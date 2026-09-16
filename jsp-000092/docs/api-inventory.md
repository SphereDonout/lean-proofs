# Proof API inventory

All project declarations use namespace `JSP092`. The statements below describe the actual implemented interfaces; the exact Lean types are in the named modules. `Triple α` and the finite branch are universe-polymorphic. The final graph uses a vertex type in universe zero.

## Graph and finite families

| Module | Main declarations and contract |
| --- | --- |
| `JSP092.Basic` | `Triple α` has coordinates `a < b < c`. `Up x y` is `x.b < y.a ∧ y.a < x.c ∧ x.c < y.b`. `speckerGraph α` admits either orientation. `Triple.map_adj` preserves edges under strictly increasing coordinate maps. |
| `JSP092.Finite.Cut` | `cut_cases`, `crossLeft_not_adj`, `crossRight_not_adj`, and `lower_upper_not_adj` justify the four-way cut and independent crossing classes. |
| `JSP092.Finite.Halves` | `lowerTriple`, `upperTriple`, and their adjacency lemmas normalize triples within a dyadic half. Upper normalization explicitly requires the interval-size equality and the lower coordinate bound. |
| `JSP092.Finite.DyadicColoring` | `dyadicColoring k : (speckerGraph (Fin (2^k))).Coloring (Fin k × Bool)`. |
| `JSP092.Finite.Support` | `coordinateSupport W`, its bound `card ≤ 3 * W.card`, the increasing `coordinateRank`, and `rankedTriple_adj`. Repeated coordinates share a single rank. |
| `JSP092.Finite.FiniteColoring` | `finiteDyadicColoring W k hcover` colors the induced graph on the original finite family using the dyadic palette. |
| `JSP092.Finite.Pigeonhole` | `independent_fiber_card_bound` returns `I ⊆ W`, ambient `G.IsIndepSet I`, and `W.card ≤ Fintype.card C * I.card`. |
| `JSP092.Finite.IndependentSet` | `finite_independent_set W k hcover`, with `hcover : 3 * W.card ≤ 2^k`, returns `I ⊆ W`, ambient independence, and `W.card ≤ 2 * k * I.card`. |

The finite theorem uses no logarithms, real arithmetic, nonempty-family hypothesis, or ordinal assumptions.

## Countable ordinals and chromatic cardinality

| Module | Main declarations and contract |
| --- | --- |
| `JSP092.Infinite.Carrier` | `Omega : Type := (Cardinal.aleph.{0} 1).ord.ToType`; `cardinal_omega`; `omega_sequence_bounded`; and the strictly greater choice `omegaNext`. |
| `JSP092.Infinite.CountableCover` | `UnboundedAbove S` means that `S` has an element strictly above every bound. `exists_unboundedAbove_of_countable_cover` allows overlapping covering sets. |
| `JSP092.Infinite.NestedFibers` | Guarded total `paint` and the third-, second-, and first-coordinate fibers; each stage proves that some color has an unbounded relevant fiber. |
| `JSP092.Infinite.NoCountableColoring` | `exists_monochromatic_edge` for every function `Triple Omega → ℕ`; `no_nat_coloring : IsEmpty ((speckerGraph Omega).Coloring ℕ)`. |
| `JSP092.Infinite.VertexCardinality` | `cardinal_triple_omega : Cardinal.mk (Triple Omega) = Cardinal.aleph 1`, with explicit lower and upper bounds. |
| `JSP092.Infinite.ChromaticCardinality` | `chromaticCardinal_specker_omega : (speckerGraph Omega).chromaticCardinal = Cardinal.aleph 1`. |

The external cardinal-valued coloring definition is imported from `FormalConjecturesForMathlib.Combinatorics.SimpleGraph.Coloring.Vertex`. The admitted source Erdős 75 theorem is not imported or used.

## Asymptotics and final assembly

| Module | Main declarations and contract |
| --- | --- |
| `JSP092.Asymptotic.DyadicCover` | `dyadicDepth n := Nat.log 2 (3*n) + 1`; positivity and coverage for every `n`; an explicit real logarithmic bound and `dyadicDepth_isBigO_log`. |
| `JSP092.Asymptotic.PowerGap` | `eventually_dyadicDepth_lt_rpow hε` and `exists_dyadicDepth_threshold hε` establish eventual `0 < n` and `2 * dyadicDepth n < n^ε` for every `ε > 0`. `independent_size_gt_rpow` converts `n ≤ 2*k*m` and the strict palette bound into `n^(1-ε) < m`. |
| `JSP092.NearLinearFinite` | `eventually_nearLinear_finite hε` supplies a threshold before quantification over all finite triple families of size `n`. |
| `JSP092.Main` | `erdos75_near_linear` supplies the graph, both aleph-one equalities, and the exact eventual finite-subgraph statement with ambient independence and strict real-power inequality. |

The main adapter first forces `n > 0`, then uses `Set.finite_of_ncard_pos` before converting `H.verts` to a `Finset`. This guards against the natural cardinal convention for infinite sets. The theorem quantifies over all positive real epsilon, including epsilon equal to or greater than one.

## Validation entry points

The maintained verification command is `bash scripts/verify.sh --clean`, and the tracked combined audit is `Checks/Audit.lean`. Independent review reports are under `docs/reviews/`. Implementation-time checks under `Scratch/` document additional local experiments; they are not imported by the proof library.

The main theorem's inspected transitive axioms are exactly `propext`, `Classical.choice`, and `Quot.sound`. Successful module compilation, independent semantic review, and the coordinator's final clean-build audit are distinct pieces of verification evidence.
