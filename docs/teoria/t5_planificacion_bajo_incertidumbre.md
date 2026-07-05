<link rel="stylesheet" href="../css/estilo.css" type="text/css" />

# Planificación bajo incertidumbre

## Algunos conceptos fundamentales

### A. Diferencias fundamentales con la planificación clásica:

- Paso a contemplar **efectos no deterministas de las acciones**.
- Los **planes se conciben como políticas de acciones**, no como secuencias estáticas.
- El objetivo es la **optimización de políticas** maximizando funciones de utilidad.

### B. Procesos de decisión de Markov (MDP):

- Definición basada en una tupla **(S, A, P)**: estados finitos, acciones finitas y una distribución de probabilidad de transición $P_a(s'|s)$.
- **Políticas ($\pi$)**: Asignación que indica qué acción aplicar en cada posible estado.
- **Historias ($h$)**: Sucesión infinita de estados generada en la ejecución de una política, y cálculo de su probabilidad inducida asumiendo la propiedad de Markov.

### C. Utilidades y Recompensas:

- Definición de funciones de **recompensa ($R$) y costes ($C$)** de las acciones.
- Introducción de un **factor de descuento ($\gamma$)** para asegurar que los valores de las utilidades futuras se mantengan acotados y no tiendan al infinito.
- **Utilidad esperada de un estado ($U_\pi(s)$)**, calculada como solución a un sistema de ecuaciones lineales.

### D. Búsqueda de la Optimalidad:

- Concepto de máxima utilidad esperada ($U^*(s)$) regida por las **Ecuaciones de Bellman** (ecuaciones no lineales).
- Cómo derivar una **política óptima ($\pi^*$)** a partir de las utilidades máximas.

### E. Algoritmos de cálculo con conocimiento completo del sistema:

- **Algoritmo de iteración de valores**: Genera funciones de utilidad de manera iterativa hasta cumplir un criterio de parada matemático.
- **Algoritmo de iteración de políticas**: Genera una secuencia de políticas que va mejorando mediante la resolución sucesiva de sistemas de ecuaciones lineales.

## Resumen de la lógica matemática del modelo de planificación bajo incertidumbre

Tenemos, por una parte la probabilidad de que una historia ocurra, por otra la utilidad de esa historia como el valor suma de todas las recompensas y costes que irás recolectando paso a paso hacia el futuro a lo largo de esa línea temporal en concreto, y si nos proyectamos al futuro con todas las posibles historias penalizando los estados lejanos con el factor de descuento, estamos hablando de la utilidad de un determinado estado.

Reuniendo todas las piezas tal, la construcción teórica es exactamente esta:

- 1. Tomas una de las ramas del futuro (una historia) y evalúas su **utilidad individual ($U(h|\pi)$)**, sumando las recompensas de todos sus pasos pero aplicando el **factor de descuento ($\gamma$)** para penalizar matemáticamente las recompensas lejanas y asegurar que el total sea un valor acotado.
- 2. Calculas la **probabilidad inducida ($\mathbb{P}(h|\pi)$)** de que el azar del entorno te lleve exactamente por esa secuencia temporal.
- 3. Te **proyectas al futuro con todas las posibles historias distintas** que pueden originarse desde el estado en el que estás.
- 4. Al ponderar (multiplicar) la utilidad de cada una de esas historias por su probabilidad de ocurrir y sumarlas todas, el resultado matemático que obtienes es precisamente la **Utilidad esperada de ese estado determinado ($U_\pi(s)$)**.

Esa cifra global consolida todos los futuros posibles y te da el valor real de estar en ese estado. De hecho, el objetivo final de todos los algoritmos de resolución (como la iteración de valores o la iteración de políticas) es maximizar precisamente ese valor para encontrar la **política óptima ($\pi^*$)**: aquella que te asegure la mayor utilidad esperada independientemente de los contratiempos del entorno.

## El salto a los sistemas de ecuaciones

Como hemos visto, la utilidad de un estado evalúa todo el futuro que se abre a partir de él. Por tanto, la ecuación establece una **interdependencia geométrica**: la utilidad esperada del estado actual $s$ se calcula en función de la utilidad esperada de los posibles estados futuros $s'$ a los que el sistema puede transitar tras aplicar la acción.

Al observar la fórmula ($U(s) = R(s, \pi(s)) + \gamma \sum P_{\pi(s)}(s'|s)U(s')$), verás que **el término $U$ aparece a ambos lados de la igualdad** `. Para saber el valor de un estado, necesitas saber cuánto vale el futuro en sus estados vecinos; pero esos vecinos dependen a su vez de otros estados, formando una red donde la influencia puede incluso ser circular (volver al estado inicial) `.

Dado que no puedes calcular ningún estado de forma aislada, **las utilidades de todos los estados del sistema se convierten simultáneamente en las incógnitas** que queremos averiguar.

Al aplicar esta regla a todos y cada uno de los estados posibles del dominio, **se conforma de manera natural un sistema de ecuaciones lineales cerrado** `. Por ejemplo, en el caso del robot que se mueve por 5 localizaciones que muestran los apuntes, se genera exactamente un sistema con 5 ecuaciones interconectadas y 5 variables a despejar ($U(s_1)$ a $U(s_5)$) `. Al resolver este bloque de ecuaciones de forma conjunta, logras desentrañar el valor exacto de la utilidad esperada para cada rincón del problema bajo esa política.

## Buscando la política óptima

Efectivamente, el objetivo final es alcanzar la **máxima utilidad esperada de un estado ($U^*(s)$)**, lo que nos garantiza descubrir la **política óptima ($\pi^*$)**: aquella que supera o iguala a todas las demás.

Sin embargo, el método no consiste en probar "por fuerza bruta" todas las políticas posibles una por una. Como la cantidad de políticas posibles crece de forma exponencial (está acotada por $|A|^{|S|}$, es decir, el número de acciones elevado al número de estados), iterar sobre todas ellas sería computacionalmente inviable en problemas reales.

Para lograr esta maximización de forma eficiente, la teoría utiliza dos algoritmos inteligentes de programación dinámica:

1. **Algoritmo de iteración de políticas:** Este método sí trabaja resolviendo sistemas de ecuaciones. Comienza con una política inicial aleatoria y resuelve su **sistema de ecuaciones lineales** para averiguar la utilidad actual de los estados. Una vez tiene esos resultados, "mejora" la política evaluando estado por estado y escogiendo la acción que maximiza la utilidad local. Al tener una política nueva, vuelve a plantear y resolver el nuevo sistema de ecuaciones, repitiendo el ciclo **hasta que la política deja de cambiar**, momento en el que se garantiza haber alcanzado la política óptima.

2. **Algoritmo de iteración de valores:** Este método aborda el problema sin resolver sistemas de ecuaciones en cada ciclo. En su lugar, se basa directamente en las **Ecuaciones de Bellman**. A diferencia del sistema lineal que vimos antes, las ecuaciones de Bellman son **no lineales porque introducen un operador de maximización ($m\hat{a}x_{a \in A(s)}$)** dentro de la propia fórmula. El algoritmo actualiza iterativamente una tabla de valores numéricos para cada estado, asumiendo en cada paso que siempre se toma la acción que da la ganancia máxima, hasta que los valores se estabilizan (criterio de parada). Solo tras alcanzar esa estabilidad matemática, se deriva la política final.

En resumen: no iteramos a ciegas sobre el conjunto de todas las políticas posibles, sino que usamos las herramientas del cálculo numérico (ya sea resolviendo sistemas lineales sucesivos o iterando las ecuaciones no lineales de Bellman) para **ir puliendo la solución de manera guiada hasta chocar con el techo matemático ($U^*$)**.

<div class="highlight-theory">

### Algoritmo de iteración de valores

Verificando tus pasos con la teoría, el esqueleto del algoritmo hace justo lo que propones:

1. **Inicialización:** Empiezas inicializando arbitrariamente $U_0$ para todos los estados ``.
2. **Iteración:** Calculas $U_{i+1}$ basándote en los valores de $U_i$ usando la ecuación de Bellman, aplicando en cada paso el operador para quedarte con el valor máximo ``.
3. **Criterio de parada:** Repites el ciclo hasta que se cumple la estabilización matemática, es decir, cuando el cambio máximo entre $U_i$ y $U_{i-1}$ para todos los estados es estrictamente menor a un valor mínimo prefijado (conocido como $\epsilon$) ``.
4. **Construcción de la política:** Una vez que se alcanza ese punto de parada, extraes la política óptima $\pi^*$ evaluando cada estado y eligiendo la acción (el $arg\ m\hat{a}x$) que maximiza esa ecuación con las utilidades finales ``.

**¿Por qué se estabilizan obligatoriamente los valores de $U_i$?**

La razón fundamental que garantiza esta convergencia es el **factor de descuento ($\gamma$)** ``.

Recordemos que $\gamma$ es un valor comprendido entre 0 y 1 ($0 < \gamma < 1$) ``. Cada vez que el algoritmo de iteración de valores realiza un nuevo ciclo (calcula $U_2, U_3, U_4...$), lo que está haciendo conceptualmente es proyectar su visión un paso temporal más hacia el futuro.

Al proyectarse hacia adelante, las recompensas de esos pasos futuros se van multiplicando iterativamente por el factor de descuento elevado a potencias cada vez mayores ($\gamma^1, \gamma^2, \gamma^3...$) `. Puesto que $\gamma$ es una fracción, **las aportaciones numéricas de esos horizontes temporales distantes se vuelven exponencialmente pequeñas**, acercándose a cero `.

Esto logra que la ecuación se comporte como una serie geométrica convergente. La teoría demuestra que la utilidad esperada nunca va a tender a infinito ni va a "explotar", sino que está limitada por una **cota superior finita máxima** (cuyo límite es $\frac{R_{max}}{1-\gamma}$) ``.

Gracias a esto, llegará inevitablemente una iteración en la que el impacto numérico de mirar un paso extra hacia el futuro será tan minúsculo que la diferencia entre $U_i$ y $U_{i-1}$ pasará a ser menor que tu margen de error prefijado $\epsilon$ `. En ese instante, los valores se estabilizan, asegurándole al algoritmo que ha chocado con el techo óptimo y puede terminar con éxito `.

</div>

<div class="summary">

**Resumen: Algoritmo de Iteración de Valores en Procesos de Decisión de Markov**

Este algoritmo es un método de programación dinámica para encontrar la política óptima ($\pi^*$) en entornos bajo incertidumbre, basándose en la actualización progresiva del valor de utilidad de cada estado.

**1. El Concepto Principal: Ecuaciones de Bellman**

A diferencia del algoritmo de Iteración de Políticas (que resuelve sistemas cerrados de ecuaciones lineales en cada ciclo evaluando una lista de acciones concreta), la iteración de valores utiliza las **Ecuaciones de Bellman** `. Estas son **ecuaciones no lineales** porque introducen el operador de maximización (max) directamente en la fórmula, evitando resolver sistemas complejos paso a paso `.

**2. El Bucle Iterativo (Mirando al Futuro)**

El algoritmo procesa iterativamente una tabla de números, donde cada paso expande el "horizonte de cálculo" del agente un paso más hacia el futuro:

- **Inicialización:** Comienza con una "estimación ciega" arbitraria de la utilidad de todos los estados ($U_0$).
- **Actualización ($U_{i+1}$):** Para cada estado, prueba todas las acciones sumando la recompensa inmediata de aplicarla hoy y el futuro descontado estimado (basado en la tabla de la iteración anterior $U_i$).
- **Operador $m\hat{a}x$:** El sistema evalúa el sumatorio de todas las acciones y **se queda únicamente con el valor numérico más alto**. Para maximizar la eficiencia computacional en memoria, durante esta fase **el algoritmo olvida qué acción generó ese número**, actualizando solo el diccionario de utilidades.

**3. La Convergencia y el Factor de Descuento ($\gamma$)**

El proceso iterativo no explota hacia el infinito gracias al **factor de descuento ($0 < \gamma < 1$)**.

- Este factor reduce exponencialmente el peso de las recompensas futuras, acotando el valor esperado máximo de cualquier historia al límite matemático finito de $\frac{R_{max}}{1-\gamma}$.
- **Criterio de parada:** Gracias a esta cota geométrica, llegará un momento en el que proyectarse un paso más al futuro aportará un impacto numérico minúsculo. Cuando el cambio máximo entre la iteración $U_{i}$ y $U_{i-1}$ es estrictamente menor a un umbral prefijado ($\epsilon$), **la tabla de utilidades se estabiliza** y el bucle termina.

**4. Extracción de la Política Óptima ($\pi^*$)**

El error más común es intentar deducir las mejores acciones revisando el comportamiento en iteraciones tempranas ($U_0, U_1$).

- Una vez que el sistema se estabiliza (ej: en $U_N$), **las tablas de iteraciones anteriores quedan obsoletas y se descartan**.
- El algoritmo fija la **única tabla final estabilizada** y ejecuta un cálculo aislado.
- **Operador $arg\ m\hat{a}x$:** Se vuelven a evaluar todas las acciones posibles en la ecuación de Bellman utilizando exclusivamente los valores de la tabla definitiva. En este momento sí nos quedamos con la **"identidad de la acción"** que da el valor máximo, configurando así la política final.

**Truco de comprobación para ejercicios escritos**

Dado que la ecuación interna de evaluación es idéntica en el bucle y en el cierre, los resultados deben ser coherentes: **La acción que selecciones en tu $arg\ m\hat{a}x$ final tiene que coincidir obligatoriamente con la acción que te proporcionó el valor numérico máximo en tu última iteración manual**. Si no coincide (y no hay empate matemático), es garantía de que se ha cometido un error aritmético al calcular esa fila.

**Desglose de la ecuación de Bellman**

Cuando decimos "**Actualización ($U_{i+1}$):** Para cada estado, prueba todas las acciones sumando la recompensa inmediata de aplicarla hoy y el futuro descontado estimado (basado en la tabla de la iteración anterior $U_i$).", estamos describiendo la ecuación de Bellman:

Esa frase es simplemente la **traducción a palabras de la parte interna de la ecuación de Bellman**, que es el motor del algoritmo: $R(s,a) + \gamma \sum P_a(s'|s)U_i(s')$.

Vamos a desglosar exactamente qué significa esta frase separándola en sus dos bloques conceptuales:

**1. "La recompensa inmediata de aplicarla hoy"**
Se refiere al término **$R(s,a)$** de la ecuación. Al evaluar una acción, lo primero que mira el sistema es la consecuencia directa e instantánea que se produce al ejecutarla.
Por ejemplo, si un robot decide moverse, ejecutar ese movimiento puede suponer un gasto de energía instantáneo (un coste $C=1$), o quizás al dar ese paso entra en una casilla de victoria y recibe su premio (una recompensa $R=100$). Esta parte no especula con el futuro, es el pago instantáneo y seguro por dar el paso "hoy".

**2. "El futuro descontado estimado"**
Se refiere al término de la derecha: **$\gamma \sum P_a(s'|s) U_i(s')$**. Una acción no solo otorga un premio inmediato, sino que altera la posición del sistema dejándolo en uno o varios posibles estados resultantes mañana ($s'$).

- Decimos que es el **futuro** porque el sumatorio calcula **la esperanza matemática** de a qué estados destino te llevará esa acción (ponderando por la probabilidad $P_a$ de que los efectos no deterministas salgan bien o mal).
- Decimos que es **estimado** porque, como el algoritmo se encuentra dando vueltas en un bucle iterativo, todavía no conoce el valor real y definitivo de esos estados futuros ($U^*$). Lo que hace es tomar prestados los valores numéricos que calculó en la iteración inmediatamente anterior ($U_i$), usándolos como su mejor "adivinanza" temporal.
- Decimos que es **descontado** porque multiplicamos todo ese bloque futuro por el factor $\gamma$ (ej. $0.9$) para reducir su peso y priorizar el presente.

**En resumen:**
Para saber si una acción es la mejor, el algoritmo pone dos cosas en una balanza: **"¿Qué gano o sufro en este preciso instante por ejecutarla?"** (recompensa inmediata) sumado a **"¿En qué posición me deja esta acción para seguir jugando mañana, según lo que he calculado hasta ahora?"** (futuro descontado estimado). Sumando ambas mitades, obtiene el valor total de esa acción y ya puede compararla con las demás aplicando el operador máximo ($m\hat{a}x$).

</div>

<div class="highlight-theory">

**Algoritmo de iteración de políticas**

El truco para entender la iteración de políticas es pensar en ella como un ciclo constante de **"evaluar y mejorar"**.

La secuencia mental del algoritmo funciona así:

**1. Evaluación (El paso que ya tienes)**
Comenzaste con una política aleatoria inicial (llamémosla $\pi_0$). Al resolver el sistema de ecuaciones lineales para esa política en concreto, has obtenido como resultado una **tabla de valores numéricos ($U_0$)**. Esa tabla te dice exactamente qué utilidad conseguirás si el agente sigue estrictamente esa política &pi; hacia el futuro.

**2. Mejora de la política (El siguiente paso)**
Ahora te preguntas: _"Sabiendo que el futuro vale lo que dice mi tabla U<sub>0</sub>, ¿puedo tomar mejores decisiones?"_.
Para responderlo, el algoritmo evalúa estado por estado aplicando el operador **$arg max$**, exactamente igual que hacíamos al final del algoritmo de iteración de valores.

Para un estado $s$, pruebas **todas las acciones posibles** aplicando la fórmula interna de Bellman pero utilizando tu recién calculada tabla U<sub>0</sub>:
$R(s,a) + \gamma \sum P_a(s'|s) U\_0(s')$

Te quedas con la acción que te dé el valor más alto. Al repetir esto para todos los estados, habrás generado una **nueva política de acciones actualizada (llamémosla $\pi_1$)**.

**3. Criterio de parada (¿Qué hacemos ahora?)**
Aquí el algoritmo compara la nueva política ($\pi_1$) con la vieja ($\pi_0$) y pueden ocurrir dos cosas:

- **Si son diferentes ($\pi_1 \neq \pi_0$):** Significa que el algoritmo ha descubierto un plan de acción mejor. Entonces, **el bucle vuelve a empezar**. Tomas tu nueva política $\pi_1$, planteas un **nuevo sistema de ecuaciones lineales** basado únicamente en estas nuevas acciones, lo resuelves para obtener una nueva tabla numérica ($U_1$), y usas $U_1$ para intentar extraer una política aún mejor ($\pi_2$).
- **Si son exactamente iguales ($\pi_1 = \pi_0$):** ¡El algoritmo termina! `. Si después de reevaluar todos los estados con tus nuevos números, resulta que la lista de acciones ganadoras es idéntica a la que ya tenías, significa que has llegado a un punto de estabilización temporal donde la política ya no puede mejorar más. Has encontrado matemáticamente la **política óptima ($\pi^*$)**`.

**En resumen visual de la diferencia:**
Mientras que la _iteración de valores_ daba miles de vueltas actualizando una tabla de números y solo sacaba la política de acciones al final del todo, la **iteración de políticas** da vueltas actualizando directamente la lista de acciones, deteniéndose a resolver un sistema de ecuaciones completo en cada salto para comprobar si esa lista ha dejado de cambiar.

</div>

<div class="summary">

Tu razonamiento general es **excelente y demuestra que has captado perfectamente el flujo estratégico** del problema en Procesos de Decisión de Markov: desde la evaluación lineal de una política dada hasta la necesidad de buscar la política óptima salvando la no linealidad de Bellman.

Sin embargo, para asegurar un examen perfecto, **debes corregir un error matemático de índices y matizar una confusión muy común (y peligrosa) sobre qué algoritmo resuelve sistemas de ecuaciones**.

Aquí tienes la verificación, corrección y matización detallada de tu razonamiento:

---

### 1. Corrección del sentido de la fórmula (Los Índices)

- **Tu frase:** _"...obteniendo el valor de $U_i$ en función de $U_{i+1}(s')$..."\_
- **La corrección:** Es exactamente al revés. El algoritmo de iteración de valores calcula la utilidad de la nueva iteración, **$U_{i+1}(s)$**, basándose en los valores de utilidad que ya conocíamos de la iteración anterior, **$U_i(s')$**.
- La ecuación matemática de actualización del paso $i+1$ es:
  $$U_{i+1}(s) = \max_{a \in A(s)} \left( R(s,a) + \gamma \sum_{s' \in S} P_a(s'|s) U_i(s') \right)$$

---

### 2. La trampa del examen: ¿Se resuelven sistemas de ecuaciones en la Iteración de Valores?

- **Tu frase:** _"...Es decir, planteamos sistemas de ecuaciones de forma iterativa hasta que se estabilizan..."_
- **La corrección (Matiz crucial):** **No.** En el algoritmo de _Iteración de Valores_ (Value Iteration) **nunca se plantean ni se resuelven sistemas de ecuaciones lineales**.
  - Lo que se hace es una **actualización directa (o asignación aritmética)**. Para cada estado $s$, simplemente miras los números de la columna anterior $U_i$, aplicas la fórmula del máximo y las probabilidades, y el resultado lo apuntas directamente en la casilla de $U_{i+1}(s)$. Es un proceso computacionalmente muy barato por paso porque solo requiere sumas y multiplicaciones.
- **¿Dónde sí se resuelven sistemas de ecuaciones en cada iteración?** En el algoritmo de **Iteración de Políticas** (Policy Iteration). En este algoritmo, para evaluar la política actual $\pi_i$ en cada paso, sí es obligatorio plantear y resolver un sistema de $n$ ecuaciones lineales con $n$ incógnitas para hallar su utilidad exacta $U_i$.

---

### 3. Matiz sobre la Utilidad Óptima ($U^*$) y el Criterio de Parada

- **Tu frase:** _"...Llegado a este punto decimos que hemos calculado la Utilidad óptima $U^*$ ..."_
- **El matiz:** En realidad, como el horizonte es infinito, el algoritmo no suele llegar a la $U^*$ matemática exacta, sino que se detiene cuando la diferencia máxima entre dos pasos consecutivos es menor que un margen de error $\epsilon$ prefijado:

  $$\|U_i - U_{i-1}\| = \max_{s \in S} |U_i(s) - U_{i-1}(s)| < \epsilon$$

- La teoría garantiza que cuando se cumple este criterio de parada, la utilidad calculada $U_i$ está **extremadamente cerca** de la óptima real ($U^*$), con un error acotado por:

  $$\|U_i - U^*\| < \frac{2\gamma}{1-\gamma}\epsilon$$

- A partir de esa $U_i$ casi óptima, extraemos de manera voraz una política que está garantizado que sí es la **política óptima exacta ($\pi^*$)**.

---

### Resumen comparativo para fijar ideas de cara al examen

| Característica             | Iteración de Valores (_Value Iteration_)                                                            | Iteración de Políticas (_Policy Iteration_)                                             |
| :------------------------- | :-------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------- |
| **¿Qué inicializa?**       | Una función de utilidad arbitraria $U_0$.                                                           | Una política arbitraria $\pi_0$.                                                        |
| **¿Qué calcula por paso?** | Actualizaciones directas aplicando el operador de Bellman (con el $\max$).                          | Resuelve un **sistema de ecuaciones lineales** para evaluar la política actual $\pi_i$. |
| **Criterio de parada**     | Cuando los valores de utilidad dejan de cambiar significativamente: $\|U_i - U_{i-1}\| < \epsilon$. | Cuando la política sugerida es idéntica a la anterior: $\pi_{i} = \pi_{i-1}$.           |
| **Resultado final**        | Devuelve una aproximación de $U^*$ y extrae la política óptima $\pi^*$.                             | Devuelve directamente la política óptima exacta $\pi^*$.                                |

</div>
