# JSP-000924 statement contract

Adopted for implementation. The source and mathematical scope have been reviewed; verification status is recorded separately in final-verification.md and the task ledger.

## Identified source result

Michael Filaseta, Carrie Finch and Mark Kozek, *On Powers Associated with Sierpiński Numbers, Riesel Numbers and Polignac's Conjecture*, [author preprint dated 23 December 2007](https://people.math.sc.edu/filaseta/papers/SierpinskiEtCoPapNew.pdf). The selected result is the **unnumbered Izotov construction in Section 2, printed page 6, including equation (1)**. It is distinct from the paper's general-power Theorem 1 and its later smaller-root Theorem 10.

The definition of a Sierpiński number is on printed page 1; the original congruence cover is on pages 3–4. Page 6 removes one covering row and uses factorization for its exponents. The construction is credited to A. S. Izotov; reference [10] gives *A note on Sierpiński numbers*, Fibonacci Quarterly 33 (1995), 206–207. The selected exposition supplies the argument needed here, so no theorem from that earlier article is assumed as a Lean dependency.

## Exact mathematical target

Set A = 734110615000775 and

```text
M = 2·3·5·17·257·65537·641·6700417 = 36893488147419103230.
L(t) = A + M·t.
```

For every t ∈ ℕ and every n ∈ ℕ, there exists d ∈ ℕ such that

```text
1 < d < L(t)^4·2^n + 1  and  d divides L(t)^4·2^n + 1.
```

Consequently every L(t)^4 is a positive odd fourth power that is a Sierpiński number, and infinitely many distinct natural numbers have these properties. The standard Sierpiński predicate quantifies over n > 0. Including n = 0 in the first theorem is an additional endpoint proved from the same numerical data.

### Proposed Lean objects and exports

These document the implemented signatures and definitions; proof bodies are in the Lean modules. All declarations use namespace `JSP924` and concrete type `ℕ`; no polymorphic universe or hidden section parameter is intended.

```lean
def seed : ℕ := 734110615000775
def step : ℕ := 36893488147419103230
def root (t : ℕ) : ℕ := seed + step * t
def value (t n : ℕ) : ℕ := root t ^ 4 * 2 ^ n + 1
def Composite (N : ℕ) : Prop :=
  ∃ d : ℕ, 1 < d ∧ d < N ∧ d ∣ N
def Sierpinski (k : ℕ) : Prop :=
  0 < k ∧ Odd k ∧ ∀ n : ℕ, 0 < n → Composite (k * 2 ^ n + 1)
def coverDivisors : Finset ℕ := {3, 17, 257, 65537, 641, 6700417}

theorem family_value_composite (t n : ℕ) : Composite (value t n)
theorem family_value_not_prime (t n : ℕ) : ¬ Nat.Prime (value t n)
theorem family_sierpinski (t : ℕ) : Sierpinski (root t ^ 4)
theorem infinitely_many_fourth_power_sierpinski :
  Set.Infinite {k : ℕ | Sierpinski k ∧ ∃ l : ℕ, k = l ^ 4}
```

## Objects, quantifiers and conventions

| Paper object | Planned representation | Meaning to preserve |
| --- | --- | --- |
| Positive root ℓ in the displayed congruence class | `root t`, t : ℕ | Fixed positive A and M; t = 0 is included |
| k = ℓ⁴ | `root t ^ 4` | Fourth power of an actual natural root |
| k·2ⁿ + 1 | `value t n` | Exponent belongs to 2, and fourth power belongs to the root |
| Composite | `Composite` | A divisor strictly between 1 and the value |
| Sierpiński number | `Sierpinski` | Positive odd k; all positive exponents |
| n = 4u + 2 | `u := n / 4` in the exceptional branch | u may be zero |
| Infinitely many k | `Set.Infinite` of the displayed set | Distinct outputs, established by an injective parameter map |

Quantifier order is ∀ t, ∀ n, ∃ d. The witness d may depend on both parameters. A, M and the six covering divisors are fixed globally. No threshold, bounded exponent range, assumed primality or nonempty auxiliary structure is introduced. Proper-divisor compositeness rules out 0, 1 and prime values.

## Paper steps and planned lemmas

| Step | Source passage or derived bridge | Cards / declarations |
| --- | --- | --- |
| P01 | Definition, p.1; odd root congruence, p.6 | D00 definitions and `root_odd`; I02 `family_sierpinski` |
| P02 | Root congruence system and product modulus, p.6 | D00 bounds; C01 `cover_data`; C03 `root_modEq_seed` |
| P03 | Covering implications, p.3, with the modulus-4 row removed on p.6 | C02 `finite_cover`; C03 `two_pow_mod64`, `value_modEq_residue`; C04 `covered_composite` |
| P04 | Equation (1), p.6 | F01 `sophie_identity`, `sophie_composite`; F02 `exceptional_value`, `exceptional_composite` |
| P05 | Conclusion for each root in the congruence class, p.6 | I01 `family_value_composite`; B01 proper-factor and nonprime bridges; I02 `family_value_not_prime` |
| P06 | Derived corollary of the explicit progression | I02 `fourth_family_injective`, `infinitely_many_fourth_power_sierpinski` |
| P07 | Formalization acceptance, derived from this contract | V01 independent statement adapters and transitive axiom inventory |

The divisor table and algebraic outline are in [proof-outline.md](proof-outline.md).

## Explicit expansions and limits of the argument

- Replace the paper's CRT construction step with verification of its given A and M. Verify the product/decimal correspondence during source review. Do not claim to prove CRT uniqueness, the least possible root, or every displayed root congruence unless separate lemmas establish them.
- Use a common period of 64 and 48 residue witnesses to express the six cover implications. Prove symbolic lifting to arbitrary n; the finite certificate alone is insufficient.
- Rewrite equation (1) with x = ℓ·2ᵘ = y+1. The subtraction-free identity in BRIEF.md is an equivalent algebraic representation. Both factors must exceed 1; x = 1 gives 5 and is excluded.
- Supply the paper's implicit strict factor bounds, the n = 0 endpoint and progression injectivity explicitly. No unresolved mathematical gap in this selected construction was identified during planning; these remain Lean obligations.
- The discussion of ℓ ≡ 0 modulo 5 motivates a possible absence of a finite cover. The target makes no assertion of that absence. The paper describes that further proof as unavailable on p.2.

## Attribution and scope

This publishes a formalization of the cited known construction. It makes no novelty or priority claim. The broader no-finite-cover question is outside the result.

## Acceptance criteria

All four final exports and the critical helpers must compile against the locked environment. A separate check must independently transcribe the source conclusion, then prove the expanded targets from the public import. Review constants, both universal parameters, strict bounds, oddness, exponent zero, n = 2 and distinctness.

Only `propext`, `Classical.choice` and `Quot.sound` are permitted in transitive axiom reports. Require a nonempty complete inventory and fail on missing reports, admissions or extra assumptions. Build the accepted library and all check modules with warnings treated as failures. Record exact dependency source identities and clean project rebuild scope. Separate AI review from human review and an independently implemented proof checker.

Actual verification and its trust limits are recorded in [final-verification.md](final-verification.md).
