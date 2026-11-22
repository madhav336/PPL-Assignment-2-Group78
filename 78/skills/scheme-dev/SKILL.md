---
name: scheme-dev
description: Allowed built-ins, conventions, run/test commands, a self-review checklist and known AI failure modes for writing Racket 8.x (#lang racket/base) solutions for CS F301 Assignment 2 (S1 tree traversals in id_q3.rkt, S2 nested insert in id_q4.rkt). Use for every Scheme function, test or review in this repository.
---

# scheme-dev

You are helping a student group write Scheme for CS F301 Assignment 2. The
group must be able to explain every line in a viva, so small, clearly
recursive functions matter more than clever code.

## 1. Scope of one request

- Work on **exactly one unit** per request: one function (with its private
  helpers), one test file, or one review. If a request asks for a whole
  problem ("solve S1", "write id_q4.rkt"), do not write it; propose a split
  into units and do only the first one.
- Never hard-code expected outputs. Never change code outside the unit you
  were asked about without saying so.

## 2. Language and environment

- **Racket 8.x**. Every code file starts with exactly `#lang racket/base`.
- The file holds **only definitions**: no top-level calls, no top-level
  `display`, no `provide`, no `require`, no `module+`. Running
  `racket code/78_q3.rkt` must print **nothing**. The grader appends its
  own calls to the end of the file.

### The whitelist: these are the ONLY identifiers you may use

```
define  lambda  let  let*  letrec  named let  if  cond  else  and  or  not  begin
quote / '   cons  car  cdr  list
c[ad]{2,4}r compositions: cadr cddr caar cdar caddr cdddr cadddr cddddr ...
null?  pair?  eq?  assq  assoc
+  -  *  <  >  <=  >=  =  max
display  newline
read            (S2 only)
```

Everything else from `racket/base` is **forbidden**, including:
`length append reverse map filter member memq memv list-ref list-tail
foldl foldr apply andmap ormap for-each sort build-list
set! set-car! set-cdr! vectors hash tables strings chars do for when unless case
equal? eqv? null empty first rest second last
add1 sub1 zero? list? symbol? number? min abs / quotient remainder modulo
write print printf format error void`.

If you need one of these, write a helper with a `my-` prefix (`my-length`,
`my-map`, `my-reverse`, `my-append`) from whitelisted pieces only. Never
define a function with the same name as a built-in.

Telling atoms from lists without `list?`/`symbol?`/`number?`: in this
assignment a value is a list exactly when `(or (null? v) (pair? v))`
(there are no dotted pairs); anything else is an atom.

## 3. How the grader runs the code

```
racket code/78_q3.rkt        # grader's calls appended to the end
racket code/78_q4.rkt        # S2.a also reads x, lst, n from stdin
```

Our group ID is 78. Run commands from the `78/` folder.

## 4. Coding conventions

- Names: `kebab-case`; predicates end in `?` (`leaf?`); helpers that replace
  banned built-ins start with `my-`.
- Every function gets a comment block like:

  ```racket
  ;; (tree-height tree) -> number
  ;; Recursive reading: the height of () is 0; the height of a node is
  ;; 1 + the larger of the heights of its left and right subtrees.
  ;; Not tail recursive (two recursive calls).
  ```

  State the contract (argument types -> result), the **recursive reading**
  (base case, then recursive case) and whether it is tail recursive.
- Pass all state through arguments. No mutation of any kind.
- Prefer tail recursion where natural: use a named `let` with an accumulator
  for walking a list. Build result lists by `cons`-ing onto an accumulator
  (and reversing once with `my-reverse` if needed), not by repeated
  `my-append` inside a loop.
- Use `let*` (not `let`) when the order of evaluation matters, for example
  three `(read)` calls that must read x, then lst, then n.
- Tree accessors: give names to the parts of a node, for example
  `(define (node-value t) (car t))`, `(define (node-left t) (cadr t))`,
  `(define (node-right t) (caddr t))`.
- Every printing function ends its output with `(newline)`; print lists with
  `display`, which prints `(1 2 3)` and `(b a c)` and `()`.

## 5. Problem-specific facts to keep right

### S1 (id_q3.rkt)
- Tree = `()` or `(value left right)`. Height of `()` is 0. A leaf is a node
  with both subtrees `()`. The empty tree has 0 leaves.
- Visit left before right. Inorder = left, node, right; preorder = node,
  left, right; postorder = left, right, node.
- `print-inorder`: one line. `print-all-traversals`: three lines (inorder,
  preorder, postorder). `print-height-and-leaves`: one line `(height leaves)`.
- Check `()`: prints `()`, three lines of `()`, and `(0 0)`.

### S2 (id_q4.rkt)
- `(insert-if-short x lst n)` puts `x` in front of every list (top level
  included, `()` included) whose **original** top-level length is `< n`, at
  every nesting level.
- Recurse into sublists first, using lengths measured on the original
  lists, then decide whether to `cons` `x` on the front.
- Compute each list's length **once**. Calling `my-length` again at every
  step of the same list is O(n²) and is too slow for 10,000 elements.
- `my-map` must handle 10,000 elements and `insert-if-short` must handle
  nesting depth 100. Racket handles deep non-tail recursion, but test both.
- `(make-inserter x len-ok?)` returns a one-argument function. The final file
  has **one** definition of `insert-if-short`, built on `make-inserter`
  (with a predicate like `(lambda (len) (< len n))`). Commit the S2.b version
  before replacing it, so the history shows both.
- `(print-insert-result)`: three `read`s in order (x, lst, n), then `display`
  the result and `newline`. No prompt text.

## 6. Testing

Because the files may not `provide` anything, test them the way the grader
does: append calls to a copy of the file.

- Test files: `tests/test_q3.rkt`, `tests/test_q4.rkt`. Each holds **only
  calls** (no `#lang` line) and, above each call, the expected output in a
  comment that starts `; expect: `.
- Run (Git Bash), from the `78/` folder:

  ```
  cat code/78_q3.rkt tests/test_q3.rkt > ../run_q3.rkt && racket ../run_q3.rkt > ../out_q3.txt
  grep '^; expect: ' tests/test_q3.rkt | sed 's/^; expect: //' | diff - ../out_q3.txt && echo PASS
  ```

- S2.a reads stdin, so also test it with input piped in:

  ```
  printf '(print-insert-result)\n' | cat code/78_q4.rkt - > ../run_q4_io.rkt
  echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket ../run_q4_io.rkt
  ```

- Always include every example from the assignment PDF plus edge cases:
  the empty tree, a single node, a one-sided tree; for S2 `()` with `n = 0`,
  `n = 0` in general, deep nesting (100 levels) and a 10,000-element list.
- Confirm `racket code/78_q3.rkt` on its own prints nothing.

### Whitelist check

Run this before every commit. It lists lines that use a banned identifier
(it also catches mentions in comments, so read each hit):

```
grep -nE "(^|[[:space:](\'])(length|append|reverse|map|filter|member|memq|memv|list-ref|list-tail|foldl|foldr|apply|andmap|ormap|for-each|sort|build-list|set!|set-car!|set-cdr!|vector[a-z-]*|hash[a-z-]*|string[a-z-]*|do|for|for/[a-z]+|when|unless|case|equal\?|eqv\?|null|empty|empty\?|first|rest|second|last|add1|sub1|zero\?|list\?|symbol\?|number\?|min|abs|/|quotient|remainder|modulo|write|print|printf|format|error|void|provide|require)([[:space:])]|$)" code/*.rkt
```

## 7. Self-review checklist (apply before every answer)

1. Is every identifier in the code on the whitelist (or defined in this file)?
2. Does the file start with `#lang racket/base` and contain only definitions?
3. Does every function have a contract, a recursive reading and a tail-recursion note?
4. Is there any mutation, loop form, string, vector or hash table? (There must not be.)
5. Do base cases cover `()` and single-element inputs?
6. Is the output exactly right: `display` (not `write`), one `newline` per
   line, no extra spaces or text?
7. Are lengths measured on the original list, and only once per list?
8. Will it be fast enough for 10,000 elements and depth 100 (no O(n²) helper inside a loop)?
9. Is anything hard-coded that should be computed?
10. Did I test it, or say clearly which commands the student should run to test it?

## 8. Known failure modes of AI tools in Scheme/Racket

- Using banned built-ins out of habit: `length`, `append`, `map`, `reverse`,
  `filter`, `foldl`, `apply`, `equal?`, `null` / `empty`, `first` / `rest`,
  `add1` / `sub1`, `zero?`, `list?`, `symbol?`, `number?`, `when`, `unless`.
- Writing `#lang racket` instead of `#lang racket/base`, or adding
  `(provide ...)` / `(require ...)`.
- Leaving test calls or debug `display`s at the top level of the code file.
- Using `else` in an `if` (it only belongs in `cond`), or a `cond` with no `else`.
- Using `set!` to keep a counter instead of passing it as an argument.
- Building lists in reverse with an accumulator and forgetting to reverse,
  or reversing twice.
- Quadratic code: `my-append` inside a loop, or recomputing `my-length` at every step.
- Mixing up the order of the `(value left right)` fields (`cadr` is left,
  `caddr` is right).
- Treating an empty sublist `()` as an atom (it is a list of length 0), or
  forgetting that the top-level list counts too.
- Measuring length after inserting `x`, which makes the result wrong.
- Using `let` for the three `read` calls and relying on evaluation order
  instead of making it explicit with `let*`.
- Printing with `write`/`print` or adding a prompt to `print-insert-result`.
- Defining helpers named exactly like built-ins (`length`, `map`), which
  shadows them and confuses readers and graders.
