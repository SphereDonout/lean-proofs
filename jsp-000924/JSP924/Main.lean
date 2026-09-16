import JSP924.Universal
import Mathlib.Data.Set.Finite.Basic

/-!
The published Izotov construction yields infinitely many distinct fourth-power
Sierpiński numbers. This asserts no absence of a finite prime cover.
-/

namespace JSP924

theorem family_value_not_prime (t n : ℕ) : ¬ Nat.Prime (value t n) :=
  composite_not_prime (family_value_composite t n)

theorem fourth_family_injective :
    Function.Injective (fun t : ℕ => root t ^ 4) := by
  apply (Nat.pow_left_injective (by decide : 4 ≠ 0)).comp
  intro t u h
  exact Nat.eq_of_mul_eq_mul_left (by norm_num [step] : 0 < step)
    (Nat.add_left_cancel h)

theorem family_sierpinski (t : ℕ) : Sierpinski (root t ^ 4) := by
  have hr : 0 < root t := by have h := root_gt_one t; omega
  refine ⟨pow_pos hr 4, (root_odd t).pow, ?_⟩
  intro n _
  exact family_value_composite t n

theorem infinitely_many_fourth_power_sierpinski :
    Set.Infinite {k : ℕ | Sierpinski k ∧ ∃ l : ℕ, k = l ^ 4} := by
  apply Set.infinite_of_injective_forall_mem fourth_family_injective
  intro t
  exact ⟨family_sierpinski t, root t, rfl⟩

end JSP924
