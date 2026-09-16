import Mathlib.Combinatorics.SimpleGraph.Coloring.Vertex
import Mathlib.Combinatorics.Pigeonhole
import Mathlib.Tactic.ByContra

/-!
# An independent color fiber with an integral size bound

The coloring is on the original finite vertex set. The resulting set is
independent in the ambient graph, not merely in a chosen subgraph.
-/

namespace JSP092

universe u v
variable {V : Type u} {C : Type v}

/-- A finite induced coloring has a color fiber at least as large as the average.
The conclusion also holds for an empty palette: the existence of the coloring
then forces the vertex set to be empty. -/
theorem independent_fiber_card_bound (G : SimpleGraph V) (W : Finset V) [Fintype C]
    (coloring : (G.induce (W : Set V)).Coloring C) :
    ∃ I : Finset V, I ⊆ W ∧ G.IsIndepSet (I : Set V) ∧
      W.card ≤ Fintype.card C * I.card := by
  classical
  by_cases hW : W = ∅
  · subst W
    exact ⟨∅, Finset.Subset.refl _, by simp, by simp⟩
  have hWnonempty : W.Nonempty := Finset.nonempty_iff_ne_empty.mpr hW
  obtain ⟨x, hx⟩ := hWnonempty
  let defaultColor : C := coloring ⟨x, hx⟩
  let color : V → C := fun v => if hv : v ∈ W then coloring ⟨v, hv⟩ else defaultColor
  have color_apply (v : V) (hv : v ∈ W) : color v = coloring ⟨v, hv⟩ := by
    simp only [color, dif_pos hv]
  let fiber (c : C) : Finset V := W.filter (fun v => color v = c)
  obtain ⟨c, _, hc⟩ := Finset.exists_max_image (Finset.univ : Finset C)
    (fun c => (fiber c).card) ⟨defaultColor, Finset.mem_univ _⟩
  refine ⟨fiber c, Finset.filter_subset _ _, ?_, ?_⟩
  · intro v hv w hw _hvw hAdj
    have hv' := Finset.mem_filter.mp hv
    have hw' := Finset.mem_filter.mp hw
    apply coloring.valid (show (G.induce (W : Set V)).Adj ⟨v, hv'.1⟩ ⟨w, hw'.1⟩ from hAdj)
    rw [← color_apply v hv'.1, ← color_apply w hw'.1, hv'.2, hw'.2]
  · by_contra! hbound
    obtain ⟨d, hd, hlarge⟩ := Finset.exists_lt_card_fiber_of_mul_lt_card_of_maps_to
      (s := W) (t := Finset.univ) (f := color)
      (fun _ _ => Finset.mem_univ _) (by simpa using hbound)
    exact (not_lt_of_ge (hc d hd)) hlarge

end JSP092
