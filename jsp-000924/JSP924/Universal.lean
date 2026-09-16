import JSP924.Cover.Complete
import JSP924.Factorization.Exceptional

namespace JSP924

/-- Izotov's explicit fourth-power progression works for every natural exponent. -/
theorem family_value_composite (t n : ℕ) : Composite (value t n) := by
  by_cases hn : n % 4 = 2
  · exact exceptional_composite t n hn
  · exact covered_composite t n hn

theorem named_witness_composite (n : ℕ) :
    Composite (734110615000775 ^ 4 * 2 ^ n + 1) := by
  simpa only [value, root, seed, Nat.mul_zero, Nat.add_zero] using
    family_value_composite 0 n

end JSP924
