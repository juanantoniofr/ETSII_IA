<link rel="stylesheet" href="../../../docs/css/estilo.css">

# Gymnasium

¡Hola! Es completamente normal que la documentación técnica de una biblioteca como Gymnasium parezca un poco abstracta al principio. La mejor forma de entenderla es, precisamente, "aterrizar" esos conceptos en un problema concreto como el tuyo: el clásico problema del mundo cuadrícula (Gridworld) de 3x4.

Aquí tienes la traducción de esas clases y funciones al comportamiento de tu robot.

## 1. La Biblioteca Base: El Entorno

**Clase `Env**`: Esta es la plantilla principal donde vas a programar toda la lógica de tu cuadrícula. Piensa en ella como el "tablero de juego" que contiene todas las reglas.

- **Método `reset**`: Esto es el botón de "Nueva Partida". Cuando lo llames, el entorno debe colocar a tu robot en la celda de inicio (por ejemplo, la inferior izquierda) y devolver esa posición inicial.

- **Método `step**`: Es el "motor" del tiempo. Cuando el robot decide moverse (por ejemplo, "ir arriba"), se lo pasas a este método. ¿Qué hace `step` internamente en tu problema?

1. Calcula a dónde se mueve realmente el robot teniendo en cuenta la probabilidad (80% de ir donde quiere, 10% de desviarse a un lado, 10% de desviarse al otro).
2. Comprueba si se choca contra un borde o contra la celda bloqueada de la fila 2 / columna 2 (en cuyo caso, se queda donde está).
3. Calcula la recompensa: **-1** si cayó en la celda trampa debajo del objetivo, o **-0.04** si cayó en cualquier otra.
4. Devuelve el nuevo estado, la recompensa y si el episodio ha terminado (por ejemplo, si llegó a la meta).

- **Atributo `np_random**`: Es el dado virtual de tu entorno. Es indispensable para tu problema porque lo usarás dentro del método `step` para simular ese 0.8 y 0.1 de probabilidad al moverse.

---

## 2. Módulo `spaces`: Definiendo las Reglas del Tablero

Gymnasium necesita saber exactamente qué formato tienen las acciones que puede tomar el robot y cómo se representan las casillas. Para eso sirve la **Clase `Space**` y sus clases derivadas:

- **Clase `Discrete**`: Sirve para representar conjuntos de números enteros. En tu caso, es **perfecta para las acciones**. Como el robot tiene 4 movimientos posibles (arriba, abajo, izquierda, derecha), definirías el espacio de acciones como un espacio discreto de 4 elementos (`Discrete(4)`).

- **Clase `Box**`: Sirve para definir coordenadas dentro de unos límites (intervalos). Es **ideal para representar el estado (la posición del robot)**. Podrías definir la cuadrícula como una "caja" matemática donde el mínimo (`low`) es la coordenada `[0, 0]` y el máximo (`high`) es la coordenada `[2, 3]`(para las 3 filas y 4 columnas). Además, usarías`dtype` entero, ya que no hay medias casillas.

- **Clase `Dict**`: Te permite combinar varios espacios en un diccionario. Si tu estado fuera más complejo (por ejemplo, la posición del robot Y además la cantidad de batería que le queda), usarías esto para agrupar ambos datos.

- **Métodos útiles (`contains`, `sample`, `seed`)**:
- `sample` te permite elegir una acción completamente al azar, lo cual es muy útil cuando el robot está empezando a explorar la cuadrícula y aún no sabe qué hacer.

- `contains` te sirve para verificar si una coordenada generada está dentro del tablero válido.

- `seed` asegura que la aleatoriedad sea reproducible (útil para que los experimentos den el mismo resultado si los repites).

---

## 3. Módulo `wrappers`: Las Herramientas de Medición

Las envolturas (wrappers) son "capas" que le pones a tu entorno por fuera para añadirle funcionalidades sin tener que modificar el código de tu cuadrícula original.

- **Clase `RecordEpisodeStatistics**`: Es como el contador de puntos del robot. Como el robot recibe un castigo de -0.04 por cada paso, su objetivo es dar los menos pasos posibles. Este wrapper sumará todos esos -0.04 y los -1 automáticamente para decirte cuánta recompensa total acumuló el robot en un intento. Guardará estos datos usando el parámetro `buffer_length` para que puedas analizar los episodios más recientes.

- **Clase `TimeLimit**`: Es un cronómetro de seguridad. Si el robot es torpe (o el agente aún no ha aprendido) podría quedarse rebotando entre dos paredes para siempre y el episodio nunca terminaría. Esta envoltura le dice al entorno: *"Si llevas más de X pasos (el parámetro `max_episode_steps`), corta el intento y empieza uno nuevo"\*.
