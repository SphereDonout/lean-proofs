# JSP-000924: the Izotov fourth-power construction

This standalone Lean 4 project formalizes the known construction in [Filaseta–Finch–Kozek, Section 2, printed page 6](https://people.math.sc.edu/filaseta/papers/SierpinskiEtCoPapNew.pdf#page=6), credited to Izotov.

For every natural `t` and `n`,

```text
(734110615000775 + 36893488147419103230*t)^4 * 2^n + 1
```

has a natural divisor strictly between 1 and itself. The project also proves that the corresponding positive odd fourth powers form an infinite family of Sierpiński numbers. The main theorem includes `n = 0`; the Sierpiński predicate uses positive exponents.

The absence of a finite prime cover is outside this result. This is a formalization of known mathematics, with no claim of a new solution to that broader question.

## Verify on an Apple Silicon Mac

Requires Git, Python 3.9+, `curl`, `tar`, `shasum`, and network access for first-time downloads:

```sh
git clone https://github.com/SphereDonout/lean-proofs.git
cd lean-proofs/jsp-000924
sh scripts/bootstrap.sh
sh scripts/verify.sh --clean
```

Bootstrap installs the pinned toolchain locally and fetches dependencies at the committed lockfile revisions. It currently supports arm64 macOS. It does not need the JSP-000092 project or the development prompt pack. Installed tools and dependency caches are excluded from Git.

## Other platforms with Elan already installed

From this project directory, with Git and Python 3.9+ also available:

```sh
elan toolchain install leanprover/lean4:v4.33.1
lake exe cache get
sh scripts/verify.sh --clean
```

The Lean source and verification script are portable; the recorded runs used arm64 macOS. Other platforms and first-time toolchain downloads were not independently tested for this publication.

The clean verification removes only this project's generated build outputs, retaining the toolchain and upstream caches. Expected summary:

```text
PASS: 15 Lean files; 32 axiom reports; 9 locked clean dependencies; clean project rebuild.
```

## Public interface

Import `JSP924`.

| Declaration | Result |
| --- | --- |
| `JSP924.family_value_composite` | Proper-divisor compositeness for every natural t,n |
| `JSP924.family_value_not_prime` | Nonprimality for every natural t,n |
| `JSP924.family_sierpinski` | Every constructed fourth power is a Sierpiński number |
| `JSP924.infinitely_many_fourth_power_sierpinski` | Infinitely many distinct positive odd fourth powers have the property |

See [the universal theorem](JSP924/Universal.lean), [the corollaries](JSP924/Main.lean), and [independently expanded statements](Checks/Statement.lean). The public interface uses the parameterized progression; it does not export a separate theorem with the paper's congruence hypothesis.

## Verification and attribution

- [Statement contract](docs/statement-contract.md) and [proof outline](docs/proof-outline.md)
- [Final verification report](docs/final-verification.md)
- [Normal run](docs/evidence/normal/verification.json) and [clean run](docs/evidence/clean/verification.json)
- [Separate AI semantic review](docs/semantic-review.md)
- [Environment and dependency pins](docs/environment.md)
- [Sources and attribution](docs/sources.md)
- [Completed task ledger](docs/progress.json)

Verification builds every accepted Lean module with warnings treated as failures, checks dependency source integrity, and audits all 32 named project/check theorems. Only `propext`, `Classical.choice` and `Quot.sound` are allowed. The kernel and retained upstream build caches are part of the recorded trust boundary; no independently implemented kernel replay or external human referee review is claimed.
