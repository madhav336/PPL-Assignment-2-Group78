# CS F301 Principles of Programming Languages: Assignment 2 (Group 78)

Logic and Functional Programming: two Prolog problems (P1, P2) and two Scheme
problems (S1, S2).

## Group members

| Member | GitHub | Problem owned |
|---|---|---|
| Madhav | `madhav336` | S1: binary tree traversals; repo setup, skill files, team docs |
| Pranav | `pranny-coder` | P1: department assignment puzzle |
| Vedesh | `vedeshshinde` | P2: arithmetic equations |
| Jenil | `kj25` | S2: conditional insert into a nested list |

## Repository layout

```
78/
├── code/       78_q1.pl  78_q2.pl  78_q3.rkt  78_q4.rkt   solutions
├── tests/      test_q1.pl test_q2.pl test_q3.rkt test_q4.rkt   one test file per problem
├── skills/     prolog-dev/SKILL.md  scheme-dev/SKILL.md     AI skill files
├── prompts/    P1.md  P2.md  S1.md  S2.md                   prompts, word for word
└── P1_REPORT.md                                             solution count and clue 9 analysis
CLAUDE.md       assignment requirements and rules for AI sessions
TEAM_GUIDE.md   team workflow: ownership, unit-by-unit prompts, logging and commits
```

## Environment

- SWI-Prolog 9.2.9
- Racket 8.18; the Scheme files use `#lang racket/base` and only the built-ins
  allowed by the handout

## Running the solutions

Run from the `78/code/` folder. The code files contain definitions only, so
loading a file prints nothing.

```
swipl -q -f 78_q1.pl -g main -t halt
swipl -q -f 78_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9],N), print(N), nl" -t halt
swipl -q -f 78_q2.pl -g "all_equations([4,2,5,3],Es), print(Es), nl" -t halt
racket 78_q3.rkt      # the grader appends its calls, e.g. (print-all-traversals t1)
racket 78_q4.rkt      # the grader appends its calls, e.g. (print-insert-result)
```

## Running the tests

Run from the `78/` folder.

**Prolog (plunit):**
```
cd tests
swipl -q -f test_q1.pl -g run_tests -t halt
swipl -q -f test_q2.pl -g run_tests -t halt
```

**Scheme (Git Bash):** each test file holds calls only, with the expected
output in `; expect:` comments. The file is appended to a copy of the
solution, the way the grader runs it, and the output is compared:
```
cat code/78_q3.rkt tests/test_q3.rkt > ../run_q3.rkt && racket ../run_q3.rkt > ../out_q3.txt
grep '^; expect: ' tests/test_q3.rkt | sed 's/^; expect: //' | diff - ../out_q3.txt && echo PASS

cat code/78_q4.rkt tests/test_q4.rkt > ../run_q4.rkt
printf '42 ((1 2) (3 4 5) (6) ()) 3\n0 (((1) 2) (3) ((4 5 6) ())) 3\n7 () 3\n7 () 0\n' | racket ../run_q4.rkt > ../out_q4.txt
grep '^; expect: ' tests/test_q4.rkt | sed 's/^; expect: //' | diff - ../out_q4.txt && echo PASS
```
The S2 tests end with four `print-insert-result` calls, which read the 12
input values above from standard input. Delete `run_*.rkt` and `out_*.txt`
afterwards; they are not part of the submission.

## Status

| Problem | Result | Tests | Final review |
|---|---|---|---|
| S1 binary tree traversals | all handout examples match | 40/40 | PASS |
| S2 conditional insert | all handout examples match, including stdin | 38/38 | done |
| P1 department puzzle | `main` prints a solution; N = 3 for clues 1–8, N = 1 with clue 9 | 8/8 | PASS |
| P2 arithmetic equations | all handout examples match | 18/18 | PASS |

**P1 result:** clues 1–8 allow 3 solutions. Clue 9 ("The friend whose favorite
language is Java works on the embedded project.") keeps exactly one. The
reasoning is in [`78/P1_REPORT.md`](78/P1_REPORT.md).

## How we worked

- Generative AI tools were used, as the handout allows. Each prompt covered
  one unit of work (one function or predicate, one test file, one review or
  one fix).
- Every prompt is logged word for word in `78/prompts/`, numbered in the order
  sent, with the unit, the sender, and a note on the result.
- Every unit is its own commit, made by the teammate who did it. The commit
  history therefore shows the work section by section and who did each part.
- The skill files in `78/skills/` set the conventions the AI followed: language
  version, allowed built-ins, comment style, how to test, a self-review
  checklist and known AI failure modes.
- Shared rules for the group and its AI sessions are in
  [`CLAUDE.md`](CLAUDE.md) and [`TEAM_GUIDE.md`](TEAM_GUIDE.md).
