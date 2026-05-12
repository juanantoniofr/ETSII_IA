## Ejercicio 1

Consideremos el proceso de decisión de Markov tal que  
$S = \{s_1, s_2, s_3\}$

$A = \{a_1, a_2, a_3\}$

y $P$ viene dado por:

**Probabilidades de transición**

- Acción $a_1$

|         | $$s_1$$ | $$s_2$$ | $$s_3$$ |
| ------- | ------- | ------- | ------- |
| $$s_2$$ | 0.4     | 0.1     | 0.5     |
| $$s_3$$ | 0.5     | 0.0     | 0.5     |

- Acción $a_2$

|         | $$s_1$$ | $$s_2$$ | $$s_3$$ |
| ------- | ------- | ------- | ------- |
| $$s_1$$ | 0.0     | 0.3     | 0.7     |
| $$s_3$$ | 0.0     | 0.5     | 0.5     |

- Acción $a_3$

|         | $$s_1$$ | $$s_2$$ | $$s_3$$ |
| ------- | ------- | ------- | ------- |
| $$s_1$$ | 0.0     | 0.3     | 0.7     |
| $$s_2$$ | 0.8     | 0.2     | 0.0     |

Consideremos

- $R(s_1) = -1$
- $R(s_2) = -0.04$
- $R(s_3) = 1$

como recompensas de los estados, 0 como coste de aplicar las acciones y $0.9$ como factor de descuento.

Dada la política

$\pi(s_1) = a_3,\quad \pi(s_2) = a_3,\quad \pi(s_3) = a_2$

### ¿Cuál es la `probabilidad inducida` por $\pi$ de la historia (parcial) $\langle s_3, s_3, s_3, s_2, s_2 \rangle?$

**Solución:**

Para calcular la probabilidad inducida por la política $\pi$ para esa historia parcial, debes aplicar la fórmula matemática del modelo, que consiste en multiplicar las probabilidades individuales de cada salto de estado: $\mathbb{P}(h|\pi) = \prod_{i\ge0} P_{\pi(s_i)}(s_{i+1}|s_i)$.

Vamos a desglosar tu historia $\langle s_3, s_3, s_3, s_2, s_2 \rangle$ paso a paso comprobando las tablas del enunciado:

1.  **De $s_3$ a $s_3$:** La política dicta que estando en $s_3$ debes aplicar la acción $a_2$ ($\pi(s_3) = a_2$). Si miras la tabla de $P_{a_2}$, en la fila correspondiente al estado $s_3$ los valores son `0.0 0.5 0.5`. Como las columnas corresponden a $s_1$, $s_2$ y $s_3$ respectivamente, la probabilidad de empezar en $s_3$ y acabar en $s_3$ es **0.5**, ¡no es cero!.
2.  **De $s_3$ a $s_3$:** Se repite exactamente el mismo caso anterior, por lo que la probabilidad vuelve a ser **0.5**.
3.  **De $s_3$ a $s_2$:** Sigues en el estado $s_3$, por lo que aplicas de nuevo la acción $a_2$. Mirando la misma fila de la tabla $P_{a_2}$, la probabilidad de transitar esta vez a $s_2$ (la columna central) es **0.5**.
4.  **De $s_2$ a $s_2$:** Ahora el sistema ha transitado a $s_2$. Aquí la política cambia y te exige aplicar la acción $a_3$ ($\pi(s_2) = a_3$). Si miras la tabla de $P_{a_3}$, la fila para $s_2$ tiene los valores `0.8 0.2 0.0`. Por tanto, la probabilidad de transitar de $s_2$ a $s_2$ (la columna central) es **0.2**.

Al multiplicar todas las probabilidades encadenadas de cada transición, el cálculo matemático final de la historia es el siguiente:

**$\mathbb{P}(h|\pi) = 0.5 \times 0.5 \times 0.5 \times 0.2 = \mathbf{0.025}$**

---

### ¿Cuál es la `utilidad inducida` por $\pi$ de esa historia?

La utilidad de una historia evalúa **todos los estados por los que pasas desde el instante inicial**, aplicando un descuento cada vez mayor a medida que avanzas en el tiempo.

La fórmula teórica correcta para calcular la utilidad de una historia $h$ inducida por una política $\pi$ es:
**$U(h|\pi) = \sum_{i \ge 0} \gamma^i R(s_i, \pi(s_i))$**

Para aplicar esta fórmula a tu ejercicio, debemos tener en cuenta los datos del enunciado:

- El coste de aplicar las acciones es 0, por lo que el rendimiento neto $R(s_i, \pi(s_i))$ es exactamente igual a la recompensa de cada estado $R(s_i)$.
- Las recompensas son: $R(s_3) = 1$ y $R(s_2) = -0,04$.
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

---

### Plantear el `sistema de ecuaciones` que caracteriza $U_\pi$.

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

---

- Plantear las **ecuaciones de Bellman** que caracterizan $U^*$.

- Supongamos que hemos resuelto las ecuaciones anteriores y que conocemos $U^*$.  
  **Describir cómo podríamos obtener una política óptima.**
