import JSP233.Progression

/-!
The finite family in Szabó's Section 5 construction.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

namespace JSP233

/-- The chosen common element, `⌈N/2⌉`. -/
def center (N : ℕ) : ℕ := (N + 1) / 2

/-- The permissible common differences. -/
def steps (N : ℕ) : Finset ℕ := Finset.Icc 1 ((N - 1) / 4)

theorem step_pos {N d : ℕ} (hd : d ∈ steps N) : 1 ≤ d :=
  (Finset.mem_Icc.mp hd).1

theorem step_le {N d : ℕ} (hd : d ∈ steps N) : d ≤ (N - 1) / 4 :=
  (Finset.mem_Icc.mp hd).2

theorem center_bounds (N : ℕ) (hN : 1 ≤ N) :
    1 ≤ center N ∧ center N ≤ N := by
  dsimp [center]
  omega

theorem window_bounds (N d : ℕ) (hN : 1 ≤ N)
    (hD : d ≤ (N - 1) / 4) :
    1 ≤ center N - 2 * d ∧ center N + 2 * d ≤ N := by
  dsimp [center]
  omega

theorem window_order (N d : ℕ) (hd : 1 ≤ d)
    (hD : d ≤ (N - 1) / 4) :
    2 * d ≤ center N ∧ center N - 2 * d < center N - d ∧
    center N - d < center N ∧ center N < center N + d ∧
    center N + d < center N + 2 * d := by
  dsimp [center]
  omega

/-- The five-term centered progression. -/
def five (N d : ℕ) : Finset ℕ :=
  {center N - 2 * d, center N - d, center N, center N + d, center N + 2 * d}

/-- The left consecutive four-term subprogression. -/
def leftFour (N d : ℕ) : Finset ℕ :=
  {center N - 2 * d, center N - d, center N, center N + d}

/-- The right consecutive four-term subprogression. -/
def rightFour (N d : ℕ) : Finset ℕ :=
  {center N - d, center N, center N + d, center N + 2 * d}

/-- First excluded non-progression triple. -/
def badLeft (N d : ℕ) : Finset ℕ :=
  {center N - 2 * d, center N, center N + d}

/-- Second excluded non-progression triple. -/
def badRight (N d : ℕ) : Finset ℕ :=
  {center N - d, center N, center N + 2 * d}

/-- The two exclusions belonging to one step. -/
def excludedAt (N d : ℕ) : Finset (Finset ℕ) :=
  {badLeft N d, badRight N d}

/-- The three added windows belonging to one step. -/
def addedAt (N d : ℕ) : Finset (Finset ℕ) :=
  {five N d, leftFour N d, rightFour N d}

/-- All subsets of `[1,N]` with at most three elements containing the center. -/
def baseFamily (N : ℕ) : Finset (Finset ℕ) :=
  insert {center N}
    (((Finset.Icc 1 N).powersetCard 2).image (fun P => insert (center N) P))

/-- Two triples removed for each admissible difference. -/
def excludedFamily (N : ℕ) : Finset (Finset ℕ) :=
  (steps N).biUnion (excludedAt N)

/-- Three progressions added for each admissible difference. -/
def addedFamily (N : ℕ) : Finset (Finset ℕ) :=
  (steps N).biUnion (addedAt N)

/-- Szabó's improved family. -/
def szaboFamily (N : ℕ) : Finset (Finset ℕ) :=
  (baseFamily N \ excludedFamily N) ∪ addedFamily N

end JSP233
