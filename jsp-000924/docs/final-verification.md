# Final verification report

Publication verification completed on **2026-09-16 (UTC)** in a fresh, portable source copy. This folder contains the proof sources, pinned dependency manifest, independent statement checks, verifier and setup instructions needed to reproduce the result. Lean and the upstream dependencies must be installed or downloaded separately.

## Result verified

For every `t n : ℕ`, the number

```text
(734110615000775 + 36893488147419103230*t)^4 * 2^n + 1
```

has a natural divisor strictly between 1 and itself. The corollaries prove that the constructed fourth powers are positive odd Sierpiński numbers and form an infinite set.

The formalization follows the known Izotov construction described in the [source paper](https://people.math.sc.edu/filaseta/papers/SierpinskiEtCoPapNew.pdf#page=6). Its parameterized family includes `n = 0`; the Sierpiński predicate uses positive exponents. It does not establish absence of a finite prime cover, least-root optimality, or a new solution to the broader open question. The public interface does not include a separate adapter accepting the paper's literal congruence hypothesis.

## Commands and evidence

All commands were run from this project directory.

| Command | Result | Evidence |
| --- | --- | --- |
| `sh scripts/bootstrap.sh` | Exit 0; pinned environment ready | [Setup outcome and publication checks](evidence/publication-checks.json) |
| `sh scripts/verify.sh` | Exit 0 | [Normal verification record](evidence/normal/verification.json) |
| `sh scripts/verify.sh --clean` | Exit 0 | [Clean verification record](evidence/clean/verification.json) |

Each verification run completed 25 recorded subprocess commands with exit status 0. Both runs accepted **15 Lean source files**, validated **32 named transitive axiom reports**, and checked **9 clean dependency checkouts** against the committed revisions and Mathlib's transitive lockfile. Every recorded command log has a matching SHA-256 digest.

The build treats warnings as failures. Direct statement, boundary and axiom checks disable implicit declarations and reject unfinished proofs. The transitive axiom inventory permits only `propext`, `Classical.choice` and `Quot.sound`. A supplementary source scan rejects proof placeholders, custom axioms and computational trust bypasses.

The clean run removed this project's generated `.lake/build` before rebuilding the full library and check modules. No proof source was changed for publication: all 15 Lean files are byte-for-byte identical to the previously verified local project. The [separate AI semantic review](semantic-review.md) documents the mathematical correspondence and expanded statement checks.

## Source identity

Both records contain the same SHA-256 map for 26 inputs: proof/check sources, dependency configuration, statement contract, semantic review, theorem inventory and scripts. All hashes were checked against the publication files after both runs.

The SHA-256 of that map, encoded as UTF-8 JSON with sorted keys, comma/colon separators and no whitespace or trailing newline, is:

```text
b07d91e421cbe535eb75aa02447ab1123548cf1cedc73ff5fcc75b2a501c763c
```

## Reproduction limits and privacy

The recorded environment was arm64 macOS, Lean 4.33.1 and the exact revisions in [the environment record](environment.md). Matching installed toolchain and upstream caches were reused in separate ignored directories. First-time downloads on a new machine, other operating systems, a full upstream source rebuild and an independently implemented kernel replay were not tested. A human referee review or award decision is not claimed.

The published bundle omits local tools, caches, development history and old development logs. Verification metadata uses relative paths and a UTC date. The verifier normalizes local filesystem prefixes in diagnostic logs and records whether each output changed; **none of the successful outputs required normalization in these two runs**. The named axiom reports and exit statuses are preserved.

To reproduce, follow the [README setup instructions](../README.md) and run `sh scripts/verify.sh --clean`.
