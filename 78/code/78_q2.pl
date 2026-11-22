:- use_module(library(lists), [append/3, member/2]).

%! expr_value(+Expr, -Value) is semidet.
%  Declarative reading: Value is the integer value of expression tree Expr,
%  where each node uses one of the four binary arithmetic operators and every
%  division has a non-zero divisor and an exact result. Invalid trees fail.
expr_value(num(Number), Number) :-
    integer(Number).
expr_value(+(LeftExpr, RightExpr), Value) :-
    expr_value(LeftExpr, LeftValue),
    expr_value(RightExpr, RightValue),
    integer(LeftValue),
    integer(RightValue),
    Value is LeftValue + RightValue.
expr_value(-(LeftExpr, RightExpr), Value) :-
    expr_value(LeftExpr, LeftValue),
    expr_value(RightExpr, RightValue),
    integer(LeftValue),
    integer(RightValue),
    Value is LeftValue - RightValue.
expr_value(*(LeftExpr, RightExpr), Value) :-
    expr_value(LeftExpr, LeftValue),
    expr_value(RightExpr, RightValue),
    integer(LeftValue),
    integer(RightValue),
    Value is LeftValue * RightValue.
expr_value(/(LeftExpr, RightExpr), Value) :-
    expr_value(LeftExpr, LeftValue),
    expr_value(RightExpr, RightValue),
    integer(LeftValue),
    integer(RightValue),
    RightValue =\= 0,
    LeftValue mod RightValue =:= 0,
    Value is LeftValue // RightValue.

% P2.2: expression tree generator
%! expression_tree(+Numbers, -Expr) is nondet.
%  Declarative reading: Expr is a binary arithmetic tree whose leaves contain
%  every integer in Numbers exactly once and in the same order. Every division
%  tree is generated; expr_value/2 determines whether its divisions are valid.
expression_tree([Number], num(Number)) :-
    integer(Number).
expression_tree(Numbers, Expr) :-
    append(LeftNumbers, RightNumbers, Numbers),
    LeftNumbers = [_|_],
    RightNumbers = [_|_],
    expression_tree(LeftNumbers, LeftExpr),
    expression_tree(RightNumbers, RightExpr),
    member(Operator, [+, -, *, /]),
    Expr =.. [Operator, LeftExpr, RightExpr].

% P2.1: consecutive input splits and equal expression sides
%! number_split(+Numbers, -LeftNumbers, -RightNumbers) is nondet.
%  Declarative reading: LeftNumbers and RightNumbers are non-empty consecutive
%  parts of Numbers whose concatenation is exactly Numbers.
number_split(Numbers, LeftNumbers, RightNumbers) :-
    append(LeftNumbers, RightNumbers, Numbers),
    LeftNumbers = [_|_],
    RightNumbers = [_|_].

%! equal_expression_sides(+Numbers, -LeftExpr, -RightExpr) is nondet.
%  Declarative reading: LeftExpr and RightExpr are generated from two
%  non-empty consecutive parts of Numbers and have the same integer value.
equal_expression_sides(Numbers, LeftExpr, RightExpr) :-
    number_split(Numbers, LeftNumbers, RightNumbers),
    expression_tree(LeftNumbers, LeftExpr),
    expression_tree(RightNumbers, RightExpr),
    expr_value(LeftExpr, LeftValue),
    expr_value(RightExpr, RightValue),
    LeftValue =:= RightValue.

% P2.4: canonical expression formatting
%! expression_string(+Expr, -String) is semidet.
%  Declarative reading: String is the canonical, space-free SWI string for
%  valid integer expression tree Expr, with parentheses preserving its tree.
expression_string(Expr, String) :-
    expression_string_at(Expr, 0, top, String).

%! expression_string_at(+Expr, +ParentPrecedence, +Side, -String) is semidet.
%  Declarative reading: String is Expr formatted for its position as a child
%  of an operator with ParentPrecedence, or as a top-level expression.
expression_string_at(num(Number), _, _, String) :-
    integer(Number),
    number_string(Number, String).
expression_string_at(Expr, ParentPrecedence, Side, String) :-
    Expr =.. [Operator, LeftExpr, RightExpr],
    operator_details(Operator, Symbol, Precedence),
    expression_string_at(LeftExpr, Precedence, left, LeftString),
    expression_string_at(RightExpr, Precedence, right, RightString),
    string_concat(LeftString, Symbol, LeftAndOperator),
    string_concat(LeftAndOperator, RightString, Body),
    parenthesize(Body, Precedence, ParentPrecedence, Side, String).

%! operator_details(+Operator, -Symbol, -Precedence) is det.
%  Declarative reading: Symbol and Precedence describe one of the four
%  supported binary arithmetic operators.
operator_details(+, "+", 1).
operator_details(-, "-", 1).
operator_details(*, "*", 2).
operator_details(/, "/", 2).

%! parenthesize(+Body, +Precedence, +ParentPrecedence, +Side, -String) is semidet.
%  Declarative reading: String is Body with parentheses exactly when the
%  child's precedence and side require them to preserve the expression tree.
parenthesize(Body, _, _, top, Body).
parenthesize(Body, Precedence, ParentPrecedence, left, Body) :-
    Precedence >= ParentPrecedence.
parenthesize(Body, Precedence, ParentPrecedence, left, String) :-
    Precedence < ParentPrecedence,
    string_concat("(", Body, Opened),
    string_concat(Opened, ")", String).
parenthesize(Body, Precedence, ParentPrecedence, right, Body) :-
    Precedence > ParentPrecedence.
parenthesize(Body, Precedence, ParentPrecedence, right, String) :-
    Precedence =< ParentPrecedence,
    string_concat("(", Body, Opened),
    string_concat(Opened, ")", String).

% P2.a: generate one valid equation
%! generate_equation(+Numbers, -Equation) is nondet.
%  Declarative reading: Equation is a space-free SWI string for two
%  canonically formatted expressions from consecutive parts of Numbers that
%  evaluate to the same integer using only exact, non-zero-divisor division.
generate_equation(Numbers, Equation) :-
    equal_expression_sides(Numbers, LeftExpr, RightExpr),
    expression_string(LeftExpr, LeftString),
    expression_string(RightExpr, RightString),
    string_concat(LeftString, "=", LeftAndEquals),
    string_concat(LeftAndEquals, RightString, Equation).

% P2.b: collect all valid equations
%! all_equations(+Numbers, -Equations) is det.
%  Declarative reading: Equations is the sorted list of distinct equation
%  strings generated for Numbers, or [] when no valid equation exists.
all_equations(Numbers, Equations) :-
    findall(Equation, generate_equation(Numbers, Equation), UnsortedEquations),
    sort(UnsortedEquations, Equations).

%! count_equations(+Numbers, -Count) is det.
%  Declarative reading: Count is the number of distinct valid equations for
%  Numbers, as collected and sorted by all_equations/2.
count_equations(Numbers, Count) :-
    all_equations(Numbers, Equations),
    length(Equations, Count).
