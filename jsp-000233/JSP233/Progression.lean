import FormalConjecturesForMathlib.Combinatorics.AP.Basic
import Mathlib

/-!
Finite arithmetic progressions with the exact predicate used by Formal Conjectures.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

namespace JSP233

/-- The finite set of `l` consecutive terms starting at `a` with step `d`. -/
def prog (a d l : ℕ) : Finset ℕ :=
  (Finset.range l).image (fun i => a + i * d)

theorem prog_card (a d l : ℕ) (hd : 0 < d) : (prog a d l).card = l := by
  have hinj : Set.InjOn (fun i => a + i * d) (Finset.range l : Set ℕ) := by
    intro i hi j hj hij
    have hmul : i * d = j * d := Nat.add_left_cancel hij
    exact Nat.mul_right_cancel hd hmul
  simpa only [prog, Finset.card_range] using (Finset.card_image_iff.mpr hinj)

theorem prog_ap (a d l : ℕ) (hd : 0 < d) :
    ((prog a d l : Finset ℕ) : Set ℕ).IsAPOfLength (l : ℕ∞) := by
  refine ⟨a, d, ?_, ?_⟩
  · change (↑(prog a d l) : Set ℕ).encard = (l : ℕ∞)
    rw [Set.encard_coe_eq_coe_finsetCard, prog_card a d l hd]
  · ext x
    simp only [prog, Finset.mem_image, Finset.mem_range, SetLike.mem_coe]
    constructor
    · rintro ⟨i, hi, rfl⟩
      exact ⟨i, by simpa using hi, by simp⟩
    · rintro ⟨i, hi, rfl⟩
      exact ⟨i, by simpa using hi, by simp⟩

end JSP233
