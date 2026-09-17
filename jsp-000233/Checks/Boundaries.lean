import JSP233

/-!
Small cardinality checks at the empty-step and first modified cases.
The general proof does not depend on these computations.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false
set_option warn.sorry true

example : (JSP233.szaboFamily 1).card = 1 := by decide
example : (JSP233.szaboFamily 4).card = 7 := by decide
example : (JSP233.szaboFamily 5).card = 12 := by decide
example : (JSP233.szaboFamily 9).card = 39 := by decide
