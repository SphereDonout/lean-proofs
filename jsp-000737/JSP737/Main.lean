import JSP737.FactorSum
import JSP737.IntervalCount

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

namespace JSP737

/-- The Erdős–Rosenfeld bound holds for every natural n and nonnegative C.
For n = 0 this uses Mathlib's convention `Nat.divisors 0 = ∅`. -/
theorem nearDivisors_card_le (n : ℕ) (C : ℝ) (hC : 0 ≤ C) :
    ((nearDivisors n C).card : ℝ) ≤ 1 + C ^ 2 := by
  classical
  by_cases hn : n = 0
  · subst n
    simp only [nearDivisors, Nat.divisors_zero, Finset.filter_empty,
      Finset.card_empty, Nat.cast_zero]
    positivity
  · have hnpos : 0 < n := Nat.pos_of_ne_zero hn
    have hcard : ((nearDivisors n C).image (factorSum n)).card =
        (nearDivisors n C).card :=
      Finset.card_image_iff.mpr (factorSum_injective n C hnpos)
    have hbound := nat_card_le_interval ((nearDivisors n C).image (factorSum n))
      (2 * Real.sqrt (n : ℝ)) (2 * Real.sqrt (n : ℝ) + C ^ 2)
      (by linarith [sq_nonneg C]) (by
        intro k hk
        obtain ⟨d, hd, rfl⟩ := Finset.mem_image.mp hk
        exact factorSum_mem_bounds n d C hnpos hC hd)
    rw [hcard] at hbound
    linarith

/-- The iterated nonnegative square root agrees with the real fourth power root. -/
theorem fourth_root_eq_rpow (n : ℕ) :
    Real.sqrt (Real.sqrt (n : ℝ)) = (n : ℝ) ^ (1 / 4 : ℝ) := by
  rw [Real.sqrt_eq_rpow, Real.sqrt_eq_rpow, ← Real.rpow_mul (Nat.cast_nonneg n)]
  norm_num

/-- Exact bridge from the square-root definition to the source's real powers. -/
theorem nearDivisors_eq_rpow (n : ℕ) (C : ℝ) :
    nearDivisors n C = n.divisors.filter (fun d : ℕ =>
      (n : ℝ) ^ (1 / 2 : ℝ) ≤ (d : ℝ) ∧
      (d : ℝ) ≤ (n : ℝ) ^ (1 / 2 : ℝ) + C * (n : ℝ) ^ (1 / 4 : ℝ)) := by
  unfold nearDivisors
  rw [fourth_root_eq_rpow, Real.sqrt_eq_rpow]

/-- Pointwise strengthening of the published divisor-count consequence of Proposition 4.1. -/
theorem rosenfeld_bound_pointwise (n : ℕ) (C : ℝ) (hC : 0 ≤ C) :
    ((n.divisors.filter (fun d : ℕ =>
      (n : ℝ) ^ (1 / 2 : ℝ) ≤ (d : ℝ) ∧
      (d : ℝ) ≤ (n : ℝ) ^ (1 / 2 : ℝ) +
        C * (n : ℝ) ^ (1 / 4 : ℝ))).card : ℝ) ≤ 1 + C ^ 2 := by
  simpa only [nearDivisors_eq_rpow] using nearDivisors_card_le n C hC

/-- Exact eventual theorem selected as JSP-000737 / Erdős 886's Rosenfeld bound. -/
theorem erdos_rosenfeld_bound :
    ∀ C > (0 : ℝ), ∀ᶠ (n : ℕ) in Filter.atTop,
      ((n.divisors.filter (fun d : ℕ =>
        (n : ℝ) ^ (1 / 2 : ℝ) ≤ (d : ℝ) ∧
        (d : ℝ) ≤ (n : ℝ) ^ (1 / 2 : ℝ) +
          C * (n : ℝ) ^ (1 / 4 : ℝ))).card : ℝ) ≤ 1 + C ^ 2 := by
  intro C hC
  exact Filter.Eventually.of_forall (fun n => rosenfeld_bound_pointwise n C hC.le)

end JSP737
