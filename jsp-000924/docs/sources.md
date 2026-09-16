# Sources and attribution

## Mathematics

Michael Filaseta, Carrie Finch and Mark Kozek, *On Powers Associated with Sierpiński Numbers, Riesel Numbers and Polignac's Conjecture*, [author preprint, 23 December 2007](https://people.math.sc.edu/filaseta/papers/SierpinskiEtCoPapNew.pdf). This formalization follows the unnumbered Izotov construction on printed page 6 and equation (1), using the covering implications on page 3 and Sierpiński definition on page 1.

The exposition credits A. S. Izotov, *A note on Sierpiński numbers*, Fibonacci Quarterly 33 (1995), 206–207. Mathematical credit belongs to the original construction and its exposition.

The implemented result is the explicit fourth-power progression. Least-root optimality, CRT uniqueness, and absence of a finite prime cover are outside its scope. See statement-contract.md and semantic-review.md for exact correspondence and equivalent formalization choices.

## Formalization and tools

The new JSP924 modules and independent statement checks were produced in this workspace with OpenAI Codex assistance and separate AI review. Mathlib and Lean supply the supporting theory and kernel. The modular lifting and numerical certificates are proved in the included Lean modules.

`scripts/check_axioms.py` is copied unchanged from the local lean-paper-proof skill. Its SHA-256 is `cc25981609b43389aea1fa2d863cd4172dddc7e8f292d35a4c26b9a9368f9b89`. It enforces the stated inventory policy and does not replace the Lean compiler or semantic review.

The source is published here. No human referee review, independently implemented proof checker, award decision or prize submission is claimed.
