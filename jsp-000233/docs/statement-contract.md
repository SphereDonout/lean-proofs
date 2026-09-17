# Statement contract: Szabó's AP-intersection family

## Source and selected claim

Tibor Szabó, *Intersection properties of subsets of integers*, European Journal of Combinatorics 20(5) (1999), 429–444, Section 5, printed page 21. Author-hosted manuscript: <https://page.mi.fu-berlin.de/szabo/PDF/aps.pdf>. The inspected PDF has SHA-256 `bf837ef30c3538b2b44aea5d335cad9f75959066ccc119f01d89e79490dfdd78`. The notation and floor/ceiling glyphs on page 21 were checked visually. A later expanded explanation is Zhanfu Yang, *Exact values and exact upper bounds for families of integers with arithmetic progression intersections (Erdős Problem #272)* (2026), Section 2, <https://arxiv.org/html/2607.23004#S2>.

**Selected claim:** for every integer `N ≥ 1`, there is a family `C` of distinct subsets of `[1,N]` with pairwise nonempty arithmetic-progression intersections and

`|C| = choose(N,2) + 1 + floor((N-1)/4)`.

The paper denotes the maximum family size by `N₁` and proves this lower bound by an explicit family. This project formalizes that construction and the implied inequality. It does **not** prove the exact extremal value or Szabó's asymptotic upper bound.

## Lean proposition and conventions

The exported construction theorem is intended to have type:

```lean
theorem JSP233.szabo_family (N : ℕ) (hN : 1 ≤ N) :
  ∃ C : Finset (Finset ℕ), Erdos272.IsArithInterSet N C ∧
    C.card = N.choose 2 + 1 + (N - 1) / 4
```

The endpoint is intended to have type:

```lean
theorem JSP233.szabo_lower_bound (N : ℕ) (hN : 1 ≤ N) :
  N.choose 2 + 1 + (N - 1) / 4 ≤ Erdos272.maxArithInterCard N
```

These use the definitions in Formal Conjectures, pinned at commit `40e7c98697de6f66b8cbdbf641749ab39ed9c152`, file `FormalConjectures/ErdosProblems/272.lean`. Its `IsArithInterSet` requires `C ⊆ (Finset.Icc 1 N).powerset` and pairwise intersections of **distinct** members to satisfy `Set.IsAPOfLength l` for some `l > 0`. The `ℕ∞` progression length and natural-number subtraction must be treated explicitly. Its maximum is a natural-number `sSup` of feasible family cardinalities. The paper's `[1,N]` and the Lean `Finset.Icc 1 N` agree; family members are represented by `Finset ℕ`, and the outer `Finset` enforces distinctness. The center is `ceil(N/2)`, represented by `(N+1)/2`, and the construction parameter runs through `1 ≤ d ≤ floor((N-1)/4)`.

## Argument and proof obligations

1. **Base family (paper Section 5, lines 1–4):** all subsets of size at most three containing the center, count `choose(N,2)+1`. Establish this by coding the noncentral elements as zero-, one-, or two-element subsets or by another bijective count.
2. **Modifications (Section 5, middle):** for each admissible `d`, remove `{c-2d,c,c+d}` and `{c-d,c,c+2d}` and add the centered five-term progression and its two four-term consecutive subprogressions. Prove all points lie in `[1,N]`, all removed members are distinct, all inserted members are new/distinct, and the net gain is one per `d`.
3. **Intersection property (Section 5, mostly implicit):** every member contains `c`. Intersections of two base members have at most two points. Intersections of a retained base member with an inserted progression are APs because the only troublesome triples were removed. Intersections of two inserted progressions are APs, including different `d` and the `d : 2d` overlap cases. These checks are paper gaps requiring explicit Lean lemmas.
4. **Cardinality and supremum bridge (Section 5, displayed equation):** establish the exact family count, then use membership in the defining `sSup` to obtain the lower bound.

Formalization authorship belongs to this project. The combinatorial construction belongs to Szabó. Any Lean proof using a different equivalent coding must identify that change in the final report.

## Acceptance criteria

The exact construction theorem and lower bound compile with the pinned Lean 4/Mathlib/Formal Conjectures versions, warnings treated as errors. A separate statement check independently phrases the paper claim and derives it from the exported theorem. Final declarations and critical helpers have complete transitive axiom reports with only `propext`, `Classical.choice`, and `Quot.sound` allowed. No `sorry`, `admit`, custom mathematical axiom, or `native_decide` shortcut may support the result. A clean project build and semantic review must succeed before calling the formalization verified.
