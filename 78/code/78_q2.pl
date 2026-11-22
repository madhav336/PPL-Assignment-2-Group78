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
