import JSP924.Basic

/-!
Proper-divisor bridges used by both branches of the Izotov construction.
-/

namespace JSP924

/-- A product of two natural numbers greater than one has a proper divisor. -/
theorem composite_mul {a b : ℕ} (ha : 1 < a) (hb : 1 < b) :
    Composite (a * b) := by
  refine ⟨a, ha, ?_, ⟨b, rfl⟩⟩
  nlinarith

/-- A number with a divisor strictly between one and itself is not prime. -/
theorem composite_not_prime {N : ℕ} (h : Composite N) :
    ¬ Nat.Prime N := by
  obtain ⟨d, hd, hlt, hdvd⟩ := h
  exact Nat.not_prime_of_dvd_of_lt hdvd (by omega) hlt

end JSP924
