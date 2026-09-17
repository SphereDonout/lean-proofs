import Mathlib.Data.Real.Basic
import Mathlib.Data.Finset.Max
import Mathlib.Order.Interval.Finset.Nat
import Mathlib.Tactic.Linarith

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

namespace JSP737

/-- A finite set of natural numbers in a real interval has cardinality at most
the interval's length plus one. -/
theorem nat_card_le_interval (s : Finset ℕ) (a b : ℝ) (hab : a ≤ b)
    (hmem : ∀ k ∈ s, a ≤ (k : ℝ) ∧ (k : ℝ) ≤ b) :
    (s.card : ℝ) ≤ b - a + 1 := by
  classical
  obtain hs | hs := s.eq_empty_or_nonempty
  · subst s
    simp only [Finset.card_empty, Nat.cast_zero]
    linarith
  · have hminmax : s.min' hs ≤ s.max' hs := s.min'_le_max' hs
    have hsub : s ⊆ Finset.Icc (s.min' hs) (s.max' hs) := by
      intro k hk
      exact Finset.mem_Icc.mpr ⟨s.min'_le k hk, s.le_max' k hk⟩
    have hcard := Finset.card_le_card hsub
    rw [Nat.card_Icc] at hcard
    have hcard_real : (s.card : ℝ) ≤ ((s.max' hs : ℕ) : ℝ) + 1 -
        ((s.min' hs : ℕ) : ℝ) := by
      have hcast : (s.card : ℝ) ≤ ((s.max' hs + 1 - s.min' hs : ℕ) : ℝ) :=
        Nat.cast_le.mpr hcard
      rw [Nat.cast_sub (hminmax.trans (Nat.le_succ _)), Nat.cast_succ] at hcast
      exact hcast
    have hmin := (hmem _ (s.min'_mem hs)).1
    have hmax := (hmem _ (s.max'_mem hs)).2
    linarith

end JSP737
