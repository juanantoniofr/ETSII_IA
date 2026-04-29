(define (domain problema_del_transporte_de_paquetes-domain)
 (:requirements :strips :typing)
 (:types
    paquete localizacion - object
    lugar camion - localizacion
 )
 (:predicates 
             (conectados ?l1 - lugar ?l2 - lugar)
             (camion_en ?c - camion ?l - lugar)
             (paquete_en ?p - paquete ?lc - localizacion)
 )
 (:action ir
  :parameters ( ?c - camion ?l1 - lugar ?l2 - lugar)
  :precondition (and (conectados ?l1 ?l2) (camion_en ?c ?l1))
  :effect (and (not (camion_en ?c ?l1)) (camion_en ?c ?l2)))
 (:action cargar
  :parameters ( ?p - paquete ?c - camion ?l - lugar)
  :precondition (and (camion_en ?c ?l) (paquete_en ?p ?l))
  :effect (and (not (paquete_en ?p ?l)) (paquete_en ?p ?c)))
 (:action descargar
  :parameters ( ?p - paquete ?c - camion ?l - lugar)
  :precondition (and (camion_en ?c ?l) (paquete_en ?p ?c))
  :effect (and (not (paquete_en ?p ?c)) (paquete_en ?p ?l)))
)
