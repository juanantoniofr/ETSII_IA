(define (problem problema_del_transporte_de_paquetes-problem)
 (:domain problema_del_transporte_de_paquetes-domain)
 (:objects
   p - paquete
   l0 l1 l2 l3 - lugar
   c - camion
 )
 (:init
              (conectados l0 l1)
              (conectados l1 l0)
              (conectados l1 l2)
              (conectados l2 l1)
              (conectados l2 l3)
              (conectados l3 l2)
              (conectados l1 l3)
              (conectados l3 l1)
              (camion_en c l0)
              (paquete_en p l1)
 )
 (:goal (and 
           (camion_en c l0)
           (paquete_en p l3)
        )
 )
)
