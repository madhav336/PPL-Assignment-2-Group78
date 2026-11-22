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
