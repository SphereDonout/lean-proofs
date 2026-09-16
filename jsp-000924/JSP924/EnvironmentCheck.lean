import Mathlib.Data.Nat.ModEq
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Set.Finite.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.NormNum.PowMod
import Mathlib.Tactic.NormNum.ModEq

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

#check Nat.ModEq.pow
#check Nat.ModEq.modulus_mul_add
#check Nat.mod_add_div
#check Nat.not_prime_of_dvd_of_lt
#check Nat.pow_left_injective
#check Nat.le_self_pow
#check Nat.one_le_pow
#check Set.infinite_of_injective_forall_mem

example : (2 : ℕ) ^ 64 % 641 = 1 := by norm_num
