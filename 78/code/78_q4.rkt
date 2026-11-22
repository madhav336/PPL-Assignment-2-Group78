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

;; (insert-if-short x lst n) -> list
;; Applies make-inserter with a predicate that accepts lengths strictly below n
;; to lst, returning the transformed list.
;; Not recursive: make-inserter's returned function performs the traversal.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (list-size) (< list-size n))) lst))

;; (print-insert-result) -> printed output
;; Reads x, lst, and n in that order, displays (insert-if-short x lst n),
;; and ends the result with one newline.
;; Not recursive.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))

;; (make-inserter x len-ok?) -> one-argument function from list to list
;; The returned function processes each list by mapping over its immediate
;; elements, recursively processing nested lists, then prepending x when
;; len-ok? accepts that list's original top-level length.
;; make-inserter itself is not recursive. Its local insert-list is not tail
;; recursive: after processing nested lists, it may still prepend x.
(define (make-inserter x len-ok?)
  (letrec ((insert-list
            (lambda (lst)
              (let* ((original-length (my-length lst))
                     (insert? (len-ok? original-length))
                     (processed-elements
                      (my-map
                       (lambda (element)
                         (if (or (null? element) (pair? element))
                             (insert-list element)
                             element))
                       lst)))
                (if insert?
                    (cons x processed-elements)
                    processed-elements)))))
    (lambda (lst) (insert-list lst))))
