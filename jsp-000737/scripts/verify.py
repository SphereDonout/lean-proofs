#!/usr/bin/env python3
"""Run complete JSP737 acceptance and repeat from a clean project build.

Python 3.9+, standard library only. Run from any working directory. Only this
project's .lake/build is removed; shared dependencies and toolchains remain.
"""

import datetime
import hashlib
import json
from pathlib import Path
import shlex
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
EVIDENCE = ROOT / "docs/evidence"
FLAGS = ["-DautoImplicit=false", "-DrelaxedAutoImplicit=false",
         "-Dwarn.sorry=true", "-DwarningAsError=true"]


def now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source_hashes():
    files = [ROOT / name for name in (
        "JSP737.lean", "lean-toolchain", "lakefile.toml", "lake-manifest.json",
        "Checks/axiom-targets.txt")]
    for directory in ("JSP737", "Checks"):
        files.extend((ROOT / directory).rglob("*.lean"))
    files.extend((ROOT / "scripts").glob("*.py"))
    hashes = {}
    for path in sorted(set(files)):
        if path.is_symlink():
            raise RuntimeError("Accepted source may not be a symlink: " + path.relative_to(ROOT).as_posix())
        hashes[path.relative_to(ROOT).as_posix()] = digest(path)
    return hashes


def main():
    if len(sys.argv) != 1:
        raise SystemExit("Usage: python3 scripts/verify.py (always performs a clean project rebuild)")
    EVIDENCE.mkdir(parents=True, exist_ok=True)
    summary = {
        "started_utc": now(), "result": "RUNNING", "commands": [],
        "clean_project_rebuild": False,
        "retained": "Locked dependency source/build caches and selected Lean toolchain",
        "limits": "Dependency caches are retained; this is not a fresh dependency rebuild or a separate proof checker",
    }

    def save():
        (EVIDENCE / "verification-summary.json").write_text(json.dumps(summary, indent=2) + "\n")

    save()
    lake = shutil.which("lake")
    if lake is None:
        candidate = Path.home() / ".elan/bin/lake"
        if candidate.is_file():
            lake = str(candidate)

    def run(label, command):
        logfile = EVIDENCE / (label + ".txt")
        with logfile.open("w") as output:
            completed = subprocess.run(command, cwd=ROOT, stdout=output, stderr=subprocess.STDOUT)
        display = ["lake" if arg == lake else "python3" if arg == sys.executable else str(arg)
                   for arg in command]
        summary["commands"].append({
            "command": shlex.join(display), "exit_code": completed.returncode,
            "log": logfile.relative_to(ROOT).as_posix(),
        })
        save()
        print(label + ": exit " + str(completed.returncode), flush=True)
        if completed.returncode:
            print(logfile.read_text(), file=sys.stderr)
            raise RuntimeError(label + " failed with exit " + str(completed.returncode))
        return logfile.read_text()

    try:
        if lake is None:
            raise RuntimeError("Install Elan and make lake available on PATH")
        for name in ("Statement", "Axioms", "Boundaries"):
            if not (ROOT / "Checks" / (name + ".lean")).is_file():
                raise RuntimeError("Required acceptance module is missing: Checks/" + name + ".lean")
        run("dependency-integrity", [sys.executable, "scripts/check_dependencies.py"])
        lean_version = run("lean-version", [lake, "env", "lean", "--version"])
        lake_version = run("lake-version", [lake, "--version"])
        if "version 4.33.1" not in lean_version or "Lean version 4.33.1" not in lake_version:
            raise RuntimeError("Actual compiler/build-tool version differs from Lean 4.33.1")
        before = source_hashes()
        (EVIDENCE / "source-hashes.json").write_text(json.dumps(before, indent=2) + "\n")
        # Explicit module targets also cover any accepted leaf not yet imported by the root.
        targets = ["JSP737", "Checks"]
        for directory in ("JSP737", "Checks"):
            targets.extend(path.relative_to(ROOT).with_suffix("").as_posix().replace("/", ".")
                           for path in sorted((ROOT / directory).rglob("*.lean")))

        def acceptance(prefix):
            run(prefix + "build", [lake, "--wfail", "build", *targets])
            for name, label in (("Statement", "statement-check"), ("Boundaries", "boundary-check")):
                run(prefix + label, [lake, "env", "lean", *FLAGS, "Checks/" + name + ".lean"])
            if (ROOT / "Checks/Exports.lean").is_file():
                run(prefix + "exported-types", [lake, "env", "lean", *FLAGS, "Checks/Exports.lean"])
            run(prefix + "axioms", [lake, "env", "lean", *FLAGS, "Checks/Axioms.lean"])
            run(prefix + "axiom-policy", [sys.executable, "scripts/check_axioms.py",
                "--expected", "Checks/axiom-targets.txt", "--log", "docs/evidence/" + prefix + "axioms.txt"])

        acceptance("initial-")
        build = ROOT / ".lake/build"
        if (ROOT / ".lake").is_symlink() or build.is_symlink():
            raise RuntimeError("Refusing to delete a symlinked project build directory")
        if build.exists():
            shutil.rmtree(build)
        summary["clean_project_rebuild"] = True
        save()
        acceptance("")
        run("dependency-integrity-after", [sys.executable, "scripts/check_dependencies.py"])
        if source_hashes() != before:
            raise RuntimeError("Accepted source or configuration changed during verification; rerun")
        summary["source_inventory_sha256"] = digest(EVIDENCE / "source-hashes.json")
        summary["finished_utc"] = now()
        summary["result"] = "PASS"
        save()
        print("PASS: pinned sources, library/check builds, statement, boundaries, axioms, and clean project rebuild", flush=True)
    except BaseException as error:
        summary["finished_utc"] = now()
        summary["result"] = "FAIL"
        summary["error"] = str(error)
        save()
        raise


if __name__ == "__main__":
    main()
