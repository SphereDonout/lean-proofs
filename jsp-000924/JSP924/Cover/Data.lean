import JSP924.Basic
import Mathlib.Data.Nat.ModEq

/-!
The six divisor rows used for Izotov's fourth-power construction in
Filaseta, Finch and Kozek, *On Powers Associated with Sierpiński Numbers,
Riesel Numbers and Polignac's Conjecture*, preprint pages 3 and 6.

Only the numerical bounds, progression divisibility, and a common period
are needed here; no primality or exact-order claim is used.
-/

namespace JSP924

theorem cover_data (d : ℕ) (hd : d ∈ coverDivisors) :
    1 < d ∧ d < seed ∧ d ∣ step ∧ Nat.ModEq d (2 ^ 64) 1 := by
  simp only [coverDivisors, Finset.mem_insert, Finset.mem_singleton] at hd
  rcases hd with rfl | rfl | rfl | rfl | rfl | rfl <;>
    norm_num [seed, step, Nat.ModEq]

end JSP924
