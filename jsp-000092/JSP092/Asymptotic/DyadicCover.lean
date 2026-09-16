import Mathlib.Analysis.SpecialFunctions.Log.Base
import Mathlib.Tactic

/-!
# A dyadic coordinate cover

The finite coloring argument needs an integer `k` with `3 * n ≤ 2 ^ k`.
We use one plus the natural binary logarithm. This is a cover, and is not
claimed to equal the ceiling of the real logarithm at powers of two.
-/

namespace JSP092

/-- A total, positive dyadic depth; its value at zero is one. -/
def dyadicDepth (n : ℕ) : ℕ := Nat.log 2 (3 * n) + 1

@[simp] theorem dyadicDepth_zero : dyadicDepth 0 = 1 := by
  simp [dyadicDepth]

theorem dyadicDepth_pos (n : ℕ) : 0 < dyadicDepth n := by
  simp [dyadicDepth]

/-- The chosen depth covers all coordinates of any family of `n` triples. -/
theorem dyadicDepth_cover (n : ℕ) : 3 * n ≤ 2 ^ dyadicDepth n := by
  exact (Nat.lt_pow_succ_log_self (by norm_num : 1 < 2) (3 * n)).le

/-- An explicit logarithmic upper bound, valid even at zero. -/
theorem dyadicDepth_le_logb (n : ℕ) :
    (dyadicDepth n : ℝ) ≤ Real.logb 2 (3 * (n : ℝ)) + 1 := by
  have h := Real.natLog_le_logb (3 * n) 2
  push_cast at h ⊢
  simpa [dyadicDepth] using add_le_add_right h 1

/-- The dyadic depth grows at most logarithmically along the natural numbers. -/
theorem dyadicDepth_isBigO_log :
    (fun n : ℕ => (dyadicDepth n : ℝ)) =O[Filter.atTop]
      (fun n : ℕ => Real.log (n : ℝ)) := by
  have hdom : (fun n : ℕ => (dyadicDepth n : ℝ)) =O[Filter.atTop]
      (fun n : ℕ => Real.logb 2 (3 * (n : ℝ)) + 1) := by
    apply Asymptotics.IsBigO.of_bound'
    exact Filter.Eventually.of_forall fun n => by
      rw [Real.norm_of_nonneg (Nat.cast_nonneg _), Real.norm_eq_abs]
      exact (dyadicDepth_le_logb n).trans (le_abs_self _)
  have hlog : (fun x : ℝ => Real.logb 2 (3 * x)) =O[Filter.atTop] Real.log :=
    Real.isBigO_logb_const_mul_log_atTop 3
  have hone : (fun _ : ℝ => (1 : ℝ)) =O[Filter.atTop] Real.log :=
    Real.isLittleO_const_log_atTop.isBigO
  exact hdom.trans ((hlog.add hone).comp_tendsto tendsto_natCast_atTop_atTop)

end JSP092
