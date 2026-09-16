#!/usr/bin/env python3
"""Check that every dependency checkout is at its preserved locked revision."""
import json
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parent.parent
manifest = json.loads((root / "lake-manifest.json").read_text())
for package in manifest["packages"]:
    checkout = root / manifest["packagesDir"] / package["name"]
    head = subprocess.check_output(["git", "-C", str(checkout), "rev-parse", "HEAD"], text=True).strip()
    if head != package["rev"]:
        sys.exit(f"Revision mismatch: {package['name']}: {head} != {package['rev']}")
    for args in (["diff", "--quiet"], ["diff", "--cached", "--quiet"]):
        if subprocess.run(["git", "-C", str(checkout), *args]).returncode:
            sys.exit(f"Modified dependency source: {package['name']}")
    print(f"PASS: {package['name']} {head}")
print(f"PASS: all {len(manifest['packages'])} dependency revisions match the lockfile")
