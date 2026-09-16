import Mathlib.Combinatorics.SimpleGraph.Coloring.Vertex
import Mathlib.Tactic

/-!
# The exact triple Specker graph

The edge pattern is XXYXYY, including all three cross inequalities.
The finite and ordinal parts of the project share this definition.
-/

namespace JSP092

universe u v

@[ext]
structure Triple (α : Type u) [LinearOrder α] where
  a : α
  b : α
  c : α
  ab : a < b
  bc : b < c

variable {α : Type u} {β : Type v} [LinearOrder α] [LinearOrder β]

def Up (x y : Triple α) : Prop :=
  x.b < y.a ∧ y.a < x.c ∧ x.c < y.b

def speckerGraph (α : Type u) [LinearOrder α] : SimpleGraph (Triple α) where
  Adj x y := Up x y ∨ Up y x
  symm := ⟨fun _ _ h => h.symm⟩
  loopless := ⟨fun x => by
    rintro (h | h)
    · exact (not_lt_of_ge x.ab.le) h.1
    · exact (not_lt_of_ge x.ab.le) h.1⟩

@[simp] theorem speckerGraph_adj (x y : Triple α) :
    (speckerGraph α).Adj x y ↔ Up x y ∨ Up y x := Iff.rfl

def Triple.map (f : α → β) (hf : StrictMono f) (x : Triple α) : Triple β :=
  ⟨f x.a, f x.b, f x.c, hf x.ab, hf x.bc⟩

@[simp] theorem Triple.map_a (f : α → β) (hf : StrictMono f) (x : Triple α) :
    (x.map f hf).a = f x.a := rfl

@[simp] theorem Triple.map_b (f : α → β) (hf : StrictMono f) (x : Triple α) :
    (x.map f hf).b = f x.b := rfl

@[simp] theorem Triple.map_c (f : α → β) (hf : StrictMono f) (x : Triple α) :
    (x.map f hf).c = f x.c := rfl

theorem Triple.map_up (f : α → β) (hf : StrictMono f) {x y : Triple α}
    (h : Up x y) : Up (x.map f hf) (y.map f hf) :=
  ⟨hf h.1, hf h.2.1, hf h.2.2⟩

theorem Triple.map_adj (f : α → β) (hf : StrictMono f) {x y : Triple α}
    (h : (speckerGraph α).Adj x y) :
    (speckerGraph β).Adj (x.map f hf) (y.map f hf) := by
  rcases h with h | h
  · exact Or.inl (Triple.map_up f hf h)
  · exact Or.inr (Triple.map_up f hf h)

end JSP092
