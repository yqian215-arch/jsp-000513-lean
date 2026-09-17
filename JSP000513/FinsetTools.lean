import Mathlib.Data.Finset.Card
import Mathlib.Data.Finset.Lattice.Basic
import Lean.Elab.Tactic.Omega

namespace JSP000513
universe u
variable {α : Type u} [DecidableEq α]

theorem exists_mem_avoiding_pair (S : Finset α) (hS : 3 ≤ S.card) (a b : α) :
    ∃ c ∈ S, c ≠ a ∧ c ≠ b := by
  have hnot : ¬ S ⊆ ({a,b} : Finset α) := by
    intro h
    have hc := Finset.card_le_card h
    have hp := Finset.card_pair_eq_one_or_two (a := a) (b := b)
    omega
  obtain ⟨c,hc,hn⟩ := Finset.not_subset.mp hnot
  exact ⟨c,hc,fun h => hn (by simp [h]),fun h => hn (by simp [h])⟩

omit [DecidableEq α] in
theorem exists_mem_of_card_lt (S T : Finset α) (h : T.card < S.card) :
    ∃ c ∈ S, c ∉ T := by
  apply Finset.not_subset.mp
  intro hsub
  exact (not_le_of_gt h) (Finset.card_le_card hsub)

/-- Among at least two candidate colors, one avoids the unique possible
deletion making a three-element list equal to a fixed two-element list. -/
theorem exists_erase_ne (C S T : Finset α) (hC : 2 ≤ C.card)
    (hS : S.card = 3) (hT : T.card = 2) :
    ∃ c ∈ C, S.erase c ≠ T := by
  obtain ⟨a,ha⟩ := Finset.card_pos.mp (by omega : 0 < C.card)
  by_cases hea : S.erase a = T
  · have haS : a ∈ S := by
      by_contra hn
      rw [Finset.erase_eq_of_notMem hn] at hea
      have := congrArg Finset.card hea
      omega
    obtain ⟨b,hb,hba⟩ := Finset.exists_mem_ne (s := C) (by omega) a
    refine ⟨b,hb,?_⟩
    intro heb
    exact hba ((Finset.erase_inj S haS).mp (hea.trans heb.symm)).symm
  · exact ⟨a,ha,hea⟩

/-- Color the two remaining vertices of a triangle after its third
vertex is fixed, when their lists cannot both be the same pair. -/
theorem triangle_pair_extension (A B : Finset α)
    (hA : 2 ≤ A.card) (hB : B.card = 2) (hne : A ≠ B) (t : α) :
    ∃ a ∈ A, ∃ b ∈ B, a ≠ b ∧ a ≠ t ∧ b ≠ t := by
  obtain ⟨b,hb,hbt⟩ := Finset.exists_mem_ne (s := B) (by omega) t
  by_cases hsub : A ⊆ ({b,t} : Finset α)
  · have heq : A = ({b,t} : Finset α) :=
      Finset.eq_of_subset_of_card_le hsub (by rw [Finset.card_pair hbt]; exact hA)
    have hnB : ¬ B ⊆ ({b,t} : Finset α) := by
      intro hBsub
      have heqB : B = ({b,t} : Finset α) :=
        Finset.eq_of_subset_of_card_le hBsub (by rw [Finset.card_pair hbt,hB])
      exact hne (heq.trans heqB.symm)
    obtain ⟨c,hc,hcn⟩ := Finset.not_subset.mp hnB
    have hcb : c ≠ b := fun h => hcn (by simp [h])
    have hct : c ≠ t := fun h => hcn (by simp [h])
    exact ⟨b,by simp [heq],c,hc,hcb.symm,hbt,hct⟩
  · obtain ⟨a,ha,han⟩ := Finset.not_subset.mp hsub
    exact ⟨a,ha,b,hb,fun h => han (by simp [h]),fun h => han (by simp [h]),hbt⟩

/-- The signal color used in the diamond of DHS19 Lemma 6. -/
theorem diamond_signal (A B C : Finset α)
    (hA : A.card = 2) (hB : B.card = 2) (hC : C.card = 3) :
    ∃ q : α, ∀ r : α, r ≠ q →
      ∃ a ∈ A, ∃ b ∈ B, a ≠ r ∧ b ≠ r ∧ (a = b ∨ a ∉ C ∨ b ∉ C) := by
  by_cases hAB : Disjoint A B
  · have hu : C.card < (A ∪ B).card := by
      rw [Finset.card_union_of_disjoint hAB,hA,hB,hC]
      decide
    obtain ⟨q,hq,hqC⟩ := exists_mem_of_card_lt (A ∪ B) C hu
    refine ⟨q,?_⟩
    intro r hr
    rcases Finset.mem_union.mp hq with hqA | hqB
    · obtain ⟨b,hb,hbr⟩ := Finset.exists_mem_ne (s := B) (by omega) r
      exact ⟨q,hqA,b,hb,hr.symm,hbr,Or.inr (Or.inl hqC)⟩
    · obtain ⟨a,ha,har⟩ := Finset.exists_mem_ne (s := A) (by omega) r
      exact ⟨a,ha,q,hqB,har,hr.symm,Or.inr (Or.inr hqC)⟩
  · obtain ⟨q,hqA,hqB⟩ := Finset.not_disjoint_iff.mp hAB
    exact ⟨q,fun r hr => ⟨q,hqA,q,hqB,hr.symm,hr.symm,Or.inl rfl⟩⟩

theorem diamond_middle (C : Finset α) (hC : C.card = 3)
    (a b d : α) (hgood : a = b ∨ a ∉ C ∨ b ∉ C) :
    ∃ c ∈ C, c ≠ a ∧ c ≠ b ∧ c ≠ d := by
  rcases hgood with hab | ha | hb
  · obtain ⟨c,hc,hca,hcd⟩ := exists_mem_avoiding_pair C (by omega) a d
    exact ⟨c,hc,hca,hab ▸ hca,hcd⟩
  · obtain ⟨c,hc,hcb,hcd⟩ := exists_mem_avoiding_pair C (by omega) b d
    exact ⟨c,hc,fun h => ha (h ▸ hc),hcb,hcd⟩
  · obtain ⟨c,hc,hca,hcd⟩ := exists_mem_avoiding_pair C (by omega) a d
    exact ⟨c,hc,hca,fun h => hb (h ▸ hc),hcd⟩

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

