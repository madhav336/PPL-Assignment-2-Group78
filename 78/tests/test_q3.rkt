;; Tests for S1 (78/code/78_q3.rkt): binary tree traversals.
;;
;; This file holds calls only (no #lang line). It is never loaded with the
;; solution; it is appended to a copy of it, the way the grader does.
;; Each call is preceded by its expected output, one "; expect: " comment per
;; printed line, in order.
;;
;; Run from the 78/ folder (Git Bash):
;;   cat code/78_q3.rkt tests/test_q3.rkt > ../run_q3.rkt && racket ../run_q3.rkt > ../out_q3.txt
;;   grep '^; expect: ' tests/test_q3.rkt | sed 's/^; expect: //' | diff - ../out_q3.txt && echo PASS

;; ---------------------------------------------------------------------------
;; Test trees
;; ---------------------------------------------------------------------------

;; Supplied examples from the assignment.
(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))

;; Edge cases.
(define t-empty '())
(define t-single '(9 () ()))
(define t-left '(3 (2 (1 () ()) ()) ()))
(define t-right '(a () (b () (c () ()))))
(define t-uneven '(1 (2 () (4 () ())) (3 () ())))

;; ---------------------------------------------------------------------------
;; S1.a: print-inorder
;; ---------------------------------------------------------------------------

; expect: (1 2 3 4 5 6 7)
(print-inorder t1)
; expect: (1 2 3)
(print-inorder t2)
; expect: (b a c)
(print-inorder t3)
; expect: ()
(print-inorder t-empty)
; expect: (9)
(print-inorder t-single)
; expect: (1 2 3)
(print-inorder t-left)
; expect: (a b c)
(print-inorder t-right)
; expect: (2 4 1 3)
(print-inorder t-uneven)

;; ---------------------------------------------------------------------------
;; S1.b: print-all-traversals (inorder, preorder, postorder)
;; ---------------------------------------------------------------------------

; expect: (1 2 3 4 5 6 7)
; expect: (4 2 1 3 6 5 7)
; expect: (1 3 2 5 7 6 4)
(print-all-traversals t1)
; expect: (1 2 3)
; expect: (1 2 3)
; expect: (3 2 1)
(print-all-traversals t2)
; expect: (b a c)
; expect: (a b c)
; expect: (b c a)
(print-all-traversals t3)
; expect: ()
; expect: ()
; expect: ()
(print-all-traversals t-empty)
; expect: (9)
; expect: (9)
; expect: (9)
(print-all-traversals t-single)
; expect: (1 2 3)
; expect: (3 2 1)
; expect: (1 2 3)
(print-all-traversals t-left)
; expect: (a b c)
; expect: (a b c)
; expect: (c b a)
(print-all-traversals t-right)
; expect: (2 4 1 3)
; expect: (1 2 4 3)
; expect: (4 2 3 1)
(print-all-traversals t-uneven)

;; ---------------------------------------------------------------------------
;; S1.c: print-height-and-leaves
;; ---------------------------------------------------------------------------

; expect: (3 4)
(print-height-and-leaves t1)
; expect: (3 1)
(print-height-and-leaves t2)
; expect: (2 2)
(print-height-and-leaves t3)
; expect: (0 0)
(print-height-and-leaves t-empty)
; expect: (1 1)
(print-height-and-leaves t-single)
; expect: (3 1)
(print-height-and-leaves t-left)
; expect: (3 1)
(print-height-and-leaves t-right)
; expect: (3 2)
(print-height-and-leaves t-uneven)
