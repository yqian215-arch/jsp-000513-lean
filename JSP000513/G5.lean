import JSP000513.G4
import JSP000513.G1

namespace JSP000513.G5
abbrev Vertex := G4.Vertex ⊕ Fin 5
/-- The new vertices are v2,v4,v5,x,y. -/
def remaining : Fin 5 → Fin 7 := ![1,3,4,5,6]
def small : SimpleGraph (Fin 5) where
  Adj a b := (a=1 ∧ b=2) ∨ (a=2 ∧ b=1) ∨ (a=3 ∧ b=4) ∨ (a=4 ∧ b=3)
  symm := ⟨by decide⟩
  loopless := ⟨by decide⟩
def cross (a : G4.Vertex) (b : Fin 5) : Prop :=
  (a=G4.first ∧ (b=0 ∨ b=2 ∨ b=3)) ∨
  (a=G4.third ∧ (b=0 ∨ b=1 ∨ b=4)) ∨
  (a=G4.boundary 0 ∧ (b=0 ∨ b=1)) ∨
  (a=G4.boundary 1 ∧ (b=3 ∨ b=4))
def graph : SimpleGraph Vertex := attach G4.graph small cross
def embed : Fin 7 → Vertex := ![.inl G4.first,.inr 0,.inl G4.third,.inr 1,.inr 2,.inr 3,.inr 4]
def extraLists : Fin 5 → Finset ℕ :=
  ![{1,4,5,6,7,8},{3,4,5,6,7,8},{2,4,5,6},{1,2,3,4,7,8},{1,2,7,8}]
def extraSizes : Fin 5 → ℕ := ![3,3,2,3,2]
def lists : Vertex → Finset ℕ := Sum.elim G4.lists extraLists
def halfSizes : Vertex → ℕ := Sum.elim G4.halfSizes extraSizes

theorem embed_adj (x y : Fin 7) (h : G1.graph.Adj x y) : graph.Adj (embed x) (embed y) := by
  fin_cases x <;> fin_cases y <;> simp [G1.graph] at h <;>
    simp [embed,graph,attach,cross,small]

theorem lists_card (v : Vertex) : (lists v).card = 2 * halfSizes v := by
  cases v with
  | inl a => exact G4.lists_card a
  | inr b => fin_cases b <;> decide

universe u
variable {Color : Type u}

theorem combine_coloring (L : Vertex → Finset Color)
    (f : G4.Vertex → Color) (g : Fin 7 → Color)
    (hf : IsListColoring G4.graph (L ∘ Sum.inl) f)
    (hg : IsListColoring G1.graph (L ∘ embed) g)
    (hfirst : f G4.first = g 0) (hthird : f G4.third = g 2)
    (h0 : f (G4.boundary 0) ≠ g 1 ∧ f (G4.boundary 0) ≠ g 3)
    (h1 : f (G4.boundary 1) ≠ g 5 ∧ f (G4.boundary 1) ≠ g 6) :
    IsListColoring graph L (Sum.elim f (g ∘ remaining)) := by
  apply hf.attach
  · constructor
    · intro v
      have h := hg.1 (remaining v)
      fin_cases v <;> exact h
    · intro a b h
      apply hg.2
      fin_cases a <;> fin_cases b <;> simp [small] at h <;> decide
  · intro a b h
    rcases h with ⟨rfl,hb⟩ | ⟨rfl,hb⟩ | ⟨rfl,hb⟩ | ⟨rfl,hb⟩
    · rw [hfirst]
      rcases hb with rfl | rfl | rfl <;> exact hg.2 _ _ (by decide)
    · rw [hthird]
      rcases hb with rfl | rfl | rfl <;> exact hg.2 _ _ (by decide)
    · rcases hb with rfl | rfl
      · exact h0.1
      · exact h0.2
    · rcases hb with rfl | rfl
      · exact h1.1
      · exact h1.2

/-- G1 with the four enlarged half-lists extends arbitrary values at v1,v3. -/
theorem augmented_extension [DecidableEq Color] (K : Fin 7 → Finset Color)
    (hs : ∀ v, (K v).card = (![3,3,3,3,2,3,2] : Fin 7 → ℕ) v)
    (a b : Color) (ha : a ∈ K 0) (hb : b ∈ K 2) :
    ∃ g, IsListColoring G1.graph K g ∧ g 0=a ∧ g 2=b := by
  obtain ⟨c1,hc1,hc1a,hc1b⟩ := exists_mem_avoiding_pair (K 1) (by rw [hs]; decide) a b
  obtain ⟨c4,hc4,hc4a⟩ := Finset.exists_mem_ne (s := K 4) (by rw [hs]; decide) a
  obtain ⟨c3,hc3,hc3b,hc3c4⟩ := exists_mem_avoiding_pair (K 3) (by rw [hs]; decide) b c4
  obtain ⟨cy,hcy,hcyb⟩ := Finset.exists_mem_ne (s := K 6) (by rw [hs]; decide) b
  obtain ⟨cx,hcx,hcxa,hcxcy⟩ := exists_mem_avoiding_pair (K 5) (by rw [hs]; decide) a cy
  refine ⟨![a,c1,b,c3,c4,cx,cy],⟨?_,?_⟩,rfl,rfl⟩
  · intro v; fin_cases v <;> assumption
  · intro x y h
    fin_cases x <;> fin_cases y <;> simp [G1.graph] at h <;> simp_all [ne_comm]


/-- With equal distinguished lists, delete the fixed terminal colors and apply G1. -/
theorem fixed_terminal_extension [DecidableEq Color] (K : Fin 7 → Finset Color)
    (hs : ∀ v, (K v).card = (![3,3,3,3,2,3,2] : Fin 7 → ℕ) v)
    (heq : K 0 = K 2) (r s : Color) :
    ∃ g, IsListColoring G1.graph K g ∧
      r ≠ g 1 ∧ r ≠ g 3 ∧ s ≠ g 5 ∧ s ≠ g 6 := by
  classical
  let T : Fin 7 → Finset Color := ![K 0,(K 1).erase r,K 2,(K 3).erase r,K 4,(K 5).erase s,(K 6).erase s]
  have hT (v : Fin 7) : G1.halfSizes v ≤ (T v).card := by
    have hv := hs v
    have her := Finset.pred_card_le_card_erase (s := K v) (a := r)
    have hes := Finset.pred_card_le_card_erase (s := K v) (a := s)
    fin_cases v <;> dsimp [T,G1.halfSizes] at hv her hes ⊢ <;> omega
  have hsub (v : Fin 7) : T v ⊆ K v := by
    fin_cases v <;> simp [T,Finset.erase_subset]
  have hchoose (v : Fin 7) := Finset.exists_subset_card_eq (hT v)
  choose M hMT hMc using hchoose
  have hM0 : M 0 = K 0 := Finset.eq_of_subset_of_card_le (hMT 0) (by rw [hs 0,hMc]; decide)
  have hM2 : M 2 = K 2 := Finset.eq_of_subset_of_card_le (hMT 2) (by rw [hs 2,hMc]; decide)
  obtain ⟨g,hg⟩ := G1.half_list_colorable M hMc (hM0.trans (heq.trans hM2.symm))
  refine ⟨g,⟨fun v => hsub v (hMT v (hg.1 v)),hg.2⟩,?_,?_,?_,?_⟩
  · exact (Finset.mem_erase.mp (hMT 1 (hg.1 1))).1.symm
  · exact (Finset.mem_erase.mp (hMT 3 (hg.1 3))).1.symm
  · exact (Finset.mem_erase.mp (hMT 5 (hg.1 5))).1.symm
  · exact (Finset.mem_erase.mp (hMT 6 (hg.1 6))).1.symm

/-- DHS19 Lemma 8, positive half, for every color type. -/
theorem half_list_colorable [DecidableEq Color] (L : Vertex → Finset Color)
    (hs : ∀ v, (L v).card = halfSizes v) : ListColorable graph L := by
  classical
  let K := L ∘ embed
  have hK (v : Fin 7) : (K v).card = (![3,3,3,3,2,3,2] : Fin 7 → ℕ) v := by
    have hv := hs (embed v)
    fin_cases v <;> exact hv
  have hbase (v : G4.Vertex) : (L (.inl v)).card = G4.halfSizes v := hs (.inl v)
  rcases G4.half_list_relaxed (L ∘ Sum.inl) hbase with
    ⟨a,ha,b,hb,hext⟩ | ⟨heq,rs,hrs,hext⟩
  · obtain ⟨g,hg,hga,hgb⟩ := augmented_extension K hK a b ha hb
    obtain ⟨r,hr,hr1,hr3⟩ := exists_mem_avoiding_pair (L (.inl (G4.boundary 0)))
      (by rw [hs]; decide) (g 1) (g 3)
    obtain ⟨s,hsL,hs5,hs6⟩ := exists_mem_avoiding_pair (L (.inl (G4.boundary 1)))
      (by rw [hs]; decide) (g 5) (g 6)
    obtain ⟨f,hf,hfa,hfb,hfr⟩ := hext ![r,s] (by intro i; fin_cases i <;> assumption)
    exact ⟨_,combine_coloring L f g hf hg (hfa.trans hga.symm) (hfb.trans hgb.symm)
      (by rw [hfr 0]; exact ⟨hr1,hr3⟩) (by rw [hfr 1]; exact ⟨hs5,hs6⟩)⟩
  · obtain ⟨g,hg,hr1,hr3,hs5,hs6⟩ := fixed_terminal_extension K hK heq (rs 0) (rs 1)
    obtain ⟨f,hf,hfa,hfb,hfr⟩ := hext (g 0) (hg.1 0) (g 2) (hg.1 2)
    exact ⟨_,combine_coloring L f g hf hg hfa hfb
      (by rw [hfr 0]; exact ⟨hr1,hr3⟩) (by rw [hfr 1]; exact ⟨hs5,hs6⟩)⟩

/-- DHS19 Lemma 8, negative half, by restricting back to G1. -/
theorem not_listMulticolorable : ¬ ListMulticolorable graph lists 2 := by
  rintro ⟨φ,hφ⟩
  have hbase : IsListMulticoloring G4.graph G4.lists 2 (φ ∘ Sum.inl) :=
    hφ.comap Sum.inl (fun _ _ h => h)
  have ht := G4.twofold_terminals_forced _ hbase
  have hn0 (v : Fin 5) (hv : v=0 ∨ v=1) : Disjoint (φ (.inr v)) {7,8} := by
    rw [← ht 0]
    exact hφ.2.2 _ _ (Or.inr (Or.inr (Or.inl ⟨rfl,hv⟩)))
  have hn1 (v : Fin 5) (hv : v=3 ∨ v=4) : Disjoint (φ (.inr v)) {7,8} := by
    rw [← ht 1]
    exact hφ.2.2 _ _ (Or.inr (Or.inr (Or.inr ⟨rfl,hv⟩)))
  apply G1.not_listMulticolorable
  refine ⟨φ ∘ embed,(hφ.comap embed embed_adj).mono_lists ?_⟩
  intro v c hc
  have hm := hφ.1 (embed v) hc
  have hzero := hn0 0 (Or.inl rfl)
  have hone := hn0 1 (Or.inr rfl)
  have hthree := hn1 3 (Or.inl rfl)
  have hfour := hn1 4 (Or.inr rfl)
  fin_cases v
  · exact hm
  · have hn := Finset.disjoint_left.mp hzero hc
    simp [lists,embed,extraLists,G1.lists] at hm ⊢
    simp only [Finset.mem_insert,Finset.mem_singleton] at hn
    omega
  · exact hm
  · have hn := Finset.disjoint_left.mp hone hc
    simp [lists,embed,extraLists,G1.lists] at hm ⊢
    simp only [Finset.mem_insert,Finset.mem_singleton] at hn
    omega
  · exact hm
  · have hn := Finset.disjoint_left.mp hthree hc
    simp [lists,embed,extraLists,G1.lists] at hm ⊢
    simp only [Finset.mem_insert,Finset.mem_singleton] at hn
    omega
  · have hn := Finset.disjoint_left.mp hfour hc
    simp [lists,embed,extraLists,G1.lists] at hm ⊢
    simp only [Finset.mem_insert,Finset.mem_singleton] at hn
    omega
end JSP000513.G5


