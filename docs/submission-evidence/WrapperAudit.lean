import JSP000513.Problem
#print JSP000513.list_choosability_doubling_is_false
#print axioms JSP000513.list_choosability_doubling_is_false
example : ¬ (∀ (n : ℕ) (G : SimpleGraph (Fin n)),
    JSP000513.ABChoosable G 4 1 → JSP000513.ABChoosable G 8 2) :=
  JSP000513.list_choosability_doubling_is_false
