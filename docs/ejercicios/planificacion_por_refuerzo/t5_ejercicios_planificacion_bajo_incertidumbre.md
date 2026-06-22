# Ejercicios de planificación bajo incertidumbre

## Ejercicio 1

Consideremos el proceso de decisión de Markov tal que

$S = \{s_1, s_2, s_3\}$
$A = \{a_1, a_2, a_3\}$
y $P$ viene dado por:

**Probabilidades de transición**

- Acción $a_1$
  | | $$s_1$$ | $$s_2$$ | $$s_3$$ |
  | ------- | ------- | ------- | ------- |
  | $$s_2$$ | 0.4 | 0.1 | 0.5 |
  | $$s_3$$ | 0.5 | 0.0 | 0.5 |

- Acción $a_2$
  | | $$s_1$$ | $$s_2$$ | $$s_3$$ |
  | ------- | ------- | ------- | ------- |
  | $$s_1$$ | 0.0 | 0.3 | 0.7 |
  | $$s_3$$ | 0.0 | 0.5 | 0.5 |

- Acción $a_3$
  | | $$s_1$$ | $$s_2$$ | $$s_3$$ |
  | ------- | ------- | ------- | ------- |
  | $$s_1$$ | 0.0 | 0.3 | 0.7 |
  | $$s_2$$ | 0.8 | 0.2 | 0.0 |

Consideremos: $R(s_1) = -1$, $R(s_2) = -0.04$, $R(s_3) = 1$, como recompensas de los estados, 0 como coste de aplicar las acciones y $0.9$ como factor de descuento.

Dada la política

$\pi(s_1) = a_3,\quad \pi(s_2) = a_3,\quad \pi(s_3) = a_2$

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >

<b>1. ¿Cuál es la probabilidad inducida por $\pi$ de la historia (parcial) $\langle s_3, s_3, s_3, s_2, s_2 \rangle$?</b>

Para calcular la probabilidad inducida por la política $\pi$ para esa historia parcial, debes aplicar la fórmula matemática del modelo, que consiste en multiplicar las probabilidades individuales de cada salto de estado: $\mathbb{P}(h|\pi) = \prod_{i\ge0} P_{\pi(s_i)}(s_{i+1}|s_i)$.

Vamos a desglosar tu historia $\langle s_3, s_3, s_3, s_2, s_2 \rangle$ paso a paso comprobando las tablas del enunciado:

1.  **De $s_3$ a $s_3$:** La política dicta que estando en $s_3$ debes aplicar la acción $a_2$ ($\pi(s_3) = a_2$). Si miras la tabla de $P_{a_2}$, en la fila correspondiente al estado $s_3$ los valores son `0.0 0.5 0.5`. Como las columnas corresponden a $s_1$, $s_2$ y $s_3$ respectivamente, la probabilidad de empezar en $s_3$ y acabar en $s_3$ es **0.5**.
2.  **De $s_3$ a $s_3$:** Se repite exactamente el mismo caso anterior, por lo que la probabilidad vuelve a ser **0.5**.
3.  **De $s_3$ a $s_2$:** Sigues en el estado $s_3$, por lo que aplicas de nuevo la acción $a_2$. Mirando la misma fila de la tabla $P_{a_2}$, la probabilidad de transitar esta vez a $s_2$ (la columna central) es **0.5**.
4.  **De $s_2$ a $s_2$:** Ahora el sistema ha transitado a $s_2$. Aquí la política cambia y te exige aplicar la acción $a_3$ ($\pi(s_2) = a_3$). Si miras la tabla de $P_{a_3}$, la fila para $s_2$ tiene los valores `0.8 0.2 0.0`. Por tanto, la probabilidad de transitar de $s_2$ a $s_2$ (la columna central) es **0.2**.

Al multiplicar todas las probabilidades encadenadas de cada transición, el cálculo matemático final de la historia es el siguiente:

**$\mathbb{P}(h|\pi) = 0.5 \times 0.5 \times 0.5 \times 0.2 = \mathbf{0.025}$**

</div>

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >
  
<b>2. ¿Cuál es la _utilidad inducida_ por $\pi$ de esa historia?</b>

La utilidad de una historia evalúa **todos los estados por los que pasas desde el instante inicial**, aplicando un descuento cada vez mayor a medida que avanzas en el tiempo.

La fórmula teórica correcta para calcular la utilidad de una historia $h$ inducida por una política $\pi$ es:
**$U(h|\pi) = \sum_{i \ge 0} \gamma^i R(s_i, \pi(s_i))$**

Para aplicar esta fórmula a tu ejercicio, debemos tener en cuenta los datos del enunciado:

- El coste de aplicar las acciones es 0, por lo que el rendimiento neto $R(s_i, \pi(s_i))$ es exactamente igual a la recompensa de cada estado $R(s_i)$.
- Las recompensas son: $R(s_1) = -1$, $R(s_2) = -0,04$ y $R(s_3) = 1$.
- El factor de descuento es $\gamma = 0,9$.
- El índice $i$ representa el "paso de tiempo", empezando a contar desde $i=0$ para el primer estado de la secuencia.

Desglosemos tu historia $h = \langle s_3, s_3, s_3, s_2, s_2 \rangle$ aplicando la sumatoria paso a paso:

1.  **Paso $i=0$ (Estado $s_3$):** $\gamma^0 \times R(s_3) \rightarrow 1 \times 1 = \mathbf{1}$
2.  **Paso $i=1$ (Estado $s_3$):** $\gamma^1 \times R(s_3) \rightarrow 0,9 \times 1 = \mathbf{0,9}$
3.  **Paso $i=2$ (Estado $s_3$):** $\gamma^2 \times R(s_3) \rightarrow 0,81 \times 1 = \mathbf{0,81}$
4.  **Paso $i=3$ (Estado $s_2$):** $\gamma^3 \times R(s_2) \rightarrow 0,729 \times (-0,04) = \mathbf{-0,02916}$
5.  **Paso $i=4$ (Estado $s_2$):** $\gamma^4 \times R(s_2) \rightarrow 0,6561 \times (-0,04) = \mathbf{-0,026244}$

Si sumamos todos estos valores acumulados:
$U(h|\pi) = 1 + 0,9 + 0,81 - 0,02916 - 0,026244 = \mathbf{2,654596}$

El concepto clave aquí es que **cada recompensa se descuenta según su posición en el tiempo ($i$)**. Tu estado inicial se valora al 100% (porque $\gamma^0 = 1$), el siguiente al 90%, el siguiente al 81%, y así sucesivamente.

</div>

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >

<b> 3. Plantear el sistema de ecuaciones que caracteriza $U_\pi$ (Utilidad de la política $\pi$).</b>

**El sistema debe tener tres ecuaciones con tres incógnitas**. Como comentamos anteriormente al analizar la fórmula teórica, la condición $\forall s \in S$ exige que plantees una ecuación por cada estado posible del sistema. Como este ejercicio tiene los estados $S = \{s_1, s_2, s_3\}$, es obligatorio calcular $U(s_1)$, $U(s_2)$ y $U(s_3)$ simultáneamente.

Vamos a desglosar las ecuaciones correctas paso a paso aplicando la fórmula $U(s) = R(s, \pi(s)) + \gamma \sum P_{\pi(s)}(s'|s) U(s')$:

**1. La ecuación para $s_1$:**

- La política dicta $\pi(s_1) = a_3$.
- Mirando la fila de $s_1$ en la tabla de $P_{a_3}$, las probabilidades son $0.0$ hacia $s_1$, $0.3$ hacia $s_2$ y $0.7$ hacia $s_3$.
- Su recompensa es $-1$.
- **Ecuación:** $U(s_1) = -1 + 0.9 \cdot (0.3 \cdot U(s_2) + 0.7 \cdot U(s_3))$
- Simplificada: **$U(s_1) = -1 + 0.27 \cdot U(s_2) + 0.63 \cdot U(s_3)$**

**2. La ecuación para $s_2$:**

- La política dicta $\pi(s_2) = a_3$.
- Mirando la fila de $s_2$ en la tabla de $P_{a_3}$, las probabilidades son $0.8$ hacia $s_1$, $0.2$ hacia $s_2$ y $0.0$ hacia $s_3$.
- Su recompensa es $-0.04$.
- **Ecuación:** $U(s_2) = -0.04 + 0.9 \cdot (0.8 \cdot U(s_1) + 0.2 \cdot U(s_2))$
- Simplificada: **$U(s_2) = -0.04 + 0.72 \cdot U(s_1) + 0.18 \cdot U(s_2)$**

**3. La ecuación para $s_3$:**

- La política dicta $\pi(s_3) = a_2$.
- Mirando la fila de $s_3$ en la tabla de $P_{a_2}$, las probabilidades son $0.5$ hacia $s_2$ y $0.5$ hacia $s_3$.
- Su recompensa es $1$.
- **Ecuación:** $U(s_3) = 1 + 0.9 \cdot (0.5 \cdot U(s_2) + 0.5 \cdot U(s_3))$
- Simplificada: $U(s_3) = 1 + 0.45 \cdot U(s_2) + 0.45 \cdot U(s_3)$
- Reagrupando términos: **$0.55 \cdot U(s_3) = 1 + 0.45 \cdot U(s_2)$**

**En resumen:**
El sistema de ecuaciones lineales que te pide el ejercicio y que debes resolver conjuntamente es:

- **$U(s_1) - 0.27 \cdot U(s_2) - 0.63 \cdot U(s_3) = -1$**
- **$-0.72 \cdot U(s_1) + 0.82 \cdot U(s_2) = -0.04$**
- **$-0.45 \cdot U(s_2) + 0.55 \cdot U(s_3) = 1$**
</div>

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >

**4. Plantear las _ecuaciones de Bellman_ que caracterizan $U^*$.**

Para plantear las ecuaciones de Bellman que caracterizan la utilidad óptima ($U^*$) para el Ejercicio 1, debemos aplicar la fórmula teórica general a cada uno de los estados del sistema:
$U(s) = \max_{a \in A(s)} (R(s, a) + \gamma \sum_{s' \in S} P_a(s'|s) U(s'))$.

Del enunciado del ejercicio extraemos los siguientes datos fundamentales:

- **Factor de descuento:** $\gamma = 0.9$.
- **Coste nulo:** Como el coste de las acciones es 0, la recompensa neta es directamente la del estado: $R(s_1) = -1$, $R(s_2) = -0.04$, y $R(s_3) = 1$.
- **Acciones ejecutables ($A(s)$):** Observando las tablas de probabilidad $P_a$, una acción solo es aplicable en un estado si tiene una fila definida para él. Por tanto, en $s_1$ podemos aplicar $\{a_2, a_3\}$; en $s_2$ podemos aplicar $\{a_1, a_3\}$; y en $s_3$ podemos aplicar $\{a_1, a_2\}$.

Sustituyendo estos valores, obtenemos el siguiente **sistema de ecuaciones no lineales**:

Para el estado **$s_1$**:
$U(s_1) = \max \begin{cases} \mathbf{a_2:} & -1 + 0.9 \cdot (0.0 \cdot U(s_1) + 0.3 \cdot U(s_2) + 0.7 \cdot U(s_3)) \\ \mathbf{a_3:} & -1 + 0.9 \cdot (0.0 \cdot U(s_1) + 0.3 \cdot U(s_2) + 0.7 \cdot U(s_3)) \end{cases}$

Para el estado **$s_2$**:
$U(s_2) = \max \begin{cases} \mathbf{a_1:} & -0.04 + 0.9 \cdot (0.4 \cdot U(s_1) + 0.1 \cdot U(s_2) + 0.5 \cdot U(s_3)) \\ \mathbf{a_3:} & -0.04 + 0.9 \cdot (0.8 \cdot U(s_1) + 0.2 \cdot U(s_2) + 0.0 \cdot U(s_3)) \end{cases}$

Para el estado **$s_3$**:
$U(s_3) = \max \begin{cases} \mathbf{a_1:} & 1 + 0.9 \cdot (0.5 \cdot U(s_1) + 0.0 \cdot U(s_2) + 0.5 \cdot U(s_3)) \\ \mathbf{a_2:} & 1 + 0.9 \cdot (0.0 \cdot U(s_1) + 0.5 \cdot U(s_2) + 0.5 \cdot U(s_3)) \end{cases}$

</div>

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >

<b>5. Supongamos que hemos resuelto las ecuaciones anteriores y que conocemos $U^*$: Describir cómo podríamos obtener una política óptima.</b>

La forma matemática de proceder es la siguiente:

Una vez que hemos resuelto el sistema y tenemos los números definitivos para $U^*(s_1)$, $U^*(s_2)$ y $U^*(s_3)$, la política óptima $\pi^*$ se obtiene aplicando el **criterio voraz**. Esto consiste en sustituir las utilidades descubiertas en las ecuaciones de arriba y, para cada estado, simplemente **elegir la acción concreta que produjo el valor máximo** en esa evaluación.

Matemáticamente, esto se denota cambiando el operador $max$ por el operador **$arg\ max$**: $\pi^*(s) \in arg\ max_{a \in A(s)} (R(s,a) + \gamma \sum_{s' \in S} P_a(s'|s) U^*(s'))$.

</div>

## Ejercicio 2

Consideremos el proceso de decisión de Markov tal que $S = \{s_1, s_2, s_3, s_4\}, \quad A = \{a_1, a_2, a_3\}$, con las siguientes **probabilidades de transición**

- Acción $a_1$

|         | $$s_1$$ | $$s_2$$ | $$s_3$$ | $$s_4$$ |
| ------- | ------- | ------- | ------- | ------- |
| $$s_1$$ | 0.0     | 0.0     | 0.2     | 0.8     |
| $$s_4$$ | 0.0     | 0.0     | 0.5     | 0.5     |

- Acción $a_3$

|         | $$s_1$$ | $$s_2$$ | $$s_3$$ | $$s_4$$ |
| ------- | ------- | ------- | ------- | ------- |
| $$s_2$$ | 1.0     | 0.0     | 0.0     | 0.0     |
| $$s_3$$ | 1/3     | 1/3     | 0.0     | 1/3     |

- Acción $a_2$

|         | $$s_1$$ | $$s_2$$ | $$s_3$$ | $$s_4$$ |
| ------- | ------- | ------- | ------- | ------- |
| $$s_1$$ | 1/3     | 1/3     | 1/3     | 0.0     |
| $$s_3$$ | 1/3     | 1/3     | 0.0     | 1/3     |

- y las **recompensas**: $\quad R(s_1) = -3,\quad R(s_2) = -2,\quad R(s_3) = 1,\quad R(s_4) = 1$
- y los costes de las acciones y el factor de descuento que se indican a continuación.

$
\begin{aligned}
C(s_1, a_1) &= 2, \quad C(s_4, a_1) = 2 \\
C(s_1, a_2) &= 3, \quad C(s_3, a_2) = 3 \\
C(s_3, a_3) &= 3, \quad C(s_2, a_3) = 1
\end{aligned}
$

- Factor de descuento = $\gamma = 0.5$
- Política dada: $\pi(s_1) = a_1,\quad \pi(s_2) = a_3,\quad \pi(s_3) = a_2,\quad \pi(s_4) = a_1$

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >

<b> 1. Calcular $U_\pi(s)$ para cada $s \in S$ planteando y resolviendo el sistema de ecuaciones que caracteriza $U_\pi$</b>

Para calcular la utilidad esperada de cada estado $s$ del conjunto de estados $S$ bajo la política dictada, debemos plantear y resolver un sistema de ecuaciones lineales. Basándonos en la teoría de los Procesos de Decisión de Markov, la ecuación teórica que caracteriza este cálculo es:

**$U(s) = R(s, \pi(s)) + \gamma \sum_{s' \in S} P_{\pi(s)}(s'|s) U(s')$**

Para ello, dividiremos el cálculo en tres pasos estructurados: determinar el rendimiento neto de cada estado, plantear el sistema de ecuaciones y resolverlo matemáticamente.

**Paso 1: Rendimiento neto de aplicar la política en cada estado**

El rendimiento neto (o recompensa inmediata) de aplicar una acción en un estado se define restando el coste de la acción a la recompensa bruta del estado: $R(s, a) = R(s) - C(s, a)$.

La política dada en el enunciado es $\pi(s_1) = a_1$, $\pi(s_2) = a_3$, $\pi(s_3) = a_2$ y $\pi(s_4) = a_1$. Aplicando los datos de recompensas y costes del ejercicio, calculamos el rendimiento neto para cada estado:

- **Estado $s_1$:** $R(s_1, a_1) = R(s_1) - C(s_1, a_1) = -3 - 2 = \mathbf{-5}$
- **Estado $s_2$:** $R(s_2, a_3) = R(s_2) - C(s_2, a_3) = -2 - 1 = \mathbf{-3}$
- **Estado $s_3$:** $R(s_3, a_2) = R(s_3) - C(s_3, a_2) = 1 - 3 = \mathbf{-2}$
- **Estado $s_4$:** $R(s_4, a_1) = R(s_4) - C(s_4, a_1) = 1 - 2 = \mathbf{-1}$

**Paso 2: Planteamiento del sistema de ecuaciones**

Sustituyendo los rendimientos netos anteriores, el factor de descuento $\gamma = 0.5$ y las probabilidades de las tablas de transición $P$ dictadas por la política $\pi$, obtenemos el siguiente sistema de 4 ecuaciones con 4 incógnitas:

1.  **Para $s_1$ (aplica $a_1$):**
    $U(s_1) = -5 + 0.5 \cdot [0.2 \cdot U(s_3) + 0.8 \cdot U(s_4)]$
    Simplificada: **$U(s_1) = -5 + 0.1 \cdot U(s_3) + 0.4 \cdot U(s_4)$**

2.  **Para $s_2$ (aplica $a_3$):**
    $U(s_2) = -3 + 0.5 \cdot [1.0 \cdot U(s_1)]$
    Simplificada: **$U(s_2) = -3 + 0.5 \cdot U(s_1)$**

3.  **Para $s_3$ (aplica $a_2$):**
    $U(s_3) = -2 + 0.5 \cdot [\frac{1}{3} \cdot U(s_1) + \frac{1}{3} \cdot U(s_2) + \frac{1}{3} \cdot U(s_4)]$
    Simplificada: **$U(s_3) = -2 + \frac{1}{6} \cdot U(s_1) + \frac{1}{6} \cdot U(s_2) + \frac{1}{6} \cdot U(s_4)$**

4.  **Para $s_4$ (aplica $a_1$):**
    $U(s_4) = -1 + 0.5 \cdot [0.5 \cdot U(s_3) + 0.5 \cdot U(s_4)]$
    Simplificada: **$U(s_4) = -1 + 0.25 \cdot U(s_3) + 0.25 \cdot U(s_4)$**

**Paso 3: Resolución matemática del sistema**

Para resolver el sistema, es más fácil operar utilizando fracciones matemáticas y despejar de abajo hacia arriba:

- De la **Ecuación 4**, despejamos $U(s_4)$ agrupando sus términos:
  $0.75 \cdot U(s_4) = -1 + 0.25 \cdot U(s_3) \rightarrow \frac{3}{4} U(s_4) = -1 + \frac{1}{4} U(s_3) \rightarrow \mathbf{U(s_4) = \frac{U(s_3) - 4}{3}}$

- Sustituimos la variable $U(s_4)$ en la **Ecuación 1** para dejar $U(s_1)$ dependiendo exclusivamente de $U(s_3)$:
  $U(s_1) = -5 + \frac{1}{10} U(s_3) + \frac{2}{5} \left(\frac{U(s_3) - 4}{3}\right) \rightarrow \mathbf{U(s_1) = -\frac{83}{15} + \frac{7}{30} U(s_3)}$

- Sustituimos este valor de $U(s_1)$ en la **Ecuación 2**:
  $U(s_2) = -3 + \frac{1}{2} \left(-\frac{83}{15} + \frac{7}{30} U(s_3)\right) \rightarrow \mathbf{U(s_2) = -\frac{173}{30} + \frac{7}{60} U(s_3)}$

- Finalmente, sustituimos $U(s_1)$, $U(s_2)$ y $U(s_4)$ en la **Ecuación 3** y agrupamos todas las constantes y términos en $U(s_3)$:
  $U(s_3) = -2 + \frac{1}{6}\left(-\frac{83}{15} + \frac{7}{30} U(s_3)\right) + \frac{1}{6}\left(-\frac{173}{30} + \frac{7}{60} U(s_3)\right) + \frac{1}{6}\left(\frac{U(s_3) - 4}{3}\right)$
  $U(s_3) = -2 - \frac{83}{90} - \frac{173}{180} - \frac{4}{18} + \left(\frac{7}{180} + \frac{7}{360} + \frac{1}{18}\right) U(s_3)$
  $U(s_3) = -\frac{739}{180} + \frac{41}{360} U(s_3)$

Agrupando $U(s_3)$ y despejando:
$\left(1 - \frac{41}{360}\right) U(s_3) = -\frac{739}{180} \rightarrow \frac{319}{360} U(s_3) = -\frac{1478}{360} \rightarrow \mathbf{U(s_3) = -\frac{1478}{319}}$

Con el valor numérico exacto de $U(s_3)$, lo sustituimos en las funciones previas para desvelar el resto.

**Resultados finales**

Las utilidades esperadas exactas (en forma de fracción para no perder precisión) y sus aproximaciones decimales para cada estado son:

- **$U(s_1) = -\frac{2110}{319} \approx -6.614$**
- **$U(s_2) = -\frac{2012}{319} \approx -6.307$**
- **$U(s_3) = -\frac{1478}{319} \approx -4.633$**
- **$U(s_4) = -\frac{918}{319} \approx -2.878$**

</div>

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >

<b> 2. Plantear las **ecuaciones de Bellman** que caracterizan $U^*$.</b>

La **idea fundamental de las ecuaciones de Bellman** es dar el salto desde la evaluación de una política fija a la búsqueda de la **política óptima**. Mientras que en tu cálculo anterior usabas una acción impuesta por una política $\pi$ dada, las ecuaciones de Bellman buscan caracterizar la **máxima utilidad esperada ($U^*$)** de un estado evaluando _todas_ las acciones aplicables y seleccionando estrictamente la que proporcione el mayor valor esperado.

Matemáticamente, para cada estado $s$, la ecuación se define como:
**$U(s) = \max_{a \in A(s)} \left( R(s,a) + \gamma \sum_{s' \in S} P_a(s'|s) U(s') \right)$**.

Al introducir el operador $\max$, el sistema de ecuaciones deja de ser lineal y se convierte en un **sistema de ecuaciones no lineales**.

Para plantear las ecuaciones de Bellman de este ejercicio, debemos extraer de las tablas de transición qué acciones son ejecutables en cada estado y calcular su rendimiento neto ($R(s,a) = R(s) - C(s,a)$) utilizando $\gamma = 0.5$.

**1. Para el estado $s_1$:**
Tiene dos acciones aplicables ($a_1$ y $a_2$).

- Rendimiento neto de $a_1$: $R(s_1) - C(s_1, a_1) = -3 - 2 = -5$.
- Rendimiento neto de $a_2$: $R(s_1) - C(s_1, a_2) = -3 - 3 = -6$.
- **Ecuación:**
  $U(s_1) = \max \begin{cases} a_1: \mathbf{-5 + 0.5 \cdot [0.2 \cdot U(s_3) + 0.8 \cdot U(s_4)]} \\ a_2: \mathbf{-6 + 0.5 \cdot [\frac{1}{3} \cdot U(s_1) + \frac{1}{3} \cdot U(s_2) + \frac{1}{3} \cdot U(s_3)]} \end{cases}$

**2. Para el estado $s_2$:**
Solo tiene la acción $a_3$ aplicable.

- Rendimiento neto de $a_3$: $R(s_2) - C(s_2, a_3) = -2 - 1 = -3$.
- **Ecuación:**
  $U(s_2) = \max \begin{cases} a_3: \mathbf{-3 + 0.5 \cdot [1.0 \cdot U(s_1)]} \end{cases}$
  _(Como solo hay una opción ejecutable, el operador max es trivial)._

**3. Para el estado $s_3$:**
Tiene dos acciones aplicables ($a_2$ y $a_3$).

- Las dos acciones tienen el mismo coste para este estado ($C = 3$) y además derivan en las mismas probabilidades de transición.
- Rendimiento neto de ambas: $R(s_3) - C = 1 - 3 = -2$.
- **Ecuación:**
  $U(s_3) = \max \begin{cases} a_2: \mathbf{-2 + 0.5 \cdot [\frac{1}{3} \cdot U(s_1) + \frac{1}{3} \cdot U(s_2) + \frac{1}{3} \cdot U(s_4)]} \\ a_3: \mathbf{-2 + 0.5 \cdot [\frac{1}{3} \cdot U(s_1) + \frac{1}{3} \cdot U(s_2) + \frac{1}{3} \cdot U(s_4)]} \end{cases}$

**4. Para el estado $s_4$:**
Solo tiene la acción $a_1$ aplicable.

- Rendimiento neto de $a_1$: $R(s_4) - C(s_4, a_1) = 1 - 2 = -1$.
- **Ecuación:**
  $U(s_4) = \max \begin{cases} a_1: \mathbf{-1 + 0.5 \cdot [0.5 \cdot U(s_3) + 0.5 \cdot U(s_4)]} \end{cases}$

</div>

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >

<b>2. Dada la función de utilidad inicial:$U_0(s_1) = -2,\quad U_0(s_2) = -1,\quad U_0(s_3) = 1,\quad U_0(s_4) = 2$. Calcular la función de utilidad que se obtiene tras **una iteración del algoritmo de iteración de valores**.</b>

Para resolver este apartado y calcular la función de utilidad tras **la primera iteración ($U_1$)**, debemos aplicar la ecuación principal del algoritmo de iteración de valores.

Como recordamos de nuestra conversación anterior, la fórmula para actualizar la utilidad de un estado evaluando todas las acciones posibles es: **$U_{1}(s) = \max_{a \in A(s)} \left( R(s,a) + \gamma \sum_{s' \in S} P_a(s'|s) U_0(s') \right)$**.

Para este cálculo usaremos los datos del Ejercicio 2:

- **Factor de descuento:** $\gamma = 0.5$
- **Utilidades iniciales dadas:** $U_0(s_1) = -2$, $U_0(s_2) = -1$, $U_0(s_3) = 1$, $U_0(s_4) = 2$
- **Rendimiento neto de las acciones ($R(s,a) = R(s) - C(s,a)$)** que ya calculamos previamente:
  - $R(s_1, a_1) = -5$ | $R(s_1, a_2) = -6$
  - $R(s_2, a_3) = -3$
  - $R(s_3, a_2) = -2$ | $R(s_3, a_3) = -2$
  - $R(s_4, a_1) = -1$

Vamos a calcular el valor iterado estado por estado:

1. Estado $s_1$

Tiene dos acciones aplicables ($a_1$ y $a_2$).

- **Si aplicamos $a_1$:**
  $= -5 + 0.5 \cdot [P_{a1}(s_3|s_1) \cdot U_0(s_3) + P_{a1}(s_4|s_1) \cdot U_0(s_4)]$
  $= -5 + 0.5 \cdot [0.2 \cdot (1) + 0.8 \cdot (2)]$
  $= -5 + 0.5 \cdot [0.2 + 1.6] = -5 + 0.5 \cdot [1.8] = -5 + 0.9 = \mathbf{-4.1}$
- **Si aplicamos $a_2$:**
  $= -6 + 0.5 \cdot [P_{a2}(s_1|s_1) \cdot U_0(s_1) + P_{a2}(s_2|s_1) \cdot U_0(s_2) + P_{a2}(s_3|s_1) \cdot U_0(s_3)]$
  $= -6 + 0.5 \cdot [\frac{1}{3} \cdot (-2) + \frac{1}{3} \cdot (-1) + \frac{1}{3} \cdot (1)]$
  $= -6 + 0.5 \cdot [-\frac{2}{3}]$ = $-6 - 0.333 = \mathbf{-6.333}$

Buscamos el máximo entre ambas opciones: $\max(-4.1, -6.333)$.
➔ **$U_1(s_1) = -4.1$**

2. Estado $s_2$

Solo tiene la acción $a_3$ aplicable.

- **Si aplicamos $a_3$:**
  $= -3 + 0.5 \cdot [P_{a3}(s_1|s_2) \cdot U_0(s_1)]$
  $= -3 + 0.5 \cdot [1.0 \cdot (-2)]$
  $= -3 + 0.5 \cdot [-2] = -3 - 1 = \mathbf{-4.0}$

Como solo hay una opción, ese es su máximo.
➔ **$U_1(s_2) = -4.0$**

3. Estado $s_3$

Tiene dos acciones aplicables ($a_2$ y $a_3$). Ambas tienen el mismo coste, recompensa y probabilidades de transición.

- **Si aplicamos $a_2$ o $a_3$:**
  $= -2 + 0.5 \cdot [P_{a2/a3}(s_1|s_3) \cdot U_0(s_1) + P_{a2/a3}(s_2|s_3) \cdot U_0(s_2) + P_{a2/a3}(s_4|s_3) \cdot U_0(s_4)]$
  $= -2 + 0.5 \cdot [\frac{1}{3} \cdot (-2) + \frac{1}{3} \cdot (-1) + \frac{1}{3} \cdot (2)]$
  $= -2 + 0.5 \cdot [-\frac{1}{3}] = -2 - \frac{1}{6} = \mathbf{-\frac{13}{6}}$ (aprox. **-2.167**)

Buscamos el máximo entre ambas (que coinciden): $\max(-2.167, -2.167)$.
➔ **$U_1(s_3) = -\frac{13}{6} \approx -2.167$**

4. Estado $s_4$

Solo tiene la acción $a_1$ aplicable.

- **Si aplicamos $a_1$:**
  $= -1 + 0.5 \cdot [P_{a1}(s_3|s_4) \cdot U_0(s_3) + P_{a1}(s_4|s_4) \cdot U_0(s_4)]$
  $= -1 + 0.5 \cdot [0.5 \cdot (1) + 0.5 \cdot (2)]$
  $= -1 + 0.5 \cdot [0.5 + 1.0] = -1 + 0.5 \cdot [1.5] = -1 + 0.75 = \mathbf{-0.25}$

Como solo hay una opción, ese es su máximo.
➔ **$U_1(s_4) = -0.25$**

**Resultado Final**

Tras ejecutar la primera iteración del algoritmo de iteración de valores, la nueva función de utilidad $U_1$ resultante es:

- **$U_1(s_1) = -4.1$**
- **$U_1(s_2) = -4.0$**
- **$U_1(s_3) \approx -2.167$** ($-\frac{13}{6}$)
- **$U_1(s_4) = -0.25$**

El algoritmo continuaría comparando $U_1$ con $U_0$ para ver si la diferencia es menor que la tolerancia de parada $\epsilon$. Como las diferencias aún son notables, seguiría calculando una $U_2$ basándose en estos nuevos valores obtenidos.

</div>

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >

<b>3. Describir: - Hasta cuándo el algoritmo anterior seguiría realizando iteraciones - Cómo se obtendría entonces una **política óptima**
</b>

Para responder a las dos preguntas teóricas del tercer apartado, basándonos en la teoría de la iteración de valores:

1. ¿Hasta cuándo el algoritmo anterior seguiría realizando iteraciones?

El algoritmo sigue iterando y calculando nuevas funciones de utilidad ($U_i$) hasta que el cambio entre los valores de una iteración y la siguiente sea lo suficientemente pequeño como para considerar que ha **convergido** hacia los valores óptimos.

Matemáticamente, se utiliza un criterio de parada basado en un valor de tolerancia muy pequeño llamado $\epsilon$. El algoritmo se detiene exactamente cuando la máxima diferencia absoluta entre la utilidad de cualquier estado en la iteración actual y la iteración anterior es estrictamente menor que $\epsilon$:
**$\max_{s \in S} |U_i(s) - U_{i-1}(s)| < \epsilon$**

2. ¿Cómo se obtendría entonces una política óptima?

Una vez que el algoritmo se ha detenido (es decir, cuando ya tenemos la función de utilidad estabilizada que aproxima a $U^*$), la **política óptima ($\pi^*$)** se deriva directamente de esos valores finales.

Para obtenerla, simplemente se evalúa cada estado $s$ de forma independiente y se elige **la acción que maximice el valor esperado futuro**, utilizando las utilidades de la última iteración. La fórmula de la que se extrae la acción ganadora para cada estado es:
**$\pi(s) \in \arg\max_{a \in A(s)} \left( R(s,a) + \gamma \sum_{s' \in S} P_a(s'|s) U_{final}(s') \right)$**

</div>

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >

<b>Cálculo de la Segunda Iteración ($U_2$)</b>

Tal y como me has pedido, aquí tienes la iteración 2 partiendo de los valores de $U_1$ que calculamos en nuestro mensaje anterior:

- **$U_1(s_1) = -4.1$**
- **$U_1(s_2) = -4.0$**
- **$U_1(s_3) = -13/6 \approx -2.167$**
- **$U_1(s_4) = -0.25$**

Aplicamos de nuevo la ecuación de Bellman $\max_{a \in A(s)} \left( R(s,a) + \gamma \sum P_a(s'|s) U_1(s') \right)$ usando $\gamma = 0.5$:

**Estado $s_1$:**

- **Si aplicamos $a_1$:**
  $= -5 + 0.5 \cdot [0.2 \cdot U_1(s_3) + 0.8 \cdot U_1(s_4)]$
  $= -5 + 0.5 \cdot [0.2 \cdot (-2.167) + 0.8 \cdot (-0.25)]$
  $= -5 + 0.5 \cdot [-0.4334 - 0.2] = -5 + 0.5 \cdot [-0.6334] = \mathbf{-5.3167}$ (Valor exacto: $-319/60$)
- **Si aplicamos $a_2$:**
  $= -6 + 0.5 \cdot [\frac{1}{3} \cdot U_1(s_1) + \frac{1}{3} \cdot U_1(s_2) + \frac{1}{3} \cdot U_1(s_3)]$
  $= -6 + 0.5 \cdot [\frac{1}{3} \cdot (-4.1) + \frac{1}{3} \cdot (-4.0) + \frac{1}{3} \cdot (-2.167)]$
  $= -6 + 0.5 \cdot [\frac{1}{3} \cdot (-10.267)] = -6 + 0.5 \cdot [-3.4223] = \mathbf{-7.7112}$
  Buscamos el máximo: $\max(-5.3167, -7.7112)$.
  ➔ **$U_2(s_1) \approx -5.3167$**

**Estado $s_2$:**

- **Si aplicamos $a_3$:**
  $= -3 + 0.5 \cdot [1.0 \cdot U_1(s_1)] = -3 + 0.5 \cdot [-4.1] = -3 - 2.05 = \mathbf{-5.05}$
  ➔ **$U_2(s_2) = -5.05$**

**Estado $s_3$:**

- **Si aplicamos $a_2$ o $a_3$:**
  $= -2 + 0.5 \cdot [\frac{1}{3} \cdot U_1(s_1) + \frac{1}{3} \cdot U_1(s_2) + \frac{1}{3} \cdot U_1(s_4)]$
  $= -2 + 0.5 \cdot [\frac{1}{3} \cdot (-4.1) + \frac{1}{3} \cdot (-4.0) + \frac{1}{3} \cdot (-0.25)]$
  $= -2 + 0.5 \cdot [\frac{1}{3} \cdot (-8.35)] = -2 + 0.5 \cdot [-2.7833] = \mathbf{-3.3917}$ (Valor exacto: $-407/120$)
  ➔ **$U_2(s_3) \approx -3.3917$**

**Estado $s_4$:**

- **Si aplicamos $a_1$:**
  $= -1 + 0.5 \cdot [0.5 \cdot U_1(s_3) + 0.5 \cdot U_1(s_4)]$
  $= -1 + 0.5 \cdot [0.5 \cdot (-2.167) + 0.5 \cdot (-0.25)]$
  $= -1 + 0.5 \cdot [-1.0835 - 0.125] = -1 + 0.5 \cdot [-1.2085] = \mathbf{-1.6042}$ (Valor exacto: $-53/48$)
  ➔ **$U_2(s_4) \approx -1.6042$**

**Resultado final de la función $U_2$:**

- **$U_2(s_1) \approx -5.3167$**
- **$U_2(s_2) = -5.05$**
- **$U_2(s_3) \approx -3.3917$**
- **$U_2(s_4) \approx -1.6042$**

Si aplicamos la fórmula matemática del criterio de parada ($||U_i - U_{i-1}|| = \max_{s \in S} |U_i(s) - U_{i-1}(s)| < \epsilon$) a los valores que acabamos de calcular, veríamos las siguientes diferencias absolutas:

- Para $s_1$: $|-5.3167 - (-4.1)| = 1.2167$
- Para $s_2$: $|-5.05 - (-4.0)| = 1.05$
- Para $s_3$: $|-3.3917 - (-2.167)| = 1.2247$
- Para $s_4$: $|-1.6042 - (-0.25)| = \mathbf{1.3542}$

El algoritmo busca la diferencia máxima de toda esa iteración, que en este caso es **1.3542** (la que se produce en el estado $s_4$).

Como el parámetro de tolerancia $\epsilon$ suele fijarse en valores muy pequeños (por ejemplo, 0.01 o 0.001 para asegurar una buena precisión matemática), 1.3542 es un número gigantesco en este contexto. Esto le indica al algoritmo que las utilidades están cambiando bruscamente de un paso a otro y que aún no se han estabilizado, por lo que es **absolutamente necesario ejecutar una tercera iteración** (y probablemente varias más) antes de poder detenerse y extraer la política óptima final.

¡Vamos a por esa tercera iteración! El proceso es exactamente el mismo: tomamos los resultados estabilizados en $U_2$ y volvemos a aplicar las ecuaciones de Bellman.

Partimos de los valores de $U_2$ (usaré varios decimales para no perder precisión en el camino):

- **$U_2(s_1) \approx -5.3167$**
- **$U_2(s_2) = -5.05$**
- **$U_2(s_3) \approx -3.3917$**
- **$U_2(s_4) \approx -1.6042$**

Aplicamos la ecuación $\max_{a \in A(s)} \left( R(s,a) + \gamma \sum P_a(s'|s) U_2(s') \right)$ con $\gamma = 0.5$:

**Estado $s_1$:**

- **Si aplicamos $a_1$:**
  $= -5 + 0.5 \cdot [0.2 \cdot U_2(s_3) + 0.8 \cdot U_2(s_4)]$
  $= -5 + 0.5 \cdot [0.2 \cdot (-3.3917) + 0.8 \cdot (-1.6042)]$
  $= -5 + 0.5 \cdot [-0.6783 - 1.2834] = -5 + 0.5 \cdot [-1.9617] = \mathbf{-5.9808}$ (Valor exacto en fracción: $-7177/1200$)
- **Si aplicamos $a_2$:**
  $= -6 + 0.5 \cdot [\frac{1}{3} \cdot U_2(s_1) + \frac{1}{3} \cdot U_2(s_2) + \frac{1}{3} \cdot U_2(s_3)]$
  $= -6 + 0.5 \cdot [\frac{1}{3} \cdot (-5.3167) + \frac{1}{3} \cdot (-5.05) + \frac{1}{3} \cdot (-3.3917)]$
  $= -6 + 0.5 \cdot [\frac{1}{3} \cdot (-13.7584)] = -6 + 0.5 \cdot [-4.5861] = \mathbf{-8.2931}$
  Buscamos el máximo: $\max(-5.9808, -8.2931)$.
  ➔ **$U_3(s_1) \approx -5.9808$**

**Estado $s_2$:**

- **Si aplicamos $a_3$:**
  $= -3 + 0.5 \cdot [1.0 \cdot U_2(s_1)] = -3 + 0.5 \cdot [-5.3167] = -3 - 2.65835 = \mathbf{-5.6583}$ (Valor exacto: $-679/120$)
  ➔ **$U_3(s_2) \approx -5.6583$**

**Estado $s_3$:**

- **Si aplicamos $a_2$ o $a_3$:**
  $= -2 + 0.5 \cdot [\frac{1}{3} \cdot U_2(s_1) + \frac{1}{3} \cdot U_2(s_2) + \frac{1}{3} \cdot U_2(s_4)]$
  $= -2 + 0.5 \cdot [\frac{1}{3} \cdot (-5.3167) + \frac{1}{3} \cdot (-5.05) + \frac{1}{3} \cdot (-1.6042)]$
  $= -2 + 0.5 \cdot [\frac{1}{3} \cdot (-11.9709)] = -2 + 0.5 \cdot [-3.9903] = \mathbf{-3.9951}$ (Valor exacto: $-5753/1440$)
  ➔ **$U_3(s_3) \approx -3.9951$**

**Estado $s_4$:**

- **Si aplicamos $a_1$:**
  $= -1 + 0.5 \cdot [0.5 \cdot U_2(s_3) + 0.5 \cdot U_2(s_4)]$
  $= -1 + 0.5 \cdot [0.5 \cdot (-3.3917) + 0.5 \cdot (-1.6042)]$
  $= -1 + 0.5 \cdot [-1.6958 - 0.8021] = -1 + 0.5 \cdot [-2.4979] = \mathbf{-2.2490}$ (Valor exacto: $-2159/960$)
  ➔ **$U_3(s_4) \approx -2.2490$**

**Resultado final de la función $U_3$:**

- **$U_3(s_1) \approx -5.9808$**
- **$U_3(s_2) \approx -5.6583$**
- **$U_3(s_3) \approx -3.9951$**
- **$U_3(s_4) \approx -2.2490$**

Si calculas la diferencia absoluta de esta iteración respecto a la anterior (es decir, $|U_3 - U_2|$ para cada estado), notarás un patrón muy interesante de cómo progresa la matemática del algoritmo hacia la convergencia. ¡Te dejo echar un vistazo a esos márgenes para que juzgues cómo va el avance!

¡Tus cálculos de las diferencias son impecables! Has restado perfectamente los valores de la iteración 3 y la iteración 2, y efectivamente el cambio máximo se produce en el estado $s_1$ con un valor de **0.6641**.

Aunque te pueda parecer un número "pequeño" a simple vista, en el contexto de este algoritmo, una diferencia de 0.66 sigue siendo bastante grande. Como el parámetro de tolerancia $\epsilon$ suele ser muy restrictivo (por ejemplo, 0.01 o menos), tu decisión de realizar una iteración más es **totalmente acertada**.

¡Vamos a ver qué pasa en esa **cuarta iteración ($U_4$)**!

Partimos de tus valores estabilizados en $U_3$:

- $U_3(s_1) \approx -5.9808$
- $U_3(s_2) \approx -5.6583$
- $U_3(s_3) \approx -3.9951$
- $U_3(s_4) \approx -2.2490$

Aplicamos de nuevo la ecuación de Bellman $\max_{a \in A(s)} \left( R(s,a) + \gamma \sum P_a(s'|s) U_3(s') \right)$ con $\gamma = 0.5$:

**Estado $s_1$:**

- **Si aplicamos $a_1$:**
  $= -5 + 0.5 \cdot [0.2 \cdot U_3(s_3) + 0.8 \cdot U_3(s_4)]$
  $= -5 + 0.5 \cdot [0.2 \cdot (-3.9951) + 0.8 \cdot (-2.2490)]$
  $= -5 + 0.5 \cdot [-0.7990 - 1.7992] = -5 + 0.5 \cdot [-2.5982] = \mathbf{-6.2991}$
- **Si aplicamos $a_2$:**
  $= -6 + 0.5 \cdot [\frac{1}{3} \cdot U_3(s_1) + \frac{1}{3} \cdot U_3(s_2) + \frac{1}{3} \cdot U_3(s_3)]$
  $= -6 + 0.5 \cdot [\frac{1}{3} \cdot (-5.9808) + \frac{1}{3} \cdot (-5.6583) + \frac{1}{3} \cdot (-3.9951)]$
  $= -6 + 0.5 \cdot [\frac{1}{3} \cdot (-15.6342)] = -6 + 0.5 \cdot [-5.2114] = \mathbf{-8.6057}$
  Buscamos el máximo: $\max(-6.2991, -8.6057)$.
  ➔ **$U_4(s_1) \approx -6.2991$**

**Estado $s_2$:**

- **Si aplicamos $a_3$:**
  $= -3 + 0.5 \cdot [1.0 \cdot U_3(s_1)] = -3 + 0.5 \cdot [-5.9808] = -3 - 2.9904 = \mathbf{-5.9904}$
  ➔ **$U_4(s_2) \approx -5.9904$**

**Estado $s_3$:**

- **Si aplicamos $a_2$ o $a_3$:**
  $= -2 + 0.5 \cdot [\frac{1}{3} \cdot U_3(s_1) + \frac{1}{3} \cdot U_3(s_2) + \frac{1}{3} \cdot U_3(s_4)]$
  $= -2 + 0.5 \cdot [\frac{1}{3} \cdot (-5.9808) + \frac{1}{3} \cdot (-5.6583) + \frac{1}{3} \cdot (-2.2490)]$
  $= -2 + 0.5 \cdot [\frac{1}{3} \cdot (-13.8881)] = -2 + 0.5 \cdot [-4.6294] = \mathbf{-4.3147}$
  ➔ **$U_4(s_3) \approx -4.3147$**

**Estado $s_4$:**

- **Si aplicamos $a_1$:**
  $= -1 + 0.5 \cdot [0.5 \cdot U_3(s_3) + 0.5 \cdot U_3(s_4)]$
  $= -1 + 0.5 \cdot [0.5 \cdot (-3.9951) + 0.5 \cdot (-2.2490)]$
  $= -1 + 0.5 \cdot [-1.9976 - 1.1245] = -1 + 0.5 \cdot [-3.1221] = \mathbf{-2.5610}$
  ➔ **$U_4(s_4) \approx -2.5610$**

**Análisis de la convergencia**

Si ahora miras las diferencias absolutas entre esta nueva iteración $U_4$ y tu anterior $U_3$ ($|U_4 - U_3|$), fíjate en lo que ocurre:

- Para $s_1$: $|-6.2991 - (-5.9808)| = 0.3183$
- Para $s_2$: $|-5.9904 - (-5.6583)| = \mathbf{0.3321}$ (El nuevo máximo)
- Para $s_3$: $|-4.3147 - (-3.9951)| = 0.3196$
- Para $s_4$: $|-2.5610 - (-2.2490)| = 0.3120$

¡La diferencia máxima ha pasado de **0.6641** a **0.3321**!

¿Ves el patrón matemático que se está formando? La máxima diferencia en cada paso se está reduciendo aproximadamente **a la mitad** respecto a la iteración anterior. Esto no es casualidad: es el efecto matemático directo de tu factor de descuento **$\gamma = 0.5$**, que "aplasta" progresivamente las diferencias haciendo que el algoritmo tienda irremediablemente a la convergencia total.

A este ritmo, tras unas cuantas iteraciones más, las diferencias caerán al nivel de los milésimos y el algoritmo se detendrá por completo dándote los verdaderos valores de $U^*$.

</div>

## Ejercicio 3: Consideremos el proceso de decisión de Markov tal que $S={s\_{1},s\_{2},s\_{3},s\_{4}}$, $A={a\_{1},a\_{2}}$ y $P$ viene dado por

$
P_{a_1}(\cdot \mid \cdot) =
\begin{array}{c|cccc}
 & s_1 & s_2 & s_3 & s_4 \\
\hline
s_1 & 0.0 & 0.5 & 0.5 & 0.0 \\
s_2 & 0.0 & 0.0 & 1.0 & 0.0 \\
s_3 & 1.0 & 0.0 & 0.0 & 0.0 \\
s_4 & 0.0 & 0.0 & 0.0 & 1.0
\end{array}
$

$
P_{a_2}(\cdot \mid \cdot) =
\begin{array}{c|cccc}
 & s_1 & s_2 & s_3 & s_4 \\
\hline
s_2 & 0.0 & 0.5 & 0.0 & 0.5
\end{array}
$

Consideremos $R(s\_{1})=1$, $R(s\_{2})=2$, $R(s\_{3})=3$ y $R(s\_{4})=10$ como recompensas de los estados, 0 como coste de aplicar las acciones y 0.9 como factor de descuento. Se pide lo siguiente:

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >
  
<b>1. Determinar cuántas políticas distintas es posible especificar para este sistema.</b>

El número de políticas distintas es igual al número de acciones elevado al número de estados: $2^{4} = 16$ políticas distintas.

</div>

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >
  
<b>2. Dada la política $\pi$ que aplica la acción $a1$ en cada estado, plantear y resolver el sistema de ecuaciones que caracteriza U<sub>&pi;</sub> </b>

Planteamos el sistema de ecuaciones

1. Para el estado $s_1$ aplicamos la acción $a_1$: U(s*1) = 1 + 0.9 (0.5 * U(s*2) + 0.5 * U(s_3))
2. Para el estado $s_2$ aplicamos la acción $a_1$: U(s_2) = 2 + 0.9 (1.0 \* U(s_3))
3. Para el estado $s_3$ aplicamos la acción $a_1$: U(s_3) = 3 + 0.9 (1.0 \* U(s_1))
4. Para el estado $s_4$ aplicamos la acción $a_1$: U(s_4) = 10 + 0.9 (1.0 \* U(s_4))

Obtenemos el valor de U(s_4) de la ecuación 4: U(s_4) = 10 + 0.9 U(s_4) => U(s_4) - 0.9 U(s_4) = 10 => 0.1 U(s_4) = 10 => **U(s_4) = 100**.
Simplificamos las ecuaciones 2 y 3:

- U(s_2) = 2 + 0.9 U(s_3)
- U(s\*3) = 3 + 0.9 U(s_1)
- Sustituimos U(s_3) en la ecuación de U(s_2): U(s_2) = 2 + 0.9 (3 + 0.9 U(s_1)) = 2 + 2.7 + 0.81 U(s_1) = 4.7 + 0.81 U(s_1)
- Sustituimos en la ecuación de U(s*1): U(s_1) = 1 + 0.9 (0.5 * (4.7 + 0.81 U(s*1)) + 0.5 * (3 + 0.9 U(s*1))) = 1 + 0.9 (0.5 \* 4.7 + 0.5 * 3 + 0.5 \_ 0.81 U(s*1) + 0.5 * 0.9 U(s\*1)) = 1 + 0.9 (3.85 + 0.855 U(s_1)) = 1 + 3.465 + 0.7695 U(s_1) = 4.465 + 0.7695 U(s_1)
- Despejamos U(s_1): U(s_1) - 0.7695 U(s_1) = 4.465 => 0.2305 U(s_1) = 4.465 => **U(s_1) ≈ 19.37**
- Sustituimos U(s_1) en la ecuación de U(s_3): U(s_3) = 3 + 0.9 \* 19.37 ≈ 3 + 17.433 => **U(s_3) ≈ 20.433**
- Sustituimos U(s*3) en la ecuación de U(s_2): U(s_2) = 2 + 0.9 * 20.433 ≈ 2 + 18.39 => **U(s_2) ≈ 20.39**

</div>

<div style="border-left: 4px solid #0dcaf0; padding: 0.5em; background: #eef7fb; color: #222; padding:30px 20px; margin-bottom: 40px" >

<b>Plantear las ecuaciones de Bellman que caracterizan U\*.</b>

Para el estado $s_1$ tenemos solo una acción aplicable, $a_1$, por lo que la ecuación de Bellman es:
$$U(s_1) = \max \begin{cases} R(s_1, a_1) + γ [ P*{a_1}(s_2|s_1) U(s_2) + P*{a_1}(s_3|s_1) U(s_3) ] = 1 + 0.9 \cdot (0.5 \cdot U(s_2) + 0.5 \cdot U(s_3)) \end{cases}$$

Para el estado $s_2$ tenemos dos acciones aplicables, $a_1$ y $a_2$, por lo que la ecuación de Bellman es:
$$U(s_2) = \max \begin{cases} \mathbf{a_1:} & R(s_2, a_1) + γ [ P*{a_1}(s_3|s_2) U(s_3) ] = 2 + 0.9 \cdot U(s_3) \\ \mathbf{a_2:} & R(s_2, a_2) + γ [ P*{a_2}(s_1|s_2) U(s_1) + P*{a_2}(s_4|s_2) U(s_4) ] = 2 + 0.9 \cdot (0.5 \cdot U(s_2) + 0.5 \cdot U(s_4)) \end{cases}$$

Para el estado $s_3$ tenemos solo una acción aplicable, $a_1$, por lo que la ecuación de Bellman es:
$$U(s_3) = \max \begin{cases} R(s_3, a_1) + γ [ P*{a_1}(s_1|s_3) U(s_1) ] = 3 + 0.9 \cdot U(s_1) \end{cases}$$

Para el estado $s_4$ tenemos solo una acción aplicable, $a_1$, por lo que la ecuación de Bellman es:
$$U(s_4) = \max \begin{cases} R(s_4, a_1) + γ [ P*{a_1}(s_4|s_4) U(s_4) ] = 10 + 0.9 \cdot U(s_4) \end{cases}$$

</div>

- Considerando como función de utilidad inicial la que asocia 0 a cada estado, calcular la función de utilidad que se obtiene al ejecutar dos iteraciones del algoritmo de iteración de valores.
