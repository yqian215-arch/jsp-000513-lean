import Mathlib.Data.Finset.Card
import Mathlib.Data.Finset.Lattice.Basic
import Lean.Elab.Tactic.Omega

namespace JSP000513
universe u
variable {α : Type u} [DecidableEq α]

theorem exists_pair_avoiding (S : Finset α) (hS : 3 ≤ S.card) (a : α) :
    ∃ T : Finset α, T ⊆ S ∧ T.card = 2 ∧ a ∉ T := by
  have hcard : 2 ≤ (S.erase a).card := by
    have := Finset.pred_card_le_card_erase (s := S) (a := a)
    omega
  obtain ⟨T, hT, hTc⟩ := Finset.exists_subset_card_eq hcard
  exact ⟨T, fun _ hx => (Finset.mem_erase.mp (hT hx)).2, hTc,
    fun hx => (Finset.mem_erase.mp (hT hx)).1 rfl⟩

theorem exists_pair_ne (S A : Finset α) (hS : 3 ≤ S.card) (hA : A.card = 2) :
    ∃ B : Finset α, B ⊆ S ∧ B.card = 2 ∧ B ≠ A := by
  have hnot : ¬ S ⊆ A := by
    intro h
    have := Finset.card_le_card h
    omega
  obtain ⟨c, hc, hcA⟩ := Finset.not_subset.mp hnot
  obtain ⟨d, hd, hdc⟩ := Finset.exists_mem_ne (s := S) (by omega) c
  refine ⟨{c,d}, by simp [Finset.insert_subset_iff, hc,hd], Finset.card_pair (Ne.symm hdc), ?_⟩
  intro h
  exact hcA (h ▸ (by simp : c ∈ ({c,d} : Finset α)))

/-- Choose different two-element sublists avoiding two distinct colors.
This is the list-selection step in DHS19 Corollary 4. -/
theorem exists_distinct_pairs_avoiding (S : Finset α) (hS : S.card = 3)
    (a b : α) (hab : a ≠ b) :
    ∃ A B : Finset α, A ⊆ S ∧ B ⊆ S ∧ A.card = 2 ∧ B.card = 2 ∧
      a ∉ A ∧ b ∉ B ∧ A ≠ B := by
  by_cases hb : b ∈ S
  · obtain ⟨A, hAS, hAc, haA⟩ := exists_pair_avoiding S (by omega) a
    obtain ⟨B, hBS, hBc, hbB⟩ := exists_pair_avoiding S (by omega) b
    by_cases hbA : b ∈ A
    · exact ⟨A,B,hAS,hBS,hAc,hBc,haA,hbB,fun h => hbB (h ▸ hbA)⟩
    · have hcard : 1 < (S.erase a).card := by
        have := Finset.pred_card_le_card_erase (s := S) (a := a)
        omega
      obtain ⟨d, hd, hdb⟩ := Finset.exists_mem_ne hcard b
      refine ⟨{b,d},B,?_,hBS,?_,hBc,?_,hbB,?_⟩
      · simp [Finset.insert_subset_iff, hb, (Finset.mem_erase.mp hd).2]
      · exact Finset.card_pair (Ne.symm hdb)
      · simp only [Finset.mem_insert, Finset.mem_singleton, not_or]; exact ⟨hab, Ne.symm (Finset.mem_erase.mp hd).1⟩
      · intro h
        exact hbB (h ▸ (by simp : b ∈ ({b,d} : Finset α)))
  · obtain ⟨A, hAS, hAc, haA⟩ := exists_pair_avoiding S (by omega) a
    obtain ⟨B, hBS, hBc, hBA⟩ := exists_pair_ne S A (by omega) hAc
    exact ⟨A,B,hAS,hBS,hAc,hBc,haA,fun h => hb (hBS h),Ne.symm hBA⟩

theorem pair_inter_card_le_one {A B : Finset α}
    (hA : A.card = 2) (hB : B.card = 2) (hne : A ≠ B) :
    (A ∩ B).card ≤ 1 := by
  by_contra h
  have hc : 2 ≤ (A ∩ B).card := by omega
  have heA : A ∩ B = A := Finset.eq_of_subset_of_card_le Finset.inter_subset_left (by omega)
  have heB : A ∩ B = B := Finset.eq_of_subset_of_card_le Finset.inter_subset_right (by omega)
  exact hne (heA.symm.trans heB)

end JSP000513

