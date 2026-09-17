# Independent semantic review

Reviewer: separate AI source reviewer. Date: 2026-09-17 UTC.
This is an independent AI review of source correspondence. It is not a human
review, a prize review, or an independent kernel check.

## Source and exact scope

Paul Erdős and Moshe Rosenfeld, *The factor-difference set of integers*, Acta
Arithmetica 79.4 (1997), 353–359. The selected result is the final paragraph of
the proof of Proposition 4.1, journal page 356 (PDF page 4).

- [Primary PDF](https://matwbn.icm.edu.pl/ksiazki/aa/aa79/aa7944.pdf)
- [DOI](https://doi.org/10.4064/aa-79-4-353-359)
- PDF SHA-256: `642f4b33a75f402c2c6a8150193540e5831f6daedb3f3130e84a7d5b6df5289f`

The relevant proof was read in extracted text and page 356 was rendered and
visually inspected. The selected assertion bounds the number of positive
integer divisors of n in the closed interval

    [sqrt(n), sqrt(n) + C * fourth_root(n)]

by the real number `1 + C^2`. The upstream Formal Conjectures formulation is
`∀ C > 0, ∀ᶠ n in atTop, ...`. The independent check transcribes this proposition
using real powers with exponents `(1 / 2 : ℝ)` and `(1 / 4 : ℝ)` and a real
coercion on the cardinality. It also checks the pointwise positive-integer
version for `C ≥ 0`.

This does not prove the full open Erdős 886 conjecture, the infinitely-many-four
divisors result, or Proposition 4.1 as a separately exported theorem.

## Source repairs and proof correspondence

The printed interval has a reversed first comparison `sqrt(n) ≥ d`. The
upper-factor argument and the upstream formal statement fix it to `sqrt(n) ≤ d`.
The printed strict inequality for its indexed upper factor also has a square
endpoint exception: for index zero and square n, equality is possible.

The formal proof counts the same integer factor sums used in the paper,
directly mapping d to `d + n / d` on the upper half of the divisors. It proves
that these distinct sums lie in `[2 sqrt(n), 2 sqrt(n) + C^2]`, then counts the
integers in that interval. This is a reformulation of the paper's factor-sum
spacing argument. It handles the closed endpoints using non-strict
inequalities and does not depend on the existence of the paper's `d_1(n)`.

## Implementation inspected

The reviewer read the accepted sources `Basic.lean`, `RealBounds.lean`,
`IntervalCount.lean`, `FactorSum.lean`, and `Main.lean` before writing the
independent check.

- `nearDivisors` filters `Nat.divisors n`; both comparisons are non-strict and
  the interval width is `C * sqrt(sqrt(n))`.
- `divisor_product` uses exact natural division under `d ∣ n`. The real
  factor product equals `sqrt(n)^2`.
- `factor_sum_bounds` requires the positive square root, nonnegative C and
  fourth root, the interval hypotheses, and the factor product. No conclusion
  equivalent to the cardinality theorem is assumed.
- `upper_factor_unique` derives upper-factor equality from equal products and
  sums. Its square endpoint branch is explicit.
- `factorSum_injective` uses positive n and both upper-half inequalities;
  it does not silently assume distinct sums.
- `nat_card_le_interval` treats empty sets separately. For a nonempty set it
  bounds cardinality by the integer interval between its minimum and maximum,
  then casts the resulting natural inequality to the reals.
- `nearDivisors_card_le` splits off n=0, using Mathlib's convention
  `Nat.divisors 0 = ∅`. The positive-n branch uses the proved injection and
  real interval bound. The mathematical paper is about positive integers;
  the n=0 extension is only this library convention.
- `fourth_root_eq_rpow` and `nearDivisors_eq_rpow` provide the real-power
  bridge. The exponents are real numbers and the nonnegative base hypothesis
  is supplied to `Real.rpow_mul`.
- `rosenfeld_bound_pointwise` has only n, C and `0 ≤ C` as parameters.
  `erdos_rosenfeld_bound` fixes C before the eventual quantifier and uses the
  pointwise theorem for every n. There is no hidden eventual threshold
  dependence or extra hypothesis.

No semantic weakening was found in this source review. The stronger C=0 and
n=0 conventions are documented above; the independent `paper_pointwise`
check retains the positive-n assumption from the mathematics.

## Independent check and evidence status

Owned check module: `Checks/Statement.lean`.
Named declarations added to the required axiom inventory:

- `JSP737Checks.paper_statement`
- `JSP737Checks.paper_pointwise`

The module also uses
`#check_failure Erdos886.erdos_886.variants.rosenfeld_bound` to ensure that the
upstream admitted theorem is absent from its import graph. This supplements
the transitive axiom reports; it does not replace them.

After the accepted library was built, the reviewer ran:

```sh
lake env lean -DautoImplicit=false -DrelaxedAutoImplicit=false \
  -DwarningAsError=true Checks/Statement.lean \
  > docs/evidence/statement-review.log 2>&1
```

Result: **exit 0**. The log contains the expanded types of both named checks.
Those types retain the real cardinality, closed interval, real exponents,
nonnegative-C pointwise hypothesis, and positive-C eventual quantifier order.
The logged `Unknown identifier` message is expected output from
`#check_failure`; it confirms absence of the upstream admitted declaration
and is not a failed compilation.

The separate semantic review and independently transcribed statement checks
are complete for the inspected sources. The coordinator owns the complete
transitive axiom audit, dependency integrity checks, focused boundary checks,
and clean project rebuild. This review does not claim that those later checks
have already passed, or that any proof checker independent of Lean was run.
