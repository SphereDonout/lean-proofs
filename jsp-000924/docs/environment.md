# Environment and reproduction

Lean is pinned to `leanprover/lean4:v4.33.1`. The exact compiler and Lake version outputs are stored in each verification record. All direct and transitive dependency commits are preserved in `lake-manifest.json`.

| Package | Git revision |
| --- | --- |
| mathlib | `0df444a360eaa60ab8c11dca51a86af692955474` |
| plausible | `b7eb3304aeae834b12dda98993a37f6a41f6f0bb` |
| LeanSearchClient | `5f4d51b81cbd3f6b32b156bfad9056621a040404` |
| importGraph | `16f02aa7642864af59f1ff0e384a015994db9118` |
| proofwidgets | `4be2e3d5087eeb272cf5a8853b8f9dd025ef5957` |
| aesop | `3448c0bcc5ce01b2d1546e483ec3620e32df3d0e` |
| Qq | `92c15be17b7caf78c2ad767ec40f89052d908d81` |
| batteries | `4488d40d070b9700d4d5a6aa342f0d40c31b2a2d` |
| Cli | `6130a47896ce867c6a4a55373441e59e565bad0f` |

Only Mathlib is a direct mathematical dependency. No Formal Conjectures target or admitted theorem is imported.

## Bootstrap

`sh scripts/bootstrap.sh` installs pinned Elan 4.2.4 and Lean locally on arm64 macOS. It validates the Elan installer archive SHA-256, preserves the committed manifest, fetches the locked dependency caches, and builds the environment-check module. It requires network access when downloads are absent. The installer checksum and URL are in the script.

With an existing Elan installation on another supported platform, install the pinned Lean toolchain, run `lake exe cache get`, then `sh scripts/verify.sh --clean`. `scripts/env.sh` accepts an optional `JSP924_ELAN_HOME` override, otherwise uses this project's `.tools/elan` if present, then the existing PATH. No sibling project is needed.

## Publication verification environment

A fresh source copy was prepared without local development history. Matching toolchain and dependency caches were supplied locally as separate ignored directories to avoid unnecessary downloads. They are not part of the committed folder. The bootstrap and verification runs on that copy are recorded in the final report.

The verifier checks all nine Git revisions, source cleanliness, and agreement with Mathlib's transitive manifest. It builds the full library, EnvironmentCheck and independent check modules with warnings failing, then validates the full axiom inventory.

`--clean` removes only `.lake/build`. Upstream binaries and toolchain caches are retained; they were not all rebuilt from source or checked with an independently implemented kernel. A first-time setup on a new machine was not performed during the publication check.

Metadata paths are recorded relative to the project root. Local filesystem prefixes in diagnostics are normalized before logs are written; each command records whether that normalization changed its output. The named axiom reports and command exit statuses are preserved.
