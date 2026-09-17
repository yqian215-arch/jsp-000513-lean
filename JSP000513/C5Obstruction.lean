import JSP000513.Definitions
import Mathlib.Data.Finset.Powerset
import Mathlib.Data.Fin.VecNotation
import Mathlib.Data.Fintype.Fin

/-!
# DHS19 Lemma 3: the negative half

Source: Dvořák–Hu–Sereni, arXiv:1806.03880v2, p. 3, Figure 1 (left).
Index `i : Fin 5` represents the paper's vertex `v_(i+1)`.
All finite decisions below are reduced and checked by the Lean kernel.
The positive half is proved in C5Positive.lean; the full finite-graph
counterexample is assembled in MainTheorem.lean.
-/

namespace JSP000513.C5

/-- Exactly the cycle edges 12, 23, 34, 45, 51, in both orientations. -/
def graph : SimpleGraph (Fin 5) where
  Adj x y := (x, y) ∈
    ({(0, 1), (1, 0), (1, 2), (2, 1), (2, 3), (3, 2),
      (3, 4), (4, 3), (4, 0), (0, 4)} : Finset (Fin 5 × Fin 5))
  symm := ⟨by decide⟩
  loopless := ⟨by decide⟩

instance : DecidableRel graph.Adj := fun _ _ => by
  unfold graph
  infer_instance

/-- The paper's actual color labels are retained as natural numbers. -/
def lists : Fin 5 → Finset ℕ :=
  ![{1, 2, 5, 6}, {1, 4, 5, 6}, {3, 4, 5, 6},
    {3, 4, 5, 6}, {2, 4, 5, 6}]

/-- Every specified list has exactly four colors. -/
theorem lists_card : ∀ x, (lists x).card = 4 := by decide

/-- All two-element subsets of one vertex's actual list. -/
def pairChoices (x : Fin 5) : Finset (Finset ℕ) :=
  (lists x).powersetCard 2

/-- Completeness and soundness of the finite candidate encoding. -/
theorem mem_pairChoices_iff (x : Fin 5) (s : Finset ℕ) :
    s ∈ pairChoices x ↔ s ⊆ lists x ∧ s.card = 2 :=
  Finset.mem_powersetCard

theorem pairChoices_card : ∀ x, (pairChoices x).card = 6 := by decide

set_option maxRecDepth 65536 in
set_option maxHeartbeats 8000000 in
/-- Kernel-checked finite obstruction. Five independent six-element
candidate sets cover all `6^5 = 7776` assignments. -/
theorem no_compatible_choices :
    ∀ s₁ ∈ pairChoices 0,
    ∀ s₂ ∈ pairChoices 1,
    ∀ s₃ ∈ pairChoices 2,
    ∀ s₄ ∈ pairChoices 3,
    ∀ s₅ ∈ pairChoices 4,
      ¬ (Disjoint s₁ s₂ ∧ Disjoint s₂ s₃ ∧ Disjoint s₃ s₄ ∧
        Disjoint s₄ s₅ ∧ Disjoint s₅ s₁) := by
  decide

/-- The semantic conclusion, for arbitrary natural-number finite sets:
the specified `SimpleGraph` has no `(lists : 2)`-coloring. -/
theorem not_listMulticolorable : ¬ ListMulticolorable graph lists 2 := by
  rintro ⟨φ, hsub, hcard, hedge⟩
  have hchoices (x : Fin 5) : φ x ∈ pairChoices x :=
    (mem_pairChoices_iff x (φ x)).2 ⟨hsub x, hcard x⟩
  exact no_compatible_choices
    (φ 0) (hchoices 0) (φ 1) (hchoices 1) (φ 2) (hchoices 2)
    (φ 3) (hchoices 3) (φ 4) (hchoices 4)
    ⟨hedge 0 1 (by decide), hedge 1 2 (by decide),
      hedge 2 3 (by decide), hedge 3 4 (by decide), hedge 4 0 (by decide)⟩

/-- Immediate choosability consequence on the natural-number palette.
This is `(4 : 2)`, not the final theorem's `(8 : 2)` obstruction. -/
theorem not_ABChoosable_four_two : ¬ ABChoosable graph 4 2 := by
  intro h
  exact not_listMulticolorable (h lists lists_card)

end JSP000513.C5
