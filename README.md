# Lean proofs

Reproducible Lean projects, each with its own toolchain and dependency lockfile.

| Project | Result | Verification |
| --- | --- | --- |
| [jsp-000092](jsp-000092/) | The near-linear Erdős 75 / JSP-000092 theorem | [Build instructions](jsp-000092/README.md), [verification report](jsp-000092/docs/final-verification.md) |
| [jsp-000924](jsp-000924/) | The known Izotov fourth-power Sierpiński construction | [Build instructions](jsp-000924/README.md), [verification report](jsp-000924/docs/final-verification.md) |
| [jsp-000737](jsp-000737/) | The known Erdős–Rosenfeld general-C fourth-root divisor bound (partial result for Erdős 886) | [Build instructions](jsp-000737/README.md), [verification report](jsp-000737/docs/verification-report.md) |
| [jsp-000233](jsp-000233/) | Szabó's AP-intersection construction and lower bound (partial result for JSP-000233) | [Build instructions](jsp-000233/README.md), [verification report](jsp-000233/docs/verification-report.md) |

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

## Verify JSP-000737

With Elan, Git and Python 3.9 or later installed:

```sh
cd lean-proofs/jsp-000737
elan toolchain install leanprover/lean4:v4.33.1
lake exe cache get
python3 scripts/verify.py
```

The project supplies all proof and check modules, a complete dependency lock, and verification scripts. The result is the known bound of 1+C² divisors in the closed interval from √n to √n+C n^(1/4). The full JSP-000737 / Erdős 886 question remains open; see the [scope comparison](jsp-000737/docs/scope-audit.md).

## Verify JSP-000233

With Elan, Git, and Python 3 installed:

```sh
cd lean-proofs/jsp-000233
lake exe cache get
sh scripts/verify.sh fresh
```

This proof constructs Szabó's family of size `choose(N,2) + 1 + floor((N-1)/4)` for every `N ≥ 1`. It proves a known lower bound; the exact maximum asked by JSP-000233 remains open. See the [statement contract](jsp-000233/docs/statement-contract.md) for the precise scope.
