#lang racket/base
;; CS F301 Assignment 2, S2: Conditional Insert

;; (my-length lst) -> number
;; Recursive reading: the length of () is 0; for a non-empty list, count its
;; first element once and continue with the rest of the list. Since each step
;; follows only cdr, nested lists count as single top-level elements.
;; Tail recursive: the recursive call is the final operation, carrying the
;; updated count as an accumulator.
(define (my-length lst)
  (let walk ((remaining lst) (count 0))
    (if (null? remaining)
        count
        (walk (cdr remaining) (+ count 1)))))

;; (my-map f lst) -> list
;; Recursive reading: the mapped result of () is (); for a non-empty list,
;; apply f to its first element and map the rest, preserving the element order.
;; The local walk builds mapped elements in reverse order, then a second local
;; walk restores the original order. Nested lists are passed to f as elements.
;; Tail recursive: both local walks make their recursive calls in tail position.
(define (my-map f lst)
  (let walk ((remaining lst) (mapped-reversed '()))
    (if (null? remaining)
        (let restore ((remaining-mapped mapped-reversed) (result '()))
          (if (null? remaining-mapped)
              result
              (restore (cdr remaining-mapped)
                       (cons (car remaining-mapped) result))))
        (walk (cdr remaining)
              (cons (f (car remaining)) mapped-reversed)))))
