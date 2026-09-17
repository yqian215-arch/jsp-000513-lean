import JSP000513.FinsetTools
import Mathlib.Data.Finset.Disjoint

namespace JSP000513

/-- Three pairs on the triangle with the first two contained in the
four ordinary colors force the third to be the special pair. -/
theorem special_triangle_forcing (A B C : Finset ℕ)
    (hA : A.card = 2) (hB : B.card = 2) (hC : C.card = 2)
    (hAS : A ⊆ {1,2,3,4}) (hBS : B ⊆ {1,2,3,4})
    (hCS : C ⊆ {1,2,3,4,7,8})
    (hAB : Disjoint A B) (hCA : Disjoint C A) (hCB : Disjoint C B) :
    C = {7,8} := by
  have hu : A ∪ B = ({1,2,3,4} : Finset ℕ) := by
    apply Finset.eq_of_subset_of_card_le (Finset.union_subset hAS hBS)
    rw [Finset.card_union_of_disjoint hAB,hA,hB]
    decide
  have hsub : C ⊆ ({7,8} : Finset ℕ) := by
    intro c hc
    have hm := hCS hc
    have hnA := Finset.disjoint_left.mp hCA hc
    have hnB := Finset.disjoint_left.mp hCB hc
    have hn : c ∉ ({1,2,3,4} : Finset ℕ) := by
      rw [← hu,Finset.mem_union]
      exact fun h => h.elim hnA hnB
    simp only [Finset.mem_insert,Finset.mem_singleton] at hm hn ⊢
    omega
  exact Finset.eq_of_subset_of_card_le hsub (by simp [hC])

end JSP000513
