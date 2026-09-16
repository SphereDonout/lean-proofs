# Finite proof: author checks

Date: 2026-09-16.

This records checks performed by the author of the finite coloring and transfer
modules. It complements the coordinator's independent review; it is not presented
as an independent review of the author's own proof.

## Build evidence

From the project root, with the pinned local Lean stack:

```sh
source scripts/env.sh
lake build JSP092.Finite.IndependentSet
lake env lean -DwarningAsError=true Checks/FiniteEdgeCases.lean
```

Both commands completed with exit status 0. The module build reported 3039 jobs
and successfully built the dyadic coloring, finite coloring transfer, and integral
independent-set theorem. The checked source produced no warnings or errors.

## Boundary and semantic checks

`Checks/FiniteEdgeCases.lean` verifies:

- The integral theorem retains exactly its generic linear-order interface and
  dyadic coverage assumption.
- The empty vertex set is accepted with `k = 0`.
- The dyadic graph at level zero has a valid coloring into its empty palette.
- The generic pigeonhole theorem accepts an empty palette, and this forces the
  original finite vertex set to be empty.
- Concrete triples `(0, 1, 3)` and `(2, 4, 5)` form an edge in both orientations,
  while the oriented `Up` relation holds in only one direction.
- Equality with the cut is handled in all three relevant positions: the last
  coordinate, the middle coordinate, and the first coordinate.
- Distinct triples sharing their first and last coordinates are allowed and are
  nonadjacent in the checked example.

The finite construction preserves independence in the ambient graph. Its color
fibers remain subsets of the original vertex set; no coordinate-disjointness
assumption is introduced.

## Axiom evidence

The same checked file prints the transitive axioms of:

- `JSP092.dyadicColoring`
- `JSP092.coordinateSupport_card_le`
- `JSP092.rankedTriple_adj`
- `JSP092.independent_fiber_card_bound`
- `JSP092.finite_independent_set`

Every declaration reports exactly:

```text
[propext, Classical.choice, Quot.sound]
```

The examples use ordinary kernel-checked proof terms and tactics, including
`decide` and `norm_num`. No `native_decide`, admitted proof, or custom mathematical
axiom is used.
