import JSP000513

open JSP000513

namespace Cleanroom

instance {V W : Type} (G : SimpleGraph V) (H : SimpleGraph W) (E : V → W → Prop)
    [DecidableRel G.Adj] [DecidableRel H.Adj] [DecidableRel E] : DecidableRel (attach G H E).Adj := by
  intro x y
  cases x <;> cases y <;> dsimp [attach] <;> infer_instance
instance {I V : Type} [DecidableEq I] (G : SimpleGraph V) [DecidableRel G.Adj] : DecidableRel (copies (I := I) G).Adj := fun _ _ => by
  dsimp [copies]; infer_instance
instance : DecidableRel G3.cross := fun _ _ => by unfold G3.cross; infer_instance
instance : DecidableRel Nine.cross := fun _ _ => by unfold Nine.cross; infer_instance
instance : DecidableRel Triangle.graph.Adj := fun _ _ => by unfold Triangle.graph; infer_instance
instance : DecidableRel Nine.graph.Adj := fun _ _ => by unfold Nine.graph; infer_instance
instance : DecidableRel G4.cross := fun _ _ => by unfold G4.cross; infer_instance
instance : DecidableRel G5.cross := fun _ _ => by unfold G5.cross; infer_instance
instance : DecidableRel G5.small.Adj := fun _ _ => by unfold G5.small; infer_instance

set_option maxRecDepth 65536

set_option maxHeartbeats 16000000

def mapC5 : Fin 5 → Fin 5 := ![0,1,2,3,4]

def edgesC5 : Finset (Fin 5 × Fin 5) := {(0,1),(0,4),(1,2),(2,3),(3,4)}

example : Function.Bijective mapC5 := by decide

example : ∀ a b, C5.graph.Adj (mapC5 a) (mapC5 b) ↔ ((a,b) ∈ edgesC5 ∨ (b,a) ∈ edgesC5) := by decide

def listsC5 : Fin 5 → Finset ℕ := ![{1,2,5,6},{1,4,5,6},{3,4,5,6},{3,4,5,6},{2,4,5,6}]

example : ∀ a, C5.lists (mapC5 a) = listsC5 a := by decide

#eval "Checking expected C5: 5 vertices, 5 undirected edges, all lists, bijection"

example : (Finset.univ.filter (fun p : Fin 5 × Fin 5 => C5.graph.Adj (mapC5 p.1) (mapC5 p.2))).card = 10 := by decide

def mapG1 : Fin 7 → Fin 7 := ![0,1,2,3,4,5,6]

def edgesG1 : Finset (Fin 7 × Fin 7) := {(0,1),(0,4),(0,5),(1,2),(2,3),(2,6),(3,4),(5,6)}

example : Function.Bijective mapG1 := by decide

example : ∀ a b, G1.graph.Adj (mapG1 a) (mapG1 b) ↔ ((a,b) ∈ edgesG1 ∨ (b,a) ∈ edgesG1) := by decide

def listsG1 : Fin 7 → Finset ℕ := ![{1,2,3,4,5,6},{1,4,5,6},{1,2,3,4,5,6},{3,4,5,6},{2,4,5,6},{1,2,3,4},{1,2}]

example : ∀ a, G1.lists (mapG1 a) = listsG1 a := by decide

#eval "Checking expected G1: 7 vertices, 8 undirected edges, all lists, bijection"

example : (Finset.univ.filter (fun p : Fin 7 × Fin 7 => G1.graph.Adj (mapG1 p.1) (mapG1 p.2))).card = 16 := by decide

def mapG2 : Fin 9 → Fin 9 := ![0,1,2,3,4,5,6,7,8]

def edgesG2 : Finset (Fin 9 × Fin 9) := {(0,1),(0,4),(0,5),(1,2),(1,5),(2,3),(2,5),(3,4),(3,5),(4,5),(5,6),(6,7),(6,8),(7,8)}

example : Function.Bijective mapG2 := by decide

example : ∀ a b, G2.graph.Adj (mapG2 a) (mapG2 b) ↔ ((a,b) ∈ edgesG2 ∨ (b,a) ∈ edgesG2) := by decide

def listsG2 : Fin 9 → Finset ℕ := ![{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8}]

example : ∀ a, G2.lists (mapG2 a) = listsG2 a := by decide

#eval "Checking expected G2: 9 vertices, 14 undirected edges, all lists, bijection"

example : (Finset.univ.filter (fun p : Fin 9 × Fin 9 => G2.graph.Adj (mapG2 p.1) (mapG2 p.2))).card = 28 := by decide

def mapG3 : Fin 23 → G3.Vertex := ![.inl 0,.inl 1,.inl 2,.inl 3,.inl 4,.inl 5,.inl 6,.inl 7,.inl 8,.inr (0,0),.inr (0,1),.inr (0,2),.inr (0,3),.inr (0,4),.inr (0,5),.inr (0,6),.inr (1,0),.inr (1,1),.inr (1,2),.inr (1,3),.inr (1,4),.inr (1,5),.inr (1,6)]

instance : DecidableRel G3.graph.Adj := fun _ _ => by
  unfold G3.graph
  infer_instance

def edgesG3 : Finset (Fin 23 × Fin 23) := {(0,1),(0,4),(0,5),(1,2),(1,5),(2,3),(2,5),(3,4),(3,5),(4,5),(5,6),(6,7),(6,8),(7,8),(8,9),(8,10),(8,16),(8,17),(9,11),(9,12),(10,11),(10,12),(11,12),(12,13),(13,14),(13,15),(14,15),(16,18),(16,19),(17,18),(17,19),(18,19),(19,20),(20,21),(20,22),(21,22)}

example : Function.Bijective mapG3 := by decide

example : ∀ a b, G3.graph.Adj (mapG3 a) (mapG3 b) ↔ ((a,b) ∈ edgesG3 ∨ (b,a) ∈ edgesG3) := by decide

def listsG3 : Fin 23 → Finset ℕ := ![{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,7},{4,5,6,7},{1,2,3,4,5,6},{1,2,3,4,5,6,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,8},{4,5,6,8},{1,2,3,4,5,6},{1,2,3,4,5,6,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8}]

example : ∀ a, G3.lists (mapG3 a) = listsG3 a := by decide

#eval "Checking expected G3: 23 vertices, 36 undirected edges, all lists, bijection"

example : (Finset.univ.filter (fun p : Fin 23 × Fin 23 => G3.graph.Adj (mapG3 p.1) (mapG3 p.2))).card = 72 := by decide

def mapG4 : Fin 32 → G4.Vertex := ![.inl (.inl 0),.inl (.inl 1),.inl (.inl 2),.inl (.inl 3),.inl (.inl 4),.inl (.inl 5),.inl (.inl 6),.inl (.inl 7),.inl (.inl 8),.inl (.inr (0,0)),.inl (.inr (0,1)),.inl (.inr (0,2)),.inl (.inr (0,3)),.inl (.inr (0,4)),.inl (.inr (0,5)),.inl (.inr (0,6)),.inl (.inr (1,0)),.inl (.inr (1,1)),.inl (.inr (1,2)),.inl (.inr (1,3)),.inl (.inr (1,4)),.inl (.inr (1,5)),.inl (.inr (1,6)),.inr (.inl 0),.inr (.inl 1),.inr (.inl 2),.inr (.inr (0,0)),.inr (.inr (0,1)),.inr (.inr (0,2)),.inr (.inr (1,0)),.inr (.inr (1,1)),.inr (.inr (1,2))]

instance : DecidableRel G4.graph.Adj := fun _ _ => by
  unfold G4.graph
  infer_instance

def edgesG4 : Finset (Fin 32 × Fin 32) := {(0,1),(0,4),(0,5),(1,2),(1,5),(2,3),(2,5),(3,4),(3,5),(4,5),(5,6),(6,7),(6,8),(7,8),(8,9),(8,10),(8,16),(8,17),(9,11),(9,12),(10,11),(10,12),(11,12),(12,13),(13,14),(13,15),(14,15),(15,23),(16,18),(16,19),(17,18),(17,19),(18,19),(19,20),(20,21),(20,22),(21,22),(22,23),(23,24),(23,25),(24,25),(25,26),(25,29),(26,27),(26,28),(27,28),(29,30),(29,31),(30,31)}

example : Function.Bijective mapG4 := by decide

example : ∀ a b, G4.graph.Adj (mapG4 a) (mapG4 b) ↔ ((a,b) ∈ edgesG4 ∨ (b,a) ∈ edgesG4) := by decide

def listsG4 : Fin 32 → Finset ℕ := ![{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,7},{4,5,6,7},{1,2,3,4,5,6},{1,2,3,4,5,6,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,8},{4,5,6,8},{1,2,3,4,5,6},{1,2,3,4,5,6,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8}]

example : ∀ a, G4.lists (mapG4 a) = listsG4 a := by decide

#eval "Checking expected G4: 32 vertices, 49 undirected edges, all lists, bijection"

example : (Finset.univ.filter (fun p : Fin 32 × Fin 32 => G4.graph.Adj (mapG4 p.1) (mapG4 p.2))).card = 98 := by decide

def mapG5 : Fin 37 → G5.Vertex := ![.inl (.inl (.inl 0)),.inl (.inl (.inl 1)),.inl (.inl (.inl 2)),.inl (.inl (.inl 3)),.inl (.inl (.inl 4)),.inl (.inl (.inl 5)),.inl (.inl (.inl 6)),.inl (.inl (.inl 7)),.inl (.inl (.inl 8)),.inl (.inl (.inr (0,0))),.inl (.inl (.inr (0,1))),.inl (.inl (.inr (0,2))),.inl (.inl (.inr (0,3))),.inl (.inl (.inr (0,4))),.inl (.inl (.inr (0,5))),.inl (.inl (.inr (0,6))),.inl (.inl (.inr (1,0))),.inl (.inl (.inr (1,1))),.inl (.inl (.inr (1,2))),.inl (.inl (.inr (1,3))),.inl (.inl (.inr (1,4))),.inl (.inl (.inr (1,5))),.inl (.inl (.inr (1,6))),.inl (.inr (.inl 0)),.inl (.inr (.inl 1)),.inl (.inr (.inl 2)),.inl (.inr (.inr (0,0))),.inl (.inr (.inr (0,1))),.inl (.inr (.inr (0,2))),.inl (.inr (.inr (1,0))),.inl (.inr (.inr (1,1))),.inl (.inr (.inr (1,2))),.inr 0,.inr 1,.inr 2,.inr 3,.inr 4]

instance : DecidableRel G5.graph.Adj := fun _ _ => by
  unfold G5.graph
  infer_instance

def edgesG5 : Finset (Fin 37 × Fin 37) := {(0,1),(0,4),(0,5),(0,32),(0,34),(0,35),(1,2),(1,5),(2,3),(2,5),(2,32),(2,33),(2,36),(3,4),(3,5),(4,5),(5,6),(6,7),(6,8),(7,8),(8,9),(8,10),(8,16),(8,17),(9,11),(9,12),(10,11),(10,12),(11,12),(12,13),(13,14),(13,15),(14,15),(15,23),(16,18),(16,19),(17,18),(17,19),(18,19),(19,20),(20,21),(20,22),(21,22),(22,23),(23,24),(23,25),(24,25),(25,26),(25,29),(26,27),(26,28),(27,28),(28,32),(28,33),(29,30),(29,31),(30,31),(31,35),(31,36),(33,34),(35,36)}

example : Function.Bijective mapG5 := by decide

example : ∀ a b, G5.graph.Adj (mapG5 a) (mapG5 b) ↔ ((a,b) ∈ edgesG5 ∨ (b,a) ∈ edgesG5) := by decide

def listsG5 : Fin 37 → Finset ℕ := ![{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6},{1,2,3,4,5,6,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,7},{4,5,6,7},{1,2,3,4,5,6},{1,2,3,4,5,6,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,8},{4,5,6,8},{1,2,3,4,5,6},{1,2,3,4,5,6,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8},{1,4,5,6,7,8},{3,4,5,6,7,8},{2,4,5,6},{1,2,3,4,7,8},{1,2,7,8}]

example : ∀ a, G5.lists (mapG5 a) = listsG5 a := by decide

#eval "Checking expected G5: 37 vertices, 61 undirected edges, all lists, bijection"

example : (Finset.univ.filter (fun p : Fin 37 × Fin 37 => G5.graph.Adj (mapG5 p.1) (mapG5 p.2))).card = 122 := by decide

example : Function.Injective G5.embed := by decide

example : ∀ i j, G5.graph.Adj (G5.embed i) (G5.embed j) ↔ G1.graph.Adj i j := by decide

example : ∀ i, Final.neighbors (mapG5 i) = (Finset.univ.filter (fun j : Fin 4 => j.val < 4 - (listsG5 i).card / 2)) := by decide

def indexWitness : Final.Index := ⟨![⟨{9,10},by decide⟩,⟨{11,12},by decide⟩,⟨{13,14},by decide⟩,⟨{15,16},by decide⟩],by unfold Final.Valid; decide⟩

#check indexWitness

end Cleanroom
