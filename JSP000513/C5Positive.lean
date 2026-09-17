import JSP000513.C5Obstruction
import JSP000513.ListColoring
import Mathlib.Tactic.FinCases
import Lean.Elab.Tactic.Omega

namespace JSP000513.C5

universe u
variable {Color : Type u}

theorem coloring_of_five (L : Fin 5 → Finset Color)
    (a b c d e : Color)
    (ha : a ∈ L 0) (hb : b ∈ L 1) (hc : c ∈ L 2)
    (hd : d ∈ L 3) (he : e ∈ L 4)
    (hab : a ≠ b) (hbc : b ≠ c) (hcd : c ≠ d)
    (hde : d ≠ e) (hea : e ≠ a) : ListColorable graph L := by
  refine ⟨![a,b,c,d,e], ?_, ?_⟩
  · intro x
    fin_cases x <;> simp_all
  · intro x y hxy
    fin_cases x <;> fin_cases y <;>
      simp [graph] at hxy <;> simp_all [ne_comm]

/-- Greedy coloring around the cycle, starting with a color unavailable
at the final neighbor. This works for arbitrary palettes and lists. -/
theorem colorable_of_escape (L : Fin 5 → Finset Color)
    (hsize : ∀ x, 2 ≤ (L x).card)
    (a : Color) (ha : a ∈ L 0) (hna : a ∉ L 1) : ListColorable graph L := by
  classical
  obtain ⟨e, he, hea⟩ := Finset.exists_mem_ne (s := L 4) (by have := hsize 4; omega) a
  obtain ⟨d, hd, hde⟩ := Finset.exists_mem_ne (s := L 3) (by have := hsize 3; omega) e
  obtain ⟨c, hc, hcd⟩ := Finset.exists_mem_ne (s := L 2) (by have := hsize 2; omega) d
  obtain ⟨b, hb, hbc⟩ := Finset.exists_mem_ne (s := L 1) (by have := hsize 1; omega) c
  exact coloring_of_five L a b c d e ha hb hc hd he
    (fun h => hna (h.symm ▸ hb)) hbc hcd hde hea

/-- The reflection fixes vertex 1 and exchanges vertices 0 and 2. -/
def reflect : Fin 5 → Fin 5 := ![2,1,0,4,3]

theorem reflect_involutive : Function.Involutive reflect := by
  intro x; fin_cases x <;> rfl
theorem reflect_adj : ∀ x y, graph.Adj (reflect x) (reflect y) ↔ graph.Adj x y := by
  decide

theorem colorable_reflect (L : Fin 5 → Finset Color)
    (h : ListColorable graph (L ∘ reflect)) : ListColorable graph L := by
  obtain ⟨f, hm, he⟩ := h
  refine ⟨f ∘ reflect, ?_, ?_⟩
  · intro x
    simpa [Function.comp_def, reflect_involutive x] using hm (reflect x)
  · intro x y hxy
    exact he _ _ ((reflect_adj x y).2 hxy)

/-- DHS19 Lemma 3, positive half. The lists are arbitrary two-element
sets, not sublists of the special obstruction lists. -/
theorem half_list_colorable [DecidableEq Color] (L : Fin 5 → Finset Color)
    (hsize : ∀ x, (L x).card = 2)
    (hinter : ((L 0) ∩ (L 2)).card ≤ 1) : ListColorable graph L := by
  classical
  have hnot : ¬ (L 0 ⊆ L 1 ∧ L 2 ⊆ L 1) := by
    rintro ⟨h01, h21⟩
    have hu : (L 0 ∪ L 2).card ≤ 2 := by
      calc
        _ ≤ (L 1).card := Finset.card_le_card (Finset.union_subset h01 h21)
        _ = 2 := hsize 1
    have hi := Finset.card_inter_add_card_union (L 0) (L 2)
    rw [hsize 0, hsize 2] at hi
    omega
  by_cases h01 : L 0 ⊆ L 1
  · have h21 : ¬ L 2 ⊆ L 1 := fun h => hnot ⟨h01,h⟩
    obtain ⟨a, ha, hna⟩ := Finset.not_subset.mp h21
    apply colorable_reflect L
    apply colorable_of_escape (L ∘ reflect)
    · intro x
      simp only [Function.comp_apply, hsize]
      omega
    · simpa [Function.comp_def, reflect] using ha
    · simpa [Function.comp_def, reflect] using hna
  · obtain ⟨a, ha, hna⟩ := Finset.not_subset.mp h01
    exact colorable_of_escape L (fun x => by rw [hsize x]) a ha hna

end JSP000513.C5


