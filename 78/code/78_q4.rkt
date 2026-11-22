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
