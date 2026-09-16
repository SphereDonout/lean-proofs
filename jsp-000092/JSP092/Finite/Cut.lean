import JSP092.Basic

/-! # Independent crossing classes at an ordered cut -/

namespace JSP092

universe u
variable {α : Type u} [LinearOrder α] {x y : Triple α} {t : α}

theorem cut_cases (x : Triple α) (t : α) :
    x.c < t ∨ t ≤ x.a ∨ (x.b < t ∧ t ≤ x.c) ∨ (x.a < t ∧ t ≤ x.b) := by
  by_cases hc : x.c < t
  · exact Or.inl hc
  by_cases ha : t ≤ x.a
  · exact Or.inr (Or.inl ha)
  by_cases hb : x.b < t
  · exact Or.inr (Or.inr (Or.inl ⟨hb, le_of_not_gt hc⟩))
  · exact Or.inr (Or.inr (Or.inr ⟨lt_of_not_ge ha, le_of_not_gt hb⟩))

theorem crossLeft_not_adj (hx : x.b < t ∧ t ≤ x.c)
    (hy : y.b < t ∧ t ≤ y.c) : ¬ (speckerGraph α).Adj x y := by
  rintro (h | h)
  · exact (not_lt_of_ge hx.2) (h.2.2.trans hy.1)
  · exact (not_lt_of_ge hy.2) (h.2.2.trans hx.1)

theorem crossRight_not_adj (hx : x.a < t ∧ t ≤ x.b)
    (hy : y.a < t ∧ t ≤ y.b) : ¬ (speckerGraph α).Adj x y := by
  rintro (h | h)
  · exact (not_lt_of_ge hx.2) (h.1.trans hy.1)
  · exact (not_lt_of_ge hy.2) (h.1.trans hx.1)

theorem lower_upper_not_adj (hx : x.c < t) (hy : t ≤ y.a) :
    ¬ (speckerGraph α).Adj x y := by
  rintro (h | h)
  · exact (not_lt_of_ge hy) (h.2.1.trans hx)
  · exact (not_lt_of_ge hy) (y.ab.trans (h.1.trans (x.ab.trans (x.bc.trans hx))))

end JSP092
