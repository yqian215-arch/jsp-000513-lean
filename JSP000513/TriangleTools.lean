import JSP000513.FinsetTools

namespace JSP000513
universe u
variable {α : Type u} [DecidableEq α]

/-- Choose two boundary colors while preserving a nonexceptional residual list. -/
theorem two_roots_residual (R S A B : Finset α)
    (hR : R.card = 3) (hS : S.card = 3) (hA : A.card = 3) (hB : B.card = 2) :
    ∃ r ∈ R, ∃ s ∈ S, 2 ≤ ((A.erase r).erase s).card ∧
      (A.erase r).erase s ≠ B := by
  obtain ⟨r,hr,hrB⟩ := exists_erase_ne R A B (by omega) hA hB
  by_cases hrA : r ∈ A
  · have hc : (A.erase r).card = 2 := by rw [Finset.card_erase_of_mem hrA,hA]
    obtain ⟨s,hs,hsA⟩ := exists_mem_of_card_lt S (A.erase r) (by omega)
    exact ⟨r,hr,s,hs,by rw [Finset.erase_eq_of_notMem hsA,hc],by rwa [Finset.erase_eq_of_notMem hsA]⟩
  · obtain ⟨s,hs,hsB⟩ := exists_erase_ne S A B (by omega) hA hB
    refine ⟨r,hr,s,hs,?_,?_⟩
    · rw [Finset.erase_eq_of_notMem hrA]
      have := Finset.pred_card_le_card_erase (s := A) (a := s)
      omega
    · rwa [Finset.erase_eq_of_notMem hrA]

/-- At most one deletion turns a triple into a prescribed pair. -/
theorem bad_deletions_card (C A B : Finset α) (hA : A.card = 3) (hB : B.card = 2) :
    (C.filter (fun q => A.erase q = B)).card ≤ 1 := by
  apply Finset.card_le_one.mpr
  intro a ha b hb
  have hea := (Finset.mem_filter.mp ha).2
  have heb := (Finset.mem_filter.mp hb).2
  have haA : a ∈ A := by
    by_contra hn
    rw [Finset.erase_eq_of_notMem hn] at hea
    have := congrArg Finset.card hea
    omega
  exact (Finset.erase_inj A haA).mp (hea.trans heb.symm)

/-- A triple avoids the two exceptional deletion colors of two triangles. -/
theorem avoid_two_bad_deletions (C A₀ A₁ B₀ B₁ : Finset α)
    (hC : C.card = 3) (hA₀ : A₀.card = 3) (hA₁ : A₁.card = 3)
    (hB₀ : B₀.card = 2) (hB₁ : B₁.card = 2) :
    ∃ q ∈ C, A₀.erase q ≠ B₀ ∧ A₁.erase q ≠ B₁ := by
  let D₀ := C.filter (fun q => A₀.erase q = B₀)
  let D₁ := C.filter (fun q => A₁.erase q = B₁)
  have h₀ : D₀.card ≤ 1 := bad_deletions_card C A₀ B₀ hA₀ hB₀
  have h₁ : D₁.card ≤ 1 := bad_deletions_card C A₁ B₁ hA₁ hB₁
  have hu := Finset.card_union_le D₀ D₁
  obtain ⟨q,hq,hqn⟩ := exists_mem_of_card_lt C (D₀ ∪ D₁) (by omega)
  refine ⟨q,hq,?_,?_⟩
  · intro h
    exact hqn (Finset.mem_union_left _ (Finset.mem_filter.mpr ⟨hq,h⟩))
  · intro h
    exact hqn (Finset.mem_union_right _ (Finset.mem_filter.mpr ⟨hq,h⟩))
end JSP000513
