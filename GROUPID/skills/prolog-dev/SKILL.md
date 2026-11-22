---
name: prolog-dev
description: Conventions, run/test commands, a self-review checklist and known AI failure modes for writing SWI-Prolog 9.x solutions for CS F301 Assignment 2 (P1 logic puzzle in id_q1.pl, P2 arithmetic equations in id_q2.pl). Use for every Prolog predicate, test or review in this repository.
---

# prolog-dev

You are helping a student group write Prolog for CS F301 Assignment 2. The
group must be able to explain every line in a viva, so clear, declarative code
matters more than clever code.

## 1. Scope of one request

- Work on **exactly one unit** per request: one predicate (with its helper
  clauses), one test file, or one review. If a request asks for a whole
  problem ("solve P2", "write id_q1.pl"), do not write it; propose a split
  into units and do only the first one.
- Never hard-code a puzzle answer or an expected output. Results must be derived.
- Never change code outside the unit you were asked about without saying so.

## 2. Language and environment

- **SWI-Prolog 9.x** only. No other Prolog dialect features.
- Allowed libraries: `lists`, `apply`, `yall`, `aggregate`. Load them
  explicitly at the top of the file, for example
  `:- use_module(library(lists)).` Nothing else (**no `clpfd`**, no `dcg/basics`,
  no `strings`, no `readutil`).
- Forbidden everywhere: `assert*/1`, `retract*/1`, `b_setval/2`, `nb_setval/2`,
  `b_getval/2`, `nb_getval/2`, global variables, `halt/0`, and any
  `:- initialization(...)` directive.
- The file holds **only definitions** and `use_module` directives. Loading it
  must print nothing (no warnings either).
- P2 only: never build a string and parse it back (`term_to_atom/2`,
  `term_string/2`, `read_term_from_atom/3`, `atom_to_term/3`, `number_codes/2`
  on an expression, and so on). Evaluate the expression **tree** directly.

## 3. How the grader runs the code

```
swipl -q -f code/GROUPID_q1.pl -g main -t halt
swipl -q -f code/GROUPID_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8],N), print(N), nl" -t halt
swipl -q -f code/GROUPID_q2.pl -g "all_equations([4,2,5,3],Es), print(Es), nl" -t halt
```

Replace `GROUPID` with the real group ID. Run commands from the `GROUPID/` folder.

## 4. Coding conventions

- Predicate names: `snake_case`. Variable names: `CamelCase`, meaningful
  (`Solution`, `LeftExpr`, `Value`), never `X1, X2, X3` unless the role is
  genuinely just "an element".
- Every predicate gets a header comment in this form:

  ```prolog
  %! expr_value(+Expr, -Value) is semidet.
  %  Declarative reading: Value is the integer value of expression tree Expr,
  %  where every division in Expr is exact and has a non-zero divisor.
  ```

  Use the mode markers `+` (bound on entry), `-` (output), `?` (either) and
  a determinism word: `det`, `semidet`, `nondet`, `multi`.
- Write the **declarative reading** ("X holds when ...") for each predicate,
  not a procedural story.
- All clauses of one predicate are contiguous (no `discontiguous` warnings).
  For P1, `clue(1, S)` to `clue(9, S)` sit together in numeric order, each
  preceded by a comment with the English clue.
- `% CLUE 9: <English sentence>` must be on the line **directly above**
  `clue(9, ...)`. Clue 9 must not name any friend; it may only use attribute values.
- No singleton variables: use `_` or `_Name`.
- Prefer pure relations. Use `->` and `!` only where you can explain why, and
  never where a cut would remove solutions that `findall/3` needs.

## 5. Problem-specific facts to keep right

### P1 (id_q1.pl)
- A solution is `[p('Alex',D1,L1,P1), p('Ben',D2,L2,P2), p('Carla',D3,L3,P3), p('Dana',D4,L4,P4)]`.
- Atoms are exactly: `research, development, design, testing`;
  `python, java, 'c++', javascript`; `'AI', web, embedded, data`.
- Generate the whole solution by giving each attribute a permutation of its
  four values (`permutation/2` from `lists`), then test clues on the fully
  bound solution. `clue(N, S)` is only ever called on a fully bound `S`, so
  `\+` inside a clue is safe.
- `count_solutions(Active, N)` checks **only** the clues whose numbers are in
  `Active` (for example with `forall(member(C, Active), clue(C, S))` or
  `maplist`), uses `findall/3` or `aggregate_all(count, ...)`, and gives
  `N = 0` (not failure) when nothing matches.
- `main/0` prints exactly four lines like `Alex = [research, python, AI]`.
  Use `format("~w = [~w, ~w, ~w]~n", [...])`. `~w` prints `c++` and `AI`
  without quotes; `~q` and `print/1` would add quotes, which is wrong here.
  `main` prints one solution only (no backtracking into a second print).

### P2 (id_q2.pl)
- Represent expressions as terms, for example `num(N)`, or `+(A,B)`, `-(A,B)`,
  `*(A,B)`, `/(A,B)` over sub-trees. Never evaluate with `is/2` on a term that
  contains `/`, because `7/2` is `3.5` and `6/2` is `3` in SWI 9.
- Exact division: divisor `D =\= 0`, `X mod D =:= 0`, then `V is X // D`.
  Check this at **every** division node.
- Splits: for a list of length k, the left side takes the first j numbers,
  1 =< j < k (use `append(Left, Right, List)` with both non-empty).
- Lists of length 0 or 1 must make `generate_equation/2` **fail** quickly, not
  loop or throw.
- Printing (canonical form, no spaces): precedence `* /` = 2, `+ -` = 1,
  numbers never in parentheses; left operand in parentheses only if its top
  precedence is **lower** than the parent's; right operand in parentheses if
  its top precedence is **lower or equal**. Check against
  `(4+2)*3, 4+2*3, 8/4*2, 8/(4*2), 1-2-3, 1-(2-3), 1+(2+3), 1+2+3`.
- The result must be an SWI **string**: build it with `format(string(S), ...)`,
  `string_concat/3`, `atomics_to_string/2` or `number_string/2`. Check with
  `string(S)`.
- `all_equations/2`: collect with `findall/3`, then `sort/2` (sorts in
  standard order **and** removes duplicates). Gives `[]` when there are none.
  Do not use `setof/3` or `bagof/3` there: they fail on no solutions.
- `count_equations(List, N)`: length of the `all_equations/2` result.

## 6. Testing

- Tests go in `tests/`, one file per problem: `tests/test_q1.pl`, `tests/test_q2.pl`.
- Tests may use `plunit` (tests are not bound by the library limit; the code
  files are). A test file starts with
  `:- consult('../code/GROUPID_q1.pl').` and holds `:- begin_tests(...).` /
  `:- end_tests(...).` blocks.
- Run: `swipl -q -f tests/test_q1.pl -g run_tests -t halt`
- Always include: every example from the assignment PDF, failure cases
  (`[]`, `[5]`, `[2,3,4]`), a division-by-zero case (for example `[0,0]`,
  `[4,0,0]`), and a check that results are strings.
- Also run the exact grader commands from Section 3 and confirm the output
  matches the required format byte for byte, with nothing printed at load time.

## 7. Self-review checklist (apply before every answer)

1. Does the code use only the allowed libraries and no forbidden predicates?
2. Does loading the file print nothing (no singleton or discontiguous warnings,
   no `initialization`, no `halt`)?
3. Does every predicate have a mode/determinism header and a declarative reading?
4. Are `=`, `==`, `=:=` and `is` each used correctly (unification vs identity
   vs arithmetic comparison vs evaluation)?
5. Is every arithmetic goal called only on bound values?
6. Does any cut or `->` remove solutions that callers (`findall`, `main`) need?
7. Does it terminate on every input, including `[]` and one-element lists?
8. Are results the right type (string vs atom vs code list; quoted atoms like `'c++'`, `'AI'`)?
9. Is anything hard-coded that should be derived?
10. Did I test it, or say clearly which commands the student should run to test it?

## 8. Known failure modes of AI tools in Prolog

- Reaching for `library(clpfd)` (`#=`, `all_different`, `label`) for puzzles.
  **Banned here.**
- Using `is/2` on unbound variables ("Arguments are not sufficiently instantiated").
- Confusing `=`, `==`, `=:=` and `is`; writing `X = Y + 1` and expecting arithmetic.
- Using `/` and getting floats; forgetting the zero-divisor check at inner nodes.
- Putting `\+` or `dif` before variables are bound, so negation means
  something different from what was intended.
- Using `setof/bagof`, which fail on no solutions instead of giving `[]`.
- Using `msort/2` (keeps duplicates) where `sort/2` is required, or vice versa.
- Green cuts that are actually red: a `!` that makes `generate_equation`
  deterministic also breaks `findall` in `all_equations`.
- Left-recursive generators that loop forever, or generators that build
  unbounded trees instead of splitting a finite list.
- Producing atoms or code lists when a string is required; printing with
  `print/1`, `write_canonical/1` or `~q`, which add quotes.
- Adding `:- initialization(main).` or calling `halt.` at the end of the file.
- Hallucinating predicates that do not exist in SWI-Prolog, or using ones from
  libraries outside the allowed list (`string_code/3` is built in and fine;
  `split_string/4` is built in but usually means you are parsing, which P2 forbids).
- Spreading `clue/2` clauses apart, which causes discontiguous warnings at load.
- Hard-coding the puzzle answer, or writing clue 9 that names a friend.
