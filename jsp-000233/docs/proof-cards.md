# Proof cards

Every card below compiled in the pinned project. The clean project rebuild and axiom audit are recorded in `docs/verification-report.md`.

| ID | Status | Paper step | Exact goal / interface | Main work |
| --- | --- | --- | --- | --- |
| E | Compiled | Section 5 setup | `center_bounds`, `window_bounds`, `window_order` in `JSP233/Family.lean` | Natural division and subtraction bounds; source page 21. |
| A | Compiled | Section 5 inserted progressions | `prog_ap` in `JSP233/Progression.lean`; window equalities, cardinalities, and AP lemmas in `JSP233/WindowAP.lean` | A positive step yields exactly the declared `ℕ∞` length. |
| X | Compiled | Section 5 well-intersection claim | `distinct_base_inter_ap`, `base_added_inter_ap`, `addedAt_inter_ap` in `JSP233/Intersect.lean` | Explicitly classify all four allowed centered triples; prove the two exclusions and different-step overlaps. |
| C | Compiled | Section 5 displayed count | `base_card`, `excludedFamily_card`, `addedFamily_card`, `szaboFamily_card` in `JSP233/Counting.lean` | Injective indexing, disjointness, and exact finite counting. |
| M | Compiled | Section 5 displayed result | `szabo_family_feasible`, `szabo_family`, `szabo_lower_bound` in `JSP233/Main.lean` | Construct a witness under the pinned Formal Conjectures predicate and apply `sSup`. |
| V | Verified locally | Source statement and foundations | `Checks/Statement.lean`, `Checks/Semantics.lean`, `Checks/Axioms.lean`, `Checks/Boundaries.lean` | `sh scripts/verify.sh clean` passed after removing project build output. |

The independent statement check was derived from the paper in the same agent session. It is an independent Lean proposition, not an independent human or separate AI review.
