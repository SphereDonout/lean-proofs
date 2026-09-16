import JSP092.Finite.FiniteColoring
import JSP092.Finite.Pigeonhole

/-! # The integral finite independent-set theorem -/

namespace JSP092

universe u
variable {α : Type u} [LinearOrder α]

/-- Every finite set of triple vertices whose coordinate count fits in a dyadic
interval has an ambient independent subset with the stated integral bound.
No positivity, ordinal, logarithmic, or real-number assumptions are required. -/
theorem finite_independent_set (W : Finset (Triple α)) (k : ℕ)
    (hcover : 3 * W.card ≤ 2 ^ k) :
    ∃ I : Finset (Triple α), I ⊆ W ∧ (speckerGraph α).IsIndepSet (I : Set (Triple α)) ∧
      W.card ≤ 2 * k * I.card := by
  obtain ⟨I, hIW, hI, hcard⟩ := independent_fiber_card_bound (speckerGraph α) W
    (finiteDyadicColoring W k hcover)
  refine ⟨I, hIW, hI, ?_⟩
  simpa [Nat.mul_comm k 2] using hcard

end JSP092
