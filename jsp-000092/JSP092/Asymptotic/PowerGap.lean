import JSP092.Asymptotic.DyadicCover
import Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics

/-!
# The strict power gap

Logarithmic palette size is eventually smaller than every positive power.
The final lemma isolates the positive-real arithmetic which turns a finite
color-class bound into the required strictly near-linear independent set.
-/

open Filter Asymptotics

namespace JSP092

/-- The real logarithmic bound for twice the palette depth is little-o of
every positive real power. -/
theorem dyadicBound_isLittleO_rpow {ε : ℝ} (hε : 0 < ε) :
    (fun x : ℝ => 2 * (Real.logb 2 (3 * x) + 1)) =o[atTop]
      (fun x : ℝ => x ^ ε) := by
  have hlog : (fun x : ℝ => Real.logb 2 (3 * x)) =O[atTop] Real.log :=
    Real.isBigO_logb_const_mul_log_atTop 3
  have hone : (fun _ : ℝ => (1 : ℝ)) =O[atTop] Real.log :=
    Real.isLittleO_const_log_atTop.isBigO
  exact ((hlog.add hone).trans_isLittleO (isLittleO_log_rpow_atTop hε)).const_mul_left 2

/-- Uniform eventual strict palette bound. The threshold depends only on `ε`. -/
theorem eventually_dyadicDepth_lt_rpow {ε : ℝ} (hε : 0 < ε) :
    ∀ᶠ n : ℕ in atTop, 0 < n ∧ (2 * dyadicDepth n : ℝ) < (n : ℝ) ^ ε := by
  have hbound := (dyadicBound_isLittleO_rpow hε).bound (by norm_num : (0 : ℝ) < 1 / 2)
  have hnat := (tendsto_natCast_atTop_atTop (R := ℝ)).eventually hbound
  filter_upwards [hnat, eventually_gt_atTop (0 : ℕ)] with n hn hpos
  refine ⟨hpos, ?_⟩
  have hp : 0 < (n : ℝ) ^ ε := Real.rpow_pos_of_pos (by exact_mod_cast hpos) ε
  have hdepth := dyadicDepth_le_logb n
  have habs := le_abs_self (2 * (Real.logb 2 (3 * (n : ℝ)) + 1))
  simp only [Real.norm_eq_abs, abs_of_pos hp] at hn
  nlinarith

/-- An explicit natural threshold form for final theorem assembly. -/
theorem exists_dyadicDepth_threshold {ε : ℝ} (hε : 0 < ε) :
    ∃ N : ℕ, ∀ n : ℕ, N ≤ n →
      0 < n ∧ (2 * dyadicDepth n : ℝ) < (n : ℝ) ^ ε := by
  exact Filter.eventually_atTop.1 (eventually_dyadicDepth_lt_rpow hε)

/-- Convert the integral color-class inequality and a strict power gap into
the required strict lower bound. -/
theorem independent_size_gt_rpow {n k m : ℕ} {ε : ℝ}
    (hn : 0 < n) (hk : 0 < k)
    (hcard : n ≤ (2 * k) * m)
    (hgap : (2 * k : ℝ) < (n : ℝ) ^ ε) :
    (n : ℝ) ^ (1 - ε) < (m : ℝ) := by
  have hnR : 0 < (n : ℝ) := by exact_mod_cast hn
  have hkR : 0 < (2 * k : ℝ) := by positivity
  have hp : 0 < (n : ℝ) ^ ε := Real.rpow_pos_of_pos hnR ε
  have hm : 0 < m := by nlinarith
  have hmR : 0 < (m : ℝ) := by exact_mod_cast hm
  have hcardR : (n : ℝ) ≤ (2 * k : ℝ) * (m : ℝ) := by exact_mod_cast hcard
  rw [Real.rpow_sub hnR, Real.rpow_one]
  apply (div_lt_iff₀ hp).2
  nlinarith

end JSP092
