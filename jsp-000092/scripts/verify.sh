#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
. scripts/env.sh

jsp_build_log=docs/evidence/build.txt
case "${1-}" in
  "") ;;
  --clean) rm -rf .lake/build; jsp_build_log=docs/evidence/build-clean.txt ;;
  *) echo "Usage: sh scripts/verify.sh [--clean]" >&2; exit 2 ;;
esac

mkdir -p docs/evidence
if ! python3 scripts/check-lock.py > docs/evidence/dependency-lock.txt 2>&1; then
  cat docs/evidence/dependency-lock.txt
  exit 1
fi
git -C .lake/packages/mathlib rev-parse HEAD > docs/evidence/mathlib-revision.txt
git -C .lake/packages/formal_conjectures rev-parse HEAD > docs/evidence/formal-conjectures-revision.txt
test "$(cat docs/evidence/mathlib-revision.txt)" = 0df444a360eaa60ab8c11dca51a86af692955474
test "$(cat docs/evidence/formal-conjectures-revision.txt)" = 40e7c98697de6f66b8cbdbf641749ab39ed9c152
test "$(cat lean-toolchain)" = leanprover/lean4:v4.33.1
lean --version > docs/evidence/lean-version.txt
lake --version > docs/evidence/lake-version.txt

if ! lake --wfail build JSP092 > "$jsp_build_log" 2>&1; then
  cat "$jsp_build_log"
  exit 1
fi
cat "$jsp_build_log"

if ! lake env lean -DwarningAsError=true Checks/Audit.lean > docs/evidence/axioms.txt 2>&1; then
  cat docs/evidence/axioms.txt
  exit 1
fi
python3 scripts/check-audit.py docs/evidence/axioms.txt

if ! lake env lean -DautoImplicit=false -DrelaxedAutoImplicit=false -DwarningAsError=true Checks/FiniteEdgeCases.lean > docs/evidence/finite-edge-cases.txt 2>&1; then
  cat docs/evidence/finite-edge-cases.txt
  exit 1
fi

# Admissions and compiler-trusted shortcuts are prohibited in accepted sources.
python3 - <<'PY'
from pathlib import Path
import re
sources = [Path('JSP092.lean'), *Path('JSP092').rglob('*.lean'), *Path('Checks').rglob('*.lean')]
for path in sources:
    for line_no, line in enumerate(path.read_text().splitlines(), 1):
        if line.strip() == 'set_option warn.sorry true':
            continue
        if re.search(r'\b(sorry|admit|axiom|sorryAx|native_decide|unsafe|implemented_by)\b', line):
            raise SystemExit(f'Prohibited token in {path}:{line_no}: {line}')
print(f'PASS: {len(sources)} accepted Lean source files scanned')
PY
shasum -a 256 lean-toolchain lakefile.toml lake-manifest.json > docs/evidence/config-sha256.txt
echo "PASS: locked build, exact statement, transitive axioms, and finite edge cases"
