import JSP000513.FinalConstruction
import JSP000513.StatementDrafts
import Mathlib.Data.Fintype.EquivFin
import Mathlib.Data.Fintype.Sum
import Mathlib.Data.Fintype.Prod
import Mathlib.Combinatorics.SimpleGraph.Maps

namespace JSP000513
universe u v w

/-- Reindex vertices by an equivalence without changing choosability. -/
theorem choosable_comap_equiv {V : Type u} {W : Type v} (G : SimpleGraph W)
    (e : V ≃ W) (Color : Type w) (a b : ℕ) :
    ABChoosableOn (G.comap e) Color a b ↔ ABChoosableOn G Color a b := by
  constructor
  · intro h L hs
    obtain ⟨φ,hφ⟩ := h (L ∘ e) (fun x => hs (e x))
    refine ⟨φ ∘ e.symm,?_,fun x => hφ.2.1 _,?_⟩
    · intro x c hc
      simpa using hφ.1 (e.symm x) hc
    · intro x y hxy
      exact hφ.2.2 _ _ (by simpa using hxy)
  · intro h L hs
    obtain ⟨φ,hφ⟩ := h (L ∘ e.symm) (fun x => hs (e.symm x))
    refine ⟨φ ∘ e,?_,fun x => hφ.2.1 _,?_⟩
    · intro x c hc
      simpa using hφ.1 (e x) hc
    · intro x y hxy
      exact hφ.2.2 _ _ hxy

namespace Final
noncomputable def vertexEquiv := (Fintype.equivFin Vertex).symm
noncomputable def finiteGraph : SimpleGraph (Fin (Fintype.card Vertex)) := graph.comap vertexEquiv

theorem finiteGraph_four_choosable (Color : Type u) : ABChoosableOn finiteGraph Color 4 1 :=
  (choosable_comap_equiv graph vertexEquiv Color 4 1).mpr (four_choosable_on Color)

theorem finiteGraph_not_eight_two : ¬ ABChoosable finiteGraph 8 2 := by
  intro h
  exact not_eight_two_choosable ((choosable_comap_equiv graph vertexEquiv ℕ 8 2).mp h)
end Final

/-- JSP-000513 / DHS19 Theorem 2, with the original natural-color statement. -/
theorem theorem2 : Theorem2NatTarget :=
  ⟨Fintype.card Final.Vertex,Final.finiteGraph,
    Final.finiteGraph_four_choosable ℕ,Final.finiteGraph_not_eight_two⟩

/-- The same finite witness supports arbitrary color palettes on the positive side. -/
theorem theorem2_all_palettes : Theorem2AllPalettesTarget :=
  ⟨Fintype.card Final.Vertex,Final.finiteGraph,
    Final.finiteGraph_four_choosable,fun h => Final.finiteGraph_not_eight_two (h ℕ)⟩
end JSP000513

