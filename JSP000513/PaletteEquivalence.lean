import JSP000513.MainTheorem

namespace JSP000513
universe u v w

/-- Injectively rename the colors of a particular list multicoloring. -/
theorem IsListMulticoloring.map_colors {V : Type u} {C : Type v} {D : Type w}
    {G : SimpleGraph V} {L : V → Finset C} {φ : V → Finset C} {b : ℕ}
    (h : IsListMulticoloring G L b φ) (e : C ↪ D) :
    IsListMulticoloring G (fun v => (L v).map e) b (fun v => (φ v).map e) := by
  classical
  refine ⟨fun v => Finset.map_subset_map.mpr (h.1 v),?_,?_⟩
  · intro v; simpa using h.2.1 v
  · intro x y hxy
    apply Finset.disjoint_left.mpr
    intro d hd hd'
    obtain ⟨c,hc,rfl⟩ := Finset.mem_map.mp hd
    obtain ⟨c',hc',he⟩ := Finset.mem_map.mp hd'
    have heq := e.injective he
    subst c'
    exact Finset.disjoint_left.mp (h.2.2 x y hxy) hc hc'

/-- Choosability descends along an injective embedding of palettes. -/
theorem ABChoosableOn.of_embedding {V : Type u} {C : Type v} {D : Type w}
    {G : SimpleGraph V} {a b : ℕ} (h : ABChoosableOn G D a b) (e : C ↪ D) :
    ABChoosableOn G C a b := by
  classical
  intro L hs
  obtain ⟨φ,hφ⟩ := h (fun v => (L v).map e) (fun v => by simpa using hs v)
  let τ (v : V) := (L v).filter (fun c => e c ∈ φ v)
  have heq (v : V) : (τ v).map e = φ v := by
    ext d
    constructor
    · intro hd
      obtain ⟨c,hc,rfl⟩ := Finset.mem_map.mp hd
      exact (Finset.mem_filter.mp hc).2
    · intro hd
      obtain ⟨c,hc,rfl⟩ := Finset.mem_map.mp (hφ.1 v hd)
      exact Finset.mem_map.mpr ⟨c,Finset.mem_filter.mpr ⟨hc,hd⟩,rfl⟩
  refine ⟨τ,fun v => Finset.filter_subset _ _,?_,?_⟩
  · intro v
    have hc := congrArg Finset.card (heq v)
    simpa [hφ.2.1 v] using hc
  · intro x y hxy
    apply Finset.disjoint_left.mpr
    intro c hc hc'
    exact Finset.disjoint_left.mp (hφ.2.2 x y hxy)
      (Finset.mem_filter.mp hc).2 (Finset.mem_filter.mp hc').2

/-- On a finite graph, only finitely many colors occur in any given list assignment.
Thus unrestricted natural-number colors are equivalent to arbitrary palettes. -/
theorem finite_palette_equivalence {V : Type u} [Fintype V] (G : SimpleGraph V)
    (a b : ℕ) (h : ABChoosable G a b) (Color : Type v) : ABChoosableOn G Color a b := by
  classical
  intro L hs
  let S : Finset Color := Finset.univ.biUnion L
  have hS (v : V) : L v ⊆ S := by
    intro c hc
    exact Finset.mem_biUnion.mpr ⟨v,Finset.mem_univ v,hc⟩
  let K (v : V) : Finset ↥S := (L v).subtype (fun c => c ∈ S)
  let e : ↥S ↪ ℕ := (Fintype.equivFin ↥S).toEmbedding.trans
    ⟨Fin.val,Fin.val_injective⟩
  have hK (v : V) : (K v).card = a := by
    rw [Finset.card_subtype,Finset.filter_eq_self.mpr (fun c hc => hS v hc)]
    exact hs v
  obtain ⟨φ,hφ⟩ := h.of_embedding e K hK
  have hm (v : V) : (K v).map (Function.Embedding.subtype _) = L v :=
    Finset.subtype_map_of_mem (fun c hc => hS v hc)
  have hc := hφ.map_colors (Function.Embedding.subtype _)
  refine ⟨fun v => (φ v).map (Function.Embedding.subtype _),?_,hc.2⟩
  intro v c hcv
  rw [← hm v]
  exact hc.1 v hcv

/-- The palette bridge requested in the original statement audit. -/
theorem finitePaletteEquivalence : FinitePaletteEquivalenceTarget := by
  intro n a b G
  exact ⟨fun h Color => finite_palette_equivalence G a b h Color,fun h => h ℕ⟩
end JSP000513
