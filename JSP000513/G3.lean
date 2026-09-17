import JSP000513.SevenAttachment

namespace JSP000513.G3

abbrev Vertex := Fin 9 ⊕ (Fin 2 × Fin 7)
def cross (a : Fin 9) (b : Fin 2 × Fin 7) : Prop := a = 8 ∧ (b.2 = 0 ∨ b.2 = 1)
def graph : SimpleGraph Vertex := attach G2.graph (copies Seven.graph) cross
def lists : Vertex → Finset ℕ := Sum.elim G2.lists (fun v => Seven.lists v.1 v.2)
def halfSizes : Vertex → ℕ := Sum.elim G2.halfSizes (fun v => Seven.halfSizes v.2)
def boundary (i : Fin 2) : Vertex := .inr (i,6)

theorem lists_card (x : Vertex) : (lists x).card = 2 * halfSizes x := by
  cases x with
  | inl a => exact G2.lists_card a
  | inr b => exact Seven.lists_card b.1 b.2

universe u
variable {Color : Type u}

def combine (f : Fin 9 → Color) (g : Fin 2 → Fin 7 → Color) : Vertex → Color :=
  Sum.elim f (fun v => g v.1 v.2)

theorem combine_coloring (L : Vertex → Finset Color)
    (f : Fin 9 → Color) (g : Fin 2 → Fin 7 → Color)
    (hf : IsListColoring G2.graph (L ∘ Sum.inl) f)
    (hg : ∀ i, IsListColoring Seven.graph (fun v => L (.inr (i,v))) (g i))
    (hn : ∀ i, g i 0 ≠ f 8 ∧ g i 1 ≠ f 8) :
    IsListColoring graph L (combine f g) := by
  apply hf.attach (IsListColoring.copies g hg)
  intro a b h
  rcases h with ⟨rfl,hb⟩
  rcases b with ⟨i,v⟩
  dsimp at hb ⊢
  rcases hb with rfl | rfl
  · exact (hn i).1.symm
  · exact (hn i).2.symm

/-- DHS19 Lemma 6, relaxed extension property. -/
theorem half_list_relaxed [DecidableEq Color] (L : Vertex → Finset Color)
    (hs : ∀ x, (L x).card = halfSizes x) :
    StrongRelaxed graph L (.inl 0) (.inl 2) boundary := by
  classical
  let K : Fin 9 → Finset Color := L ∘ Sum.inl
  let T : Fin 2 → Fin 7 → Finset Color := fun i v => L (.inr (i,v))
  have hK (v : Fin 9) : (K v).card = G2.halfSizes v := hs (.inl v)
  have hT (i : Fin 2) (v : Fin 7) : (T i v).card = Seven.halfSizes v := hs (.inr (i,v))
  rcases G2.half_list_relaxed K hK with ⟨a,ha,b,hb,hext⟩ | ⟨heq,cs,hcs,hext⟩
  · have hflex (i : Fin 2) := Seven.flexible_extension (T i) (hT i)
    choose q hq using hflex
    obtain ⟨r,hr,hr0,hr1⟩ := exists_mem_avoiding_pair (K 8)
      (by rw [hK]; decide) (q 0) (q 1)
    have hrq (i : Fin 2) : r ≠ q i := by fin_cases i <;> assumption
    obtain ⟨f,hf,hfa,hfb,hfr⟩ := hext (fun _ => r) (fun _ => hr)
    have hf8 : f 8 = r := hfr 0
    apply Or.inl
    refine ⟨a,ha,b,hb,?_⟩
    intro ts hts
    have hparts (i : Fin 2) := hq i r (hrq i) (ts i) (hts i)
    choose g hg hg0 hg1 hgt using hparts
    refine ⟨combine f g, combine_coloring L f g hf hg
      (fun i => by rw [hf8]; exact ⟨hg0 i,hg1 i⟩),hfa,hfb,?_⟩
    intro i
    exact hgt i
  · let r := cs 0
    have hparts (i : Fin 2) := Seven.greedy_extension (T i) (hT i) r
    choose g hg hg0 hg1 using hparts
    apply Or.inr
    refine ⟨heq,fun i => g i 6,fun i => (hg i).1 6,?_⟩
    intro a ha b hb
    obtain ⟨f,hf,hfa,hfb,hfr⟩ := hext a ha b hb
    have hf8 : f 8 = r := hfr 0
    exact ⟨combine f g,combine_coloring L f g hf hg
      (fun i => by rw [hf8]; exact ⟨hg0 i,hg1 i⟩),hfa,hfb,fun _ => rfl⟩

/-- DHS19 Lemma 6: at least one terminal is the special pair. -/
theorem twofold_terminal_forced (φ : Vertex → Finset ℕ)
    (hφ : IsListMulticoloring graph lists 2 φ) :
    φ (boundary 0) = {7,8} ∨ φ (boundary 1) = {7,8} := by
  have hbase : IsListMulticoloring G2.graph G2.lists 2 (φ ∘ Sum.inl) :=
    hφ.comap Sum.inl (fun _ _ h => h)
  have hpart (i : Fin 2) : IsListMulticoloring Seven.graph (Seven.lists i) 2
      (fun v => φ (.inr (i,v))) :=
    hφ.comap (fun v => .inr (i,v)) (fun _ _ h => ⟨rfl,h⟩)
  have hforce (i : Fin 2) (hi : 7+i.val ∈ φ (.inl 8)) : φ (boundary i) = {7,8} := by
    apply Seven.twofold_terminal_forced i _ (hpart i)
    · exact Finset.disjoint_left.mp (hφ.2.2 (.inl 8) (.inr (i,0)) ⟨rfl,Or.inl rfl⟩) hi
    · exact Finset.disjoint_left.mp (hφ.2.2 (.inl 8) (.inr (i,1)) ⟨rfl,Or.inr rfl⟩) hi
  rcases G2.twofold_special_mem _ hbase with h7 | h8
  · exact Or.inl (hforce 0 h7)
  · exact Or.inr (hforce 1 h8)

end JSP000513.G3

