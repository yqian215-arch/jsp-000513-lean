import JSP000513.NineAttachment

namespace JSP000513.G4
abbrev Vertex := G3.Vertex ⊕ Nine.Vertex
def cross (a : G3.Vertex) (b : Nine.Vertex) : Prop :=
  (∃ i, a = G3.boundary i) ∧ b = .inl 0
def graph : SimpleGraph Vertex := attach G3.graph Nine.graph cross
def lists : Vertex → Finset ℕ := Sum.elim G3.lists Nine.lists
def halfSizes : Vertex → ℕ := Sum.elim G3.halfSizes Nine.halfSizes
def boundary (i : Fin 2) : Vertex := .inr (Nine.boundary i)
def first : Vertex := .inl (.inl 0)
def third : Vertex := .inl (.inl 2)

theorem lists_card (v : Vertex) : (lists v).card = 2 * halfSizes v := by
  cases v with
  | inl a => exact G3.lists_card a
  | inr b => exact Nine.lists_card b

universe u
variable {Color : Type u}

theorem combine_coloring (L : Vertex → Finset Color)
    (f : G3.Vertex → Color) (g : Nine.Vertex → Color)
    (hf : IsListColoring G3.graph (L ∘ Sum.inl) f)
    (hg : IsListColoring Nine.graph (L ∘ Sum.inr) g)
    (hn : ∀ i, g (.inl 0) ≠ f (G3.boundary i)) :
    IsListColoring graph L (Sum.elim f g) := by
  apply hf.attach hg
  rintro a b ⟨⟨i,rfl⟩,rfl⟩
  exact (hn i).symm

/-- DHS19 Lemma 7, positive extension property. -/
theorem half_list_relaxed [DecidableEq Color] (L : Vertex → Finset Color)
    (hs : ∀ v, (L v).card = halfSizes v) :
    StrongRelaxed graph L first third boundary := by
  classical
  let K := L ∘ Sum.inl
  let T := L ∘ Sum.inr
  have hK (v : G3.Vertex) : (K v).card = G3.halfSizes v := hs (.inl v)
  have hT (v : Nine.Vertex) : (T v).card = Nine.halfSizes v := hs (.inr v)
  rcases G3.half_list_relaxed K hK with ⟨a,ha,b,hb,hext⟩ | ⟨heq,rs,hrs,hext⟩
  · have hR (i : Fin 2) : (K (G3.boundary i)).card = 3 := hK (G3.boundary i)
    obtain ⟨rs,hrs,hextT⟩ := Nine.flexible_extension T hT (K ∘ G3.boundary) hR
    obtain ⟨f,hf,hfa,hfb,hfr⟩ := hext rs hrs
    refine Or.inl ⟨a,ha,b,hb,?_⟩
    intro ts hts
    obtain ⟨g,hg,hgn,hgt⟩ := hextT ts hts
    exact ⟨Sum.elim f g,combine_coloring L f g hf hg
      (fun i => by rw [hfr]; exact hgn i),hfa,hfb,hgt⟩
  · obtain ⟨g,hg,hgn⟩ := Nine.greedy_extension T hT rs
    refine Or.inr ⟨heq,g ∘ Nine.boundary,fun i => hg.1 _,?_⟩
    intro a ha b hb
    obtain ⟨f,hf,hfa,hfb,hfr⟩ := hext a ha b hb
    exact ⟨Sum.elim f g,combine_coloring L f g hf hg
      (fun i => by rw [hfr]; exact hgn i),hfa,hfb,fun _ => rfl⟩

/-- A red six-element list next to the special pair reduces to the four ordinary colors. -/
theorem ordinary_subset (A : Finset ℕ) (hA : A ⊆ {1,2,3,4,7,8})
    (hd : Disjoint A {7,8}) : A ⊆ {1,2,3,4} := by
  intro c hc
  have hm := hA hc
  have hn := Finset.disjoint_left.mp hd hc
  simp only [Finset.mem_insert,Finset.mem_singleton] at hm hn ⊢
  omega

/-- DHS19 Lemma 7: both new terminals are forced to the special pair. -/
theorem twofold_terminals_forced (φ : Vertex → Finset ℕ)
    (hφ : IsListMulticoloring graph lists 2 φ) :
    ∀ i, φ (boundary i) = {7,8} := by
  have hbase : IsListMulticoloring G3.graph G3.lists 2 (φ ∘ Sum.inl) :=
    hφ.comap Sum.inl (fun _ _ h => h)
  obtain ⟨i,hi⟩ : ∃ i, φ (.inl (G3.boundary i)) = {7,8} := by
    rcases G3.twofold_terminal_forced _ hbase with h | h
    · exact ⟨0,h⟩
    · exact ⟨1,h⟩
  have hd : Disjoint (φ (.inr (.inl 0))) {7,8} := by
    rw [← hi]
    exact hφ.2.2 _ _ ⟨⟨i,rfl⟩,rfl⟩
  have hmain : φ (.inr (.inl 2)) = {7,8} := by
    apply special_triangle_forcing (φ (.inr (.inl 0))) (φ (.inr (.inl 1))) _
      (hφ.2.1 _) (hφ.2.1 _) (hφ.2.1 _)
      (ordinary_subset _ (hφ.1 _) hd) (hφ.1 _) (hφ.1 _)
    · exact hφ.2.2 _ _ (by change (0 : Fin 3) ≠ 1; decide)
    · exact hφ.2.2 _ _ (by change (2 : Fin 3) ≠ 0; decide)
    · exact hφ.2.2 _ _ (by change (2 : Fin 3) ≠ 1; decide)
  intro j
  have hdj : Disjoint (φ (.inr (.inr (j,0)))) {7,8} := by
    rw [← hmain]
    exact hφ.2.2 _ _ ⟨rfl,rfl⟩
  apply special_triangle_forcing (φ (.inr (.inr (j,0)))) (φ (.inr (.inr (j,1)))) _
    (hφ.2.1 _) (hφ.2.1 _) (hφ.2.1 _)
    (ordinary_subset _ (hφ.1 _) hdj) (hφ.1 _) (hφ.1 _)
  · exact hφ.2.2 _ _ ⟨rfl,by change (0 : Fin 3) ≠ 1; decide⟩
  · exact hφ.2.2 _ _ ⟨rfl,by change (2 : Fin 3) ≠ 0; decide⟩
  · exact hφ.2.2 _ _ ⟨rfl,by change (2 : Fin 3) ≠ 1; decide⟩
end JSP000513.G4
