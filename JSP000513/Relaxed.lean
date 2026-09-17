import JSP000513.ListColoring

namespace JSP000513
universe u v w

/-- A full coloring extending specified values at both distinguished
vertices and at an indexed family of boundary vertices. -/
def BoundaryExtension {V : Type u} {Color : Type v} {I : Type w}
    (G : SimpleGraph V) (L : V → Finset Color) (a b : V) (s : I → V)
    (ca cb : Color) (cs : I → Color) : Prop :=
  ∃ f, IsListColoring G L f ∧ f a = ca ∧ f b = cb ∧ ∀ i, f (s i) = cs i

/-- A stronger extension interface for the paper's relaxed gadgets.
All boundary color assignments satisfying their lists must extend; we
do not additionally require that they already color the induced boundary.
The concrete gadgets have independent boundaries, so the stronger form
is applicable and in particular implies the extension claims in DHS19.
The order of the existential and universal quantifiers is essential. -/
def StrongRelaxed {V : Type u} {Color : Type v} {I : Type w}
    (G : SimpleGraph V) (L : V → Finset Color) (a b : V) (s : I → V) : Prop :=
  (∃ ca ∈ L a, ∃ cb ∈ L b,
    ∀ cs : I → Color, (∀ i, cs i ∈ L (s i)) → BoundaryExtension G L a b s ca cb cs) ∨
  (L a = L b ∧ ∃ cs : I → Color, (∀ i, cs i ∈ L (s i)) ∧
    ∀ ca ∈ L a, ∀ cb ∈ L b, BoundaryExtension G L a b s ca cb cs)

end JSP000513
