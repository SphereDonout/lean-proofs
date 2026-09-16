import JSP924
import Mathlib.Data.Fintype.Card

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

/-! Focused checks of the endpoints and the finite/exceptional partition. -/

namespace JSP924Checks

/-- The parameter-zero specialization retains every natural exponent. -/
theorem parameter_zero (n : ℕ) :
    ∃ d : ℕ, 1 < d ∧ d < 734110615000775 ^ 4 * 2 ^ n + 1 ∧
      d ∣ 734110615000775 ^ 4 * 2 ^ n + 1 := by
  exact JSP924.named_witness_composite n

/-- At exponent zero the fixed witness is already a proper divisor for all roots. -/
theorem exponent_zero_witness (t : ℕ) :
    1 < 6700417 ∧
      6700417 < (734110615000775 + 36893488147419103230 * t) ^ 4 + 1 ∧
      6700417 ∣ (734110615000775 + 36893488147419103230 * t) ^ 4 + 1 := by
  have hmem : 6700417 ∈ JSP924.coverDivisors := by
    norm_num [JSP924.coverDivisors]
  obtain ⟨hgt, hlt, hstep, _⟩ := JSP924.cover_data 6700417 hmem
  have hbase : Nat.ModEq 6700417 (JSP924.seed ^ 4 + 1) 0 := by
    norm_num [Nat.ModEq, JSP924.seed]
  have hdiv : 6700417 ∣ JSP924.root t ^ 4 + 1 :=
    Nat.modEq_zero_iff_dvd.mp
      ((((JSP924.root_modEq_seed t 6700417 hstep).pow 4).add
        (Nat.ModEq.refl 1)).trans hbase)
  have hproper : 6700417 < JSP924.root t ^ 4 + 1 := by
    simpa only [JSP924.value, pow_zero, Nat.mul_one] using
      hlt.trans (JSP924.seed_lt_value t 0)
  simpa only [JSP924.root, JSP924.seed, JSP924.step] using
    And.intro hgt (And.intro hproper hdiv)

/-- The first exceptional exponent is covered with quotient zero. -/
theorem exponent_two (t : ℕ) :
    ∃ d : ℕ, 1 < d ∧
      d < (734110615000775 + 36893488147419103230 * t) ^ 4 * 2 ^ 2 + 1 ∧
      d ∣ (734110615000775 + 36893488147419103230 * t) ^ 4 * 2 ^ 2 + 1 := by
  simpa only [JSP924.Composite, JSP924.value, JSP924.root,
    JSP924.seed, JSP924.step] using
      JSP924.exceptional_composite t 2 (by decide)

/-- Removing the strict factorization hypothesis would include this prime. -/
theorem sophie_at_one_prime : Nat.Prime (4 * (1 : ℕ) ^ 4 + 1) := by
  decide

theorem sophie_at_one_not_composite :
    ¬ JSP924.Composite (4 * (1 : ℕ) ^ 4 + 1) := by
  intro h
  exact JSP924.composite_not_prime h sophie_at_one_prime

theorem covered_residue_count :
    (Finset.univ.filter (fun r : Fin 64 => r.val % 4 ≠ 2)).card = 48 := by
  decide

theorem exceptional_residue_count :
    (Finset.univ.filter (fun r : Fin 64 => r.val % 4 = 2)).card = 16 := by
  decide

end JSP924Checks
