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
;; Not recursive.
(define (node-value tree) (car tree))

;; (node-left tree) -> tree
;; The left subtree of a non-empty node: the second element.
;; Not recursive.
(define (node-left tree) (cadr tree))

;; (node-right tree) -> tree
;; The right subtree of a non-empty node: the third element.
;; Not recursive.
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
;; Not recursive: it delegates the whole traversal to inorder-acc, starting
;; with an empty accumulator. That single call is a tail call.
(define (inorder tree)
  (inorder-acc tree '()))

;; (print-inorder tree) -> void
;; Prints the inorder list of tree on one line with display, then a newline.
;; Not recursive.
(define (print-inorder tree)
  (begin
    (display (inorder tree))
    (newline)))

;; ---------------------------------------------------------------------------
;; S1.b: preorder, postorder and all three traversals
;; ---------------------------------------------------------------------------

;; (preorder tree) -> list
;; The list of the values of tree in preorder (node, left subtree, right subtree).
;; The work is done by the local procedure walk, defined with a named let:
;; (walk t acc) returns the preorder values of t followed by the elements of acc.
;; Recursive reading of walk:
;;   - the preorder of () followed by acc is just acc;
;;   - for a node, first put the right subtree's values in front of acc,
;;     then the left subtree's values in front of that, then the node's
;;     value in front of everything (node, left, right).
;; Tail recursion: preorder itself is not recursive; it starts walk with an
;; empty accumulator. Inside walk, neither recursive call is a tail call:
;; the left call's result is still passed to cons, and the right call is an
;; argument of the left call. Because the node comes first, its cons is always
;; the last step, so a tail call here would need an explicit stack and a
;; final reverse, which is not natural for this traversal.
(define (preorder tree)
  (let walk ((t tree) (acc '()))
    (if (null? t)
        acc
        (cons (node-value t)
              (walk (node-left t)
                    (walk (node-right t) acc))))))

;; (postorder tree) -> list
;; The list of the values of tree in postorder (left subtree, right subtree, node).
;; The work is done by the local procedure walk, defined with a named let:
;; (walk t acc) returns the postorder values of t followed by the elements of acc.
;; Recursive reading of walk:
;;   - the postorder of () followed by acc is just acc;
;;   - for a node, first put the node's value in front of acc, then the
;;     right subtree's values in front of that, then the left subtree's
;;     values in front of everything (left, right, node).
;; Tail recursion: postorder itself is not recursive; it starts walk with an
;; empty accumulator. Inside walk, the call on the left subtree is a tail call
;; (its result is returned directly); the call on the right subtree is not
;; (its result is still needed as the left call's accumulator).
(define (postorder tree)
  (let walk ((t tree) (acc '()))
    (if (null? t)
        acc
        (walk (node-left t)
              (walk (node-right t)
                    (cons (node-value t) acc))))))

;; (print-all-traversals tree) -> void
;; Prints three lines with display, each followed by a newline: the inorder,
;; preorder and postorder lists of tree, in that order. The first line reuses
;; print-inorder from S1.a.
;; Not recursive.
(define (print-all-traversals tree)
  (begin
    (print-inorder tree)
    (display (preorder tree))
    (newline)
    (display (postorder tree))
    (newline)))
