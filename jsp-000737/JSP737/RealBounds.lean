import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

/-!
# Algebra for factor sums above the square root

These lemmas isolate the real inequalities in Erdős and Rosenfeld,
*The factor-difference set of integers*, Proposition 4.1.
-/

namespace JSP737

/-- Upper factors in an interval of width `C * t`, with `t² = s`, have
factor sums in an interval of width `C²`. -/
theorem factor_sum_bounds (s t C d q : ℝ) (hs : 0 < s) (ht : 0 ≤ t)
    (htsq : t ^ 2 = s) (hC : 0 ≤ C) (hd : s ≤ d)
    (hdu : d ≤ s + C * t) (hprod : d * q = s ^ 2) :
    2 * s ≤ d + q ∧ d + q ≤ 2 * s + C ^ 2 := by
  have hdpos : 0 < d := lt_of_lt_of_le hs hd
  have hdist : (d - s) ^ 2 ≤ C ^ 2 * d := by
    calc
      (d - s) ^ 2 ≤ (C * t) ^ 2 :=
        (sq_le_sq₀ (sub_nonneg.mpr hd) (mul_nonneg hC ht)).mpr (by linarith)
      _ = C ^ 2 * t ^ 2 := by ring
      _ = C ^ 2 * s := by rw [htsq]
      _ ≤ C ^ 2 * d := mul_le_mul_of_nonneg_left hd (sq_nonneg C)
  constructor
  · apply (mul_le_mul_iff_right₀ hdpos).mp
    nlinarith [sq_nonneg (d - s)]
  · apply (mul_le_mul_iff_right₀ hdpos).mp
    nlinarith [hdist]

/-- A factor sum determines its factor on or above the positive square root. -/
theorem upper_factor_unique (s d e q r : ℝ) (hs : 0 < s)
    (hd : s ≤ d) (he : s ≤ e) (hp : d * q = s ^ 2)
    (hr : e * r = s ^ 2) (hsum : d + q = e + r) : d = e := by
  have hrle : r ≤ s := by
    by_contra h
    have hpos : 0 < e * (r - s) :=
      mul_pos (lt_of_lt_of_le hs he) (sub_pos.mpr (lt_of_not_ge h))
    nlinarith [mul_nonneg (sub_nonneg.mpr he) hs.le]
  have heq : d * (d + q) = d * (e + r) := congrArg (fun x : ℝ => d * x) hsum
  have hfactor : (d - e) * (d - r) = 0 := by nlinarith [heq]
  rcases mul_eq_zero.mp hfactor with hde | hdr
  · exact sub_eq_zero.mp hde
  · have hds : d = s := by linarith
    have hrs : r = s := by linarith
    have hes : e = s := by
      rw [hrs] at hr
      nlinarith
    exact hds.trans hes.symm

end JSP737
