import JSP924.Composite
import Mathlib.Tactic.Ring

/-!
The Sophie Germain identity in a subtraction-free natural-number form.
This is the factorization in equation (1) on page 6 of the source preprint.
-/

namespace JSP924

/-- Shift the variable so that both factors are polynomials over the naturals. -/
theorem sophie_identity (y : ℕ) :
    4 * (y + 1) ^ 4 + 1 =
      (2 * y ^ 2 + 2 * y + 1) * (2 * y ^ 2 + 6 * y + 5) := by
  ring

/-- The strict bound excludes `x = 1`, whose corresponding value is the prime 5. -/
theorem sophie_composite (x : ℕ) (hx : 1 < x) :
    Composite (4 * x ^ 4 + 1) := by
  obtain ⟨y, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : x ≠ 0)
  have hy : 1 ≤ y := by omega
  rw [Nat.succ_eq_add_one, sophie_identity]
  apply composite_mul <;> nlinarith

end JSP924
