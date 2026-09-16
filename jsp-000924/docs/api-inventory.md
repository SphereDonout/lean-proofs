# API inventory

The environment-check module prints checked signatures for the installed congruence, power, proper-divisor and infinite-set APIs. Its output is included in the build logs.

The proof uses `Nat.ModEq` compatibility and divisibility lemmas, `Nat.mod_add_div`, `Nat.le_self_pow`, `Nat.one_le_pow`, `Nat.not_prime_of_dvd_of_lt`, `Nat.pow_left_injective`, and `Set.infinite_of_injective_forall_mem`.

Arithmetic and finite checks use `norm_num`, `fin_cases`, `ring`, `omega`, `nlinarith`, and ordinary checked `decide`. All proof terms are checked under the recorded foundation policy. The actual compiled source and axiom reports are the authoritative evidence.
