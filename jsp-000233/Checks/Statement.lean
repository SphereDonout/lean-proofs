import JSP233

/-!
Independent transcription of Szabó's Section 5 finite construction.
This module checks that the exported theorem implies the source statement.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

namespace Checks

/-- The paper's family condition, phrased without `Erdos272.IsArithInterSet`. -/
def PaperFamily (N : ℕ) (C : Finset (Finset ℕ)) : Prop :=
  (∀ A ∈ C, A ⊆ Finset.Icc 1 N) ∧
  (∀ A ∈ C, ∀ B ∈ C, A ≠ B →
    ∃ l : ℕ∞, 0 < l ∧ ((A ∩ B : Finset ℕ) : Set ℕ).IsAPOfLength l)

theorem statement_check (N : ℕ) (hN : 1 ≤ N) :
    ∃ C : Finset (Finset ℕ), PaperFamily N C ∧
      C.card = N.choose 2 + 1 + (N - 1) / 4 := by
  obtain ⟨C, hC, hcard⟩ := JSP233.szabo_family N hN
  refine ⟨C, ?_, hcard⟩
  constructor
  · intro A hA
    exact Finset.mem_powerset.mp (hC.1 hA)
  · intro A hA B hB hne
    exact hC.2 hA hB hne

end Checks
