import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Data.Finset.Card
import Mathlib.Data.Finset.Lattice.Basic

/-!
# List multicoloring definitions

The definitions follow Dvořák–Hu–Sereni, arXiv:1806.03880v2, p. 2.
Lists have exactly `a` colors; a coloring selects exactly `b` colors at
each vertex. The palette is explicit and is not assumed finite.
-/

namespace JSP000513

universe u v

/-- A particular assignment of finite color sets respects the lists,
has exactly `b` colors per vertex, and is disjoint on every edge. -/
def IsListMulticoloring {V : Type u} {Color : Type v}
    (G : SimpleGraph V) (L : V → Finset Color) (b : ℕ)
    (φ : V → Finset Color) : Prop :=
  (∀ x, φ x ⊆ L x) ∧
  (∀ x, (φ x).card = b) ∧
  (∀ x y, G.Adj x y → Disjoint (φ x) (φ y))

/-- Existence of an `(L : b)`-coloring for a specified list assignment. -/
def ListMulticolorable {V : Type u} {Color : Type v}
    (G : SimpleGraph V) (L : V → Finset Color) (b : ℕ) : Prop :=
  ∃ φ : V → Finset Color, IsListMulticoloring G L b φ

/-- `(a : b)`-choosability on an explicit, possibly infinite palette.
The paper uses positive `b ≤ a`; this total definition also accepts
other natural numbers without asserting any theorem about them. -/
def ABChoosableOn {V : Type u} (G : SimpleGraph V)
    (Color : Type v) (a b : ℕ) : Prop :=
  ∀ L : V → Finset Color,
    (∀ x, (L x).card = a) → ListMulticolorable G L b

/-- Working convention: unrestricted natural-number colors. -/
def ABChoosable {V : Type u} (G : SimpleGraph V) (a b : ℕ) : Prop :=
  ABChoosableOn G ℕ a b

end JSP000513
