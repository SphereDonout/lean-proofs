# JSP-000092: a Lean 4 proof of the near-linear theorem

This standalone project formalizes the affirmative near-linear proposition in [Erdős problem 75 at the pinned Formal Conjectures revision](https://github.com/google-deepmind/formal-conjectures/blob/40e7c98697de6f66b8cbdbf641749ab39ed9c152/FormalConjectures/ErdosProblems/75.lean), corresponding to JSP-000092.

The theorem constructs a graph with vertex cardinality and chromatic cardinality both **aleph-one**. For every real `ε > 0`, all sufficiently large finite `n`-vertex subgraphs contain an independent set, independent in the ambient graph, of size strictly greater than `n^(1-ε)`.

The exported theorem is `JSP092.erdos75_near_linear` in `JSP092/Main.lean`. The complete library passes a clean build with warnings treated as failures. Transitive axiom checks report only `propext`, `Classical.choice`, and `Quot.sound`. See the [final verification report](docs/final-verification.md), [task ledger](docs/progress.json), and [independent reviews](docs/reviews/).

The semantic reviews were performed by separate AI agents during development.
They are internal reviews, separate from external human or prize-committee review.

The fixed-linear bound `c * n` is outside this theorem. This work formalizes existing public mathematics and makes no discovery-priority or prize-eligibility claim. See [the mathematical statement and attribution](docs/statement-contract.md).

## Use the installed stack

Run commands from this project directory:

```sh
. scripts/env.sh
lean --version
lake --wfail build JSP092
sh scripts/verify.sh --clean
```

The environment script selects the project-local installation in `.tools/elan` for the current shell. It does not modify your shell configuration or system Lean installation. `verify.sh --clean` is the final verification entry point; it rebuilds project outputs and runs the tracked audit.

## Set up another Apple Silicon Mac

The bootstrap script currently supports **arm64 macOS only**. It requires usable Git, `curl`, `tar`, and `shasum`, plus network access to the upstream download and cache services. Verification additionally requires Python 3 (standard library only).

```sh
sh scripts/bootstrap.sh
. scripts/env.sh
sh scripts/verify.sh --clean
```

Bootstrap installs pinned Elan and Lean locally, verifies the Elan archive SHA-256, obtains dependency caches, and builds the coloring support module. Existing matching installations and cached downloads are reused. Keep `lake-manifest.json`; bootstrap uses its resolved revisions and never runs `lake update` by default.

## Other platforms with Elan already installed

The Lean source and Lake project do not depend on the macOS bootstrap script.
With Elan, Git, and Python 3 already available, run these commands inside
`jsp-000092` using the existing Elan installation:

```sh
elan toolchain install leanprover/lean4:v4.33.1
lake exe cache get
python3 scripts/check-lock.py
lake --wfail build JSP092
lake env lean -DwarningAsError=true Checks/Audit.lean > audit-output.txt
python3 scripts/check-audit.py audit-output.txt
lake env lean -DautoImplicit=false -DrelaxedAutoImplicit=false -DwarningAsError=true Checks/FiniteEdgeCases.lean
```

These are the underlying proof checks used by the verification script. The
recorded verification runs were on arm64 macOS; other platforms have not been
tested in this project. The development prompt pack and scratch files are not
needed for any of these checks.

## Dependency pins

| Component | Version or revision |
| --- | --- |
| Elan installer | `4.2.4` |
| Lean | `leanprover/lean4:v4.33.1` |
| Mathlib | `0df444a360eaa60ab8c11dca51a86af692955474` |
| Formal Conjectures | `40e7c98697de6f66b8cbdbf641749ab39ed9c152` |

All transitive package revisions are recorded in the preserved `lake-manifest.json`. [Environment details](docs/environment.md) include the installer checksum, installation layout, and recovery guidance.

## Proof structure

1. Define increasing triples and the exact six-coordinate interleaving graph.
2. Color triples on `Fin (2^k)` with `Fin k × Bool`, then rank finite coordinate supports and select a large independent color fiber.
3. Use the countable ordinals to prove that every natural-number coloring has a monochromatic edge, and derive both aleph-one cardinality equalities.
4. Prove that logarithmic palette size is eventually smaller than every positive real power.
5. Assemble the exact graph-existence proposition, including the finite-subgraph adapter.

[The API inventory](docs/api-inventory.md) lists the main module interfaces. The project imports the Formal Conjectures coloring support definition, not the admitted Erdős 75 conjecture.
