# Final verification: JSP-000092 near-linear theorem

**Result: PASS — all implementation cards through V01 are complete.**

Verified locally on 16 September 2026 in the standalone `jsp092` Lake project,
on branch `codex/jsp-000092`. The project exposes
`JSP092.erdos75_near_linear` through `import JSP092`.

## Exact mathematical result

There is a graph with both vertex cardinality and chromatic cardinality
aleph-one. For every positive real epsilon, there is a threshold uniform over
all finite subgraphs of each size `n` beyond that threshold, admitting an
ambient-graph independent subset of cardinality strictly greater than
`n^(1-epsilon)`.

`Checks/Audit.lean` transcribes the affirmative right-hand proposition from the
[pinned upstream statement](https://github.com/google-deepmind/formal-conjectures/blob/40e7c98697de6f66b8cbdbf641749ab39ed9c152/FormalConjectures/ErdosProblems/75.lean)
and proves it using the exported theorem. The same check verifies that
`Erdos75.erdos_75` is absent from the import environment. The upstream
coloring support module supplies only the required `chromaticCardinal`
definition and its ordinary dependencies.

The stronger fixed-linear question is outside this result. Mathematical
attribution and the statement contract are in [statement-contract.md](statement-contract.md).

## Commands and recorded evidence

Run from the project directory:

```sh
sh scripts/verify.sh --clean
```

This command completed with exit **0**. It performs the following checks:

| Check | Result | Evidence |
| --- | --- | --- |
| All 10 dependency checkouts match the preserved lockfile; tracked dependency sources unmodified | PASS | [dependency-lock.txt](evidence/dependency-lock.txt) |
| Lean 4.33.1 and its Lake toolchain | PASS | [Lean](evidence/lean-version.txt), [Lake](evidence/lake-version.txt) |
| Complete library, after deleting this project's `.lake/build`, with `lake --wfail build JSP092` | Exit 0; 3059 jobs | [build-clean.txt](evidence/build-clean.txt) |
| Exact upstream affirmative proposition; 25 transitive axiom reports | Exit 0 | [axioms.txt](evidence/axioms.txt) |
| Finite boundary cases and generic integral interface, explicit variables, warnings as errors | Exit 0 | [finite-edge-cases.txt](evidence/finite-edge-cases.txt) |
| All 21 accepted Lean source files checked for admissions and prohibited shortcuts | PASS | Enforced by `scripts/verify.sh` |
| Fixed environment input hashes | Recorded | [config-sha256.txt](evidence/config-sha256.txt) |

The clean build rebuilt all 19 project library modules, including the umbrella
module and final theorem. It retained the installed toolchain and upstream
dependency build caches. It was **not** a from-source recompilation of Lean,
Mathlib, and every dependency. The stack was downloaded separately: Elan 4.2.4,
Lean 4.33.1, locked dependencies, and 8690 Mathlib cache artifacts. See
[environment.md](environment.md) for setup instructions and the bootstrap
script's testing limits.

The final theorem depends on exactly:

```text
[propext, Classical.choice, Quot.sound]
```

Every other audited declaration uses a subset of these foundations.
`scripts/check-audit.py` fails if any requested report is missing or contains
an additional axiom. No admitted mathematical assumption or compiler-trusted
proof shortcut is accepted.

## Independent semantic reviews

These were internal reviews performed by separate AI agents during development.
The reviewer of each component did not author that component. This report does
not record an external human review or an authorized prize-verification decision.

Authors and reviewers were separated by component:

- [Finite foundations](reviews/finite-foundation.md): reviewed by the analytic
  and integration author, independently of the foundation and finite authors.
- [Ordinal and recursive dyadic constructions](reviews/ordinal-and-dyadic.md):
  reviewed by the coordinator, independently of those component authors.
- [Asymptotics and final assembly](reviews/asymptotic-integration.md): reviewed
  by the ordinal author, including a separate compiled transcription of the
  upstream target.
- [Finite boundary checks](reviews/finite-author-checks.md): author checks,
  subsequently rerun as part of the combined verification command.

The reviews check the exact six-coordinate interleaving, both orientations,
overlapping countable covers, both cardinality bounds, all positive epsilon,
strict real inequalities, and the uniformity of the threshold. The final
adapter proves `n > 0` before using positive natural cardinality to obtain
finiteness of `H.verts`, and retains independence in the ambient graph.

## Recorded implementation choices

- O03 and O04 share `NestedFibers.lean`.
- O07 bounds the defining infimum directly using the nonempty set of realized
  palette cardinals, rather than first extracting a minimum palette.
- The analytic depth is exactly `Nat.log 2 (3*n) + 1`, as approved; no sharper
  ceiling expression is needed.

These choices preserve every parent theorem. There are no unresolved proof or
environment blockers. The [22-card task ledger](progress.json) records actual
outputs, exported declarations, and verification evidence.
