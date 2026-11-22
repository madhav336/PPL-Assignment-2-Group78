:- consult('../code/78_q1.pl').

:- begin_tests(p1_puzzle).

% Test 1: Candidate generator produces valid structure and distinct attributes
test(generator_structure, [nondet]) :-
    generate_solution(S),
    S = [p('Alex', D1, L1, P1),
         p('Ben', D2, L2, P2),
         p('Carla', D3, L3, P3),
         p('Dana', D4, L4, P4)],
    is_set([D1, D2, D3, D4]),
    is_set([L1, L2, L3, L4]),
    is_set([P1, P2, P3, P4]).

% Test 2: main/0 prints four lines in exact expected format and succeeds deterministically
test(main_output, [true]) :-
    with_output_to(string(Output), main),
    split_string(Output, "\n", "", Lines),
    Lines = [
        "Alex = [design, java, AI]",
        "Ben = [development, javascript, web]",
        "Carla = [research, c++, data]",
        "Dana = [testing, python, embedded]",
        ""
    ].

% Test 3: count_solutions on empty clue list [] gives 13824
test(count_empty_clues, [true(N == 13824)]) :-
    count_solutions([], N).

% Test 4: count_solutions on subsets of clues: [1..4] gives 208, and [1..8] gives 3
test(count_clues_1_to_4, [true(N == 208)]) :-
    count_solutions([1, 2, 3, 4], N).

test(count_clues_1_to_8, [true(N == 3)]) :-
    count_solutions([1, 2, 3, 4, 5, 6, 7, 8], N).

% Test 5: count_solutions on clues [1..9] gives exactly N = 1
test(count_clues_1_to_9, [true(N == 1)]) :-
    count_solutions([1, 2, 3, 4, 5, 6, 7, 8, 9], N).

% Test 6: verify that the unique solution for [1..9] satisfies clue 9,
% while other solutions of [1..8] fail clue 9
test(clue_9_discriminates_solution, [true]) :-
    findall(S, (generate_solution(S), satisfies_active_clues([1,2,3,4,5,6,7,8], S)), Sols),
    length(Sols, 3),
    include(clue(9), Sols, KeptSols),
    length(KeptSols, 1),
    exclude(clue(9), Sols, ExcludedSols),
    length(ExcludedSols, 2).

% Test 7: count_solutions with an unsatisfiable clue list gives N = 0
test(count_unsatisfiable_clues, [true(N == 0)]) :-
    count_solutions([99], N).

:- end_tests(p1_puzzle).
