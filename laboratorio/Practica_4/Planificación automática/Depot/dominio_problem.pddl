(define (domain depot-domain)
 (:requirements :strips :typing)
 (:types
    place locatable - object
    truck hoist surface - locatable
    pallet crate - surface
    depot distributor - place
 )
 (:predicates 
             (at ?x - locatable ?y - place)
             (on ?x_0 - crate ?y_0 - surface)
             (in ?x_0 - crate ?y_1 - truck)
             (lifting ?x_1 - hoist ?y_2 - crate)
             (available ?x_1 - hoist)
             (clear ?x_2 - surface)
 )
 (:action drive
  :parameters ( ?x_3 - truck ?y - place ?z - place)
  :precondition (and (at ?x_3 ?y))
  :effect (and (not (at ?x_3 ?y)) (at ?x_3 ?z)))
 (:action lift
  :parameters ( ?x_1 - hoist ?y_2 - crate ?z_0 - surface ?p - place)
  :precondition (and (available ?x_1) (on ?y_2 ?z_0) (at ?z_0 ?p))
  :effect (and (not (on ?y_2 ?z_0)) (not (available ?x_1)) (lifting ?x_1 ?y_2)))
 (:action drop
  :parameters ( ?x_1 - hoist ?y_2 - crate ?z_0 - surface ?p - place)
  :precondition (and (lifting ?x_1 ?y_2) (at ?x_1 ?p) (at ?z_0 ?p))
  :effect (and (not (lifting ?x_1 ?y_2)) (available ?x_1) (on ?y_2 ?z_0)))
 (:action load
  :parameters ( ?x_1 - hoist ?y_2 - crate ?z_1 - truck ?p - place)
  :precondition (and (lifting ?x_1 ?y_2) (at ?x_1 ?p) (at ?z_1 ?p))
  :effect (and (not (lifting ?x_1 ?y_2)) (available ?x_1) (in ?y_2 ?z_1)))
 (:action unload
  :parameters ( ?x_1 - hoist ?y_2 - crate ?z_1 - truck ?p - place)
  :precondition (and (available ?x_1) (in ?y_2 ?z_1) (at ?z_1 ?p) (at ?x_1 ?p))
  :effect (and (not (available ?x_1)) (not (in ?y_2 ?z_1)) (at ?y_2 ?p)))
)
