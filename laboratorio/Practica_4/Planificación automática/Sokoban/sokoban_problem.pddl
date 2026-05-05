(define (domain sokoban_problem-domain)
 (:requirements :strips :typing :action-costs)
 (:types
    thing location direction - object
    player stone - thing
 )
 (:predicates 
             (clear ?l - location)
             (at ?t - thing ?l - location)
             (at-goal ?s - stone)
             (is-goal ?l - location)
             (is-nongoal ?l_no - location)
             (move-dir ?l1 - location ?l2 - location ?d - direction)
 )
 (:functions 
             (total-cost)
 )
 (:action move
  :parameters ( ?p - player ?l1 - location ?l2 - location ?d - direction)
  :precondition (and (at ?p ?l1) (move-dir ?l1 ?l2 ?d))
  :effect (and (not (at ?p ?l1)) (at ?p ?l2) (increase (total-cost) 0)))
 (:action push-to-nogoal
  :parameters ( ?p - player ?l1 - location ?s - stone ?l2 - location ?d - direction)
  :precondition (and (at ?p ?l1) (at ?s ?l1) (move-dir ?l1 ?l2 ?d) (clear ?l2) (is-nongoal ?l2) (is-nongoal ?l1))
  :effect (and (not (at ?p ?l1)) (not (at ?s ?l1)) (not (clear ?l2)) (not (at-goal ?s)) (at ?p ?l2) (at ?s ?l2) (increase (total-cost) 1)))
 (:action push-to-goal
  :parameters ( ?p - player ?l1 - location ?s - stone ?l2 - location ?d - direction)
  :precondition (and (at ?p ?l1) (at ?s ?l1) (clear ?l2) (move-dir ?l1 ?l2 ?d) (is-nongoal ?l1) (is-goal ?l2))
  :effect (and (not (at ?p ?l1)) (not (at ?s ?l1)) (not (clear ?l2)) (at ?p ?l2) (at ?s ?l2) (at-goal ?s) (increase (total-cost) 1)))
)
