import JSP000513.C5Positive
import JSP000513.FinsetTools

namespace JSP000513.G1

/-- Paper vertices v1,...,v5,x,y have indices 0,...,6. -/
def graph : SimpleGraph (Fin 7) where
  Adj x y := (x,y) ∈
    ({(0,1),(1,0),(1,2),(2,1),(2,3),(3,2),(3,4),(4,3),(4,0),(0,4),
      (0,5),(5,0),(5,6),(6,5),(6,2),(2,6)} : Finset (Fin 7 × Fin 7))
  symm := ⟨by decide⟩
  loopless := ⟨by decide⟩

instance : DecidableRel graph.Adj := fun _ _ => by unfold graph; infer_instance

def lists : Fin 7 → Finset ℕ :=
  ![{1,2,3,4,5,6}, {1,4,5,6}, {1,2,3,4,5,6}, {3,4,5,6},
    {2,4,5,6}, {1,2,3,4}, {1,2}]

def halfSizes : Fin 7 → ℕ := ![3,2,3,2,2,2,1]

theorem lists_card : ∀ x, (lists x).card = 2 * halfSizes x := by decide

def cycleVertex (x : Fin 5) : Fin 7 := x.castLE (by decide)

theorem cycle_adj : ∀ x y, C5.graph.Adj x y → graph.Adj (cycleVertex x) (cycleVertex y) := by
  decide

universe u

/-- Corollary 4, positive half, for arbitrary color types. -/
theorem half_list_colorable {Color : Type u} [DecidableEq Color]
    (L : Fin 7 → Finset Color) (hsize : ∀ x, (L x).card = halfSizes x)
    (heq : L 0 = L 2) : ListColorable graph L := by
  classical
  obtain ⟨cy, hcy⟩ := Finset.card_pos.mp (show 0 < (L 6).card by rw [hsize]; decide)
  obtain ⟨cx, hcx, hcxy⟩ := Finset.exists_mem_ne
    (s := L 5) (by rw [hsize]; decide) cy
  obtain ⟨A,B,hA,hB,hAc,hBc,hcxA,hcyB,hAB⟩ :=
    exists_distinct_pairs_avoiding (L 0) (by simpa [halfSizes] using hsize 0) cx cy hcxy
  let K : Fin 5 → Finset Color := ![A,L 1,B,L 3,L 4]
  have hKsize : ∀ x, (K x).card = 2 := by
    intro x
    fin_cases x <;> simp [K, hAc, hBc, hsize, halfSizes]
  obtain ⟨f, hf, hedge⟩ := C5.half_list_colorable K hKsize
    (by simpa [K] using pair_inter_card_le_one hAc hBc hAB)
  have hf0 : f 0 ∈ A := by simpa [K] using hf 0
  have hf1 : f 1 ∈ L 1 := by simpa [K] using hf 1
  have hf2 : f 2 ∈ B := by simpa [K] using hf 2
  have hf3 : f 3 ∈ L 3 := by simpa [K] using hf 3
  have hf4 : f 4 ∈ L 4 := by simpa [K] using hf 4
  have hf0L := hA hf0
  have hf2L : f 2 ∈ L 2 := heq ▸ hB hf2
  have h01 := hedge 0 1 (by decide)
  have h12 := hedge 1 2 (by decide)
  have h23 := hedge 2 3 (by decide)
  have h34 := hedge 3 4 (by decide)
  have h40 := hedge 4 0 (by decide)
  have h0x : f 0 ≠ cx := fun h => hcxA (h ▸ hf0)
  have h2y : f 2 ≠ cy := fun h => hcyB (h ▸ hf2)
  refine ⟨![f 0,f 1,f 2,f 3,f 4,cx,cy], ?_, ?_⟩
  · intro x
    fin_cases x <;> simp_all
  · intro x y hxy
    fin_cases x <;> fin_cases y <;> simp [graph] at hxy <;> simp_all [ne_comm]

/-- Corollary 4, negative half: its fixed lists force the C5 obstruction. -/
theorem not_listMulticolorable : ¬ ListMulticolorable graph lists 2 := by
  rintro ⟨φ, hs, hc, he⟩
  have hy : φ 6 = {1,2} := Finset.eq_of_subset_of_card_le
    (by simpa [lists] using hs 6) (by simp [hc])
  have hxsub : φ 5 ⊆ ({3,4} : Finset ℕ) := by
    intro c hcm
    have hm := hs 5 hcm
    have hn := (Finset.disjoint_left.mp (he 5 6 (by decide))) hcm
    rw [hy] at hn
    simp [lists] at hm
    simp only [Finset.mem_insert, Finset.mem_singleton]
    simp only [Finset.mem_insert, Finset.mem_singleton] at hn
    omega
  have hx : φ 5 = {3,4} := Finset.eq_of_subset_of_card_le hxsub (by simp [hc])
  apply C5.not_listMulticolorable
  refine ⟨fun x => φ (cycleVertex x), ?_, fun x => hc _, ?_⟩
  · intro x c hcm
    have hm := hs (cycleVertex x) hcm
    fin_cases x
    · have hn := (Finset.disjoint_left.mp (he 0 5 (by decide))) hcm
      rw [hx] at hn
      simp [cycleVertex, lists, C5.lists] at hm ⊢
      simp only [Finset.mem_insert, Finset.mem_singleton] at hn
      omega
    · simpa [cycleVertex, lists, C5.lists] using hm
    · have hn := (Finset.disjoint_left.mp (he 2 6 (by decide))) hcm
      rw [hy] at hn
      simp [cycleVertex, lists, C5.lists] at hm ⊢
      simp only [Finset.mem_insert, Finset.mem_singleton] at hn
      omega
    · simpa [cycleVertex, lists, C5.lists] using hm
    · simpa [cycleVertex, lists, C5.lists] using hm
  · intro x y hxy
    exact he _ _ (cycle_adj x y hxy)

end JSP000513.G1

