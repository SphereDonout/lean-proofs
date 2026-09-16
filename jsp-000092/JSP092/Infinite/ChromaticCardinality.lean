import JSP092.Infinite.NoCountableColoring
import JSP092.Infinite.VertexCardinality
import FormalConjecturesForMathlib.Combinatorics.SimpleGraph.Coloring.Vertex

/-! # Chromatic cardinality of the ordinal triple graph -/

namespace JSP092

open Cardinal

/-- The set occurring in the chromatic-cardinal definition is nonempty. -/
theorem specker_color_cardinals_nonempty :
    Set.Nonempty {κ : Cardinal | ∃ (C : Type) (_ : Cardinal.mk C = κ),
      Nonempty ((speckerGraph Omega).Coloring C)} := by
  refine ⟨Cardinal.mk (Triple Omega), Triple Omega, rfl, ?_⟩
  exact ⟨{ toFun := id, map_rel' := fun h => (speckerGraph Omega).ne_of_adj h }⟩

/-- Every realized proper color cardinal is at least aleph-one. -/
theorem aleph_one_le_color_cardinal (C : Type)
    (c : (speckerGraph Omega).Coloring C) :
    Cardinal.aleph 1 ≤ Cardinal.mk C := by
  by_contra! h
  have hcount : Cardinal.mk C ≤ Cardinal.aleph0 := by
    exact Cardinal.lt_aleph_one_iff.mp h
  have hnat : Cardinal.mk C ≤ Cardinal.mk ℕ := by simpa using hcount
  obtain ⟨e⟩ := (Cardinal.le_def C ℕ).mp hnat
  let d : (speckerGraph Omega).Coloring ℕ :=
    { toFun := fun x => e (c x)
      map_rel' := fun h => fun he => c.valid h (e.injective he) }
  exact no_nat_coloring.false d

/-- The Specker graph has chromatic cardinality exactly aleph-one. -/
theorem chromaticCardinal_specker_omega :
    (speckerGraph Omega).chromaticCardinal = Cardinal.aleph 1 := by
  unfold SimpleGraph.chromaticCardinal
  apply le_antisymm
  · calc
      _ ≤ Cardinal.mk (Triple Omega) := by
        apply csInf_le (OrderBot.bddBelow _)
        exact ⟨Triple Omega, rfl,
          ⟨{ toFun := id, map_rel' := fun h => (speckerGraph Omega).ne_of_adj h }⟩⟩
      _ = Cardinal.aleph 1 := cardinal_triple_omega
  · apply le_csInf specker_color_cardinals_nonempty
    rintro κ ⟨C, rfl, ⟨c⟩⟩
    exact aleph_one_le_color_cardinal C c

end JSP092
