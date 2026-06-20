# Aprendizaje por refuerzo

## Método de montecarlo

Has entendido perfectamente el escenario del problema: al no tener el "mapa interno del entorno" (las funciones de probabilidad de transición $P$ ni las recompensas $R$), el agente está ciego y los algoritmos clásicos que usaban ecuaciones matemáticas interconectadas ya no sirven.

El primer "clic" mental que debes hacer para entender el método de Montecarlo es **el cambio de la función $U(s)$ a la función $q(s,a)$**.
En los métodos anteriores calculábamos el valor de un estado ($U(s)$) y usábamos las probabilidades $P$ para deducir qué acción era mejor. Como ahora no tenemos $P$, Montecarlo no puede calcular $U(s)$, sino que tiene que estimar directamente **$q(s,a)$**: la utilidad esperada de aplicar una acción concreta $a$ estando en un estado $s$.

Para encontrar la política óptima usando ensayo y error, el método de Montecarlo intercala la evaluación empírica con la mejora de la política en un proceso cíclico:

**1. Inicialización en blanco**
El agente arranca con una tabla de valores $q(s,a)$ inicializada a 0 para todos los pares estado-acción, y con una política inicial aleatoria. También prepara listas vacías para ir guardando el historial de ganancias de cada par.

**2. Generar un episodio completo ("Jugar una partida completa")**
A diferencia de los métodos anteriores que calculaban estado a estado resolviendo ecuaciones, el método de Montecarlo **no es local**: necesita jugar partidas enteras para aprender.
Pones al agente en un estado inicial y le dejas interactuar con el entorno siguiendo una política $\epsilon$-voraz (es decir, casi siempre usa la mejor acción que conoce, pero a veces elige una al azar para explorar) `. El agente sigue avanzando hasta que choca obligatoriamente con un **estado terminal** (el fin del juego) `.
Al terminar, tienes una secuencia real grabada: $(s_0, a_0, R_0), (s_1, a_1, R_1) \dots$ `.

**3. Evaluación empírica retrospectiva**
Una vez finalizado el episodio, el algoritmo viaja "hacia atrás" revisando la secuencia. Para cada estado y acción que haya ejecutado (por ejemplo, estar en $s_1$ y hacer $a_2$), el algoritmo mira **cuánta recompensa real acumuló desde ese instante exacto hasta que terminó el juego**, aplicándole el factor de descuento ($\gamma$) a los pasos futuros.

**4. Actualizar la tabla $q$ mediante promedios**
Esa utilidad total conseguida en el paso anterior se guarda en la memoria del par $(s_1, a_2)$. El algoritmo recalcula el valor $q(s_1, a_2)$ haciendo **la media aritmética** de todas las utilidades reales que ha recolectado en todos los episodios pasados donde ejecutó esa misma acción en ese mismo estado.
Gracias a la Ley Fuerte de los Grandes Números, si el agente juega suficientes partidas, esa simple media matemática acabará convergiendo al valor real y exacto que tiene esa acción.

**5. Mejora Voraz de la Política**
Inmediatamente después de actualizar los números de la tabla $q$, el algoritmo actualiza su política para los estados que acaba de visitar. Simplemente mira la tabla y hace un $arg\ m\hat{a}x$: **"De todas las acciones que he probado en el estado $s$, ¿cuál tiene ahora mismo la media $q$ más alta?"** `. Esa acción se convierte en la nueva directriz de la política para ese estado `.

**Resumen del ciclo:**
El agente juega un episodio hasta el final $\rightarrow$ Calcula exactamente cuánto ganó desde cada paso $\rightarrow$ Hace la media de esas ganancias en su tabla $q(s,a)$ $\rightarrow$ Actualiza su política escogiendo la acción con la media más alta $\rightarrow$ Vuelve a jugar otro episodio.

Repitiendo este proceso de experimentar, promediar ganancias y ajustar la política miles de veces, el agente termina descubriendo empíricamente la política óptima $\pi^*$ sin haber conocido jamás las reglas ocultas del entorno.

## Método de las difereferencias temporales

¡Exactamente! Has dado con la clave del funcionamiento del algoritmo. El método **"inventa"** temporalmente ese valor futuro, algo que en la teoría formal se denomina usar una **estimación** ``.

A diferencia de Montecarlo, que espera pacientemente a que termine la partida para conocer la verdad absoluta de la historia, el método de las diferencias temporales **consulta su propia memoria** para ver qué valor numérico tiene guardado en ese preciso instante para el estado destino $s_{t+1}$, y lo usa como si fuera un hecho seguro ``.

El proceso de esta "invención" funciona así:

1. Antes de que el agente empiece a moverse por el entorno, se inicializa su tabla de utilidades con valores completamente arbitrarios (generalmente ceros o números aleatorios) ``.
2. Al dar el salto de $s_t$ a $s_{t+1}$, el entorno le da un golpe de realidad inmediato entregándole una recompensa $R_t$.
3. Para evaluar cómo de buena ha sido esa jugada sin tener que seguir jugando hasta el final, el agente **mira su tabla de valoraciones actual y extrae su propia "adivinanza" del estado en el que acaba de caer ($U(s_{t+1})$)** ``.
4. Finalmente, suma esa verdad a corto plazo ($R_t$) con su invención a largo plazo ($\gamma U(s_{t+1})$), y usa ese cóctel para corregir y actualizar el valor del estado que acaba de abandonar ($U(s_t)$) ``.

**¿Por qué funciona si al principio está adivinando basándose en ceros?**
Durante los primeros pasos, sus invenciones son pésimas y totalmente erróneas. Sin embargo, conforme el agente explora y choca repetidamente contra los estados terminales del juego (donde la recompensa real es definitiva y no hay nada más que adivinar), esos valores reales exactos empiezan a "contagiarse" hacia los estados inmediatamente anteriores.

Paso a paso, cada estado va actualizando su valor apoyándose en la estimación de su vecino, de forma que los valores reales fluyen como una ola desde el final del juego hacia el principio. La teoría matemática nos garantiza que **estas estimaciones basadas en otras estimaciones acaban convergiendo con total seguridad hacia la utilidad real óptima** ($U^*$ o $q^*$), siempre y cuando se ajuste correctamente la tasa de aprendizaje ($\alpha$) a lo largo del tiempo ``.

Esa es precisamente la mayor innovación de las diferencias temporales: el agente **aprende haciendo predicciones basadas en sus propias predicciones anteriores**, corrigiendo continuamente su nivel de error gracias a la pequeña porción de realidad que recolecta en cada paso ($R_t$) ``.

## Algoritmo Q-Learning

El algoritmo **Q-learning** es la culminación de los conceptos que hemos ido viendo. Es, de hecho, una variante específica y muy potente dentro de la familia de los algoritmos de **Diferencias Temporales (DT)**.

Su enfoque principal es encontrar directamente la **función de utilidad óptima de pares estado-acción ($q^*$)** mediante ensayo y error, interactuando con el entorno paso a paso.

Para entender en qué se diferencia, vamos a compararlo con los tres métodos anteriores:

**1. Diferencia con la Programación Dinámica (Iteración de valores/políticas)**
Al igual que todos los métodos de aprendizaje por refuerzo, Q-learning **no necesita el mapa del juego**. No requiere conocer las probabilidades de transición ($P$) ni las recompensas del sistema ($R$) de antemano; aprende a ciegas moviéndose por el entorno.

**2. Diferencia con el método de Montecarlo**
Mientras Montecarlo tiene que jugar el episodio entero hasta llegar a un estado terminal para poder actualizar su tabla, Q-learning actualiza su conocimiento **"al vuelo" en cada paso**. Ejecuta una acción, mira la recompensa inmediata ($R_t$), mira la tabla para ver el valor estimado del estado en el que ha aterrizado, y actualiza el estado que acaba de dejar.

**3. La diferencia CRUCIAL: El operador máximo y la independencia de la política**
La verdadera magia de Q-learning, y lo que lo separa del resto, es una característica matemática que la teoría define así: **aproxima la utilidad óptima con independencia de la política seguida**.

Para entender esto, mira la ecuación de actualización que usa el algoritmo en cada paso:
$q(s_t, a_t) \leftarrow q(s_t, a_t) + \alpha(R_t + \gamma \mathbf{\max_{a'} q(s_{t+1}, a')} - q(s_t, a_t))$

Fíjate en ese operador $\mathbf{\max_{a'}}$ insertado en la estimación del futuro. Esto tiene un impacto conceptual enorme:

- Para poder descubrir cosas nuevas, el agente de Q-learning se mueve usando una política $\epsilon$-voraz (es decir, a veces hace la jugada óptima, pero de vez en cuando **elige una acción aleatoria para explorar**).
- En otros algoritmos, si el agente hace un movimiento aleatorio estúpido para explorar, la penalización de ese error mancha el valor del estado anterior.
- Sin embargo, gracias al operador $m\hat{a}x$, Q-learning separa cómo se mueve de cómo aprende. Aunque hoy esté explorando dando tumbos, a la hora de actualizar sus matemáticas **asume siempre que, a partir del próximo paso, jugará a la perfección** (eligiendo la acción $a'$ que le dé el máximo valor en el estado $s_{t+1}$).

**En resumen:**
El enfoque de Q-learning le permite explorar el entorno de forma muy agresiva o aleatoria sin que esas malas decisiones temporales "envenenen" su tabla matemática. Aprende a tropezones (como Montecarlo), actualiza paso a paso (como Diferencias Temporales) pero evalúa el futuro como si fuera perfecto (como la Iteración de Valores) `. Una vez que el algoritmo termina de iterar, solo tienes que mirar la tabla $q$ y extraer la política voraz definitiva`.

### Ejemplo de actualización de la tabla q

Vamos a verlo con un caso práctico numérico paso a paso basado en el Ejercicio 8 de los apuntes. Tenemos un sistema con 4 estados ($s_1, s_2, s_3, s_4$) y 2 acciones posibles ($a_1, a_2$).

**Las condiciones iniciales de nuestro agente:**

- Al no saber nada del mundo, **toda la tabla $q(s,a)$ empieza en 0** para todos los estados y acciones.
- Factor de descuento: **$\gamma = 0.9$**.
- Tasa de aprendizaje (cómo de rápido sustituimos el valor viejo por el nuevo): **$\alpha = 0.5$**.

La fórmula que vamos a aplicar tras cada paso es:
$q(s, a) \leftarrow q(s, a) + 0.5 \cdot [R + 0.9 \cdot \mathbf{\max_{a'} q(s', a')} - q(s, a)]$

Imagina que dejas al agente interactuar y genera esta primera secuencia de experiencia real:
$s_1 \xrightarrow{a_1, R=10} s_2 \xrightarrow{a_1, R=20} s_3 \xrightarrow{a_2, R=30} s_4 \xrightarrow{a_1, R=70} s_1$.

Veamos cómo se actualiza su "cerebro" al vuelo:

**Paso 1: Estando en $s_1$, aplica $a_1$, gana 10 puntos y cae en $s_2$.**
El algoritmo pausa y actualiza el par que acaba de dejar ($s_1, a_1$). Para estimar el futuro, mira los valores actuales de su destino ($s_2$). Como acaba de empezar a jugar, las acciones desde $s_2$ valen 0.
$q(s_1, a_1) = 0 + 0.5 \cdot [10 + 0.9 \cdot \max(0, 0) - 0] = \mathbf{5}$

**Paso 2: Estando en $s_2$, aplica $a_1$, gana 20 puntos y cae en $s_3$.**
Vuelve a mirar el futuro (las acciones desde $s_3$), que siguen valiendo 0.
$q(s_2, a_1) = 0 + 0.5 \cdot [20 + 0.9 \cdot \max(0, 0) - 0] = \mathbf{10}$

**Paso 3: Estando en $s_3$, aplica $a_2$, gana 30 puntos y cae en $s_4$.**
Misma situación, el futuro en $s_4$ todavía es 0.
$q(s_3, a_2) = 0 + 0.5 \cdot [30 + 0.9 \cdot \max(0, 0) - 0] = \mathbf{15}$

**Paso 4: ¡Aquí ocurre la magia! Estando en $s_4$, aplica $a_1$, gana 70 puntos y vuelve a caer en $s_1$.**
Ahora, al evaluar su futuro (el estado destino $s_1$), **su tabla ya no está vacía**. El agente busca en su memoria y ve que en el Paso 1 actualizó el valor de $q(s_1, a_1)$ a 5. El otro valor posible, $q(s_1, a_2)$, sigue siendo 0.
Aplica el operador máximo sobre ese futuro: $\max(5, 0) = \mathbf{5}$.
Sustituimos en la fórmula para actualizar $s_4$:
$q(s_4, a_1) = 0 + 0.5 \cdot [70 + 0.9 \cdot (\mathbf{5}) - 0]$
$q(s_4, a_1) = 0.5 \cdot [70 + 4.5] = \mathbf{37.25}$

Como puedes ver claramente en este último paso, el algoritmo Q-learning **no ha necesitado esperar a que acabe el juego**, ni necesita conocer las probabilidades de transición. Simplemente ha cogido la recompensa enorme que acaba de descubrir hoy ($R=70$) y le ha sumado un "préstamo" del valor futuro que él mismo había aprendido tres pasos atrás ($q=5$), actualizando al instante su tabla para saber que hacer $a_1$ estando en $s_4$ es una decisión fantástica (valor de 37.25).
