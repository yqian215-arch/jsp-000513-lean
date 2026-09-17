import JSP000513.G5
import Mathlib.Data.Fintype.Powerset

namespace JSP000513.G5

theorem halfSizes_values (v : Vertex) : halfSizes v = 2 ∨ halfSizes v = 3 ∨ halfSizes v = 4 := by
  rcases v with ((((a | ⟨i,b⟩) | (c | ⟨j,d⟩)) | e))
  · fin_cases a <;> decide
  · fin_cases i <;> fin_cases b <;> decide
  · fin_cases c <;> decide
  · fin_cases j <;> fin_cases d <;> decide
  · fin_cases e <;> decide

theorem lists_palette (v : Vertex) : lists v ⊆ ({1,2,3,4,5,6,7,8} : Finset ℕ) := by
  rcases v with ((((a | ⟨i,b⟩) | (c | ⟨j,d⟩)) | e))
  · fin_cases a <;> decide
  · fin_cases i <;> fin_cases b <;> decide
  · fin_cases c <;> decide
  · fin_cases j <;> fin_cases d <;> decide
  · fin_cases e <;> decide
end JSP000513.G5

namespace JSP000513.Final

def palette : Finset ℕ := {9,10,11,12,13,14,15,16}
abbrev Pool := ↥(palette.powerset)
def Valid (ψ : Fin 4 → Pool) : Prop :=
  (∀ i, (ψ i).val.card = 2) ∧ ∀ i j, i ≠ j → Disjoint (ψ i).val (ψ j).val
abbrev Index := {ψ : Fin 4 → Pool // Valid ψ}
noncomputable instance : Fintype Index := by
  classical
  exact Fintype.ofFinite _
abbrev Vertex := Fin 4 ⊕ (Index × G5.Vertex)

def neighbors (v : G5.Vertex) : Finset (Fin 4) :=
  if G5.halfSizes v = 2 then {0,1} else if G5.halfSizes v = 3 then {0} else ∅

def cross (i : Fin 4) (p : Index × G5.Vertex) : Prop := i ∈ neighbors p.2
def graph : SimpleGraph Vertex := attach ⊤ (copies G5.graph) cross

def padding (ψ : Index) (v : G5.Vertex) : Finset ℕ :=
  if G5.halfSizes v = 2 then (ψ.val 0).val ∪ (ψ.val 1).val
  else if G5.halfSizes v = 3 then (ψ.val 0).val else ∅
def lists : Vertex → Finset ℕ :=
  Sum.elim (fun _ => palette) (fun p => G5.lists p.2 ∪ padding p.1 p.2)

theorem neighbors_card (v : G5.Vertex) : (neighbors v).card = 4 - G5.halfSizes v := by
  rcases G5.halfSizes_values v with h | h | h <;> simp [neighbors,h]

theorem padding_mem (ψ : Index) (v : G5.Vertex) (c : ℕ) :
    c ∈ padding ψ v ↔ ∃ i ∈ neighbors v, c ∈ (ψ.val i).val := by
  rcases G5.halfSizes_values v with h | h | h <;> simp [padding,neighbors,h]

theorem padding_card (ψ : Index) (v : G5.Vertex) :
    (padding ψ v).card = 2 * (4-G5.halfSizes v) := by
  rcases G5.halfSizes_values v with h | h | h
  · simp only [padding,h,ite_true]
    rw [Finset.card_union_of_disjoint (ψ.property.2 0 1 (by decide)),ψ.property.1,ψ.property.1]
  · simp [padding,h,ψ.property.1]
  · simp [padding,h]

theorem padding_subset (ψ : Index) (v : G5.Vertex) : padding ψ v ⊆ palette := by
  intro c hc
  obtain ⟨i,hi,hci⟩ := (padding_mem ψ v c).mp hc
  exact (Finset.mem_powerset.mp (ψ.val i).property) hci

theorem lists_card (v : Vertex) : (lists v).card = 8 := by
  cases v with
  | inl a => change palette.card = 8; decide
  | inr p =>
    have hd : Disjoint (G5.lists p.2) (padding p.1 p.2) :=
      Finset.disjoint_of_subset_left (G5.lists_palette p.2)
        (Finset.disjoint_of_subset_right (padding_subset p.1 p.2) (by decide))
    change (G5.lists p.2 ∪ padding p.1 p.2).card = 8
    rw [Finset.card_union_of_disjoint hd,G5.lists_card,padding_card]
    rcases G5.halfSizes_values p.2 with h | h | h <;> omega

/-- The copy indexed by the clique's coloring excludes all its padding colors. -/
theorem not_listMulticolorable : ¬ ListMulticolorable graph lists 2 := by
  rintro ⟨φ,hφ⟩
  let ψ : Index := ⟨fun i => ⟨φ (.inl i),Finset.mem_powerset.mpr (hφ.1 (.inl i))⟩,
    ⟨fun i => hφ.2.1 (.inl i),fun i j hij => hφ.2.2 (.inl i) (.inl j) hij⟩⟩
  have hcopy := hφ.comap (fun v => Sum.inr (ψ,v)) (fun _ _ h => ⟨rfl,h⟩)
  apply G5.not_listMulticolorable
  refine ⟨fun v => φ (.inr (ψ,v)),hcopy.mono_lists ?_⟩
  intro v c hc
  have hm := hφ.1 (.inr (ψ,v)) hc
  rcases Finset.mem_union.mp hm with h | h
  · exact h
  · obtain ⟨i,hi,hci⟩ := (padding_mem ψ v c).mp h
    exact False.elim (Finset.disjoint_left.mp (hφ.2.2 (.inr (ψ,v)) (.inl i) hi) hc hci)



universe u
variable {Color : Type u}

theorem clique_colorable [DecidableEq Color] (L : Fin 4 → Finset Color)
    (hs : ∀ i, (L i).card = 4) : ListColorable (⊤ : SimpleGraph (Fin 4)) L := by
  obtain ⟨a,ha⟩ := Finset.card_pos.mp (by rw [hs]; decide : 0 < (L 0).card)
  obtain ⟨b,hb,hba⟩ := Finset.exists_mem_ne (s := L 1) (by rw [hs]; decide) a
  obtain ⟨c,hc,hca,hcb⟩ := exists_mem_avoiding_pair (L 2) (by rw [hs]; decide) a b
  have hcsmall : ({a,b,c} : Finset Color).card ≤ 3 := by
    have h := Finset.card_insert_le a ({b,c} : Finset Color)
    have hpair := Finset.card_pair_eq_one_or_two (a := b) (b := c)
    omega
  obtain ⟨d,hd,hdn⟩ := exists_mem_of_card_lt (L 3) {a,b,c} (by rw [hs]; omega)
  have hda : d ≠ a := fun h => hdn (by simp [h])
  have hdb : d ≠ b := fun h => hdn (by simp [h])
  have hdc : d ≠ c := fun h => hdn (by simp [h])
  refine ⟨![a,b,c,d],?_,?_⟩
  · intro i; fin_cases i <;> assumption
  · intro i j hij
    have hn : i ≠ j := hij
    fin_cases i <;> fin_cases j <;> simp_all [ne_comm]

/-- DHS19 Theorem 2, positive half: arbitrary four-element lists and palettes. -/
theorem four_list_colorable [DecidableEq Color] (L : Vertex → Finset Color)
    (hs : ∀ v, (L v).card = 4) : ListColorable graph L := by
  classical
  obtain ⟨f,hf⟩ := clique_colorable (L ∘ Sum.inl) (fun i => hs (.inl i))
  let R (ψ : Index) (v : G5.Vertex) := L (.inr (ψ,v)) \ (neighbors v).image f
  have hR (ψ : Index) (v : G5.Vertex) : G5.halfSizes v ≤ (R ψ v).card := by
    have hsub := Finset.card_le_card_sdiff_add_card (s := L (.inr (ψ,v)))
      (t := (neighbors v).image f)
    have himg := Finset.card_image_le (s := neighbors v) (f := f)
    have hn := neighbors_card v
    have hv := G5.halfSizes_values v
    have hl := hs (.inr (ψ,v))
    dsimp [R]
    omega
  have hp (ψ : Index) (v : G5.Vertex) := Finset.exists_subset_card_eq (hR ψ v)
  choose M hMR hMc using hp
  have hcolor (ψ : Index) := G5.half_list_colorable (M ψ) (hMc ψ)
  choose g hg using hcolor
  have hgL (ψ : Index) : IsListColoring G5.graph (fun v => L (.inr (ψ,v))) (g ψ) :=
    ⟨fun v => (Finset.mem_sdiff.mp (hMR ψ v ((hg ψ).1 v))).1,(hg ψ).2⟩
  refine ⟨Sum.elim f (fun p => g p.1 p.2),hf.attach (IsListColoring.copies g hgL) ?_⟩
  intro i p hi heq
  have hn := (Finset.mem_sdiff.mp (hMR p.1 p.2 ((hg p.1).1 p.2))).2
  apply hn
  exact Finset.mem_image.mpr ⟨i,hi,heq⟩

theorem four_choosable_on (Color : Type u) : ABChoosableOn graph Color 4 1 := by
  classical
  intro L hs
  exact (four_list_colorable L hs).to_multicolorable

theorem not_eight_two_choosable : ¬ ABChoosable graph 8 2 := by
  intro h
  exact not_listMulticolorable (h lists lists_card)
end JSP000513.Final
