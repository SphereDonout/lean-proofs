# Independent review of the ordinal and dyadic constructions

Reviewer: coordinator, independently of the authors of the ordinal branch and
the recursive coloring/finite adapter. Reviewed 16 September 2026.

Result: **PASS**. The reviewed proof sources establish the interfaces required
by the statement contract. Reproducible compiler and axiom evidence is collected
by `scripts/verify.sh` in `docs/evidence/`.

## Ordinal branch

- `Omega` is the small `ToType` of the ordinal of aleph-one, in universe zero.
  `omega_sequence_bounded` uses the supremum of the sequence of represented
  ordinals and Mathlib's proved countable-supremum bound. Transport back through
  the order isomorphism gives a bound in the same carrier.
- The countable-cover argument assumes coverage only. Its members can overlap.
  If every member were bounded, countably many selected bounds would have a
  common bound, contradicting strict unboundedness of the covered set.
- Both order guards occur in the third fiber. Second and first fibers retain
  the required unboundedness. The natural-number color is fixed before the
  six coordinates are selected.
- The selections yield `x.a < x.b < y.a < x.c < y.b < y.c`. Both constructed
  vertices have the selected color; the total helper's fallback is never used
  at an invalid coordinate triple.
- The vertex lower bound preserves the first coordinate of every input. The
  upper bound injects triples into the product of three copies of `Omega`.
- Any proper palette smaller than aleph-one embeds into the natural numbers,
  contradicting the monochromatic-edge theorem. An identity coloring supplies
  the chromatic upper bound. The set of realized palette cardinals is proved
  nonempty before the infimum lower bound is applied.

The chromatic proof uses direct lower and upper bounds on the defining infimum,
instead of first proving that the minimum is attained. This is a valid local
simplification of O07 and preserves the exact definition imported from the
pinned coloring support module.

## Dyadic coloring and finite adapter

- The base case has no increasing triples in `Fin 1`; an empty palette is valid.
- Each step reuses the previous palette in the two halves. Triples in opposite
  halves are nonadjacent. Normalization preserves the relevant inequalities.
- Crossing triples use the fresh first palette coordinate `k`; lower levels
  have first coordinate strictly less than `k`.
- The Boolean coordinate distinguishes the two crossing classes. Equal colors
  in either class contradict its proved independence. Equality at a cut belongs
  to the upper side, consistently throughout the definitions and proof cases.
- Increasing ranks are taken on the union of all coordinate supports. Shared
  coordinates have the same rank; no disjointness assumption is introduced.
- The coloring is transported to the induced graph on the original vertex set.
  Pigeonhole returns an independent set in the ambient graph, with the integral
  bound `W.card ≤ 2 * k * I.card`. The construction is valid for an empty set.

No formal target is replaced by a hypothesis, no stronger graph assumption is
introduced, and no fixed-linear asymptotic claim is made.
