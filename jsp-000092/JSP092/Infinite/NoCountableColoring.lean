import JSP092.Infinite.NestedFibers
import Mathlib.Combinatorics.SimpleGraph.Coloring.Vertex

/-! # The monochromatic-edge construction

The six coordinates are selected in the order x₀, x₁, y₀, x₂, y₁, y₂.
Their strict inequalities give exactly the required XXYXYY adjacency.
-/

namespace JSP092

/-- Every coloring of the ordinal triple graph by natural numbers has a
monochromatic edge. -/
theorem exists_monochromatic_edge (c : Triple Omega → ℕ) :
    ∃ x y, (speckerGraph Omega).Adj x y ∧ c x = c y := by
  classical
  obtain ⟨i, hA⟩ := exists_unbounded_firstFiber c
  obtain ⟨x₀, hx₀, _⟩ := hA (Classical.arbitrary Omega)
  obtain ⟨x₁, hx₁, hx₀x₁⟩ := hx₀ x₀
  obtain ⟨y₀, hy₀, hx₁y₀⟩ := hA x₁
  obtain ⟨x₂, hx₂, hy₀x₂⟩ := hx₁.2 y₀
  obtain ⟨y₁, hy₁, hx₂y₁⟩ := hy₀ x₂
  obtain ⟨y₂, hy₂, hy₁y₂⟩ := hy₁.2 y₁
  let x : Triple Omega := ⟨x₀, x₁, x₂, hx₀x₁, hx₂.2.1⟩
  let y : Triple Omega := ⟨y₀, y₁, y₂, hy₁.1, hy₁y₂⟩
  refine ⟨x, y, Or.inl ⟨hx₁y₀, hy₀x₂, hx₂y₁⟩, ?_⟩
  have hcx : c x = i := by
    exact (paint_mk c x₀ x₁ x₂ hx₀x₁ hx₂.2.1).symm.trans hx₂.2.2
  have hcy : c y = i := by
    exact (paint_mk c y₀ y₁ y₂ hy₁.1 hy₁y₂).symm.trans hy₂.2.2
  exact hcx.trans hcy.symm

/-- In particular there is no proper coloring by natural numbers. -/
theorem no_nat_coloring : IsEmpty ((speckerGraph Omega).Coloring ℕ) := by
  refine ⟨fun c => ?_⟩
  obtain ⟨x, y, hxy, hc⟩ := exists_monochromatic_edge c
  exact (c.valid hxy) hc

end JSP092
