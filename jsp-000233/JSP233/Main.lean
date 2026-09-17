import FormalConjectures.ErdosProblems.«272»
import JSP233.Intersect
/-! The verified Szabó family and its extremal lower bound. -/
set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true
open Finset
namespace JSP233

theorem base_subset_ground (N : ℕ) (hN : 1 ≤ N)
    (S : Finset ℕ) (hS : S ∈ baseFamily N) :
    S ⊆ Finset.Icc 1 N := by
  have hc : center N ∈ Finset.Icc 1 N :=
    Finset.mem_Icc.mpr (center_bounds N hN)
  simp only [baseFamily, Finset.mem_insert] at hS
  rcases hS with h | h
  · rw [h]
    simpa using hc
  · obtain ⟨P, hP, hEq⟩ := Finset.mem_image.mp h
    rw [← hEq]
    exact Finset.insert_subset hc (Finset.mem_powersetCard.mp hP).1

theorem added_subset_ground (N : ℕ) (hN : 1 ≤ N)
    (S : Finset ℕ) (hS : S ∈ addedFamily N) :
    S ⊆ Finset.Icc 1 N := by
  obtain ⟨d, hd, hS⟩ := Finset.mem_biUnion.mp hS
  exact (addedAt_sub_five N d S hS).trans (five_subset_ground N d hN hd)

theorem szabo_family_feasible (N : ℕ) (hN : 1 ≤ N) :
    Erdos272.IsArithInterSet N (szaboFamily N) := by
  constructor
  · intro S hS
    rcases Finset.mem_union.mp hS with hbase | hadd
    · exact Finset.mem_powerset.mpr
        (base_subset_ground N hN S (Finset.mem_sdiff.mp hbase).1)
    · exact Finset.mem_powerset.mpr (added_subset_ground N hN S hadd)
  · intro S hS T hT hne
    rcases Finset.mem_union.mp hS with hSbase | hSadd
    · rcases Finset.mem_union.mp hT with hTbase | hTadd
      · exact distinct_base_inter_ap N S T (Finset.mem_sdiff.mp hSbase).1
          (Finset.mem_sdiff.mp hTbase).1 hne
      · obtain ⟨d, hd, hTd⟩ := Finset.mem_biUnion.mp hTadd
        exact base_added_inter_ap N d hd S T hSbase hTd
    · rcases Finset.mem_union.mp hT with hTbase | hTadd
      · obtain ⟨d, hd, hSd⟩ := Finset.mem_biUnion.mp hSadd
        obtain ⟨l, hl, hAP⟩ := base_added_inter_ap N d hd T S hTbase hSd
        exact ⟨l, hl, by simpa only [Finset.inter_comm] using hAP⟩
      · obtain ⟨d, hd, hSd⟩ := Finset.mem_biUnion.mp hSadd
        obtain ⟨e, he, hTe⟩ := Finset.mem_biUnion.mp hTadd
        exact addedAt_inter_ap N d e hd he S T hSd hTe

/-- Szabó's exact family count, as stated in Section 5 of the paper. -/
theorem szabo_family (N : ℕ) (hN : 1 ≤ N) :
    ∃ C : Finset (Finset ℕ), Erdos272.IsArithInterSet N C ∧
      C.card = N.choose 2 + 1 + (N - 1) / 4 := by
  exact ⟨szaboFamily N, szabo_family_feasible N hN, szaboFamily_card N hN⟩

/-- The resulting lower bound for the extremal function in Formal Conjectures. -/
theorem szabo_lower_bound (N : ℕ) (hN : 1 ≤ N) :
    N.choose 2 + 1 + (N - 1) / 4 ≤ Erdos272.maxArithInterCard N := by
  obtain ⟨C, hC, hcard⟩ := szabo_family N hN
  have hbdd : BddAbove {#A | (A : Finset (Finset ℕ)) (_ : Erdos272.IsArithInterSet N A)} := by
    refine ⟨((Finset.Icc 1 N).powerset).card, ?_⟩
    rintro v ⟨A, hA, rfl⟩
    exact Finset.card_le_card hA.1
  have hmem : C.card ∈ {#A | (A : Finset (Finset ℕ))
      (_ : Erdos272.IsArithInterSet N A)} := ⟨C, hC, rfl⟩
  rw [← hcard]
  exact le_csSup hbdd hmem

end JSP233
