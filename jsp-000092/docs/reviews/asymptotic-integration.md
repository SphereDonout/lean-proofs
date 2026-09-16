# Independent review: asymptotics and final integration

**Result: PASS. No actionable mathematical or Lean trust findings.**

Reviewed on 16 September 2026 by the agent that implemented the separate ordinal branch; this reviewer did not author the four modules reviewed here. The review covers the analytic proof and its final adapter. The finite coloring proof and the ordinal proof receive separate reviews.

## Reviewed files

- `JSP092/Asymptotic/DyadicCover.lean`
- `JSP092/Asymptotic/PowerGap.lean`
- `JSP092/NearLinearFinite.lean`
- `JSP092/Main.lean`

## Semantic checks

| Requirement | Finding | Evidence |
|---|---|---|
| Exact affirmative source proposition | PASS | `Main.lean:20` matches the entire right-hand side of the pinned source theorem. A fresh transcription with the source's `ℵ_ 1` and `#V` notation elaborates using only `JSP092.erdos75_near_linear`. |
| Vertex type lives in `Type` | PASS | `Main.lean:21`; instantiated with `Triple Omega`. |
| Both cardinal equalities | PASS | `Main.lean:22` and `Main.lean:23` retain chromatic cardinality and vertex cardinality, each aleph-one. |
| Dyadic coordinate cover | PASS | `DyadicCover.lean:24` proves `3 * n ≤ 2 ^ dyadicDepth n` for all natural `n`; there is no assumption that the chosen depth equals the ceiling logarithm. |
| Empty and boundary values | PASS | `dyadicDepth 0 = 1`, depth is always positive, and coverage holds at zero and at powers of two. The final theorem only invokes the strict-power argument for positive `n`. |
| Every positive real epsilon | PASS | `PowerGap.lean:18` requires only `0 < ε`, using logarithm versus real-power asymptotics. There is no restriction `ε < 1` and no special-case argument that would fail at `ε = 1`. |
| Strict palette inequality | PASS | `PowerGap.lean:28` uses the little-o estimate with constant `1/2` and positivity of `n ^ ε`, yielding a strict inequality rather than a weak one. |
| Strict independent-set bound | PASS | `PowerGap.lean:48` obtains `m > 0` from `n > 0` and the integral bound. Multiplication by positive `m` preserves strictness, and positive `n ^ ε` permits division. `Real.rpow_sub` converts the result to `n ^ (1 - ε) < m`. |
| Uniform threshold | PASS | `NearLinearFinite.lean:19` quantifies eventually over `n` before the finite family `W`; `Main.lean:25` quantifies eventually over `n` before the arbitrary subgraph `H`. |
| Positive ncard before finiteness | PASS | `Main.lean:35` introduces `0 < n`; `Main.lean:36` then uses `H.verts.ncard = n` to prove finiteness. Infinite sets with natural cardinality zero cannot enter this step. |
| Ambient graph independence | PASS | `NearLinearFinite.lean:21` proves independence in `speckerGraph α`; `Main.lean:29` requires independence in `G`. The arbitrary subgraph may have deleted edges; its own weaker independence predicate is never substituted. |
| Correct set conversion | PASS | `Main.lean:37` proves the exact cardinality of `H.verts.toFinset`, and `Main.lean:43` transfers returned subset membership back to `H.verts`. |
| No admitted source theorem imported | PASS | Source is read for its statement only. The import closure used in the review comes from `JSP092.Main`, and the final theorem's transitive axioms contain no `sorryAx`. |

## Independent compilation and trust evidence

Working directory: the project root.
Each command was preceded by `source scripts/env.sh`.

1. `lake build JSP092.Main` exited **0** and printed “Build completed successfully (3057 jobs).”
2. All four reviewed modules independently passed `lake env lean -DwarningAsError=true <path>` with **exit 0** and no diagnostics.
3. `lake env lean -DwarningAsError=true Scratch/Infinite/IntegrationReview.lean` exited **0**. That file imports only `JSP092.Main`, repeats the pinned source's complete affirmative proposition, and proves it by direct application of `JSP092.erdos75_near_linear`.
4. The same independent review file printed transitive axioms for:
   - `JSP092.dyadicDepth_cover`
   - `JSP092.eventually_dyadicDepth_lt_rpow`
   - `JSP092.independent_size_gt_rpow`
   - `JSP092.eventually_nearLinear_finite`
   - `JSP092.erdos75_near_linear`

All five lists were exactly:

```text
[propext, Classical.choice, Quot.sound]
```

Raw local output is in `Scratch/Infinite/integration-review-output.txt`. No custom mathematical assumptions, admitted proof terms, or compiler-trusted proof shortcuts occur in these dependency closures.

## Scope of the conclusion

The implemented proposition is the affirmative right-hand side of the source's `answer(sorry) ↔ ...` declaration. It does not import that declaration or its `sorry`, and it does not assert the stronger fixed-linear independent-set bound. This review establishes agreement with the requested mathematical statement and verified proof terms; it makes no novelty, priority, or prize claim.

Source: [Formal Conjectures Erdős 75 at the pinned revision](https://github.com/google-deepmind/formal-conjectures/blob/40e7c98697de6f66b8cbdbf641749ab39ed9c152/FormalConjectures/ErdosProblems/75.lean).

## Published reproduction

The `Scratch/` commands above record development-time checks. Scratch files
are excluded from the published project. The maintained source checks are
`Checks/Audit.lean` and `Checks/FiniteEdgeCases.lean`; run
`sh scripts/verify.sh --clean` from the project root to reproduce them.
The corresponding output is preserved in `docs/evidence/`.
