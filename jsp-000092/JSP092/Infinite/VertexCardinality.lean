import JSP092.Basic
import JSP092.Infinite.Carrier
import Mathlib.SetTheory.Cardinal.Arithmetic

/-! # Cardinality of the ordinal triple graph

The first-coordinate projection proves injectivity of the lower-bound map.
For the upper bound, triples embed into three copies of the coordinate carrier.
-/

namespace JSP092

open Cardinal

/-- An injection of the coordinate carrier into the vertex type. -/
noncomputable def omegaToTriple (a : Omega) : Triple Omega :=
  ⟨a, omegaNext a, omegaNext (omegaNext a), lt_omegaNext a,
    lt_omegaNext (omegaNext a)⟩

theorem omegaToTriple_injective : Function.Injective omegaToTriple := by
  intro a b h
  exact congrArg Triple.a h

theorem tripleCoordinates_injective :
    Function.Injective (fun x : Triple Omega => (x.a, x.b, x.c)) := by
  intro x y h
  cases x
  cases y
  simp only [Prod.mk.injEq] at h
  rcases h with ⟨ha, hb, hc⟩
  subst_vars
  rfl

/-- The vertex cardinality is exactly aleph-one; both bounds are explicit. -/
@[simp] theorem cardinal_triple_omega :
    Cardinal.mk (Triple Omega) = Cardinal.aleph 1 := by
  apply le_antisymm
  · calc
      Cardinal.mk (Triple Omega) ≤ Cardinal.mk (Omega × Omega × Omega) :=
        Cardinal.mk_le_of_injective tripleCoordinates_injective
      _ = Cardinal.aleph 1 := by
        simp only [Cardinal.mk_prod, cardinal_omega]
        simp [Cardinal.mul_eq_self]
  · calc
      Cardinal.aleph 1 = Cardinal.mk Omega := cardinal_omega.symm
      _ ≤ Cardinal.mk (Triple Omega) :=
        Cardinal.mk_le_of_injective omegaToTriple_injective

end JSP092
