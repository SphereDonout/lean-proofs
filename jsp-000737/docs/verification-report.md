# Verification report

**Result: PASS.** The selected JSP-000737 general-C divisor bound is implemented, compiled, semantically reviewed against the source, and verified under the trust policy below. No unresolved proof obligation remains in the selected scope.

Publication-copy verification completed **17 September 2026 at 03:42:58 UTC**. This reran complete acceptance in the standalone repository subfolder. Machine-readable outcomes and exact commands: [verification-summary.json](evidence/verification-summary.json).

## Theorem and source

`JSP737.erdos_rosenfeld_bound`, in [JSP737/Main.lean](../JSP737/Main.lean), proves:

```lean
∀ C > (0 : ℝ), ∀ᶠ (n : ℕ) in Filter.atTop,
  ((n.divisors.filter (fun d : ℕ =>
    (n : ℝ) ^ (1 / 2 : ℝ) ≤ (d : ℝ) ∧
    (d : ℝ) ≤ (n : ℝ) ^ (1 / 2 : ℝ) +
      C * (n : ℝ) ^ (1 / 4 : ℝ))).card : ℝ) ≤ 1 + C ^ 2
```

This matches the known divisor-count consequence of Erdős–Rosenfeld, *The factor-difference set of integers* (1997), Proposition 4.1, page 356, and the selected Formal Conjectures `rosenfeld_bound` variant. The stronger pointwise theorem permits C=0 and every positive n; n=0 is handled separately by Mathlib's empty-divisor convention.

The proof uses a direct version of the paper's factor-sum spacing argument. Two source typos are corrected: the reversed lower interval comparison and an unjustified strict inequality at the square endpoint. Details and a lemma-to-source mapping are in the [statement contract](statement-contract.md). The source PDF and upstream statement hashes are recorded there.

The full open Erdős 886 problem and the infinite four-divisor construction are outside the verified scope.

## Environment

- Lean `4.33.1`, compiler commit `819816b2e0a3bf405af45ae5c7af2491d8f5bee6`, release build, arm64 macOS.
- Lake `5.0.0-src+819816b`, using Lean `4.33.1`.
- Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`.
- All nine Git dependencies match their full revisions in [lake-manifest.json](../lake-manifest.json).
- Dependency checks before and after verification found clean repositories and rehashed **9,541 source/configuration files** against their pinned Git blobs. Extra ignored source overrides and cached modules lacking tracked source names were checked.
- Formal Conjectures is not a dependency; its admitted target is absent from the accepted imports.

All dependency revisions and integrity outcomes: [dependency-integrity-after.txt](evidence/dependency-integrity-after.txt). Actual version outputs: [lean-version.txt](evidence/lean-version.txt), [lake-version.txt](evidence/lake-version.txt).

## Commands and results

Run from the project directory:

```sh
python3 scripts/verify.py
```

The script completed every command with **exit 0**. It first verified the existing project build, removed only the local `.lake/build` directory, and repeated full acceptance. The locked dependency sources, dependency build caches and selected toolchain were retained.

| Check | Outcome | Evidence |
|---|---|---|
| Dependency pins, clean source trees and import/configuration integrity | PASS before and after | [Integrity report](evidence/dependency-integrity-after.txt) |
| Entire accepted library and all check modules, `lake --wfail build ...` | PASS, initial and clean | [Clean build](evidence/build.txt) |
| Independent source proposition with explicit-variable flags and warnings failing | PASS | [Statement log](evidence/statement-check.txt) |
| n=0 convention, n=1/C=0, general positive-square endpoint and zero-width bound | PASS | [Boundary log](evidence/boundary-check.txt) |
| Expanded definitions and exported theorem types | Inspected | [Exported types](evidence/exported-types.txt) |
| Complete inventory of 17 transitive axiom reports | PASS, initial and clean | [Raw axioms](evidence/axioms.txt), [policy result](evidence/axiom-policy.txt) |
| No source/configuration change during verification | PASS | [Source hashes](evidence/source-hashes.json) |
| Separate AI review of mathematical correspondence | Complete; no semantic weakening found | [Semantic review](semantic-review.md) |

Check modules were explicitly compiled with `-DautoImplicit=false -DrelaxedAutoImplicit=false -Dwarn.sorry=true -DwarningAsError=true`. The expected `Unknown identifier` output from `#check_failure` in the statement check confirms that the admitted upstream theorem is absent; the check exits successfully.

## Trust policy and source identity

All 17 inventoried declarations, including both final results, the independent adapters, critical algebra/counting helpers, representation bridges and boundary theorems, report exactly:

```text
propext, Classical.choice, Quot.sound
```

No `sorryAx`, custom mathematical axiom or compiler-trusted computation axiom appears. A supplemental lexical inspection found only the intentional `warn.sorry` option settings, with no admission or unsafe proof shortcut. The transitive reports, rather than that lexical search, enforce the trust policy.

Accepted source/configuration inventory SHA-256:

```text
ada2035d34aab4da1a0fd9896c207c4d28a22897b198ae4471b2dc60483d3412
```

Main module SHA-256:

```text
06b2671b34612f8ca80d44c3bc6a4b82f15d31ce41f47acb17489972cc1b9c66
```

The inventory covers Lean sources, check inventory, toolchain, Lake configuration/lock and verification scripts. Documentation is not part of the code-identity hash. The exact per-file hashes are in [source-hashes.json](evidence/source-hashes.json).

## Review and limits

A separate AI agent derived the intended proposition from the primary paper, visually inspected page 356, reviewed the implementation, and compiled a separate statement adapter. Other agents implemented the isolated algebra and interval-counting cards; the coordinator assembled the natural-number bridges, final theorem and acceptance checks. These are AI reviews, not human or prize-authorized reviews.

The clean rebuild verifies this project's sources using the pinned Lean compiler/kernel and retained dependency caches. The cache module names were matched to pinned source names; dependency binary contents were not independently rebuilt or checked by another kernel. A fresh-machine/network installation and a distinct proof-checker implementation were not run. This package is published for reproduction; no awards submission or prize decision is implied.
