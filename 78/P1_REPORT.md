# P1 Report: Department Assignment Puzzle Analysis

## 1. Number of Solutions ($N$)

Evaluating the query:
```prolog
?- count_solutions([1, 2, 3, 4, 5, 6, 7, 8], N).
```
yields:
$$\mathbf{N = 3}$$

There are exactly **3 distinct assignments** that satisfy clues 1 through 8 simultaneously out of the $13,824$ total possible combinatorial permutations ($4! \times 4! \times 4!$).

---

## 2. The Three Valid Solutions

The three solutions derived from clues 1 to 8 are:

### Solution 1 (Kept by `main/0`):
* **Alex:** `[design, java, AI]`
* **Ben:** `[development, javascript, web]`
* **Carla:** `[research, c++, data]`
* **Dana:** `[testing, python, embedded]`

### Solution 2:
* **Alex:** `[design, java, embedded]`
* **Ben:** `[development, javascript, web]`
* **Carla:** `[testing, python, AI]`
* **Dana:** `[research, c++, data]`

### Solution 3:
* **Alex:** `[testing, python, embedded]`
* **Ben:** `[development, javascript, web]`
* **Carla:** `[design, java, AI]`
* **Dana:** `[research, c++, data]`

---

## 3. What $N = 3$ Tells Us About the Puzzle

1. **The Puzzle is Under-Constrained:**
   In standard logic grid puzzles, a well-formed clue set must narrow the search space down to a unique model ($N = 1$). A count of $N = 3$ demonstrates that clues 1 through 8 leave degrees of freedom unconstrained.

2. **Invariance of Ben's Assignment:**
   Across all three solutions, Ben's department, programming language, and project are uniquely and deterministically fixed:
   * **Ben** is always assigned to `[development, javascript, web]`.

3. **Permutational Ambiguity Among Alex, Carla, and Dana:**
   The ambiguity is localized entirely to the remaining three friends:
   * The bundle `[research, c++, data]` is assigned to **Carla** in Solution 1, but shifts to **Dana** in Solutions 2 and 3.
   * In Solution 1, **Alex** takes the `AI` project with `[design, java]`, while in Solutions 2 and 3, `AI` shifts to **Carla**.
   * In Solution 1, **Dana** works in `testing` with `[python, embedded]`, whereas in Solution 2 Carla works in `testing` with `[python, AI]`, and in Solution 3 Alex works in `testing` with `[python, embedded]`.

4. **Necessity and Design of Clue 9 (Task P1.c):**
   Because $N = 3$, an additional constraint is mathematically necessary to isolate a single true solution ($N = 1$). Crucially, Clue 9 **must keep Solution 2**, rather than Solution 1 or Solution 3:
   * **Why Solutions 1 and 3 cannot be separated by an attribute clue:** Solutions 1 and 3 contain the exact same four person-attribute tuples: `{ (design, java, AI), (development, javascript, web), (research, c++, data), (testing, python, embedded) }`. They differ solely by permutation of friend names. Since Task P1.c strictly forbids naming any friend and requires referring to friends only through attribute values (as Clue 5 does), no valid attribute-only clue can be true for Solution 1 while being false for Solution 3.
   * **Why Solution 2 is uniquely suited:** Solution 2 features a unique attribute pairing—the friend whose favorite language is `java` works on the `embedded` project (`member(p(_, _, java, embedded), Solution)`). In both Solutions 1 and 3, the friend who prefers `java` works on `AI` $\neq$ `embedded`. Thus, Clue 9 (`% CLUE 9: The friend whose favorite language is Java works on the embedded project.`) is true for Solution 2 and false for both Solutions 1 and 3, reducing the solution count to exactly $N = 1$.
