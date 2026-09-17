import JSP233.Counting
/-! Intersections of Szabó’s added arithmetic progressions. -/
set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true
namespace JSP233

theorem three_eq_prog (c t : ℕ) (hct : t ≤ c) :
    ({c - t, c, c + t} : Finset ℕ) = prog (c - t) t 3 := by
  ext x
  simp only [prog, Finset.mem_insert, Finset.mem_singleton,
    Finset.mem_image, Finset.mem_range]
  constructor
  · intro hx
    rcases hx with h₀ | h₁ | h₂
    · exact ⟨0, by norm_num, by omega⟩
    · exact ⟨1, by norm_num, by omega⟩
    · exact ⟨2, by norm_num, by omega⟩
  · rintro ⟨i, hi, rfl⟩
    interval_cases i <;> omega

theorem subset_center_three_ap (c t : ℕ) (ht : 0 < t) (hct : t ≤ c)
    (S : Finset ℕ) (hS : S ⊆ ({c - t, c, c + t} : Finset ℕ))
    (hc : c ∈ S) :
    ∃ l : ℕ∞, 0 < l ∧ (S : Set ℕ).IsAPOfLength l := by
  by_cases hm : c - t ∈ S
  · by_cases hp : c + t ∈ S
    · have heq : S = {c - t, c, c + t} := by
        apply Finset.Subset.antisymm hS
        intro x hx
        simp only [Finset.mem_insert, Finset.mem_singleton] at hx
        rcases hx with rfl | rfl | rfl <;> assumption
      refine ⟨3, by norm_num, ?_⟩
      rw [heq, three_eq_prog c t hct]
      exact prog_ap _ _ _ ht
    · have heq : S = {c - t, c} := by
        apply Finset.Subset.antisymm
        · intro x hx
          have hx' := hS hx
          simp only [Finset.mem_insert, Finset.mem_singleton] at hx' ⊢
          rcases hx' with h | h | h
          · exact Or.inl h
          · exact Or.inr h
          · subst x; exact False.elim (hp hx)
        · intro x hx
          simp only [Finset.mem_insert, Finset.mem_singleton] at hx
          rcases hx with rfl | rfl <;> assumption
      refine ⟨2, by norm_num, ?_⟩
      rw [heq]
      simpa only [Finset.coe_insert, Finset.coe_singleton] using
        (Nat.isAPOfLength_pair (a := c - t) (b := c) (by omega))
  · by_cases hp : c + t ∈ S
    · have heq : S = {c, c + t} := by
        apply Finset.Subset.antisymm
        · intro x hx
          have hx' := hS hx
          simp only [Finset.mem_insert, Finset.mem_singleton] at hx' ⊢
          rcases hx' with h | h | h
          · subst x; exact False.elim (hm hx)
          · exact Or.inl h
          · exact Or.inr h
        · intro x hx
          simp only [Finset.mem_insert, Finset.mem_singleton] at hx
          rcases hx with rfl | rfl <;> assumption
      refine ⟨2, by norm_num, ?_⟩
      rw [heq]
      simpa only [Finset.coe_insert, Finset.coe_singleton] using
        (Nat.isAPOfLength_pair (a := c) (b := c + t) (by omega))
    · have heq : S = {c} := by
        apply Finset.Subset.antisymm
        · intro x hx
          have hx' := hS hx
          simp only [Finset.mem_insert, Finset.mem_singleton] at hx' ⊢
          rcases hx' with h | h | h
          · subst x; exact False.elim (hm hx)
          · exact h
          · subst x; exact False.elim (hp hx)
        · simpa only [Finset.singleton_subset_iff] using hc
      refine ⟨1, by norm_num, ?_⟩
      rw [heq]
      simpa only [Finset.coe_singleton] using
        (Set.IsAPOfLength.one.mpr ⟨c, rfl⟩ : ({c} : Set ℕ).IsAPOfLength 1)

theorem between_two_points {α : Type*} [DecidableEq α]
    (A B : Finset α) (l r : α)
    (hA : A ⊆ B) (hB : B ⊆ insert l (insert r A)) :
    B = A ∨ B = insert l A ∨ B = insert r A ∨
      B = insert l (insert r A) := by
  by_cases hl : l ∈ B
  · by_cases hr : r ∈ B
    · right; right; right
      exact Finset.Subset.antisymm hB
        (Finset.insert_subset_iff.mpr
          ⟨hl, Finset.insert_subset_iff.mpr ⟨hr, hA⟩⟩)
    · right; left
      apply Finset.Subset.antisymm
      · intro x hx
        have h := hB hx
        simp only [Finset.mem_insert] at h ⊢
        rcases h with h | h | h
        · exact Or.inl h
        · subst x; exact False.elim (hr hx)
        · exact Or.inr h
      · exact Finset.insert_subset_iff.mpr ⟨hl, hA⟩
  · by_cases hr : r ∈ B
    · right; right; left
      apply Finset.Subset.antisymm
      · intro x hx
        have h := hB hx
        simp only [Finset.mem_insert] at h ⊢
        rcases h with h | h | h
        · subst x; exact False.elim (hl hx)
        · exact Or.inl h
        · exact Or.inr h
      · exact Finset.insert_subset_iff.mpr ⟨hr, hA⟩
    · left
      apply Finset.Subset.antisymm
      · intro x hx
        have h := hB hx
        simp only [Finset.mem_insert] at h
        rcases h with h | h | h
        · subst x; exact False.elim (hl hx)
        · subst x; exact False.elim (hr hx)
        · exact h
      · exact hA


theorem five_decomp (N d : ℕ) :
    five N d = insert (center N - 2 * d)
      (insert (center N + 2 * d) ({center N - d, center N, center N + d} : Finset ℕ)) := by
  ext x
  simp [five]
  tauto

theorem left_decomp (N d : ℕ) :
    leftFour N d = insert (center N - 2 * d)
      ({center N - d, center N, center N + d} : Finset ℕ) := by
  ext x
  simp [leftFour]

theorem right_decomp (N d : ℕ) :
    rightFour N d = insert (center N + 2 * d)
      ({center N - d, center N, center N + d} : Finset ℕ) := by
  ext x
  simp [rightFour]
  tauto


theorem five_inter_five_sub_three (N d e : ℕ)
    (hd : 1 ≤ d) (he : 1 ≤ e)
    (hboundd : 2 * d ≤ center N) (hbounde : 2 * e ≤ center N)
    (hde : d ≠ e) :
    five N d ∩ five N e ⊆
      ({center N - max d e, center N, center N + max d e} : Finset ℕ) := by
  intro x hx
  simp only [Finset.mem_inter, five, Finset.mem_insert,
    Finset.mem_singleton] at hx ⊢
  omega


theorem addedAt_sub_five (N d : ℕ) (S : Finset ℕ)
    (hS : S ∈ addedAt N d) : S ⊆ five N d := by
  simp only [addedAt, Finset.mem_insert, Finset.mem_singleton] at hS
  rcases hS with rfl | rfl | rfl
  · exact Finset.Subset.rfl
  · simp [leftFour, five, Finset.subset_iff]
  · simp [rightFour, five, Finset.subset_iff]

theorem addedAt_mid_sub (N d : ℕ) (S : Finset ℕ)
    (hS : S ∈ addedAt N d) :
    ({center N - d, center N, center N + d} : Finset ℕ) ⊆ S := by
  simp only [addedAt, Finset.mem_insert, Finset.mem_singleton] at hS
  rcases hS with rfl | rfl | rfl
  · simp [five, Finset.subset_iff]
  · simp [leftFour, Finset.subset_iff]
  · simp [rightFour, Finset.subset_iff]


/-- A set between the middle three points and the five-point window is an AP. -/
theorem between_mid_five_ap (N d : ℕ) (hd : d ∈ steps N)
    (S : Finset ℕ)
    (hmid : ({center N - d, center N, center N + d} : Finset ℕ) ⊆ S)
    (hfive : S ⊆ five N d) :
    ∃ l : ℕ∞, 0 < l ∧ (S : Set ℕ).IsAPOfLength l := by
  have hshape := between_two_points
    ({center N - d, center N, center N + d} : Finset ℕ) S
    (center N - 2 * d) (center N + 2 * d)
    hmid (by simpa only [five_decomp] using hfive)
  rcases hshape with h | h | h | h
  · refine ⟨3, by norm_num, ?_⟩
    rw [h, three_eq_prog (center N) d (by
      have := (window_order N d (step_pos hd) (step_le hd)).1
      omega)]
    exact prog_ap _ _ _ (by have := step_pos hd; omega)
  · refine ⟨4, by norm_num, ?_⟩
    rw [h, ← left_decomp]
    exact leftFour_ap N d hd
  · refine ⟨4, by norm_num, ?_⟩
    rw [h, ← right_decomp]
    exact rightFour_ap N d hd
  · refine ⟨5, by norm_num, ?_⟩
    rw [h, ← five_decomp]
    exact five_ap N d hd

/-- Any two of the newly inserted windows have an AP intersection. -/
theorem addedAt_inter_ap (N d e : ℕ) (hd : d ∈ steps N) (he : e ∈ steps N)
    (S T : Finset ℕ) (hS : S ∈ addedAt N d) (hT : T ∈ addedAt N e) :
    ∃ l : ℕ∞, 0 < l ∧ ((S ∩ T : Finset ℕ) : Set ℕ).IsAPOfLength l := by
  by_cases hde : d = e
  · subst e
    apply between_mid_five_ap N d hd (S ∩ T)
    · exact Finset.subset_inter (addedAt_mid_sub N d S hS)
        (addedAt_mid_sub N d T hT)
    · exact (Finset.inter_subset_left).trans (addedAt_sub_five N d S hS)
  · have hdb := (window_order N d (step_pos hd) (step_le hd)).1
    have heb := (window_order N e (step_pos he) (step_le he)).1
    have hsub : S ∩ T ⊆
        ({center N - max d e, center N, center N + max d e} : Finset ℕ) := by
      intro x hx
      have hxS : x ∈ five N d := addedAt_sub_five N d S hS (Finset.mem_inter.mp hx).1
      have hxT : x ∈ five N e := addedAt_sub_five N e T hT (Finset.mem_inter.mp hx).2
      exact five_inter_five_sub_three N d e (step_pos hd) (step_pos he)
        hdb heb hde (Finset.mem_inter.mpr ⟨hxS, hxT⟩)
    have hc : center N ∈ S ∩ T := by
      apply Finset.mem_inter.mpr
      constructor
      · exact addedAt_mid_sub N d S hS (by simp)
      · exact addedAt_mid_sub N e T hT (by simp)
    apply subset_center_three_ap (center N) (max d e) (by
      have := step_pos hd
      have := step_pos he
      omega) (by omega) (S ∩ T) hsub hc


theorem small_set_ap (S : Finset ℕ) (hS : S.Nonempty) (hcard : S.card ≤ 2) :
    ∃ l : ℕ∞, 0 < l ∧ (S : Set ℕ).IsAPOfLength l := by
  have hpos : 0 < S.card := Finset.card_pos.mpr hS
  have hcases : S.card = 1 ∨ S.card = 2 := by omega
  rcases hcases with h | h
  · obtain ⟨a, ha⟩ := Finset.card_eq_one.mp h
    refine ⟨1, by norm_num, ?_⟩
    rw [ha]
    simpa only [Finset.coe_singleton] using
      (Set.IsAPOfLength.one.mpr ⟨a, rfl⟩ : ({a} : Set ℕ).IsAPOfLength 1)
  · obtain ⟨a, b, hab, heq⟩ := Finset.card_eq_two.mp h
    by_cases hlt : a < b
    · refine ⟨2, by norm_num, ?_⟩
      rw [heq]
      simpa only [Finset.coe_insert, Finset.coe_singleton] using
        (Nat.isAPOfLength_pair (a := a) (b := b) hlt)
    · have hlt' : b < a := by omega
      refine ⟨2, by norm_num, ?_⟩
      rw [heq]
      simpa only [Finset.coe_insert, Finset.coe_singleton, Set.pair_comm] using
        (Nat.isAPOfLength_pair (a := b) (b := a) hlt')


theorem pair_subset_four (a b c d : ℕ)
    (hab : a < b) (hbc : b < c) (hcd : c < d)
    (P : Finset ℕ) (hP : P ⊆ {a, b, c, d}) (hcard : P.card = 2) :
    P = {a, b} ∨ P = {a, c} ∨ P = {a, d} ∨
    P = {b, c} ∨ P = {b, d} ∨ P = {c, d} := by
  obtain ⟨x, y, hxy, rfl⟩ := Finset.card_eq_two.mp hcard
  have hx : x ∈ ({a, b, c, d} : Finset ℕ) := hP (by simp)
  have hy : y ∈ ({a, b, c, d} : Finset ℕ) := hP (by simp)
  simp only [Finset.mem_insert, Finset.mem_singleton] at hx hy
  rcases hx with rfl | rfl | rfl | rfl <;>
    rcases hy with rfl | rfl | rfl | rfl
  all_goals first | omega | simp [Finset.pair_comm]

theorem triple_subfive_cases (N d : ℕ) (hd : d ∈ steps N) (A : Finset ℕ)
    (hcard : A.card = 3) (hc : center N ∈ A) (hsub : A ⊆ five N d) :
    A = insert (center N) ({center N - 2*d, center N - d} : Finset ℕ) ∨
    A = insert (center N) ({center N - 2*d, center N + d} : Finset ℕ) ∨
    A = insert (center N) ({center N - 2*d, center N + 2*d} : Finset ℕ) ∨
    A = insert (center N) ({center N - d, center N + d} : Finset ℕ) ∨
    A = insert (center N) ({center N - d, center N + 2*d} : Finset ℕ) ∨
    A = insert (center N) ({center N + d, center N + 2*d} : Finset ℕ) := by
  have hPcard : (A.erase (center N)).card = 2 := by
    have := Finset.card_erase_add_one hc
    omega
  have hPsub : A.erase (center N) ⊆
      ({center N - 2*d, center N - d, center N + d, center N + 2*d} : Finset ℕ) := by
    intro x hx
    have hxA : x ∈ A := (Finset.mem_erase.mp hx).2
    have hxne : x ≠ center N := (Finset.mem_erase.mp hx).1
    have hx5 := hsub hxA
    simp only [five, Finset.mem_insert, Finset.mem_singleton] at hx5 ⊢
    omega
  have horder := window_order N d (step_pos hd) (step_le hd)
  have hpair := pair_subset_four
    (center N - 2*d) (center N - d) (center N + d) (center N + 2*d)
    horder.2.1 (by omega) horder.2.2.2.2 (A.erase (center N)) hPsub hPcard
  have hA : A = insert (center N) (A.erase (center N)) := (Finset.insert_erase hc).symm
  rcases hpair with h | h | h | h | h | h
  · left; exact hA.trans (congrArg (insert (center N)) h)
  · right; left; exact hA.trans (congrArg (insert (center N)) h)
  · right; right; left; exact hA.trans (congrArg (insert (center N)) h)
  · right; right; right; left; exact hA.trans (congrArg (insert (center N)) h)
  · right; right; right; right; left; exact hA.trans (congrArg (insert (center N)) h)
  · right; right; right; right; right; exact hA.trans (congrArg (insert (center N)) h)

theorem three_seq_eq_prog (a d : ℕ) :
    ({a, a+d, a+2*d} : Finset ℕ) = prog a d 3 := by
  ext x
  simp only [prog, Finset.mem_insert, Finset.mem_singleton,
    Finset.mem_image, Finset.mem_range]
  constructor
  · intro hx
    rcases hx with h | h | h
    · exact ⟨0, by norm_num, by omega⟩
    · exact ⟨1, by norm_num, by omega⟩
    · exact ⟨2, by norm_num, by omega⟩
  · rintro ⟨i, hi, rfl⟩
    interval_cases i <;> omega

theorem three_ordered_ap (a b c : ℕ) (hab : a < b) (hbc : b < c)
    (hstep : b - a = c - b) :
    (({a, b, c} : Finset ℕ) : Set ℕ).IsAPOfLength 3 := by
  let d := b-a
  have hd : 0 < d := by dsimp [d]; omega
  have hb : b = a + d := by dsimp [d]; omega
  have hc : c = a + 2 * d := by dsimp [d]; omega
  have hset : ({a, b, c} : Finset ℕ) = {a, a+d, a+2*d} := by
    rw [hb, hc]
  rw [hset, three_seq_eq_prog]
  exact prog_ap a d 3 hd

theorem triple_subfive_good_ap (N d : ℕ) (hd : d ∈ steps N) (A : Finset ℕ)
    (hcard : A.card = 3) (hc : center N ∈ A) (hsub : A ⊆ five N d)
    (hbadL : A ≠ badLeft N d) (hbadR : A ≠ badRight N d) :
    ∃ l : ℕ∞, 0 < l ∧ (A : Set ℕ).IsAPOfLength l := by
  have horder := window_order N d (step_pos hd) (step_le hd)
  rcases triple_subfive_cases N d hd A hcard hc hsub with h | h | h | h | h | h
  · refine ⟨3, by norm_num, ?_⟩
    have hshape : insert (center N)
        ({center N - 2*d, center N - d} : Finset ℕ) =
        {center N - 2*d, center N - d, center N} := by
      ext x; simp; tauto
    rw [h, hshape]
    exact three_ordered_ap _ _ _ (by omega) (by omega) (by omega)
  · have hshape : insert (center N)
        ({center N - 2*d, center N + d} : Finset ℕ) = badLeft N d := by
      ext x; simp [badLeft]; tauto
    exact False.elim (hbadL (h.trans hshape))
  · refine ⟨3, by norm_num, ?_⟩
    have hshape : insert (center N)
        ({center N - 2*d, center N + 2*d} : Finset ℕ) =
        {center N - 2*d, center N, center N + 2*d} := by
      ext x; simp; tauto
    rw [h, hshape]
    exact three_ordered_ap _ _ _ (by omega) (by omega) (by omega)
  · refine ⟨3, by norm_num, ?_⟩
    have hshape : insert (center N)
        ({center N - d, center N + d} : Finset ℕ) =
        {center N - d, center N, center N + d} := by
      ext x; simp; tauto
    rw [h, hshape]
    exact three_ordered_ap _ _ _ (by omega) (by omega) (by omega)
  · have hshape : insert (center N)
        ({center N - d, center N + 2*d} : Finset ℕ) = badRight N d := by
      ext x; simp [badRight]; tauto
    exact False.elim (hbadR (h.trans hshape))
  · refine ⟨3, by norm_num, ?_⟩
    have hshape : insert (center N)
        ({center N + d, center N + 2*d} : Finset ℕ) =
        {center N, center N + d, center N + 2*d} := by
      ext x; simp
    rw [h, hshape]
    exact three_ordered_ap _ _ _ (by omega) (by omega) (by omega)



theorem base_added_inter_ap (N d : ℕ) (hd : d ∈ steps N)
    (S T : Finset ℕ) (hS : S ∈ baseFamily N \ excludedFamily N)
    (hT : T ∈ addedAt N d) :
    ∃ l : ℕ∞, 0 < l ∧ ((S ∩ T : Finset ℕ) : Set ℕ).IsAPOfLength l := by
  let I := S ∩ T
  have hbase : S ∈ baseFamily N := (Finset.mem_sdiff.mp hS).1
  have hnot : S ∉ excludedFamily N := (Finset.mem_sdiff.mp hS).2
  have hsmall : I.card ≤ 3 := by
    have hcard := Finset.card_le_card (Finset.inter_subset_left : I ⊆ S)
    have hSsmall := base_member_card_le_three N S hbase
    change (S ∩ T).card ≤ 3
    omega
  have hc : center N ∈ I := by
    apply Finset.mem_inter.mpr
    constructor
    · exact base_member_center N S hbase
    · exact addedAt_mid_sub N d T hT (by simp)
  by_cases hle : I.card ≤ 2
  · exact small_set_ap I ⟨center N, hc⟩ hle
  · have hcard : I.card = 3 := by omega
    have hIS : I = S := by
      apply Finset.eq_of_subset_of_card_le Finset.inter_subset_left
      rw [hcard]
      exact base_member_card_le_three N S hbase
    have hbadLmem : badLeft N d ∈ excludedFamily N := by
      apply Finset.mem_biUnion.mpr
      exact ⟨d, hd, by simp [excludedAt]⟩
    have hbadRmem : badRight N d ∈ excludedFamily N := by
      apply Finset.mem_biUnion.mpr
      exact ⟨d, hd, by simp [excludedAt]⟩
    have hbadL : I ≠ badLeft N d := by
      intro h
      apply hnot
      rw [hIS.symm.trans h]
      exact hbadLmem
    have hbadR : I ≠ badRight N d := by
      intro h
      apply hnot
      rw [hIS.symm.trans h]
      exact hbadRmem
    have hsub : I ⊆ five N d :=
      (Finset.inter_subset_right).trans (addedAt_sub_five N d T hT)
    exact triple_subfive_good_ap N d hd I hcard hc hsub hbadL hbadR


theorem distinct_base_inter_ap (N : ℕ) (S T : Finset ℕ)
    (hS : S ∈ baseFamily N) (hT : T ∈ baseFamily N) (hne : S ≠ T) :
    ∃ l : ℕ∞, 0 < l ∧ ((S ∩ T : Finset ℕ) : Set ℕ).IsAPOfLength l := by
  have hcard : (S ∩ T).card ≤ 2 := by
    have hSsmall := base_member_card_le_three N S hS
    have hTsmall := base_member_card_le_three N T hT
    have hSI := Finset.card_le_card (Finset.inter_subset_left : S ∩ T ⊆ S)
    have hTI := Finset.card_le_card (Finset.inter_subset_right : S ∩ T ⊆ T)
    by_contra h
    have hSIeq : S ∩ T = S :=
      Finset.eq_of_subset_of_card_le Finset.inter_subset_left (by omega)
    have hTIeq : S ∩ T = T :=
      Finset.eq_of_subset_of_card_le Finset.inter_subset_right (by omega)
    exact hne (hSIeq.symm.trans hTIeq)
  have hc : center N ∈ S ∩ T := by
    apply Finset.mem_inter.mpr
    exact ⟨base_member_center N S hS, base_member_center N T hT⟩
  exact small_set_ap (S ∩ T) ⟨center N, hc⟩ hcard

end JSP233
