:- consult('../code/78_q2.pl').

% Test helper: read leaves in order from the implementation's num/1 and
% binary operator expression-tree terms.
test_expression_numbers(num(Number), [Number]).
test_expression_numbers(Expr, Numbers) :-
    Expr =.. [Operator, LeftExpr, RightExpr],
    memberchk(Operator, [+, -, *, /]),
    test_expression_numbers(LeftExpr, LeftNumbers),
    test_expression_numbers(RightExpr, RightNumbers),
    append(LeftNumbers, RightNumbers, Numbers).

:- begin_tests(p2_arithmetic_equations).

% Test 1: generate_equation/2 produces a valid equation for the PDF example.
test(generate_valid_equation, [nondet]) :-
    generate_equation([4, 2, 5, 3], Equation),
    memberchk(Equation,
              ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
               "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]).

% Test 2: a list with no solution fails to generate an equation.
test(generate_no_solution, [fail]) :-
    generate_equation([2, 3, 4], _).

% Test 3: an empty list fails to generate an equation.
test(generate_empty_list, [fail]) :-
    generate_equation([], _).

% Test 4: a one-number list fails to generate an equation.
test(generate_single_number, [fail]) :-
    generate_equation([5], _).

% Test 5: all equations for the first PDF example match exactly and in order.
test(all_equations_four_numbers) :-
    all_equations([4, 2, 5, 3], Equations),
    Equations == ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                  "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"].

% Test 6: the second PDF example has no valid equations.
test(all_equations_no_solution, [true(Equations == [])]) :-
    all_equations([2, 3, 4], Equations).

% Test 7: the third PDF example has one valid equation string.
test(all_equations_two_four_eight, [true(Equations == ["2*4=8"])]) :-
    all_equations([2, 4, 8], Equations).

% Test 8: count_equations/2 returns the counts for all three PDF examples.
test(count_equations_four_numbers, [true(Count =:= 7)]) :-
    count_equations([4, 2, 5, 3], Count).

test(count_equations_no_solution, [true(Count =:= 0)]) :-
    count_equations([2, 3, 4], Count).

test(count_equations_two_four_eight, [true(Count =:= 1)]) :-
    count_equations([2, 4, 8], Count).

% Test 9: exact division evaluates to an integer.
test(exact_division, [true(Value =:= 4)]) :-
    expr_value(/(num(8), num(2)), Value).

% Test 10: inexact division is rejected.
test(inexact_division, [fail]) :-
    expr_value(/(num(7), num(2)), _).

% Test 11: division by zero is rejected.
test(division_by_zero, [fail]) :-
    expr_value(/(num(4), num(0)), _).

% Test 12: negative intermediate values are evaluated correctly.
test(negative_intermediate, [true(Value =:= -1)]) :-
    expr_value(/(-(num(3), num(8)), num(5)), Value).

% Test 13: canonical parentheses preserve precedence and associativity.
test(canonical_parenthesization, [nondet]) :-
    expression_string(*(+(num(4), num(2)), num(3)), S1),
    expression_string(+(num(4), *(num(2), num(3))), S2),
    expression_string(*(/(num(8), num(4)), num(2)), S3),
    expression_string(/(num(8), *(num(4), num(2))), S4),
    expression_string(-(-(num(1), num(2)), num(3)), S5),
    expression_string(-(num(1), -(num(2), num(3))), S6),
    expression_string(+(num(1), +(num(2), num(3))), S7),
    expression_string(+(+(num(1), num(2)), num(3)), S8),
    [S1, S2, S3, S4, S5, S6, S7, S8] ==
    ["(4+2)*3", "4+2*3", "8/4*2", "8/(4*2)", "1-2-3", "1-(2-3)",
     "1+(2+3)", "1+2+3"].

% Test 14: all_equations/2 removes duplicates from its result.
test(duplicate_elimination) :-
    all_equations([4, 2, 5, 3], Equations),
    sort(Equations, Equations),
    length(Equations, 7).

% Test 15: all_equations/2 returns the equations in standard sorted order.
test(equation_sorting, [true(Equations == Expected)]) :-
    all_equations([4, 2, 5, 3], Equations),
    Expected = ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"].

% Test 16: generated equations are SWI strings without spaces.
test(equation_strings) :-
    all_equations([4, 2, 5, 3], Equations),
    maplist(string, Equations),
    forall(member(Equation, Equations), \+ sub_string(Equation, _, 1, _, " ")).

% Additional edge coverage from the final P2 review.
test(all_equations_empty_input, [true(Equations == [])]) :-
    all_equations([], Equations).

test(all_equations_single_input, [true(Equations == [])]) :-
    all_equations([5], Equations).

test(count_equations_empty_input, [true(Count =:= 0)]) :-
    count_equations([], Count).

test(count_equations_single_input, [true(Count =:= 0)]) :-
    count_equations([5], Count).

test(zero_dividend_exact_division, [true(Value =:= 0)]) :-
    expr_value(/(num(0), num(5)), Value).

test(zero_divisor_rejected, [fail]) :-
    expr_value(/(num(0), num(0)), _).

test(zero_pair_equation, [true(Equations == ["0=0"])]) :-
    all_equations([0, 0], Equations).

test(zero_equations_are_valid_unique_and_sorted) :-
    all_equations([4, 0, 0], Equations),
    Equations == ["4*0=0"],
    sort(Equations, Equations),
    forall(member(Equation, Equations),
           \+ sub_string(Equation, _, 2, _, "/0")).

test(expression_tree_single_number) :-
    findall(Expr, expression_tree([5], Expr), Trees),
    Trees == [num(5)].

test(expression_tree_all_trees_preserve_order_and_use_each_number_once) :-
    findall(Expr, expression_tree([1, 2, 3], Expr), Trees),
    length(Trees, 32),
    sort(Trees, UniqueTrees),
    length(UniqueTrees, 32),
    forall(member(Expr, Trees),
           test_expression_numbers(Expr, [1, 2, 3])).

test(expression_tree_empty_input, [fail]) :-
    expression_tree([], _).

test(expression_tree_non_integer_input, [fail]) :-
    expression_tree([one], _).

:- end_tests(p2_arithmetic_equations).
