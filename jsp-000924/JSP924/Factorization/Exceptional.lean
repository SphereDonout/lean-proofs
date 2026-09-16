import JSP924.Factorization.SophieGermain

/-!
The exponent classes `n ≡ 2 (mod 4)` in the Izotov construction are handled
by the Sophie Germain factorization rather than by a fixed covering divisor.
-/

namespace JSP924

/-- Identify the literal family value with the expression to be factored. -/
theorem exceptional_value (t u : ℕ) :
    value t (4 * u + 2) = 4 * (root t * 2 ^ u) ^ 4 + 1 := by
  unfold value
  rw [pow_add, Nat.mul_comm 4 u, pow_mul, mul_pow]
  ring

/-- Every exceptional exponent has the required proper divisor. -/
theorem exceptional_composite (t n : ℕ) (hn : n % 4 = 2) :
    Composite (value t n) := by
  have hn' : n = 4 * (n / 4) + 2 := by
    have h := Nat.mod_add_div n 4
    omega
  rw [hn', exceptional_value]
  apply sophie_composite
  have hr := root_gt_one t
  have hp : 1 ≤ 2 ^ (n / 4) := Nat.one_le_pow (n / 4) 2 (by decide)
  nlinarith

end JSP924
