import JSP092.Basic
import Mathlib.Data.Finset.Sort

/-!
# Finite coordinate support and increasing ranks

Only coordinates used by the specified finite set of vertices are ranked.
Shared coordinates remain shared, and the construction needs no nonemptiness assumption.
-/

namespace JSP092

universe u
variable {α : Type u} [LinearOrder α]

noncomputable def coordinateSupport (W : Finset (Triple α)) : Finset α := by
  classical
  exact W.image Triple.a ∪ W.image Triple.b ∪ W.image Triple.c

theorem a_mem_coordinateSupport {W : Finset (Triple α)} {x : Triple α} (hx : x ∈ W) :
    x.a ∈ coordinateSupport W := by
  classical
  simp only [coordinateSupport, Finset.mem_union]
  exact Or.inl (Or.inl (Finset.mem_image.mpr ⟨x, hx, rfl⟩))

theorem b_mem_coordinateSupport {W : Finset (Triple α)} {x : Triple α} (hx : x ∈ W) :
    x.b ∈ coordinateSupport W := by
  classical
  simp only [coordinateSupport, Finset.mem_union]
  exact Or.inl (Or.inr (Finset.mem_image.mpr ⟨x, hx, rfl⟩))

theorem c_mem_coordinateSupport {W : Finset (Triple α)} {x : Triple α} (hx : x ∈ W) :
    x.c ∈ coordinateSupport W := by
  classical
  simp only [coordinateSupport, Finset.mem_union]
  exact Or.inr (Finset.mem_image.mpr ⟨x, hx, rfl⟩)

theorem coordinateSupport_card_le (W : Finset (Triple α)) :
    (coordinateSupport W).card ≤ 3 * W.card := by
  classical
  calc
    (coordinateSupport W).card ≤
        (W.image Triple.a ∪ W.image Triple.b).card + (W.image Triple.c).card :=
      Finset.card_union_le _ _
    _ ≤ ((W.image Triple.a).card + (W.image Triple.b).card) + (W.image Triple.c).card :=
      Nat.add_le_add_right (Finset.card_union_le _ _) _
    _ ≤ (W.card + W.card) + W.card :=
      Nat.add_le_add (Nat.add_le_add (Finset.card_image_le) (Finset.card_image_le))
        (Finset.card_image_le)
    _ = 3 * W.card := by omega

/-- The increasing zero-based rank on the finite coordinate support. -/
noncomputable def coordinateRank (W : Finset (Triple α)) :
    coordinateSupport W ≃o Fin (coordinateSupport W).card :=
  ((coordinateSupport W).orderIsoOfFin rfl).symm

/-- The original vertex represented by its three coordinate ranks. -/
noncomputable def rankedTriple (W : Finset (Triple α)) (x : W) :
    Triple (Fin (coordinateSupport W).card) where
  a := coordinateRank W ⟨x.val.a, a_mem_coordinateSupport x.property⟩
  b := coordinateRank W ⟨x.val.b, b_mem_coordinateSupport x.property⟩
  c := coordinateRank W ⟨x.val.c, c_mem_coordinateSupport x.property⟩
  ab := (coordinateRank W).strictMono x.val.ab
  bc := (coordinateRank W).strictMono x.val.bc

theorem rankedTriple_up {W : Finset (Triple α)} {x y : W} (h : Up x.val y.val) :
    Up (rankedTriple W x) (rankedTriple W y) :=
  ⟨(coordinateRank W).strictMono h.1, (coordinateRank W).strictMono h.2.1,
    (coordinateRank W).strictMono h.2.2⟩

theorem rankedTriple_adj {W : Finset (Triple α)} {x y : W}
    (h : (speckerGraph α).Adj x.val y.val) :
    (speckerGraph (Fin (coordinateSupport W).card)).Adj (rankedTriple W x) (rankedTriple W y) := by
  rcases h with h | h
  · exact Or.inl (rankedTriple_up h)
  · exact Or.inr (rankedTriple_up h)

end JSP092
