# Statement contract: JSP-000737

## Selected result and attribution

Paul Erdős and Moshe Rosenfeld, *The factor-difference set of integers*, Acta Arithmetica 79.4 (1997), 353–359, the divisor-count consequence following Proposition 4.1 on page 356 (PDF page 4).

- [Primary PDF](https://matwbn.icm.edu.pl/ksiazki/aa/aa79/aa7944.pdf)
- [DOI](https://doi.org/10.4064/aa-79-4-353-359)
- PDF SHA-256: `642f4b33a75f402c2c6a8150193540e5831f6daedb3f3130e84a7d5b6df5289f`.
- [Formal Conjectures statement](https://github.com/google-deepmind/formal-conjectures/blob/40e7c98697de6f66b8cbdbf641749ab39ed9c152/FormalConjectures/ErdosProblems/886.lean), revision `40e7c98697de6f66b8cbdbf641749ab39ed9c152`, declaration `erdos_886.variants.rosenfeld_bound`. Source SHA-256: `5b09299621c531d8a871a0d8e3db9f228d2b3063d561ed49d14e6b80a05f27aa`.

The original mathematical result belongs to Erdős and Rosenfeld. This project supplies an AI-assisted Lean formalization and a direct reformulation of their factor-sum spacing argument. The existing AlphaProof C=1 special-case proof is acknowledged in the README. No novelty of mathematics, first formalization priority, or award is asserted.

## Exact proposition

For every real C > 0, all sufficiently large natural n have at most 1+C² positive divisors in the **closed** interval [√n, √n+C n^(1/4)]. The cardinality is compared in ℝ.

Exported declaration: `JSP737.erdos_rosenfeld_bound`.

```lean
∀ C > (0 : ℝ), ∀ᶠ (n : ℕ) in Filter.atTop,
  ((n.divisors.filter (fun d : ℕ =>
    (n : ℝ) ^ (1 / 2 : ℝ) ≤ (d : ℝ) ∧
    (d : ℝ) ≤ (n : ℝ) ^ (1 / 2 : ℝ) +
      C * (n : ℝ) ^ (1 / 4 : ℝ))).card : ℝ) ≤ 1 + C ^ 2
```

The stronger `rosenfeld_bound_pointwise` holds for every n : ℕ and C ≥ 0. Its n=0 case uses the explicitly documented Mathlib convention `Nat.divisors 0 = ∅`. For positive n it is precisely the mathematical finite bound, including perfect squares and C=0. The threshold in the eventual theorem can therefore be chosen independently of C.

Excluded scope: the open all-exponent Ruzsa conjecture, Proposition 4.1's factor-difference lower bound as a separately exported theorem, and Proposition 4.2's infinite four-divisor construction.

## Objects and conventions

| Paper object | Lean representation | Meaning |
|---|---|---|
| Integer n being factored | `n : ℕ` | Positive in the substantive argument |
| Positive divisors | `Nat.divisors n` | Finite set, no multiplicities |
| Width parameter | `C : ℝ` | Arbitrary positive real; stronger result allows zero |
| Square root | `Real.sqrt (n : ℝ)` | Nonnegative real root |
| Fourth root | `Real.sqrt (Real.sqrt (n : ℝ))` | Bridged to real exponent 1/4 by a proved equality |
| Selected upper factors | `JSP737.nearDivisors n C` | Both interval endpoints included |
| Complementary factor | `n / d : ℕ` | Exact because d divides n |
| Factor sum | `JSP737.factorSum n d` | Natural integer d+n/d |
| Number of factors | Finset cardinality cast to ℝ | No rounding or natural-number truncation of C² |

All theorem variables have explicit types. No hypotheses about unproved catalog targets or mathematical axioms may enter the accepted graph. Formal Conjectures is used as a statement reference and is not a project dependency.

## Argument and source correspondence

The paper's proof on page 356 orders factor differences and observes that corresponding sums of complementary factors are distinct integers at least 2√n. We count those integer sums directly in an interval. This verifies a reformulated proof of the consequence, rather than every displayed line of Proposition 4.1.

| Step | Exported lemmas | Correspondence |
|---|---|---|
| Complementary factors multiply to n | `divisor_product` | Paper's n=aᵢbᵢ, with exact natural division proved |
| Sum lies between 2√n and 2√n+C² | `factor_sum_bounds`, `factorSum_mem_bounds` | Elementary square identities underlying the paper's factor-sum argument; direct bounded-interval reformulation |
| Distinct upper factors have distinct sums | `upper_factor_unique`, `factorSum_injective` | Paper's distinct factor sums; includes equality at √n |
| Integers in an interval of length C² number at most C²+1 | `nat_card_le_interval` | Paper's integer spacing step, with empty sets handled |
| Transfer cardinality and convert roots | `nearDivisors_card_le`, `fourth_root_eq_rpow`, `nearDivisors_eq_rpow` | Source's divisor count in its exact real-power notation |
| Export pointwise and eventual forms | `rosenfeld_bound_pointwise`, `erdos_rosenfeld_bound` | Selected upstream variant |

Two source corrections were confirmed by visual inspection: the printed first interval comparison is reversed; and the strict upper-factor inequality needs an exception at the square endpoint with index zero. The direct non-strict argument handles both. It does not require the paper's second factor difference to exist for small n.

## Environment and acceptance criteria

Lean `leanprover/lean4:v4.33.1`; Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`, whose own toolchain file selects that Lean version. The complete dependency lock is `lake-manifest.json`; these working pins were reused from the local compatible environment. No upgrade or admitted target import is required.

Acceptance requires the whole library and independent check modules to compile with warnings failing; all inventoried final theorems, bridges and critical helpers to report only `propext`, `Classical.choice`, `Quot.sound`; dependency sources and configuration to match the lock; a clean project rebuild; and the separate AI semantic review. Cache reuse and the compiler/kernel trust limit must be recorded. Source review alone and a successful example do not satisfy these criteria.
