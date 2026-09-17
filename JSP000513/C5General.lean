import JSP000513.C5Positive
import JSP000513.FinsetTools

namespace JSP000513.C5

theorem adj_steps : ∀ x y, graph.Adj x y → y = x + 1 ∨ y = x - 1 := by decide
theorem adj_add : ∀ k x y, graph.Adj x y → graph.Adj (x+k) (y+k) := by decide
theorem adj_sub : ∀ k x y, graph.Adj x y → graph.Adj (x-k) (y-k) := by decide
theorem adj_flip : ∀ k x y, graph.Adj x y → graph.Adj (k-x) (k-y) := by decide
theorem sub_add_cancel_fin : ∀ k x : Fin 5, (x-k)+k=x := by decide
theorem sub_sub_cancel_fin : ∀ k x : Fin 5, k-(k-x)=x := by decide

theorem one_add_fin : ∀ x : Fin 5, 1+x=x+1 := by decide
theorem sub_zero_fin : ∀ x : Fin 5, x-0=x := by decide

universe u
variable {Color : Type u}

/-- An available color absent at an adjacent vertex breaks the cycle. -/
theorem colorable_of_edge_escape (L : Fin 5 → Finset Color)
    (hs : ∀ x, 2 ≤ (L x).card) (x y : Fin 5) (hxy : graph.Adj x y)
    (c : Color) (hc : c ∈ L x) (hn : c ∉ L y) : ListColorable graph L := by
  rcases adj_steps x y hxy with hy | hy
  · have hcol : ListColorable graph (L ∘ (fun i => i+x)) :=
      colorable_of_escape _ (fun i => hs _) c (by simpa using hc)
        (by simpa only [Function.comp_apply, hy, one_add_fin] using hn)
    have hp := hcol.comap (fun i => i-x) (adj_sub x)
    simpa only [Function.comp_def, sub_add_cancel_fin] using hp
  · have hcol : ListColorable graph (L ∘ (fun i => x-i)) :=
      colorable_of_escape _ (fun i => hs _) c (by simpa only [Function.comp_apply, sub_zero_fin] using hc)
        (by simpa [Function.comp_def, hy] using hn)
    have hp := hcol.comap (fun i => x-i) (adj_flip x)
    simpa only [Function.comp_def, sub_sub_cancel_fin] using hp

/-- If lists of size at least two fail to color C5, they are all the
same two-element set. This is used in the wheel gadget of Lemma 5. -/
theorem colorable_or_uniform_pair [DecidableEq Color] (L : Fin 5 → Finset Color)
    (hs : ∀ x, 2 ≤ (L x).card) :
    ListColorable graph L ∨ ∃ S : Finset Color, S.card = 2 ∧ ∀ x, L x = S := by
  classical
  by_cases hescape : ∃ x y, graph.Adj x y ∧ ¬ L x ⊆ L y
  · obtain ⟨x,y,hxy,hnot⟩ := hescape
    obtain ⟨c,hc,hn⟩ := Finset.not_subset.mp hnot
    exact Or.inl (colorable_of_edge_escape L hs x y hxy c hc hn)
  · have hedge (x y : Fin 5) (hxy : graph.Adj x y) : L x = L y := by
      apply Finset.Subset.antisymm
      · by_contra h
        exact hescape ⟨x,y,hxy,h⟩
      · by_contra h
        exact hescape ⟨y,x,graph.adj_symm hxy,h⟩
    have h01 := hedge 0 1 (by decide)
    have h12 := hedge 1 2 (by decide)
    have h23 := hedge 2 3 (by decide)
    have h34 := hedge 3 4 (by decide)
    have hall (x : Fin 5) : L x = L 0 := by
      fin_cases x <;> simp_all
    by_cases hcard : (L 0).card = 2
    · exact Or.inr ⟨L 0,hcard,hall⟩
    · have hthree : 3 ≤ (L 0).card := by have := hs 0; omega
      obtain ⟨a,ha⟩ := Finset.card_pos.mp (by omega : 0 < (L 0).card)
      obtain ⟨b,hb,hba⟩ := Finset.exists_mem_ne (s := L 0) (by omega) a
      have hnot : ¬ L 0 ⊆ ({a,b} : Finset Color) := by
        intro h
        have hc := Finset.card_le_card h
        have hp : ({a,b} : Finset Color).card = 2 := Finset.card_pair hba.symm
        omega
      obtain ⟨c,hc,hn⟩ := Finset.not_subset.mp hnot
      have hca : c ≠ a := fun h => hn (by simp [h])
      have hcb : c ≠ b := fun h => hn (by simp [h])
      apply Or.inl
      apply coloring_of_five L a b a b c ha
        (hall 1 ▸ hb) (hall 2 ▸ ha) (hall 3 ▸ hb) (hall 4 ▸ hc)
        hba.symm hba hba.symm hcb.symm hca

/-- Removing the same color from nonuniform three-element lists leaves
a colorable cycle. No fixed palette is assumed. -/
theorem colorable_erase_of_nonuniform_three [DecidableEq Color]
    (L : Fin 5 → Finset Color) (hs : ∀ x, (L x).card = 3)
    (hn : ¬ ∀ x, L x = L 0) (c : Color) :
    ListColorable graph (fun x => (L x).erase c) := by
  have hk (x : Fin 5) : 2 ≤ ((L x).erase c).card := by
    have := Finset.pred_card_le_card_erase (s := L x) (a := c)
    rw [hs x] at this
    omega
  rcases colorable_or_uniform_pair (fun x => (L x).erase c) hk with h | ⟨S,hS,hall⟩
  · exact h
  · have hm (x : Fin 5) : c ∈ L x := by
      by_contra hcx
      have hh := hall x
      rw [Finset.erase_eq_of_notMem hcx] at hh
      have := congrArg Finset.card hh
      rw [hs x,hS] at this
      omega
    have heq (x : Fin 5) : L x = insert c S := by
      rw [← hall x, Finset.insert_erase (hm x)]
    exact False.elim (hn (fun x => (heq x).trans (heq 0).symm))

/-- Precolor the two distinguished nonadjacent vertices of a cycle
with common three-element lists, and extend. -/
theorem extend_uniform_three [DecidableEq Color] (S : Finset Color) (hS : S.card = 3)
    (a b : Color) (ha : a ∈ S) (hb : b ∈ S) :
    ∃ f : Fin 5 → Color, IsListColoring graph (fun _ => S) f ∧ f 0 = a ∧ f 2 = b := by
  obtain ⟨c,hc,hca,hcb⟩ := exists_mem_avoiding_pair S (by omega) a b
  obtain ⟨d,hd,hdb⟩ := Finset.exists_mem_ne (s := S) (by omega) b
  obtain ⟨e,he,hed,hea⟩ := exists_mem_avoiding_pair S (by omega) d a
  refine ⟨![a,c,b,d,e], ⟨?_,?_⟩,rfl,rfl⟩
  · intro x
    fin_cases x <;> simp_all
  · intro x y hxy
    fin_cases x <;> fin_cases y <;> simp [graph] at hxy <;> simp_all [ne_comm]

/-- Two disjoint pairs exhaust a palette of size at most four. -/
theorem equal_pairs_of_common_neighbor [DecidableEq Color]
    (S A B C : Finset Color) (hS : S.card ≤ 4)
    (hA : A.card = 2) (hB : B.card = 2) (hC : C.card = 2)
    (hAS : A ⊆ S) (hBS : B ⊆ S) (hCS : C ⊆ S)
    (hAB : Disjoint A B) (hBC : Disjoint B C) : A = C := by
  have hu : B ∪ C = S := by
    apply Finset.eq_of_subset_of_card_le (Finset.union_subset hBS hCS)
    rw [Finset.card_union_of_disjoint hBC,hB,hC]
    exact hS
  apply Finset.eq_of_subset_of_card_le
  · intro c hc
    have hm := hAS hc
    rw [← hu, Finset.mem_union] at hm
    rcases hm with hb | hc'
    · exact False.elim (Finset.disjoint_left.mp hAB hc hb)
    · exact hc'
  · omega

/-- An odd cycle cannot assign two colors per vertex from four colors.
This avoids invoking fractional chromatic numbers in Lemma 5. -/
theorem not_twofold_palette_four [DecidableEq Color]
    (S : Finset Color) (hS : S.card ≤ 4) :
    ¬ ListMulticolorable graph (fun _ => S) 2 := by
  rintro ⟨φ,hs,hc,he⟩
  have heq (a b c : Fin 5) (hab : graph.Adj a b) (hbc : graph.Adj b c) : φ a = φ c :=
    equal_pairs_of_common_neighbor S _ _ _ hS (hc a) (hc b) (hc c)
      (hs a) (hs b) (hs c) (he a b hab) (he b c hbc)
  have h02 := heq 0 1 2 (by decide) (by decide)
  have h24 := heq 2 3 4 (by decide) (by decide)
  have hd := he 4 0 (by decide)
  rw [← h24, ← h02] at hd
  have hemp : φ 0 = ∅ := by simpa using hd
  have hcard := hc 0
  rw [hemp] at hcard
  simp at hcard

end JSP000513.C5



