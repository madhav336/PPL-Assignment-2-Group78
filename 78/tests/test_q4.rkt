;; Tests for S2 (78/code/78_q4.rkt): nested conditional insertion.
;; This file holds calls only (no #lang line) and is appended to a copy of
;; the solution, following the format of test_q3.rkt.

;; ---------------------------------------------------------------------------
;; S2.b1: my-length
;; ---------------------------------------------------------------------------

; expect: 0
(begin
  (display (my-length '()))
  (newline))

; expect: 1
(begin
  (display (my-length '(a)))
  (newline))

; expect: 4
(begin
  (display (my-length '(1 2 3 4)))
  (newline))

; expect: 2
(begin
  (display (my-length '((1 2) (3 4))))
  (newline))

; expect: 4
(begin
  (display (my-length '(a (b c) d ())))
  (newline))

; expect: 10000
(begin
  (display
   (my-length
    (let build ((remaining 10000) (result '()))
      (if (= remaining 0)
          result
          (build (- remaining 1)
                 (cons remaining result))))))
  (newline))

;; ---------------------------------------------------------------------------
;; S2.b2: my-map
;; ---------------------------------------------------------------------------

; expect: ()
(begin
  (display (my-map (lambda (value) (+ value 1)) '()))
  (newline))

; expect: (6)
(begin
  (display (my-map (lambda (value) (+ value 1)) '(5)))
  (newline))

; expect: (2 3 4 5)
(begin
  (display (my-map (lambda (value) (+ value 1)) '(1 2 3 4)))
  (newline))

; expect: (a b c)
(begin
  (display (my-map (lambda (value) value) '(a b c)))
  (newline))

; expect: ((1 2) (3 4) ())
(begin
  (display (my-map (lambda (value) value) '((1 2) (3 4) ())))
  (newline))

; expect: (a (b c) d)
(begin
  (display (my-map (lambda (value) value) '(a (b c) d)))
  (newline))

; expect: (9 8 7 6)
(begin
  (display (my-map (lambda (value) value) '(9 8 7 6)))
  (newline))

; expect: (10000 2)
(let ((mapped-list
       (my-map
        (lambda (value) (+ value 1))
        (let build ((remaining 10000) (result '()))
          (if (= remaining 0)
              result
              (build (- remaining 1)
                     (cons remaining result)))))))
  (display (list (my-length mapped-list) (car mapped-list)))
  (newline))

; expect: 10001
(let ((mapped-list
       (my-map
        (lambda (value) (+ value 1))
        (let build ((remaining 10000) (result '()))
          (if (= remaining 0)
              result
              (build (- remaining 1)
                     (cons remaining result)))))))
  (let find-last ((remaining mapped-list))
    (if (null? (cdr remaining))
        (display (car remaining))
        (find-last (cdr remaining))))
  (newline))

;; ---------------------------------------------------------------------------
;; S2.c1: make-inserter
;; ---------------------------------------------------------------------------

; expect: (x a (x b c) (x))
(begin
  (display ((make-inserter 'x (lambda (size) #t)) '(a (b c) ())))
  (newline))

; expect: (a (b c) ())
(begin
  (display ((make-inserter 'x (lambda (size) #f)) '(a (b c) ())))
  (newline))

; expect: ((42 1 2) (3 4 5) (42 6) (42))
(begin
  (display
   ((make-inserter 42 (lambda (size) (< size 3)))
    '((1 2) (3 4 5) (6) ())))
  (newline))

; expect: ((tag a b) (c) (d e f))
(begin
  (display
   ((make-inserter 'tag (lambda (size) (= size 2)))
    '((a b) (c) (d e f))))
  (newline))

; expect: (7)
(begin
  (display ((make-inserter 7 (lambda (size) (< size 3))) '()))
  (newline))

; expect: (x (x (x)) (x))
(begin
  (display ((make-inserter 'x (lambda (size) #t)) '((()) ())))
  (newline))

;; ---------------------------------------------------------------------------
;; S2.c2: insert-if-short
;; ---------------------------------------------------------------------------

; expect: ((42 1 2) (3 4 5) (42 6) (42))
(begin
  (display (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3))
  (newline))

; expect: ((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
(begin
  (display (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3))
  (newline))

; expect: (7)
(begin
  (display (insert-if-short 7 '() 3))
  (newline))

; expect: ()
(begin
  (display (insert-if-short 7 '() 0))
  (newline))

; expect: (a b c)
(begin
  (display (insert-if-short 'x '(a b c) 3))
  (newline))

; expect: (x a b)
(begin
  (display (insert-if-short 'x '(a b) 3))
  (newline))

; expect: (a ((x b) (x)) (x))
(begin
  (display (insert-if-short 'x '(a ((b) ()) ()) 2))
  (newline))

; expect: ((x (x)) (x))
(begin
  (display (insert-if-short 'x '((()) ()) 2))
  (newline))

; expect: (x a (x b c) d)
(begin
  (display (insert-if-short 'x '(a (b c) d) 4))
  (newline))

; expect: ((()))
(begin
  (display (insert-if-short 'x '((())) 0))
  (newline))

; expect: (10001 x)
(let ((inserted-list
       (insert-if-short
        'x
        (let build ((remaining 10000) (result '()))
          (if (= remaining 0)
              result
              (build (- remaining 1)
                     (cons remaining result))))
        10001)))
  (display (list (my-length inserted-list) (car inserted-list)))
  (newline))

; expect: preserved
(let ((inserted-list
       (insert-if-short
        'x
        (let build ((remaining 10000) (result '()))
          (if (= remaining 0)
              result
              (build (- remaining 1)
                     (cons remaining result))))
        10001)))
  (let ((result-length (my-length inserted-list)))
    (if (and (= result-length 10001)
             (pair? inserted-list)
             (eq? (car inserted-list) 'x))
        (let verify-order ((remaining (cdr inserted-list)) (next-value 1))
          (if (null? remaining)
              (if (= next-value 10001)
                  (display 'preserved)
                  (display 'failed))
              (if (= (car remaining) next-value)
                  (verify-order (cdr remaining) (+ next-value 1))
                  (display 'failed))))
        (display 'failed)))
  (newline))

; expect: pass
(let ((nested-result
       (insert-if-short
        'x
        (let build ((depth 100) (tree '()))
          (if (= depth 0)
              tree
              (build (- depth 1) (list tree))))
        2)))
  (let verify ((current nested-result) (depth 100))
    (if (= depth 0)
        (if (and (pair? current)
                 (eq? (car current) 'x)
                 (null? (cdr current)))
            (display 'pass)
            (display 'fail))
        (if (and (pair? current)
                 (eq? (car current) 'x)
                 (pair? (cdr current))
                 (null? (cddr current)))
            (verify (cadr current) (- depth 1))
            (display 'fail))))
  (newline))

;; ---------------------------------------------------------------------------
;; S2.a: print-insert-result
;; These four calls consume twelve input datums, three per call, in order.
;; ---------------------------------------------------------------------------

; expect: ((42 1 2) (3 4 5) (42 6) (42))
(print-insert-result)

; expect: ((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
(print-insert-result)

; expect: (7)
(print-insert-result)

; expect: ()
(print-insert-result)
