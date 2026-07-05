# Guía de Estudio y Plantilla Modelo: Planificación Clásica (PDDL) con Unified Planning
## Grado en Ingeniería Informática - Universidad de Sevilla

Esta plantilla contiene la estructura, sintaxis y patrones de código fundamentales para resolver con éxito los ejercicios de desarrollo y de laboratorio de la **Práctica 4 (Planificación Clásica)** utilizando la biblioteca **`Unified Planning`** [178, 215]. Está completamente actualizada y adaptada a las soluciones oficiales de los ejercicios propuestos (Mundo de Bloques, Depot y Sokoban) [178, 180, 182].

---

## 1. Ejercicio 1: El Mundo de los Bloques (Generación Dinámica de Instancias)
Este bloque se centra en leer un dominio PDDL ya existente, clonarlo y construir de forma dinámica objetos, estados iniciales y objetivos en base a un parámetro numérico $N$ [178, 179].

### Patrón de Código Oficial para Examen:
```python
import time
from unified_planning.shortcuts import OneshotPlanner, get_environment, Object
from unified_planning.io import PDDLReader

# Desactivar la publicidad del planificador para un output limpio
get_environment().credits_stream = None

# 1. Leer el dominio PDDL desde el disco
lector_PDDL = PDDLReader()
dominio_mundo_bloques = lector_PDDL.parse_problem("dominio_mundo_bloques.pddl")

def crea_instancia_mundo_bloques(N):
    # 2. Clonar preventivamente el dominio para no arrastrar modificaciones
    instancia = dominio_mundo_bloques.clone()
    
    # 3. Obtener el tipo de objeto correspondiente
    block_type = instancia.user_type('object')
    
    # 4. Crear y añadir dinámicamente los N bloques [B0, B1, ..., BN-1]
    bloques_creados = [Object(f"B{i}", block_type) for i in range(N)]
    instancia.add_objects(bloques_creados)
    
    # 5. Recuperar los fluentes del dominio para poder referenciarlos
    sobre_la_mesa = dominio_mundo_bloques.fluent('sobre_la_mesa')
    sobre = dominio_mundo_bloques.fluent('sobre')
    agarrado = dominio_mundo_bloques.fluent('agarrado')
    brazo_libre = dominio_mundo_bloques.fluent('brazo_libre')
    despejado = dominio_mundo_bloques.fluent('despejado')
    
    # Lista de todos los objetos cargados en la instancia
    lista_bloques = list(instancia.all_objects)
    
    # 6. CONFIGURAR ESTADO INICIAL
    # - Brazo libre al inicio (True)
    instancia.set_initial_value(brazo_libre(), True)
    
    # - Torre inicial apilada: B0 en la mesa, B1 sobre B0, B2 sobre B1...
    bloque_anterior = None
    for bloque in lista_bloques:
        if bloque_anterior is None:
            instancia.set_initial_value(sobre_la_mesa(bloque), True)
        else:
            instancia.set_initial_value(sobre(bloque, bloque_anterior), True)
        bloque_anterior = bloque
        
    # - El último bloque de la lista (BN-1) está despejado
    instancia.set_initial_value(despejado(lista_bloques[-1]), True)
    
    # 7. CONFIGURAR ESTADO OBJETIVO
    # Queremos la torre al revés: BN-1 en la mesa, BN-2 sobre BN-1... B0 sobre B1
    bloque_anterior = None
    for bloque in reversed(lista_bloques):
        if bloque_anterior is None:
            instancia.add_goal(sobre_la_mesa(bloque))
        else:
            instancia.add_goal(sobre(bloque, bloque_anterior))
        bloque_anterior = bloque
        
    return instancia

# 8. Verificación de la construcción correcta del problema
instancia_prueba = crea_instancia_mundo_bloques(7)

print("--- ESTADO INICIAL ---")
for fluido, valor in instancia_prueba.initial_values.items():
    if str(valor) == "true" or valor is True:
        print(f"  {fluido}")
    elif str(valor) != "false" and valor is not False:
        print(f"  {fluido} = {valor}")

print("\n--- ESTADO OBJETIVO ---")
for meta in instancia_prueba.goals:
    print(f"  {meta}")
```

### Script de Prueba de Estrés (Fast Downward):
```python
estados_resueltos = {"SOLVED_SATISFICING", "SOLVED_OPTIMALLY"}
tamanos_a_probar = [5, 10, 20, 30, 50, 100, 200, 500]

print("Iniciando Prueba de Estrés - Mundo de Bloques")
for N in tamanos_a_probar:
    print(f"\n--- Probando con N = {N} bloques ---")
    instancia = crea_instancia_mundo_bloques(N)
    
    with OneshotPlanner(name="fast-downward") as planner:
        inicio = time.time()
        # Establecemos un límite de tiempo de 30 segundos por problema
        resultado = planner.solve(instancia, timeout=30)
        tiempo_total = time.time() - inicio
        
        estado_nombre = getattr(resultado.status, "name", str(resultado.status))
        
        if estado_nombre in estados_resueltos:
            longitud_plan = len(resultado.plan.actions)
            print(f"  ¡Resuelto! Tiempo: {tiempo_total:.2f} s. Longitud del plan: {longitud_plan}")
        else:
            print(f"  Falló o excedió el tiempo límite (Estado: {estado_nombre}).")
            break
```

---

## 2. Ejercicio 2: Depot (Dominio Logístico con Jerarquía de Tipos)
Este problema combina el mundo de los bloques con la distribución logística. Requiere definir una jerarquía de tipos (herencia) y utilizar un fluente con nombre reservado (`in_`) [180].

### Patrón de Código Oficial para Examen:
```python
from unified_planning.shortcuts import Problem, UserType, Fluent, BoolType, InstantaneousAction

# 1. Definición de la jerarquía de tipos
Place = UserType('Place')                      # Clase base para ubicaciones
Locatable = UserType('Locatable')              # Clase base para objetos móviles
Depot = UserType('Depot', father=Place)        # Almacén (subtipo de Place)
Distributor = UserType('Distributor', Place)   # Distribuidor (subtipo de Place)
Truck = UserType('Truck', father=Locatable)    # Camión (subtipo de Locatable)
Hoist = UserType('Hoist', father=Locatable)    # Polipasto (subtipo de Locatable)
Surface = UserType('Surface', father=Locatable)# Superficie (subtipo de Locatable)
Pallet = UserType('Pallet', father=Surface)    # Palé (subtipo de Surface)
Crate = UserType('Crate', father=Surface)      # Caja (subtipo de Surface)

dominio_depot = Problem('depot')

# Añadir tipos de objetos al problema
for tipo in [Place, Locatable, Depot, Distributor, Truck, Hoist, Surface, Pallet, Crate]:
    dominio_depot.user_types.append(tipo)

# 2. Definición de predicados lógicos (Fluentes)
at = Fluent('AT', BoolType(), x=Locatable, y=Place)
on = Fluent('ON', BoolType(), x=Crate, y=Surface)
lifting = Fluent('LIFTING', BoolType(), x=Hoist, y=Crate)
available = Fluent('AVAILABLE', BoolType(), x=Hoist)
clear = Fluent('CLEAR', BoolType(), x=Surface)

# TRUCO DE EXAMEN: El predicado IN se define como in_ para evitar colisiones
# con la palabra clave reservada de Python 'in'
in_ = Fluent('IN', BoolType(), x=Crate, y=Truck)

# Añadir fluentes al dominio
for fluente in [at, on, in_, lifting, available, clear]:
    dominio_depot.add_fluent(fluente, default_initial_value=False)

# 3. Modelado de Esquemas de Acciones Instantáneas
# Acción DRIVE: Camión x viaja del lugar y al lugar z
drive = InstantaneousAction('DRIVE', x=Truck, y=Place, z=Place)
x, y, z = drive.x, drive.y, drive.z
drive.add_precondition(at(x, y))
drive.add_effect(at(x, y), False)
drive.add_effect(at(x, z), True)

# Acción LIFT: Polipasto x levanta la caja y de la superficie z en el lugar p
lift = InstantaneousAction('LIFT', x=Hoist, y=Crate, z=Surface, p=Place)
x, y, z, p = lift.x, lift.y, lift.z, lift.p
for hecho in [at(x, p), at(z, p), on(y, z), available(x), clear(y)]:
    lift.add_precondition(hecho)
for hecho in [available(x), on(y, z), clear(y)]:
    lift.add_effect(hecho, False)
for hecho in [lifting(x, y), clear(z)]:
    lift.add_effect(hecho, True)

# Acción DROP: Polipasto x suelta la caja y sobre la superficie z en el lugar p
drop = InstantaneousAction('DROP', x=Hoist, y=Crate, z=Surface, p=Place)
x, y, z, p = drop.x, drop.y, drop.z, drop.p
for hecho in [at(x, p), at(z, p), lifting(x, y), clear(z)]:
    drop.add_precondition(hecho)
for hecho in [clear(z), lifting(x, y)]:
    drop.add_effect(hecho, False)
for hecho in [clear(y), available(x), on(y, z), at(y, p)]:
    drop.add_effect(hecho, True)

# Acción LOAD: Polipasto x carga la caja y en el camión z en el lugar p
load = InstantaneousAction('LOAD', x=Hoist, y=Crate, z=Truck, p=Place)
x, y, z, p = load.x, load.y, load.z, load.p
for hecho in [at(x, p), at(z, p), at(y, p), lifting(x, y)]:
    load.add_precondition(hecho)
for hecho in [lifting(x, y)]:
    load.add_effect(hecho, False)
for hecho in [available(x), in_(y, z)]:
    load.add_effect(hecho, True)

# Acción UNLOAD: Polipasto x descarga la caja y del camión z en el lugar p
unload = InstantaneousAction('UNLOAD', x=Hoist, y=Crate, z=Truck, p=Place)
x, y, z, p = unload.x, unload.y, unload.z, unload.p
for hecho in [at(x, p), at(z, p), in_(y, z), available(x)]:
    unload.add_precondition(hecho)
for hecho in [in_(y, z), available(x)]:
    unload.add_effect(hecho, False)
for hecho in [lifting(x, y)]:
    unload.add_effect(hecho, True)

# Registrar las acciones limpiando instancias previas si las hubiera
dominio_depot.clear_actions()
dominio_depot.add_actions([drive, lift, drop, load, unload])
```

---

## 3. Ejercicio 3: Sokoban (Planificación con Costes y Parámetros del Planificador)
En Sokoban el objetivo es empujar cajas (`stone`) a ciertas posiciones. Se penalizan las acciones de empujar (coste 1) frente a las de moverse (coste 0), buscando optimizar el coste acumulado [182, 185].

### Patrón de Código Oficial (Dominio, Costes y Heurística hmax):
```python
from unified_planning.shortcuts import Problem, UserType, Fluent, BoolType, IntType, Int, InstantaneousAction, MinimizeActionCosts, OneshotPlanner

dominio_sokoban = Problem("sokoban")

# 1. Tipos de objetos
thing = UserType("thing")
location = UserType("location")
direction = UserType("direction")
player = UserType("player", father=thing)
stone = UserType("stone", father=thing)

# 2. Predicados
clear = Fluent("CLEAR", BoolType(), l=location)
at = Fluent("AT", BoolType(), t=thing, l=location)
at_goal = Fluent("AT-GOAL", BoolType(), s=stone)
is_goal = Fluent("IS-GOAL", BoolType(), l=location)
is_nongoal = Fluent("IS-NONGOAL", BoolType(), l=location)
move_dir = Fluent("MOVE-DIR", BoolType(), l1=location, l2=location, d=direction)

# Fluente numérico especial para el coste acumulado de las instancias
total_cost = Fluent("total-cost", IntType())

for f in [clear, at, at_goal, is_goal, is_nongoal, move_dir]:
    dominio_sokoban.add_fluent(f, default_initial_value=False)
dominio_sokoban.add_fluent(total_cost, default_initial_value=Int(0))

# 3. Acciones
# - MOVE: El jugador se desplaza a una casilla libre adyacente (Coste 0)
move = InstantaneousAction("MOVE", p=player, l1=location, l2=location, d=direction)
p, l1, l2, d = move.parameters
move.add_precondition(at(p, l1))
move.add_precondition(move_dir(l1, l2, d))
move.add_precondition(clear(l2))
move.add_effect(at(p, l1), False)
move.add_effect(at(p, l2), True)
move.add_effect(clear(l1), True)
move.add_effect(clear(l2), False)

# - PUSH-TO-NONGOAL: El jugador empuja una piedra a una casilla no objetivo (Coste 1)
push_nogoal = InstantaneousAction("PUSH-TO-NONGOAL", p=player, l1=location, s=stone, l2=location, l3=location, d=direction)
p, l1, s, l2, l3, d = push_nogoal.parameters
push_nogoal.add_precondition(at(p, l1))
push_nogoal.add_precondition(at(s, l2))
push_nogoal.add_precondition(move_dir(l1, l2, d))
push_nogoal.add_precondition(move_dir(l2, l3, d))
push_nogoal.add_precondition(clear(l3))
push_nogoal.add_precondition(is_nongoal(l3))

push_nogoal.add_effect(at(p, l1), False)
push_nogoal.add_effect(at(s, l2), False)
push_nogoal.add_effect(clear(l3), False)
push_nogoal.add_effect(at_goal(s), False) # No está en zona objetivo
push_nogoal.add_effect(at(p, l2), True)
push_nogoal.add_effect(at(s, l3), True)
push_nogoal.add_effect(clear(l1), True)

# - PUSH-TO-GOAL: El jugador empuja una piedra a una casilla objetivo (Coste 1)
push_goal = InstantaneousAction("PUSH-TO-GOAL", p=player, l1=location, s=stone, l2=location, l3=location, d=direction)
p, l1, s, l2, l3, d = push_goal.parameters
push_goal.add_precondition(at(p, l1))
push_goal.add_precondition(at(s, l2))
push_goal.add_precondition(move_dir(l1, l2, d))
push_goal.add_precondition(move_dir(l2, l3, d))
push_goal.add_precondition(clear(l3))
push_goal.add_precondition(is_goal(l3))

push_goal.add_effect(at(p, l1), False)
push_goal.add_effect(at(s, l2), False)
push_goal.add_effect(clear(l3), False)
push_goal.add_effect(at_goal(s), True) # Marcado como en zona objetivo
push_goal.add_effect(at(p, l2), True)
push_goal.add_effect(at(s, l3), True)
push_goal.add_effect(clear(l1), True)

dominio_sokoban.add_actions([move, push_nogoal, push_goal])

# 4. Configurar la métrica de minimización de costes
# Coste 1 para empujes, por defecto coste 0 (para los movimientos de andar)
metrica = MinimizeActionCosts(
    {
        push_nogoal: Int(1),
        push_goal: Int(1)
    },
    default=Int(0)
)
dominio_sokoban.add_quality_metric(metrica)

# 5. Configurar el planificador con algoritmo A* y heurística hmax
configuracion_fd = {
    "fast_downward_search_config": "astar(hmax())"
}

with OneshotPlanner(name="fast-downward", params=configuracion_fd) as planner:
    resultado = planner.solve(dominio_sokoban, timeout=60)
    print(f"Estado de la resolución: {resultado.status}")
```

---

## 4. Cheat Sheet de la API de Unified-Planning para Examen

| Clase / Método | Propósito / Ejemplo |
| :--- | :--- |
| `UserType('Name', father=Parent)` | Define un tipo y herencia (subtipo de `Parent`) [215]. |
| `Fluent('Name', Type(), param=Type)` | Define un predicado lógico o función de estado [215]. |
| `BoolType()`, `IntType()` | Tipos de datos soportados para los fluentes [215]. |
| `Int(valor)` | Construye constantes numéricas de tipo entero [215]. |
| `InstantaneousAction('Name', ...)` | Especifica una acción que ocurre en un instante [216]. |
| `action.parameters` | Desempaqueta los parámetros del esquema de la acción. |
| `action.add_precondition(fluent)` | Añade una restricción lógica requerida [216]. |
| `action.add_effect(fluent, value)` | Define el cambio de estado tras ejecutar la acción [216]. |
| `Problem('Name')` | Clase contenedora de la definición de un problema clásico [216]. |
| `problem.clone()` | Copia el problema para modificaciones seguras (esencial para pruebas) [216]. |
| `problem.add_objects([Object])` | Inserta constantes físicas en el problema [216]. |
| `problem.set_initial_value(fluent, val)`| Define el estado inicial de partida ($t=0$) [216]. |
| `problem.add_goal(fluent)` | Define una condición lógica que el plan debe satisfacer [216]. |
| `problem.add_quality_metric(metric)` | Inyecta métricas de optimización (minimizar costes, pasos) [216]. |
| `MinimizeActionCosts({action: cost})` | Configura el coste unitario por cada esquema de acción [217]. |
| `OneshotPlanner(name='fast-downward')`| Carga el planificador clásico por excelencia [217]. |
| `planner.solve(problem, timeout=X)` | Resuelve el problema con un tiempo máximo de retardo $X$ [217]. |

---

## ⚠️ Errores Típicos a Evitar en el Examen

1. **Uso de palabras clave de Python en fluentes:** Nunca llames a un fluente `in` o `not`. Usa siempre nombres modificados como `in_` o `not_` en tu código Python, mapeándolos en el PDDL final si es necesario [180].
2. **Confundir el objeto `Problem` con sus modificaciones directas:** Si vas a resolver múltiples instancias, recuerda llamar siempre a `dominio.clone()` antes de modificar su estado inicial o añadir objetos, de lo contrario acumularás datos no deseados de ejecuciones previas [216].
3. **No registrar las acciones:** Definir las variables `drive`, `lift` etc. no las asocia al problema de forma automática. Siempre debes invocar `problema.add_actions([lista_de_acciones])` o lanzarás un plan vacío por falta de operadores [216].
4. **Olvidar deshabilitar la publicidad en bucles estresantes:** Al realizar pruebas de rendimiento, desactiva el flujo de créditos del entorno con `get_environment().credits_stream = None` para no contaminar la consola del terminal y ralentizar la ejecución del programa.
