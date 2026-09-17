import JSP233.WindowAP
/-! Cardinality lemmas for the base and modified families. -/
set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true
namespace JSP233

theorem insert_center_inj (U : Finset ℕ) (c : ℕ) :
    Set.InjOn (fun P : Finset ℕ => insert c P) (U.powersetCard 2 : Set (Finset ℕ)) := by
  intro P hP Q hQ heq
  have hp2 : P.card = 2 := (Finset.mem_powersetCard.mp hP).2
  have hq2 : Q.card = 2 := (Finset.mem_powersetCard.mp hQ).2
  have hcards := congrArg Finset.card heq
  by_cases hp : c ∈ P
  · by_cases hq : c ∈ Q
    · simpa [Finset.insert_eq_of_mem hp, Finset.insert_eq_of_mem hq] using heq
    · simp [Finset.card_insert_of_notMem hq, Finset.insert_eq_of_mem hp, hp2, hq2] at hcards
  · by_cases hq : c ∈ Q
    · simp [Finset.card_insert_of_notMem hp, Finset.insert_eq_of_mem hq, hp2, hq2] at hcards
    · have herase := congrArg (fun S : Finset ℕ => S.erase c) heq
      simpa [Finset.erase_insert, Finset.erase_eq_self.mpr hp,
        Finset.erase_eq_self.mpr hq] using herase

theorem base_card (N : ℕ) :
    (baseFamily N).card = N.choose 2 + 1 := by
  have hU : (Finset.Icc 1 N).card = N := by
    simp [Nat.card_Icc]
  have h_image :
      ((((Finset.Icc 1 N).powersetCard 2).image (fun P => insert (center N) P)).card) =
        N.choose 2 := by
    rw [Finset.card_image_iff.mpr (insert_center_inj _ _), Finset.card_powersetCard, hU]
  have h_single :
      ({center N} : Finset ℕ) ∉
        ((Finset.Icc 1 N).powersetCard 2).image (fun P => insert (center N) P) := by
    intro h
    obtain ⟨P, hP, heq⟩ := Finset.mem_image.mp h
    have hp2 : P.card = 2 := (Finset.mem_powersetCard.mp hP).2
    by_cases hc : center N ∈ P
    · have : P = {center N} := by simpa [Finset.insert_eq_of_mem hc] using heq
      simp [this] at hp2
    · have hh := congrArg Finset.card heq
      simp [Finset.card_insert_of_notMem hc, hp2] at hh
  rw [baseFamily, Finset.card_insert_of_notMem h_single, h_image]

theorem badLeft_ne_badRight (N d : ℕ) (hd : 0 < d) :
    badLeft N d ≠ badRight N d := by
  intro heq
  have hmem : center N + d ∈ badRight N d := by
    rw [← heq]
    simp [badLeft]
  simp only [badRight, Finset.mem_insert, Finset.mem_singleton] at hmem
  omega

theorem excludedAt_card (N d : ℕ) (hd : 0 < d) :
    (excludedAt N d).card = 2 := by
  simp [excludedAt, Finset.card_insert_of_notMem, badLeft_ne_badRight N d hd]

theorem badLeft_inj (N d e : ℕ) (hd : 0 < d)
    (h : badLeft N d = badLeft N e) : d = e := by
  have hmem : center N + d ∈ badLeft N e := by
    rw [← h]
    simp [badLeft]
  simp only [badLeft, Finset.mem_insert, Finset.mem_singleton] at hmem
  omega

theorem badRight_inj (N d e : ℕ) (hd : 0 < d)
    (h : badRight N d = badRight N e) : d = e := by
  have hmem : center N + 2 * d ∈ badRight N e := by
    rw [← h]
    simp [badRight]
  simp only [badRight, Finset.mem_insert, Finset.mem_singleton] at hmem
  omega

theorem badLeft_ne_badRight_any (N d e : ℕ)
    (hd : 0 < d) (he : 0 < e) (hbound : 2 * d ≤ center N) :
    badLeft N d ≠ badRight N e := by
  intro h
  have hhi : center N + d ∈ badRight N e := by
    rw [← h]
    simp [badLeft]
  have hlo : center N - 2 * d ∈ badRight N e := by
    rw [← h]
    simp [badLeft]
  simp only [badRight, Finset.mem_insert, Finset.mem_singleton] at hhi hlo
  omega

theorem excludedAt_disjoint (N d e : ℕ)
    (hd : d ∈ steps N) (he : e ∈ steps N) (hde : d ≠ e) :
    Disjoint (excludedAt N d) (excludedAt N e) := by
  rw [Finset.disjoint_left]
  intro S hS hT
  simp only [excludedAt, Finset.mem_insert, Finset.mem_singleton] at hS hT
  have hboundd := (window_order N d (step_pos hd) (step_le hd)).1
  have hbounde := (window_order N e (step_pos he) (step_le he)).1
  rcases hS with rfl | rfl
  · rcases hT with h | h
    · exact hde (badLeft_inj N d e (by have := step_pos hd; omega) h)
    · exact badLeft_ne_badRight_any N d e
        (by have := step_pos hd; omega) (by have := step_pos he; omega) hboundd h
  · rcases hT with h | h
    · exact badLeft_ne_badRight_any N e d
        (by have := step_pos he; omega) (by have := step_pos hd; omega) hbounde h.symm
    · exact hde (badRight_inj N d e (by have := step_pos hd; omega) h)


theorem steps_card (N : ℕ) : (steps N).card = (N - 1) / 4 := by
  simp [steps, Nat.card_Icc]

theorem excludedFamily_card (N : ℕ) :
    (excludedFamily N).card = 2 * ((N - 1) / 4) := by
  have hdisj : (↑(steps N) : Set ℕ).PairwiseDisjoint (excludedAt N) := by
    intro d hd e he hde
    exact excludedAt_disjoint N d e hd he hde
  rw [excludedFamily, Finset.card_biUnion hdisj]
  calc
    ∑ d ∈ steps N, (excludedAt N d).card = ∑ d ∈ steps N, 2 := by
      apply Finset.sum_congr rfl
      intro d hd
      exact excludedAt_card N d (by have := step_pos hd; omega)
    _ = 2 * ((N - 1) / 4) := by simp [steps_card, Nat.mul_comm]



theorem leftFour_ne_rightFour_any (N d e : ℕ)
    (hd : 0 < d) (he : 0 < e) (hbound : 2 * d ≤ center N) :
    leftFour N d ≠ rightFour N e := by
  intro h
  have hhi : center N + d ∈ rightFour N e := by
    rw [← h]
    simp [leftFour]
  have hlo : center N - 2 * d ∈ rightFour N e := by
    rw [← h]
    simp [leftFour]
  simp only [rightFour, Finset.mem_insert, Finset.mem_singleton] at hhi hlo
  omega

theorem five_ne_four_left (N d e : ℕ) (hd : d ∈ steps N) (he : e ∈ steps N) :
    five N d ≠ leftFour N e := by
  intro h
  have hh := congrArg Finset.card h
  rw [five_card N d hd, leftFour_card N e he] at hh
  omega

theorem five_ne_four_right (N d e : ℕ) (hd : d ∈ steps N) (he : e ∈ steps N) :
    five N d ≠ rightFour N e := by
  intro h
  have hh := congrArg Finset.card h
  rw [five_card N d hd, rightFour_card N e he] at hh
  omega

theorem addedAt_card (N d : ℕ) (hd : d ∈ steps N) :
    (addedAt N d).card = 3 := by
  have h1 : leftFour N d ≠ rightFour N d :=
    leftFour_ne_rightFour_any N d d (by have := step_pos hd; omega)
      (by have := step_pos hd; omega)
      (window_order N d (step_pos hd) (step_le hd)).1
  have h2 : five N d ∉ ({leftFour N d, rightFour N d} : Finset (Finset ℕ)) := by
    simp only [Finset.mem_insert, Finset.mem_singleton, not_or]
    exact ⟨five_ne_four_left N d d hd hd, five_ne_four_right N d d hd hd⟩
  have h1' : leftFour N d ∉ ({rightFour N d} : Finset (Finset ℕ)) := by
    simpa only [Finset.mem_singleton] using h1
  change (insert (five N d) (insert (leftFour N d)
    ({rightFour N d} : Finset (Finset ℕ)))).card = 3
  rw [Finset.card_insert_of_notMem h2, Finset.card_insert_of_notMem h1']
  simp

theorem five_inj (N d e : ℕ) (hd : 0 < d) (he : 0 < e)
    (h : five N d = five N e) : d = e := by
  have hde : center N + 2 * d ∈ five N e := by rw [← h]; simp [five]
  have hed : center N + 2 * e ∈ five N d := by rw [h]; simp [five]
  simp only [five, Finset.mem_insert, Finset.mem_singleton] at hde hed
  omega

theorem leftFour_inj (N d e : ℕ) (hd : 0 < d) (he : 0 < e)
    (h : leftFour N d = leftFour N e) : d = e := by
  have hde : center N + d ∈ leftFour N e := by rw [← h]; simp [leftFour]
  have hed : center N + e ∈ leftFour N d := by rw [h]; simp [leftFour]
  simp only [leftFour, Finset.mem_insert, Finset.mem_singleton] at hde hed
  omega

theorem rightFour_inj (N d e : ℕ) (hd : 0 < d) (he : 0 < e)
    (h : rightFour N d = rightFour N e) : d = e := by
  have hde : center N + 2 * d ∈ rightFour N e := by rw [← h]; simp [rightFour]
  have hed : center N + 2 * e ∈ rightFour N d := by rw [h]; simp [rightFour]
  simp only [rightFour, Finset.mem_insert, Finset.mem_singleton] at hde hed
  omega

theorem addedAt_disjoint (N d e : ℕ)
    (hd : d ∈ steps N) (he : e ∈ steps N) (hde : d ≠ e) :
    Disjoint (addedAt N d) (addedAt N e) := by
  rw [Finset.disjoint_left]
  intro S hS hT
  simp only [addedAt, Finset.mem_insert, Finset.mem_singleton] at hS hT
  have hboundd := (window_order N d (step_pos hd) (step_le hd)).1
  have hbounde := (window_order N e (step_pos he) (step_le he)).1
  rcases hS with rfl | rfl | rfl
  · rcases hT with h | h | h
    · exact hde (five_inj N d e (by have := step_pos hd; omega)
        (by have := step_pos he; omega) h)
    · exact five_ne_four_left N d e hd he h
    · exact five_ne_four_right N d e hd he h
  · rcases hT with h | h | h
    · exact five_ne_four_left N e d he hd h.symm
    · exact hde (leftFour_inj N d e (by have := step_pos hd; omega)
        (by have := step_pos he; omega) h)
    · exact leftFour_ne_rightFour_any N d e
        (by have := step_pos hd; omega) (by have := step_pos he; omega) hboundd h
  · rcases hT with h | h | h
    · exact five_ne_four_right N e d he hd h.symm
    · exact leftFour_ne_rightFour_any N e d
        (by have := step_pos he; omega) (by have := step_pos hd; omega) hbounde h.symm
    · exact hde (rightFour_inj N d e (by have := step_pos hd; omega)
        (by have := step_pos he; omega) h)


theorem addedFamily_card (N : ℕ) :
    (addedFamily N).card = 3 * ((N - 1) / 4) := by
  have hdisj : (↑(steps N) : Set ℕ).PairwiseDisjoint (addedAt N) := by
    intro d hd e he hde
    exact addedAt_disjoint N d e hd he hde
  rw [addedFamily, Finset.card_biUnion hdisj]
  calc
    ∑ d ∈ steps N, (addedAt N d).card = ∑ d ∈ steps N, 3 := by
      apply Finset.sum_congr rfl
      intro d hd
      exact addedAt_card N d hd
    _ = 3 * ((N - 1) / 4) := by simp [steps_card, Nat.mul_comm]



theorem triple_mem_base (N a b : ℕ)
    (ha : a ∈ Finset.Icc 1 N) (hb : b ∈ Finset.Icc 1 N)
    (hab : a ≠ b) :
    ({a, center N, b} : Finset ℕ) ∈ baseFamily N := by
  have hP : ({a, b} : Finset ℕ) ∈ (Finset.Icc 1 N).powersetCard 2 := by
    rw [Finset.mem_powersetCard]
    constructor
    · simp [Finset.insert_subset_iff, ha, hb]
    · simp [hab]
  have himage : insert (center N) ({a, b} : Finset ℕ) ∈
      ((Finset.Icc 1 N).powersetCard 2).image (fun P => insert (center N) P) := by
    exact Finset.mem_image.mpr ⟨{a, b}, hP, rfl⟩
  have hbase : insert (center N) ({a, b} : Finset ℕ) ∈ baseFamily N := by
    simp only [baseFamily, Finset.mem_insert]
    exact Or.inr himage
  simpa only [Finset.insert_comm] using hbase

theorem five_subset_ground (N d : ℕ) (hN : 1 ≤ N) (hd : d ∈ steps N) :
    five N d ⊆ Finset.Icc 1 N := by
  have hbounds := window_bounds N d hN (step_le hd)
  have horder := window_order N d (step_pos hd) (step_le hd)
  intro x hx
  simp only [five, Finset.mem_insert, Finset.mem_singleton] at hx
  rw [Finset.mem_Icc]
  rcases hx with rfl | rfl | rfl | rfl | rfl <;> omega

theorem excluded_subset_base (N : ℕ) (hN : 1 ≤ N) :
    excludedFamily N ⊆ baseFamily N := by
  intro S hS
  obtain ⟨d, hd, hS⟩ := Finset.mem_biUnion.mp hS
  simp only [excludedAt, Finset.mem_insert, Finset.mem_singleton] at hS
  have hsub := five_subset_ground N d hN hd
  have horder := window_order N d (step_pos hd) (step_le hd)
  rcases hS with rfl | rfl
  · apply triple_mem_base N
    · exact hsub (by simp [five])
    · exact hsub (by simp [five])
    · omega
  · apply triple_mem_base N
    · exact hsub (by simp [five])
    · exact hsub (by simp [five])
    · omega

theorem base_member_card_le_three (N : ℕ) (S : Finset ℕ)
    (hS : S ∈ baseFamily N) : S.card ≤ 3 := by
  simp only [baseFamily, Finset.mem_insert] at hS
  rcases hS with h | h
  · rw [h]
    simp
  · obtain ⟨P, hP, hEq⟩ := Finset.mem_image.mp h
    have hp2 : P.card = 2 := (Finset.mem_powersetCard.mp hP).2
    rw [← hEq]
    have := Finset.card_insert_le (center N) P
    omega

theorem base_member_center (N : ℕ) (S : Finset ℕ)
    (hS : S ∈ baseFamily N) : center N ∈ S := by
  simp only [baseFamily, Finset.mem_insert] at hS
  rcases hS with h | h
  · rw [h]
    simp
  · obtain ⟨P, _hP, hEq⟩ := Finset.mem_image.mp h
    rw [← hEq]
    simp

theorem added_member_card_ge_four (N : ℕ) (S : Finset ℕ)
    (hS : S ∈ addedFamily N) : 4 ≤ S.card := by
  obtain ⟨d, hd, hS⟩ := Finset.mem_biUnion.mp hS
  simp only [addedAt, Finset.mem_insert, Finset.mem_singleton] at hS
  rcases hS with rfl | rfl | rfl
  · rw [five_card N d hd]; omega
  · rw [leftFour_card N d hd]
  · rw [rightFour_card N d hd]

theorem base_disjoint_added (N : ℕ) :
    Disjoint (baseFamily N) (addedFamily N) := by
  rw [Finset.disjoint_left]
  intro S hbase hadd
  have hsmall := base_member_card_le_three N S hbase
  have hlarge := added_member_card_ge_four N S hadd
  omega


theorem szaboFamily_card (N : ℕ) (hN : 1 ≤ N) :
    (szaboFamily N).card = N.choose 2 + 1 + (N - 1) / 4 := by
  have hsub := excluded_subset_base N hN
  have hdisj : Disjoint (baseFamily N \ excludedFamily N) (addedFamily N) := by
    rw [Finset.disjoint_left]
    intro S hS hadd
    have hbase : S ∈ baseFamily N := (Finset.mem_sdiff.mp hS).1
    exact (Finset.disjoint_left.mp (base_disjoint_added N)) hbase hadd
  have hcardremove : (baseFamily N \ excludedFamily N).card =
      (baseFamily N).card - (excludedFamily N).card := by
    rw [Finset.card_sdiff]
    rw [Finset.inter_eq_left.mpr hsub]
  have hle : (excludedFamily N).card ≤ (baseFamily N).card :=
    Finset.card_le_card hsub
  rw [szaboFamily, Finset.card_union_of_disjoint hdisj, hcardremove,
    base_card N, excludedFamily_card N, addedFamily_card N]
  rw [base_card N, excludedFamily_card N] at hle
  omega


end JSP233
