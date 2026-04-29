**Ejercicio 3**

Consideremos un dominio de planificación automática consistente en un conjunto de satélites que se pretenden usar para, con unos instrumentos a bordo de esos satélites, tomar una serie de distintos tipos de fotografías de ciertos fenómenos galácticos. En este dominio los hechos se especifican a partir de los siguientes predicados:

- `SON_DISTINTOS(O1, O2)`: representa que los objetos $o_1$ y $o_2$ son distintos.
- `APUNTA_A(s, o)`: representa que el satélite $s$ está orientado hacia el objeto $o$.
- `A_BORDO(i, s)`: representa que el instrumento $i$ se encuentra a bordo del satélite $s$.
- `NO_CALIBRADO(i)`: representa que el instrumento $i$ no está calibrado.
- `CALIBRADO(i)`: representa que el instrumento $i$ está calibrado.
- `OBJETIVO_CALIBRACIÓN(i, o)`: representa que el objeto $o$ se usa para calibrar el instrumento $i$.
- `COMPATIBLE_CON(i, t)`: representa que el instrumento $i$ puede tomar imágenes de tipo $t$.
- `HAY_ENERGÍA(s)`: representa que el satélite $s$ dispone de energía para encender un instrumento.
- `ENCENDIDO(i)`: representa que el instrumento $i$ está encendido.
- `SIN_IMAGEN(o, t)`: representa que no se tiene una imagen de tipo $t$ del objeto $o$.
- `CON_IMAGEN(o, t)`: representa que se tiene una imagen de tipo $t$ del objeto $o$.

**Se pide:**

**1. Representar en el formalismo STRIPS los siguientes esquemas de acciones:**

- `GIRAR_HACIA(s, o1, o2)`: representa que el satélite $s$ pasa de apuntar hacia el objeto $o_1$ a apuntar hacia el objeto $o_2$.
  - _precondiciones:_ SON_DISTINTOS(o1, o2), APUNTA_A(s, o1)
  - _lista de borrado:_ APUNTA_A(s, o1)
  - _lista de adición:_ APUNTA_A(s, o2)

---

- `ENCENDER(i, s)`: representa que se enciende el instrumento $i$ a bordo del satélite $s$. Para ello el satélite debe tener energía disponible, ya que en cada satélite no puede estar encendido más de un instrumento a la vez.
  - _precondiciones:_ HAY_ENERGÍA(s), A_BORDO(i, s)
  - _lista de borrado:_ HAY_ENERGÍA(s)
  - _lista de adición:_ ENCENDIDO(i)

---

- `APAGAR(i, s)`: representa que se apaga el instrumento $i$ a bordo del satélite $s$, volviendo a haber energía disponible en ese satélite para poder encender otro instrumento. Los instrumentos dejan de estar calibrados cuando se apagan.
  - _precondiciones:_ ENCENDIDO(i), A_BORDO(i, s)
  - _lista de borrado:_ ENCENDIDO(i), CALIBRADO(i)
  - _lista de adición:_ HAY_ENERGÍA(s), NO_CALIBRADO(i)

---

- `CALIBRAR(i, s, o)`: representa que se calibra el instrumento $i$ a bordo del satélite $s$ con el objetivo de calibración $o$ del instrumento. Para ello, el satélite debe apuntar hacia ese objetivo y el instrumento debe estar encendido.
  - _precondiciones:_ NO_CALIBRADO(i), A_BORDO(i, s), ENCENDIDO(i), APUNTA_A(s, o), OBJETIVO_CALIBRACIÓN(i, o)
  - _lista de borrado:_ NO_CALIBRADO(i)
  - _lista de adición:_ CALIBRADO(i)

---

- `TOMAR_IMAGEN(i, s, o, t)`: representa que con el instrumento $i$ a bordo del satélite $s$ se toma una imagen de tipo $t$ del objeto $o$. Para ello, el satélite debe apuntar hacia ese objeto y el instrumento debe estar encendido y calibrado y debe poder tomar imágenes de ese tipo.
  - _precondiciones:_ A_BORDO(i, s), COMPATIBLE_CON(i, t), CALIBRADO(i), APUNTA_A(s, o), ENCENDIDO(i), SIN_IMAGEN(o, t)
  - _lista de borrado:_ SIN_IMAGEN(o, t)
  - _lista de adición:_ CON_IMAGEN(o, t)

---

**2. Representar el estado inicial y el objetivo de un problema en ese dominio en el que:**

- Hay dos satélites, SATÉLITE0 y SATÉLITE1.
- Hay cuatro instrumentos, INSTRUMENTO0 a INSTRUMENTO3.
- Hay tres tipos de imágenes, VISIBLE, INFRARROJOS y ESPECTRÓGRAFO.
- Hay ocho objetos galácticos, ESTRELLA0 a ESTRELLA4 y NEBULOSA0 a NEBULOSA2.
- El INSTRUMENTO0 puede tomar imágenes de tipo INFRARROJOS y ESPECTRÓGRAFO y se calibra con ESTRELLA1.
- El INSTRUMENTO1 puede tomar imágenes de tipo VISIBLE y se calibra con ESTRELLA2.
- El INSTRUMENTO2 puede tomar imágenes de tipo VISIBLE e INFRARROJOS y se calibra con ESTRELLA0.
- El INSTRUMENTO3 puede tomar imágenes de tipo VISIBLE, INFRARROJOS y ESPECTRÓGRAFO y se calibra con ESTRELLA0.
- El satélite SATÉLITE0 tiene a bordo los instrumentos INSTRUMENTO0, INSTRUMENTO1 e INSTRUMENTO2, apagados, y apunta inicialmente a ESTRELLA4.
- El satélite SATÉLITE1 tiene a bordo el instrumento INSTRUMENTO3, apagado, y apunta inicialmente a ESTRELLA0.
- Se desean una imagen de infrarrojos de ESTRELLA3, una imagen de espectrógrafo de ESTRELLA4 y NEBULOSA0 y una imagen del visible y de espectrógrafo de NEBULOSA2.

- _Estado inicial:_
  - Objetos_galacticos = {ESTRELLA_i | i=0,...,4} U {NEBULOSA_i | i=0,..,2}
  - Tipos_imagen = {VISIBLE, INFRARROJOS, ESPECTRÓGRAFO}
  - { son_distintos(O_i, O_j) | O_i, O_j ∈ Objetos_galacticos; i != j }
  - compatible_con(INSTRUMENTO0, IMAGEN_INFRARROJO), compatible_con(INSTRUMENTO0, IMAGEN_ESPECTRÓGRAFO), OBJETIVO_CALIBRACIÓN(INSTRUMENTO0, ESTRELLA1)
  - compatible_con(INSTRUMENTO1, VISIBLE), OBJETIVO_CALIBRACIÓN(INSTRUMENTO1, ESTRELLA2)
  - compatible_con(INSTRUMENTO2, VISIBLE), compatible_con(INSTRUMENTO2, INFRARROJOS), OBJETIVO_CALIBRACIÓN(INSTRUMENTO2, ESTRELLA0)
  - compatible_con(INSTRUMENTO3, VISIBLE), compatible_con(INSTRUMENTO3, INFRARROJOS), compatible_con(INSTRUMENTO3, ESPECTRÓGRAFO), OBJETIVO_CALIBRACIÓN(INSTRUMENTO3, ESTRELLA0)
  - a_bordo(INSTRUMENTO0, SATÉLITE0), a_bordo(INSTRUMENTO1, SATÉLITE0), a_bordo(INSTRUMENTO2, SATÉLITE0), a_bordo(INSTRUMENTO3, SATÉLITE1)
  - apunta_a(SATÉLITE0, ESTRELLA4), apunta_a(SATÉLITE1, ESTRELLA0)
  - **OJO, me faltó esto**
  - hay_energía(SATÉLITE0), hay_energía(SATÉLITE1)
  - no_calibrado(INSTRUMENTO0), no_calibrado(INSTRUMENTO1), no_calibrado(INSTRUMENTO2), no_calibrado(INSTRUMENTO3)
  - { sin-imagen(O, T) | o ∈ objetos_galacticos, t ∈ tipos_imagen }

- _Objetivo:_
  - con_imagen(ESTRELLA3, INFRARROJOS), con_imagen(ESTRELLA4, ESPECTRÓGRAFO), con_imagen(NEBULOSA0, ESPECTRÓGRAFO), con_imagen(NEBULOSA2, VISIBLE), con_imagen(NEBULOSA2,ESPECTRÓGRAFO)
