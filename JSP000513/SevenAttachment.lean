import JSP000513.G2
import JSP000513.GraphAssembly
import JSP000513.ColorForcing

namespace JSP000513.Seven

/-- The seven z-vertices attached in each copy in DHS19 Lemma 6. -/
def graph : SimpleGraph (Fin 7) where
  Adj x y := (x,y) ∈
    ({(0,2),(2,0),(0,3),(3,0),(1,2),(2,1),(1,3),(3,1),(2,3),(3,2),
      (3,4),(4,3),(4,5),(5,4),(4,6),(6,4),(5,6),(6,5)} : Finset (Fin 7 × Fin 7))
  symm := ⟨by decide⟩
  loopless := ⟨by decide⟩
instance : DecidableRel graph.Adj := fun _ _ => by unfold graph; infer_instance

def halfSizes : Fin 7 → ℕ := ![2,2,3,4,3,2,3]
def lists (i : Fin 2) : Fin 7 → Finset ℕ :=
  ![{1,2,3,7+i.val},{4,5,6,7+i.val},{1,2,3,4,5,6},{1,2,3,4,5,6,7,8},
    {1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8}]

theorem lists_card : ∀ i x, (lists i x).card = 2 * halfSizes x := by decide

universe u
variable {Color : Type u}

theorem vector_coloring (L : Fin 7 → Finset Color) (a b c d e f t : Color)
    (ha : a ∈ L 0) (hb : b ∈ L 1) (hc : c ∈ L 2) (hd : d ∈ L 3)
    (he : e ∈ L 4) (hf : f ∈ L 5) (ht : t ∈ L 6)
    (hac : a ≠ c) (had : a ≠ d) (hbc : b ≠ c) (hbd : b ≠ d)
    (hcd : c ≠ d) (hde : d ≠ e) (hef : e ≠ f) (het : e ≠ t) (hft : f ≠ t) :
    IsListColoring graph L ![a,b,c,d,e,f,t] := by
  constructor
  · intro x
    fin_cases x <;> simp_all
  · intro x y hxy
    fin_cases x <;> fin_cases y <;> simp [graph] at hxy <;> simp_all [ne_comm]

/-- Select one forbidden root color. Avoiding it allows arbitrary
terminal precoloring, the crucial first branch of Lemma 6. -/
theorem flexible_extension [DecidableEq Color] (L : Fin 7 → Finset Color)
    (hs : ∀ x, (L x).card = halfSizes x) :
    ∃ q : Color, ∀ r : Color, r ≠ q → ∀ t ∈ L 6,
      ∃ f : Fin 7 → Color, IsListColoring graph L f ∧
        f 0 ≠ r ∧ f 1 ≠ r ∧ f 6 = t := by
  obtain ⟨q,hq⟩ := diamond_signal (L 0) (L 1) (L 2)
    (by simpa [halfSizes] using hs 0) (by simpa [halfSizes] using hs 1)
    (by simpa [halfSizes] using hs 2)
  refine ⟨q,?_⟩
  intro r hr t ht
  obtain ⟨a,ha,b,hb,har,hbr,hgood⟩ := hq r hr
  let D := L 3 \ {a,b}
  have hD : 2 ≤ D.card := by
    have h := Finset.le_card_sdiff ({a,b} : Finset Color) (L 3)
    have hp := Finset.card_pair_eq_one_or_two (a := a) (b := b)
    have hs3 : (L 3).card = 4 := by simpa [halfSizes] using hs 3
    dsimp [D]
    omega
  obtain ⟨d,hdD,hdel⟩ := exists_erase_ne D (L 4) (L 5) hD
    (by simpa [halfSizes] using hs 4) (by simpa [halfSizes] using hs 5)
  have hd := (Finset.mem_sdiff.mp hdD).1
  have hdan := (Finset.mem_sdiff.mp hdD).2
  have hda : d ≠ a := fun h => hdan (by simp [h])
  have hdb : d ≠ b := fun h => hdan (by simp [h])
  obtain ⟨c,hc,hca,hcb,hcd⟩ := diamond_middle (L 2)
    (by simpa [halfSizes] using hs 2) a b d hgood
  have hleft : 2 ≤ ((L 4).erase d).card := by
    have h := Finset.pred_card_le_card_erase (s := L 4) (a := d)
    have hs4 : (L 4).card = 3 := by simpa [halfSizes] using hs 4
    omega
  obtain ⟨e,he',f,hf,hef,het,hft⟩ := triangle_pair_extension ((L 4).erase d) (L 5)
    hleft (by simpa [halfSizes] using hs 5) hdel t
  have he := (Finset.mem_erase.mp he').2
  have hed := (Finset.mem_erase.mp he').1
  exact ⟨![a,b,c,d,e,f,t],
    vector_coloring L a b c d e f t ha hb hc hd he hf ht
      hca.symm hda.symm hcb.symm hdb.symm hcd hed.symm hef het hft,
    har,hbr,rfl⟩

/-- With a fixed root color, ordinary greedy coloring supplies a
terminal color. This is the second branch of Lemma 6. -/
theorem greedy_extension [DecidableEq Color] (L : Fin 7 → Finset Color)
    (hs : ∀ x, (L x).card = halfSizes x) (r : Color) :
    ∃ f : Fin 7 → Color, IsListColoring graph L f ∧ f 0 ≠ r ∧ f 1 ≠ r := by
  obtain ⟨a,ha,har⟩ := Finset.exists_mem_ne (s := L 0) (by rw [hs]; decide) r
  obtain ⟨b,hb,hbr⟩ := Finset.exists_mem_ne (s := L 1) (by rw [hs]; decide) r
  obtain ⟨c,hc,hca,hcb⟩ := exists_mem_avoiding_pair (L 2) (by rw [hs]; decide) a b
  have hD : ({a,b,c} : Finset Color).card < (L 3).card := by
    have hbound : ({a,b,c} : Finset Color).card ≤ 3 := by
      have h := Finset.card_insert_le a ({b,c} : Finset Color)
      have hbc := Finset.card_pair_eq_one_or_two (a := b) (b := c)
      omega
    rw [hs]
    change _ < 4
    omega
  obtain ⟨d,hd,hdn⟩ := exists_mem_of_card_lt (L 3) {a,b,c} hD
  have hda : d ≠ a := fun h => hdn (by simp [h])
  have hdb : d ≠ b := fun h => hdn (by simp [h])
  have hdc : d ≠ c := fun h => hdn (by simp [h])
  obtain ⟨e,he,hed⟩ := Finset.exists_mem_ne (s := L 4) (by rw [hs]; decide) d
  obtain ⟨f,hf,hfe⟩ := Finset.exists_mem_ne (s := L 5) (by rw [hs]; decide) e
  obtain ⟨t,ht,hte,htf⟩ := exists_mem_avoiding_pair (L 6) (by rw [hs]; decide) e f
  exact ⟨![a,b,c,d,e,f,t],
    vector_coloring L a b c d e f t ha hb hc hd he hf ht
      hca.symm hda.symm hcb.symm hdb.symm hdc.symm hed.symm hfe.symm hte.symm htf.symm,
    har,hbr⟩

/-- The designated forbidden root color forces the terminal pair. -/
theorem twofold_terminal_forced (i : Fin 2) (φ : Fin 7 → Finset ℕ)
    (hφ : IsListMulticoloring graph (lists i) 2 φ)
    (h0 : 7+i.val ∉ φ 0) (h1 : 7+i.val ∉ φ 1) : φ 6 = {7,8} := by
  rcases hφ with ⟨hs,hc,he⟩
  have h0sub : φ 0 ⊆ ({1,2,3} : Finset ℕ) := by
    intro c hcm
    have hm := hs 0 hcm
    have hn : c ≠ 7+i.val := fun h => h0 (h ▸ hcm)
    simp [lists] at hm
    simp only [Finset.mem_insert,Finset.mem_singleton]
    omega
  have h1sub : φ 1 ⊆ ({4,5,6} : Finset ℕ) := by
    intro c hcm
    have hm := hs 1 hcm
    have hn : c ≠ 7+i.val := fun h => h1 (h ▸ hcm)
    simp [lists] at hm
    simp only [Finset.mem_insert,Finset.mem_singleton]
    omega
  have h01 : Disjoint (φ 0) (φ 1) := by
    exact (show Disjoint ({1,2,3} : Finset ℕ) {4,5,6} by decide).mono h0sub h1sub
  have h2sub : φ 2 ⊆ ({1,2,3,4,5,6} : Finset ℕ) := by simpa [lists] using hs 2
  have hallsub : (φ 0 ∪ φ 1) ∪ φ 2 ⊆ ({1,2,3,4,5,6} : Finset ℕ) := by
    apply Finset.union_subset
    · apply Finset.union_subset
      · exact h0sub.trans (by decide)
      · exact h1sub.trans (by decide)
    · exact h2sub
  have hd : Disjoint (φ 0 ∪ φ 1) (φ 2) :=
    Finset.disjoint_union_left.mpr ⟨he 0 2 (by decide),he 1 2 (by decide)⟩
  have hu : (φ 0 ∪ φ 1) ∪ φ 2 = ({1,2,3,4,5,6} : Finset ℕ) := by
    apply Finset.eq_of_subset_of_card_le hallsub
    rw [Finset.card_union_of_disjoint hd,Finset.card_union_of_disjoint h01,hc 0,hc 1,hc 2]
    decide
  have h3sub : φ 3 ⊆ ({7,8} : Finset ℕ) := by
    intro c hcm
    have hm := hs 3 hcm
    have hn0 := Finset.disjoint_left.mp (he 3 0 (by decide)) hcm
    have hn1 := Finset.disjoint_left.mp (he 3 1 (by decide)) hcm
    have hn2 := Finset.disjoint_left.mp (he 3 2 (by decide)) hcm
    have hn : c ∉ ({1,2,3,4,5,6} : Finset ℕ) := by
      rw [← hu,Finset.mem_union,Finset.mem_union]
      exact fun h => h.elim (fun h' => h'.elim hn0 hn1) hn2
    simp [lists] at hm
    simp only [Finset.mem_insert,Finset.mem_singleton] at hn ⊢
    omega
  have h3 : φ 3 = ({7,8} : Finset ℕ) :=
    Finset.eq_of_subset_of_card_le h3sub (by simp [hc])
  have h4sub : φ 4 ⊆ ({1,2,3,4} : Finset ℕ) := by
    intro c hcm
    have hm := hs 4 hcm
    have hn := Finset.disjoint_left.mp (he 4 3 (by decide)) hcm
    rw [h3] at hn
    simp [lists] at hm
    simp only [Finset.mem_insert,Finset.mem_singleton] at hn ⊢
    omega
  exact special_triangle_forcing (φ 4) (φ 5) (φ 6) (hc 4) (hc 5) (hc 6)
    h4sub (by simpa [lists] using hs 5) (by simpa [lists] using hs 6)
    (he 4 5 (by decide)) (he 6 4 (by decide)) (he 6 5 (by decide))

end JSP000513.Seven
