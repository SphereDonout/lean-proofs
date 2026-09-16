import JSP924.Basic
import Mathlib.Data.Nat.ModEq

/-! Symbolic congruence transport for the fixed progression and period 64. -/

namespace JSP924

theorem root_modEq_seed (t d : ℕ) (hd : d ∣ step) :
    Nat.ModEq d (root t) seed := by
  unfold root
  simpa only [Nat.add_comm] using
    (Nat.ModEq.modulus_mul_add (m := step) (a := t) (b := seed)).of_dvd hd

theorem two_pow_mod64 (d n : ℕ)
    (hperiod : Nat.ModEq d (2 ^ 64) 1) :
    Nat.ModEq d (2 ^ n) (2 ^ (n % 64)) := by
  calc
    2 ^ n = 2 ^ (n % 64) * (2 ^ 64) ^ (n / 64) := by
      rw [← pow_mul, ← pow_add, Nat.mod_add_div]
    _ ≡ 2 ^ (n % 64) * 1 ^ (n / 64) [MOD d] :=
      (Nat.ModEq.refl _).mul (hperiod.pow _)
    _ = 2 ^ (n % 64) := by simp

theorem value_modEq_residue (t n d : ℕ)
    (hd : d ∣ step) (hperiod : Nat.ModEq d (2 ^ 64) 1) :
    Nat.ModEq d (value t n) (seed ^ 4 * 2 ^ (n % 64) + 1) := by
  exact (((root_modEq_seed t d hd).pow 4).mul
    (two_pow_mod64 d n hperiod)).add (Nat.ModEq.refl 1)

end JSP924
