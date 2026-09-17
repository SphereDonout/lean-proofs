# JSP-000737: the Erdős–Rosenfeld divisor bound

**Scope:** this project formalizes a known partial result associated with JSP-000737. The full catalog question (Erdős 886 / Ruzsa's conjecture) remains open. See the [explicit statement comparison](docs/scope-audit.md).

Lean formalization of the known general bound: for every real C > 0, all sufficiently large natural n have at most **1+C²** positive divisors in the closed interval

\[
[\sqrt n,\;\sqrt n+C n^{1/4}].
\]

The project proves the stronger pointwise result for every n ≥ 1 and C ≥ 0. An additional n=0 case follows from Mathlib's empty-divisor convention.

**Verification: PASS.** Full library/check builds, a clean project rebuild, source correspondence review and all 17 axiom audits passed. See the [verification report](docs/verification-report.md).

## Result and scope

- Exact eventual theorem: [`JSP737.erdos_rosenfeld_bound`](JSP737/Main.lean).
- Stronger pointwise theorem: `JSP737.rosenfeld_bound_pointwise`.
- [Statement contract and source correspondence](docs/statement-contract.md).
- [Independent AI semantic review](docs/semantic-review.md).
- [Verification report](docs/verification-report.md).
- [Proof-card ledger](docs/proof-cards.md).

This is the general C theorem associated with JSP-000737 / Erdős 886. The full open Ruzsa conjecture and the infinite four-divisor construction are outside this project. This repository publishes the formalization; publication does not establish prize eligibility. No awards submission is included in this publication.

## Mathematics and prior work

Paul Erdős and Moshe Rosenfeld, *The factor-difference set of integers*, Acta Arithmetica 79.4 (1997), 353–359: the consequence following Proposition 4.1 on page 356. [Paper](https://matwbn.icm.edu.pl/ksiazki/aa/aa79/aa7944.pdf), [DOI](https://doi.org/10.4064/aa-79-4-353-359).

The proof counts the distinct integer sums d+n/d of complementary factors. Each lies in [2√n, 2√n+C²], so there are at most C²+1. This reformulates the paper's factor-sum spacing argument and handles its two endpoint/inequality typos explicitly.

The previously published [AlphaProof C=1 proof](https://github.com/google-deepmind/formal-conjectures/pull/1942#discussion_r2749752508) is related prior work. A bounded public-proof and awards search on 16 September 2026, before this implementation, found no completed general-C proof in the sources checked. This is not a claim of universal absence or priority.

Formal Conjectures provides a [statement reference at revision `40e7c98697de6f66b8cbdbf641749ab39ed9c152`](https://github.com/google-deepmind/formal-conjectures/blob/40e7c98697de6f66b8cbdbf641749ab39ed9c152/FormalConjectures/ErdosProblems/886.lean). Its admitted theorems are not imported. Original mathematics is credited to the paper's authors; this implementation and review were AI-assisted with Codex and separate AI agents.

## Reproduce

Requirements: Elan, Git, and Python 3.9 or later. The selected versions are:

- Lean `leanprover/lean4:v4.33.1`.
- Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`.
- All nine dependency revisions are pinned in `lake-manifest.json`.

From this project directory, install the selected toolchain and obtain the locked dependency caches if necessary:

```sh
elan toolchain install leanprover/lean4:v4.33.1
lake exe cache get
python3 scripts/verify.py
```

Keep `lake-manifest.json` unchanged. The verification script rejects toolchain/configuration drift, dependency changes and import-path overrides. It checks dependency sources, builds the entire library and all check modules with warnings failing, checks 17 transitive axiom reports, then repeats after deleting only this project's `.lake/build` output. It retains toolchains and dependency caches.

The local development environment shares a compatible `.lake/packages` cache through a symlink. That generated directory is ignored and is not part of the source project. The source configuration uses public Git dependencies and no absolute local paths. The fresh network setup commands above are provided for reproduction; acceptance here used the existing locked dependencies and caches.

For a quick incremental compile:

```sh
lake --wfail build JSP737 Checks
```

## Trust and limitations

Permitted transitive axioms are only `propext`, `Classical.choice`, and `Quot.sound`. No admissions, custom mathematical axioms or compiler-trusted computation shortcuts are used. The statement check was independently transcribed by a separate AI reviewer, then compiled against the exported theorem.

Verification uses the pinned Lean compiler/kernel. A clean project rebuild is recorded; a full rebuild of dependency caches, a fresh machine installation, a separate proof-checker implementation and human review are not claimed. See the verification report for actual commands and evidence.
