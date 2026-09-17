import JSP000513.MainTheorem

namespace JSP000513

/-- JSP-000513 has a negative answer: even among finite graphs,
(4:1)-choosability does not always imply (8:2)-choosability.
The contradiction uses the same finite graph supplied by DHS19 Theorem 2. -/
theorem list_choosability_doubling_is_false :
    ¬ (∀ (n : ℕ) (G : SimpleGraph (Fin n)),
      ABChoosable G 4 1 → ABChoosable G 8 2) := by
  intro h
  obtain ⟨n, G, h4, h82⟩ := theorem2
  exact h82 (h n G h4)

end JSP000513
