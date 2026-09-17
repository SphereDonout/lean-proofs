#!/usr/bin/env python3
"""Check raw Lean axiom reports against a nonempty declaration inventory.

The caller must first run Lean successfully and supply fresh, unedited output.
This checks coverage and standard foundations, not proof or log authenticity.
Uses only Python's standard library.
"""

import argparse
import re
import sys
from pathlib import Path

ALLOWED = frozenset({"propext", "Classical.choice", "Quot.sound"})
REPORT = re.compile(
    r"^\s*'([^\n]+)'\s+(?:depends on axioms:\s*\[([^\]]*)\]"
    r"|does not depend on any axioms)[ \t]*$",
    re.MULTILINE,
)


def audit(expected_text: str, log_text: str) -> list[str]:
    expected = [line.strip() for line in expected_text.splitlines()
                if line.strip() and not line.lstrip().startswith("#")]
    if not expected:
        raise ValueError("Expected theorem inventory is empty")
    if len(set(expected)) != len(expected):
        raise ValueError("Expected theorem inventory contains duplicates")
    if any(any(c.isspace() for c in name) for name in expected):
        raise ValueError("Use one fully qualified declaration name per line")
    reports: dict[str, set[str]] = {}
    for match in REPORT.finditer(log_text):
        name, body = match.groups()
        if name in reports:
            raise ValueError(f"Duplicate axiom report: {name}")
        reports[name] = {item.strip() for item in (body or "").split(",")
                         if item.strip()}
    missing = set(expected) - reports.keys()
    unexpected = reports.keys() - set(expected)
    if missing:
        raise ValueError(f"Missing or unrecognized axiom reports: {sorted(missing)}")
    if unexpected:
        raise ValueError(f"Uninventoried axiom reports: {sorted(unexpected)}")
    for name in expected:
        rejected = reports[name] - ALLOWED
        if rejected:
            raise ValueError(f"Unapproved axioms for {name}: {sorted(rejected)}")
    return [f"PASS: {name}: {sorted(reports[name])}" for name in expected]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--expected", type=Path, required=True,
                        help="One fully qualified declaration per line")
    parser.add_argument("--log", type=Path, required=True,
                        help="Raw output from a successful Lean audit command")
    args = parser.parse_args()
    try:
        messages = audit(args.expected.read_text(encoding="utf-8"),
                         args.log.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, ValueError) as error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 1
    for message in messages:
        print(message)
    print(f"PASS: {len(messages)} complete reports use only accepted foundations")
    return 0


if __name__ == "__main__":
    sys.exit(main())
