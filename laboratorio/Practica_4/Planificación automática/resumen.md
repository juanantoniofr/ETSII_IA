# Práctica 4 - Planificación automática

## 0. Introducción

Por un lado especificamos el problema y por otro usamos un planificador para resolverlo

- Bibliotecas
  - unified-planning -> Especificar el problema (compatible con distintos planificadores)
  - up-fast-downward -> Planificador (elegimos este pero puede ser otro)

## 1. unified-planning

### Podemos leer y escribir dominios y problemas de planificación

```python

    from unified_planning.io import PDDLReader

    lector_PDDL = PDDLReader()
    problema_mundo_bloques = lector_PDDL.parse_problem('dominio_mundo_bloques.pddl',
                                                       'problema_mundo_bloques.pddl')

```

- Si queremos usar unified-planning junto a un planificador **tenemos que elegir el modo OneshotPlanner**
- Y ademas tenemos que comprobar que el planificador es compatible con la especificación del problema

```python

    from unified_planning.shortcuts import OneshotPlanner

    planificador = OneshotPlanner(name='fast-downward')
    # Devuelve true si son compatibles
    planificador.supports(problema_mundo_bloques.kind)

```

### Especificación mediante código del dominio y problema

- 1. Crear los tipos. Se permiten jerarquías entre ellos.

```python

    from unified_planning.shortcuts import UserType

    paquete = UserType('Paquete')
    localización = UserType('Localización')
    lugar = UserType('Lugar', father=localización)
    camion = UserType('Camion', father=localización)


```

- 2. Crear los fluentes (**predicados**). Hay que indicar el tipo de cada argumento.

```python

    from unified_planning.shortcuts import Fluent, BoolType

    conectados = Fluent('CONECTADOS', BoolType(), l1=lugar, l2=lugar)
    camion_en = Fluent('CAMION_EN', BoolType(), c=camion, l=lugar)
    paquete_en = Fluent('PAQUETE_EN', BoolType(), p=paquete, lc=localización)


```

- 3. **Finalmente** creamos las acciones.

```python

    from unified_planning.shortcuts import InstantaneousAction

    # ---
    # IR
    # ---
    accion_ir = InstantaneousAction('IR', c=camion, l1=lugar, l2=lugar)
    c = accion_ir.c
    l1 = accion_ir.l1
    l2 = accion_ir.l2

    # - Precondiciones
    for hecho in [conectados(l1,l2), camion_en(c,l1)]:
        accion_ir.add_precondition(hecho)

    # - Lista de borrado
    for hecho in [camion_en(c, l1)]:
        accion_ir.add_effect(hecho, False)

    # - Lista de Adición
    for hecho in [camion_en(c,l2)]:
        accion_ir.add_effect(hecho, True)

    # ---
    # CARGAR
    # ---
    accion_cargar = InstantaneousAction('CARGAR', c=camion, p=paquete, l=lugar)
    c = accion_cargar.c
    p = accion_cargar.p
    l = accion_cargar.l

    # - Precondiciones
    for hecho in [camion_en(c,l1), paquete_en(p,l1)]:
        accion_cargar.add_precondition(hecho)

    # - Lista de borrado
    for hecho in [paquete_en(p,l1)]:
        accion_cargar.add_effect(hecho, False)

    # - Lista de adición
    for hecho in [paquete_en(p,c)]:
        accion_cargar.add_effect(hecho, True)

    # ---
    # DESCARGAR
    # ---
    accion_descargar = InstananeousAction('DESCARGAR', c=camion, p=paquete, l=lugar)
    c = accion_cargar.c
    p = accion_cargar.p
    l = accion_cargar.l

    # - Precondiciones
    for hecho in [paquete_en(p,c), camion_en(c,l)]:
        accion_descargar.add_precondition(hecho)

    # - Lista de borrado
    for hecho in [paquete_en(p,c)]:
        accion_descargar.add_effect(hecho, False)

    # - Lista de adición
    for hecho in [paquete_en(p,l)]:
        accion_descargar.add_effect(hecho, True)

```

#### Dominio del problema

Tenemos:

- Tipos de objetos.
- Predicados
- Acciones

Llegado este punto, ya tenemos definido el **dominio del problema**, y lo podemos salvar a un fichero pddl.

```python

    from unified_plannig.shortcuts import Problem

    problema_transporte_de_paquetes = Problem('Problema del transporte de paquetes')

    # - Añade los tipos
    for tipo_de_objeto in [paquete, localizacion, camion, lugar]:
        problema_transporte_de_paquetes.user_types.append(tipo_de_objeto)
    # - Añade los predicados (fluentes)
    for fluente in [conectados, paquete_en, camion_en]
        problema_transporte_de_paquetes.add_fluente(fluente, default_initial_value=False)

    # - Añade las acciones
    problema_transporte_de_paquetes.add_actions([accion_ir, accion_cargar, accion_descargar])

    from unified_planning.io import PDDLWriter
    escritor_PDDL = PDDLWriter(problema_transporte_de_paquetes)
    escritor_PDDL.write_domain('dominio_transporte_de_paquetes.pddl')

```

#### Problema

Para completar la definición o especificación del problema nos falta.

- 1. Objetos concretos usados por esa **instancia del problema**.
- 2. Establecer a true los hechos del estado inicial.
- 3. Establecer el objetivo.

```python

    from unified._planning.shortcuts import Object

    # ---- definición de objetos

    # define L0, L1, L2 y L3
    lugares = [Object(f'L{i}', lugar) for i in range(4)]
    # define C - camion -
    c = Object('C', camion)
    # define P - paquete -
    p = Object('P', paquete)

    for objeto in lugares + [C,P]:
        problema_transporte_de_paquetes.add_object(objeto)


    # ---- hechos iniciales a true (estado inicial)
    for i,j in  [(0, 1), (1, 2), (2, 3), (1, 3)]:
        Li = lugares[i]
        Lj = lugares[j]
        problema_transporte_de_paquetes.set_initial_value(conectados(Li,Lj), True)
        problema_transporte_de_paquetes.set_initial_value(conectados(Lj,Li), True)

    problema_transporte_de_paquetes.set_initial_value(camion_en(C, lugares[0]), True)
    problema_transporte_de_paquetes.set_initial_value(paquete_en(P, lugares[1]), True)

    # ---- hechos finales (objetivo)

    problema_transporte_de_paquetes.add_goal(camion_en(C, lugares[0]))
    problema_transporte_de_paquetes.add_goal(paquete_en(P, lugares[3]))

```

También podemos salvar el problema a un fichero pddl.

```python

    escritor_PDDL.write_problem('problema_transporte_de_paquetes.pddl')
```

## 2. Planificación

- Buscamos un plan usando nuestro planificador (fast-downward), indicando que use los algoritmo A<sup>∗</sup> con heurística h<sup>max</sup>.

```python

    planificador = OneshotPlanner(name='fast-downward', params={'fast_downward_search_config': 'astar(hmax())'})
    plan = planificador.solve(problema_transporte_de_paquetes)

```
