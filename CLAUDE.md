# CLAUDE.md: shared rules for CS F301 Assignment 2

This file is the single source of truth for **every** group member and **every**
AI session working in this repo. Claude Code loads it automatically. If you use
another AI tool, paste this file in first. If anything here conflicts with the
handout `PPL_Assignment_2_Final.pdf`, the handout wins; tell the group and fix
this file.

The rules for teammates driving the AI (ownership, the unit workflow, prompt
logging, commits, what not to touch) are in `TEAM_GUIDE.md`, imported here:
@TEAM_GUIDE.md

---

## 1. Rules for the AI (all sessions, all teammates)

1. **Only write code, tests and docs.** Never run `git add`, `git commit`,
   `git push`, or change remotes or branches. At the end of each unit, give the
   teammate ready-to-run commands (Section 4) so they commit from **their own**
   GitHub account.
2. **No AI attribution anywhere:** no `Co-Authored-By` lines, and no "generated
   by AI" text in commits, code or files.
3. **One unit per prompt.** A unit is one function or predicate (with its
   private helpers), one test file, or one review. If a prompt asks for a whole
   problem ("do S2", "finish P1", "do the rest"), do not write it: name the next
   unit from the plan (Section 6), do only that one, and say so.
4. **Read the matching skill file before writing code and follow it exactly:**
   `78/skills/prolog-dev/SKILL.md` for P1/P2 and
   `78/skills/scheme-dev/SKILL.md` for S1/S2.
5. **Don't change other people's finished units** unless the prompt asks.
   Mention any problem you notice instead of fixing it silently.
6. **Before starting, check progress:** `git log --oneline` and the matching
   `78/prompts/*.md` show which units are done.
7. **Explain each unit** so the teammate can defend it in the viva: the
   declarative or recursive reading, tail calls, and edge cases. Prefer clear
   code over clever code.
8. **Test every unit before saying it's done** (Section 5) and show the output.
9. **Never hard-code** a puzzle answer or an expected output.

---

## 2. What the assignment actually requires

### Ground rules
- Group work only. Sharing code, prompts or skill files with another group is
  an integrity violation.
- **Deadline: 22 Nov 2026, 24:00.** Late submissions are not accepted.
- Decomposition rule: one prompt = one unit of work. **The commit history must
  show the work done section by section.**
- **Environment:** SWI-Prolog 9.x (we use 9.2.9) and Racket 8.x (we use 8.18,
  `#lang racket/base`).
- **Group ID: 78.** Files:
  `78_q1.pl`, `78_q2.pl`, `78_q3.rkt`, `78_q4.rkt`.
- **Files contain only definitions.** Loading one prints nothing. Prolog: no
  `halt`, no `:- initialization`. Racket: starts with `#lang racket/base`, no
  top-level calls, no `provide` or `require`. The grader appends its own calls.
- **The grader runs:**
  - `swipl -q -f 78_q1.pl -g main -t halt`
  - `swipl -q -f 78_q1.pl -g "<goal>" -t halt`
  - `racket 78_q3.rkt` and `racket 78_q4.rkt`

### Prolog constraints (P1, P2)
- No `assert`, `retract`, `b_setval` or `nb_setval`, and no global variables.
- Libraries: **only** `lists`, `apply`, `yall`, `aggregate` (no `clpfd`).
- Print nothing beyond what is specified.

### Scheme constraints (S1, S2)
- Allowed **only**: define, lambda, let, let*, letrec, named let, if, cond
  (with else), and, or, not, begin, quote ('), cons, car, cdr, list, car/cdr
  compositions up to four levels (cadr, caddr, cdddr, cadddr, ...), null?,
  pair?, eq?, assq, assoc, + - * < > <= >= =, max, display, newline. S2 also
  allows `read`.
- Everything else is banned, for example: set!, vectors, hash tables, strings,
  do, for, length, append, reverse, map, filter, member, memq, list-ref,
  list-tail, equal?, list?, add1, null, first/rest, when/unless. Write `my-`
  helpers instead.

### P1: puzzle (`78_q1.pl`, 3 marks)
- A solution is a list of `p(Name, Dept, Lang, Project)` in the order
  `'Alex'`, `'Ben'`, `'Carla'`, `'Dana'`. The values are exactly: `research`,
  `development`, `design`, `testing`; `python`, `java`, `'c++'`, `javascript`;
  `'AI'`, `web`, `embedded`, `data`. Each value is used exactly once.
- Each clue is its own clause `clue(N, Solution)`, true when clue N holds in a
  fully filled-in solution.
- **P1.a:** `main/0` derives one solution from clues 1 to 8 (not hard-coded)
  and prints exactly four lines like `Alex = [research, python, AI]`.
- **P1.b:** `count_solutions(Active, N)` counts solutions that satisfy exactly
  the clues in `Active`, ignoring the rest, using `findall/3` or
  `aggregate_all/3`. Report N for clues 1 to 8, and what it says about the
  puzzle, in `P1_REPORT.md`.
- **P1.c:** `clue(9, S)` makes `count_solutions([1,...,9], N)` give `N = 1`.
  The comment `% CLUE 9: <English sentence>` goes on the line directly above
  it. It must not name a friend; it may refer to friends only through
  attribute values. It must be true in the kept solution and false in every
  other solution of clues 1 to 8.

### P2: equations (`78_q2.pl`, 3 marks)
- Insert `+ - * /` and exactly one `=` between the numbers, using every number
  once and in order, with optional parentheses. No unary minus and no joining
  digits. Sub-expression values may be negative.
- Division only when exact and the divisor is not 0, at **every** division.
- Output is an SWI **string** with no spaces. Canonical parentheses: `* /`
  bind tighter than `+ -`, operators are left-associative, a left operand is
  parenthesized only if its precedence is lower than the parent's, a right
  operand if it is lower or equal, and numbers never are.
- `generate_equation(List, E)` gives one valid equation; it **fails** (no loop,
  no error) if none exists, including for length 0 or 1.
- `all_equations(List, Es)` gives all equations, without duplicates, sorted
  with `sort/2`, or `[]`. `count_equations(List, N)` gives its length.
- Never build a string and parse it back into a term.
- Examples: `[4,2,5,3]` gives
  `["4*2-5=3","4*2=5+3","4-2=5-3","4/2=5-3","4=2*(5-3)","4=2+(5-3)","4=2+5-3"]`.
  `[2,3,4]` gives `[]`. `[2,4,8]` gives `["2*4=8"]`.

### S1: tree traversals (`78_q3.rkt`, 3 marks)
- A tree is `()` or `(value left right)`. Height of `()` is 0. A leaf has both
  subtrees `()`. Visit left before right.
- `(print-inorder t)` prints one line. `(print-all-traversals t)` prints three
  lines: inorder, preorder, postorder. `(print-height-and-leaves t)` prints
  `(height leaf-count)`. Every function ends with a newline.
- Pass all state through arguments. Prefer tail recursion where natural.
- Expected output (from the PDF):
  - t1 = `(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ())))`:
    `(1 2 3 4 5 6 7)`, `(4 2 1 3 6 5 7)`, `(1 3 2 5 7 6 4)`, `(3 4)`
  - t2 = `(1 () (2 () (3 () ())))`: `(1 2 3)`, `(1 2 3)`, `(3 2 1)`, `(3 1)`
  - t3 = `(a (b () ()) (c () ()))`: `(b a c)`, `(a b c)`, `(b c a)`, `(2 2)`
  - `()`: `()` on every traversal line, and `(0 0)`

### S2: conditional insert (`78_q4.rkt`, 3 marks)
- `(insert-if-short x lst n)` puts x at the front of every list, at every
  level, whose **original** top-level length is `< n`. The top-level list
  counts, and `()` (length 0) becomes `(x)` when `0 < n`.
- **S2.a:** `(print-insert-result)` reads x, lst and n with `read` in that
  order, then displays the result and a newline, with no prompt.
- **S2.b:** write your own `my-length` and `my-map`, and define
  `insert-if-short` with them.
- **S2.c:** `(make-inserter x len-ok?)` returns a one-argument function that
  inserts x into every list whose length satisfies `len-ok?`. The **final file
  has a single** `insert-if-short`, defined using `make-inserter`.
- Examples (stdin, then output):
  - `42 ((1 2) (3 4 5) (6) ()) 3` gives `((42 1 2) (3 4 5) (42 6) (42))`
  - `0 (((1) 2) (3) ((4 5 6) ())) 3` gives `((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))`
  - `7 () 3` gives `(7)`, and `7 () 0` gives `()`
- Hidden tests use nesting depth 100 and lists of 10,000 elements.

### Deliverables (one GitHub repo, no zip, history preserved)
```
78/
  code/      78_q1.pl 78_q2.pl 78_q3.rkt 78_q4.rkt
  tests/     one test file per problem (the PDF examples + own edge cases)
  skills/    prolog-dev/SKILL.md scheme-dev/SKILL.md
  prompts/   P1.md P2.md S1.md S2.md (prompts word for word)
  P1_REPORT.md
```

### Marks (total 20)
P1 3 · P2 3 · S1 3 · S2 3 · group git/process (structure, skills, prompts,
tests) 2 · **individual commits 2** · **individual viva 4**.

---

## 3. Prompt logging (everyone, identical format)

1. Write the prompt in `78/prompts/<P1|P2|S1|S2>.md` **first**, then copy
   it from there into the AI, so the log is exact.
2. Use this format, numbering prompts in order within each file:

   ````markdown
   ## Prompt N (unit: S1.b, sent by: <teammate name>)

   ```
   <exact prompt text, unedited, typos included>
   ```

   > Note (group): <optional explanation, clearly separate from the prompt>
   ````

3. Follow-up and fix prompts are logged too, for example
   `(unit: S1.b fix, sent by: ...)`.
4. Never edit a prompt after it was sent. Explanations go only in a `> Note (group):` line.

Prompt template (fill in for each unit):
```
Using the <prolog-dev | scheme-dev> skill.
Unit: <ID> - <what, in one line>
File: code/78_qN.<pl|rkt>. Only add/change: <names>. Don't touch: <other units>.
Spec: <the rule(s) from the PDF this unit must meet>
Constraints: <the bans/format rules that matter here>
Explain: <declarative/recursive reading, tail calls, edge cases>
Check: run <examples / edge cases> and show the output.
```

---

## 4. Commits (everyone, identical format)

- **One unit = one commit**, containing the code change **and** its prompt log
  entry. Commit from your own account (check `git config user.name`).
- Message format: `<unit>: <what changed>`, in the imperative, with no AI
  attribution. Examples:
  - `S1.b: add preorder/postorder and print-all-traversals`
  - `P2: add canonical expression printer`
  - `S2 tests: add depth-100 and 10k-element cases`
- The AI ends each unit with commands like:
  ```
  git add 78/code/78_q3.rkt 78/prompts/S1.md
  git commit -m "S1.b: add preorder/postorder and print-all-traversals"
  ```
- Pull before you start (`git pull`) and push after you commit, so teammates
  don't edit the same file at once. **One person per code file at a time.**

---

## 5. Uniform code, test and check conventions

- **Prolog:** `snake_case` predicates and `CamelCase` variables. Every
  predicate gets a `%! name(+In, -Out) is det|semidet|nondet.` header plus a
  declarative reading. Clauses of one predicate stay contiguous. No warnings
  on load.
- **Scheme:** `kebab-case`, `?` for predicates, `my-` for replacements of
  banned built-ins. Every function gets a comment with its contract
  (`;; (f args) -> result`), its recursive reading, and whether it is tail
  recursive.
- **Test files:** `78/tests/test_q1.pl`, `test_q2.pl` (plunit, consulting
  `../code/78_qN.pl`), `test_q3.rkt`, `test_q4.rkt` (calls only, no
  `#lang`, with expected output in `; expect: ` comments). The skill files
  give the exact run commands.
- **Before every commit:**
  1. Loading the file prints nothing (`racket code/78_q3.rkt`, or
     `swipl -q -f code/78_q1.pl -t halt`).
  2. The unit's PDF examples pass.
  3. For Scheme, run the whitelist grep from `scheme-dev/SKILL.md`; it should
     only match words in comments.

---

## 6. Unit plan (shared; tick units off through commits and prompt logs)

- **S1:** S1.a inorder + `print-inorder` → S1.b preorder/postorder +
  `print-all-traversals` → S1.c height → S1.c leaf count +
  `print-height-and-leaves` → tests → review
- **S2:** `my-length` → `my-map` → S2.b `insert-if-short` → S2.a
  `print-insert-result` → S2.c `make-inserter` → redefine `insert-if-short`
  with it (commit the S2.b version first) → tests (depth 100, 10,000 elements)
  → review
- **P1:** solution generator (permutations) → clues 1–4 → clues 5–8 →
  `main/0` → `count_solutions/2` → **group** writes `P1_REPORT.md` → list the
  solutions so the **group** can design clue 9 → add `clue(9, …)` → tests →
  review
- **P2:** list splitting → expression tree generator → evaluator (exact
  division) → canonical printer → `generate_equation/2` → `all_equations/2`
  + `count_equations/2` → tests → review

Units marked **group** are the group's own reasoning; the AI may help check
it but should not decide it. These are likely viva questions.

---

## 7. Before submission
- Everything uses group ID `78`: the `78/` folder and `78_q1.pl` ... `78_q4.rkt`.
- Every prompt file is complete and in order; every unit has its own commit.
- Every teammate has meaningful commits under their own account.
- Fresh clone check: run each grader command; loading prints nothing; all tests pass.
