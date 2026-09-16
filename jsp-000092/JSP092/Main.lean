import JSP092.NearLinearFinite
import JSP092.Infinite.ChromaticCardinality
import Mathlib.Data.Set.Card

/-!
# JSP-000092 / Erdős 75: the near-linear theorem

This is the affirmative mathematical proposition in the pinned Formal
Conjectures Erdős 75 statement, with the exact universe-zero vertex type,
chromatic cardinal, quantifier order, ambient-graph independence, and strict
real-power bound. The admitted source conjecture is not imported.

The proof formalizes the public Specker-graph argument described in the
project's statement contract and mathematical source references.
-/

namespace JSP092

/-- The exact affirmative near-linear proposition of Erdős problem 75. -/
theorem erdos75_near_linear :
    ∃ (V : Type) (G : SimpleGraph V),
      G.chromaticCardinal = Cardinal.aleph 1 ∧
      Cardinal.mk V = Cardinal.aleph 1 ∧
      ∀ ε > (0 : ℝ),
        ∀ᶠ n : ℕ in Filter.atTop, ∀ H : G.Subgraph,
          H.verts.ncard = n →
          ∃ I : Finset V,
            (I : Set V) ⊆ H.verts ∧
            G.IsIndepSet (I : Set V) ∧
            (I.card : ℝ) > (n : ℝ) ^ (1 - ε) := by
  refine ⟨Triple Omega, speckerGraph Omega, chromaticCardinal_specker_omega,
    cardinal_triple_omega, ?_⟩
  intro ε hε
  filter_upwards [eventually_nearLinear_finite (α := Omega) hε,
    Filter.eventually_gt_atTop (0 : ℕ)] with n hn hpos H hH
  have hfinite : H.verts.Finite := Set.finite_of_ncard_pos (by omega)
  have hcard : hfinite.toFinset.card = n := by
    rw [← Set.ncard_eq_toFinset_card H.verts hfinite]
    exact hH
  obtain ⟨I, hIW, hI, hsize⟩ := hn hfinite.toFinset hcard
  refine ⟨I, ?_, hI, hsize⟩
  intro x hx
  exact hfinite.mem_toFinset.mp (hIW hx)

end JSP092
