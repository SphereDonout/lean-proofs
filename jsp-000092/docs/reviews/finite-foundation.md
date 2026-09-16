# Independent review: finite foundations

Reviewed 2026-09-16 by the asymptotic/integration implementation worker, who did not author the reviewed foundation modules. No reviewed proof files were edited during this review.

## Result

**PASS.** Source inspection and kernel compilation found no mismatch between the mathematical interfaces and their intended role. All ten inspected proof exports have only permitted standard foundations. This review covers `Basic.lean`, `Finite/Cut.lean`, `Finite/Halves.lean`, `Finite/Support.lean`, and `Finite/Pigeonhole.lean`. Recursive dyadic coloring is outside this foundation review.

## Semantic checks

- **Exact adjacency.** A vertex has coordinates `a < b < c`. `Up x y` requires all three inequalities `x.b < y.a < x.c < y.b`. Together these are exactly `x.a < x.b < y.a < x.c < y.b < y.c`. The graph includes either orientation, and the looplessness proof uses the contradiction between `x.a < x.b` and `x.b < x.a`. Both orientations are preserved by the coordinate transport lemmas.
- **Cut boundaries.** The four classes cover all triples: wholly below the cut, wholly at or above it, crossing after the middle coordinate, and crossing before the middle coordinate. A last coordinate equal to the cut belongs to the first crossing class; a middle coordinate equal to the cut belongs to the second crossing class; a first coordinate equal to the cut belongs to the upper half. Each crossing class is independent by a direct contradiction with the corresponding strict interleaving inequality. A wholly lower triple and a wholly upper triple cannot be adjacent in either orientation.
- **Half normalization.** Lower normalization preserves coordinate values and uses the bound on the last coordinate to bound the first two. Upper normalization requires both the exact interval size `m = n + n` and the first-coordinate lower bound `n ≤ x.a.val`. Consequently every coordinate is at least `n`: natural subtraction cannot truncate any coordinate, and all strict inequalities are preserved. No hidden positive-size assumption is required. At a zero-size destination the input hypotheses cannot be realized by a triple.
- **Shared coordinates and empty support.** The support is the union of the three coordinate images, with cardinality bounded above by `3 * W.card`; it does not assume three distinct new coordinates per vertex. One order isomorphism ranks the entire support, so repeated coordinates in different vertices receive the same rank. The definitions permit an empty vertex family and empty support. Ranking is only applied to members of the family, so no rank of an absent coordinate is requested.
- **Pigeonhole and empty palette.** An empty vertex family is handled first, returning the empty independent set. For a nonempty family, its coloring supplies a color, making the maximum-fiber argument legitimate even though the theorem does not assume a nonempty palette. Thus an empty palette causes no omitted case. The comparison is the integral bound `W.card ≤ Fintype.card C * I.card`, without division or rounding assumptions.
- **Ambient independence.** The palette colors the induced graph on the original finite vertex set. The selected fiber consists of original vertices and is a subset of that set. The proof takes an edge of the ambient graph, converts it directly to an edge in the induced graph, and contradicts equal colors. Its conclusion is `G.IsIndepSet`, not independence in a weaker graph.

## Reproducible checks

Working directory: the project root.

```sh
source scripts/env.sh
lake --wfail build JSP092.Main JSP092.Basic JSP092.Finite.Cut JSP092.Finite.Halves JSP092.Finite.Support JSP092.Finite.Pigeonhole
lake env lean -DwarningAsError=true Scratch/Asymptotic/FoundationReview.lean
```

Both commands exited **0**. The build reported `Build completed successfully (3057 jobs).` The axiom audit printed:

| Declarations | Transitive axioms |
| --- | --- |
| `Triple.map_adj`, `cut_cases`, `crossLeft_not_adj`, `crossRight_not_adj`, `lower_upper_not_adj` | `propext` |
| `lowerTriple_adj`, `upperTriple_adj` | `propext`, `Quot.sound` |
| `coordinateSupport_card_le`, `rankedTriple_adj`, `independent_fiber_card_bound` | `propext`, `Classical.choice`, `Quot.sound` |

No admission, custom mathematical axiom, or compiler-trusted proof shortcut occurs in these audited dependencies. No remaining corrective action was identified.

## Published reproduction

The `Scratch/` commands above record development-time checks. Scratch files
are excluded from the published project. The maintained source checks are
`Checks/Audit.lean` and `Checks/FiniteEdgeCases.lean`; run
`sh scripts/verify.sh --clean` from the project root to reproduce them.
The corresponding output is preserved in `docs/evidence/`.
