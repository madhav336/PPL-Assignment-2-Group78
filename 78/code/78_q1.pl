:- use_module(library(lists)).

% =============================================================================
% P1: Solution Generator
% =============================================================================

%! departments(-Departments) is det.
%  Declarative reading: Departments is the list of valid department atoms.
departments([research, development, design, testing]).

%! languages(-Languages) is det.
%  Declarative reading: Languages is the list of valid language atoms.
languages([python, java, 'c++', javascript]).

%! projects(-Projects) is det.
%  Declarative reading: Projects is the list of valid project atoms.
projects(['AI', web, embedded, data]).

%! generate_solution(-Solution) is nondet.
%  Declarative reading: Solution is a list of four terms
%  [p('Alex', DeptAlex, LangAlex, ProjAlex),
%   p('Ben', DeptBen, LangBen, ProjBen),
%   p('Carla', DeptCarla, LangCarla, ProjCarla),
%   p('Dana', DeptDana, LangDana, ProjDana)]
%  representing the four friends in fixed order, where each attribute
%  (department, language, project) is assigned a distinct value from its domain
%  via a permutation of the four domain values.
generate_solution([
    p('Alex',  DeptAlex,  LangAlex,  ProjAlex),
    p('Ben',   DeptBen,   LangBen,   ProjBen),
    p('Carla', DeptCarla, LangCarla, ProjCarla),
    p('Dana',  DeptDana,  LangDana,  ProjDana)
]) :-
    departments(Depts),
    permutation(Depts, [DeptAlex, DeptBen, DeptCarla, DeptDana]),
    languages(Langs),
    permutation(Langs, [LangAlex, LangBen, LangCarla, LangDana]),
    projects(Projs),
    permutation(Projs, [ProjAlex, ProjBen, ProjCarla, ProjDana]).

% =============================================================================
% Clues
% =============================================================================

%! clue(+ClueNumber, +Solution) is semidet.
%  Declarative reading: Holds when clue number ClueNumber is satisfied by the
%  fully bound candidate Solution.

% 1. The friend who prefers the AI project does not work in research and is not Dana.
clue(1, Solution) :-
    member(p(Name, Dept, _Lang, 'AI'), Solution),
    Dept \= research,
    Name \= 'Dana'.

% 2. Alex does not work in development and does not prefer C++.
clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _Proj), Solution),
    Dept \= development,
    Lang \= 'c++'.

% 3. The friend working in the testing department likes Python.
clue(3, Solution) :-
    member(p(_Name, testing, python, _Proj), Solution).

% 4. Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    member(p('Ben', Dept, _Lang, web), Solution),
    Dept \= testing.

% 5. The friend whose favorite language is Java works in the design department.
clue(5, Solution) :-
    member(p(_Name, design, java, _Proj), Solution).

% 6. Carla's project preference is not embedded, and her department is not development.
clue(6, Solution) :-
    member(p('Carla', Dept, _Lang, Proj), Solution),
    Proj \= embedded,
    Dept \= development.

% 7. Dana's favorite language is not Java, and she works in research or testing.
clue(7, Solution) :-
    member(p('Dana', Dept, Lang, _Proj), Solution),
    Lang \= java,
    memberchk(Dept, [research, testing]).

% 8. The friend who prefers data projects works in research and does not use JavaScript.
clue(8, Solution) :-
    member(p(_Name, research, Lang, data), Solution),
    Lang \= javascript.

% =============================================================================
% Task P1.a: Solver and Formatted Output
% =============================================================================

%! solve_clues_1_to_8(-Solution) is nondet.
%  Declarative reading: Solution is a complete four-friend assignment satisfying
%  clues 1 through 8.
solve_clues_1_to_8(Solution) :-
    generate_solution(Solution),
    clue(1, Solution),
    clue(2, Solution),
    clue(3, Solution),
    clue(4, Solution),
    clue(5, Solution),
    clue(6, Solution),
    clue(7, Solution),
    clue(8, Solution).

%! main is det.
%  Declarative reading: Solves clues 1 to 8 and displays the first valid solution
%  in the required format (Alex, Ben, Carla, Dana) without backtracking into
%  subsequent solutions.
main :-
    solve_clues_1_to_8([
        p('Alex',  DA, LA, PA),
        p('Ben',   DB, LB, PB),
        p('Carla', DC, LC, PC),
        p('Dana',  DD, LD, PD)
    ]),
    !,
    format("Alex = [~w, ~w, ~w]~n", [DA, LA, PA]),
    format("Ben = [~w, ~w, ~w]~n", [DB, LB, PB]),
    format("Carla = [~w, ~w, ~w]~n", [DC, LC, PC]),
    format("Dana = [~w, ~w, ~w]~n", [DD, LD, PD]).

% =============================================================================
% Task P1.b: Solution Counter
% =============================================================================

%! satisfies_active_clues(+Active, +Solution) is semidet.
%  Declarative reading: Solution satisfies every clue whose number appears in
%  the Active clue list.
satisfies_active_clues(Active, Solution) :-
    forall(member(C, Active), clue(C, Solution)).

%! count_solutions(+Active, -N) is det.
%  Declarative reading: N is the count of distinct four-friend assignments that
%  satisfy all clues in the Active list and ignore all other clues. Yields N = 0
%  when no assignment satisfies all active clues.
count_solutions(Active, N) :-
    findall(Solution,
            ( generate_solution(Solution),
              satisfies_active_clues(Active, Solution)
            ),
            Solutions),
    length(Solutions, N).
