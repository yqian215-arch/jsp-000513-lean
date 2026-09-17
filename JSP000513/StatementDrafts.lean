import JSP000513.Definitions

/-!
# Target propositions

These preserve the original statement drafts. Their proofs are
`theorem2`, `theorem2_all_palettes`, and `finitePaletteEquivalence`.
-/

namespace JSP000513

/-- DHS19 Theorem 2 with natural-number colors and explicitly finite vertices. -/
def Theorem2NatTarget : Prop :=
  ∃ n : ℕ, ∃ G : SimpleGraph (Fin n),
    ABChoosable G 4 1 ∧ ¬ ABChoosable G 8 2

/-- The same counterexample with universal positive quantification over palettes. -/
def Theorem2AllPalettesTarget : Prop :=
  ∃ n : ℕ, ∃ G : SimpleGraph (Fin n),
    (∀ Color : Type, ABChoosableOn G Color 4 1) ∧
      ¬ (∀ Color : Type, ABChoosableOn G Color 8 2)

/-- Natural colors suffice for all finite-graph list multicoloring questions. -/
def FinitePaletteEquivalenceTarget : Prop :=
  ∀ (n a b : ℕ) (G : SimpleGraph (Fin n)),
    ABChoosable G a b ↔ ∀ Color : Type, ABChoosableOn G Color a b
end JSP000513
