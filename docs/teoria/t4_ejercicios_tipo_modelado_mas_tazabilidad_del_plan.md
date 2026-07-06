<link rel="stylesheet" href="../css/estilo.css">

<div class="highlight-exercise">

## Ejercicio 1

### Enunciado

Consideremos un dominio de planificación automática consistente en **furgonetas conducidas por conductores para transportar paquetes entre distintos lugares**.

En este dominio los hechos se especifican a partir de los siguientes predicados:

- `conductor_en(c, l)`: representa que el conductor `c` está en el lugar `l`.
- `furgoneta_en(f, l)`: representa que la furgoneta `f` está en el lugar `l`.
- `paquete_en(p, l)`: representa que el paquete `p` está en el lugar `l`.
- `cargado_en(p, f)`: representa que el paquete `p` está cargado en la furgoneta `f`.
- `conduciendo(c, f)`: representa que el conductor `c` está conduciendo la furgoneta `f`.
- `sin_conductor(f)`: representa que ningún conductor está conduciendo la furgoneta `f`.
- `hay_carretera(l1, l2)`: representa que hay una carretera entre los lugares `l1` y `l2`.
- `hay_camino(l1, l2)`: representa que hay un camino entre los lugares `l1` y `l2`.

### Se pide:

1.  **Representar en el formalismo STRIPS** los siguientes esquemas de acciones:
    - `cargar_furgoneta(p, f, l)`: representa que en el lugar `l` se carga el paquete `p` en la furgoneta `f`.
    - `descargar_furgoneta(p, f, l)`: representa que en el lugar `l` se descarga el paquete `p` de la furgoneta `f`.
    - `subir_a(c, f, l)`: representa que en el lugar `l` el conductor `c` se sube a la furgoneta `f` para conducirla.  
      _Una furgoneta solo puede ser conducida por un único conductor._
    - `bajar_de(c, f, l)`: representa que en el lugar `l` el conductor `c` se baja de la furgoneta `f`.
    - `conducir(c, f, l1, l2)`: representa que el conductor `c` conduce por carretera la furgoneta `f` del lugar `l1` al lugar `l2`.
    - `caminar(c, l1, l2)`: representa que el conductor `c` va andando por un camino del lugar `l1` al lugar `l2`.

### Solución

- `cargar_furgoneta(p, f, l)`: representa que en el lugar `l` se carga el paquete `p` en la furgoneta `f`.
  - _Precondiciones:_ furgoneta_en(f,l), paquete_en(p,l)
  - _Lista de borrado:_ paquete_en(p,l)
  - _Lista de adicción:_ cargado_en(p,f)

- `descargar_furgoneta(p, f, l)`: representa que en el lugar `l` se descarga el paquete `p` de la furgoneta `f`.
  - _Precondiciones:_ cargado_en(p,f), furgoneta_en(f,l)
  - _Lista de borrado_: cargado_en(p,f)
  - _Lista de adicción_: paquete_en(p,l)

- `subir_a(c, f, l)`: representa que en el lugar `l` el conductor `c` se sube a la furgoneta `f` para conducirla.  
  _Una furgoneta solo puede ser conducida por un único conductor._
  - _Precondiciones:_ conductor_en(c,l), furgoneta_en(f,l), sin_conductor(f)
  - _Lista de borrado_: sin_conductor(f), conductor_en(c,l)
  - _Lista de adicción_: conduciendo(c,f)

- `bajar_de(c, f, l)`: representa que en el lugar `l` el conductor `c` se baja de la furgoneta `f`.
  - _Precondiciones:_ furgoneta_en(f,l), conduciendo(c,f)
  - _Lista de borrado_: conduciendo(c,f)
  - _Lista de adicción_: sin_conductor(f), conductor_en(c,l)

- `conducir(c, f, l1, l2)`: representa que el conductor `c` conduce por carretera la furgoneta `f` del lugar `l1` al lugar `l2`.
  - _Precondiciones:_ conduciendo(c,f), hay_carretera(l1,l2), furgoneta_en(f,l1)
  - _Lista de borrado_: furgoneta_en(f,l1)
  - _Lista de adicción_: furgoneta_en(f,l2)

- `caminar(c, l1, l2)`: representa que el conductor `c` va andando por un camino del lugar `l1` al lugar `l2`.
  - _Precondiciones:_ hay_camino(l1,l2),conductor_en(l1)
  - _Lista de borrado_: conductor_en(c,l1)
  - _Lista de adicción_: conductor_en(c,l2)

### Se pide:

**Representar el estado inicial y el objetivo de un problema en ese dominio en el que**

    - Hay tres lugares: `L1`, `L2` y `L3`.
    - Hay dos furgonetas: `F1` y `F2`.
    - Hay dos conductores: `C1` y `C2`.
    - Hay dos paquetes: `P1` y `P2`.
    - Hay una carretera entre los lugares `L1` y `L3` y entre los lugares `L2` y `L3`.
    - Hay un camino entre los lugares `L1` y `L2`.
    - La furgoneta `F1`, el conductor `C1` y el paquete `P1` se encuentran en el lugar `L1`.
    - La furgoneta `F2`, el conductor `C2` y el paquete `P2` se encuentran en el lugar `L2`.
    - El objetivo es que:
      - Ambos paquetes y el conductor `C1` se encuentren en el lugar `L3`,
      - La furgoneta `F1` se encuentre en el lugar `L1`,
      - El conductor `C2` se encuentre en el lugar `L2`.

### Solución

- _Estado inicial:_
  - furgoneta_en(F1,L1), conductor_en(C1,L1), paquete_en(P1,L1)
  - furgoneta_en(F2,L2), conductor_en(C2,L2), paquete_en(P2,L2)
  - sin_conductor(F1), sin_conductor(F2)
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)

- _Objetivo:_
  - paquete_en(P1,L3), paquete_en(P2,L3)
  - furgoneta_en(F1,L1)
  - conductor_en(C2,L2), conductor_en(C1,L3)

### Se pide:

**Especificar un posible plan solución** del problema anterior y comprobar que efectivamente lo es describiendo la secuencia de estados que se obtiene al aplicar las acciones contenidas en el plan.

### Solución

**Plan:** {cargar_furgoneta(P1,F1,L1), subir_a(C1,F1,L1), conducir(C1,F1,L1,L3), descargar_furgoneta(P1,F1,L3), bajar_de(C1,F1,L3), cargar_furgoneta(P2,F2,L2), subir_a(C2,F2,L2), conducir(C2,F2,L2,L3), descargar_furgoneta(P2,F2,L3), bajar_de(C2,F2,L3), subir_a(C2,F1,L3), conducir(C2,F1,L3,L1), bajar_de(C2,F1,L1),caminar(C2,L1,L2)}

**Traza**

- _estado incial_
  - furgoneta_en(F1,L1), conductor_en(C1,L1), paquete_en(P1,L1)
  - furgoneta_en(F2,L2), conductor_en(C2,L2), paquete_en(P2,L2)
  - sin_conductor(F1), sin_conductor(F2)
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
- **cargar_furgoneta(P1,F1,L1)**
  - furgoneta_en(F1,L1), conductor_en(C1,L1),
  - furgoneta_en(F2,L2), conductor_en(C2,L2), paquete_en(P2,L2)
  - sin_conductor(F1), sin_conductor(F2)
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - cargado_en(P1,F1)
- **subir_a(C1,F1,L1)**
  - furgoneta_en(F1,L1),
  - furgoneta_en(F2,L2), conductor_en(C2,L2), paquete_en(P2,L2)
  - sin_conductor(F2)
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - cargado_en(P1,F1), conduciendo(C1,F1)
- **conducir(C1,F1,L1,L3)**
  - furgoneta_en(F2,L2), conductor_en(C2,L2), paquete_en(P2,L2)
  - sin_conductor(F2)
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - cargado_en(P1,F1), conduciendo(C1,F1), furgoneta_en(F1,L3)
- **bajar_de(C1,F1,L3)**
  - furgoneta_en(F2,L2), conductor_en(C2,L2), paquete_en(P2,L2)
  - sin_conductor(F2)
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - cargado_en(P1,F1), furgoneta_en(F1,L3), sin_conductor(F1), **conductor_en(C1,L3)**
- **descargar_furgoneta(P1,F1,L3)**
  - furgoneta_en(F2,L2), conductor_en(C2,L2), paquete_en(P2,L2)
  - sin_conductor(F2)
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - furgoneta_en(F1,L3), sin_conductor(F1), **conductor_en(C1,L3)**, **paquete_en(P1,L3)**
- **cargar_furgoneta(P2,F2,L2)**
  - furgoneta_en(F2,L2), conductor_en(C2,L2)
  - sin_conductor(F2)
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - furgoneta_en(F1,L3), sin_conductor(F1), **conductor_en(C1,L3)**, **paquete_en(P1,L3)**, paquete_en(P1,F2)
- **subir_a(C2,F2,L2)**
  - furgoneta_en(F2,L2),
  -
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - furgoneta_en(F1,L3), sin_conductor(F1), **conductor_en(C1,L3)**, **paquete_en(P1,L3)**, paquete_en(P1,F2), conduciendo(C2,F2)
- **conducir(C2,F2,L2,L3)**
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - furgoneta_en(F1,L3), sin_conductor(F1), **conductor_en(C1,L3)**, **paquete_en(P1,L3)**, paquete_en(P1,F2), conduciendo(C2,F2), furgoneta_en(F2,L3)
- **bajar_de(C2,F2,L3)**
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - furgoneta_en(F1,L3), sin_conductor(F1), **conductor_en(C1,L3)**, **paquete_en(P1,L3)**, paquete_en(P1,F2), furgoneta_en(F2,L3), sin_conductor(F2), conductor_en(C2,L3)
- **descargar_furgoneta(P2,F2,L3)**
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - furgoneta_en(F1,L3), sin_conductor(F1), **conductor_en(C1,L3)**, **paquete_en(P1,L3)**, furgoneta_en(F2,L3), sin_conductor(F2), conductor_en(C2,L3), **paquete_en(P2,L3)**
- **subir_a(C2,F1,L3)**
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - furgoneta_en(F1,L3), **conductor_en(C1,L3)**, **paquete_en(P1,L3)**, furgoneta_en(F2,L3), sin_conductor(F2), conductor_en(C2,L3), **paquete_en(P2,L3)**, conduciendo(C2,F1,)
- **conducir(C2,F1,L3,L1)**
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - **conductor_en(C1,L3)**, **paquete_en(P1,L3)**, furgoneta_en(F2,L3), sin_conductor(F2), conductor_en(C2,L3), **paquete_en(P2,L3)**, conduciendo(C2,F1),**furgoneta_en(F1,L1)**
- **bajar_de(C2,F1,L1)**
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - **conductor_en(C1,L3)**, **paquete_en(P1,L3)**, furgoneta_en(F2,L3), sin_conductor(F2), conductor_en(C2,L3), **paquete_en(P2,L3)**, **furgoneta_en(F1,L1)**, conductor_en(C2,L1)
- **caminar(C2,L1,L2)**
  - hay_carretera(L1,L3), hay_carretera(L2,L3), hay_carretera(L3,L1), hay_carretera(L3,L2)
  - Hay camino(L1,L2), Hay camino(L2,L1)
  - **conductor_en(C1,L3)**, **paquete_en(P1,L3)**, furgoneta_en(F2,L3), sin_conductor(F2), conductor_en(C2,L3), **paquete_en(P2,L3)**, **furgoneta_en(F1,L1)**, **conductor_en(C2,L2)**

---

</div>

## Ejercicio 2

Consideremos un dominio de planificación automática consistente en un **ascensor** (que asumimos con capacidad infinita) que permite moverse a personas entre distintas plantas de un edificio.

En este dominio los hechos se especifican a partir de los siguientes predicados:

- `superior(pl1, pl2)`: representa que la planta `pl1` del edificio está por encima de la planta `pl2`.
- `ascensor_en(pl)`: representa que el ascensor se encuentra en la planta `pl` del edificio.
- `origen(pe, pl)`: representa que la persona `pe` se encuentra inicialmente en la planta `pl` del edificio.
- `destino(pe, pl)`: representa que la persona `pe` desea ir a la planta `pl` del edificio.
- `dentro_ascensor(pe)`: representa que la persona `pe` ha entrado en el ascensor.
- `fuera_ascensor(pe)`: representa que la persona `pe` no ha entrado en el ascensor.
- `en_destino(pe)`: representa que la persona `pe` ha llegado a su destino.

### Se pide:

1.  **Representar en el formalismo STRIPS** los siguientes esquemas de acciones:
    - `entrar(pe, pl)`: representa que la persona `pe` entra en el ascensor en la planta `pl` en la que se encuentra inicialmente.
      - _Precondiciones:_ origen(pe,pl), ascensor_en(pl), fuera_ascensor(pe)
      - _Lista de borrado:_ origen(pe,pl), fuera_ascensor(pe)
      - _Lista de adicción:_ dentro_ascensor(pe)
    - `salir(pe, pl)`: representa que la persona `pe` sale del ascensor en la planta `pl` del edificio a la que desea ir.
      - _Precondiciones:_ dentro_ascensor(pe), ascensor_en(pl), destino(pe, pl)
      - _Lista de borrado:_ dentro_ascensor(pe)
      - _Lista de adicción:_ fuera_ascensor(pe), en_destino(pe)
    - `subir(pl1, pl2)`: representa que el ascensor sube de la planta `pl1` a la planta `pl2` del edificio.
      - _Precondiciones:_ ascensor_en(pl1), superior(pl2, pl1)
      - _Lista de borrado:_ ascensor_en(pl1)
      - _Lista de adicción:_ ascensor_en(pl2)
    - `bajar(pl1, pl2)`: representa que el ascensor baja de la planta `pl1` a la planta `pl2` del edificio.
      - _Precondiciones:_ ascensor_en(pl1), superior(pl1, pl2)
      - _Lista de borrado:_ ascensor_en(pl1)
      - _Lista de adicción:_ ascensor_en(pl2)

2.  **Representar el estado inicial y el objetivo** de un problema en ese dominio en el que:
    - El edificio tiene cuatro plantas (`PL0` a `PL3`).
    - El ascensor se encuentra inicialmente en la planta `PL1`.
    - Hay una persona `PE0` en la planta `PL0` que desea ir a la planta `PL2`.
    - Hay una persona `PE1` en la planta `PL3` que desea ir a la planta `PL0`.

    - _Estado Inicial:_ superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), ascensor_en(PL1), origen(PE0,PL0), destino(PE0,PL2), fuera_ascensor(PE0), origen(PE1,PL3), destino(PE1,PL0), fuera_ascensor(PE1)

    - _objetivo:_ en_destino(PE0), en_destino(PE1)

3.  **Especificar un posible plan solución** del problema anterior y comprobar que efectivamente lo es describiendo la secuencia de estados que se obtiene al aplicar las acciones contenidas en el plan.

**PLAN** = { bajar(PL1,PL0), entrar(PE0, PL0), subir (PL0,PL1), subir(PL1,PL2), salir(PE0,PL2), subir(PL2,PL3), entrar(PE1,PL3), bajar(PL3,PL2), bajar(PL2,PL1), bajar(PL1,PL0), salir(PE0,PL0)}

**Traza**

- _Estado Inicial:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), ascensor_en(PL1), origen(PE0,PL0), destino(PE0,PL2), fuera_ascensor(PE0), origen(PE1,PL3), destino(PE1,PL0), fuera_ascensor(PE1) }

- **Acción 1 bajar(PL1,PL0):**
  - _Estado:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), origen(PE0,PL0), destino(PE0,PL2), fuera_ascensor(PE0), origen(PE1,PL3), destino(PE1,PL0), fuera_ascensor(PE1), ascensor_en(PL0) }
- **Acción 2 entrar(PE0,PL0):**
  - _Estado:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), origen(PE0,PL0), destino(PE0,PL2), origen(PE1,PL3), destino(PE1,PL0), fuera_ascensor(PE1), ascensor_en(PL0) }
- **Acción 3 sublir(PL0,PL1):**
  - _Estado:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), origen(PE0,PL0), destino(PE0,PL2), origen(PE1,PL3), destino(PE1,PL0), fuera_ascensor(PE1), ascensor_en(PL1) }
- **Acción 4 sublir(PL1,PL2):**
  - _Estado:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), origen(PE0,PL0), destino(PE0,PL2), origen(PE1,PL3), destino(PE1,PL0), fuera_ascensor(PE1), ascensor_en(PL2) }
- **Acción 5 salir(PE0,PL2):**
  - _Estado:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), origen(PE0,PL0), destino(PE0,PL2), origen(PE1,PL3), destino(PE1,PL0), fuera_ascensor(PE1), ascensor_en(PL2), fuera_ascensor(PE0), **en_destino(PE0)** }
- **Acción 6 subir(PL2,PL3):**
  - _Estado:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), origen(PE0,PL0), destino(PE0,PL2), origen(PE1,PL3), destino(PE1,PL0), fuera_ascensor(PE1), ascensor_en(PL3), fuera_ascensor(PE0), **en_destino(PE0)** }
- **Acción 7 entrar(PE1,PL3):**
  - _Estado:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), origen(PE0,PL0), destino(PE0,PL2), origen(PE1,PL3), destino(PE1,PL0), ascensor_en(PL3), fuera_ascensor(PE0), **en_destino(PE0)** }
- **Acción 8 bajar(PL3,PL2):**
  - _Estado:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), origen(PE0,PL0), destino(PE0,PL2), origen(PE1,PL3), destino(PE1,PL0), ascensor_en(PL2), fuera_ascensor(PE0), **en_destino(PE0)** }
- **Acción 9 bajar(PL2,PL1):**
  - _Estado:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), origen(PE0,PL0), destino(PE0,PL2), origen(PE1,PL3), destino(PE1,PL0), ascensor_en(PL1), fuera_ascensor(PE0), **en_destino(PE0)**s }
- **Acción 10 bajar(PL1,PL0):**
  - _Estado:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), origen(PE0,PL0), destino(PE0,PL2), origen(PE1,PL3), destino(PE1,PL0), ascensor_en(PL0), fuera_ascensor(PE0), **en_destino(PE0)** }
- **Acción 11 salir(PE1,PL0):**
  - _Estado:_ { superior(PL3,PL2), superior(PL3,PL1),superior(PL3,PL0), superior(PL2,PL1), superior(PL2,PL0), superior(PL1,PL0), origen(PE0,PL0), destino(PE0,PL2), origen(PE1,PL3), destino(PE1,PL0), ascensor_en(PL0), fuera_ascensor(PE0), **en_destino(PE0)**, fuera_ascensor(PE1), **en_destino(PE1)** }
