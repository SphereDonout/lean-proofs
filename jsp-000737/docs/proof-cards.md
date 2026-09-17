# Proof cards and task ledger

Project: JSP-000737 general divisor bound. Exact parent proposition and source: [statement contract](statement-contract.md). Every module uses the pinned Lean 4.33.1 / Mathlib environment and is in the accepted build graph. No scratch file is an accepted dependency.

| Card | Owner | File / exports | Prerequisites | Source step | Local result |
|---|---|---|---|---|---|
| S0 | Separate source reviewer | Contract review; `Checks/Statement.lean` | Paper and upstream statement | Derive the intended closed interval independently | Source and implementation reviewed; check compiled |
| B0 | Coordinator | `JSP737/Basic.lean`: `nearDivisors`, `factorSum` | Mathlib divisors, real roots | Shared objects | Compiled |
| R1 | Algebra worker | `JSP737/RealBounds.lean`: `factor_sum_bounds`, `upper_factor_unique` | Real ordered-field algebra | Factor sums lie in a short interval and identify upper factors | Compiled; standard axioms only |
| I1 | Counting worker | `JSP737/IntervalCount.lean`: `nat_card_le_interval` | Finset extrema, natural interval count | Integer spacing | Compiled; standard axioms only |
| N1 | Coordinator | `JSP737/FactorSum.lean`: `divisor_product`, `factorSum_mem_bounds`, `factorSum_injective` | B0, R1 | Exact natural complementary factors and casts | Compiled |
| M1 | Coordinator | `JSP737/Main.lean`: cardinal bound, root bridge, pointwise and eventual exports | N1, I1 | Assemble source consequence | Compiled |
| V1 | Independent reviewer and coordinator | `Checks/Statement.lean`, `Boundaries.lean`, `Axioms.lean`, `Exports.lean` | M1 | Semantic correspondence, endpoint checks, trust audit | See final verification report |

## R1: algebra interfaces

`factor_sum_bounds (s t C d q : ℝ)` assumes `0 < s`, `0 ≤ t`, `t² = s`, `0 ≤ C`, `s ≤ d`, `d ≤ s+C*t`, and `d*q = s²`. It proves `2*s ≤ d+q ∧ d+q ≤ 2*s+C²`.

`upper_factor_unique (s d e q r : ℝ)` assumes `0 < s`, `s ≤ d`, `s ≤ e`, `d*q = s²`, `e*r = s²`, and `d+q = e+r`. It proves `d=e`, including the square endpoint.

Command: `lake --wfail build JSP737.RealBounds`; exit 0. Pure polynomial inequalities and a factored equality replace division by positive real d.

## I1: counting interface

`nat_card_le_interval (s : Finset ℕ) (a b : ℝ)` assumes `a ≤ b` and that every member k satisfies `a ≤ (k : ℝ) ∧ (k : ℝ) ≤ b`. It proves `(s.card : ℝ) ≤ b-a+1`. The empty set is handled separately; for a nonempty set, its minimum and maximum bound its cardinality.

Command: `lake --wfail build JSP737.IntervalCount`; exit 0.

## N1: discrete bridge interfaces

- `divisor_product (n d : ℕ) (hd : d ∣ n)` proves `(d : ℝ) * (n/d : ℕ) = (Real.sqrt (n : ℝ))²` by exact natural division and the square-root identity.
- `factorSum_mem_bounds (n d : ℕ) (C : ℝ)` assumes `0<n`, `0≤C`, `d∈nearDivisors n C`; it locates the real cast of `factorSum n d` in `[2√n,2√n+C²]`.
- `factorSum_injective (n : ℕ) (C : ℝ)` assumes `0<n`; it proves `Set.InjOn (factorSum n) (nearDivisors n C)`. No nonnegative-width hypothesis is needed for injectivity.

Command: `lake --wfail build JSP737.FactorSum`; exit 0.

## M1: assembly interfaces

`nearDivisors_card_le (n : ℕ) (C : ℝ) (hC : 0≤C)` gives the finite cardinal bound, using empty divisors when n=0. `fourth_root_eq_rpow` and `nearDivisors_eq_rpow` provide explicit representation bridges. `rosenfeld_bound_pointwise` restates the bound with real exponents; `erdos_rosenfeld_bound` exports the exact eventual proposition without extra hypotheses.

Command: `lake --wfail build JSP737`; exit 0. No mathematical obligations remain in these cards; complete acceptance and source identity are recorded in the verification report.

## V1: acceptance

The explicit inventory `Checks/axiom-targets.txt` names 17 declarations: every critical helper, all final statements and bridges, independent statement adapters, and four boundary checks. The coordinator selected this inventory from the contract, rather than inferring completeness from existing axiom output.

Command: `python3 scripts/verify.py`. It preserves pins, checks dependency source integrity, performs complete builds and explicit-option check runs, audits the inventory, and repeats from a clean project build state. Full outcomes appear in `docs/evidence/verification-summary.json` and the final report.
