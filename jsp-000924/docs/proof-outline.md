# Proof outline

Let `A = 734110615000775`, `M = 36893488147419103230`, `L(t) = A + M*t` and `V(t,n) = L(t)^4*2^n+1`.

## Covered exponents

| Condition | Divisor |
| --- | ---: |
| n % 2 = 1 | 3 |
| n % 8 = 4 | 17 |
| n % 16 = 8 | 257 |
| n % 32 = 16 | 65537 |
| n % 64 = 32 | 641 |
| n % 64 = 0 | 6700417 |

Lean proves the closed numerical data, including `d | M`, `1 < d < A`, and `2^64 ≡ 1 mod d`. A complete finite certificate handles the 48 residue classes outside `n % 4 = 2`. Symbolic congruence lifting proves divisibility for all t,n in those classes. The bound `A < V(t,n)` makes each divisor proper.

## Exceptional exponents

For `n = 4*u+2`, write `x = L(t)*2^u > 1`. Then `V(t,n) = 4*x^4+1`. Writing `x=y+1` gives the natural-number identity

```text
4*(y+1)^4+1 = (2*y^2+2*y+1)*(2*y^2+6*y+5).
```

Both factors exceed one. The product therefore has a proper divisor. This handles the other 16 residue classes, including n=2.

## Final results

Combine the two branches for all natural t,n. Positivity and oddness give the Sierpiński predicate at positive exponents. The positive-step progression is injective, as is taking fourth powers on naturals; its range is infinite. Separate checks transcribe expanded conclusions and verify the zero endpoints and strict factorization boundary.
