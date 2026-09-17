# JSP-000233: Szabó's AP-intersection construction

Formalization target and provenance are in [docs/statement-contract.md](docs/statement-contract.md). The exact construction gives a known lower bound within the open Erdős 272 extremal question.

Toolchain: Lean `v4.33.1`; Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`; Formal Conjectures `40e7c98697de6f66b8cbdbf641749ab39ed9c152`. The manifest records transitive pins. A fresh checkout needs Lean's selected toolchain, the locked dependencies, and compatible Mathlib artifacts. With network access, `lake exe cache get` prepares the Mathlib cache; `lake build JSP233` builds the source modules. Run `sh scripts/verify.sh fresh` to check every lock revision, build the whole library and checks, validate the statement adapter and boundary cases, and audit transitive axioms.

The accepted implementation is in `JSP233/*.lean`; `JSP233.szabo_family` constructs the exact paper family, and `JSP233.szabo_lower_bound` is the corresponding Formal Conjectures extremal bound. [Verification results](docs/verification-report.md) include a clean project rebuild and the source-to-statement review. These are established results within an open catalog problem; the full extremal question remains open. This project has not been submitted to the Justin Sun Prize awards repository.
