# Statement comparison: known bound versus full catalog question

## Conclusion

The accepted Lean theorem correctly proves the selected Erdős–Rosenfeld bound. It is **not equivalent to a complete solution of JSP-000737 / Erdős 886**. The earlier conversational description “exact catalog statement” was too broad; the correct description is “the exact known `rosenfeld_bound` variant associated with that catalog entry.”

The project contract and original semantic review already excluded the full open conjecture. This note makes the distinction explicit at the formula level. No Lean source, theorem statement, or dependency was changed during this audit.

## Implemented result

For every fixed real C>0, for all sufficiently large natural n,

\[
\#\{d\mid n: \sqrt n\le d\le\sqrt n+C n^{1/4}\}\le 1+C^2.
\]

`JSP737.erdos_rosenfeld_bound` exactly matches `Erdos886.erdos_886.variants.rosenfeld_bound` in [the pinned Formal Conjectures source](https://github.com/google-deepmind/formal-conjectures/blob/40e7c98697de6f66b8cbdbf641749ab39ed9c152/FormalConjectures/ErdosProblems/886.lean). The pointwise export additionally proves this for every positive n and C≥0. The mathematical source is the consequence of Proposition 4.1 on page 356 of [Erdős–Rosenfeld (1997)](https://matwbn.icm.edu.pl/ksiazki/aa/aa79/aa7944.pdf).

Checked: positive natural divisors, real C, closed endpoints, fourth-root exponent, real cardinality cast, and quantifier order. The n=0 extension follows only from the documented empty-divisor convention.

## Full underlying question

The separate `Erdos886.erdos_886` conjecture asks whether

\[
\forall\varepsilon>0\;\exists K\in\mathbb N\;\exists N\in\mathbb N\;
\forall n\ge N,\quad
\#\{d\mid n: \sqrt n<d<\sqrt n+n^{1/2-\varepsilon}\}\le K.
\]

K and N may depend on ε, but K must be independent of n. The [catalog row](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0701-0800.md#JSP-000737) gives only a broad verbal description and records Progress; it does not replace this precise quantified statement.

## Why the current theorem does not imply the full answer

For ε≥1/4 and n≥1, the interval in the conjecture lies inside the fourth-root interval with C=1, so the current theorem supplies a bound of two.

For 0<ε<1/4, the conjecture's interval is wider than a fixed-C fourth-root interval as n grows. Applying the pointwise theorem with

\[
C=n^{1/4-\varepsilon}
\]

gives only

\[
1+C^2=1+n^{1/2-2\varepsilon},
\]

which grows with n. This does not provide the required constant K(ε). The extra strength “every n” does not remove this gap. Open versus closed endpoints also does not remove it; our closed interval is stronger at the same width, but the missing exponent range uses wider intervals.

The paper's additional question on page 358 about one absolute constant independent of C is a separate question associated with JSP-000738. The bound 1+C² does not settle that either.

## Accurate status

Completed: a verified Lean formalization of the known arbitrary-C Erdős–Rosenfeld fourth-root divisor bound, with a pointwise strengthening.

Unproved by this project: the full all-ε Ruzsa conjecture behind JSP-000737. Successful compilation and axiom verification establish only the actual exported propositions. They do not establish full catalog completion or change the catalog's eligibility status.

Review method: coordinator comparison of current project definitions and theorem with the paper and Formal Conjectures, plus a separate AI scope review. Existing build evidence was preserved; code identity was checked against its recorded hashes. No new compiler run was needed for this semantic comparison.
