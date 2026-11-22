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
