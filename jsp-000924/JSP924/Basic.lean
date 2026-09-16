import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Finset.Insert
import Mathlib.Algebra.Ring.Parity
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Lean.Elab.Tactic.Omega

/-!
Definitions for the Izotov fourth-power construction, as presented by
Filaseta, Finch and Kozek, Section 2, page 6 (23 December 2007 preprint).
-/

namespace JSP924

def seed : ℕ := 734110615000775
def step : ℕ := 36893488147419103230
def root (t : ℕ) : ℕ := seed + step * t
def value (t n : ℕ) : ℕ := root t ^ 4 * 2 ^ n + 1

def Composite (N : ℕ) : Prop :=
  ∃ d : ℕ, 1 < d ∧ d < N ∧ d ∣ N

def Sierpinski (k : ℕ) : Prop :=
  0 < k ∧ Odd k ∧ ∀ n : ℕ, 0 < n → Composite (k * 2 ^ n + 1)

def coverDivisors : Finset ℕ := {3, 17, 257, 65537, 641, 6700417}

theorem step_eq_product :
    step = 2 * 3 * 5 * 17 * 257 * 65537 * 641 * 6700417 := by
  norm_num [step]

theorem seed_le_root (t : ℕ) : seed ≤ root t := by
  exact Nat.le_add_right seed (step * t)

theorem root_gt_one (t : ℕ) : 1 < root t := by
  have h := seed_le_root t
  norm_num [seed] at h
  omega

theorem root_odd (t : ℕ) : Odd (root t) := by
  refine ⟨367055307500387 + 18446744073709551615 * t, ?_⟩
  simp only [root, seed, step]
  omega

theorem seed_lt_value (t n : ℕ) : seed < value t n := by
  have hr := seed_le_root t
  have hp : root t ≤ root t ^ 4 := Nat.le_self_pow (by decide) _
  have hn : 1 ≤ 2 ^ n := Nat.one_le_pow n 2 (by decide)
  unfold value
  nlinarith

end JSP924
