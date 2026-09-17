import JSP737.Basic
import JSP737.RealBounds

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

namespace JSP737

/-- Exact complementary factors multiply to the square of the square root. -/
theorem divisor_product (n d : ℕ) (hd : d ∣ n) :
    (d : ℝ) * (n / d : ℕ) = Real.sqrt (n : ℝ) ^ 2 := by
  rw [Real.sq_sqrt (Nat.cast_nonneg n)]
  exact_mod_cast Nat.mul_div_cancel' hd

/-- The natural factor sum of a selected divisor lies in a short real interval. -/
theorem factorSum_mem_bounds (n d : ℕ) (C : ℝ) (hn : 0 < n) (hC : 0 ≤ C)
    (hd : d ∈ nearDivisors n C) :
    2 * Real.sqrt (n : ℝ) ≤ (factorSum n d : ℝ) ∧
      (factorSum n d : ℝ) ≤ 2 * Real.sqrt (n : ℝ) + C ^ 2 := by
  obtain ⟨hdiv, hl, hu⟩ := Finset.mem_filter.mp hd
  have hdvd : d ∣ n := (Nat.mem_divisors.mp hdiv).1
  have hs : 0 < Real.sqrt (n : ℝ) := Real.sqrt_pos.2 (by exact_mod_cast hn)
  simpa only [factorSum, Nat.cast_add] using
    factor_sum_bounds (Real.sqrt (n : ℝ)) (Real.sqrt (Real.sqrt (n : ℝ))) C
      (d : ℝ) (n / d : ℕ) hs (Real.sqrt_nonneg _)
      (Real.sq_sqrt (Real.sqrt_nonneg _)) hC hl hu (divisor_product n d hdvd)

/-- Equal factor sums identify divisors on the upper side of the square root. -/
theorem factorSum_injective (n : ℕ) (C : ℝ) (hn : 0 < n) :
    Set.InjOn (factorSum n) (nearDivisors n C) := by
  intro d hd e he hsum
  obtain ⟨hddiv, hdl, _⟩ := Finset.mem_filter.mp hd
  obtain ⟨hediv, hel, _⟩ := Finset.mem_filter.mp he
  have hsumR : (d : ℝ) + (n / d : ℕ) = (e : ℝ) + (n / e : ℕ) := by
    exact_mod_cast hsum
  have hde : (d : ℝ) = (e : ℝ) :=
    upper_factor_unique (Real.sqrt (n : ℝ)) (d : ℝ) (e : ℝ) (n / d : ℕ) (n / e : ℕ)
      (Real.sqrt_pos.2 (by exact_mod_cast hn)) hdl hel
      (divisor_product n d (Nat.mem_divisors.mp hddiv).1)
      (divisor_product n e (Nat.mem_divisors.mp hediv).1) hsumR
  exact_mod_cast hde

end JSP737
