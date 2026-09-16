import JSP092.Basic

/-! # Normalizing triples wholly contained in a dyadic half -/

namespace JSP092

def lowerTriple {m n : ℕ} (x : Triple (Fin m)) (hx : x.c.val < n) :
    Triple (Fin n) where
  a := ⟨x.a.val, by have hab := x.ab; have hbc := x.bc; omega⟩
  b := ⟨x.b.val, by have hbc := x.bc; omega⟩
  c := ⟨x.c.val, hx⟩
  ab := x.ab
  bc := x.bc

def upperTriple {m n : ℕ} (hm : m = n + n) (x : Triple (Fin m))
    (hx : n ≤ x.a.val) : Triple (Fin n) where
  a := ⟨x.a.val - n, by have := x.a.isLt; omega⟩
  b := ⟨x.b.val - n, by have := x.b.isLt; omega⟩
  c := ⟨x.c.val - n, by have := x.c.isLt; omega⟩
  ab := by have := x.ab; change x.a.val - n < x.b.val - n; omega
  bc := by
    have hab := x.ab
    have hbc := x.bc
    change x.b.val - n < x.c.val - n
    omega

theorem lowerTriple_adj {m n : ℕ} {x y : Triple (Fin m)}
    (hx : x.c.val < n) (hy : y.c.val < n) (h : (speckerGraph (Fin m)).Adj x y) :
    (speckerGraph (Fin n)).Adj (lowerTriple x hx) (lowerTriple y hy) := by
  rcases h with h | h
  · exact Or.inl ⟨h.1, h.2.1, h.2.2⟩
  · exact Or.inr ⟨h.1, h.2.1, h.2.2⟩

theorem upperTriple_adj {m n : ℕ} (hm : m = n + n) {x y : Triple (Fin m)}
    (hx : n ≤ x.a.val) (hy : n ≤ y.a.val) (h : (speckerGraph (Fin m)).Adj x y) :
    (speckerGraph (Fin n)).Adj (upperTriple hm x hx) (upperTriple hm y hy) := by
  have hxa := x.ab
  have hxb := x.bc
  have hya := y.ab
  have hyb := y.bc
  rcases h with h | h
  · apply Or.inl
    obtain ⟨h1, h2, h3⟩ := h
    change x.b.val - n < y.a.val - n ∧
      y.a.val - n < x.c.val - n ∧ x.c.val - n < y.b.val - n
    constructor
    · omega
    constructor <;> omega
  · apply Or.inr
    obtain ⟨h1, h2, h3⟩ := h
    change y.b.val - n < x.a.val - n ∧
      x.a.val - n < y.c.val - n ∧ y.c.val - n < x.b.val - n
    constructor
    · omega
    constructor <;> omega

end JSP092
