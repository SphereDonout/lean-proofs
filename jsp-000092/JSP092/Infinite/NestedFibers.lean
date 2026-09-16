import JSP092.Basic
import JSP092.Infinite.Carrier
import JSP092.Infinite.CountableCover

/-! # The three nested unbounded color fibers

This is the countable-coloring argument for the XXYXYY triple graph from the
mathematical note attached to awards issue 110. No properness assumption is
needed to construct the fibers.
-/

namespace JSP092

/-- Extend a coloring to all coordinate triples. The fallback value is irrelevant
because the fibers and the final vertices use increasing coordinates. -/
noncomputable def paint (c : Triple Omega → ℕ) (a b z : Omega) : ℕ :=
  if hab : a < b then if hbz : b < z then c ⟨a, b, z, hab, hbz⟩ else 0 else 0

@[simp] theorem paint_mk (c : Triple Omega → ℕ) (a b z : Omega)
    (hab : a < b) (hbz : b < z) :
    paint c a b z = c ⟨a, b, z, hab, hbz⟩ := by
  simp [paint, hab, hbz]

/-- The third-coordinate fiber, including both order guards. -/
def thirdFiber (c : Triple Omega → ℕ) (i : ℕ) (a b : Omega) : Set Omega :=
  {z | a < b ∧ b < z ∧ paint c a b z = i}

/-- The second coordinates for which the corresponding third fiber is unbounded. -/
def secondFiber (c : Triple Omega → ℕ) (i : ℕ) (a : Omega) : Set Omega :=
  {b | a < b ∧ UnboundedAbove (thirdFiber c i a b)}

/-- The first coordinates for which the corresponding second fiber is unbounded. -/
def firstFiber (c : Triple Omega → ℕ) (i : ℕ) : Set Omega :=
  {a | UnboundedAbove (secondFiber c i a)}

theorem exists_unbounded_thirdFiber (c : Triple Omega → ℕ) {a b : Omega}
    (hab : a < b) : ∃ i, UnboundedAbove (thirdFiber c i a b) := by
  apply exists_unboundedAbove_of_countable_cover omega_sequence_bounded
    (unboundedAbove_Ioi b)
  intro z hbz
  exact ⟨paint c a b z, hab, hbz, rfl⟩

theorem exists_unbounded_secondFiber (c : Triple Omega → ℕ) (a : Omega) :
    ∃ i, UnboundedAbove (secondFiber c i a) := by
  apply exists_unboundedAbove_of_countable_cover omega_sequence_bounded
    (unboundedAbove_Ioi a)
  intro b hab
  obtain ⟨i, hi⟩ := exists_unbounded_thirdFiber c hab
  exact ⟨i, hab, hi⟩

/-- One color is fixed before any coordinates of the monochromatic edge are chosen. -/
theorem exists_unbounded_firstFiber (c : Triple Omega → ℕ) :
    ∃ i, UnboundedAbove (firstFiber c i) := by
  apply exists_unboundedAbove_of_countable_cover omega_sequence_bounded
    (unboundedAbove_univ (α := Omega))
  intro a _
  exact exists_unbounded_secondFiber c a

end JSP092
