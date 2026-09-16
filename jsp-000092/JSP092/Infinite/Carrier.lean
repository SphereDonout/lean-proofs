import Mathlib.SetTheory.Cardinal.Regular

/-!
# The small carrier of countable ordinals

The carrier is an ordinal's `ToType`, so it belongs to `Type`, rather than the
larger universe of a subtype of all ordinals. Countable boundedness uses the
regularity theorem already proved in Mathlib.
-/

namespace JSP092

open Cardinal Ordinal

abbrev Omega : Type := (Cardinal.aleph.{0} 1).ord.ToType

@[simp] theorem cardinal_omega : Cardinal.mk Omega = Cardinal.aleph 1 :=
  Cardinal.mk_ord_toType _

instance omega_nonempty : Nonempty Omega :=
  Cardinal.nonempty_ord_toType (Cardinal.aleph_pos 1).ne'

instance omega_noMaxOrder : NoMaxOrder Omega :=
  Cardinal.noMaxOrder (by simp)

/-- Every countable sequence of countable ordinals has a countable upper bound. -/
theorem omega_sequence_bounded (f : ℕ → Omega) :
    ∃ b : Omega, ∀ i, f i ≤ b := by
  let g : ℕ → Ordinal := fun i => (f i).toOrd.val
  have hg : (⨆ i, g i) < (Cardinal.aleph.{0} 1).ord := by
    rw [Cardinal.ord_aleph]
    apply Ordinal.iSup_lt_omega_one
    intro i
    simpa only [g, Set.mem_Iio, Cardinal.ord_aleph] using (f i).toOrd.property
  refine ⟨Ordinal.ToType.mk ⟨⨆ i, g i, hg⟩, ?_⟩
  intro i
  have hi : (f i).toOrd ≤ ⟨⨆ i, g i, hg⟩ := Ordinal.le_iSup g i
  have hmap := Ordinal.ToType.mk.monotone hi
  simpa only [OrderIso.apply_symm_apply] using hmap

/-- A chosen larger element; monotonicity is neither claimed nor required. -/
noncomputable def omegaNext (a : Omega) : Omega := Classical.choose (exists_gt a)

theorem lt_omegaNext (a : Omega) : a < omegaNext a :=
  Classical.choose_spec (exists_gt a)

end JSP092
