import JSP000513.Definitions
import Mathlib.Data.Finset.Disjoint

namespace JSP000513

universe u v

/-- Ordinary list coloring, with an arbitrary color type. -/
def IsListColoring {V : Type u} {Color : Type v}
    (G : SimpleGraph V) (L : V → Finset Color) (f : V → Color) : Prop :=
  (∀ x, f x ∈ L x) ∧ ∀ x y, G.Adj x y → f x ≠ f y

def ListColorable {V : Type u} {Color : Type v}
    (G : SimpleGraph V) (L : V → Finset Color) : Prop :=
  ∃ f, IsListColoring G L f

theorem ListColorable.to_multicolorable {V : Type u} {Color : Type v}
    {G : SimpleGraph V} {L : V → Finset Color} (h : ListColorable G L) :
    ListMulticolorable G L 1 := by
  classical
  obtain ⟨f, hm, he⟩ := h
  refine ⟨fun x => {f x}, ?_, ?_, ?_⟩
  · intro x
    simpa using hm x
  · intro x
    simp
  · intro x y hxy
    simpa using he x y hxy

theorem ListMulticolorable.to_colorable {V : Type u} {Color : Type v}
    {G : SimpleGraph V} {L : V → Finset Color} (h : ListMulticolorable G L 1) :
    ListColorable G L := by
  classical
  obtain ⟨φ, hs, hc, he⟩ := h
  have hex (x : V) : ∃ c, φ x = {c} := Finset.card_eq_one.mp (hc x)
  choose f hf using hex
  refine ⟨f, ?_, ?_⟩
  · intro x
    exact hs x (by simp [hf x])
  · intro x y hxy
    simpa [hf x, hf y] using he x y hxy

theorem listColorable_iff_multicolorable_one {V : Type u} {Color : Type v}
    (G : SimpleGraph V) (L : V → Finset Color) :
    ListColorable G L ↔ ListMulticolorable G L 1 :=
  ⟨ListColorable.to_multicolorable, ListMulticolorable.to_colorable⟩

theorem ListColorable.mono {V : Type u} {Color : Type v}
    {G : SimpleGraph V} {L K : V → Finset Color}
    (h : ListColorable G L) (hLK : ∀ x, L x ⊆ K x) : ListColorable G K := by
  obtain ⟨f, hm, he⟩ := h
  exact ⟨f, fun x => hLK x (hm x), he⟩

end JSP000513
