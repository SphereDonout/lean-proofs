import JSP092.Finite.Support
import JSP092.Finite.DyadicColoring

/-! # Transport dyadic colorings to arbitrary finite vertex sets -/

namespace JSP092

universe u
variable {α : Type u} [LinearOrder α]

/-- A proper coloring on the original finite set, obtained by increasing ranks
and inclusion of its coordinate support into a dyadic interval. -/
noncomputable def finiteDyadicColoring (W : Finset (Triple α)) (k : ℕ)
    (hcover : 3 * W.card ≤ 2 ^ k) :
    ((speckerGraph α).induce (W : Set (Triple α))).Coloring (Fin k × Bool) := by
  let incl : Fin (coordinateSupport W).card ↪o Fin (2 ^ k) :=
    Fin.castLEOrderEmb ((coordinateSupport_card_le W).trans hcover)
  apply SimpleGraph.Coloring.mk
    (fun x => dyadicColoring k ((rankedTriple W x).map incl incl.strictMono))
  intro x y hxy
  exact (dyadicColoring k).valid (Triple.map_adj incl incl.strictMono (rankedTriple_adj hxy))

end JSP092
