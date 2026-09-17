import JSP000513.C5General
import JSP000513.Relaxed

namespace JSP000513.G2

/-- Indices 0..4 are the cycle, and 5..8 are y1..y4. -/
def graph : SimpleGraph (Fin 9) where
  Adj x y := (x,y) ∈
    ({(0,1),(1,0),(1,2),(2,1),(2,3),(3,2),(3,4),(4,3),(4,0),(0,4),
      (0,5),(5,0),(1,5),(5,1),(2,5),(5,2),(3,5),(5,3),(4,5),(5,4),
      (5,6),(6,5),(6,7),(7,6),(6,8),(8,6),(7,8),(8,7)} : Finset (Fin 9 × Fin 9))
  symm := ⟨by decide⟩
  loopless := ⟨by decide⟩

instance : DecidableRel graph.Adj := fun _ _ => by unfold graph; infer_instance

def lists : Fin 9 → Finset ℕ :=
  ![{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},
    {1,2,3,4,5,6,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8}]

def halfSizes : Fin 9 → ℕ := ![3,3,3,3,3,4,3,2,3]
def cycleVertex (x : Fin 5) : Fin 9 := x.castLE (by decide)
def boundary : Fin 1 → Fin 9 := fun _ => 8

theorem lists_card : ∀ x, (lists x).card = 2 * halfSizes x := by decide
theorem cycle_adj : ∀ x y, C5.graph.Adj x y → graph.Adj (cycleVertex x) (cycleVertex y) := by decide
theorem cycle_center_adj : ∀ x, graph.Adj (cycleVertex x) 5 := by decide

universe u
variable {Color : Type u}

def combine (f : Fin 5 → Color) (c d e t : Color) : Fin 9 → Color :=
  ![f 0,f 1,f 2,f 3,f 4,c,d,e,t]

set_option maxHeartbeats 1200000 in
theorem combine_coloring (L : Fin 9 → Finset Color) (f : Fin 5 → Color)
    (c d e t : Color)
    (hf : IsListColoring C5.graph (L ∘ cycleVertex) f)
    (hne : ∀ x, f x ≠ c) (hc : c ∈ L 5) (hd : d ∈ L 6)
    (he : e ∈ L 7) (ht : t ∈ L 8)
    (hcd : c ≠ d) (hde : d ≠ e) (hdt : d ≠ t) (het : e ≠ t) :
    IsListColoring graph L (combine f c d e t) := by
  have hm0 := hf.1 0
  have hm1 := hf.1 1
  have hm2 := hf.1 2
  have hm3 := hf.1 3
  have hm4 := hf.1 4
  have h01 := hf.2 0 1 (by decide)
  have h12 := hf.2 1 2 (by decide)
  have h23 := hf.2 2 3 (by decide)
  have h34 := hf.2 3 4 (by decide)
  have h40 := hf.2 4 0 (by decide)
  have hn0 := hne 0
  have hn1 := hne 1
  have hn2 := hne 2
  have hn3 := hne 3
  have hn4 := hne 4
  constructor
  · intro x
    fin_cases x <;> simp_all [combine,Function.comp_def,cycleVertex]
  · intro x y hxy
    fin_cases x <;> fin_cases y <;> simp [graph] at hxy <;>
      simp_all [combine,ne_comm]

/-- DHS19 Lemma 5: both relaxed extension alternatives, with the
original quantifier order and arbitrary half-list palettes. -/
theorem half_list_relaxed [DecidableEq Color] (L : Fin 9 → Finset Color)
    (hsize : ∀ x, (L x).card = halfSizes x) :
    StrongRelaxed graph L 0 2 boundary := by
  classical
  let K : Fin 5 → Finset Color := L ∘ cycleVertex
  have hK (x : Fin 5) : (K x).card = 3 := by
    fin_cases x <;> simp [K,cycleVertex,hsize,halfSizes]
  by_cases hall : ∀ x, K x = K 0
  · have hnot : ¬ L 5 ⊆ K 0 := by
      intro h
      have hc := Finset.card_le_card h
      have hs5 : (L 5).card = 4 := by simpa [halfSizes] using hsize 5
      have := hK 0
      omega
    obtain ⟨c,hc,hcn⟩ := Finset.not_subset.mp hnot
    obtain ⟨d,hd,hdc⟩ := Finset.exists_mem_ne (s := L 6) (by rw [hsize]; decide) c
    obtain ⟨e,he,hed⟩ := Finset.exists_mem_ne (s := L 7) (by rw [hsize]; decide) d
    obtain ⟨t,ht,htd,hte⟩ := exists_mem_avoiding_pair (L 8)
      (by rw [hsize]; decide) d e
    apply Or.inr
    refine ⟨?_,fun _ => t,fun _ => ht,?_⟩
    · simpa [K,cycleVertex] using (hall 2).symm
    · intro a ha b hb
      have haK : a ∈ K 0 := ha
      have hbK : b ∈ K 0 := (hall 2) ▸ (show b ∈ K 2 from hb)
      obtain ⟨f,hf,hfa,hfb⟩ := C5.extend_uniform_three (K 0) (hK 0) a b haK hbK
      have hfK : IsListColoring C5.graph (L ∘ cycleVertex) f := by
        refine ⟨?_,hf.2⟩
        intro x
        simpa only [← hall x] using hf.1 x
      have hfc (x : Fin 5) : f x ≠ c := fun h => hcn (h ▸ hf.1 x)
      refine ⟨combine f c d e t,
        combine_coloring L f c d e t hfK hfc hc hd he ht hdc.symm hed.symm htd.symm hte.symm,
        ?_,?_,?_⟩
      · simpa [combine] using hfa
      · simpa [combine] using hfb
      · intro i; rfl
  · have hnot : ¬ L 5 ⊆ L 6 := by
      intro h
      have hc := Finset.card_le_card h
      simp [hsize,halfSizes] at hc
    obtain ⟨c,hc,hcn⟩ := Finset.not_subset.mp hnot
    obtain ⟨f,hf⟩ := C5.colorable_erase_of_nonuniform_three K hK hall c
    have hfK : IsListColoring C5.graph (L ∘ cycleVertex) f :=
      ⟨fun x => (Finset.mem_erase.mp (hf.1 x)).2,hf.2⟩
    have hfc (x : Fin 5) : f x ≠ c := (Finset.mem_erase.mp (hf.1 x)).1
    apply Or.inl
    refine ⟨f 0,hfK.1 0,f 2,hfK.1 2,?_⟩
    intro cs hcs
    let t := cs 0
    have ht : t ∈ L 8 := hcs 0
    obtain ⟨e,he,het⟩ := Finset.exists_mem_ne (s := L 7) (by rw [hsize]; decide) t
    obtain ⟨d,hd,hde,hdt⟩ := exists_mem_avoiding_pair (L 6)
      (by rw [hsize]; decide) e t
    have hcd : c ≠ d := fun h => hcn (h.symm ▸ hd)
    refine ⟨combine f c d e t,
      combine_coloring L f c d e t hfK hfc hc hd he ht hcd hde hdt het,rfl,rfl,?_⟩
    intro i
    fin_cases i
    rfl

/-- Lemma 5's forced-color conclusion. The final vertex must use
at least one of the special colors 7 and 8. -/
theorem twofold_hits_special (φ : Fin 9 → Finset ℕ)
    (hφ : IsListMulticoloring graph lists 2 φ) :
    ¬ Disjoint (φ 8) ({7,8} : Finset ℕ) := by
  rcases hφ with ⟨hs,hc,he⟩
  intro havoid
  have h8sub : φ 8 ⊆ ({1,2,3,4} : Finset ℕ) := by
    intro c hcm
    have hm := hs 8 hcm
    have hn := Finset.disjoint_left.mp havoid hcm
    simp [lists] at hm
    simp only [Finset.mem_insert,Finset.mem_singleton] at hn ⊢
    omega
  have h7sub : φ 7 ⊆ ({1,2,3,4} : Finset ℕ) := by simpa [lists] using hs 7
  have hunion : φ 7 ∪ φ 8 = ({1,2,3,4} : Finset ℕ) := by
    apply Finset.eq_of_subset_of_card_le (Finset.union_subset h7sub h8sub)
    rw [Finset.card_union_of_disjoint (he 7 8 (by decide)),hc 7,hc 8]
    decide
  have h6sub : φ 6 ⊆ ({7,8} : Finset ℕ) := by
    intro c hcm
    have hm := hs 6 hcm
    have hn7 := Finset.disjoint_left.mp (he 6 7 (by decide)) hcm
    have hn8 := Finset.disjoint_left.mp (he 6 8 (by decide)) hcm
    have hn : c ∉ ({1,2,3,4} : Finset ℕ) := by
      rw [← hunion,Finset.mem_union]
      exact fun h => h.elim hn7 hn8
    simp [lists] at hm
    simp only [Finset.mem_insert,Finset.mem_singleton] at hn ⊢
    omega
  have h6 : φ 6 = ({7,8} : Finset ℕ) :=
    Finset.eq_of_subset_of_card_le h6sub (by simp [hc])
  have h5sub : φ 5 ⊆ ({1,2,3,4,5,6} : Finset ℕ) := by
    intro c hcm
    have hm := hs 5 hcm
    have hn := Finset.disjoint_left.mp (he 5 6 (by decide)) hcm
    rw [h6] at hn
    simp [lists] at hm
    simp only [Finset.mem_insert,Finset.mem_singleton] at hn ⊢
    omega
  let S : Finset ℕ := {1,2,3,4,5,6} \ φ 5
  have hSc : S.card ≤ 4 := by
    dsimp [S]
    rw [Finset.card_sdiff_of_subset h5sub,hc 5]
    decide
  apply C5.not_twofold_palette_four S hSc
  refine ⟨fun x => φ (cycleVertex x), ?_,fun x => hc _,?_⟩
  · intro x c hcm
    apply Finset.mem_sdiff.mpr
    constructor
    · have hm := hs (cycleVertex x) hcm
      fin_cases x <;> simpa [lists,cycleVertex] using hm
    · exact Finset.disjoint_left.mp (he _ _ (cycle_center_adj x)) hcm
  · intro x y hxy
    exact he _ _ (cycle_adj x y hxy)

theorem twofold_special_mem (φ : Fin 9 → Finset ℕ)
    (hφ : IsListMulticoloring graph lists 2 φ) : 7 ∈ φ 8 ∨ 8 ∈ φ 8 := by
  by_contra hn
  apply twofold_hits_special φ hφ
  apply Finset.disjoint_left.mpr
  intro c hc hspecial
  simp only [Finset.mem_insert,Finset.mem_singleton] at hspecial
  rcases hspecial with rfl | rfl
  · exact hn (Or.inl hc)
  · exact hn (Or.inr hc)

end JSP000513.G2
