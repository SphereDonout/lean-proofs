import JSP233.Family
/-! The new four- and five-point windows as arithmetic progressions. -/
set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true
namespace JSP233

theorem five_eq_prog (N d : ℕ) (h : 2 * d ≤ center N) :
    five N d = prog (center N - 2 * d) d 5 := by
  ext x
  simp only [five, prog, Finset.mem_insert, Finset.mem_singleton,
    Finset.mem_image, Finset.mem_range]
  constructor
  · intro hx
    rcases hx with h₀ | h₁ | h₂ | h₃ | h₄
    · exact ⟨0, by norm_num, by omega⟩
    · exact ⟨1, by norm_num, by omega⟩
    · exact ⟨2, by norm_num, by omega⟩
    · exact ⟨3, by norm_num, by omega⟩
    · exact ⟨4, by norm_num, by omega⟩
  · rintro ⟨i, hi, rfl⟩
    interval_cases i <;> omega

theorem leftFour_eq_prog (N d : ℕ) (h : 2 * d ≤ center N) :
    leftFour N d = prog (center N - 2 * d) d 4 := by
  ext x
  simp only [leftFour, prog, Finset.mem_insert, Finset.mem_singleton,
    Finset.mem_image, Finset.mem_range]
  constructor
  · intro hx
    rcases hx with h₀ | h₁ | h₂ | h₃
    · exact ⟨0, by norm_num, by omega⟩
    · exact ⟨1, by norm_num, by omega⟩
    · exact ⟨2, by norm_num, by omega⟩
    · exact ⟨3, by norm_num, by omega⟩
  · rintro ⟨i, hi, rfl⟩
    interval_cases i <;> omega

theorem rightFour_eq_prog (N d : ℕ) (h : d ≤ center N) :
    rightFour N d = prog (center N - d) d 4 := by
  ext x
  simp only [rightFour, prog, Finset.mem_insert, Finset.mem_singleton,
    Finset.mem_image, Finset.mem_range]
  constructor
  · intro hx
    rcases hx with h₀ | h₁ | h₂ | h₃
    · exact ⟨0, by norm_num, by omega⟩
    · exact ⟨1, by norm_num, by omega⟩
    · exact ⟨2, by norm_num, by omega⟩
    · exact ⟨3, by norm_num, by omega⟩
  · rintro ⟨i, hi, rfl⟩
    interval_cases i <;> omega

theorem five_card (N d : ℕ) (hd : d ∈ steps N) :
    (five N d).card = 5 := by
  rw [five_eq_prog N d (window_order N d (step_pos hd) (step_le hd)).1,
    prog_card _ _ _ (by have := step_pos hd; omega : 0 < d)]

theorem leftFour_card (N d : ℕ) (hd : d ∈ steps N) :
    (leftFour N d).card = 4 := by
  rw [leftFour_eq_prog N d (window_order N d (step_pos hd) (step_le hd)).1,
    prog_card _ _ _ (by have := step_pos hd; omega : 0 < d)]

theorem rightFour_card (N d : ℕ) (hd : d ∈ steps N) :
    (rightFour N d).card = 4 := by
  have hc : d ≤ center N := by
    have := (window_order N d (step_pos hd) (step_le hd)).1
    omega
  rw [rightFour_eq_prog N d hc, prog_card _ _ _ (by have := step_pos hd; omega : 0 < d)]

theorem five_ap (N d : ℕ) (hd : d ∈ steps N) :
    ((five N d : Finset ℕ) : Set ℕ).IsAPOfLength 5 := by
  rw [five_eq_prog N d (window_order N d (step_pos hd) (step_le hd)).1]
  exact prog_ap _ _ _ (by have := step_pos hd; omega : 0 < d)

theorem leftFour_ap (N d : ℕ) (hd : d ∈ steps N) :
    ((leftFour N d : Finset ℕ) : Set ℕ).IsAPOfLength 4 := by
  rw [leftFour_eq_prog N d (window_order N d (step_pos hd) (step_le hd)).1]
  exact prog_ap _ _ _ (by have := step_pos hd; omega : 0 < d)

theorem rightFour_ap (N d : ℕ) (hd : d ∈ steps N) :
    ((rightFour N d : Finset ℕ) : Set ℕ).IsAPOfLength 4 := by
  have hc : d ≤ center N := by
    have := (window_order N d (step_pos hd) (step_le hd)).1
    omega
  rw [rightFour_eq_prog N d hc]
  exact prog_ap _ _ _ (by have := step_pos hd; omega : 0 < d)

end JSP233
