import Mathlib.NumberTheory.Divisors
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.Real.Sqrt

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

namespace JSP737

/-- Positive natural divisors in the closed fourth-root-scale interval. -/
noncomputable def nearDivisors (n : ℕ) (C : ℝ) : Finset ℕ :=
  n.divisors.filter (fun d =>
    Real.sqrt (n : ℝ) ≤ (d : ℝ) ∧
      (d : ℝ) ≤ Real.sqrt (n : ℝ) + C * Real.sqrt (Real.sqrt (n : ℝ)))

/-- Sum of a positive factor and its complementary factor. -/
def factorSum (n d : ℕ) : ℕ := d + n / d

end JSP737
