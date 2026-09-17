# Verification report — JSP-000233

Checked **17 September 2026**, ending approximately **05:00 UTC**. This reports an implemented proof of Szabó's explicit finite lower-bound construction; it does not claim the full Erdős 272 extremal problem.

## Mathematical claim and correspondence

The primary source is Tibor Szabó, *Intersection properties of subsets of integers*, European Journal of Combinatorics 20(5) (1999), Section 5, printed page 21. The visually inspected [author-hosted PDF](https://page.mi.fu-berlin.de/szabo/PDF/aps.pdf#page=21) has SHA-256 `bf837ef30c3538b2b44aea5d335cad9f75959066ccc119f01d89e79490dfdd78`. The paper constructs a family on `[1,N]` of size `choose(N,2)+1+floor((N−1)/4)`, with every intersection of two distinct members a nonempty arithmetic progression.

The exact Lean endpoint is `JSP233.szabo_family` in `JSP233/Main.lean`, with quantifiers `∀ N : ℕ, 1 ≤ N → ∃ C : Finset (Finset ℕ), Erdos272.IsArithInterSet N C ∧ C.card = N.choose 2 + 1 + (N-1)/4`. The companion `JSP233.szabo_lower_bound` proves the corresponding inequality for `Erdos272.maxArithInterCard N`. `Checks/Statement.lean` independently transcribes the family condition and derives it from the endpoint. `Checks/Semantics.lean` prints both the upstream definitions and exported theorem types; the output is in `docs/evidence/clean-semantics.txt`.

The implementation uses the paper's center `c=⌈N/2⌉=(N+1)/2`, starting family of sets containing `c` of size at most three, the two excluded triples for each `1≤d≤⌊(N−1)/4⌋`, and the three inserted centered windows. The base family is encoded by the singleton `{c}` and the images of all two-element subsets of `[1,N]` under insertion of `c`. This coding is equivalent to the paper's prose and makes its count bijective. The paper calls the intersection property clear; the Lean proof supplies explicit classification of the six triples through `c` inside a five-point window, excludes the two non-AP triples, and treats equal, different, and doubled step sizes for two added windows. This fills an omitted argument without changing the stated result.

The upstream `Erdos272.IsArithInterSet` has exactly a ground-set powerset condition and `Set.Pairwise` nonempty `Set.IsAPOfLength` intersections. The maximum is its natural-number `sSup`. The check module states the pairwise quantifiers directly, and the exported extremal inequality bounds the `sSup` using the cardinality of the ground-set powerset. Small checks cover `N=1,4,5,9`; the theorem covers every `N≥1`.

## Environment and dependency integrity

`lean-toolchain` is `leanprover/lean4:v4.33.1`. The run reported Lean `4.33.1` (commit `819816b2e0a3bf405af45ae5c7af2491d8f5bee6`) and Lake `5.0.0-src+819816b`. Direct dependency commits are Mathlib `0df444a360eaa60ab8c11dca51a86af692955474` and Formal Conjectures `40e7c98697de6f66b8cbdbf641749ab39ed9c152`. `lake-manifest.json` pins ten Git packages including transitives. `scripts/check_pins.py` compared every installed package HEAD to its manifest revision and checked each dependency source tree clean. It also records SHA-256 hashes for accepted source files and configuration in `docs/evidence/clean-pins.txt`.

The `.lake/packages` path in this workspace is a local symlink to an existing checkout of the **same locked dependency commits**. Dependency caches and toolchains were retained. A new checkout can fetch the locked packages and cache artifacts as described in the README.

## Commands and results

First run: `sh scripts/verify.sh initial` — exit 0. The statement, axiom, and boundary checks were then added. Latest run: removed only this project's `.lake/build`, then executed `sh scripts/verify.sh clean` — **exit 0**. Logs in `docs/evidence/clean-*` record:

- `lake --wfail build JSP233 Checks` — exit 0, complete accepted library and check modules rebuilt from a clean **project** build directory.
- `lake env lean -DautoImplicit=false -DrelaxedAutoImplicit=false -DwarningAsError=true Checks/Statement.lean` — exit 0.
- The same command on `Checks/Boundaries.lean`, `Checks/Semantics.lean`, and `Checks/Axioms.lean` — exit 0 for each.
- `scripts/check_axioms.py --expected Checks/axiom-targets.txt --log docs/evidence/clean-axioms.txt` — exit 0; all eight required transitive reports appeared exactly once and contained only `propext`, `Classical.choice`, `Quot.sound`.

No accepted proof module contains `sorry`, `admit`, a custom mathematical axiom, or `native_decide`. The upstream Formal Conjectures problem file contains admitted **other** theorem statements; the transitive reports show that the proved endpoints do not depend on them. The boundary checks use kernel-checked `decide` only for four finite sample cardinalities. This was a clean project rebuild with retained, pinned dependency artifacts, not a fresh network checkout or independent kernel implementation.

## Review and limits

I reviewed the paper's page 21 visually, expanded the Formal Conjectures definitions, and checked the exact ground set, distinctness condition, positive progression length, natural subtraction, uniform `N≥1` quantification, cardinality, and the `sSup` bridge. This is an **AI semantic review in the implementation session**. No separate human or independent AI reviewer has examined the proof. Lean's compiler/kernel checked the formal declarations under the stated foundations. The original paper's broader asymptotic upper bound and the open exact extremal value remain outside scope.

A final public duplicate check at about **05:00 UTC** found no issue or pull request mentioning `JSP-000233`; the recently updated awards records also showed no semantic overlap. No submission was made. The [catalog entry](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0201-0300.md#JSP-000233) currently says `Eligible to claim: No`; this formalization does not establish award eligibility.
