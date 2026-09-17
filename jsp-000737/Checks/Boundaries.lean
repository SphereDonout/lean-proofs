import JSP737

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

namespace JSP737Checks

/-- The extra n = 0 case uses the empty-divisor convention explicitly. -/
theorem zero_divisors (C : ℝ) : JSP737.nearDivisors 0 C = ∅ := by
  simp [JSP737.nearDivisors]

/-- The smallest positive n and zero width retain the square-root endpoint. -/
theorem one_zero_width : JSP737.nearDivisors 1 0 = {1} := by
  simp [JSP737.nearDivisors]

/-- Every positive perfect square retains its square-root divisor at zero width. -/
theorem square_endpoint (m : ℕ) (hm : 0 < m) :
    m ∈ JSP737.nearDivisors (m ^ 2) 0 := by
  classical
  have hdiv : m ∈ (m ^ 2).divisors := by
    apply Nat.mem_divisors.mpr
    constructor
    · exact dvd_pow_self m (by decide)
    · positivity
  apply Finset.mem_filter.mpr
  refine ⟨hdiv, ?_, ?_⟩ <;>
    simp [Nat.cast_pow, Real.sqrt_sq (Nat.cast_nonneg m)]

/-- The zero-width extension has the intended real cardinality bound. -/
theorem zero_width_card (n : ℕ) : ((JSP737.nearDivisors n 0).card : ℝ) ≤ 1 := by
  simpa using JSP737.nearDivisors_card_le n 0 (by rfl)

end JSP737Checks
