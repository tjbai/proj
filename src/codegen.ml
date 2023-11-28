open Core

module type CodeGen = sig
  val convertToString : Ast.statement list -> string
end

(*TODO
    Expressions
    Functions
    For Loops
    While Loops
    if
      Elif
  else
    Pass
    Break
    Conitinue
*)

module ConModule : CodeGen = struct
  (*Helper functions*)
  let checkIfSubAdd binaryOp =
    match binaryOp with
    | Ast.BinaryOp { operator = op; left = _; right = _ } -> (
        match op with Ast.Add -> true | Ast.Subtract -> true | _ -> false)
    | _ -> false

  (*RETURN - e.g. return a + b*)
  let returnExpression (input : string) : string = "return " ^ input

  (*CONVERSION of Expression*)

  let convertExpressionToString (exp : Ast.expression) : string =
    let rec mainHelper (exp : Ast.expression) : string =
      match exp with
      | Ast.IntLiteral i -> string_of_int i
      | Ast.StringLiteral s -> s
      | Ast.Identifier i -> i
      (*Assignments*)
      | Ast.Assignment { name = id; value = exp } -> id ^ " = " ^ mainHelper exp
      (*Binary Operations*)
      | Ast.BinaryOp { operator = op; left; right } -> (
          match op with
          | Ast.Add -> mainHelper left ^ " + " ^ mainHelper right
          | Ast.Multiply -> (
              match (checkIfSubAdd left, checkIfSubAdd right) with
              | true, true ->
                  "(" ^ mainHelper left ^ ") * (" ^ mainHelper right ^ ")"
              | true, false -> "(" ^ mainHelper left ^ ") * " ^ mainHelper right
              | false, true -> mainHelper left ^ " * (" ^ mainHelper right ^ ")"
              | false, false -> mainHelper left ^ " * " ^ mainHelper right)
          | Ast.Subtract -> mainHelper left ^ " - " ^ mainHelper right
          | Ast.Divide -> (
              match (checkIfSubAdd left, checkIfSubAdd right) with
              | true, true ->
                  "(" ^ mainHelper left ^ ") / (" ^ mainHelper right ^ ")"
              | true, false -> "(" ^ mainHelper left ^ ") / " ^ mainHelper right
              | false, true -> mainHelper left ^ " / (" ^ mainHelper right ^ ")"
              | false, false -> mainHelper left ^ " / " ^ mainHelper right)
          | _ -> failwith "Catastrophic Error")
      (*(*Unary Operations*)
        | Ast.UnaryOp { operator = op; operand = exp } -> "TODO"
        (*Functional Calls*)
        | Ast.FunctionCall { name = id; arguments = expList } -> "TODO"
        (*Core Function Calls*)
        | Ast.CoreFunctionCall { name = id; arguments = expList } -> "TODO" *)
      | _ -> ""
    in

    let result = mainHelper exp in
    result ^ ";"

  let convertToString (tree_list : Ast.statement list) : string =
    let rec helper (tree_list : Ast.statement list) (acc : string) : string =
      match tree_list with
      | [] -> acc
      (*Expression Assignment*)
      | Ast.Expression exp :: tl -> helper tl (convertExpressionToString exp)
      | Ast.Return exp :: tl ->
          helper tl (returnExpression (convertExpressionToString exp))
      | _ -> "bob"
    in
    helper tree_list ""
end
