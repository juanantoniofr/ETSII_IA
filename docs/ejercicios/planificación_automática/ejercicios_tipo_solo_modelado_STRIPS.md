# Modelado STRIPS

Los ejercicios de este documento piden se modele un problema siguiendo STRIPS. Para ello tenemos que:

- Predicados (Hechos - H): Representa las características el entorno (conjunto finito)

- Acciones (A): Conjunto finito de esquemas, que se definen por:
  - Nombre
  - Precondiciones (Hechos que deben cumplirse)
  - Lista de borrado (Hechos que dejan de cumplirse )
  - Lista de adición (Hechos que pasan a cumplirse)

- Estado Inicial (I): Hechos que se cumplen inicialmente
- Objetivo (G): Hechos que se quiere se cumplan para dar el problema por resuelto.

# Ejercicio 4

Representar en el formalismo STRIPS el problema del mono y los plátanos: un mono se encuentra en el sitio A de un laboratorio; hay una caja en el sitio C; el mono quiere los plátanos que cuelgan del techo del sitio B, pero necesita mover la caja y subirse a ella para alcanzarlos.

## Solución

**1. Predicados**

- `MONO_EN(s)`: El mono está en el sitio s.
- `CAJA_EN(s)`: La caja está en el sitio s.
- `PLATANOS_EN(s)`: Los plátanos cuelgan en el sitio s.
- `MONO_EN_SUELO()`: El mono está pisando el suelo (no está sobre la caja).
- `MONO_SOBRE_CAJA()`: El mono está subido en la caja.
- `TIENE_PLATANOS()`: El mono ha conseguido coger los plátanos.

**2. Acciones**

- **IR_A(s1, s2)**
  - _Precondiciones:_ `MONO_EN(s1)`, `MONO_EN_SUELO()`
  - _Lista de borrado:_ `MONO_EN(s1)`
  - _Lista de adición:_ `MONO_EN(s2)`

- **EMPUJAR_CAJA(s1, s2)**
  - _Precondiciones:_ `MONO_EN(s1)`, `CAJA_EN(s1)`, `MONO_EN_SUELO()`
  - _Lista de borrado:_ `MONO_EN(s1)`, `CAJA_EN(s1)`
  - _Lista de adición:_ `MONO_EN(s2)`, `CAJA_EN(s2)`

- **SUBIR_A_CAJA(s)**
  - _Precondiciones:_ `MONO_EN(s)`, `CAJA_EN(s)`, `MONO_EN_SUELO()`
  - _Lista de borrado:_ `MONO_EN_SUELO()`
  - _Lista de adición:_ `MONO_SOBRE_CAJA()`

- **BAJAR_DE_CAJA**
  - _Precondiciones:_ `MONO_EN(s)`, `CAJA_EN(s)`, `MONO_SOBRE_CAJA()`
  - _Lista de borrado:_ `MONO_SOBRE_CAJA()`
  - _Lista de adición:_ `MONO_EN_SUELO()`

- **COGER_PLÁTANOS**
  - _Precondiciones:_ `MONO_EN(s)`, `CAJA_EN(s)`, `PLÁTANOS_EN(s)`, `MONO_SOBRE_CAJA()`
  - _Lista de borrado:_ `PLÁTANOS_EN(s)`
  - _Lista de adición:_ `TIENE_PLÁTANOS()`

**3. Estado Inicial (I)**
Basado en el enunciado:

- `MONO_EN(A)`
- `CAJA_EN(C)`
- `PLÁTANOS_EN(B)`
- `MONO_EN_SUELO()`

**4. Objetivo (G)**

- `TIENE_PLÁTANOS()`

# Ejercicio 5

Representar en el formalismo STRIPS el siguiente dominio: hay dos habitaciones conectadas en una de las cuales hay 𝑁 pelotas y un robot; el robot dispone de dos pinzas, con cada una de las cuales puede sujetar una sola pelota a la vez; se desea trasladar todas las pelotas a la otra habitación.

### Solución del Ejercicio 5: Robot, pinzas y pelotas

**1. Predicados**

- `ROBOT_EN(h)`: El robot está en la habitación `h`.
- `PELOTA_EN(p, h)`: La pelota `p` está suelta en la habitación `h`.
- `EN_PINZA_1(p)`: La pelota `p` está sujeta por la pinza 1.
- `EN_PINZA_2(p)`: La pelota `p` está sujeta por la pinza 2.
- `PINZA1_LIBRE()`: La pinza 1 del robot está vacía.
- `PINZA2_LIBRE()`: La pinza 2 del robot está vacía.
- `CONECTADA(h1, h2)`: Existe conexión entre la habitación `h1` y la `h2`.

**2. Acciones**

- **IR_A(h1, h2)**
  - _Precondiciones:_ `ROBOT_EN(h1)`, `CONECTADA(h1, h2)`
  - _Lista de borrado:_ `ROBOT_EN(h1)`
  - _Lista de adición:_ `ROBOT_EN(h2)`

- **COGER_PINZA_1(p, h)**
  - _Precondiciones:_ `ROBOT_EN(h)`, `PELOTA_EN(p, h)`, `PINZA1_LIBRE()`
  - _Lista de borrado:_ `PELOTA_EN(p, h)`, `PINZA1_LIBRE()`
  - _Lista de adición:_ `EN_PINZA_1(p)`

- **SOLTAR_PINZA_1(p, h)**
  - _Precondiciones:_ `ROBOT_EN(h)`, `EN_PINZA_1(p)`
  - _Lista de borrado:_ `EN_PINZA_1(p)`
  - _Lista de adición:_ `PELOTA_EN(p, h)`, `PINZA1_LIBRE()`

- **COGER_PINZA_2(p, h)**
  - _Precondiciones:_ `ROBOT_EN(h)`, `PELOTA_EN(p, h)`, `PINZA2_LIBRE()`
  - _Lista de borrado:_ `PELOTA_EN(p, h)`, `PINZA2_LIBRE()`
  - _Lista de adición:_ `EN_PINZA_2(p)`

- **SOLTAR_PINZA_2(p, h)**
  - _Precondiciones:_ `ROBOT_EN(h)`, `EN_PINZA_2(p)`
  - _Lista de borrado:_ `EN_PINZA_2(p)`
  - _Lista de adición:_ `PELOTA_EN(p, h)`, `PINZA2_LIBRE()`

**3. Estado Inicial (I)**
Asumiendo que empezamos en la habitación A y que hay $N$ pelotas ($p_1, p_2, \dots, p_N$):

- `ROBOT_EN(A)`
- `CONECTADA(A, B)`, `CONECTADA(B, A)`
- `PINZA1_LIBRE()`, `PINZA2_LIBRE()`
- `PELOTA_EN(p1, A)`, `PELOTA_EN(p2, A)`, ..., `PELOTA_EN(pN, A)`

**4. Objetivo (G)**
Todas las $N$ pelotas deben estar sueltas en la habitación B:

- `{ PELOTA_EN(p1, B), PELOTA_EN(p2, B), ..., PELOTA_EN(pN, B) }`

# Ejercicio 6

Representar en el formalismo STRIPS el siguiente dominio: hay varias ciudades, cada una de ellas conteniendo varias localizaciones, algunas de las cuales son aeropuertos; hay también camiones, que pueden moverse de una localización a
otra dentro de una misma ciudad, y aviones, que pueden volar entre aeropuertos; el objetivo es transportar diversos paquetes de ciertas localizaciones de partida a ciertas localizaciones de llegada, que pueden estar en la misma o en otra ciudad.

Has caído en una trampa muy común cuando se empieza a programar en STRIPS: **intentar incrustar matrices, subíndices matemáticos ($i, j, k$) y tipos de datos directamente en el nombre de las variables y predicados**.

En STRIPS clásico, el motor de planificación no entiende de "índices de ciudades" ni sabe qué es un "almacén_ij". En su lugar, el formalismo STRIPS emplea una estrategia mucho más elegante: utilizar **predicados unarios para definir las propiedades/tipos** de las cosas y **predicados binarios para definir las relaciones estáticas** entre ellas.

Aquí tienes los 3 errores de diseño principales de tu propuesta y cómo los vamos a solucionar:

1.  **Redundancia de ubicación (`PAQUETE_EN_ALMACEN` vs `PAQUETE_EN_AEROPUERTO`):** Un paquete simplemente "está en un sitio". No necesitas crear predicados ni acciones diferentes dependiendo de si el edificio en el que está es un almacén o un aeropuerto. Usaremos un único predicado genérico `EN(objeto, lugar)`.
2.  **El problema de la ciudad:** Para conseguir que un camión solo se mueva dentro de la misma ciudad, no hace falta indexar los almacenes. Basta con declarar como estado estático del problema un predicado binario llamado `MISMA_CIUDAD(l1, l2)` y ponerlo como precondición al mover el camión.
3.  **El problema del aeropuerto:** Para evitar que un avión aterrice en un almacén normal, simplemente creamos una "etiqueta" estática llamada `AEROPUERTO(l)` y obligamos a que el destino de un avión cumpla siempre esa precondición.

¡Fíjate en cómo se reduce y simplifica dramáticamente el problema al aplicar esta lógica! Como comentamos antes, este es un problema de "Nivel 3", por lo que **solo se exige modelar el dominio (predicados y acciones)**.

Aquí tienes la solución óptima y limpia:

### Solución del Ejercicio 6: Red logística de Camiones y Aviones

**1. Predicados**

- _Definición de tipos (Opcional en algunas versiones, pero muy recomendado para evitar errores lógicos):_
  - `CAMION(v)`: 'v' es un camión.
  - `AVION(v)`: 'v' es un avión.
  - `PAQUETE(p)`: 'p' es un paquete.
- _Propiedades y relaciones geográficas estáticas:_
  - `AEROPUERTO(l)`: La localización 'l' es de tipo aeropuerto.
  - `MISMA_CIUDAD(l1, l2)`: Las localizaciones 'l1' y 'l2' pertenecen a la misma ciudad.
- _Estados dinámicos:_
  - `EN(entidad, l)`: La entidad (puede ser un camión, avión o paquete) está físicamente en la localización 'l'.
  - `DENTRO_DE(p, v)`: El paquete 'p' está cargado dentro del vehículo 'v' (ya sea camión o avión).

**2. Acciones**

Al abstraer los tipos de vehículos, fíjate en que ¡incluso podemos unificar las acciones de cargar y descargar para que sirvan tanto a camiones como a aviones!

- **CONDUCIR(c, l1, l2)**: El camión se mueve dentro de una misma ciudad.
  - _Precondiciones:_ `CAMION(c)`, `EN(c, l1)`, `MISMA_CIUDAD(l1, l2)`
  - _Lista de borrado:_ `EN(c, l1)`
  - _Lista de adición:_ `EN(c, l2)`

- **VOLAR(a, l1, l2)**: El avión se mueve entre dos aeropuertos (no importa la ciudad).
  - _Precondiciones:_ `AVION(a)`, `EN(a, l1)`, `AEROPUERTO(l1)`, `AEROPUERTO(l2)`
  - _Lista de borrado:_ `EN(a, l1)`
  - _Lista de adición:_ `EN(a, l2)`

- **CARGAR(p, v, l)**: Carga un paquete en un vehículo.
  - _Precondiciones:_ `PAQUETE(p)`, `EN(p, l)`, `EN(v, l)`
  - _Lista de borrado:_ `EN(p, l)`
  - _Lista de adición:_ `DENTRO_DE(p, v)`

- **DESCARGAR(p, v, l)**: Descarga un paquete del vehículo en el que va.
  - _Precondiciones:_ `PAQUETE(p)`, `DENTRO_DE(p, v)`, `EN(v, l)`
  - _Lista de borrado:_ `DENTRO_DE(p, v)`
  - _Lista de adición:_ `EN(p, l)`

---

**Nota sobre Estado Inicial y Objetivo:**
Dado que es un modelo genérico, no hace falta que escribas las fórmulas con sumatorios e índices. Si tuvieras que especificar en un examen cómo se expresaría un objetivo genérico, bastaría con usar la misma nomenclatura sencilla que aprendimos con el problema de las pelotas: enumerar el destino deseado para $N$ paquetes.

- _Objetivo (G):_ `{ EN(p1, Destino1), EN(p2, Destino2), ..., EN(pN, DestinoN) }`
