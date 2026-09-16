#!/usr/bin/env python3
"""Fail closed unless every requested Lean axiom report uses standard foundations."""
import pathlib
import re
import sys

root = pathlib.Path(__file__).resolve().parent.parent
audit_source = (root / "Checks/Audit.lean").read_text()
expected = re.findall(r"^#print axioms (\S+)$", audit_source, re.MULTILINE)
output = pathlib.Path(sys.argv[1]).read_text()
allowed = {"propext", "Classical.choice", "Quot.sound"}
for name in expected:
    pattern = re.escape("'" + name + "'") + r" (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)"
    match = re.search(pattern, output)
    if not match:
        sys.exit(f"Missing axiom report: {name}")
    axioms = {a.strip() for a in (match.group(1) or "").split(",") if a.strip()}
    if axioms - allowed:
        sys.exit(f"Unapproved axioms in {name}: {sorted(axioms - allowed)}")
print(f"PASS: {len(expected)} transitive axiom reports use only {sorted(allowed)}")
