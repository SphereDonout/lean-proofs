#!/usr/bin/env python3
"""Check the complete Lake lock against the installed dependency sources."""

import hashlib
import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
manifest = json.loads((ROOT / "lake-manifest.json").read_text())
assert manifest["packages"], "empty dependency lock"

toolchain = (ROOT / "lean-toolchain").read_text().strip()
assert toolchain == "leanprover/lean4:v4.33.1", toolchain
lakefile = (ROOT / "lakefile.toml").read_text()

expected_direct = {
    "mathlib": "0df444a360eaa60ab8c11dca51a86af692955474",
    "formal_conjectures": "40e7c98697de6f66b8cbdbf641749ab39ed9c152",
}

for item in manifest["packages"]:
    if item["type"] != "git":
        raise RuntimeError(f"Unreviewed dependency type: {item['name']}: {item['type']}")
    name, revision = item["name"], item["rev"]
    checkout = ROOT / ".lake" / "packages" / name
    actual = subprocess.check_output(
        ["git", "-C", str(checkout), "rev-parse", "HEAD"], text=True
    ).strip()
    if actual != revision:
        raise RuntimeError(f"Dependency revision mismatch: {name}: {actual} != {revision}")
    changes = subprocess.check_output(
        ["git", "-C", str(checkout), "status", "--porcelain", "--untracked-files=all"],
        text=True,
    ).strip()
    if changes:
        raise RuntimeError(f"Dependency source changed: {name}:\n{changes}")
    if name in expected_direct:
        if revision != expected_direct[name] or revision not in lakefile:
            raise RuntimeError(f"Direct dependency pin mismatch: {name}")
    print(f"PIN {name} {revision} clean")

if not expected_direct.keys() <= {p["name"] for p in manifest["packages"]}:
    raise RuntimeError("Missing direct dependency in manifest")

sources = [ROOT / "lean-toolchain", ROOT / "lakefile.toml", ROOT / "lake-manifest.json"]
sources += sorted((ROOT / "JSP233").glob("*.lean"))
sources += [ROOT / "JSP233.lean"]
sources += sorted((ROOT / "Checks").glob("*.lean"))
for path in sources:
    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    print(f"SOURCE {path.relative_to(ROOT)} {digest}")
