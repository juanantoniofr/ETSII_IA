### 4. kNN

- Puede abordar problemas de clasificación y regresión.

#### 4.1 Realización de la tarea

El modelo **k vecinos más cercanos (kNN)** es un algoritmo de aprendizaje supervisado y no paramétrico que se utiliza para resolver tanto tareas de clasificación como de regresión. Su funcionamiento se basa en la intuición de la similitud: para decidir sobre un nuevo caso, se apoya en los ejemplos del pasado que resulten más parecidos. De hecho, "aprender" o entrenar este modelo consiste pura y simplemente en memorizar todos los ejemplos del conjunto de entrenamiento.

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
Esta fórmula transforma los datos para que todos los valores del atributo queden comprimidos y se encuentren exactamente dentro del intervalo $$. La operación consiste en restar al valor original el mínimo del atributo y dividir este resultado por la diferencia entre el máximo y el mínimo:

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
> En el caso específico del algoritmo **k vecinos más cercanos (kNN)**, este se clasifica como no paramétrico porque el proceso de aprendizaje consiste únicamente en memorizar el conjunto de > > entrenamiento, por lo que **sus parámetros son, pura y simplemente, los propios ejemplos que ha memorizado**.
>
> A diferencia de los modelos paramétricos (como Naive Bayes), que resumen la información matemática en una fórmula fija y pueden borrar los datos de origen, en kNN **el modelo son los datos mismos**. Por lo tanto, a medida que le proporcionas más datos al algoritmo, el tamaño del modelo crece proporcionalmente, ya que necesita guardarlos absolutamente todos para poder comparar y calcular las distancias cuando tenga que clasificar un ejemplo nuevo.

#### 4.2 Ejercicio 13

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

## 2. Evaluación y selección de modelos

### 2.1 Métricas para Modelos de Clasificación

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

### 2.2 Métricas para Modelos de Regresión

| Métrica                                    | ¿Apropiada para? | Fórmula                                                     | Explicación                                                                                                                  | Interpretación (Aspectos relevantes)                                                                                                                                                                                                                               |
| :----------------------------------------- | :--------------- | :---------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Error Absoluto Medio (MAE)**             | Regresión        | $\frac{1}{\vert\mathcal{D}\vert}\sum \vert y-\hat{y}\vert$  | Calcula el promedio del error en valor absoluto cometido entre el valor predicho y el valor real correcto para cada ejemplo. | Da una idea directa de la magnitud del error promedio sin importar si el fallo del modelo fue por exceso o por defecto.                                                                                                                                            |
| **Error Cuadrático Medio (MSE)**           | Regresión        | $\frac{1}{\vert\mathcal{D}\vert}\sum(y-\hat{y})^{2}$        | Calcula el promedio de las diferencias al cuadrado entre el valor predicho y el valor real.                                  | Al elevarse al cuadrado, **penaliza de forma mucho más severa los errores grandes** frente a los pequeños. Al ser una función diferenciable, es más fácil de optimizar matemáticamente por los algoritmos.                                                         |
| **Raíz del Error Cuadrático Medio (RMSE)** | Regresión        | $\sqrt{\frac{1}{\vert\mathcal{D}\vert}\sum(y-\hat{y})^{2}}$ | Es la raíz cuadrada del Error Cuadrático Medio (MSE) calculado en el paso anterior.                                          | Su principal ventaja frente al MSE es que **devuelve el error medido exactamente en la misma unidad original** que el atributo objetivo, lo que facilita enormemente su comprensión en el contexto del problema.                                                   |
| **Coeficiente de determinación ($R^2$)**   | Regresión        | $1-\frac{MSE}{Var(\mathcal{D})}$                            | Compara el error cuadrático medio (MSE) del modelo con la varianza de los valores reales correctos del conjunto de datos.    | Mide la **calidad del ajuste numérico**. Un valor de 1 indica un ajuste perfecto; un 0 significa que el modelo es tan inútil como predecir siempre la media; y un valor negativo indica que las predicciones son peores que simplemente predecir la media siempre. |

_(Nota: **$y$** = valor real correcto, **$\hat{y}$** = valor numérico predicho por el modelo, **$Var(\mathcal{D})$** = varianza de los valores reales correctos, y **$\vert \mathcal{D} \vert$** = Total de ejemplos en el conjunto de datos evaluado)._

### 2.3 Ejercicios

#### Ejercicio 4

Una empresa de material deportivo quiere hacer un estudio de mercado para encontrar las características principales de sus potenciales clientes. En una primera fase se consideran la edad, el ser o no deportista profesional, el nivel de ingresos y el sexo. Tras realizar una encuesta, se obtienen los siguientes datos:

| Edad   | Deportista profesional | Nivel de ingresos | Sexo   | Interesado |
| ------ | ---------------------- | ----------------- | ------ | ---------- |
| joven  | sí                     | bajo              | hombre | sí         |
| joven  | sí                     | alto              | hombre | sí         |
| joven  | no                     | alto              | mujer  | no         |
| joven  | sí                     | bajo              | mujer  | sí         |
| joven  | no                     | medio             | mujer  | no         |
| adulto | sí                     | alto              | hombre | no         |
| adulto | no                     | alto              | mujer  | no         |
| adulto | sí                     | alto              | mujer  | no         |
| adulto | no                     | medio             | mujer  | no         |
| adulto | sí                     | bajo              | mujer  | no         |
| adulto | no                     | medio             | mujer  | no         |
| adulto | sí                     | medio             | hombre | no         |
| adulto | no                     | alto              | hombre | sí         |
| joven  | sí                     | alto              | mujer  | sí         |
| joven  | sí                     | medio             | hombre | sí         |

Se pide:

-1 Construir un modelo naive Bayes con suavizado de Laplace que prediga si un cliente está o no interesado en función del valor de los otros cuatro atributos.

- Probabilidades a priori de cada clase son, C_interesado = 6/15 C_no_interesado = 9/15
- La fórmula general de la probabilidad condicionada aplicando el suavizado de Laplace es la siguiente:

$$ \mathbb{P}(X=x|c) = \frac{N\_{x=x, c} + 1}{N_c + |X|} $$

Donde:

- **$N_{x=x, c}$**: es la cantidad de ejemplos en el conjunto de entrenamiento que pertenecen a la clase $c$ y en los que el atributo $X$ toma el valor $x$.
- **$N_c$**: es la cantidad total de ejemplos que pertenecen a la clase $c$.
- **$|X|$**: es la cantidad total de posibles valores distintos que puede tomar el atributo $X$.

Y aquí tienes la tabla con los primeros cálculos corregidos para el atributo **Edad** ($|X|=2$):

| Atributo ($X$) | Valor ($x$) | $\mathbb{P}(X=x \mid \text{interesado = sí})$       | $\mathbb{P}(X=x \mid \text{interesado = no})$                |
| :------------- | :---------- | :-------------------------------------------------- | :----------------------------------------------------------- |
| **Edad**       | **joven**   | $\frac{5 + 1}{6 + 2} = \frac{6}{8} = \mathbf{0.75}$ | $\frac{2 + 1}{9 + 2} = \frac{3}{11} \approx \mathbf{0.2727}$ |
| **Edad**       | **adulto**  | $\frac{1 + 1}{6 + 2} = \frac{2}{8} = \mathbf{0.25}$ | $\frac{7 + 1}{9 + 2} = \frac{8}{11} \approx \mathbf{0.7272}$ |

_(Nota: Como puedes observar en la tabla, la suma de las probabilidades de todos los valores posibles de un atributo dentro de una misma clase siempre da como resultado 1)._

| Atributo ($X$)              | Valor ($x$) | $\mathbb{P}(X=x \mid \text{interesado = sí})$        | $\mathbb{P}(X=x \mid \text{interesado = no})$                  |
| :-------------------------- | :---------- | :--------------------------------------------------- | :------------------------------------------------------------- |
| **deportista profesional**  | **sí**      | $\frac{5 + 1}{6 + 2} = \frac{6}{11} = \mathbf{0.75}$ | $\frac{4 + 1}{9 + 2} = \frac{5}{11} \approx \mathbf{0.0.4545}$ |
| **deportistan profesional** | **no**      | $\frac{1 + 1}{6 + 2} = \frac{2}{8} = \mathbf{0.25}$  | $\frac{5 + 1}{9 + 2} = \frac{6}{8} \approx \mathbf{0.5454}$    |

| Atributo ($X$)        | Valor ($x$) | $\mathbb{P}(X=x \mid \text{interesado = sí})$          | $\mathbb{P}(X=x \mid \text{interesado = no})$                |
| :-------------------- | :---------- | :----------------------------------------------------- | :----------------------------------------------------------- |
| **Nivel de ingresos** | **bajo**    | $\frac{2 + 1}{6 + 3} = \frac{3}{6} = \mathbf{0.3333}$  | $\frac{1 + 1}{9 + 3} = \frac{2}{6} \approx \mathbf{0.1666}$  |
| **Nivel de ingresos** | **medio**   | $\frac{1 + 1}{6 + 3} = \frac{2}{8} = \mathbf{0.2222}$  | $\frac{4 + 1}{9 + 3} = \frac{5}{8} \approx \mathbf{0.4166}$  |
| **Nivel de ingresos** | **alto**    | $\frac{3 + 1}{6 + 3} = \frac{4}{10} = \mathbf{0.4444}$ | $\frac{4 + 1}{9 + 3} = \frac{4}{10} \approx \mathbf{0.4166}$ |

| Atributo ($X$) | Valor ($x$) | $\mathbb{P}(X=x \mid \text{interesado = sí})$        | $\mathbb{P}(X=x \mid \text{interesado = no})$                |
| :------------- | :---------- | :--------------------------------------------------- | :----------------------------------------------------------- |
| **Sexo**       | **hombre**  | $\frac{4 + 1}{6 + 2} = \frac{5}{8} = \mathbf{0,625}$ | $\frac{2 + 1}{9 + 2} = \frac{3}{11} \approx \mathbf{0.2727}$ |
| **Sexo**       | **mujer**   | $\frac{2 + 1}{6 + 2} = \frac{3}{8} = \mathbf{0.375}$ | $\frac{7 + 1}{9 + 2} = \frac{8}{11} \approx \mathbf{0.7272}$ |

- 2. Construir la matriz de confusión que se tendría al usar ese modelo para clasificar los ejemplos del siguiente conjunto de prueba:

| Edad   | Deportista profesional | Nivel de ingresos | Sexo   | Interesado |
| ------ | ---------------------- | ----------------- | ------ | ---------- |
| adulto | no                     | medio             | hombre | no         |
| adulto | no                     | bajo              | hombre | no         |
| joven  | no                     | medio             | hombre | no         |
| joven  | no                     | bajo              | mujer  | no         |
| adulto | sí                     | medio             | mujer  | no         |
| joven  | sí                     | medio             | mujer  | sí         |

---

| Ejemplo 1     | P(c) | Adulto | no     | medio  | hombre | Producto | Casifica como |
| :------------ | ---- | ------ | ------ | ------ | ------ | -------- | ------------- |
| interesado    | 0,4  | 0.25   | 0.25   | 0.2222 | 0.625  | 0,0034   | XX            |
| no interesado | 0,6  | 0.7272 | 0.5454 | 0.4166 | 0.2727 | 0,0270   | No interesado |

Ejemplo 1 -> Acierto (VN) - Verdadero negativo

| Ejemplo 2     | P(C) | adulto | no     | bajo   | hombre | Producto | Clasifica como |
| :------------ | ---- | ------ | ------ | ------ | ------ | -------- | -------------- |
| interesado    | 0,4  | 0.25   | 0.25   | 0,3333 | 0.625  | 0,0052   | XX             |
| no interesado | 0,6  | 0.7272 | 0.5454 | 0.1666 | 0.2727 | 0,0108   | no interesado  |

Ejemplo 2 -> Acierto (VN) - verdadero negativo

| Ejemplo 3     | P(c) | joven  | no     | medio  | hombre | Producto | Calisifica como |
| :------------ | ---- | ------ | ------ | ------ | ------ | -------- | --------------- |
| interesado    | 0,4  | 0,75   | 0.25   | 0.2222 | 0.625  | 0,0104   | interesado      |
| no interesado | 0,6  | 0,2727 | 0.5454 | 0.4166 | 0.2727 | 0,0101   | XX              |

Ejemplo 3 - fallo (FP) - Falso positivo

| Ejemplo 4     | P(c) | joven  | no     | bajo   | mujer  | Producto | Clasifica como |
| :------------ | ---- | ------ | ------ | ------ | ------ | -------- | -------------- |
| interesado    | 0,4  | 0,75   | 0.25   | 0,3333 | 0,375  | 0,0093   | XX             |
| no interesado | 0,6  | 0,2727 | 0.5454 | 0,1666 | 0,7272 | 0,0108   | no interesado  |

Ejemplo 4 -> Acierto (VN) - Verdadero Negativo

| Ejemplo 5     | P(c) | adulto | sí     | medio  | mujer  | Producto | Clasifica como |
| :------------ | ---- | ------ | ------ | ------ | ------ | -------- | -------------- |
| interesado    | 0,4  | 0,25   | 0,75   | 0,2222 | 0,375  | 0,0062   | XX             |
| no interesado | 0,6  | 0,7272 | 0,4545 | 0,4166 | 0,7272 | 0,06     | no interesado  |

Ejemplo 5 -> acierto (VN) - verdadero negativo

| Ejemplo 6     | P(c) | joven  | sí     | medio  | mujer  | Producto | Clasifica como |
| :------------ | ---- | ------ | ------ | ------ | ------ | -------- | -------------- |
| interesado    | 0,4  | 0,75   | 0,75   | 0,2222 | 0,375  | 0,0187   | XX             |
| no interesado | 0,6  | 0,2727 | 0,4545 | 0,4166 | 0,7272 | 0,0225   | no interesado  |

Ejemplo 6 -> fallo (FN) -> falso negativo

**Matriz de confusión:**

$$
\begin{pmatrix}
VP & FP \\
FN & VN
\end{pmatrix}
$$

$$
\begin{pmatrix}
0 & 1 \\
1 & 4
\end{pmatrix}
$$

- 3. Derivar a partir de esa matriz de confusión todas las medidas posibles de rendimiento del modelo.

| Métrica                            |                                           | Fórmula                                                                                                                   | Resultado    |
| :--------------------------------- | :---------------------------------------- | :------------------------------------------------------------------------------------------------------------------------ | ------------ |
| **Exactitud o Tasa de acierto**    | $\frac{VP + VN}{\vert \mathcal{D} \vert}$ | Proporción total de ejemplos clasificados correctamente sobre el total de ejemplos evaluados ($\vert \mathcal{D} \vert$). | 4/6 = 0,6666 |
| **Tasa de error**                  | $\frac{FP + FN}{\vert \mathcal{D} \vert}$ | Proporción total de ejemplos que el modelo ha clasificado de manera incorrecta.                                           | 2/6 = 0,3333 |
| **Sensibilidad o Recuerdo (TPR)**  | $\frac{VP}{VP + FN}$                      | Proporción de ejemplos positivos reales que el modelo ha clasificado correctamente.                                       | 0            |
| **Especificidad (TNR)**            | $\frac{VN}{FP + VN}$                      | Proporción de ejemplos negativos reales que el modelo ha clasificado correctamente como negativos.                        | 4/5 = 0,8    |
| **Precisión**                      | $\frac{VP}{VP + FP}$                      | Proporción de ejemplos realmente positivos de entre todos los que el modelo ha clasificado como positivos.                | 0            |
| **Tasa de falsos positivos (FPR)** | $\frac{FP}{FP + VN}$                      | Proporción de ejemplos negativos reales que el modelo ha clasificado incorrectamente como positivos.                      | 1/5 = 0.2    |
| **Tasa de falsos negativos (FNR)** | $\frac{FN}{VP + FN}$                      | Proporción de ejemplos positivos reales que el modelo ha clasificado incorrectamente como negativos.                      | 1            |

## 3. Validación por retención y validación cruzada

El objetivo principal al evaluar un modelo no es solo saber cómo rinde con los datos que ya ha visto (los datos de entrenamiento), sino medir su **capacidad de generalización**: su aptitud para proporcionar la respuesta adecuada frente a **ejemplos nuevos** que no conoce previamente. Si un modelo acierta todo en el entrenamiento pero falla con datos nuevos, decimos que se ha **sobreajustado** (ha "memorizado" los datos en lugar de aprender el patrón subyacente).

Dado que no conocemos las respuestas de los datos futuros que el modelo procesará en el mundo real, usamos las técnicas de validación para simular ese escenario "ocultando" parte de la información al modelo durante su entrenamiento.

Aquí tienes en qué consisten los dos conceptos:

### 3.1 Validación por retención (_Holdout validation_)

Es el método más directo y el que hemos estado usando implícitamente en el Ejercicio 4. Consiste en **dividir el conjunto total de ejemplos en dos subconjuntos**:

- **Conjunto de entrenamiento:** Se usa para construir y aprender los parámetros del modelo.
- **Conjunto de prueba:** Se mantiene "retenido" (oculto) durante el entrenamiento. Solo se le muestra al modelo al final para evaluar su rendimiento, comparando sus predicciones con las respuestas correctas que ya conocemos.

**Aspectos clave:**

- La división suele ser aleatoria, reservando habitualmente entre un **20% y un 30%** de los datos para la prueba.
- Para tareas de clasificación es muy recomendable realizar un **muestreo estratificado**, lo que significa asegurarse de que la proporción de cada clase (ej. el porcentaje de "interesado" vs "no interesado") se mantenga igual en ambos subconjuntos.
- **Inconveniente:** Cuando el conjunto de datos total es pequeño, este método no es adecuado porque corremos el riesgo de dejar muy pocos datos para entrenar bien el modelo, o muy pocos datos para que la evaluación sea estadísticamente fiable.

### 3.2 Validación cruzada con k-pliegues (_k-fold cross validation_)

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

### 3.3 Ejercicio 16

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
| Anchura máxima | Altura basio-bregmática | Longitud basioloalveolar | Altura nasal | Época |
| -------------- | ----------------------- | ------------------------ | ------------ | ---------- |
| 131 | 138 | 89 | 49 | 4000 a. C. |
| 125 | 131 | 92 | 48 | 4000 a. C. |
| 131 | 132 | 99 | 50 | 4000 a. C. |
| 124 | 138 | 101 | 48 | 3300 a. C. |
| 133 | 134 | 97 | 48 | 3300 a. C. |
| 138 | 134 | 98 | 45 | 3300 a. C. |

**Pliegue 2**
| Anchura máxima | Altura basio-bregmática | Longitud basioloalveolar | Altura nasal | Época |
| 119 | 132 | 96 | 44 | 4000 a. C. |
| 136 | 143 | 100 | 54 | 4000 a. C. |
| 138 | 137 | 89 | 56 | 4000 a. C. |
| 148 | 129 | 104 | 51 | 3300 a. C. |
| 126 | 124 | 95 | 45 | 3300 a. C. |
| 135 | 136 | 98 | 52 | 3300 a. C. |

**Pliegue 3**
| Anchura máxima | Altura basio-bregmática | Longitud basioloalveolar | Altura nasal | Época |
| 139 | 130 | 108 | 48 | 4000 a. C. |
| 125 | 136 | 93 | 48 | 4000 a. C. |
| 131 | 134 | 102 | 51 | 4000 a. C. |
| 132 | 145 | 100 | 54 | 3300 a. C. |
| 133 | 130 | 102 | 48 | 3300 a. C. |
| 131 | 134 | 96 | 50 | 3300 a. C. |

- 2. Usando tanto la distancia Manhattan como la distancia euclídea y tomando 𝑘 = 1,3,5,7 como la cantidad de vecinos a considerar, estimar mediante un procedimiento devalidación cruzada el rendimiento del modelo para cada combinación de los valores de esos dos hiperparámetros.

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

#### ¿Qué conclusión sacamos de estos resultados?

El rendimiento del modelo es **muy pobre**. La mejor tasa de acierto es apenas de un 55,55%, lo cual es prácticamente lo mismo que lanzar una moneda al aire para adivinar si el cráneo pertenece al año 4000 a.C. o al 3300 a.C.

**¿Por qué falla tanto el modelo?**
Porque estamos calculando la distancia geométrica con los **datos en bruto**. En la tabla del enunciado, hay medidas numéricamente muy grandes (como la _Anchura máxima_ o la _Altura basio-bregmática_, que rondan los 130-140 milímetros) y medidas numéricamente más pequeñas (como la _Altura nasal_, que ronda los 45 milímetros).

Al no estar los datos en la misma escala, las diferencias matemáticas en los atributos grandes "aplastan" y anulan por completo la información útil que podrían aportar los atributos pequeños.

Esta es la respuesta completa y el análisis del apartado 2. Precisamente para solucionar este grave problema, el **apartado 3** nos pide que repitamos este mismo experimento, pero **tipificando (normalizando)** los atributos de los cráneos para que todos tengan la misma importancia.

`Nota`

> ¡Muy buena pregunta! Usé la palabra "estudiar" de forma coloquial para referirme al proceso que formalmente llamamos **entrenar** el modelo. Sin >embargo, en el caso específico del algoritmo $k$-NN ($k$ vecinos más cercanos), este proceso de entrenamiento es muy particular y directo.
>
> En otros algoritmos de aprendizaje automático, "entrenar" implica realizar cálculos matemáticos complejos para ajustar una fórmula (como calcular las >probabilidades en Naive Bayes). Pero en $k$-NN, el modelo no construye ninguna abstracción o ecuación. Tal y como explica la teoría, "para construir un >modelo kNN basta memorizar los ejemplos del conjunto de entrenamiento".
>
> Por tanto, al tratarse de un modelo no paramétrico, sus "parámetros" son literalmente los propios ejemplos que le proporcionamos.
>
> Cuando digo que el modelo "estudia" los cráneos de los pliegues de entrenamiento (por ejemplo, los Pliegues 2 y 3), quiero decir exactamente lo >siguiente:
>
> 1.  **Memorización pura:** El sistema se limita a guardar en su memoria la tabla con las cuatro medidas biométricas y la época real a la que pertenecen >esos 12 cráneos. Durante esta fase no hace absolutamente ningún cálculo general.
> 2.  **El "examen" (predicción):** Cuando le presentamos un cráneo nuevo del conjunto de prueba (del Pliegue 1) para que averigüe su época, el modelo >recurre a su memoria y calcula la distancia matemática (euclídea o Manhattan) entre las medidas de este cráneo desconocido y las medidas de cada uno de >los 12 cráneos que memorizó.
> 3.  **La decisión:** Tras medir todas las distancias, identifica cuáles son los $k$ cráneos memorizados que tienen una distancia menor al nuevo (es >decir, sus $k$ "vecinos más cercanos"). La predicción final del modelo será, simplemente, asignar al cráneo nuevo la época mayoritaria entre esos >vecinos más cercanos.
>
> En resumen, "estudiar" para el modelo $k$-NN es un proceso puramente memorístico: archiva todos los datos de entrenamiento tal cual y, a la hora de >predecir, los usa como una base de datos para buscar qué ejemplos pasados se parecen más al nuevo problema que le estamos planteando.
