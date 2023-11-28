open Ast
open Codegen
open OUnit2

(*Sample Tree to Test - a+b
  let adding_1 =
    [
      Ast.Expression
        (BinaryOp
           { operator = Add; left = Identifier "a"; right = Identifier "b" });
    ]
*)

let additionOnly =
  [
    Ast.Expression
      (BinaryOp
         {
           operator = Ast.Add;
           left =
             BinaryOp
               {
                 operator = Ast.Add;
                 left = Identifier "a";
                 right = Identifier "b";
               };
           right =
             BinaryOp
               {
                 operator = Ast.Add;
                 left = Identifier "c";
                 right = Identifier "d";
               };
         });
  ]

let addSubMix =
  [
    Ast.Expression
      (BinaryOp
         {
           operator = Ast.Subtract;
           left =
             BinaryOp
               {
                 operator = Ast.Add;
                 left = Identifier "a";
                 right = Identifier "b";
               };
           right =
             BinaryOp
               {
                 operator = Ast.Add;
                 left = Identifier "c";
                 right = Identifier "d";
               };
         });
  ]

let addMult_1 =
  [
    Ast.Expression
      (BinaryOp
         {
           operator = Ast.Multiply;
           left =
             BinaryOp
               {
                 operator = Ast.Add;
                 left = Identifier "a";
                 right = Identifier "b";
               };
           right =
             BinaryOp
               {
                 operator = Ast.Add;
                 left = Identifier "c";
                 right = Identifier "d";
               };
         });
  ]

let addMult_2 =
  [
    Ast.Expression
      (BinaryOp
         {
           operator = Ast.Multiply;
           left =
             BinaryOp
               {
                 operator = Ast.Multiply;
                 left =
                   BinaryOp
                     {
                       operator = Ast.Add;
                       left = Identifier "a";
                       right = Identifier "b";
                     };
                 right = Identifier "b";
               };
           right =
             BinaryOp
               {
                 operator = Ast.Add;
                 left = Identifier "c";
                 right =
                   BinaryOp
                     {
                       operator = Ast.Multiply;
                       left = Identifier "c";
                       right = Identifier "d";
                     };
               };
         });
  ]

let mult_1 =
  [
    Ast.Expression
      (BinaryOp
         {
           operator = Ast.Multiply;
           left = Identifier "a";
           right = Identifier "b";
         });
  ]

let multDiv =
  [
    Ast.Expression
      (BinaryOp
         {
           operator = Ast.Divide;
           left =
             BinaryOp
               {
                 operator = Ast.Multiply;
                 left = Identifier "a";
                 right = Identifier "b";
               };
           right =
             BinaryOp
               {
                 operator = Ast.Divide;
                 left = Identifier "c";
                 right = Identifier "d";
               };
         });
  ]

let multDivAddSub =
  [
    Ast.Expression
      (BinaryOp
         {
           operator = Ast.Add;
           left =
             BinaryOp
               {
                 operator = Ast.Divide;
                 left =
                   BinaryOp
                     {
                       operator = Ast.Multiply;
                       left = Identifier "a";
                       right = Identifier "b";
                     };
                 right = Identifier "b";
               };
           right =
             BinaryOp
               {
                 operator = Ast.Subtract;
                 left = Identifier "c";
                 right =
                   BinaryOp
                     {
                       operator = Ast.Divide;
                       left = Identifier "c";
                       right = Identifier "d";
                     };
               };
         });
  ]

(*Expression tests*)
let expression_1 _ =
  assert_equal "a + b + c + d;" @@ ConModule.convertToString additionOnly;
  assert_equal "(a + b) * (c + d);" @@ ConModule.convertToString addMult_1;
  assert_equal "a * b;" @@ ConModule.convertToString mult_1;
  assert_equal "(a + b) * b * (c + c * d);"
  @@ ConModule.convertToString addMult_2;
  assert_equal "a + b - c + d;" @@ ConModule.convertToString addSubMix;
  assert_equal "a * b / c / d;" @@ ConModule.convertToString multDiv;
  assert_equal "a * b / b + c - c / d;"
  @@ ConModule.convertToString multDivAddSub

(***************************** Assignment tests **************************************)

let assignment_eg_1 =
  [ Ast.Expression (Assignment { name = "a"; value = IntLiteral 5 }) ]

let assignment_1 _ =
  assert_equal "a = 5;" @@ ConModule.convertToString assignment_eg_1

(***************************** Return tests ******************************************)

let return_eg_1 = [ Ast.Return (IntLiteral 5) ]

let return_1 _ =
  assert_equal "return 5;" @@ ConModule.convertToString return_eg_1

(***************************** UTIL **************************************************)

let codeGenTests =
  "codeGen tests"
  >: test_list
       [
         "assignment tests" >:: assignment_1;
         "return tests" >:: return_1;
         "expression_1" >:: expression_1;
       ]

let series = "Final Project Tests" >::: [ codeGenTests ]
let () = run_test_tt_main series
