# Lean proofs

Reproducible Lean projects, each with its own toolchain and dependency lockfile.

| Project | Result | Verification |
| --- | --- | --- |
| [jsp-000092](jsp-000092/) | The near-linear Erdős 75 / JSP-000092 theorem | [Build instructions](jsp-000092/README.md), [verification report](jsp-000092/docs/final-verification.md) |
| [jsp-000924](jsp-000924/) | The known Izotov fourth-power Sierpiński construction | [Build instructions](jsp-000924/README.md), [verification report](jsp-000924/docs/final-verification.md) |

## Verify JSP-000092

On an Apple Silicon Mac with Git, Python 3, and the standard command-line tools:

```sh
git clone https://github.com/SphereDonout/lean-proofs.git
cd lean-proofs/jsp-000092
sh scripts/bootstrap.sh
sh scripts/verify.sh --clean
```

The project supplies all Lean source files, pinned dependency revisions, and
reproducible checks. Bootstrap downloads the toolchain and dependencies; it
currently supports arm64 macOS. See the project README for verification using
an existing Lean/Elan installation on other platforms.

The mathematical sources are credited in each project. The recorded semantic
reviews for JSP-000092 were internal reviews by separate AI agents during
development; they are distinct from external human or prize-committee review.

## Verify JSP-000924

```sh
cd lean-proofs/jsp-000924
sh scripts/bootstrap.sh
sh scripts/verify.sh --clean
```

This folder supplies its own proof sources, pinned dependencies and checks. Its local bootstrap currently supports arm64 macOS; the project README also documents use with an existing Elan installation. The result formalizes the known fourth-power family and makes no claim about absence of a finite prime cover.
