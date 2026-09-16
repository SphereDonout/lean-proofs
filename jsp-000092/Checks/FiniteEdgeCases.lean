import JSP092.Finite.IndependentSet

/-!
# Author checks for the finite proof

These checks preserve the generic integral interface and exercise the boundaries
that distinguish the exact triple graph and the dyadic cut construction.
-/

namespace JSP092.Checks.Finite

-- The handoff interface is generic over the ambient linear order.
example {α : Type*} [LinearOrder α] (W : Finset (Triple α)) (k : ℕ)
    (hcover : 3 * W.card ≤ 2 ^ k) :
    ∃ I : Finset (Triple α), I ⊆ W ∧ (speckerGraph α).IsIndepSet (I : Set (Triple α)) ∧
      W.card ≤ 2 * k * I.card :=
  finite_independent_set W k hcover

-- The empty vertex set needs neither a positive palette nor positive support.
example {α : Type*} [LinearOrder α] :
    ∃ I : Finset (Triple α), I ⊆ ∅ ∧ (speckerGraph α).IsIndepSet (I : Set (Triple α)) ∧
      (∅ : Finset (Triple α)).card ≤ 2 * 0 * I.card :=
  finite_independent_set ∅ 0 (by simp)

-- At level zero there are no increasing triples, so the empty palette is valid.
example : (speckerGraph (Fin (2 ^ 0))).Coloring (Fin 0 × Bool) :=
  dyadicColoring 0

-- The generic pigeonhole statement also accepts an empty palette.
example {V : Type*} (G : SimpleGraph V) (W : Finset V)
    (coloring : (G.induce (W : Set V)).Coloring (Fin 0)) :
    ∃ I : Finset V, I ⊆ W ∧ G.IsIndepSet (I : Set V) ∧ W.card ≤ 0 * I.card := by
  simpa using independent_fiber_card_bound G W coloring

-- Such a coloring forces the original finite vertex set to be empty.
example {V : Type*} (G : SimpleGraph V) (W : Finset V)
    (coloring : (G.induce (W : Set V)).Coloring (Fin 0)) : W = ∅ := by
  obtain ⟨I, _, _, hcard⟩ := independent_fiber_card_bound G W coloring
  have hz : W.card = 0 := by simpa using hcard
  exact Finset.card_eq_zero.mp hz

private def edgeLeft : Triple ℕ := ⟨0, 1, 3, by decide, by decide⟩
private def edgeRight : Triple ℕ := ⟨2, 4, 5, by decide, by decide⟩

-- The six coordinates have the exact XXYXYY interleaving in both edge orientations.
example : (speckerGraph ℕ).Adj edgeLeft edgeRight := by
  norm_num [speckerGraph, Up, edgeLeft, edgeRight]

example : (speckerGraph ℕ).Adj edgeRight edgeLeft := by
  norm_num [speckerGraph, Up, edgeLeft, edgeRight]

-- The orientation predicate itself is not symmetric.
example : Up edgeLeft edgeRight ∧ ¬ Up edgeRight edgeLeft := by
  norm_num [Up, edgeLeft, edgeRight]

private def leftBoundary₁ : Triple ℕ := ⟨0, 1, 3, by decide, by decide⟩
private def leftBoundary₂ : Triple ℕ := ⟨0, 2, 3, by decide, by decide⟩

-- Equality of the last coordinate with the cut belongs to the crossing class.
example : ¬ leftBoundary₁.c < 3 ∧
    ¬ (speckerGraph ℕ).Adj leftBoundary₁ leftBoundary₂ := by
  refine ⟨by decide, ?_⟩
  exact crossLeft_not_adj (t := 3) ⟨by decide, by decide⟩ ⟨by decide, by decide⟩

private def rightBoundary₁ : Triple ℕ := ⟨0, 3, 5, by decide, by decide⟩
private def rightBoundary₂ : Triple ℕ := ⟨1, 3, 6, by decide, by decide⟩

-- Equality of the middle coordinate with the cut belongs to the other crossing class.
example : rightBoundary₁.b = 3 ∧
    ¬ (speckerGraph ℕ).Adj rightBoundary₁ rightBoundary₂ := by
  refine ⟨rfl, ?_⟩
  exact crossRight_not_adj (t := 3) ⟨by decide, by decide⟩ ⟨by decide, by decide⟩

private def lowerBoundary : Triple ℕ := ⟨0, 1, 2, by decide, by decide⟩
private def upperBoundary : Triple ℕ := ⟨3, 4, 5, by decide, by decide⟩

-- Equality of the first coordinate with the cut belongs to the upper half.
example : upperBoundary.a = 3 ∧
    ¬ (speckerGraph ℕ).Adj lowerBoundary upperBoundary := by
  refine ⟨rfl, ?_⟩
  exact lower_upper_not_adj (t := 3) (by decide) (by decide)

-- Distinct vertices may share coordinates; their shared endpoints do not form an edge.
example : leftBoundary₁ ≠ leftBoundary₂ ∧ leftBoundary₁.a = leftBoundary₂.a ∧
    leftBoundary₁.c = leftBoundary₂.c ∧
    ¬ (speckerGraph ℕ).Adj leftBoundary₁ leftBoundary₂ := by
  refine ⟨?_, rfl, rfl, ?_⟩
  · intro h
    have hb := congrArg Triple.b h
    norm_num [leftBoundary₁, leftBoundary₂] at hb
  · norm_num [speckerGraph, Up, leftBoundary₁, leftBoundary₂]

end JSP092.Checks.Finite

#print axioms JSP092.dyadicColoring
#print axioms JSP092.coordinateSupport_card_le
#print axioms JSP092.rankedTriple_adj
#print axioms JSP092.independent_fiber_card_bound
#print axioms JSP092.finite_independent_set
