#lang racket/base
;; CS F301 Assignment 2, S1: Binary Tree Traversals
;; A binary tree is either () or a three-element list (value left right),
;; where left and right are binary trees.
;; Only the built-ins allowed by the assignment are used (see skills/scheme-dev).

;; ---------------------------------------------------------------------------
;; Node accessors
;; ---------------------------------------------------------------------------

;; (node-value tree) -> value
;; The value stored at a non-empty node: the first element of (value left right).
(define (node-value tree) (car tree))

;; (node-left tree) -> tree
;; The left subtree of a non-empty node: the second element.
(define (node-left tree) (cadr tree))

;; (node-right tree) -> tree
;; The right subtree of a non-empty node: the third element.
(define (node-right tree) (caddr tree))

;; ---------------------------------------------------------------------------
;; S1.a: inorder traversal
;; ---------------------------------------------------------------------------

;; (inorder-acc tree acc) -> list
;; Returns the inorder values of tree followed by the elements of acc.
;; Recursive reading:
;;   - the inorder of () followed by acc is just acc;
;;   - for a node, first put the right subtree's values in front of acc,
;;     then the node's value in front of that, then the left subtree's
;;     values in front of everything (left, node, right).
;; Building from the right end means no list-joining helper is needed.
;; The call on the left subtree is a tail call; the call on the right
;; subtree is not (its result is needed to build the accumulator).
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (node-left tree)
                   (cons (node-value tree)
                         (inorder-acc (node-right tree) acc)))))

;; (inorder tree) -> list
;; The list of the values of tree in inorder (left subtree, node, right subtree).
(define (inorder tree)
  (inorder-acc tree '()))

;; (print-inorder tree) -> void
;; Prints the inorder list of tree on one line with display, then a newline.
(define (print-inorder tree)
  (begin
    (display (inorder tree))
    (newline)))
