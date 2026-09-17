import JSP000513.ListColoring

namespace JSP000513
universe u v w z

/-- Disjoint graph union with explicitly specified cross edges. -/
def attach {V : Type u} {W : Type v} (G : SimpleGraph V) (H : SimpleGraph W)
    (E : V → W → Prop) : SimpleGraph (V ⊕ W) where
  Adj x y := match x,y with
    | .inl a,.inl b => G.Adj a b
    | .inr a,.inr b => H.Adj a b
    | .inl a,.inr b => E a b
    | .inr b,.inl a => E a b
  symm := ⟨by
    intro x y h
    cases x <;> cases y
    · exact G.adj_symm h
    · exact h
    · exact h
    · exact H.adj_symm h⟩
  loopless := ⟨by
    intro x
    cases x
    · exact G.irrefl
    · exact H.irrefl⟩

/-- A family of disjoint copies, with no edges between distinct indices. -/
def copies {I : Type u} {V : Type v} (G : SimpleGraph V) : SimpleGraph (I × V) where
  Adj x y := x.1 = y.1 ∧ G.Adj x.2 y.2
  symm := ⟨fun _ _ h => ⟨h.1.symm,G.adj_symm h.2⟩⟩
  loopless := ⟨fun _ h => G.irrefl h.2⟩

theorem IsListColoring.attach {V : Type u} {W : Type v} {Color : Type w}
    {G : SimpleGraph V} {H : SimpleGraph W} {E : V → W → Prop}
    {L : V ⊕ W → Finset Color} {f : V → Color} {g : W → Color}
    (hf : IsListColoring G (L ∘ Sum.inl) f)
    (hg : IsListColoring H (L ∘ Sum.inr) g)
    (hcross : ∀ a b, E a b → f a ≠ g b) :
    IsListColoring (attach G H E) L (Sum.elim f g) := by
  constructor
  · intro x
    cases x with
    | inl a => exact hf.1 a
    | inr b => exact hg.1 b
  · intro x y hxy
    cases x <;> cases y
    · exact hf.2 _ _ hxy
    · exact hcross _ _ hxy
    · exact (hcross _ _ hxy).symm
    · exact hg.2 _ _ hxy

theorem IsListColoring.copies {I : Type u} {V : Type v} {Color : Type w}
    {G : SimpleGraph V} {L : I × V → Finset Color} (f : I → V → Color)
    (hf : ∀ i, IsListColoring G (fun v => L (i,v)) (f i)) :
    IsListColoring (copies G) L (fun x => f x.1 x.2) := by
  constructor
  · intro x
    exact (hf x.1).1 x.2
  · rintro ⟨i,a⟩ ⟨j,b⟩ ⟨hij,hab⟩
    dsimp at hij
    subst j
    exact (hf i).2 a b hab

theorem IsListMulticoloring.comap {V : Type u} {W : Type v} {Color : Type w}
    {G : SimpleGraph V} {H : SimpleGraph W} {L : W → Finset Color}
    {φ : W → Finset Color} {b : ℕ}
    (h : IsListMulticoloring H L b φ) (f : V → W)
    (hf : ∀ x y, G.Adj x y → H.Adj (f x) (f y)) :
    IsListMulticoloring G (L ∘ f) b (φ ∘ f) :=
  ⟨fun x => h.1 (f x),fun x => h.2.1 (f x),fun x y hxy => h.2.2 _ _ (hf x y hxy)⟩

theorem IsListMulticoloring.mono_lists {V : Type u} {Color : Type v}
    {G : SimpleGraph V} {L K : V → Finset Color} {φ : V → Finset Color} {b : ℕ}
    (h : IsListMulticoloring G L b φ) (hK : ∀ x, φ x ⊆ K x) :
    IsListMulticoloring G K b φ := ⟨hK,h.2⟩

end JSP000513

