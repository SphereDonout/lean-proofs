import JSP737

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

/-!
# Independent transcription of the source proposition

Transcribed by a separate reviewer from the divisor-count consequence of
Erdős–Rosenfeld, Proposition 4.1, Acta Arithmetica 79 (1997), page 356.
The paper's first interval comparison is a typographical error: the intended
interval is closed and lies on or above the square root.
-/

namespace JSP737Checks

/-- The exact eventual closed-interval formulation selected for JSP-000737. -/
theorem paper_statement :
    ∀ C : ℝ, 0 < C → ∀ᶠ n : ℕ in Filter.atTop,
      (((Nat.divisors n).filter (fun d : ℕ =>
        (n : ℝ) ^ (1 / 2 : ℝ) ≤ (d : ℝ) ∧
        (d : ℝ) ≤ (n : ℝ) ^ (1 / 2 : ℝ) +
          C * (n : ℝ) ^ (1 / 4 : ℝ))).card : ℝ) ≤ 1 + C ^ 2 := by
  exact JSP737.erdos_rosenfeld_bound

/-- The source bound holds pointwise for positive integers, including C = 0. -/
theorem paper_pointwise (n : ℕ) (_hn : 1 ≤ n) (C : ℝ) (hC : 0 ≤ C) :
    (((Nat.divisors n).filter (fun d : ℕ =>
      (n : ℝ) ^ (1 / 2 : ℝ) ≤ (d : ℝ) ∧
      (d : ℝ) ≤ (n : ℝ) ^ (1 / 2 : ℝ) +
        C * (n : ℝ) ^ (1 / 4 : ℝ))).card : ℝ) ≤ 1 + C ^ 2 := by
  exact JSP737.rosenfeld_bound_pointwise n C hC

end JSP737Checks

-- The upstream admitted theorem is deliberately absent from this import graph.
#check_failure Erdos886.erdos_886.variants.rosenfeld_bound

#check JSP737Checks.paper_statement
#check JSP737Checks.paper_pointwise
