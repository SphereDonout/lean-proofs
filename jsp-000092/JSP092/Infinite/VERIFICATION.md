# Ordinal branch verification

Verified locally on 16 September 2026 with Lean `4.33.1` and the project lockfile.
All commands below ran from the project root after `source scripts/env.sh`.

## Completed cards

| Cards | Module | Result |
|---|---|---|
| O01 | `Carrier.lean` | `Omega : Type`, cardinality aleph-one, no maximum, every natural-number sequence bounded |
| O02 | `CountableCover.lean` | Generic countable-cover lemma; no disjointness assumption |
| O03–O04 | `NestedFibers.lean` | Guarded third-coordinate fibers, second fibers, one unbounded first fiber |
| O05 | `NoCountableColoring.lean` | Every natural-number coloring has a monochromatic edge; proper countable colorings impossible |
| O06 | `VertexCardinality.lean` | Both cardinal bounds, hence exactly aleph-one vertices |
| O07 | `ChromaticCardinality.lean` | Cardinal-valued chromatic number is exactly aleph-one |

## Commands and evidence

- `lake build JSP092.Infinite.ChromaticCardinality`: exit 0; “Build completed successfully (3043 jobs).”
- Each of the six modules individually checked with `lake env lean -DwarningAsError=true JSP092/Infinite/<module>.lean`: all six exited 0 with no diagnostics.
- `lake env lean -DwarningAsError=true Scratch/Infinite/Audit.lean`: exit 0. Printed theorem signatures and transitive axiom lists are recorded in `Scratch/Infinite/audit-output.txt`.

The axiom checks for countable boundedness, the cover lemma, the nested-fiber theorem, the monochromatic-edge theorem, absence of natural-number colorings, vertex cardinality, and chromatic cardinality all report exactly:

```text
[propext, Classical.choice, Quot.sound]
```

No admitted proof, custom mathematical axiom, or compiler-trusted proof shortcut is used.

## Main integration interface

```lean
JSP092.cardinal_triple_omega :
  Cardinal.mk (JSP092.Triple JSP092.Omega) = Cardinal.aleph 1

JSP092.chromaticCardinal_specker_omega :
  (JSP092.speckerGraph JSP092.Omega).chromaticCardinal = Cardinal.aleph 1
```

Import `JSP092.Infinite.ChromaticCardinality` to obtain both.

## Mathematical review notes

- The carrier is the small `ToType` of the first uncountable ordinal, with cardinality and sequence boundedness proved from Mathlib theorems.
- Unboundedness means a member strictly above every bound. Countable covers may overlap, as required by the second and first fiber levels.
- The color is selected before the six coordinates. The actual inequalities used for adjacency are `x₁ < y₀ < x₂ < y₁`, with the within-triple inequalities carried by `Triple`.
- The cardinal lower bound embeds each coordinate as the first coordinate of an increasing triple; the upper bound embeds triples into the product of three coordinate carriers.
- The chromatic lower bound proves every realized color cardinal is at least aleph-one by embedding any smaller color type into the natural numbers. The upper bound uses the identity coloring.
- This proof establishes only the ordinal component; the near-linear independent-set conclusion requires the separate finite and analytic branches.

## Sources

- [Mathematical note attached to awards issue 110](https://github.com/user-attachments/files/32296106/JSP-000092_submission.md): the nested unbounded-fiber argument.
- [Pinned Mathlib regular-cardinal development](https://github.com/leanprover-community/mathlib4/blob/0df444a360eaa60ab8c11dca51a86af692955474/Mathlib/SetTheory/Cardinal/Regular.lean): `Ordinal.iSup_lt_omega_one`.
- [Pinned Formal Conjectures coloring support](https://github.com/google-deepmind/formal-conjectures/blob/40e7c98697de6f66b8cbdbf641749ab39ed9c152/FormalConjecturesForMathlib/Combinatorics/SimpleGraph/Coloring/Vertex.lean): the definition of `chromaticCardinal`. The admitted Erdős 75 theorem is not imported.

## Published reproduction

The `Scratch/` commands above record development-time checks. Scratch files
are excluded from the published project. The maintained source checks are
`Checks/Audit.lean` and `Checks/FiniteEdgeCases.lean`; run
`sh scripts/verify.sh --clean` from the project root to reproduce them.
The corresponding output is preserved in `docs/evidence/`.
