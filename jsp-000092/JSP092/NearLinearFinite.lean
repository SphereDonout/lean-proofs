import JSP092.Finite.IndependentSet
import JSP092.Asymptotic.PowerGap

/-!
# Near-linear independent sets in finite triple families

This module combines the integral color-class bound with the dyadic power gap.
The threshold is chosen before the finite vertex family, so it is uniform over
all families of the same cardinality and over every linearly ordered carrier.
-/

namespace JSP092

universe u
variable {α : Type u} [LinearOrder α]

/-- Uniform near-linear independent-set bound for finite triple families. -/
theorem eventually_nearLinear_finite {ε : ℝ} (hε : 0 < ε) :
    ∀ᶠ n : ℕ in Filter.atTop, ∀ W : Finset (Triple α), W.card = n →
      ∃ I : Finset (Triple α), I ⊆ W ∧
        (speckerGraph α).IsIndepSet (I : Set (Triple α)) ∧
        (n : ℝ) ^ (1 - ε) < (I.card : ℝ) := by
  filter_upwards [eventually_dyadicDepth_lt_rpow hε] with n hn W hW
  have hcover : 3 * W.card ≤ 2 ^ dyadicDepth n := by
    simpa only [hW] using dyadicDepth_cover n
  obtain ⟨I, hIW, hI, hcard⟩ := finite_independent_set W (dyadicDepth n) hcover
  refine ⟨I, hIW, hI, independent_size_gt_rpow hn.1 (dyadicDepth_pos n) ?_ hn.2⟩
  simpa only [hW] using hcard

end JSP092
