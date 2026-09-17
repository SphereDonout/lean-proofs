#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$project_root"

run_name=${1:-current}
case "$run_name" in
  *[!A-Za-z0-9_-]* | '')
    printf '%s\n' 'Use an alphanumeric run name (hyphen and underscore allowed).' >&2
    exit 2
    ;;
esac

mkdir -p docs/evidence
lean --version > "docs/evidence/$run_name-versions.txt"
lake --version >> "docs/evidence/$run_name-versions.txt"
python3 scripts/check_pins.py > "docs/evidence/$run_name-pins.txt"
lake --wfail build JSP233 Checks > "docs/evidence/$run_name-build.txt" 2>&1
lake env lean -DautoImplicit=false -DrelaxedAutoImplicit=false \
  -DwarningAsError=true Checks/Statement.lean \
  > "docs/evidence/$run_name-statement.txt" 2>&1
lake env lean -DautoImplicit=false -DrelaxedAutoImplicit=false \
  -DwarningAsError=true Checks/Boundaries.lean \
  > "docs/evidence/$run_name-boundaries.txt" 2>&1
lake env lean -DautoImplicit=false -DrelaxedAutoImplicit=false \
  -DwarningAsError=true Checks/Semantics.lean \
  > "docs/evidence/$run_name-semantics.txt" 2>&1
lake env lean -DautoImplicit=false -DrelaxedAutoImplicit=false \
  -DwarningAsError=true Checks/Axioms.lean \
  > "docs/evidence/$run_name-axioms.txt" 2>&1
python3 scripts/check_axioms.py --expected Checks/axiom-targets.txt \
  --log "docs/evidence/$run_name-axioms.txt" \
  > "docs/evidence/$run_name-axiom-audit.txt"
printf 'Verification passed: %s\n' "$run_name"
