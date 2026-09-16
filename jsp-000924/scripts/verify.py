#!/usr/bin/env python3
"""Rebuild and audit the locked JSP924 library, preserving actual command exits."""

import argparse
import datetime
import hashlib
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOOLCHAIN = "leanprover/lean4:v4.33.1"
MATHLIB = "0df444a360eaa60ab8c11dca51a86af692955474"
FLAGS = ["-DautoImplicit=false", "-DrelaxedAutoImplicit=false",
         "-Dwarn.sorry=true", "-DwarningAsError=true"]


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def public_text(text):
    """Keep local filesystem locations out of publishable diagnostics."""
    text = text.replace(str(ROOT), ".")
    home = str(Path.home())
    if home != "/":
        text = text.replace(home, "<home>")
    text = re.sub(r"/(?:Users|home)/[^/\s]+", "<home>", text)
    text = re.sub(r"(?:/private)?/(?:tmp|var/folders)/[^\s]+", "<temporary-path>", text)
    return text


def source_identity():
    paths = [ROOT / "lean-toolchain", ROOT / "lakefile.toml",
             ROOT / "lake-manifest.json", ROOT / "JSP924.lean",
             ROOT / "Checks/axiom-targets.txt", ROOT / "docs/statement-contract.md",
             ROOT / "docs/semantic-review.md"]
    for directory, pattern in [("JSP924", "*.lean"), ("Checks", "*.lean"),
                               ("scripts", "*.py"), ("scripts", "*.sh")]:
        paths.extend((ROOT / directory).rglob(pattern))
    return {str(p.relative_to(ROOT)): sha256(p) for p in sorted(set(paths))}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--clean", action="store_true",
                        help="Remove only this project's generated .lake/build directory")
    args = parser.parse_args()
    directory = ROOT / "docs/evidence" / ("clean" if args.clean else "normal")
    directory.mkdir(parents=True, exist_ok=True)
    result = {"verification_date_utc": datetime.datetime.now(datetime.timezone.utc).date().isoformat(),
              "working_directory": ".",
              "path_convention": "Metadata paths are project-relative; local filesystem prefixes in diagnostics are normalized.", "clean_project_build": args.clean,
              "retained_caches": "Installed Lean toolchain and pinned upstream dependency builds",
              "commands": [], "passed": False}

    def run(label, argv, cwd=ROOT):
        completed = subprocess.run(argv, cwd=cwd, text=True, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT)
        log = directory / (label + ".txt")
        output = public_text(completed.stdout)
        log.write_text(output)
        result["commands"].append({"label": label, "argv": argv,
                                   "cwd": str(cwd.relative_to(ROOT)), "exit_code": completed.returncode,
                                   "log": str(log.relative_to(ROOT)),
                                   "log_sha256": sha256(log),
                                   "local_paths_normalized": output != completed.stdout})
        if completed.returncode:
            raise RuntimeError(f"{label} exited {completed.returncode}; see {log.relative_to(ROOT)}")
        return output.strip()

    try:
        before = source_identity()
        result["source_sha256"] = before
        if (ROOT / "lean-toolchain").read_text().strip() != TOOLCHAIN:
            raise RuntimeError("Unexpected Lean toolchain pin")
        manifest = json.loads((ROOT / "lake-manifest.json").read_text())
        revisions = {p["name"]: p["rev"] for p in manifest["packages"]}
        if revisions.get("mathlib") != MATHLIB or "formal_conjectures" in revisions:
            raise RuntimeError("Unexpected mathematical dependency closure")
        dependencies = []
        for package in manifest["packages"]:
            if package["type"] != "git":
                raise RuntimeError("A non-Git dependency needs a separately reviewed identity check")
            checkout = ROOT / manifest["packagesDir"] / package["name"]
            actual = run("dependency-" + package["name"] + "-head",
                         ["git", "rev-parse", "HEAD"], checkout)
            status = run("dependency-" + package["name"] + "-status",
                         ["git", "status", "--porcelain", "--untracked-files=all"], checkout)
            if actual != package["rev"] or status:
                raise RuntimeError(f"Dependency pin or source-integrity failure: {package['name']}")
            dependencies.append({"name": package["name"], "revision": actual,
                                 "tracked_and_untracked_sources_clean": True})
        upstream = json.loads((ROOT / manifest["packagesDir"] / "mathlib/lake-manifest.json").read_text())
        if {p["name"]: p["rev"] for p in upstream["packages"]} != {
                name: rev for name, rev in revisions.items() if name != "mathlib"}:
            raise RuntimeError("Transitive dependency revisions differ from Mathlib's locked closure")
        result["dependencies"] = dependencies
        result["lean_version"] = run("lean-version", ["lake", "env", "lean", "--version"])
        result["lake_version"] = run("lake-version", ["lake", "--version"])
        if "version 4.33.1," not in result["lean_version"]:
            raise RuntimeError("Actual compiler does not match the pinned version")

        if args.clean:
            build = ROOT / ".lake/build"
            if build.is_symlink() or build.resolve() != ROOT / ".lake/build":
                raise RuntimeError("Refusing to clean an unexpected build-directory target")
            if build.exists():
                shutil.rmtree(build)
        run("build", ["lake", "--wfail", "build", "JSP924", "JSP924.EnvironmentCheck", "Checks"])
        for label, source in [("statement", "Checks/Statement.lean"),
                              ("boundaries", "Checks/BoundaryCases.lean"),
                              ("axioms", "Checks/Axioms.lean")]:
            run(label, ["lake", "env", "lean", *FLAGS, source])
        run("axiom-policy", ["python3", "scripts/check_axioms.py",
                             "--expected", "Checks/axiom-targets.txt",
                             "--log", str((directory / "axioms.txt").relative_to(ROOT))])

        # Supplemental source scan; the transitive axiom inventory is the primary trust check.
        banned = re.compile(r"\b(sorry|admit|axiom|sorryAx|native_decide|unsafe|implemented_by)\b")
        source_files = [ROOT / name for name in before if name.endswith(".lean")]
        for source in source_files:
            for number, line in enumerate(source.read_text().splitlines(), 1):
                if line.strip() == "set_option warn.sorry true":
                    continue
                if banned.search(line):
                    raise RuntimeError(f"Review prohibited token at {source.relative_to(ROOT)}:{number}")
        result["accepted_lean_file_count"] = len(source_files)
        inventory = (ROOT / "Checks/axiom-targets.txt").read_text().splitlines()
        result["axiom_inventory_count"] = len([n for n in inventory if n.strip()])
        if before != source_identity():
            raise RuntimeError("Accepted sources changed during verification")
        result["passed"] = True
        print(f"PASS: {len(source_files)} Lean files; {result['axiom_inventory_count']} axiom reports; "
              f"{len(dependencies)} locked clean dependencies; "
              f"{'clean project rebuild' if args.clean else 'project build'}.")
    except (OSError, ValueError, KeyError, RuntimeError) as error:
        result["error"] = public_text(str(error))
        print("FAIL: " + result["error"], file=sys.stderr)
    finally:
        result["verification_finished"] = True
        (directory / "verification.json").write_text(json.dumps(result, indent=2) + "\n")
    return 0 if result["passed"] else 1


if __name__ == "__main__":
    sys.exit(main())
