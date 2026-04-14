### PARTE II: PROBLEMAS PARA RESOLVER EN PAPEL (1.50 Puntos)

_El problema tiene dos apartados para escalonar la nota (0.75 puntos cada uno). Debes mostrar el desarrollo matemático._

**Problema: Modelos de n-gramas y predicción de texto**
Imagina que estás diseñando el motor estadístico de un teclado predictivo para una aplicación móvil. Para facilitar los cálculos en papel, se dispone de un vocabulario muy reducido de tres términos $V = \{a, b, c\}$ y el siguiente corpus de entrenamiento compuesto por cuatro mensajes cortos (ya delimitados con los símbolos especiales de inicio `<s>` y fin `</s>`):

- $D_1$: `<s> a b a </s>`
- $D_2$: `<s> b a b </s>`
- $D_3$: `<s> a a b </s>`
- $D_4$: `<s> a b c </s>`

Se pide:

- **Apartado A (0.75 ptos):** Usando un modelo **bigrama estándar (sin suavizado)** entrenado mediante estimación de máxima verosimilitud, supón que un usuario acaba de escribir la secuencia de inicio `<s> a b`. Basándote en el contexto correspondiente, ¿qué término (incluyendo el símbolo `</s>`) sugerirá tu sistema predictivo con **mayor probabilidad** como el siguiente en la frase? _Demuestra matemáticamente tu respuesta calculando las probabilidades condicionales de todas las posibles continuaciones._
- **Apartado B (0.75 ptos):** El modelo anterior sufre el problema de asignar probabilidad cero a las combinaciones que nunca ha visto. Para solucionarlo, decides aplicar un modelo **bigrama con suavizado de Laplace ($k=1$)**. Usando este nuevo modelo suavizado, calcula detalladamente la probabilidad conjunta que tu sistema le asignaría a una frase nueva escrita por el usuario: $D_{nueva} =$ `<s> b b c </s>`.

* **Apartado C (0.50 ptos):** Como alternativa de precaución frente a contextos nuevos, decides implementar una técnica de **retroceso (_backoff_) simple a unigramas**. Esta técnica establece que si la probabilidad de un bigrama $\mathbb{P}(w_m | w_{m-1})$ es cero porque no aparece en el corpus de entrenamiento, el modelo utilizará en su lugar la probabilidad marginal del modelo unigrama $\mathbb{P}(w_m)$. Sabiendo que el usuario quiere escribir la misma frase nueva del apartado anterior ($D_{nueva} =$ `<s> b b c </s>`), ¿cuál sería el valor exacto de la probabilidad condicional del segundo término `b` dado su contexto, aplicando esta técnica de retroceso? _Muestra el cálculo de frecuencias necesario para el unigrama_.

#### Solución

¡Hola! Has hecho un buen planteamiento al intentar buscar el contexto y calcular sus frecuencias, pero has cometido **un error conceptual muy importante con respecto a lo que significa un modelo bigrama**. Además, en tu cálculo final arrastraste un pequeño error matemático.

Vamos a corregir el **Apartado A** y luego te explicaré paso a paso cómo se resuelve el **Apartado B**.

---

### Corrección del Apartado A: El error del contexto

En un modelo **bigrama ($n=2$)**, la aproximación de Markov establece que la predicción de la siguiente palabra depende **única y exclusivamente de la palabra inmediatamente anterior ($n-1 = 1$)**. Por lo tanto, si el usuario ha escrito `<s> a b`, **el contexto que debes buscar en tu corpus es únicamente la letra `b`**.

**Resolución del Apartado A:**
Debes buscar en el corpus cuántas veces aparece la palabra `b` y qué viene inmediatamente después:

- $D_1$: `<s> a b a </s>` $\rightarrow$ a `b` le sigue **`a`**.
- $D_2$: `<s> b a b </s>` $\rightarrow$ a la primera `b` le sigue **`a`**, a la segunda `b` le sigue **`</s>`**.
- $D_3$: `<s> a a b </s>` $\rightarrow$ a `b` le sigue **`</s>`**.
- $D_4$: `<s> a b c </s>` $\rightarrow$ a `b` le sigue **`c`**.

El contexto `b` aparece un total de **$C(b) = 5$** veces. Calculamos las probabilidades de las posibles continuaciones usando la estimación de máxima verosimilitud:

- $\mathbb{P}(a | b) = \frac{C(b\text{ }a)}{C(b)} = \mathbf{\frac{2}{5}}$ (Aparece en $D_1$ y $D_2$)
- $\mathbb{P}(b | b) = \frac{C(b\text{ }b)}{C(b)} = \mathbf{0}$
- $\mathbb{P}(c | b) = \frac{C(b\text{ }c)}{C(b)} = \mathbf{\frac{1}{5}}$ (Aparece en $D_4$)
- $\mathbb{P}(\text{</s>} | b) = \frac{C(b\text{ } \text{</s>})}{C(b)} = \mathbf{\frac{2}{5}}$ (Aparece en $D_2$ y $D_3$)

**Conclusión del Apartado A:** El sistema predictivo sugerirá con mayor probabilidad los términos **`a`** o **`</s>`** (ambos con probabilidad $0.4$).

---

### Cómo hacer el Apartado B (Paso a paso)

Para calcular la **probabilidad conjunta** de toda una frase nueva ($D_{nueva} =$ `<s> b b c </s>`) con un modelo bigrama, la regla de la cadena nos dice que debemos descomponer la frase y multiplicar las probabilidades condicionales de cada término dado el anterior. Es decir:

$$\mathbb{P}(D_{nueva}) = \mathbb{P}(b | \text{<s>}) \times \mathbb{P}(b | b) \times \mathbb{P}(c | b) \times \mathbb{P}(\text{</s>} | c)$$

Puesto que nos piden aplicar el **Suavizado de Laplace ($k=1$)**, debemos usar la siguiente fórmula modificada para cada cálculo:

$$\mathbb{P}(w_m | w_{m-1}) = \frac{C(w_{m-1} w_m) + 1}{C(w_{m-1}) + |V_{total}|}$$

El tamaño total del vocabulario es $|V_{total}| = |\{a, b, c, \text{</s>}\}| = \mathbf{4}$ (recuerda que el símbolo `</s>` cuenta para el denominador).

**1. Calculamos cada probabilidad individual:**

- **$\mathbb{P}(b | \text{<s>})$**: ¿Cuántas frases en el corpus empiezan por `b`? Solo 1 ($D_2$). ¿Cuántos inicios de frase `<s>` hay en total? Hay 4.
  $\mathbb{P}(b | \text{<s>}) = \frac{1 + 1}{4 + 4} = \mathbf{\frac{2}{8}} = \mathbf{\frac{1}{4}}$
- **$\mathbb{P}(b | b)$**: Vimos en el apartado A que `b` aparece 5 veces, pero nunca seguida de otra `b`.
  $\mathbb{P}(b | b) = \frac{0 + 1}{5 + 4} = \mathbf{\frac{1}{9}}$
- **$\mathbb{P}(c | b)$**: Vimos en el apartado A que `b` va seguida de `c` solo 1 vez ($D_4$).
  $\mathbb{P}(c | b) = \frac{1 + 1}{5 + 4} = \mathbf{\frac{2}{9}}$
- **$\mathbb{P}(\text{</s>} | c)$**: La letra `c` aparece solo 1 vez en todo el corpus ($D_4$), y va seguida de `</s>` esa única vez.
  $\mathbb{P}(\text{</s>} | c) = \frac{1 + 1}{1 + 4} = \mathbf{\frac{2}{5}}$

**2. Multiplicamos para obtener la probabilidad conjunta:**
$$\mathbb{P}(D_{nueva}) = \frac{1}{4} \times \frac{1}{9} \times \frac{2}{9} \times \frac{2}{5} = \frac{4}{1620} = \mathbf{\frac{1}{405}} \approx \mathbf{0.00247}$$

¡Y listo! Gracias al suavizado de Laplace, la probabilidad de la frase entera no se ha anulado a pesar de que el bigrama `b b` no había sido visto en el entrenamiento.

### Apartado C

**Consejo para resolver este nuevo apartado:**
Recuerda que para calcular la probabilidad del modelo unigrama $\mathbb{P}(b)$ debes contar cuántas veces aparece el término `b` en todo el corpus y dividirlo entre la suma de ocurrencias de _todos_ los términos generados (es decir, el total de palabras más los símbolos `</s>`, excluyendo los símbolos de inicio `<s>` para el denominador).

¡Buen intento! Has captado perfectamente la idea de cuándo y cómo saltar al modelo inferior aplicando la técnica de retroceso (o _backoff_, aunque en tu respuesta se haya colado como "Rockoff" por un error de teclado).

Sin embargo, aunque el planteamiento lógico es correcto, hay un **error matemático crítico** en el cálculo del unigrama y un par de despistes en las otras probabilidades.

Vamos a analizar tu respuesta paso a paso:

### 1. El error principal (Respuesta exacta al Apartado C)

El enunciado del Apartado C solo te pedía calcular el valor exacto de la probabilidad del segundo término `b` dado su contexto `b`, aplicando el retroceso.

Para calcular la probabilidad de un unigrama $\mathbb{P}(b)$ debes dividir las apariciones de `b` entre el **total de términos generados en el corpus** (palabras más los símbolos `</s>`, excluyendo los inicios `<s>`).

Vamos a contarlos:

- $D_1$ (`<s> a b a </s>`): genera **a, b, a, `</s>`** $\rightarrow$ 4 términos.
- $D_2$ (`<s> b a b </s>`): genera **b, a, b, `</s>`** $\rightarrow$ 4 términos.
- $D_3$ (`<s> a a b </s>`): genera **a, a, b, `</s>`** $\rightarrow$ 4 términos.
- $D_4$ (`<s> a b c </s>`): genera **a, b, c, `</s>`** $\rightarrow$ 4 términos.

En total, el corpus genera **16 términos**. Como la letra `b` aparece 5 veces, el cálculo de retroceso correcto es:
**$\mathbb{P}(b) = \frac{5}{16}$**

---

### 2. Resto de la frase

Usando estimación estándar (sin suavizado de Laplace) para el resto de términos.

- **$\mathbb{P}(b | \text{<s>}) = 1/4$**: **¡Correcto!** Hay 4 inicios de frase (`<s>`) en total, y solo 1 vez la frase empieza por `b` ($D_2$).
- **$\mathbb{P}(c | b) = 1/5$**: **¡Correcto!** La letra `b` aparece 5 veces como contexto, y solo le sigue la `c` 1 vez (en $D_4$).
- **$\mathbb{P}(\text{</s>} | c) = 1/4$**: **¡Incorrecto!** Aquí volviste a usar el 4 en el denominador. El denominador en un modelo bigrama sin suavizar siempre es la frecuencia del contexto. La letra `c` solo aparece **1 vez** en todo el corpus ($D_4$), y la única vez que aparece, va seguida de `</s>`. Por lo tanto, su cálculo correcto es: $\mathbb{P}(\text{</s>} | c) = \frac{C(c\text{ </s>})}{C(c)} = \frac{1}{1} = \mathbf{1}$.

**Conclusión del ejercicio:**
Para el examen, es vital que recuerdes que en los modelos unigramas el denominador es el volumen total de texto generado (16 en este caso), no el número de líneas o documentos.

¡Perfecto! La interpolación lineal es la tercera gran técnica para evitar que las probabilidades nulas (ceros) arruinen nuestro modelo de lenguaje ante n-gramas no vistos en el entrenamiento.

A diferencia de la técnica de retroceso (_backoff_) en la que solo saltamos al modelo inferior si el modelo superior da cero, la interpolación lineal **combina y pondera simultáneamente los cálculos de varios modelos** en todo momento.

Para interpolar un modelo bigrama con un modelo unigrama, la fórmula matemática general es la siguiente:

$$ \mathbb{P}(w*m | w*{m-1}) = \lambda*1 \mathbb{P}\_1(w_m) + \lambda_2 \mathbb{P}\_2(w_m | w*{m-1}) $$

Donde:

- $\mathbb{P}_1$ es la probabilidad proporcionada por el modelo unigrama.
- $\mathbb{P}_2$ es la probabilidad proporcionada por el modelo bigrama.
- $\lambda_1$ y $\lambda_2$ son los pesos o coeficientes que le damos a la decisión de cada modelo. La única regla es que estos pesos deben ser mayores que 0 y sumar obligatoriamente 1 ($\lambda_1 + \lambda_2 = 1$).

Para plantear el ejercicio siguiendo tu ejemplo anterior, vamos a calcular **la probabilidad exacta del segundo término `b` dado su contexto `b`**, asumiendo que damos el mismo peso a ambos modelos ($\lambda_1 = 1/2$ y $\lambda_2 = 1/2$).

### Resolución paso a paso:

**1. Probabilidad del modelo unigrama ($\mathbb{P}_1$):**
Rescatamos el cálculo del unigrama que corregimos juntos en el paso anterior, recordando que había 16 términos generados en total en el corpus y la letra `b` aparecía 5 veces.

- $\mathbb{P}_1(b) = \frac{5}{16}$

**2. Probabilidad del modelo bigrama ($\mathbb{P}_2$):**
Rescatamos el cálculo del bigrama estándar (sin suavizar) del Apartado A, donde vimos que la letra `b` aparecía 5 veces como contexto, pero nunca iba seguida de otra `b`.

- $\mathbb{P}_2(b|b) = \frac{0}{5} = 0$

**3. Aplicamos la fórmula de interpolación lineal:**

- $\mathbb{P}(b|b) = \frac{1}{2} \times \mathbb{P}_1(b) + \frac{1}{2} \times \mathbb{P}_2(b|b)$
- $\mathbb{P}(b|b) = \frac{1}{2} \times \frac{5}{16} + \frac{1}{2} \times 0$
- $\mathbb{P}(b|b) = \mathbf{\frac{5}{32}} \approx \mathbf{0.15625}$

Como puedes observar, al inyectar el conocimiento del unigrama mediante la interpolación lineal, logramos que la probabilidad no sea cero y "salvamos" el cálculo matemático general para esa frase, de manera similar a como lo hacíamos con el suavizado de Laplace o el _backoff_.

### Apartado D

Calcular la probabilidad conjunta de toda la frase completa ($D_{nueva} =$ `<s> b b c </s>`) usando esta interpolación lineal para cada uno de los pasos.

$$ \mathbb{P}(w*m | w*{m-1}) = \lambda*1 \mathbb{P}\_1(w_m) + \lambda_2 \mathbb{P}\_2(w_m | w*{m-1}) $$

Donde:

- $\mathbb{P}_1$ es la probabilidad proporcionada por el modelo unigrama.
- $\mathbb{P}_2$ es la probabilidad proporcionada por el modelo bigrama.
- $\lambda_1$ y $\lambda_2$ son los pesos o coeficientes que le damos a la decisión de cada modelo. La única regla es que estos pesos deben ser mayores que 0 y sumar obligatoriamente 1 ($\lambda_1 + \lambda_2 = 1$).

- **$\mathbb{P}(b | \text{<s>})$** = $\frac{1}{2} \times \frac{5}{16} + \frac{1}{2} \times \frac{1}{4} = \frac{5}{32} + \frac{4}{32} = \mathbf{\frac{9}{32}}$
- **$\mathbb{P}(b | b)$** = $\frac{1}{2} \times \frac{5}{16} + \frac{1}{2} \times \frac{0}{5} = \mathbf{\frac{5}{32}}$ _(¡Aquí lograste salvar el cero!)_

* **$\mathbb{P}(c | b)$** = $\frac{1}{2} \times \frac{1}{16} + \frac{1}{2} \times \frac{1}{5} = \frac{1}{32} + \frac{1}{10} = \mathbf{\frac{21}{160}}$

- **$\mathbb{P}(\text{</s>} | c)$** = $\frac{1}{2} \times \frac{4}{16} + \frac{1}{2} \times \mathbf{\frac{1}{1}} = \frac{1}{8} + \frac{1}{2} = \mathbf{\frac{5}{8}}$

### Resultado final de la interpolación lineal

Para calcular la probabilidad conjunta de toda la frase nueva ($D_{nueva} =$ `<s> b b c </s>`), simplemente multiplicaríamos todos los resultados corregidos que hemos obtenido:

$$\mathbb{P}(D_{nueva}) = \frac{9}{32} \times \frac{5}{32} \times \frac{21}{160} \times \frac{5}{8} = \frac{4725}{1310720} \approx \mathbf{0.0036}$$
