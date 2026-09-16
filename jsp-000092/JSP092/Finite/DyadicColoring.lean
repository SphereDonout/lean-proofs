import JSP092.Finite.Cut
import JSP092.Finite.Halves

/-!
# A coloring with two colors per dyadic level

Triples wholly inside either half reuse the preceding palette. Triples crossing
the cut receive one of two fresh colors, according to the position of their
middle coordinate. Each crossing class is independent.
-/

namespace JSP092

private def raiseColor {k : ℕ} (c : Fin k × Bool) : Fin (k + 1) × Bool :=
  (c.1.castSucc, c.2)

private theorem raiseColor_injective {k : ℕ} : Function.Injective (@raiseColor k) := by
  intro c d h
  apply Prod.ext
  · exact Fin.castSucc_inj.mp (congrArg Prod.fst h)
  · exact congrArg (fun z : Fin (k + 1) × Bool => z.2) h

private theorem raiseColor_ne_new {k : ℕ} (c : Fin k × Bool) (b : Bool) :
    raiseColor c ≠ (⟨k, Nat.lt_succ_self k⟩, b) := by
  intro h
  have he := congrArg (fun p : Fin (k + 1) × Bool => p.1.val) h
  have hc := c.1.isLt
  simp only [raiseColor, Fin.val_castSucc] at he
  omega

private def toNatTriple {m : ℕ} (x : Triple (Fin m)) : Triple ℕ :=
  x.map Fin.val (fun _ _ h => h)

private theorem toNatTriple_adj {m : ℕ} {x y : Triple (Fin m)}
    (h : (speckerGraph (Fin m)).Adj x y) :
    (speckerGraph ℕ).Adj (toNatTriple x) (toNatTriple y) :=
  Triple.map_adj Fin.val (fun _ _ h => h) h

private theorem dyadic_double (k : ℕ) : 2 ^ (k + 1) = 2 ^ k + 2 ^ k := by
  rw [pow_succ]
  omega

private def stepColor {k : ℕ}
    (C : (speckerGraph (Fin (2 ^ k))).Coloring (Fin k × Bool))
    (x : Triple (Fin (2 ^ (k + 1)))) : Fin (k + 1) × Bool :=
  if hl : x.c.val < 2 ^ k then
    raiseColor (C (lowerTriple x hl))
  else if hu : 2 ^ k ≤ x.a.val then
    raiseColor (C (upperTriple (dyadic_double k) x hu))
  else
    (⟨k, Nat.lt_succ_self k⟩, decide (x.b.val < 2 ^ k))

private theorem stepColor_valid {k : ℕ}
    (C : (speckerGraph (Fin (2 ^ k))).Coloring (Fin k × Bool))
    {x y : Triple (Fin (2 ^ (k + 1)))} (hAdj : (speckerGraph (Fin (2 ^ (k + 1)))).Adj x y) :
    stepColor C x ≠ stepColor C y := by
  intro heq
  by_cases hxL : x.c.val < 2 ^ k
  · by_cases hyL : y.c.val < 2 ^ k
    · apply C.valid (lowerTriple_adj hxL hyL hAdj)
      apply raiseColor_injective
      simpa only [stepColor, dif_pos hxL, dif_pos hyL] using heq
    · by_cases hyU : 2 ^ k ≤ y.a.val
      · exact lower_upper_not_adj (x := toNatTriple x) (y := toNatTriple y)
          hxL hyU (toNatTriple_adj hAdj)
      · exact raiseColor_ne_new _ _ (by
          simpa only [stepColor, dif_pos hxL, dif_neg hyL, dif_neg hyU] using heq)
  · by_cases hyL : y.c.val < 2 ^ k
    · by_cases hxU : 2 ^ k ≤ x.a.val
      · exact lower_upper_not_adj (x := toNatTriple y) (y := toNatTriple x)
          hyL hxU (toNatTriple_adj hAdj.symm)
      · exact raiseColor_ne_new _ _ (by
          simpa only [stepColor, dif_neg hxL, dif_neg hxU, dif_pos hyL] using heq.symm)
    · by_cases hxU : 2 ^ k ≤ x.a.val
      · by_cases hyU : 2 ^ k ≤ y.a.val
        · apply C.valid (upperTriple_adj (dyadic_double k) hxU hyU hAdj)
          apply raiseColor_injective
          simpa only [stepColor, dif_neg hxL, dif_neg hyL, dif_pos hxU, dif_pos hyU] using heq
        · exact raiseColor_ne_new _ _ (by
            simpa only [stepColor, dif_neg hxL, dif_neg hyL, dif_pos hxU, dif_neg hyU] using heq)
      · by_cases hyU : 2 ^ k ≤ y.a.val
        · exact raiseColor_ne_new _ _ (by
            simpa only [stepColor, dif_neg hxL, dif_neg hyL, dif_neg hxU, dif_pos hyU]
              using heq.symm)
        · have hbool : decide (x.b.val < 2 ^ k) = decide (y.b.val < 2 ^ k) := by
            simpa only [stepColor, dif_neg hxL, dif_neg hyL, dif_neg hxU, dif_neg hyU]
              using congrArg Prod.snd heq
          by_cases hxB : x.b.val < 2 ^ k
          · have hyB : y.b.val < 2 ^ k := by simpa [hxB] using hbool.symm
            exact crossLeft_not_adj (x := toNatTriple x) (y := toNatTriple y)
              ⟨hxB, le_of_not_gt hxL⟩ ⟨hyB, le_of_not_gt hyL⟩ (toNatTriple_adj hAdj)
          · have hyB : ¬ y.b.val < 2 ^ k := by simpa [hxB] using hbool.symm
            exact crossRight_not_adj (x := toNatTriple x) (y := toNatTriple y)
              ⟨lt_of_not_ge hxU, le_of_not_gt hxB⟩
              ⟨lt_of_not_ge hyU, le_of_not_gt hyB⟩ (toNatTriple_adj hAdj)

/-- A proper coloring of increasing triples below `2^k` using `2*k` colors.
The level-zero graph has no vertices, so the empty palette is valid. -/
def dyadicColoring : (k : ℕ) → (speckerGraph (Fin (2 ^ k))).Coloring (Fin k × Bool)
  | 0 => by
    letI : IsEmpty (Triple (Fin (2 ^ 0))) := ⟨fun x => by
      have hab := x.ab
      have hb := x.b.isLt
      norm_num at hb
      omega⟩
    exact SimpleGraph.Coloring.ofIsEmpty
  | k + 1 => SimpleGraph.Coloring.mk (stepColor (dyadicColoring k))
      (stepColor_valid (dyadicColoring k))

end JSP092
