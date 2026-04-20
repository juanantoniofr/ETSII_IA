## Ejercicio 1

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

2.  **Representar el estado inicial y el objetivo** de un problema en ese dominio en el que:
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

3.  **Especificar un posible plan solución** del problema anterior y comprobar que efectivamente lo es describiendo la secuencia de estados que se obtiene al aplicar las acciones contenidas en el plan.

---

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
    - `salir(pe, pl)`: representa que la persona `pe` sale del ascensor en la planta `pl` del edificio a la que desea ir.
    - `subir(pl1, pl2)`: representa que el ascensor sube de la planta `pl1` a la planta `pl2` del edificio.
    - `bajar(pl1, pl2)`: representa que el ascensor baja de la planta `pl1` a la planta `pl2` del edificio.

2.  **Representar el estado inicial y el objetivo** de un problema en ese dominio en el que:
    - El edificio tiene cuatro plantas (`PL0` a `PL3`).
    - El ascensor se encuentra inicialmente en la planta `PL1`.
    - Hay una persona `PE0` en la planta `PL0` que desea ir a la planta `PL2`.
    - Hay una persona `PE1` en la planta `PL3` que desea ir a la planta `PL0`.

3.  **Especificar un posible plan solución** del problema anterior y comprobar que efectivamente lo es describiendo la secuencia de estados que se obtiene al aplicar las acciones contenidas en el plan.
