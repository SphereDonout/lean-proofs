#!/usr/bin/env python3
"""Audit JSP737's frozen configuration and pinned dependency source trees.

Python 3.9+, standard library only. Cached dependency oleans are retained and
matched to tracked source module names; their contents are not rebuilt here.
"""

import hashlib
import json
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent.parent
TOOLCHAIN = "leanprover/lean4:v4.33.1"
MATHLIB_REV = "0df444a360eaa60ab8c11dca51a86af692955474"
CONFIG_SHA256 = "61a2a75bfa44104931a4568b801cd9627424a58f33a1fb342d9ee3610bca3f1e"
OVERRIDE_VARS = ("LEAN_PATH", "LEAN_SRC_PATH", "LEAN_SYSROOT", "LEAN_GITHASH",
                 "LAKE_HOME", "LAKE_CONFIG", "ELAN_TOOLCHAIN")


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def git(path, *args):
    return subprocess.check_output(["git", "-C", str(path), *args])


def relevant(path):
    return path.endswith(".lean") or Path(path).name in {
        "lakefile.toml", "lake-manifest.json", "lean-toolchain"}


def check_configuration():
    overrides = [name for name in OVERRIDE_VARS if name in os.environ]
    if overrides:
        raise RuntimeError("Remove import/toolchain environment overrides: " + ", ".join(overrides))
    if (ROOT / "lean-toolchain").read_text().strip() != TOOLCHAIN:
        raise RuntimeError("Unreviewed Lean toolchain")
    if sha256((ROOT / "lakefile.toml").read_bytes()) != CONFIG_SHA256:
        raise RuntimeError("Lake configuration changed; review it before updating CONFIG_SHA256")
    if (ROOT / "lakefile.lean").exists() or (ROOT / "lakefile.lean").is_symlink():
        raise RuntimeError("An alternate lakefile.lean would override the reviewed TOML configuration")
    if (ROOT / ".lake").is_symlink():
        raise RuntimeError("Project .lake must be local; only .lake/packages may be shared")
    manifest = json.loads((ROOT / "lake-manifest.json").read_text())
    if manifest.get("packagesDir") != ".lake/packages" or manifest.get("lakeDir") != ".lake":
        raise RuntimeError("Unexpected package/build directory configuration")
    packages = manifest["packages"]
    names = [item["name"] for item in packages]
    if len(names) != len(set(names)):
        raise RuntimeError("Duplicate package names in dependency lock")
    mathlib = [item for item in packages if item["name"] == "mathlib"]
    if len(mathlib) != 1 or mathlib[0]["rev"] != MATHLIB_REV:
        raise RuntimeError("Mathlib lock does not match the reviewed full revision")
    if mathlib[0]["url"] != "https://github.com/leanprover-community/mathlib4":
        raise RuntimeError("Mathlib origin differs from the reviewed repository")
    return manifest


def check_package(manifest, item):
    name = item["name"]
    if item["type"] != "git" or item.get("subDir"):
        raise RuntimeError("Unreviewed dependency type/subdirectory: " + name)
    if Path(name).name != name or name in {".", ".."}:
        raise RuntimeError("Unsafe package name")
    path = ROOT / manifest["packagesDir"] / name
    head = git(path, "rev-parse", "HEAD").decode().strip()
    if head != item["rev"]:
        raise RuntimeError("Dependency revision drift: " + name)
    origin = git(path, "remote", "get-url", "origin").decode().strip()
    if origin != item["url"]:
        raise RuntimeError("Dependency origin drift: " + name)
    status = git(path, "status", "--porcelain=v1", "--untracked-files=all").decode()
    if status:
        raise RuntimeError("Dirty dependency " + name + ": " + status)
    tracked = {}
    for row in git(path, "ls-tree", "-r", "-z", "HEAD").split(b"\0"):
        if row:
            metadata, relative = row.split(b"\t", 1)
            mode, kind, blob = metadata.split()
            tracked[relative.decode()] = (mode.decode(), kind.decode(), blob.decode())
    sources = {}
    for relative, (mode, kind, expected) in tracked.items():
        if not relevant(relative):
            continue
        source = path / relative
        if kind != "blob" or mode not in {"100644", "100755"} or source.is_symlink():
            raise RuntimeError("Unreviewed dependency source mode: " + name + "/" + relative)
        data = source.read_bytes()
        blob = hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()
        if blob != expected:
            raise RuntimeError("Dependency source bytes differ from HEAD: " + name + "/" + relative)
        sources[relative] = sha256(data)
    # Also inspect ignored files: git status alone does not detect ignored overrides.
    for directory, dirs, files in os.walk(path):
        dirs[:] = [entry for entry in dirs if entry not in {".git", ".lake"}]
        for entry in dirs:
            if (Path(directory) / entry).is_symlink():
                raise RuntimeError("Unreviewed dependency source directory symlink: " + name + "/" + entry)
        for filename in files:
            relative = (Path(directory) / filename).relative_to(path).as_posix()
            if relevant(relative) and relative not in tracked:
                raise RuntimeError("Extra dependency source/configuration: " + name + "/" + relative)
    cache = path / ".lake/build/lib/lean"
    cache_count = 0
    for compiled in cache.rglob("*.olean"):
        relative = compiled.relative_to(cache).with_suffix(".lean").as_posix()
        if relative not in sources:
            raise RuntimeError("Cached import has no pinned source: " + name + "/" + relative)
        if relative in {"JSP737.lean", "Checks.lean"} or relative.startswith(("JSP737/", "Checks/")):
            raise RuntimeError("Dependency cache shadows project imports: " + name + "/" + relative)
        cache_count += 1
    return {
        "name": name, "revision": head, "origin": origin, "status": "clean",
        "git_tree": git(path, "rev-parse", "HEAD^{tree}").decode().strip(),
        "source_files_rehashed": len(sources),
        "source_inventory_sha256": sha256(json.dumps(sources, sort_keys=True).encode()),
        "cached_modules_with_tracked_sources": cache_count,
    }


def main():
    manifest = check_configuration()
    reports = [check_package(manifest, item) for item in manifest["packages"]]
    print(json.dumps({
        "toolchain": TOOLCHAIN, "mathlib_revision": MATHLIB_REV,
        "lakefile_sha256": CONFIG_SHA256,
        "manifest_sha256": sha256((ROOT / "lake-manifest.json").read_bytes()),
        "dependencies": reports,
        "total_sources_rehashed": sum(item["source_files_rehashed"] for item in reports),
        "cache_scope": "Retained dependency oleans matched to tracked source names; contents not rebuilt",
    }, indent=2))


if __name__ == "__main__":
    main()
