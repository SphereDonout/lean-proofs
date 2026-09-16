# Pinned Lean environment

## Supported bootstrap platform

`scripts/bootstrap.sh` supports Apple Silicon macOS (`uname -s = Darwin`, `uname -m = arm64`). It exits on other platforms before installing anything. A usable Git installation, `curl`, `tar`, `shasum`, and `grep` must already be available. Initial dependency setup requires network access to GitHub and the Mathlib cache service.

The current installation was checked on 2026-09-16:

```text
elan 4.2.4 (227caca13 2026-08-25)
Lean (version 4.33.1, arm64-apple-darwin24.6.0, commit 819816b2e0a3bf405af45ae5c7af2491d8f5bee6, Release)
Lake version 5.0.0-src+819816b (Lean version 4.33.1)
```

## Exact pins and locations

| Input | Pin |
| --- | --- |
| Elan | `v4.2.4` |
| Lean toolchain | `leanprover/lean4:v4.33.1` |
| Mathlib | `0df444a360eaa60ab8c11dca51a86af692955474` |
| Formal Conjectures | `40e7c98697de6f66b8cbdbf641749ab39ed9c152` |

The Elan archive is [the pinned arm64 macOS release asset](https://github.com/leanprover/elan/releases/download/v4.2.4/elan-aarch64-apple-darwin.tar.gz). Its SHA-256, checked against the downloaded archive, is:

```text
7ad829861392c718dfebde3a83b5c8508df47be02af68894b094b0b3952616e5
```

- `.tools/downloads/` holds the installer archive and extracted installer.
- `.tools/elan/` is `ELAN_HOME`, containing Elan, the Lean toolchain, and Lake.
- `.lake/packages/` holds dependency source checkouts at the lockfile revisions.
- `.lake/packages/mathlib/.lake/build/` holds the downloaded Mathlib build cache.
- `.lake/build/` holds this project's build outputs.

The tool and cache directories are generated local state. The reproducibility inputs are `lean-toolchain`, `lakefile.toml`, `lake-manifest.json`, bootstrap configuration, and the project source files.

## Installation behavior

From the project root:

```sh
sh scripts/bootstrap.sh
. scripts/env.sh
```

The bootstrap script uses `ELAN_HOME` under the project directory. Elan installation passes `--no-modify-path --default-toolchain none`. The script installs the exact toolchain only when it is absent. It reuses an existing matching Elan installation, verifies any cached installer archive, retrieves missing dependencies and cache artifacts through `lake exe cache get`, and compiles `FormalConjecturesForMathlib.Combinatorics.SimpleGraph.Coloring.Vertex` with warnings treated as failures.

The bootstrap script requires an existing `lake-manifest.json` and checks its hash before and after dependency setup. It never runs `lake update` by default. Although some transitive packages have an upstream `inputRev` such as `main`, their resolved `rev` fields in this lockfile are exact commit hashes. Retain the complete lockfile to preserve these revisions. Verification uses Python 3 (standard library only) to check every dependency checkout against these pins and validate Lean's axiom reports.

Re-running bootstrap reuses matching installations and existing downloads. The cache command may contact its service to determine whether anything is missing; it does not intentionally redownload existing artifacts. A missing lockfile, mismatched Lean pin, bad archive checksum, unsupported platform, or failed download/build stops setup with an error.

## Build and verify

```sh
. scripts/env.sh
lake --wfail build JSP092.Main
bash scripts/verify.sh --clean
```

Source `scripts/env.sh` from the project root in each new shell. Do not change dependency revisions to repair a local build error: first confirm the selected toolchain, restore the committed lockfile if necessary, and inspect the compiler's first failing dependency or declaration.

Bootstrap implementation validation comprised a shell syntax check, existing tool-version checks, and verification of the existing installer archive checksum. The bootstrap script was not tested by removing and redownloading this already installed stack. The [final verification report](final-verification.md) records the successful clean project build using the pinned dependency sources and existing upstream caches.
