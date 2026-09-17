import JSP000513
import Lean.Util.FoldConsts
open Lean Elab Command
set_option maxRecDepth 65536
set_option maxHeartbeats 8000000
#print axioms JSP000513.theorem2
#print axioms JSP000513.theorem2_all_palettes
#print axioms JSP000513.finitePaletteEquivalence
#print JSP000513.Theorem2NatTarget
#print JSP000513.Theorem2AllPalettesTarget
#print JSP000513.FinitePaletteEquivalenceTarget
#print JSP000513.IsListMulticoloring
#print JSP000513.ABChoosableOn
#print JSP000513.StrongRelaxed
elab "audit_closure " root:ident : command => do
  let env ← getEnv
  let rootName := root.getId
  unless env.contains rootName do throwError "missing root {rootName}"
  let mut todo : Array Name := #[rootName]
  let mut seen : NameHashSet := {}
  let mut names : Array String := #[]
  let mut bad : Array String := #[]
  let mut axioms : Array String := #[]
  let mut implementations : Array String := #[]
  while !todo.isEmpty do
    let n := todo.back!
    todo := todo.pop
    if seen.contains n then continue
    seen := seen.insert n
    let some ci := env.find? n | throwError "missing dependency {n}"
    names := names.push n.toString
    if let some imp := Compiler.getImplementedBy? env n then
      implementations := implementations.push s!"implemented_by {n} => {imp}"
    if (getExternAttrData? env n).isSome then
      implementations := implementations.push s!"extern {n}"
    if ci.isUnsafe || ci.isPartial then bad := bad.push s!"unsafe/partial {n}"
    match ci with
    | .axiomInfo _ =>
      axioms := axioms.push n.toString
      unless n == ``propext || n == ``Classical.choice || n == ``Quot.sound do
        bad := bad.push s!"unapproved axiom {n}"
    | _ => pure ()
    if (n.toString.splitOn "sorry").length > 1 ||
       (n.toString.splitOn "ofReduceBool").length > 1 ||
       (n.toString.splitOn "nativeDecide").length > 1 then
      bad := bad.push s!"suspicious constant {n}"
    for dep in ci.getUsedConstantsAsSet do
      if !seen.contains dep then todo := todo.push dep
  let out := "D:/Lean/jsp-000513-cleanroom/evidence/closure-" ++ rootName.toString ++ ".txt"
  liftIO <| IO.FS.writeFile out (String.intercalate "\n" names.toList)
  liftIO <| IO.FS.writeFile (out ++ ".runtime.txt") (String.intercalate "\n" implementations.toList)
  logInfo m!"CLOSURE {rootName}: {names.size} constants; axioms={axioms}; flagged={bad}; file={out}"
  unless bad.isEmpty do throwError "closure audit failed"
audit_closure JSP000513.theorem2
audit_closure JSP000513.theorem2_all_palettes
audit_closure JSP000513.finitePaletteEquivalence
