import Mathlib.Order.Filter.AtTopBot.Basic
import Mathlib.Tactic

/-! # Countable covers of unbounded sets

The cover need not be a partition: its members may overlap.
-/

namespace JSP092

universe u
variable {α : Type u} [LinearOrder α]

/-- Members occur strictly above every proposed bound. -/
def UnboundedAbove (S : Set α) : Prop := ∀ a, ∃ b ∈ S, a < b

theorem unboundedAbove_univ [NoMaxOrder α] : UnboundedAbove (Set.univ : Set α) := by
  intro a
  obtain ⟨b, hab⟩ := exists_gt a
  exact ⟨b, Set.mem_univ _, hab⟩

theorem unboundedAbove_Ioi [NoMaxOrder α] (a : α) :
    UnboundedAbove (Set.Ioi a) := by
  intro b
  obtain ⟨c, hc⟩ := exists_gt (max a b)
  exact ⟨c, lt_of_le_of_lt (le_max_left _ _) hc,
    lt_of_le_of_lt (le_max_right _ _) hc⟩

/-- A countable cover of an unbounded set contains an unbounded member. -/
theorem exists_unboundedAbove_of_countable_cover
    (sequence_bounded : ∀ f : ℕ → α, ∃ b, ∀ i, f i ≤ b)
    {S : Set α} {T : ℕ → Set α} (hS : UnboundedAbove S)
    (hcover : ∀ a ∈ S, ∃ i, a ∈ T i) :
    ∃ i, UnboundedAbove (T i) := by
  classical
  by_contra! h
  have hb : ∀ i, ∃ b, ∀ a ∈ T i, a ≤ b := by
    intro i
    have hi := h i
    simp only [UnboundedAbove, not_forall, not_exists, not_and, not_lt] at hi
    exact hi
  choose b hb using hb
  obtain ⟨c, hc⟩ := sequence_bounded b
  obtain ⟨a, ha, hca⟩ := hS c
  obtain ⟨i, hi⟩ := hcover a ha
  exact (not_lt_of_ge ((hb i a hi).trans (hc i))) hca

end JSP092
