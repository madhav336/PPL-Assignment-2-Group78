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
