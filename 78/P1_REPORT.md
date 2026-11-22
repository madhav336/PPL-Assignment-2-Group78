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

4. **Necessity of Clue 9 (Task P1.c):**
   Because $N = 3$, an additional constraint is mathematically necessary to isolate a single true solution. To achieve $N = 1$ in Task P1.c, Clue 9 must be carefully constructed to be **true** for the desired solution (Solution 1) and **false** for Solutions 2 and 3, without referencing any friend by name.
