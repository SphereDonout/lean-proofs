import JSP092

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

/-! Reproducible statement and transitive-assumption checks. -/

open Cardinal

-- Fresh transcription of the affirmative RHS of the pinned upstream statement.
-- The upstream theorem itself must not be in the import environment.
#check_failure Erdos75.erdos_75

example :
    ∃ (V : Type) (G : SimpleGraph V),
      G.chromaticCardinal = ℵ_ 1 ∧
      #V = ℵ_ 1 ∧
      ∀ ε > (0 : ℝ),
        ∀ᶠ (n : ℕ) in Filter.atTop, ∀ (H : G.Subgraph),
          H.verts.ncard = n →
          ∃ (I : Finset V),
            (I : Set V) ⊆ H.verts ∧
            G.IsIndepSet (I : Set V) ∧
            (I.card : ℝ) > (n : ℝ) ^ (1 - ε) :=
  JSP092.erdos75_near_linear

#check JSP092.erdos75_near_linear
#check JSP092.dyadicColoring
#check JSP092.finite_independent_set
#check JSP092.omega_sequence_bounded
#check JSP092.exists_monochromatic_edge
#check JSP092.cardinal_triple_omega
#check JSP092.chromaticCardinal_specker_omega
#check JSP092.exists_dyadicDepth_threshold

#check JSP092.Triple.map_adj
#print axioms JSP092.Triple.map_adj
#check JSP092.crossLeft_not_adj
#print axioms JSP092.crossLeft_not_adj
#check JSP092.crossRight_not_adj
#print axioms JSP092.crossRight_not_adj
#check JSP092.lowerTriple_adj
#print axioms JSP092.lowerTriple_adj
#check JSP092.upperTriple_adj
#print axioms JSP092.upperTriple_adj
#print axioms JSP092.dyadicColoring
#check JSP092.coordinateSupport_card_le
#print axioms JSP092.coordinateSupport_card_le
#check JSP092.rankedTriple_adj
#print axioms JSP092.rankedTriple_adj
#check JSP092.independent_fiber_card_bound
#print axioms JSP092.independent_fiber_card_bound
#print axioms JSP092.finite_independent_set
#check JSP092.cardinal_omega
#print axioms JSP092.cardinal_omega
#print axioms JSP092.omega_sequence_bounded
#check JSP092.exists_unboundedAbove_of_countable_cover
#print axioms JSP092.exists_unboundedAbove_of_countable_cover
#check JSP092.exists_unbounded_firstFiber
#print axioms JSP092.exists_unbounded_firstFiber
#print axioms JSP092.exists_monochromatic_edge
#check JSP092.no_nat_coloring
#print axioms JSP092.no_nat_coloring
#print axioms JSP092.cardinal_triple_omega
#print axioms JSP092.chromaticCardinal_specker_omega
#check JSP092.dyadicDepth_cover
#print axioms JSP092.dyadicDepth_cover
#check JSP092.dyadicDepth_le_logb
#print axioms JSP092.dyadicDepth_le_logb
#check JSP092.dyadicDepth_isBigO_log
#print axioms JSP092.dyadicDepth_isBigO_log
#print axioms JSP092.exists_dyadicDepth_threshold
#check JSP092.independent_size_gt_rpow
#print axioms JSP092.independent_size_gt_rpow
#check JSP092.eventually_nearLinear_finite
#print axioms JSP092.eventually_nearLinear_finite
#print axioms JSP092.erdos75_near_linear
