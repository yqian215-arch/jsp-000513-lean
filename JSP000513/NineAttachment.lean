import JSP000513.TriangleTools
import JSP000513.G3

namespace JSP000513.Triangle

def graph : SimpleGraph (Fin 3) := ⊤
def halfSizes : Fin 3 → ℕ := ![3,2,3]
def lists : Fin 3 → Finset ℕ := ![{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8}]

theorem lists_card (v : Fin 3) : (lists v).card = 2 * halfSizes v := by
  fin_cases v <;> decide

universe u
variable {Color : Type u} [DecidableEq Color]

theorem vector_coloring (L : Fin 3 → Finset Color) (a b c : Color)
    (ha : a ∈ L 0) (hb : b ∈ L 1) (hc : c ∈ L 2)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    IsListColoring graph L ![a,b,c] := by
  constructor
  · intro v; fin_cases v <;> assumption
  · intro x y h
    have hn : x ≠ y := h
    fin_cases x <;> fin_cases y <;> simp_all [ne_comm]

theorem erase_extension (L : Fin 3 → Finset Color)
    (hs : ∀ v, (L v).card = halfSizes v) (q t : Color)
    (ht : t ∈ L 2) (hne : (L 0).erase q ≠ L 1) :
    ∃ f, IsListColoring graph L f ∧ f 0 ≠ q ∧ f 2 = t := by
  have hc : 2 ≤ ((L 0).erase q).card := by
    have := Finset.pred_card_le_card_erase (s := L 0) (a := q)
    have h := hs 0
    change (L 0).card = 3 at h
    omega
  obtain ⟨a,ha,b,hb,hab,hat,hbt⟩ := triangle_pair_extension _ _ hc (hs 1) hne t
  exact ⟨![a,b,t],vector_coloring L a b t (Finset.mem_erase.mp ha).2 hb ht hab hat hbt,
    (Finset.mem_erase.mp ha).1,rfl⟩

theorem greedy_extension (L : Fin 3 → Finset Color)
    (hs : ∀ v, (L v).card = halfSizes v) (r s : Color) :
    ∃ f, IsListColoring graph L f ∧ f 0 ≠ r ∧ f 0 ≠ s := by
  obtain ⟨a,ha,har,has⟩ := exists_mem_avoiding_pair (L 0) (by rw [hs]; decide) r s
  obtain ⟨b,hb,hba⟩ := Finset.exists_mem_ne (s := L 1) (by rw [hs]; decide) a
  obtain ⟨c,hc,hca,hcb⟩ := exists_mem_avoiding_pair (L 2) (by rw [hs]; decide) a b
  exact ⟨![a,b,c],vector_coloring L a b c ha hb hc hba.symm hca.symm hcb.symm,har,has⟩
end JSP000513.Triangle

namespace JSP000513.Nine
abbrev Vertex := Fin 3 ⊕ (Fin 2 × Fin 3)
def cross (a : Fin 3) (b : Fin 2 × Fin 3) : Prop := a = 2 ∧ b.2 = 0
def graph : SimpleGraph Vertex := attach Triangle.graph (copies Triangle.graph) cross
def lists : Vertex → Finset ℕ := Sum.elim Triangle.lists (fun v => Triangle.lists v.2)
def halfSizes : Vertex → ℕ := Sum.elim Triangle.halfSizes (fun v => Triangle.halfSizes v.2)
def boundary (i : Fin 2) : Vertex := .inr (i,2)

theorem lists_card (v : Vertex) : (lists v).card = 2 * halfSizes v := by
  cases v with
  | inl a => exact Triangle.lists_card a
  | inr b => exact Triangle.lists_card b.2

universe u
variable {Color : Type u} [DecidableEq Color]

theorem combine_coloring (L : Vertex → Finset Color)
    (f : Fin 3 → Color) (g : Fin 2 → Fin 3 → Color)
    (hf : IsListColoring Triangle.graph (L ∘ Sum.inl) f)
    (hg : ∀ i, IsListColoring Triangle.graph (fun v => L (.inr (i,v))) (g i))
    (hn : ∀ i, g i 0 ≠ f 2) :
    IsListColoring graph L (Sum.elim f (fun v => g v.1 v.2)) := by
  apply hf.attach (IsListColoring.copies g hg)
  rintro a ⟨i,v⟩ ⟨rfl,hv⟩
  dsimp at hv ⊢
  subst v
  exact (hn i).symm

/-- Choose the two old terminal colors before the new terminal colors. -/
theorem flexible_extension (L : Vertex → Finset Color)
    (hs : ∀ v, (L v).card = halfSizes v)
    (R : Fin 2 → Finset Color) (hR : ∀ i, (R i).card = 3) :
    ∃ rs : Fin 2 → Color, (∀ i, rs i ∈ R i) ∧
      ∀ ts : Fin 2 → Color, (∀ i, ts i ∈ L (boundary i)) →
      ∃ f, IsListColoring graph L f ∧ (∀ i, f (.inl 0) ≠ rs i) ∧
        ∀ i, f (boundary i) = ts i := by
  classical
  let K := L ∘ Sum.inl
  let T : Fin 2 → Fin 3 → Finset Color := fun i v => L (.inr (i,v))
  have hK (v : Fin 3) : (K v).card = Triangle.halfSizes v := hs (.inl v)
  have hT (i : Fin 2) (v : Fin 3) : (T i v).card = Triangle.halfSizes v := hs (.inr (i,v))
  obtain ⟨r,hr,s,hsR,hres,hne⟩ := two_roots_residual (R 0) (R 1) (K 0) (K 1)
    (hR 0) (hR 1) (hK 0) (hK 1)
  obtain ⟨q,hq,hq0,hq1⟩ := avoid_two_bad_deletions (K 2) (T 0 0) (T 1 0)
    (T 0 1) (T 1 1) (hK 2) (hT 0 0) (hT 1 0) (hT 0 1) (hT 1 1)
  obtain ⟨a,ha,b,hb,hab,haq,hbq⟩ := triangle_pair_extension _ _ hres (hK 1) hne q
  have har := (Finset.mem_erase.mp (Finset.mem_erase.mp ha).2).1
  have has := (Finset.mem_erase.mp ha).1
  have haK := (Finset.mem_erase.mp (Finset.mem_erase.mp ha).2).2
  refine ⟨![r,s],?_,?_⟩
  · intro i; fin_cases i <;> assumption
  · intro ts hts
    have hqn (i : Fin 2) : (T i 0).erase q ≠ T i 1 := by fin_cases i <;> assumption
    have hp (i : Fin 2) := Triangle.erase_extension (T i) (hT i) q (ts i) (hts i) (hqn i)
    choose g hg hgq hgt using hp
    refine ⟨Sum.elim ![a,b,q] (fun v => g v.1 v.2),
      combine_coloring L _ g (Triangle.vector_coloring K a b q haK hb hq hab haq hbq) hg hgq,?_,?_⟩
    · intro i; fin_cases i <;> assumption
    · exact hgt

theorem greedy_extension (L : Vertex → Finset Color)
    (hs : ∀ v, (L v).card = halfSizes v) (rs : Fin 2 → Color) :
    ∃ f, IsListColoring graph L f ∧ ∀ i, f (.inl 0) ≠ rs i := by
  classical
  obtain ⟨f,hf,hf0,hf1⟩ := Triangle.greedy_extension (L ∘ Sum.inl)
    (fun v => hs (.inl v)) (rs 0) (rs 1)
  have hp (i : Fin 2) := Triangle.greedy_extension (fun v => L (.inr (i,v)))
    (fun v => hs (.inr (i,v))) (f 2) (f 2)
  choose g hg hg0 hg1 using hp
  refine ⟨Sum.elim f (fun v => g v.1 v.2),combine_coloring L f g hf hg hg0,?_⟩
  intro i; fin_cases i <;> assumption
end JSP000513.Nine

