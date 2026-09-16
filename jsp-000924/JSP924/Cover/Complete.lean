import JSP924.Cover.Data
import JSP924.Cover.FiniteCertificate
import JSP924.Cover.Lift

namespace JSP924

/-- A covering divisor is proper for every parameter and every covered exponent. -/
theorem covered_composite (t n : ℕ) (hn : n % 4 ≠ 2) :
    Composite (value t n) := by
  have hr : (n % 64) % 4 ≠ 2 := by omega
  obtain ⟨d, hd, hzero⟩ := finite_cover ⟨n % 64, Nat.mod_lt n (by decide)⟩ hr
  obtain ⟨hgt, hlt, hstep, hperiod⟩ := cover_data d hd
  refine ⟨d, hgt, hlt.trans (seed_lt_value t n), ?_⟩
  have hz : Nat.ModEq d (seed ^ 4 * 2 ^ (n % 64) + 1) 0 := by
    simpa only [Nat.ModEq, Nat.zero_mod] using hzero
  exact Nat.modEq_zero_iff_dvd.mp ((value_modEq_residue t n d hstep hperiod).trans hz)

end JSP924
