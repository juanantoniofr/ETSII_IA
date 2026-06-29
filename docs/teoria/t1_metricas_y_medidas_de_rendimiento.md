<link rel="stylesheet" href="../css/estilo.css">

# Metricas y medidas de rendimiento

<div class="highlight-theory">

## Métricas de rendimiento

Según los documentos de estudio y los boletines de problemas, las métricas de rendimiento se dividen en dos grandes grupos dependiendo de si estás resolviendo una tarea de **clasificación** o una tarea de **regresión**:

**1. Métricas para modelos de Clasificación**
Se utilizan cuando el objetivo es predecir una categoría o clase discreta (como el autor de una pintura o si un cliente comprará un viaje). Las métricas evaluadas son:

- **Tasa de acierto (Accuracy):** Es la métrica más directa y se utiliza habitualmente en problemas de Naive Bayes, CART y kNN para seleccionar el mejor hiperparámetro. Mide el porcentaje global de predicciones correctas sobre el total del conjunto de prueba.
- **Medidas derivadas de la Matriz de Confusión:** En ejercicios completos se pide construir la matriz de confusión sobre el conjunto de prueba y derivar "todas las medidas posibles de rendimiento". _(Como mencionamos en mensajes anteriores, esto abarca la tasa de verdaderos positivos/negativos, la precisión, la exhaustividad o el F1-score, analizando los fallos clase por clase)_.

**2. Métricas para modelos de Regresión**
Se utilizan estrictamente cuando el objetivo es predecir un valor numérico continuo (como la cantidad de helado vendido o el volumen de un árbol). Estas métricas evalúan la distancia entre el número que predijo el modelo y el número real, y son:

- **Error absoluto medio:** Calcula el promedio de las diferencias absolutas entre la predicción y el valor real.

$$MAE = \frac{1}{n} \sum_{i=1}^{n} |y_i - \hat{y}_i|$$

- **Error cuadrático medio:** Eleva al cuadrado las diferencias antes de promediarlas, penalizando así de forma mucho más severa los errores grandes.

$$MSE = \frac{1}{n} \sum_{i=1}^{n} (y_i - \hat{y}_i)^2$$

- **Coeficiente de determinación ($R^2$):** Es una métrica estadística que indica qué proporción de la varianza de la variable dependiente es predecible a partir de los atributos. Se busca maximizar este valor.

$$R^2 = 1 - \frac{\sum_{i=1}^{n} (y_i - \hat{y}_i)^2}{\sum_{i=1}^{n} (y_i - \bar{y})^2}$$

</div>

<div class="highlight-theory">

## Diferencias entre métricas y medidas de rendimiento

Es una pregunta excelente. Aunque en foros o tutoriales genéricos de Machine Learning verás que la gente usa "métricas" y "medidas de rendimiento" como sinónimos, **en el contexto estricto de tu boletín de problemas y tu temario de la asignatura, significan dos cosas matemáticamente distintas**.

La diferencia fundamental es la siguiente:

**1. Las medidas de rendimiento evalúan el modelo**
Las **medidas de rendimiento** son los valores que calculas al final del ejercicio para ponerle una "nota" al modelo y saber qué tan bien o mal predice sobre datos nuevos. Son exactamente las que te listé en el mensaje anterior (tasa de acierto, error absoluto medio, el $R^2$ o las derivadas de la matriz de confusión).

**2. Las métricas calculan distancias entre datos**
En los enunciados de tu boletín, la palabra **"métrica"** se utiliza exclusivamente para referirse a una **métrica de distancia espacial**. Es una fórmula matemática que sirve para calcular la separación que hay entre dos ejemplos concretos. Este concepto pertenece puramente al **algoritmo k-NN (k-vecinos más cercanos)**, ya que el algoritmo necesita esta métrica para saber qué ejemplos de entrenamiento se parecen más al nuevo dato que quieres predecir.

Si revisas los problemas de k-NN en tu boletín, verás que las métricas estudiadas son:

- Métrica de la **distancia Manhattan** (se pide usar en el Ejercicio 13 de las cerámicas romanas).
- Métrica de la **distancia euclídea** (se pide usar en el Ejercicio 14 de la presión sanguínea).
- Métrica de la **distancia de Hamming** (se pide usar en el Ejercicio 15 para atributos categóricos de las plantas).

**El resumen para el examen:**
La relación entre ambos conceptos queda muy clara en el **Ejercicio 16** (el problema de los cráneos egipcios): en la fase de entrenamiento, el ejercicio te pide probar distintas **métricas** (Manhattan y euclídea) para construir el algoritmo kNN; y para decidir cuál de esas métricas es la ganadora, debes calcular la **medida de rendimiento** (la tasa de acierto) de cada una.

</div>

<div class="highlight-theory">

## Medidas de rendimento derivadas de la matriz de confusión

En el apartado 3 del **Ejercicio 9**, el enunciado te pide literalmente lo siguiente: **"Derivar a partir de esa matriz de confusión todas las medidas posibles de rendimiento del modelo"**.

Al exigirte calcular "todas las posibles" en un problema de clasificación binaria (donde solo hay Pintor A y Pintor B), se espera que, una vez construyas la matriz cruzando los 5 ejemplos de prueba, extraigas las siguientes proporciones:

1.  **Tasa de acierto (Accuracy) y Tasa de error:** El porcentaje de cuadros totales que tu árbol CART ha clasificado correctamente frente al porcentaje global en el que ha fallado.

$$Accuracy = \frac{TP + TN}{TP + TN + FP + FN} \quad ; \quad Error = 1 - Accuracy$$

2.  **Precisión (Precision):** De todos los cuadros que tu árbol ha dicho que son del "Pintor A", cuántos resultaron ser realmente del Pintor A.

$$Precision = \frac{TP}{TP + FP}$$

3.  **Sensibilidad o Tasa de verdaderos positivos (Recall):** De todos los cuadros que en la realidad pertenecían al "Pintor A", cuántos fue capaz de detectar tu modelo correctamente.

$$Recall = \frac{TP}{TP + FN}$$

4.  **Especificidad o Tasa de verdaderos negativos:** El mismo análisis que la sensibilidad, pero evaluando tu éxito a la hora de identificar la otra clase (el "Pintor B").

$$Specificity = \frac{TN}{TN + FP}$$

5.  **Tasas de fallos:** Tasa de falsos positivos y falsos negativos (el porcentaje de veces que el modelo predijo un pintor cuando en realidad era el otro).

$$FPR = \frac{FP}{FP + TN} \quad ; \quad FNR = \frac{FN}{FN + TP}$$

6.  **Medida F1 (F1-score):** La media armónica que combina la Precisión y la Sensibilidad en un solo número.

$$F1 = 2 \cdot \frac{Precision \cdot Recall}{Precision + Recall}$$

Básicamente, el ejercicio no busca que apliques una única fórmula, sino que demuestres que sabes "leer" la matriz de confusión sacando los porcentajes tanto por filas (los datos reales) como por columnas (las predicciones de tu árbol).

</div>

<div class="highlight-theory">

## Evaluación y selección de modelos

### Métricas para Modelos de Clasificación

| Métrica                            | ¿Apropiada para?        | Fórmula                                   | Explicación                                                                                                               | Interpretación (Aspectos relevantes)                                                                                                       |
| :--------------------------------- | :---------------------- | :---------------------------------------- | :------------------------------------------------------------------------------------------------------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------- |
| **Exactitud o Tasa de acierto**    | Clasificación (General) | $\frac{VP + VN}{\vert \mathcal{D} \vert}$ | Proporción total de ejemplos clasificados correctamente sobre el total de ejemplos evaluados ($\vert \mathcal{D} \vert$). | Sirve para evaluar el desempeño general del modelo. Sin embargo, puede ser una métrica engañosa si las clases están muy desequilibradas.   |
| **Tasa de error**                  | Clasificación (General) | $\frac{FP + FN}{\vert \mathcal{D} \vert}$ | Proporción total de ejemplos que el modelo ha clasificado de manera incorrecta.                                           | Mide la frecuencia global de fallos del modelo. Es exactamente el valor complementario a la exactitud.                                     |
| **Sensibilidad o Recuerdo (TPR)**  | Clasificación Binaria   | $\frac{VP}{VP + FN}$                      | Proporción de ejemplos positivos reales que el modelo ha clasificado correctamente.                                       | Evalúa la capacidad para detectar los casos positivos. Responde a: _de todos los casos positivos reales, ¿cuántos cazó el modelo?_         |
| **Especificidad (TNR)**            | Clasificación Binaria   | $\frac{VN}{FP + VN}$                      | Proporción de ejemplos negativos reales que el modelo ha clasificado correctamente como negativos.                        | Evalúa la capacidad para detectar los casos negativos. Responde a: _de todos los casos negativos reales, ¿cuántos descartó el modelo?_     |
| **Precisión**                      | Clasificación Binaria   | $\frac{VP}{VP + FP}$                      | Proporción de ejemplos realmente positivos de entre todos los que el modelo ha clasificado como positivos.                | Evalúa la fiabilidad de las alarmas del modelo. Responde a: _si el modelo dice "es positivo", ¿qué porcentaje de veces acierta realmente?_ |
| **Tasa de falsos positivos (FPR)** | Clasificación Binaria   | $\frac{FP}{FP + VN}$                      | Proporción de ejemplos negativos reales que el modelo ha clasificado incorrectamente como positivos.                      | Representa la probabilidad de que el modelo lance una "falsa alarma".                                                                      |
| **Tasa de falsos negativos (FNR)** | Clasificación Binaria   | $\frac{FN}{VP + FN}$                      | Proporción de ejemplos positivos reales que el modelo ha clasificado incorrectamente como negativos.                      | Representa la probabilidad de que el modelo pase por alto un caso positivo real.                                                           |

- TPR -> True Positive Rate
- TNR -> True Negative Rate
- FPR -> False Positive Rate
- FNR -> False Negative Rate

### Métricas para Modelos de Regresión

| Métrica                                    | ¿Apropiada para? | Fórmula                                                     | Explicación                                                                                                                  | Interpretación (Aspectos relevantes)                                                                                                                                                                                                                               |
| :----------------------------------------- | :--------------- | :---------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Error Absoluto Medio (MAE)**             | Regresión        | $\frac{1}{\vert\mathcal{D}\vert}\sum \vert y-\hat{y}\vert$  | Calcula el promedio del error en valor absoluto cometido entre el valor predicho y el valor real correcto para cada ejemplo. | Da una idea directa de la magnitud del error promedio sin importar si el fallo del modelo fue por exceso o por defecto.                                                                                                                                            |
| **Error Cuadrático Medio (MSE)**           | Regresión        | $\frac{1}{\vert\mathcal{D}\vert}\sum(y-\hat{y})^{2}$        | Calcula el promedio de las diferencias al cuadrado entre el valor predicho y el valor real.                                  | Al elevarse al cuadrado, **penaliza de forma mucho más severa los errores grandes** frente a los pequeños. Al ser una función diferenciable, es más fácil de optimizar matemáticamente por los algoritmos.                                                         |
| **Raíz del Error Cuadrático Medio (RMSE)** | Regresión        | $\sqrt{\frac{1}{\vert\mathcal{D}\vert}\sum(y-\hat{y})^{2}}$ | Es la raíz cuadrada del Error Cuadrático Medio (MSE) calculado en el paso anterior.                                          | Su principal ventaja frente al MSE es que **devuelve el error medido exactamente en la misma unidad original** que el atributo objetivo, lo que facilita enormemente su comprensión en el contexto del problema.                                                   |
| **Coeficiente de determinación ($R^2$)**   | Regresión        | $1-\frac{MSE}{Var(\mathcal{D})}$                            | Compara el error cuadrático medio (MSE) del modelo con la varianza de los valores reales correctos del conjunto de datos.    | Mide la **calidad del ajuste numérico**. Un valor de 1 indica un ajuste perfecto; un 0 significa que el modelo es tan inútil como predecir siempre la media; y un valor negativo indica que las predicciones son peores que simplemente predecir la media siempre. |

_(Nota: **$y$** = valor real correcto, **$\hat{y}$** = valor numérico predicho por el modelo, **$Var(\mathcal{D})$** = varianza de los valores reales correctos, y **$\vert \mathcal{D} \vert$** = Total de ejemplos en el conjunto de datos evaluado)._

</div>
