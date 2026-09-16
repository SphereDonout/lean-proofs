import JSP924.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.FinCases

/-!
A finite form of the cover on page 3 of Filaseta, Finch and Kozek,
*On Powers Associated with Sierpiński Numbers, Riesel Numbers and Polignac's
Conjecture*, with the modulus-four row removed as in the Izotov construction
on page 6. The sixteen classes congruent to two modulo four are handled
separately by factorization.
-/

namespace JSP924

/-- The divisor assigned to each of the six covering patterns. -/
private def residueDivisor (r : ℕ) : ℕ :=
  if r % 2 = 1 then 3
  else if r % 8 = 4 then 17
  else if r % 16 = 8 then 257
  else if r % 32 = 16 then 65537
  else if r % 64 = 32 then 641
  else 6700417

theorem finite_cover (r : Fin 64) (hr : r.val % 4 ≠ 2) :
    ∃ d ∈ coverDivisors, (seed ^ 4 * 2 ^ r.val + 1) % d = 0 := by
  refine ⟨residueDivisor r.val, ?_, ?_⟩
  · fin_cases r <;> norm_num [residueDivisor, coverDivisors]
  · fin_cases r <;> norm_num [residueDivisor, seed] at *

end JSP924
