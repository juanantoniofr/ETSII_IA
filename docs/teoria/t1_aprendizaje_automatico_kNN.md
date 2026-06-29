<link rel="stylesheet" href="../css/estilo.css">

# kNN - K vecinos más cercanos

## Teoría

<div class="highlight-theory">

- Puede abordar problemas de clasificación y regresión.

**1 Realización de la tarea**

El modelo **k vecinos más cercanos (kNN)** es un algoritmo de **aprendizaje supervisado y no paramétrico** que se utiliza para resolver tanto tareas de clasificación como de regresión. Su funcionamiento se basa en la intuición de la similitud: para decidir sobre un nuevo caso, se apoya en los ejemplos del pasado que resulten más parecidos. De hecho, "aprender" o entrenar este modelo consiste pura y simplemente en memorizar todos los ejemplos del conjunto de entrenamiento.

Para que el modelo realice su tarea, primero hay que configurar dos hiperparámetros fundamentales:

- **La métrica de distancia:** Define matemáticamente el concepto de similitud. Para ejemplos con atributos numéricos continuos se suele usar la distancia Euclídea o la Manhattan, mientras que para atributos discretos categóricos es habitual emplear la distancia de Hamming.
- **La cantidad de vecinos ($k$):** Es el número exacto de ejemplos similares que el modelo va a tener en cuenta para tomar su decisión.

Una vez definidos estos parámetros, cuando llega un ejemplo nuevo, el modelo ejecuta los siguientes pasos:

1. **Localizar a los vecinos:** Calcula la distancia matemática entre el nuevo ejemplo y todos los ejemplos del conjunto de entrenamiento, ordenándolos para seleccionar los $k$ ejemplos que se encuentren a menor distancia.
2. **Generar la predicción:** Dependiendo de la tarea que se esté resolviendo, el modelo actuará de una de estas dos formas:
   - Si es una tarea de **clasificación** (predecir una categoría o etiqueta), el modelo le asigna al ejemplo nuevo la **clase mayoritaria** de entre sus $k$ vecinos elegidos. Es decir, la que más se repita. Por este motivo, si se trata de clasificación binaria, se suele elegir un número $k$ impar para evitar que se produzcan empates.
   - Si es una tarea de **regresión** (predecir un número continuo), el modelo le asigna al ejemplo nuevo el **valor medio (la media aritmética)** de los valores que tienen sus $k$ vecinos.

- **Distancia Euclídea:** Mide la distancia geométrica directa en "línea recta" entre los dos ejemplos.

  $$d(x,x') = \sqrt{\sum_{i=1}^{n}(x_{i}-x_{i}')^{2}}$$

- **Distancia Manhattan:** Mide la distancia sumando las diferencias absolutas de cada atributo por separado.

  $$d(x,x') = \sum_{i=1}^{n}|x_{i}-x_{i}'|$$

- **Distancia de Hamming:** Cuenta exactamente la cantidad de atributos en los que los dos ejemplos difieren entre sí.

  $$d(x,x') = \sum_{i=1}^{n}\mathbb{I}(x_{i}\ne x_{i}')$$

  _(Donde $\mathbb{I}$ es la función indicador, que devuelve un 1 si los valores de ese atributo son diferentes, y un 0 si son exactamente iguales)._

**Un detalle clave para su aplicación práctica:**

Cuando el conjunto de datos incluye atributos numéricos con distintas escalas, es muy conveniente **aplicar un proceso de normalización** previo (como la normalización mín-máx o la tipificación). Si no se hace, el atributo numérico que tenga el rango de valores más grande (por ejemplo, el peso de un coche medido en miles frente al número de cilindros) dominará por completo el cálculo de las distancias, volviendo irrelevante la información de los atributos más pequeños. Al usar el modelo, esta normalización aprendida en el entrenamiento debe aplicarse exactamente igual a los nuevos ejemplos antes de clasificarlos.

**¿Cómo normalizamos?**

Este proceso es independiente se si estamos con una tarea de clasificación, como si se trata de una tarea de regresión.

**1. Normalización mín-máx**

Esta fórmula transforma los datos para que todos los valores del atributo queden comprimidos y se encuentren exactamente dentro del intervalo $[0, 1]$. La operación consiste en restar al valor original el mínimo del atributo y dividir este resultado por la diferencia entre el máximo y el mínimo:

$$x_{norm} = \frac{x - m}{M - m}$$

Donde:

- **$x$**: es el valor original que queremos normalizar.
- **$m$**: es el valor **mínimo** que toma ese atributo en todo el conjunto de entrenamiento.
- **$M$**: es el valor **máximo** que toma ese atributo en todo el conjunto de entrenamiento.

**2. Tipificación**

Esta fórmula transforma los valores del atributo de tal forma que la distribución resultante pase a tener una **media de 0 y una desviación típica de 1**. Se calcula restando la media general al valor original y dividiendo el resultado por la desviación típica:

$$x_{norm} = \frac{x - \mu}{\sigma}$$

Donde:

- **$x$**: es el valor original que queremos normalizar.
- **$\mu$**: es la **media aritmética** de todos los valores de ese atributo en el conjunto de entrenamiento.
- **$\sigma$**: es la **desviación típica** de los valores de ese atributo en el conjunto de entrenamiento.

**_`Nota`_**

> Para calcular la **desviación típica** ($\sigma$) de los valores de un atributo (necesaria, por ejemplo, para la tipificación en kNN), debes calcular la raíz cuadrada de su **varianza**.
>
> El proceso matemático, aplicando las fórmulas de la teoría de la varianza y la media, se divide en estos tres pasos:
>
> **1. Calcular la media aritmética ($\mu$ o $\overline{x}$)**
> Sumas todos los valores numéricos del atributo en tu conjunto de entrenamiento y divides el resultado entre la cantidad total de ejemplos ($N$).
> $\mu = \frac{1}{N} \sum_{i=1}^{N} x_i$
>
> **2. Calcular la varianza ($Var$)**
> Para cada valor individual del atributo, calculas su diferencia respecto a la media obtenida en el paso anterior y elevas ese resultado al cuadrado. Luego, sumas todos esos cuadrados y divides el total > entre el número de ejemplos ($N$).
> $Var = \frac{1}{N} \sum_{i=1}^{N} (x_i - \mu)^2$
>
> **3. Calcular la desviación típica ($\sigma$)**
> Finalmente, aplicas la raíz cuadrada al valor exacto de la varianza.
> $\sigma = \sqrt{Var} = \sqrt{\frac{1}{N} \sum_{i=1}^{N} (x_i - \mu)^2}$

**Un detalle fundamental para la práctica:**

Es muy importante recordar que estos parámetros de ajuste matemático ($m$, $M$, $\mu$ y $\sigma$) se deben aprender o calcular **únicamente utilizando los ejemplos del conjunto de entrenamiento**. Cuando llega un ejemplo nuevo (o cuando vayas a evaluar el conjunto de prueba), debes aplicarle exactamente esta misma fórmula de normalización usando los valores de máximo, mínimo, media o desviación que ya memorizaste durante el entrenamiento.

En el algoritmo de los k vecinos más cercanos (kNN), las fórmulas de las distancias **no dependen de si la tarea es de clasificación o de regresión**, sino de la **naturaleza de los atributos** (si son numéricos continuos o discretos). El cálculo de la distancia para encontrar a los vecinos más parecidos es idéntico en ambas tareas; la única diferencia está en cómo se genera la predicción final una vez encontrados (eligiendo la clase mayoritaria en clasificación o calculando la media aritmética en regresión).

**_`Nota`_**

> Un modelo de aprendizaje automático se considera **no paramétrico cuando el número de parámetros del modelo no es fijo, sino que depende de la cantidad de ejemplos de entrenamiento** de los que disponga.
>
> En el caso específico del algoritmo **k vecinos más cercanos (kNN)**, este se clasifica como no paramétrico porque el proceso de aprendizaje consiste únicamente en memorizar el conjunto de entrenamiento, por lo que **sus parámetros son, pura y simplemente, los propios ejemplos que ha memorizado**.
>
> A diferencia de los modelos paramétricos (como Naive Bayes), que resumen la información matemática en una fórmula fija y pueden borrar los datos de origen, en kNN **el modelo son los datos mismos**. Por lo tanto, a medida que le proporcionas más datos al algoritmo, el tamaño del modelo crece proporcionalmente, ya que necesita guardarlos absolutamente todos para poder comparar y calcular las distancias cuando tenga que clasificar un ejemplo nuevo.

</div>

<div class="highlight-theory">

**Validación por retención y validación cruzada**

El objetivo principal al evaluar un modelo no es solo saber cómo rinde con los datos que ya ha visto (los datos de entrenamiento), sino medir su **capacidad de generalización**: su aptitud para proporcionar la respuesta adecuada frente a **ejemplos nuevos** que no conoce previamente. Si un modelo acierta todo en el entrenamiento pero falla con datos nuevos, decimos que se ha **sobreajustado** (ha "memorizado" los datos en lugar de aprender el patrón subyacente).

Dado que no conocemos las respuestas de los datos futuros que el modelo procesará en el mundo real, usamos las técnicas de validación para simular ese escenario "ocultando" parte de la información al modelo durante su entrenamiento.

Aquí tienes en qué consisten los dos conceptos:

**Validación por retención (_Holdout validation_)**

Es el método más directo y el que hemos estado usando implícitamente en el Ejercicio 4. Consiste en **dividir el conjunto total de ejemplos en dos subconjuntos**:

- **Conjunto de entrenamiento:** Se usa para construir y aprender los parámetros del modelo.
- **Conjunto de prueba:** Se mantiene "retenido" (oculto) durante el entrenamiento. Solo se le muestra al modelo al final para evaluar su rendimiento, comparando sus predicciones con las respuestas correctas que ya conocemos.

**Aspectos clave:**

- La división suele ser aleatoria, reservando habitualmente entre un **20% y un 30%** de los datos para la prueba.
- Para tareas de clasificación es muy recomendable realizar un **muestreo estratificado**, lo que significa asegurarse de que la proporción de cada clase (ej. el porcentaje de "interesado" vs "no interesado") se mantenga igual en ambos subconjuntos.
- **Inconveniente:** Cuando el conjunto de datos total es pequeño, este método no es adecuado porque corremos el riesgo de dejar muy pocos datos para entrenar bien el modelo, o muy pocos datos para que la evaluación sea estadísticamente fiable.

**Validación cruzada con k-pliegues (_k-fold cross validation_)**

Para solucionar el problema de los conjuntos de datos pequeños, surge esta técnica iterativa y más robusta. Consiste en **subdividir el conjunto total de ejemplos en $k$ subconjuntos o "pliegues"** (también de manera aleatoria y preferiblemente mediante muestreo estratificado).

El proceso consiste básicamente en realizar **$k$ procesos de validación por retención distintos**:

1.  En cada iteración, se toma **un pliegue distinto como conjunto de prueba**.
2.  El modelo se entrena usando los ejemplos de los **$k-1$ pliegues restantes** (los que no pertenecen al pliegue de prueba actual).
3.  Se calcula el rendimiento del modelo sobre ese pliegue de prueba.

Al final de las $k$ iteraciones, se calcula la **media aritmética de las $k$ estimaciones de rendimiento obtenidas** (por ejemplo, la media de la tasa de acierto de cada pliegue).

**Aspectos clave:**

- Aprovecha al máximo los datos, ya que todos los ejemplos se utilizan tanto para entrenar como para evaluar en algún momento del proceso.
- Proporciona una estimación _a priori_ mucho más fiable de la capacidad de generalización del modelo.
- Una vez que hemos usado la validación cruzada para estimar cómo de bien funcionará nuestro tipo de modelo, el paso final en la práctica real es **entrenar el modelo definitivo utilizando absolutamente todos los ejemplos disponibles**. Asumimos que el rendimiento de este modelo definitivo en el mundo real será aproximadamente la media que nos devolvió la validación cruzada.

</div>

## Ejercicios

<div class="highlight-exercise">

**Ejercicio 13**

Se ha realizado un análisis químico a doce muestras de cerámica romana encontradas en tres lugares distintos, obteniéndose para cada muestra los siguientes porcentajes de óxidos de varios metales:

| Aluminio | Hierro | Magnesio | Calcio | Sodio | Lugar   |
| -------- | ------ | -------- | ------ | ----- | ------- |
| 14.4     | 7.00   | 4.30     | 0.15   | 0.51  | Lugar 1 |
| 13.8     | 7.08   | 3.43     | 0.12   | 0.17  | Lugar 1 |
| 14.6     | 7.09   | 3.88     | 0.13   | 0.20  | Lugar 1 |
| 11.5     | 6.37   | 5.64     | 0.16   | 0.14  | Lugar 1 |
| 18.3     | 1.28   | 0.67     | 0.03   | 0.03  | Lugar 2 |
| 15.8     | 2.39   | 0.63     | 0.01   | 0.04  | Lugar 2 |
| 18.0     | 1.50   | 0.67     | 0.01   | 0.06  | Lugar 2 |
| 18.0     | 1.88   | 0.68     | 0.01   | 0.04  | Lugar 2 |
| 17.7     | 1.12   | 0.56     | 0.06   | 0.06  | Lugar 3 |
| 18.3     | 1.14   | 0.67     | 0.06   | 0.05  | Lugar 3 |
| 16.7     | 0.92   | 0.53     | 0.01   | 0.05  | Lugar 3 |
| 14.8     | 2.74   | 0.67     | 0.03   | 0.05  | Lugar 3 |

Se pide:

-1. Usar un modelo 𝑘NN, con 𝑘 = 3 y métrica la distancia Manhattan, para predecir el lugar donde se encontraron las siguientes cerámicas:

| Aluminio | Hierro | Magnesio | Calcio | Sodio |
| -------- | ------ | -------- | ------ | ----- |
| 13.8     | 7.06   | 5.34     | 0.20   | 0.20  |
| 20.8     | 1.51   | 0.72     | 0.07   | 0.10  |
| 19.1     | 1.64   | 0.60     | 0.10   | 0.03  |

**Solución**

- 1. Normalizar los datos aplicando el método min - max. Para cada atributo X: $forall x in X$, $x_{norm} = \frac{x - m}{M - m}$

| Aluminio_norm | Hierro_norm | Magnesio_norm | Calcio_norm | Sodio_norm | Lugar   |
| ------------- | ----------- | ------------- | ----------- | ---------- | ------- |
| 0,4           | 1,0         | 0,74          | 0,93        | 1,00       | Lugar 1 |
| 0,3           | 1,0         | 0,57          | 0,73        | 0,29       | Lugar 1 |
| 0,5           | 1,0         | 0,66          | 0,80        | 0,35       | Lugar 1 |
| 0,0           | 0,9         | 1,00          | 1,00        | 0,23       | Lugar 1 |
| 1,0           | 0,1         | 0,03          | 0,13        | 0,00       | Lugar 2 |
| 0,6           | 0,2         | 0,02          | 0,00        | 0,02       | Lugar 2 |
| 1,0           | 0,1         | 0,03          | 0,00        | 0,06       | Lugar 2 |
| 1,0           | 0,2         | 0,03          | 0,00        | 0,02       | Lugar 2 |
| 0,9           | 0,0         | 0,01          | 0,33        | 0,06       | Lugar 3 |
| 1,0           | 0,0         | 0,03          | 0,33        | 0,04       | Lugar 3 |
| 0,8           | 0,0         | 0,00          | 0,60        | 0,04       | Lugar 3 |
| 0,5           | 0,3         | 0,03          | 0,13        | 0,04       | Lugar 3 |

- 2. Normalizamos la tabla de ejemplos a clasificar

| Aluminio_norm | Hierro_norm | Magnesio_norm | Calcio_norm | Sodio_norm |
| ------------- | ----------- | ------------- | ----------- | ---------- |
| 0,34          | 1,0         | 0,94          | 1,27        | 0,35       |
| 1,37          | 0,1         | 0,04          | 0,40        | 0,15       |
| 1,12          | 0,1         | 0,01          | 0,60        | 0,00       |

- 3. Calculamos la distancia Manhattan de los tres ejemplos a clasificar

| Manhattan_E1 | Manhattan_E2 | Manhattan_E3 |
| ------------ | ------------ | ------------ |
| 1,28         | 2,67         | 4,06         |
| 0,97 (l1)    | 1,79 (l1)    | 3,02 (l1)    |
| 0,87 (l1)    | 1,88         | 2,96 (l1)    |
| 0,90 (l1)    | 2,67         | 2,72 (l1)    |
| 4,00         | 2,02         | 5,72         |
| 3,57         | 1,77 (l2)    | 5,39         |
| 3,99         | 1,86         | 5,85         |
| 3,97         | 1,84         | 5,78         |
| 3,70         | 2,20         | 5,67         |
| 3,78         | 2,20         | 5,72         |
| 3,34         | 2,53         | 5,57         |
| 3,21         | 1,74 (l3)    | 4,94         |

- 4 como k=3 nos quedamos con los tres más pequeños.
- Tenemos que los ejemplos 1 y 3 se clasifican claramente como del "lugar 1". El ejemplo 2 no podemos determinar su procedencia

- 2. Volver a realizar las predicciones, pero ahora usando la distancia euclídea como métrica.

| Euclidea_E1 | Euclidea_E2 | Euclidea_E3 |
| ----------- | ----------- | ----------- |
| 0,76        | 1,78        | 1,69        |
| 0,65 (l1)   | 1,51        | 1,34        |
| 0,56 (l1)   | 1,50        | 1,34        |
| 0,47 (l1)   | 1,95        | 1,74        |
| 1,89        | 0,48 (l2)   | 0,48        |
| 1,80        | 0,86        | 0,78        |
| 1,93        | 0,58        | 0,63        |
| 1,91        | 0,59        | 0,62        |
| 1,76        | 0,47 (l3)   | 0,35 (l3)   |
| 1,78        | 0,39 (l3)   | 0,31 (l3)   |
| 1,61        | 0,65        | 0,37 (l3)   |
| 1,65        | 0,95        | 0,81        |

en este caso, con la distancia euclidea, clasificamos el primer ejemplo del lugar 1, pero el segundo ya no está indeterminado, lo podemos clasificar originario del lugar 3, y el último ejemplo pasas a estar clasificado ahora con origen el el lugar 3

</div>

<div class="highlight-exercise">

**Ejercicio 16**

En el marco de un estudio que trataba de decidir si existen diferencias en el tamaño del cráneo de los habitantes del antiguo Egipto en distintas épocas, se han recopilado las siguientes medidas de cráneos recuperados a partir de fósiles de hombres egipcios:

| Anchura máxima | Altura basio-bregmática | Longitud basioloalveolar | Altura nasal | Época      |
| -------------- | ----------------------- | ------------------------ | ------------ | ---------- |
| 131            | 138                     | 89                       | 49           | 4000 a. C. |
| 125            | 131                     | 92                       | 48           | 4000 a. C. |
| 131            | 132                     | 99                       | 50           | 4000 a. C. |
| 119            | 132                     | 96                       | 44           | 4000 a. C. |
| 136            | 143                     | 100                      | 54           | 4000 a. C. |
| 138            | 137                     | 89                       | 56           | 4000 a. C. |
| 139            | 130                     | 108                      | 48           | 4000 a. C. |
| 125            | 136                     | 93                       | 48           | 4000 a. C. |
| 131            | 134                     | 102                      | 51           | 4000 a. C. |
| 124            | 138                     | 101                      | 48           | 3300 a. C. |
| 133            | 134                     | 97                       | 48           | 3300 a. C. |
| 138            | 134                     | 98                       | 45           | 3300 a. C. |
| 148            | 129                     | 104                      | 51           | 3300 a. C. |
| 126            | 124                     | 95                       | 45           | 3300 a. C. |
| 135            | 136                     | 98                       | 52           | 3300 a. C. |
| 132            | 145                     | 100                      | 54           | 3300 a. C. |
| 133            | 130                     | 102                      | 48           | 3300 a. C. |
| 131            | 134                     | 96                       | 50           | 3300 a. C. |

Se pretende construir un clasificador 𝑘NN que identifique la época a la que pertenece un cráneo apartir de sus medidas, realizando una búsqueda en rejilla para elegir los valores de los hiperparámetros que maximicen la tasa de acierto del modelo. Para ello se pide:

- 1. Dividir el conjunto de entrenamiento en tres pliegues, cada uno de ellos con seis ejemplos, tres del 4000 a. C. y tres del 3300 a. C.

**Pliegue 1**

| Anchura máxima | Altura basio-bregmática | Longitud basioloalveolar | Altura nasal | Época      |
| -------------- | ----------------------- | ------------------------ | ------------ | ---------- |
| 131            | 138                     | 89                       | 49           | 4000 a. C. |
| 125            | 131                     | 92                       | 48           | 4000 a. C. |
| 131            | 132                     | 99                       | 50           | 4000 a. C. |
| 124            | 138                     | 101                      | 48           | 3300 a. C. |
| 133            | 134                     | 97                       | 48           | 3300 a. C. |
| 138            | 134                     | 98                       | 45           | 3300 a. C. |

**Pliegue 2**

| Anchura máxima | Altura basio-bregmática | Longitud basioloalveolar | Altura nasal | Época      |
| -------------- | ----------------------- | ------------------------ | ------------ | ---------- |
| 119            | 132                     | 96                       | 44           | 4000 a. C. |
| 136            | 143                     | 100                      | 54           | 4000 a. C. |
| 138            | 137                     | 89                       | 56           | 4000 a. C. |
| 148            | 129                     | 104                      | 51           | 3300 a. C. |
| 126            | 124                     | 95                       | 45           | 3300 a. C. |
| 135            | 136                     | 98                       | 52           | 3300 a. C. |

**Pliegue 3**

| Anchura máxima | Altura basio-bregmática | Longitud basioloalveolar | Altura nasal | Época      |
| -------------- | ----------------------- | ------------------------ | ------------ | ---------- |
| 139            | 130                     | 108                      | 48           | 4000 a. C. |
| 125            | 136                     | 93                       | 48           | 4000 a. C. |
| 131            | 134                     | 102                      | 51           | 4000 a. C. |
| 132            | 145                     | 100                      | 54           | 3300 a. C. |
| 133            | 130                     | 102                      | 48           | 3300 a. C. |
| 131            | 134                     | 96                       | 50           | 3300 a. C. |

- 2. Usando tanto la distancia Manhattan como la distancia euclídea y tomando 𝑘 = 1,3,5,7 como la cantidad de vecinos a considerar, estimar mediante un procedimiento de validación cruzada el rendimiento del modelo para cada combinación de los valores de esos dos hiperparámetros.

El objetivo de este apartado es evaluar cómo de bien funciona nuestro clasificador de vecinos más cercanos ($k$-NN) **con los datos originales en bruto**, es decir, tal y como nos los da el enunciado.

Para ello, tenemos que probar 8 configuraciones distintas combinando dos parámetros:

- **Dos medidas de distancia:** Manhattan y Euclídea.
- **Cuatro cantidades de vecinos ($k$):** 1, 3, 5 y 7.

Por cada una de estas 8 combinaciones, tenemos que realizar una **validación cruzada de 3 pliegues**. Esto significa hacer tres rondas de entrenamiento y examen para estimar el rendimiento de forma justa:

1.  **Ronda 1:** El modelo estudia los cráneos de los Pliegues 2 y 3 (12 ejemplos en total). Luego, le hacemos un examen pidiéndole que prediga la época de los 6 cráneos ocultos del **Pliegue 1**.
2.  **Ronda 2:** El modelo estudia los cráneos de los Pliegues 1 y 3. Se examina prediciendo los 6 cráneos ocultos del **Pliegue 2**.
3.  **Ronda 3:** El modelo estudia los cráneos de los Pliegues 1 y 2. Se examina prediciendo los 6 cráneos ocultos del **Pliegue 3**.

Al final, sumamos los aciertos de las tres rondas (sobre un total de 18 cráneos evaluados) para obtener la tasa de acierto media.

Aquí tienes la tabla con los resultados matemáticos exactos tras calcular todas las distancias entre los cráneos:

| Medida de distancia | Número de vecinos ($k$) | Aciertos Pliegue 1 | Aciertos Pliegue 2 | Aciertos Pliegue 3 | Tasa de acierto media (sobre 18) |
| :------------------ | :---------------------- | :----------------- | :----------------- | :----------------- | :------------------------------- |
| **Manhattan**       | **$k=1$**               | 3/6                | 3/6                | 2/6                | 8/18 $\approx$ **44,44%**        |
| **Manhattan**       | **$k=3$**               | 4/6                | 3/6                | 3/6                | 10/18 $\approx$ **55,55%**       |
| **Manhattan**       | **$k=5$**               | 3/6                | 2/6                | 4/6                | 9/18 = **50,00%**                |
| **Manhattan**       | **$k=7$**               | 1/6                | 3/6                | 3/6                | 7/18 $\approx$ **38,88%**        |
| **Euclídea**        | **$k=1$**               | 4/6                | 3/6                | 3/6                | 10/18 $\approx$ **55,55%**       |
| **Euclídea**        | **$k=3$**               | 3/6                | 3/6                | 4/6                | 10/18 $\approx$ **55,55%**       |
| **Euclídea**        | **$k=5$**               | 4/6                | 3/6                | 3/6                | 10/18 $\approx$ **55,55%**       |
| **Euclídea**        | **$k=7$**               | 3/6                | 3/6                | 3/6                | 9/18 = **50,00%**                |

**¿Qué conclusión sacamos de estos resultados?**

El rendimiento del modelo es **muy pobre**. La mejor tasa de acierto es apenas de un 55,55%, lo cual es prácticamente lo mismo que lanzar una moneda al aire para adivinar
si el cráneo pertenece al año 4000 a.C. o al 3300 a.C.

**¿Por qué falla tanto el modelo?**
Porque estamos calculando la distancia geométrica con los **datos en bruto**. En la tabla del enunciado, hay medidas numéricamente muy grandes (como la _Anchura máxima_ o
la _Altura basio-bregmática_, que rondan los 130-140 milímetros) y medidas numéricamente más pequeñas (como la _Altura nasal_, que ronda los 45 milímetros).

Al no estar los datos en la misma escala, las diferencias matemáticas en los atributos grandes "aplastan" y anulan por completo la información útil que podrían aportar los
atributos pequeños.

Esta es la respuesta completa y el análisis del apartado 2. Precisamente para solucionar este grave problema, el **apartado 3** nos pide que repitamos este mismo
experimento, pero **tipificando (normalizando)** los atributos de los cráneos para que todos tengan la misma importancia.

`Nota`

> ¡Muy buena pregunta! Usé la palabra "estudiar" de forma coloquial para referirme al proceso que formalmente llamamos **entrenar** el modelo. Sin >embargo, en el caso
> específico del algoritmo k-NN (k vecinos más cercanos), este proceso de entrenamiento es muy particular y directo.
>
> En otros algoritmos de aprendizaje automático, "entrenar" implica realizar cálculos matemáticos complejos para ajustar una fórmula (como calcular las >probabilidades en
> Naive Bayes). Pero en k-NN, el modelo no construye ninguna abstracción o ecuación. Tal y como explica la teoría, "para construir un >modelo kNN basta memorizar los
> ejemplos del conjunto de entrenamiento".
>
> Por tanto, al tratarse de un modelo no paramétrico, sus "parámetros" son literalmente los propios ejemplos que le proporcionamos.
>
> Cuando digo que el modelo "estudia" los cráneos de los pliegues de entrenamiento (por ejemplo, los Pliegues 2 y 3), quiero decir exactamente lo siguiente:
>
> 1.  **Memorización pura:** El sistema se limita a guardar en su memoria la tabla con las cuatro medidas biométricas y la época real a la que pertenecen >esos 12 cráneos.
>     Durante esta fase no hace absolutamente ningún cálculo general.
> 2.  **El "examen" (predicción):** Cuando le presentamos un cráneo nuevo del conjunto de prueba (del Pliegue 1) para que averigüe su época, el modelo recurre a su memoria
>     y calcula la distancia matemática (euclídea o Manhattan) entre las medidas de este cráneo desconocido y las medidas de cada uno de los 12 cráneos que memorizó.
> 3.  **La decisión:** Tras medir todas las distancias, identifica cuáles son los $k$ cráneos memorizados que tienen una distancia menor al nuevo (es >decir, sus $k$
>     "vecinos más cercanos"). La predicción final del modelo será, simplemente, asignar al cráneo nuevo la época mayoritaria entre esos vecinos más cercanos.
>
> En resumen, "estudiar" para el modelo $k$-NN es un proceso puramente memorístico: archiva todos los datos de entrenamiento tal cual y, a la hora de >predecir, los usa
> como una base de datos para buscar qué ejemplos pasados se parecen más al nuevo problema que le estamos planteando.

---

- Vamos a resolver el apartado 3, que consiste en repetir el mismo experimento pero **tipificando (normalizando)** los atributos de los cráneos para quetodos tengan la
  misma importancia.

Necesitamos calcular:

- Media de un atributo: $\mu = \frac{1}{N} \sum_{i=1}^{N} x_i$
- Varianza de un atributo: $Var = \frac{1}{N} \sum_{i=1}^{N} (x_i - \mu)^2$
- Desviación típica de un atributo: $\sigma = \sqrt{Var} = \sqrt{\frac{1}{N} \sum_{i=1}^{N} (x_i - \mu)^2}$

Una vez conocidos estos datos, la fórmula para tipificar un valor $x$ es:

$$z = \frac{x - \mu}{\sigma}$$

Añadimos una nueva fila para la media, otra para la varianza y otra para la desviación típica de cada atributo para cada uno de los tres pliegues.

**Pliegues 2 y 3 (entrenamiento) - normalizados**

Para tipificar los datos de cada pliegue, se resta la media de cada atributo y se divide entre la desviación típica de ese atributo.

$$x_{norm} = \frac{x - \mu}{\sigma}$$

Sobre estos datos calculamos la media, varianza y desviación típica de cada atributo.

|           | Anchura máx | z     | Altura b-b | z     | Long. basioloalveolar | z     | Altura nasal | z     | Época      |
| --------- | ----------- | ----- | ---------- | ----- | --------------------- | ----- | ------------ | ----- | ---------- |
|           | 119         | -1.69 | 132        | -0.21 | 96                    | -0.18 | 44           | -1.77 | 4000 a. C. |
|           | 136         | 0.40  | 143        | 1.34  | 100                   | 0.55  | 54           | 1.03  | 4000 a. C. |
|           | 138         | 0.65  | 137        | 0.49  | 89                    | -1.47 | 56           | 1.59  | 4000 a. C. |
|           | 148         | 1.87  | 129        | -0.63 | 104                   | 1.28  | 51           | 0.19  | 3300 a. C. |
|           | 126         | -0.83 | 124        | -1.34 | 95                    | -0.37 | 45           | -1.49 | 3300 a. C. |
|           | 135         | 0.28  | 136        | 0.35  | 98                    | 0.18  | 52           | 0.47  | 3300 a. C. |
|           | 139         | 0.77  | 130        | -0.49 | 108                   | 2.01  | 48           | -0.65 | 4000 a. C. |
|           | 125         | -0.95 | 136        | 0.35  | 93                    | -0.73 | 48           | -0.65 | 4000 a. C. |
|           | 131         | -0.21 | 134        | 0.07  | 102                   | 0.92  | 51           | 0.19  | 4000 a. C. |
|           | 132         | -0.09 | 145        | 1.62  | 100                   | 0.55  | 54           | 1.03  | 3300 a. C. |
|           | 133         | 0.03  | 130        | -0.49 | 102                   | 0.92  | 48           | -0.65 | 3300 a. C. |
|           | 131         | -0.21 | 134        | 0.07  | 96                    | -0.18 | 50           | -0.09 | 3300 a. C. |
| **Media** | 132.75      | 0     | 133.50     | 0     | 97.00                 | 0     | 50.33        | 0     |            |
| **Var**   | 66.22       |       | 50.25      |       | 29.83                 |       | 12.72        |       |            |
| **σ**     | 8.14        |       | 7.09       |       | 5.46                  |       | 3.57         |       |            |

**Pliegue 1 normalizado**

|     | Anchura máx | z     | Altura b‑b | z     | Longitud | z     | Altura nasal | z     | Época      |
| --- | ----------- | ----- | ---------- | ----- | -------- | ----- | ------------ | ----- | ---------- |
|     | 131         | -0.21 | 138        | 0.63  | 89       | -1.47 | 49           | -0.37 | 4000 a. C. |
|     | 125         | -0.95 | 131        | -0.35 | 92       | -0.92 | 48           | -0.65 | 4000 a. C. |
|     | 131         | -0.21 | 132        | -0.21 | 99       | 0.37  | 50           | -0.09 | 4000 a. C. |
|     | 124         | -1.08 | 138        | 0.63  | 101      | 0.73  | 48           | -0.65 | 3300 a. C. |
|     | 133         | 0.03  | 134        | 0.07  | 97       | 0.00  | 48           | -0.65 | 3300 a. C. |
|     | 138         | 0.65  | 134        | 0.07  | 98       | 0.18  | 45           | -1.49 | 3300 a. C. |

--

**Pliegues 1 y 3 (entrenamiento)**

|              | Anchura máxima  | Altura basio-bregmática    | Longitud basioloalveolar    | Altura nasal   | Época        |
| ------------ | --------------- | -------------------------- | --------------------------- | -------------- | ------------ |
|              | 131             | 138                        | 89                          | 49             | 4000 a. C.   |
|              | 125             | 131                        | 92                          | 48             | 4000 a. C.   |
|              | 131             | 132                        | 99                          | 50             | 4000 a. C.   |
|              | 124             | 138                        | 101                         | 48             | 3300 a. C.   |
|              | 133             | 134                        | 97                          | 48             | 3300 a. C.   |
|              | 138             | 134                        | 98                          | 45             | 3300 a. C.   |
|              | 139             | 130                        | 108                         | 48             | 4000 a. C.   |
|              | 125             | 136                        | 93                          | 48             | 4000 a. C.   |
|              | 131             | 134                        | 102                         | 51             | 4000 a. C.   |
|              | 132             | 145                        | 100                         | 54             | 3300 a. C.   |
|              | 133             | 130                        | 102                         | 48             | 3300 a. C.   |
|              | 131             | 134                        | 96                          | 50             | 3300 a. C.   |
| ------------ | --------------- | -------------------------- | --------------------------- | -------------- | ------------ |
| **Media**    | 131.08          | 134.67                     | 98.08                       | 48.92          |              |
| **Var**      | 20.24           | 16.39                      | 24.41                       | 4.41           |              |
| **σ**        | 4.50            | 4.05                       | 4.94                        | 2.10           |              |

**Pliegue 2 - normalización (pruebas)**

|     | Anchura máx | z     | Altura b‑b | z     | Longitud | z     | Altura nasal | z     | Época      |
| --- | ----------- | ----- | ---------- | ----- | -------- | ----- | ------------ | ----- | ---------- |
|     | 119         | -2.68 | 132        | -0.66 | 96       | -0.42 | 44           | -2.34 | 4000 a. C. |
|     | 136         | 1.09  | 143        | 2.06  | 100      | 0.39  | 54           | 2.42  | 4000 a. C. |
|     | 138         | 1.54  | 137        | 0.58  | 89       | -1.84 | 56           | 3.37  | 4000 a. C. |
|     | 148         | 3.76  | 129        | -1.40 | 104      | 1.20  | 51           | 0.99  | 3300 a. C. |
|     | 126         | -1.13 | 124        | -2.63 | 95       | -0.62 | 45           | -1.87 | 3300 a. C. |
|     | 135         | 0.87  | 136        | 0.33  | 98       | -0.02 | 52           | 1.47  | 3300 a. C. |

--

**Pliegue 1 y 2 (entrenamiento)**

|              | Anchura máx  | z     | Altura b‑b   | z     | Longitud   | z     | Altura nasal   | z     | Época      |
| ------------ | ------------ | ----- | ------------ | ----- | ---------- | ----- | -------------- | ----- | ---------- |
|              | 131          | -0.13 | 138          | 0.85  | 89         | -1.69 | 49             | -0.05 | 4000 a. C. |
|              | 125          | -0.93 | 131          | -0.63 | 92         | -1.02 | 48             | -0.33 | 4000 a. C. |
|              | 131          | -0.13 | 132          | -0.42 | 99         | 0.56  | 50             | 0.24  | 4000 a. C. |
|              | 124          | -1.07 | 138          | 0.85  | 101        | 1.02  | 48             | -0.33 | 3300 a. C. |
|              | 133          | 0.13  | 134          | 0.00  | 97         | 0.11  | 48             | -0.33 | 3300 a. C. |
|              | 138          | 0.80  | 134          | 0.00  | 98         | 0.34  | 45             | -1.19 | 3300 a. C. |
|              | 119          | -1.74 | 132          | -0.42 | 96         | -0.11 | 44             | -1.47 | 4000 a. C. |
|              | 136          | 0.53  | 143          | 1.90  | 100        | 0.79  | 54             | 1.38  | 4000 a. C. |
|              | 138          | 0.80  | 137          | 0.64  | 89         | -1.69 | 56             | 1.95  | 4000 a. C. |
|              | 148          | 2.13  | 129          | -1.06 | 104        | 1.69  | 51             | 0.52  | 3300 a. C. |
|              | 126          | -0.80 | 124          | -2.11 | 95         | -0.34 | 45             | -1.19 | 3300 a. C. |
|              | 135          | 0.40  | 136          | 0.42  | 98         | 0.34  | 52             | 0.81  | 3300 a. C. |
| ------------ | ------------ | ----  | ------------ | ----  | ---------- | ----  | -------------- | ----  | --------   |
| **Media**    | 132.00       | 0     | 134.00       | 0     | 96.50      | 0     | 49.17          | 0     |            |
| **Var**      | 56.17        |       | 22.33        |       | 19.58      |       | 12.31          |       |            |
| **σ**        | 7.49         |       | 4.73         |       | 4.43       |       | 3.51           |       |            |

**Pliegue 3 (pruebas)**

|     | Anchura máx | z     | Altura b‑b | z     | Longitud | z     | Altura nasal | z     | Época      |
| --- | ----------- | ----- | ---------- | ----- | -------- | ----- | ------------ | ----- | ---------- |
|     | 139         | 0.93  | 130        | -0.85 | 108      | 2.60  | 48           | -0.33 | 4000 a. C. |
|     | 125         | -0.93 | 136        | 0.42  | 93       | -0.79 | 48           | -0.33 | 4000 a. C. |
|     | 131         | -0.13 | 134        | 0.00  | 102      | 1.24  | 51           | 0.52  | 4000 a. C. |
|     | 132         | 0.00  | 145        | 2.33  | 100      | 0.79  | 54           | 1.38  | 3300 a. C. |
|     | 133         | 0.13  | 130        | -0.85 | 102      | 1.24  | 48           | -0.33 | 3300 a. C. |
|     | 131         | -0.13 | 134        | 0.00  | 96       | -0.11 | 50           | 0.24  | 3300 a. C. |

Ya hemos normalizado los datos de los tres pliegues, y ahora podemos repetir el mismo procedimiento de validación cruzada que hicimos en el apartado 2, pero usando
estos datos normalizados.

**Proceso general a seguir:**

Para cada pliegue (validación cruzada):

- 1. Separar train / test (Hecho)
- 2. Normalizar (train y test) usando SOLO train para calcular media y desviación típica (Hecho)
- 3. Para cada punto de test:
  - Calculas distancias a TODOS los puntos de train
  - Coges el más cercano (k=1)
  - Le asignas su clase
- 4. Comparas con la clase real
- 5. Calculas accuracy: $ \text{accuracy} = \frac{\text{número de aciertos}}{\text{número total de ejemplos}}$

**Pliegue 1 -> test, pliegues 2 y 3 -> train**

- Primer caso k=1, distancia Manhattan.

Train:

| z Anchura máx | z Altura b-b | z Long. basioloalveolar | z Altura nasal | Época      |
| ------------- | ------------ | ----------------------- | -------------- | ---------- |
| -1.69         | -0.21        | -0.18                   | -1.77          | 4000 a. C. |
| 0.40          | 1.34         | 0.55                    | 1.03           | 4000 a. C. |
| 0.65          | 0.49         | -1.47                   | 1.59           | 4000 a. C. |
| 1.87          | -0.63        | 1.28                    | 0.19           | 3300 a. C. |
| -0.83         | -1.34        | -0.37                   | -1.49          | 3300 a. C. |
| 0.28          | 0.35         | 0.18                    | 0.47           | 3300 a. C. |
| 0.77          | -0.49        | 2.01                    | -0.65          | 4000 a. C. |
| -0.95         | 0.35         | -0.73                   | -0.65          | 4000 a. C. |
| -0.21         | 0.07         | 0.92                    | 0.19           | 4000 a. C. |
| -0.09         | 1.62         | 0.55                    | 1.03           | 3300 a. C. |
| 0.03          | -0.49        | 0.92                    | -0.65          | 3300 a. C. |
| -0.21         | 0.07         | -0.18                   | -0.09          | 3300 a. C. |

test:

| z Anchura máx | z Altura b-b | z Longitud | z Altura nasal | Época      |
| ------------- | ------------ | ---------- | -------------- | ---------- |
| -0.21         | 0.63         | -1.47      | -0.37          | 4000 a. C. |
| -0.95         | -0.35        | -0.92      | -0.65          | 4000 a. C. |
| -0.21         | -0.21        | 0.37       | -0.09          | 4000 a. C. |
| -1.08         | 0.63         | 0.73       | -0.65          | 3300 a. C. |
| 0.03          | 0.07         | 0.00       | -0.65          | 3300 a. C. |
| 0.65          | 0.07         | 0.18       | -1.49          | 3300 a. C. |

Distancia Manhattan (k=1):

|       | train1 | train2 | train3 | train4 | train5 | train6   | train7 | train8   | train9 | train10 | train11 | train12  |
| ----- | ------ | ------ | ------ | ------ | ------ | -------- | ------ | -------- | ------ | ------- | ------- | -------- |
| test1 | 5.01   | 4.74   | 2.96   | 6.65   | 4.81   | 3.26     | 5.86   | **2.04** | 3.51   | 4.53    | 4.03    | 2.13     |
| test2 | 2.74   | 6.19   | 5.23   | 6.14   | 2.50   | 4.15     | 4.79   | **0.89** | 3.84   | 5.98    | 2.96    | 2.46     |
| test3 | 3.71   | 3.46   | 5.08   | 3.69   | 3.89   | 1.80     | 3.46   | 2.96     | 1.11   | 3.25    | 1.63    | **0.83** |
| test4 | 3.48   | 4.05   | 6.31   | 5.60   | 4.16   | 3.31     | 4.25   | **1.87** | 2.46   | 3.84    | 2.42    | 2.90     |
| test5 | 3.30   | 3.87   | 4.75   | 4.66   | 3.48   | 1.83     | 3.31   | 1.99     | 2.00   | 3.90    | 1.48    | **0.98** |
| test6 | 3.26   | 4.41   | 5.15   | 4.70   | 3.44   | **2.61** | 3.35   | 3.63     | 3.28   | 5.18    | 2.76    | 2.62     |

Para test1 -> mínimo = 2.04 -> train8 -> 4000 a. C. -> real 4000 a. C. ✅
Para test2 -> mínimo = 0.89 -> train8 -> 4000 a. C. -> real 4000 a. C. ✅
Para test3 -> mínimo = 0.83 -> train12 -> 3300 a. C. -> real 4000 a. C. ❌
Para test4 -> mínimo = 1.87 -> train8 -> 4000 a. C. -> real 3300 a. C. ❌
Para test5 -> mínimo = 0.98 -> train12 -> 3300 a. C. -> real 3300 a. C. ✅
Para test6 -> mínimo = 2.61 -> train6 -> 3300 a. C. -> real 3300 a. C. ✅

Accuracy = 4/6 = 0.6667 = 66.67%

Distancia Manhattan (k=3):

|       | train1 | train2 | train3   | train4 | train5   | train6   | train7 | train8   | train9   | train10 | train11  | train12  |
| ----- | ------ | ------ | -------- | ------ | -------- | -------- | ------ | -------- | -------- | ------- | -------- | -------- |
| test1 | 5.01   | 4.74   | **2.96** | 6.65   | 4.81     | 3.26     | 5.86   | **2.04** | 3.51     | 4.53    | 4.03     | **2.13** |
| test2 | 2.74   | 6.19   | 5.23     | 6.14   | **2.50** | 4.15     | 4.79   | **0.89** | 3.84     | 5.98    | 2.96     | **2.46** |
| test3 | 3.71   | 3.46   | 5.08     | 3.69   | 3.89     | 1.80     | 3.46   | 2.96     | **1.11** | 3.25    | **1.63** | **0.83** |
| test4 | 3.48   | 4.05   | 6.31     | 5.60   | 4.16     | 3.31     | 4.25   | **1.87** | **2.46** | 3.84    | **2.42** | 2.90     |
| test5 | 3.30   | 3.87   | 4.75     | 4.66   | 3.48     | **1.83** | 3.31   | 1.99     | 2.00     | 3.90    | **1.48** | **0.98** |
| test6 | 3.26   | 4.41   | 5.15     | 4.70   | 3.44     | **2.61** | 3.35   | 3.63     | 3.28     | 5.18    | **2.76** | **2.62** |

Para test1 -> vecinos más cercanos = train3, train8, train12 -> 4000 a. C., 4000 a. C., 3300 a. C. -> mayoría = 4000 a. C. -> real 4000 a. C. ✅
Para test2 -> vecinos más cercanos = train5, train8, train12 -> 3300 a. C., 4000 a. C., 3300 a. C -> mayoría = 3300 a. C. -> real 4000 a. C. ❌
Para test3 -> vecinos más cercanos = train9, train11, train12 -> 4000 a. C., 3300 a. C., 3300 a. C. -> mayoría = 3300 a. C. -> real 4000 a. C. ❌
Para test4 -> vecinos más cercanos = train8, train9, train11 -> 4000 a. C., 4000 a. C., 3300 a. C. -> mayoría = 4000 a. C. -> real 3300 a. C. ❌
Para test5 -> vecinos más cercanos = train6, train11, train12 -> 3300 a. C., 3300 a. C., 3300 a. C -> mayoría = 3300 a. C. -> real 3300 a. C. ✅
Para test6 -> vecinos más cercanos = train6, train11, train12 -> 3300 a. C., 3300 a. C., 3300 a. C -> mayoría = 3300 a. C. -> real 3300 a. C. ✅

Accuracy = 3/6 = 0.5000 = 50.00%

Distancia Manhattan (k=5):

|       | train1   | train2 | train3   | train4 | train5   | train6   | train7 | train8   | train9   | train10 | train11  | train12  |
| ----- | -------- | ------ | -------- | ------ | -------- | -------- | ------ | -------- | -------- | ------- | -------- | -------- |
| test1 | 5.01     | 4.74   | **2.96** | 6.65   | 4.81     | **3.26** | 5.86   | **2.04** | **3.51** | 4.53    | 4.03     | **2.13** |
| test2 | **2.74** | 6.19   | 5.23     | 6.14   | **2.50** | 4.15     | 4.79   | **0.89** | 3.84     | 5.98    | **2.96** | **2.46** |
| test3 | 3.71     | 3.46   | 5.08     | 3.69   | 3.89     | **1.80** | 3.46   | **2.96** | **1.11** | 3.25    | **1.63** | **0.83** |
| test4 | 3.48     | 4.05   | 6.31     | 5.60   | 4.16     | **3.31** | 4.25   | **1.87** | **2.46** | 3.84    | **2.42** | **2.90** |
| test5 | 3.30     | 3.87   | 4.75     | 4.66   | 3.48     | **1.83** | 3.31   | **1.99** | **2.00** | 3.90    | **1.48** | **0.98** |
| test6 | **3.26** | 4.41   | 5.15     | 4.70   | 3.44     | **2.61** | 3.35   | 3.63     | **3.28** | 5.18    | **2.76** | **2.62** |

Para test1 -> vecinos más cercanos = train3, train6, train8, train9, train12 -> 4000 a. C., 3300 a. C., 4000 a. C., 4000 a. C., 3300 a. C. -> mayoría = 4000 a. C. -> real 4000 a. C. ✅
Para test2 -> vecinos más cercanos = train1, train5, train8, train11, train12 -> 4000 a. C., 3300 a. C., 4000 a. C., 3300 a. C., 3300 a. C -> mayoría = 3300 a. C. -> real 4000 a. C. ❌
Para test3 -> vecinos más cercanos = train6, train8, train9, train11, train12 -> 3300 a. C., 4000 a. C., 4000 a. C., 3300 a. C., 3300 a. C. -> mayoría = 3300 a. C. -> real 4000 a. C. ❌
Para test4 -> vecinos más cercanos = train6, train8, train9, train11, train12 -> 3300 a. C., 4000 a. C., 4000 a. C., 3300 a. C., 3300 a. C. -> mayoría = 3300 a. C. -> real 3300 a. C. ✅
Para test5 -> vecinos más cercanos = train6, train8, train9, train11, train12 -> 3300 a. C., 4000 a. C., 4000 a. C., 3300 a. C., 3300 a. C. -> mayoría = 3300 a. C. -> real 3300 a. C. ✅
Para test6 -> vecinos más cercanos = train1, train6, train8, train9, train11 -> 4000 a. C., 3300 a. C., 4000 a. C., 4000 a. C., 3300 a. C. -> mayoría = 4000 a. C. -> real 3300 a. C. ❌

Accuracy = 3/6 = 0.5000 = 50.00%

<div class="summary">

**RESUMEN KNN + VALIDACIÓN CRUZADA**

**1. Para cada combinación (k y métrica)**

Ejemplo:

- k = 1, 3, 5, 7
- Métrica = Manhattan / Euclídea

👉 Cada combinación es **un modelo distinto**

---

**2. Validación cruzada (3 pliegues)**

Para cada k:

1. Dividir en 3 pliegues
2. Repetir 3 veces:
   - train = 2 pliegues
   - test = 1 pliegue
   - normalizar con **media y σ del train**
   - calcular distancias
   - clasificar con KNN
   - calcular accuracy

---

**3. Calcular accuracy media**

$$
accuracy_k = \frac{A_1 + A_2 + A_3}{3}
$$

👉 (media de los 3 pliegues)

---

**4. NO hacer esto**

❌ NO mezclar resultados de distintos k  
❌ NO calcular media entre k=1, k=3, etc.

---

**5. Resultado final**

Tabla por métrica:

```
Manhattan:
k=1 → 66.67%
k=3 → 50.00%
k=5 → ...
k=7 → ...

Euclídea:
k=1 → ...
...
```

---

**6. Elección del mejor modelo**

👉 Elegir el **k (y métrica) con mayor accuracy media**

---

</div>

</div>
