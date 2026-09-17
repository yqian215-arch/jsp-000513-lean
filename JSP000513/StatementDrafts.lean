import JSP000513.Definitions

/-!
# Unproved target statements

These are named propositions, not theorem declarations. Phase 0 provides
no proof of the full counterexample or of a palette-equivalence theorem.
-/

namespace JSP000513

/-- Draft of DHS19 Theorem 2 with natural-number colors and a finite
vertex type. No proof of this proposition is claimed. -/
def Theorem2NatTarget : Prop :=
  ∃ n : ℕ, ∃ G : SimpleGraph (Fin n),
    ABChoosable G 4 1 ∧ ¬ ABChoosable G 8 2

/-- A draft spelling out universal quantification over palettes in
`Type`. Its equivalence to the natural-number convention for finite
graphs remains unproved in this project. -/
def Theorem2AllPalettesTarget : Prop :=
  ∃ n : ℕ, ∃ G : SimpleGraph (Fin n),
    (∀ Color : Type, ABChoosableOn G Color 4 1) ∧
      ¬ (∀ Color : Type, ABChoosableOn G Color 8 2)

/-- Explicit outstanding bridge for palettes in `Type`.
This proposition is not used as a hypothesis or axiom in the PoC. -/
def FinitePaletteEquivalenceTarget : Prop :=
  ∀ (n a b : ℕ) (G : SimpleGraph (Fin n)),
    ABChoosable G a b ↔ ∀ Color : Type, ABChoosableOn G Color a b

end JSP000513
