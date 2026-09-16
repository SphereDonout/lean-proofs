import JSP924

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

/-!
Independent transcription of the Izotov construction in Filaseta–Finch–Kozek,
Section 2, printed page 6, equation (1) and the displayed root progression.
The first proposition includes the separately justified exponent-zero endpoint.
The second uses the paper's positive-exponent Sierpiński convention.
-/

namespace JSP924Checks

/-- The literal progression has a proper nontrivial divisor at every exponent. -/
theorem expanded_family_composite (t n : ℕ) :
    ∃ d : ℕ, 1 < d ∧
      d < (734110615000775 + 36893488147419103230 * t) ^ 4 * 2 ^ n + 1 ∧
      d ∣ (734110615000775 + 36893488147419103230 * t) ^ 4 * 2 ^ n + 1 := by
  simpa only [JSP924.Composite, JSP924.value, JSP924.root,
    JSP924.seed, JSP924.step] using JSP924.family_value_composite t n

/-- Infinitely many actual positive odd fourth powers satisfy the paper's property. -/
theorem expanded_infinite_family :
    Set.Infinite {k : ℕ |
      0 < k ∧ Odd k ∧ (∃ l : ℕ, k = l ^ 4) ∧
        ∀ n : ℕ, 0 < n →
          ∃ d : ℕ, 1 < d ∧ d < k * 2 ^ n + 1 ∧ d ∣ k * 2 ^ n + 1} := by
  apply JSP924.infinitely_many_fourth_power_sierpinski.mono
  intro k hk
  rcases hk with ⟨⟨hpositive, hodd, hcomposite⟩, hfourth⟩
  exact ⟨hpositive, hodd, hfourth, hcomposite⟩

end JSP924Checks
