# Independent semantic review

## Scope and method

This is a separate AI source and mathematical review of the implemented Izotov
fourth-power construction. It is not a human review, prize-authorized review,
or a run of an independently implemented Lean kernel checker.

The source is Filaseta, Finch and Kozek, *On Powers Associated with Sierpiński
Numbers, Riesel Numbers and Polignac's Conjecture*, author preprint dated
23 December 2007: [primary PDF](https://people.math.sc.edu/filaseta/papers/SierpinskiEtCoPapNew.pdf).
The selected argument is the unnumbered construction on printed page 6,
including equation (1), credited to A. S. Izotov. The positive-exponent
Sierpiński definition appears on page 1; the initial cover appears on pages
3–4. Theorem 1 and the later smaller-root Theorem 10 are separate results.

I reviewed the adopted statement contract and the actual definitions and
proofs in `Basic.lean`, `Composite.lean`, all four `Cover` modules, both
`Factorization` modules, `Universal.lean`, `Main.lean`, and the public umbrella.
The expanded statements were derived from the source's root progression,
definition and conclusion; the implementation definitions were then unfolded
to establish their correspondence. No missing mathematical step or scope
mismatch was found for the selected construction.

## Source correspondence

| Source content | Implemented meaning checked |
| --- | --- |
| Root progression on page 6 | `734110615000775 + 36893488147419103230 * t`, for every `t : ℕ`; the step is also proved equal to the paper's product modulus |
| `k = ℓ⁴` and `k·2ⁿ+1` | The fourth power applies to the whole root; the exponent `n` applies to the base 2 |
| Remaining six cover implications | A proper divisor exists for every exponent outside `n % 4 = 2`; finite residue verification is followed by universal modular lifting |
| Equation (1) for `n = 4u+2` | `x = root t * 2^u` exceeds one, and a proved polynomial identity gives two factors exceeding one |
| Compositeness | An actual natural divisor `d` with `1 < d`, `d < value`, and `d ∣ value` |
| Sierpiński definition | Positive odd `k` and compositeness at every positive exponent |
| Infinite progression consequence | A proved injective map into an explicitly infinite set of positive odd fourth powers |

The quantifier order is `∀ t : ℕ, ∀ n : ℕ, ∃ d : ℕ`. There is no hidden
positivity restriction on either parameter in the universal family theorem.
The divisor can depend on the parameters; it is not required to come from a
fixed finite set for all exponents. No theorem assumes the conclusion or a
prime-cover failure as a premise.

## Equivalent formalization choices

- The explicit given progression is checked directly; CRT existence,
  uniqueness and least-root claims are not needed.
- The six covering implications are represented by 48 residues modulo 64
  and a symbolic period-reduction proof. The 16 remaining residues use the
  factorization branch.
- The identity is written with `x = y + 1` as
  `4*(y+1)^4+1 = (2*y^2+2*y+1)*(2*y^2+6*y+5)`. This is equivalent to the
  source factorization and avoids truncated natural-number subtraction.
- Fixed divisors are shown to be proper and greater than one; primality and
  exact multiplicative orders are unnecessary for compositeness.
- The universal family statement includes the additional endpoint `n = 0`.
  The Sierpiński corollary retains the paper's positive-exponent convention.

These choices preserve the selected theorem. No claim of absence of a finite
prime cover, a new mathematical discovery, least-root optimality, or reward
eligibility is made.

## Independent compiled adapters

`Checks/Statement.lean` imports only the public `JSP924` umbrella and exports:

- `JSP924Checks.expanded_family_composite`: the literal numerical progression,
  both natural parameters, and all three explicit proper-divisor conditions.
- `JSP924Checks.expanded_infinite_family`: an explicitly infinite set of
  positive odd natural numbers, each with a fourth-power witness, for which
  every positive exponent has an explicit proper divisor.

The infinite-set adapter checks and rearranges the actual defining
conjunctions; it does not rely on a similarly named but unexpanded predicate.

## Boundary checks

`Checks/BoundaryCases.lean` imports the public umbrella plus Mathlib's finite
cardinality support. It proves:

- `parameter_zero`: the initial root works for every natural exponent.
- `exponent_zero_witness`: `6700417` is a divisor strictly between one and
  `(734110615000775 + 36893488147419103230*t)^4 + 1` for every natural `t`.
  This uses the actual modular transport and properness bounds.
- `exponent_two`: the first exceptional exponent follows from the
  exceptional branch, including quotient zero.
- `sophie_at_one_prime` and `sophie_at_one_not_composite`: at `x=1` the value
  is prime 5, confirming that the strict hypothesis cannot be dropped.
- `covered_residue_count` and `exceptional_residue_count`: kernel-checked
  finite cardinalities 48 and 16 for the complementary classes in `Fin 64`.

The cardinality checks support the semantic review. They do not replace the
already implemented finite-cover theorem or its universal lifting.

## Commands actually replayed by this reviewer

Working directory:

```text
.
```

After `. scripts/env.sh`, each of these direct source checks completed with
exit status **0**, using the project's Lean 4.33.1 environment:

```sh
lake env lean -DautoImplicit=false -DrelaxedAutoImplicit=false \
  -Dwarn.sorry=true -DwarningAsError=true Checks/Statement.lean
lake env lean -DautoImplicit=false -DrelaxedAutoImplicit=false \
  -Dwarn.sorry=true -DwarningAsError=true Checks/BoundaryCases.lean
```

The development checks produced no diagnostics on success. Historical development logs are omitted from this public bundle; fresh public-copy runs are recorded under `docs/evidence/normal/` and `docs/evidence/clean/`. The first boundary-check attempt exited 1 because `norm_num`
left `Nat.Prime 5` unsolved with the narrow imports. Replacing that single
proof with ordinary kernel-checked `decide` resolved the goal; the full
boundary module was then rerun successfully.

This reviewer did not perform the full rebuild or complete axiom-inventory replay. Those were separate coordinator acceptance stages; the public-copy results are recorded in final-verification.md.
The direct checks above are actual current-project checks, not the earlier
API probe evidence.

## Reviewed Lean source identities

| File | SHA-256 |
| --- | --- |
| `Checks/Statement.lean` | `f7b3ee59e89a6abe7af30bed0e56517c91f49fb0e4f70cfaba8e28102833e2da` |
| `Checks/BoundaryCases.lean` | `a66e2849671227830bc145003eed722b90484c9594d3dc2b31d727eb4e930f80` |
| `JSP924/Basic.lean` | `7b6da8f712fc68966739efd8a131eebfb180c0acd7ddb3e3fa4a03cb4a617eba` |
| `JSP924/Main.lean` | `2e54ab88a0922a7bccf75bb36108d5676cdbe93abfc91e5e1b5d59dba6122e29` |
| `JSP924/Universal.lean` | `16ce947bedd48efd4b9e301635ed990edfff04098ff4a181cceefba24b222637` |

The statement-contract prose was made portable for publication; the reviewed Lean source files remain byte-for-byte unchanged. Paths in this historical review are relative to the project root.

Conclusion: the reviewed public statements express the selected published
fourth-power construction, and the independently expanded adapters and focused
boundary checks compile. Overall project acceptance remains subject to the
separate clean-build, dependency-integrity and complete axiom-inventory gates.
