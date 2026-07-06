<link rel="stylesheet" href="../css/estilo.css">

# Recopilación de las fórmulas de Teoría de Inteligencia Artificial

## Formulas estadísticas

<div class="highlight-exercise">

Estas funciones estadísticas son los "ladrillos" matemáticos con los que se construyen muchos procesos del Aprendizaje Automático, desde la normalización de datos hasta las decisiones internas de los algoritmos.

Aquí tienes las fórmulas y su aplicación exacta dentro de este contexto:

### 1. Media Aritmética ($\mu$ o $\overline{y}$)

Es el valor promedio matemático de un conjunto de datos.

- **Fórmula:** $\overline{y} = \frac{1}{|D|} \sum_{(x,y) \in D} y$. _(Es decir, se suman todos los valores y se divide el resultado entre la cantidad total de ejemplos $|D|$)._
- **¿Para qué se usa en Machine Learning?**
  - **Normalización (Tipificación):** Es el valor central ($\mu$) que se le resta a cada atributo numérico para centrar los datos.
  - **Predicciones de Regresión:** En algoritmos como kNN, la predicción final es la media de los valores de los vecinos cercanos. De igual forma, en los árboles CART de regresión, cada nodo hoja se etiqueta usando la media de los valores que han caído en él.

### 2. Varianza ($Var(D)$ o $\sigma^2$)

Mide cómo de "dispersos" o separados están los datos con respecto a su propia media. Matemáticamente, es el promedio de las diferencias al cuadrado entre cada valor individual y la media general.

- **Fórmula:** $Var(D) = \frac{1}{|D|} \sum_{(x,y) \in D} (y - \overline{y})^2$.
- **¿Para qué se usa en Machine Learning?**
  - **Árboles CART de Regresión:** La varianza se utiliza como la **función de impureza**. El árbol busca dividir los datos intentando que los subconjuntos resultantes tengan la varianza más pequeña posible. Si en una rama todos los ejemplos tienen exactamente el mismo valor numérico, la varianza es cero y se considera un nodo "puro".
  - **Coeficiente de Determinación ($R^2$):** Se utiliza en el denominador de su fórmula para comparar el error de la red neuronal con la varianza natural de los datos.

### 3. Desviación Típica ($\sigma$)

Es la medida directa de dispersión que acompaña a la media.

- **Fórmula / Concepto:** Aunque a nivel conceptual es la raíz cuadrada de la varianza, en los apuntes se denota universalmente como $\sigma$.
- **¿Para qué se usa en Machine Learning?**
  - Es el divisor clave en la **Tipificación** (o Z-score): $x_{norm} = \frac{x - \mu}{\sigma}$. Se utiliza para escalar o comprimir los atributos numéricos de forma que todos terminen teniendo exactamente desviación típica 1 y media 0.

---

<div class="clarification">

## Varianza vs Desviación Típica

Ambas medidas estadísticas sirven para cuantificar la **dispersión** de un conjunto de datos (es decir, qué tan alejados o concentrados están los valores respecto a su media). Sin embargo, cumplen roles distintos en el análisis de datos.

La diferencia fundamental entre ambas radica en **las unidades de medida en las que se expresan**.

---

### 1. La Varianza ($\sigma^2$ o $s^2$)

La varianza es el promedio de las diferencias al cuadrado entre cada dato y la media aritmética:

$$\sigma^2 = \frac{\sum_{i=1}^{n} (x_i - \mu)^2}{n}$$

- **Sus unidades:** Al elevar al cuadrado las diferencias para evitar que los valores positivos y negativos se cancelen entre sí, el resultado queda expresado en **unidades al cuadrado**. Por ejemplo, si tus datos son salarios en _euros_, la varianza se expresará en _euros al cuadrado_ ($\text{euros}^2$).
- **¿Qué te dice de los datos?** \* **Penaliza los valores extremos:** Debido al exponente al cuadrado, los datos que están muy alejados de la media (los valores atípicos) aumentan drásticamente el valor de la varianza.
- **Utilidad matemática:** Conceptualmente no es intuitiva para el ser humano (nadie piensa en "euros al cuadrado" o "metros al cuadrado de altura"), pero es el motor fundamental de la estadística inferencial. Es indispensable para modelos matemáticos, optimización de algoritmos, regresiones y análisis de varianza (ANOVA).

---

### 2. La Desviación Típica o Estándar ($\sigma$ o $s$)

La desviación típica es simplemente la raíz cuadrada positiva de la varianza:

$$\sigma = \sqrt{\sigma^2}$$

- **Sus unidades:** Al aplicar la raíz cuadrada, revertimos el efecto del cuadrado y devolvemos la medida a las **mismas unidades originales de los datos** (en nuestro ejemplo, _euros_).
- **¿Qué te dice de los datos?**
- **Distancia promedio intuitiva:** Te indica aproximadamente cuánto se desvía, en promedio, un dato típico respecto a la media del grupo. Si la media de un salario es $1500\text{ €}$ y la desviación típica es $150\text{ €}$, sabes directamente cómo se distribuyen los sueldos en el mundo real.
- **Reglas de distribución:** En distribuciones normales (o con forma de campana), te permite aplicar la regla empírica del **68 - 95 - 99.7**:

- Aproximadamente el **68%** de los datos se encuentra a una distancia de $\pm 1\sigma$ de la media.
- El **95%** está dentro de $\pm 2\sigma$.
- El **99.7%** está dentro de $\pm 3\sigma$.

---

### Resumen Comparativo

| Característica          | Varianza ($\sigma^2$)                                            | Desviación Típica ($\sigma$)                                 |
| ----------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------ |
| **Unidades**            | Unidades al cuadrado ($\text{m}^2$, $\text{kg}^2$, $\text{€}^2$) | Unidades originales ($\text{m}$, $\text{kg}$, $\text{€}$)    |
| **Interpretación**      | Difícil de interpretar intuitivamente                            | Muy intuitiva y directa                                      |
| **Propósito Principal** | Cálculos teóricos, modelos estadísticos y demostraciones         | Reportes descriptivos, gráficos y comprensión del mundo real |
| **Sensibilidad**        | Muy sensible a valores atípicos (por el cuadrado)                | Sensible, pero en escala lineal comparada con la media       |

---

### Un apunte práctico para el ordenador

Aunque dominar la teoría es vital para los ejercicios en papel, cuando resuelvas problemas programando en Python con la biblioteca **Pandas**, todo esto está automatizado.

- Puedes calcular la media aritmética invocando directamente la función `.mean()` sobre tus datos.
- Si aplicas la función `.describe()` a un _DataFrame_, Python te devolverá al instante una tabla estadística completa que incluye la media (`mean`), la desviación típica (`std`), y los valores mínimos y máximos de todas tus columnas de datos.

</div>

### 1. Coeficiente de Determinación ($R^2$)

Esta métrica evalúa la calidad del ajuste de un modelo de regresión comparando el error que comete tu modelo con la varianza natural que ya tienen los datos reales.

- **Fórmula general:**
  $$R^2 = 1 - \frac{MSE}{Var(D)}$$
- **Fórmula extendida:** Sabiendo que el MSE es el Error Cuadrático Medio y $Var(D)$ es la varianza, si desarrollamos ambos cálculos obtenemos la ecuación completa:
  $$R^2 = 1 - \frac{\sum (y - \hat{y})^2}{\sum (y - \overline{y})^2}$$
  _(Nota matemática: La constante $\frac{1}{|D|}$ que va delante de las sumatorias del MSE y la varianza se cancela al dividir, por lo que la fórmula se simplifica a la suma de errores al cuadrado entre la suma de varianzas)_.
- **Significado de las variables:** $y$ es el valor real esperado, $\hat{y}$ es el valor que ha predicho tu modelo y $\overline{y}$ es la media aritmética de todos los valores reales.

### 2. Desviación Típica o Estándar ($\sigma$)

Como te adelantaba en el mensaje anterior, la desviación típica se define matemáticamente como la raíz cuadrada positiva de la varianza.

- **Fórmula general:**
  $$\sigma = \sqrt{Var(D)}$$
- **Fórmula extendida:**
  $$\sigma = \sqrt{\frac{1}{|D|} \sum (y - \overline{y})^2}$$
- **Significado de las variables:** $|D|$ es la cantidad total de ejemplos (o datos), $y$ es cada valor numérico individual y $\overline{y}$ es la media aritmética de esos datos.

A nivel práctico para resolver problemas a mano, mi consejo es que calcules primero la varianza sumando todas las diferencias al cuadrado y dividiendo entre el total de datos y, una vez tengas ese número único, le apliques la raíz cuadrada en tu calculadora para obtener $\sigma$.

</div>

## Aprendizaje automático: Naives Bayes

<div class="highlight-theory">

El modelo Naive Bayes se fundamenta en la **regla de decisión de máximo a posteriori (MAP)**, realizando la asunción matemática de que los atributos son independientes entre sí dentro de cada clase.

Aquí tienes todas las fórmulas clave que necesitas para entrenar y aplicar este modelo:

### 1. La Fórmula Maestra de Predicción (Regla MAP)

Para predecir a qué clase $\hat{c}$ pertenece un nuevo ejemplo compuesto por varios atributos ($x_1, x_2, ..., x_n$), se utiliza la siguiente ecuación:
$$\hat{c} = \arg \max_{c\in C} \mathbb{P}(c) \prod_{i=1}^{n}\mathbb{P}(X_{i}=x_{i}|c)$$

**¿Qué significa de forma intuitiva?**
Calculas la puntuación para cada clase posible multiplicando su probabilidad de partida $\mathbb{P}(c)$ por la probabilidad condicional de cada uno de los atributos del ejemplo nuevo $\mathbb{P}(X_{i}=x_{i}|c)$. Finalmente, te quedas con la clase que obtenga el valor numérico más alto (eso es lo que hace la orden $\arg \max$).

### 2. Fórmulas de Entrenamiento (Estimación de Parámetros)

Para poder usar la fórmula anterior, el modelo debe aprender primero las probabilidades desde tu conjunto de datos de entrenamiento.

- **Probabilidad a priori de la clase:**
  $$\mathbb{P}(c) = \frac{N_c}{N}$$
  _(Se calcula dividiendo el número de ejemplos de esa clase, $N_c$, entre el total de ejemplos del conjunto, $N$)_.

- **Probabilidad condicional estándar (sin suavizado):**
  $$\mathbb{P}(X=x|c) = \frac{N_{X=x,c}}{N_c}$$
  _(Se calcula dividiendo cuántas veces aparece el valor $x$ dentro de la clase $c$, entre el número total de ejemplos de esa clase)_.

### 3. Fórmula del Suavizado de Laplace (Imprescindible)

Si un atributo tiene un valor que nunca apareció en el entrenamiento para una clase concreta, la fórmula estándar daría una probabilidad de 0, lo que anularía por completo toda la multiplicación en la regla MAP. Para solucionar esto, **siempre se recomienda usar el suavizado de Laplace**:
$$\mathbb{P}(X=x|c) = \frac{N_{X=x,c} + 1}{N_c + |X|}$$

- **$+1$**: Se suma un ejemplo "virtual" al numerador para evitar el cero.
- **$|X|$**: Es la cantidad total de valores distintos que puede llegar a tomar el atributo $X$, y se suma al denominador para mantener la proporción matemática correcta.
  _(Nota: Existe una versión generalizada llamada "suavizado aditivo" donde en lugar de 1, sumas una constante $k$ arriba y $k|X|$ abajo)_.

### 4. Transformación Logarítmica (Para evitar fallos del ordenador)

Cuando tienes una gran cantidad de atributos, multiplicar muchas probabilidades (que son números pequeños entre 0 y 1) genera un número tan minúsculo que el ordenador no puede procesarlo y lo redondea a cero (esto se llama _underflow numérico_).

Para evitarlo en la práctica, la regla MAP se transforma matemáticamente aplicando logaritmos, lo que **convierte las multiplicaciones en sumas** sin alterar cuál será la clase ganadora:
$$\hat{c} = \arg \max \left( \log \mathbb{P}(c) + \sum_{i=1}^{n}\log \mathbb{P}(X_{i}=x_{i}|c) \right)$$

### 5. Adaptación para Procesamiento de Lenguaje Natural (Textos)

Si estás usando Naive Bayes para clasificar textos (como correos spam o análisis de sentimientos), la fórmula del suavizado de Laplace se adapta ligeramente al modelo de "Bolsa de palabras". En lugar de contar ejemplos enteros, cuentas repeticiones de palabras:
$$\mathbb{P}(t|c) = \frac{\text{Ocurrencias de la palabra } t \text{ en la clase } c + 1}{\text{Total de palabras en la clase } c + |V|}$$
_(Donde $|V|$ es el tamaño del vocabulario, es decir, el número de palabras únicas en todos los textos)_. Y en la regla MAP, elevarás esta probabilidad al número de veces que dicha palabra aparezca repetida en el documento nuevo que quieres clasificar.

</div>

## kNN k-Nearest Neighbors

<div class="highlight-theory">

El algoritmo de los $k$ vecinos más cercanos (kNN) es mucho más geométrico e intuitivo que Naive Bayes. Puesto que es un modelo no paramétrico que simplemente memoriza los datos de entrenamiento para compararlos, sus fórmulas no buscan probabilidades, sino que se centran puramente en **calcular distancias** y en **normalizar escalas**.

Aquí tienes las fórmulas matemáticas que rigen el algoritmo:

### 1. Fórmulas de Similitud (Métricas de Distancia)

Para decidir qué ejemplos son los "más cercanos", kNN necesita medir el espacio entre el ejemplo nuevo ($x$) y un ejemplo de entrenamiento ($x'$). Dependiendo del tipo de datos, se usa una de estas tres fórmulas:

- **Distancia Euclídea (para atributos numéricos):** Calcula la distancia geométrica clásica en "línea recta".
  $$d(x, x') = \sqrt{\sum_{i=1}^{n} (x_i - x_i')^2}$$
- **Distancia Manhattan (para atributos numéricos):** Calcula la distancia sumando las diferencias absolutas a lo largo de cada eje (como si te movieras por las manzanas de una ciudad).
  $$d(x, x') = \sum_{i=1}^{n} |x_i - x_i'|$$
- **Distancia de Hamming (para atributos discretos):** Se usa cuando los atributos no son números (por ejemplo: colores, tamaños o categorías). Simplemente cuenta en cuántos atributos difieren ambos ejemplos.
  $$d(x, x') = \sum_{i=1}^{n} \mathbb{I}(x_i \neq x_i')$$
  _(La función $\mathbb{I}$ vale 1 si los atributos son distintos, y 0 si son exactamente iguales)._

### 2. Fórmulas de Normalización (Imprescindibles)

Como ya vimos cuando resolvimos juntos el Ejercicio 16, si no aplicas una normalización previa, un atributo numérico con un rango muy grande (como el peso de un coche o el precio de un viaje) dominará por completo el cálculo de la distancia sobre los atributos más pequeños. Las dos fórmulas típicas para solucionar esto son:

- **Tipificación:** (Esta es la que usamos en tu Ejercicio 16). Convierte los datos para que tengan media 0 y desviación típica 1.
  $$x_{norm} = \frac{x - \mu}{\sigma}$$
- **Normalización Mín-Máx:** Comprime todos los valores estrictamente dentro del intervalo entre 0 y 1.
  $$x_{norm} = \frac{x - m}{M - m}$$
  _(Donde $m$ es el valor mínimo del atributo y $M$ es el máximo)._

### 3. Fórmulas de Predicción (La regla de decisión final)

Una vez que el algoritmo ha calculado las distancias y ha aislado a los $k$ ejemplos de entrenamiento más cercanos (por ejemplo, los 3 o 5 más próximos), toma la decisión final dependiendo del tipo de problema:

- **Para problemas de Clasificación:** El modelo asigna la **clase mayoritaria** (la moda). Simplemente se hace una votación entre los $k$ vecinos y gana la clase que más se repita. _(Nota teórica: Por eso siempre se aconseja que el parámetro $k$ sea un número impar en clasificación binaria, ¡para evitar empates en la votación!)._
- **Para problemas de Regresión:** Si intentas predecir un valor continuo, el modelo calcula la **media aritmética** de los valores asociados a los $k$ vecinos cercanos.
  $$\hat{y} = \frac{1}{k} \sum_{j=1}^{k} y_j$$

</div>

## Árboles de Decisión (CART)

<div class="highlight-theory">

El algoritmo CART (Árboles de Clasificación y Regresión) basa todo su aprendizaje en buscar matemáticamente el "corte" perfecto para ir dividiendo el conjunto de entrenamiento. Para lograrlo, utiliza funciones que miden la **impureza** de los datos.

Aquí tienes las fórmulas fundamentales que rigen el algoritmo:

### 1. La Fórmula Maestra de Partición (Impureza Promedio)

Cuando el árbol está en un nodo e intenta averiguar por dónde cortar un atributo usando un valor umbral ($u$), divide temporalmente sus datos en dos ramas (izquierda y derecha). El objetivo del algoritmo es encontrar el corte que minimice la siguiente fórmula de impureza ponderada:
$$\text{Impureza} = \frac{|\mathcal{D}^{Izq}|}{|\mathcal{D}|} I(\mathcal{D}^{Izq}) + \frac{|\mathcal{D}^{Der}|}{|\mathcal{D}|} I(\mathcal{D}^{Der})$$
_(Donde $|\mathcal{D}|$ es la cantidad total de ejemplos en el nodo que vas a dividir, $|\mathcal{D}^{Izq}|$ y $|\mathcal{D}^{Der}|$ son cuántos ejemplos caen a cada lado del corte, e $I$ es la función de impureza que aplique según el tipo de problema)_.

### 2. Fórmulas para tareas de Clasificación

Si tu objetivo es predecir una categoría (ejemplo: "spam" o "no spam"), la función de impureza $I$ que utiliza CART por defecto es el **Índice de Gini**.

- **Fórmula del Índice de Gini:**
  $$G(D) = 1 - \sum_{c \in C} \hat{\Pi}_c^2$$
  _(Donde $\hat{\Pi}_c$ es la proporción de ejemplos que pertenecen a la clase $c$ dentro de ese nodo)_. Si todos los datos de una partición son de la misma clase, el índice de Gini dará exactamente $0$, lo que indica pureza total.
- **Predicción final (Hojas):** Cuando el árbol no se puede dividir más, la etiqueta final del nodo hoja se decide calculando la **clase mayoritaria** de los ejemplos que han caído en él.

### 3. Fórmulas para tareas de Regresión

Si tu objetivo es predecir un número continuo (ejemplo: el precio de una casa o los mililitros de helado vendidos), la función de impureza $I$ que asume el algoritmo es la **Varianza**.

- **Fórmula de Impureza (Varianza):**
  $$Var(\mathcal{D}) = \frac{1}{|\mathcal{D}|} \sum_{(x,y) \in \mathcal{D}} (y - \overline{y})^2$$
  _(El algoritmo buscará particiones que hagan que esta varianza sea lo más cercana a 0 posible, es decir, agrupando ejemplos con valores numéricos muy similares)_.
- **Predicción final (Hojas):** La predicción que devolverá la hoja del árbol para cualquier dato nuevo será matemáticamente la **media aritmética** de los valores objetivos de los ejemplos de entrenamiento asociados a esa hoja:
  $$\text{ETIQUETA}(\mathcal{D}) = \frac{1}{|\mathcal{D}|} \sum_{(x,y) \in \mathcal{D}} y = \overline{y}$$

<div class="clarification">

## Varianza de un nodo como función de impureza en CART (Problemas de Regresión)

En el algoritmo **CART** para tareas de **regresión**, la función de impureza que se utiliza para evaluar y dividir un nodo es la **varianza** del subconjunto de ejemplos $\mathcal{D}$ asociados a dicho nodo.

La fórmula matemática para calcular la varianza de un nodo es:
$$\mathbf{Var(\mathcal{D}) = \frac{1}{|\mathcal{D}|} \sum_{(x,y) \in \mathcal{D}} (y - \bar{y})^2}$$

Donde los componentes de la ecuación se definen como:

- **$|\mathcal{D}|$**: La **cantidad total de ejemplos** que pertenecen al nodo actual.
- **$y$**: El **valor real del atributo objetivo** de cada ejemplo individual $(x,y)$ contenido en el nodo.
- **$\bar{y}$**: La **media de los valores del atributo objetivo** de todos los ejemplos del nodo, la cual se calcula con la fórmula:
  $$\mathbf{\bar{y} = \frac{1}{|\mathcal{D}|} \sum_{(x,y) \in \mathcal{D}} y}$$

---

### Conceptos clave de la varianza para el examen:

- **Rango y pureza:** La varianza de un nodo siempre toma un valor **mayor o igual que 0**. Toma el valor **exactamente cero ($0$)** únicamente cuando el nodo es **totalmente puro**, lo que significa que todos los ejemplos asociados a él tienen exactamente el mismo valor en el atributo objetivo.
- **Criterio de parada (No Divisible):** En el flujo recursivo del árbol, un nodo con varianza cero no se puede dividir más (es _nodivisible_) y se convierte automáticamente en una hoja.
- **Etiquetado del nodo hoja:** Cuando un nodo se detiene y se convierte en hoja, la etiqueta predictiva final que el árbol le asigna es **la media $\bar{y}$** de los valores del atributo objetivo de los ejemplos que quedaron asociados a esa hoja.

</div>

</div>

<div class="highlight-theory">

## Matriz de Confusión - métricas de evaluación

|                | Predicho: Positivo | Predicho: Negativo |
| -------------- | ------------------ | ------------------ |
| Real: Positivo | TP                 | FN                 |
| Real: Negativo | FP                 | TN                 |

- **Exactitud (Accuracy)**: La proporción de predicciones correctas sobre el total de predicciones.

$$\text{Exactitud} = \frac{TP + TN}{TP + TN + FP + FN}$$

- **Precisión (Precision)**: La proporción de verdaderos positivos sobre el total de predicciones positivas.

  $$\text{Precisión} = \frac{TP}{TP + FP}$$

- **Sensibilidad (Recall o Tasa de verdaderos positivos)**: La proporción de verdaderos positivos sobre el total de casos reales positivos.
  $$
  \text{Sensibilidad} = \frac{TP}{TP + FN}
  $$
- **Especificidad (Specificity o Tasa de verdaderos negativos)**: La proporción de verdaderos negativos sobre el total de casos reales negativos.
  $$
  \text{Especificidad} = \frac{TN}{TN + FP}
  $$
- **Valor predictivo negativo (NPV)**: La proporción de verdaderos negativos sobre el total de predicciones negativas.
  $$
  \text{NPV} = \frac{TN}{TN + FN}
  $$
- **Tasa de falsos positivos (FPR)**: La proporción de falsos positivos sobre el total de casos reales negativos.
  $$
  \text{FPR} = \frac{FP}{FP + TN}
  $$
- **Tasa de falsos negativos (FNR)**: La proporción de falsos negativos sobre el total de casos reales positivos.
  $$
  \text{FNR} = \frac{FN}{FN + TP}
  $$
- **F1 Score**: La media armónica de la precisión y la sensibilidad.
  $$
  F1 = 2 \cdot \frac{\text{Precisión} \cdot \text{Sensibilidad}}{\text{Precisión} + \text{Sensibilidad}}
  $$

</div>

## Redes Neuronales

<div class="summary">

### Funciones de activación

Las principales funciones de activación diferenciables utilizadas en neuronas artificiales (descartando las funciones umbral y signo propias del perceptrón clásico) son las siguientes:
| Función de Activación | Expresión Matemática | Derivada matemática |
| :--------------------------------- | :---------------------------------- | :-------------------------------------------------------- |
| **Sigmoide ($\sigma$)** | $$\Large \frac{1}{1 + e^{-z}}$$ | $$\Large \sigma(z)(1 - \sigma(z))$$ |
| **Tangente Hiperbólica ($\tanh$)** | $$\Large \frac{e^z - e^{-z}}{e^z + e^{-z}}$$ | $$\Large 1 - \tanh^2(z)$$ |
| **Rectificador (ReLU)** | $$\Large \max(0, z)$$ | $$\Large 0 \text{ si } z \le 0, 1 \text{ si } z > 0$$ |
| **Softmax** | $$\Large \frac{e^{z_k}}{\sum e^{z_i}}$$ | Matriz Jacobiana compleja (depende de todas las salidas). |

Para que una red neuronal pueda entrenarse utilizando el método del descenso por el gradiente y el algoritmo de retropropagación, es un **requisito indispensable que la función de activación elegida sea diferenciable**. El uso de estas funciones permite que pequeños ajustes en los pesos de las neuronas produzcan cambios suaves en la salida, superando así la gran limitación expresiva del perceptrón.

</div>

<div class="highlight-theory">

### Derivada de la función tangente hiperbólica

Partiendo de

$$
\tanh(z)=\frac{e^z-e^{-z}}{e^z+e^{-z}},
$$

vamos a derivarla usando la regla del cociente:

$$
\left(\frac{u}{v}\right)'=\frac{u'v-uv'}{v^2}.
$$

Definimos:

$$
u=e^z-e^{-z},
\qquad
v=e^z+e^{-z}.
$$

Sus derivadas son:

$$
u'=e^z+e^{-z},
\qquad
v'=e^z-e^{-z}.
$$

Sustituyendo:

$$
\tanh'(z)
=
\frac{(e^z+e^{-z})(e^z+e^{-z})-(e^z-e^{-z})(e^z-e^{-z})}
     {(e^z+e^{-z})^2}.
$$

Desarrollamos los cuadrados del numerador:

$$
(e^z+e^{-z})^2
=
e^{2z}+2+e^{-2z},
$$

$$
(e^z-e^{-z})^2
=
e^{2z}-2+e^{-2z}.
$$

Restando:

$$
e^{2z}+2+e^{-2z}
-
\left(e^{2z}-2+e^{-2z}\right)
=
4.
$$

Por tanto,

$$
\tanh'(z)
=
\frac{4}{(e^z+e^{-z})^2}.
$$

Y como

$$
\tanh^2(z)
=
\left(\frac{e^z-e^{-z}}{e^z+e^{-z}}\right)^2,
$$

tenemos

$$
1-\tanh^2(z)
=
1-
\left(\frac{e^z-e^{-z}}{e^z+e^{-z}}\right)^2.
$$

Llevando a común denominador:

$$
=
\frac{(e^z+e^{-z})^2-(e^z-e^{-z})^2}
     {(e^z+e^{-z})^2}.
$$

Usando la identidad

$$
(a+b)^2-(a-b)^2=4ab,
$$

con $$a=e^z$$ y $$b=e^{-z}$$,

$$
=
\frac{4e^ze^{-z}}
     {(e^z+e^{-z})^2}
=
\frac{4}
     {(e^z+e^{-z})^2}.
$$

Así obtenemos:

$$
\boxed{
\frac{d}{dz}\tanh(z)
=
\frac{4}{(e^z+e^{-z})^2}
=
1-\tanh^2(z)
}
$$

que demuestra la equivalencia de ambas expresiones.

</div>

<div class="highlight-theory">

### Derivada de la función softmax

La derivada de la función **softmax** es un cálculo fundamental en el entrenamiento de redes neuronales multiclase. A diferencia de otras funciones de activación como la sigmoide (donde la salida de una neurona solo depende de su propia entrada), **cada salida de la función softmax depende de las entradas de todas las neuronas de esa capa**.

Por este motivo, para calcular su derivada debemos evaluar el impacto de cualquier entrada $z_j$ sobre cualquier salida $a_i$.

Dada la función softmax para un vector de entradas $z = (z_1, \dots, z_n)^T$:

$$a_i = \text{softmax}(z)_i = \frac{e^{z_i}}{\sum_{k=1}^{n} e^{z_k}} = \frac{e^{z_i}}{S}$$

Donde definimos la suma del denominador como $S = \sum_{k=1}^{n} e^{z_k}$.

Para calcular la derivada parcial $\frac{\partial a_i}{\partial z_j}$ aplicamos la regla del cociente, considerando que la derivada del denominador respecto a $z_j$ es $\frac{\partial S}{\partial z_j} = e^{z_j}$. Esto nos obliga a distinguir **dos casos matemáticos**:

---

### Caso 1: Cuando $i = j$ (Derivada respecto a su propia entrada)

Evaluamos cómo cambia la salida $a_i$ cuando varía su propia entrada neta $z_i$:

$$\frac{\partial a_i}{\partial z_i} = \frac{\partial}{\partial z_i} \left(\frac{e^{z_i}}{S}\right) = \frac{\left(\frac{\partial e^{z_i}}{\partial z_i}\right) \cdot S - e^{z_i} \cdot \left(\frac{\partial S}{\partial z_i}\right)}{S^2}$$

Sustituyendo las derivadas elementales $\frac{\partial e^{z_i}}{\partial z_i} = e^{z_i}$ y $\frac{\partial S}{\partial z_i} = e^{z_i}$:

$$\frac{\partial a_i}{\partial z_i} = \frac{e^{z_i} \cdot S - e^{z_i} \cdot e^{z_i}}{S^2} = \frac{e^{z_i}(S - e^{z_i})}{S^2}$$

Separamos la fracción en dos partes:

$$\frac{\partial a_i}{\partial z_i} = \left(\frac{e^{z_i}}{S}\right) \cdot \left(\frac{S - e^{z_i}}{S}\right) = \left(\frac{e^{z_i}}{S}\right) \cdot \left(1 - \frac{e^{z_i}}{S}\right)$$

Sustituyendo de nuevo por la definición de $a_i$:

$$\mathbf{\frac{\partial a_i}{\partial z_i} = a_i (1 - a_i)}$$

---

### Caso 2: Cuando $i \neq j$ (Derivada respecto a la entrada de otra neurona)

Evaluamos cómo cambia la salida $a_i$ cuando varía la entrada $z_j$ de una neurona vecina. En este caso, el numerador $e^{z_i}$ actúa como una constante respecto a $z_j$ (su derivada es $0$):

$$\frac{\partial a_i}{\partial z_j} = \frac{\partial}{\partial z_j} \left(\frac{e^{z_i}}{S}\right) = \frac{0 \cdot S - e^{z_i} \cdot \left(\frac{\partial S}{\partial z_j}\right)}{S^2}$$

Sustituyendo la derivada del denominador $\frac{\partial S}{\partial z_j} = e^{z_j}$:

$$\frac{\partial a_i}{\partial z_j} = \frac{- e^{z_i} \cdot e^{z_j}}{S^2} = - \left(\frac{e^{z_i}}{S}\right) \cdot \left(\frac{e^{z_j}}{S}\right)$$

Sustituyendo por las activaciones correspondientes $a_i$ y $a_j$:

$$\mathbf{\frac{\partial a_i}{\partial z_j} = - a_i a_j}$$

---

### Expresión Unificada (Delta de Kronecker)

Para escribir la derivada de la función softmax en una única línea de forma elegante y compacta en tu examen, se utiliza la **Delta de Kronecker ($\delta_{ij}$)**, la cual toma el valor $1$ si $i = j$ y $0$ si $i \neq j$:

$$\mathbf{\frac{\partial a_i}{\partial z_j} = a_i (\delta_{ij} - a_j)}$$

---

### 💡 Atajo de Examen: Combinación de Softmax con Entropía Cruzada Categorica

En las preguntas de desarrollo de retropropagación del examen, la función de salida **softmax** siempre se empareja con la función de coste de **entropía cruzada categórica**:

$$C = -\sum_{k=1}^{n} y_k \log_e(a_k)$$

Si te piden calcular el error en la capa de salida ($\Delta^L = \frac{\partial C}{\partial z^L}$), debes aplicar la regla de la cadena multivariable debido a la interdependencia de softmax:

$$\Delta_j^L = \frac{\partial C}{\partial z_j^L} = \sum_{i=1}^{n} \frac{\partial C}{\partial a_i^L} \frac{\partial a_i^L}{\partial z_j^L}$$

Sustituyendo la derivada de la entropía cruzada ($\frac{\partial C}{\partial a_i^L} = -\frac{y_i}{a_i^L}$) y nuestra derivada de softmax:

$$\Delta_j^L = \sum_{i=1}^{n} \left( -\frac{y_i}{a_i^L} \right) \cdot a_i^L (\delta_{ij} - a_j^L) = \sum_{i=1}^{n} -y_i (\delta_{ij} - a_j^L)$$

$$\Delta_j^L = -\sum_{i=1}^{n} y_i \delta_{ij} + a_j^L \sum_{i=1}^{n} y_i$$

Sabiendo que $\delta_{ij}$ anula todos los sumandos excepto cuando $i=j$, y que la suma de las etiquetas reales de probabilidad de un vector _one-hot_ es exactamente $\sum y_i = 1$:

$$\mathbf{\Delta_j^L = a_j^L - y_j} \quad \Longleftrightarrow \quad \mathbf{\Delta^L = a^L - y}$$

¡Este resultado es sumamente limpio y te ahorrará valiosos minutos de desarrollo algebraico en el examen!

</div>

<div class="summary">

### Funciones de coste

| **Función de Coste**             | **Expresión Matemática**                              | **Derivada (respecto a la salida $a$)** |
| :------------------------------- | :---------------------------------------------------- | :-------------------------------------- |
| **Error Cuadrático Medio (MSE)** | $$\Large \frac{1}{n}\sum_{k=1}^{n}(y_{k}-a_{k})^{2}$$ | $$\Large \frac{2}{n}(a - y)$$           |
| **Entropía Cruzada Binaria**     | $$\Large -y \log_e(a) - (1-y)\log_e(1-a)$$            | $$\Large \frac{a - y}{a(1-a)}$$         |
| **Entropía Cruzada Categórica**  | $$\Large -\sum_{k=1}^{n}y_{k}\log_e(a_{k})$$          | $$\Large -\frac{y}{a}$$                 |

</div>

<div class="summary">

### Métricas de error

El **coeficiente de determinación** (universalmente conocido en estadística y Machine Learning como **$R^2$**) es una métrica para evaluar cómo de bueno es un modelo de regresión.

Mientras que el Error Cuadrático Medio te da un valor absoluto (que a veces es difícil de interpretar por sí solo), el $R^2$ te da una "nota" proporcional:

- Un $R^2 = 1.0$ significa que la red neuronal hace predicciones perfectas sin margen de error.
- Un $R^2 = 0.0$ significa que la red neuronal es tan mala que obtendrías los mismos resultados si ignorases la red y siempre predijeras la media aritmética de los datos.
- Incluso puede ser negativo si el modelo es peor que predecir simplemente la media.

_(Nota importante: Debo aclararte que la definición y la fórmula matemática exacta de este coeficiente no vienen incluidas en los apuntes teóricos de Redes Neuronales que tengo en mis fuentes, por lo que te estoy dando esta información basándome en conocimiento matemático externo general. Te aconsejo verificar si tu profesor utiliza alguna variante específica de la fórmula en sus transparencias, aunque el estándar es universal)._

La fórmula matemática clásica es:
$$R^2 = 1 - \frac{\text{Suma de los errores al cuadrado}}{\text{Suma total de las varianzas}}$$
$$R^2 = 1 - \frac{\sum (y_i - a_i)^2}{\sum (y_i - \bar{y})^2}$$

El coeficiente de determinación es una métrica **global** que solo se puede sacar cuando hayas terminado de pasar por la red los **5 ejemplos** de la tabla del Ejercicio 11.

</div>

<div class="summary">

### Ciclo completo de fórmulas para Redes Neuronales para resolver ejercicios de retropropagación

Para resolver un ejercicio completo en tu examen, el gran secreto que debes tener en cuenta es que **gran parte del algoritmo es universal**. Las fórmulas matemáticas para propagar la información por las capas ocultas y para actualizar los pesos son exactamente las mismas en las tres configuraciones; lo único que cambia es cómo actúa y cómo se equivoca la capa de salida.

A continuación tienes el ciclo completo de fórmulas matriciales paso a paso, integrando tus tres configuraciones:

### FASE 1: Propagación hacia adelante (Forward)

Para calcular cómo transita la información desde la primera capa oculta hasta la salida, se aplica la misma operación en cada capa $l$:

1.  **Entrada neta:** $z^l = W^l a^{l-1} + W_0^l$
2.  **Activación:** $a^l = g^l(z^l)$

_Lo que cambia:_ En las capas ocultas, $g^l$ suele ser la función Rectificador (ReLU) o Sigmoide. Sin embargo, en la capa de salida ($L$), $g^L$ dependerá de tu configuración:

- **Regresión:** $a^L = z^L$ _(Función Identidad)_.
- **Clasificación Binaria:** $a^L = \Large \frac{1}{1+e^{-z^L}}$ _(Función Sigmoide)_.
- **Clasificación Multiclase:** $a^L = \Large \frac{e^{z_i^L}}{\sum e^{z_j^L}}$ _(Función Softmax)_

### FASE 2: Cálculo del Coste y del Error Inicial ($\Delta^L$)

Aquí es donde aplicamos las tres reglas de oro que mencionaste. Comparamos tu predicción ($a^L$) con el objetivo real ($y$):

- **1. Regresión**
  - Cálculo del coste: $MSE = \frac{1}{n} \sum_{k=1}^n (y_k - a_k^L)^2$
  - Error a propagar: $\Delta^L = \frac{2}{n}(a^L - y)$
- **2. Clasificación Binaria**
  - Cálculo del coste: $C = -y \log_e(a^L) - (1-y) \log_e(1-a^L)$
  - Error a propagar: $\Delta^L = a^L - y$
- **3. Clasificación Multiclase**
  - Cálculo del coste: $C = -\sum_{k=1}^n y_k \log_e(a_k^L)$
  - Error a propagar: $\Delta^L = a^L - y$

### FASE 3: Propagación hacia atrás del error (Backpropagation)

Una vez que tienes el vector $\Delta^L$ calculado en el paso anterior, esta fórmula matricial vuelve a ser **completamente universal** para cualquiera de los tres problemas.
Para trasladar el error a las capas interiores ($l = L-1, \dots, 2$), aplicas:
$$\Delta^l = ((W^{l+1})^T \Delta^{l+1}) \odot (g^l)^{\prime}(z^l)$$
_(Recuerda: multiplicas el error de la capa superior por los pesos transpuestos, y luego aplicas el producto de Hadamard $\odot$ multiplicando posición a posición por la derivada de la activación de esa capa oculta)_.

### FASE 4: Recálculo de Pesos (Gradientes y Descenso Estocástico)

Teniendo las activaciones de la Fase 1 y los errores de la Fase 3, se calculan los gradientes locales que dictan cuánto debe cambiar la red para este ejemplo concreto. Las fórmulas **universales** son:

- **Gradiente de los pesos:** $\Large \frac{\partial C}{\partial W^l} = \Delta^l (a^{l-1})^T$
- **Gradiente de los sesgos:** $\Large \frac{\partial C}{\partial W_0^l} = \Delta^l$

Finalmente, como los ejercicios suelen pedir ajustar los parámetros por "minilotes" (un bloque de $m$ ejemplos juntos), sumas los gradientes de todos los ejemplos del bloque y aplicas la regla de actualización multiplicada por la tasa de aprendizaje $\eta$:

- **Nuevos Pesos:** $\Large W^l \leftarrow W^l - \frac{\eta}{m} \sum \Delta^l (a^{l-1})^T$
- **Nuevos Sesgos:** $\Large W_0^l \leftarrow W_0^l - \frac{\eta}{m} \sum \Delta^l$

</div>

## PNL - Procesamiento de Lenguaje Natural

<div class="highlight-exercise">

### CONFIGURACIÓN 1: Clasificación de Documentos (Bolsa de Palabras + Naive Bayes)

Se usa cuando nos importa la frecuencia entera de repetición de cada palabra sin discriminar su rareza general.

**1. Entrenamiento del Modelo (Cálculo de parámetros):**

- **Probabilidad a priori de la clase:** $\mathbb{P}(c) = \frac{N_c}{N}$ _(Documentos de la clase $c$ entre el total de documentos)_.
- **Probabilidad condicional (con Suavizado Laplace):**
  $$\mathbb{P}(t|c) = \frac{N_{c,t} + 1}{\sum_{s \in V} N_{c,s} + |V|}$$
  _(Ocurrencias de la palabra $t$ en la clase $c$ $+ 1$, dividido entre el total de palabras en la clase $c$ $+$ el tamaño del vocabulario $|V|$)_.

**2. Predicción de un nuevo documento:**
Para clasificar un texto nuevo, usas la versión con logaritmos para evitar desbordamientos, multiplicando por el número de veces ($n_{D,t}$) que aparece la palabra en el texto de prueba:

$$\hat{c} = \arg \max_{c \in C} \left( \log \mathbb{P}(c) + \sum_{t \in V} n_{D,t} \log \mathbb{P}(t|c) \right)$$

versión equivalente sin logaritmos:

$$\hat{c} = \arg \max_{c \in C} \left( \mathbb{P}(c) \prod_{t \in V} \mathbb{P}(t|c)^{n_{D,t}} \right)$$

---

### CONFIGURACIÓN 2: Clasificación de Documentos (TF-IDF + kNN)

Se usa cuando queremos darle más importancia a las palabras "clave" o raras del texto y penalizar las demasiado comunes (como preposiciones o artículos).

**1. Representación del Documento (Pesos TF-IDF):**
Para cada palabra $t$ en el documento $D$:
$$tf\text{-}idf_{t,D} = tf_{t,D} \times \log_2 \left( \frac{N}{df_t} \right)$$
_(Donde $tf$ es las veces que aparece $t$ en el documento, $N$ es el total de documentos de entrenamiento, y $df$ es en cuántos documentos distintos aparece la palabra $t$)_.

**2. Predicción de un nuevo documento:**

- **Métrica (Similitud del Coseno):** Se calcula el coseno entre el vector del documento nuevo y cada ejemplo de entrenamiento:

  $$sim(D_1, D_2) = \frac{D_1 \cdot D_2}{||D_1|| \times ||D_2||}$$

$$\mathbf{sim(D_1, D_2) = \frac{D_1 \cdot D_2}{\|D_1\| \|D_2\|} = \frac{\sum_{i=1}^{n} tf\text{-}idf_{t_i, D_1} \cdot tf\text{-}idf_{t_i, D_2}}{\sqrt{\sum_{i=1}^{n} (tf\text{-}idf_{t_i, D_1})^2} \cdot \sqrt{\sum_{i=1}^{n} (tf\text{-}idf_{t_i, D_2})^2}}}$$

### Términos de la fórmula:

- **$\mathbf{sim(D_1, D_2)}$**: Representa la **métrica de similitud del coseno** entre el documento $D_1$ y el documento $D_2$, calculada como el coseno del ángulo que forman sus representaciones vectoriales.
- **$\mathbf{D_1 \cdot D_2}$**: Es el **producto escalar** (o producto interno) entre los vectores de pesos de ambos documentos.
- **$\mathbf{\|D_1\|}$ y $\mathbf{\|D_2\|}$**: Corresponden a la **norma euclídea** (o longitud del vector de norma $L_2$) de los documentos $D_1$ y $D_2$ respectivamente. Sirve para normalizar la longitud de los textos de forma que los documentos más largos no dominen la puntuación por el simple hecho de contener más palabras.
- **$\mathbf{n}$**: Es la **cardinalidad del vocabulario** de términos prefijado, $V = \{t_1, \dots, t_n\}$.
- **$\mathbf{tf\text{-}idf_{t_i, D}}$**: Es el **peso del término** $t_i$ en el documento $D$, obtenido al multiplicar su frecuencia local ($tf$) por la frecuencia documental inversa ($idf$) del término en el corpus.

* **Regla de Decisión:** Te quedas con los $k$ documentos que saquen el valor de similitud más alto y asignas la clase mayoritaria entre ellos.

---

### CONFIGURACIÓN 3: Modelos de n-gramas (Predicción de secuencias)

Aquí el objetivo es predecir secuencias asumiendo que cada palabra depende solo de las $n-1$ palabras anteriores (propiedad de Markov).

**1. Fórmulas de Entrenamiento (Cómo abordar los ceros):**
Para calcular la probabilidad de una palabra dado un contexto, usas una de estas tres vías dependiendo de lo que exija el problema:

- **A. Suavizado de Laplace ($k=1$):**
  $$\mathbb{P}(w_m|\text{contexto}) = \frac{C(\text{contexto } w_m) + 1}{C(\text{contexto}) + (|V| + 1)}$$
  _(Suma 1 a la ocurrencia del bloque completo, y divide por el conteo del contexto puro más las continuaciones posibles)_.
- **B. Retroceso (Backoff):** Si la frecuencia del n-grama es 0, en lugar de dar probabilidad nula, el modelo asume por defecto la probabilidad del modelo inferior (ej. si falla el trigrama, usa el bigrama).
- **C. Interpolación:** Mezcla varios modelos asignando pesos $\lambda$ que deben sumar 1:
  $$\mathbb{P}(w_m|w_{m-1}) = \lambda_1 \mathbb{P}_{\text{unigrama}}(w_m) + \lambda_2 \mathbb{P}_{\text{bigrama}}(w_m|w_{m-1})$$

<div class="clarification">

## n-gramas de orden superior igual a cero en interpolación lineal

En la interpolación lineal, salvamos la situación de que la probabilidad de un n-grama de orden superior sea cero ($\mathbb{P}_4(d|abc) = 0$) calculando la probabilidad final como una suma ponderada de n-gramas de múltiples órdenes (desde el unigrama hasta el 4-grama) de forma simultánea.

La fórmula matemática para estimar la probabilidad condicional de la palabra $d$ dado su contexto anterior $abc$ mediante interpolación se define de la siguiente manera:

$$\mathbf{\mathbb{P}(d|abc) = \lambda_4 \mathbb{P}_4(d|abc) + \lambda_3 \mathbb{P}_3(d|bc) + \lambda_2 \mathbb{P}_2(d|c) + \lambda_1 \mathbb{P}_1(d)}$$

Donde cada uno de los términos que componen la ecuación se desglosan de esta forma:

- **$\mathbf{\mathbb{P}_4(d|abc)}$**: Probabilidad por máxima verosimilitud del 4-grama. En este escenario vale **$0$** porque la secuencia exacta de cuatro términos `abcd` no aparece en el corpus de entrenamiento [34: 401, 406].
- **$\mathbf{\mathbb{P}_3(d|bc)}$**: Probabilidad del trigrama, que evalúa el término de destino basándose únicamente en un contexto reducido de dos palabras (`bc`) [34: 401, 404].
- **$\mathbf{\mathbb{P}_2(d|c)}$**: Probabilidad del bigrama, evaluando la palabra de destino basándose solo en la palabra inmediatamente anterior (`c`) [34: 401, 403].
- **$\mathbf{\mathbb{P}_1(d)}$**: Probabilidad del unigrama, que es la frecuencia relativa global del término $d$ de manera independiente en todo el corpus [34: 401, 403].
- **$\mathbf{\lambda_4, \lambda_3, \lambda_2, \lambda_1}$**: Coeficientes de peso o de ponderación asignados a cada nivel. Deben cumplir de manera obligatoria las restricciones de ser **estrictamente mayores que cero** ($\lambda_i > 0$) y **sumar exactamente uno** ($\lambda_4 + \lambda_3 + \lambda_2 + \lambda_1 = 1$).

### ¿Por qué este mecanismo de mezcla resuelve la probabilidad nula?

Aunque la secuencia completa de cuatro palabras `abcd` nunca se haya visto durante el entrenamiento y su parámetro de orden superior sea nulo ($\mathbb{P}_4(d|abc) = 0$), el valor final de la probabilidad condicional calculada **no se anula**:

1.  La ecuación sigue sumando y acumulando de manera ponderada los aportes de las probabilidades de los n-gramas de niveles inferiores ($\lambda_3 \mathbb{P}_3 + \lambda_2 \mathbb{P}_2 + \lambda_1 \mathbb{P}_1$) [34: 423].
2.  Mientras el término de destino $d$ haya aparecido al menos una vez en todo el texto de entrenamiento, la probabilidad de su unigrama será positiva ($\mathbb{P}_1(d) > 0$), lo que garantiza que **la probabilidad interpolada final sea estrictamente mayor que cero ($\mathbb{P}(d|abc) > 0$)**.
3.  Esto previene el colapso del modelo de lenguaje, evitando que la probabilidad global de una frase completa de examen se reduzca a cero simplemente porque contenía una combinación de palabras muy específica que no estaba registrada en el corpus.

</div>

**2. Predicción final de una frase completa:**
Para evaluar la probabilidad de que exista toda la frase generada, multiplicas las probabilidades condicionales acotadas o sumas sus logaritmos:

$$\mathbb{P}(w) \cong \prod_{m=1}^{M}\mathbb{P}(w_m|w_{m-(n-1)}\cdot\cdot\cdot w_{m-1})$$

O esta versión equivalente usando logaritmos para evitar underflow numérico:

$$\log \mathbb{P}(w) \cong \sum_{m=1}^M \log \mathbb{P}(w_m|w_{m-(n-1)} \dots w_{m-1})$$

---

### CONFIGURACIÓN 4: Evaluación (Perplejidad)

Teniendo tu modelo de n-gramas anterior entrenado y un documento nuevo de prueba con $N$ términos totales (incluyendo símbolos $\langle/s\rangle$), mides el desempeño del modelo usando base logarítmica:
$$\Large Perplejidad(w) = 2^{-\frac{1}{N} \sum_{i=1}^M \log_2 \mathbb{P}(w_i)}$$
_(Básicamente, tomas todas las probabilidades individuales que tu modelo calculó para la secuencia de prueba, les aplicas logaritmo en base 2, las sumas, divides por el número total de términos y elevas 2 a la menos todo eso)_.

<div class="clarification">

## Cómo se calcula la perplejidad de un modelo de lenguaje

La perplejidad es una métrica de evaluación intrínseca para modelos de lenguaje que se calcula sobre un corpus de prueba compuesto por una o varias secuencias de términos. La perplejidad de un conjunto de secuencias $W_1, \dots, W_M$ se define matemáticamente mediante dos expresiones equivalentes: la forma multiplicativa (con raíz geométrica) y la forma logarítmica (utilizada en la práctica para evitar desbordamientos numéricos por abajo):

### 1. Fórmulas de la Perplejidad

- **Forma multiplicativa original:**
  $$\text{Perplejidad}(W_1 \dots W_M) = \sqrt[N]{\frac{1}{\prod_{i=1}^{M} P(W_i)}}$$

- **Forma logarítmica práctica:**
  $$\text{Perplejidad}(W_1 \dots W_M) = 2^{-\frac{1}{N} \sum_{i=1}^{M} \log_2 P(W_i)}$$

---

### 2. Explicación de cada término

- **$\text{Perplejidad}(W_1 \dots W_M)$**: Representa el valor final de la métrica sobre el corpus de prueba. Mide de manera intrínseca la "duda" o sorpresa del modelo ante los textos reales de prueba. Un modelo de lenguaje es considerado mejor cuanto menor sea su nivel de perplejidad sobre dicho corpus.
- **$W_1, \dots, W_M$** (escrito a veces en minúsculas $w_1 \dots w_M$): Son las **$M$ secuencias o frases de prueba** individuales que integran el corpus de evaluación.
- **$M$**: Es la **cantidad total de secuencias** evaluadas en el corpus de prueba.
- **$P(W_i)$**: Es la **probabilidad condicional conjunta** que el modelo de n-gramas asigna a la secuencia de prueba $W_i$. Se calcula descomponiendo la frase como el producto de las probabilidades de cada término dado su contexto previo limitado de $n-1$ palabras.
- **$\prod_{i=1}^{M} P(W_i)$**: Representa el **producto de las probabilidades** individuales de cada una de las secuencias. Equivale matemáticamente a la probabilidad conjunta que asigna el modelo a la totalidad del corpus de prueba.
- **$N$**: Es la **cantidad total de términos** (tokens) sumando todas las secuencias del corpus de prueba. Se contabilizan únicamente las palabras del vocabulario $V$ y los símbolos especiales de fin de secuencia `</s>`, omitiendo los símbolos de inicio `<s>` ya que estos nunca se predicen. Este valor sirve como factor de normalización para que la perplejidad no dependa del tamaño del texto evaluado.
- **$\sqrt[N]{\dots}$**: Representa la **raíz de orden $N$** (media geométrica inversa). Normaliza la probabilidad inversa del corpus por la longitud total $N$ para garantizar que modelos evaluados con textos de distintas longitudes puedan compararse de forma justa.
- **$\log_2$**: Es el **logaritmo en base 2**. Al aplicarlo a las probabilidades condicionales en la versión práctica, se previene que el producto de probabilidades muy pequeñas colapse en un desbordamiento numérico por abajo (_underflow_) en el computador.
- **$2^{\dots}$**: Es la base de la potencia (exponenciación en base 2). Deshace el efecto del logaritmo anterior para devolver la perplejidad a su escala original.

</div>

</div>

<div class="summary">

## Planificación bajo incertidumbre

Para resolver con éxito los ejercicios prácticos de esta sección, las fórmulas fundamentales se dividen en dos bloques principales: **Planificación bajo Incertidumbre** (donde el agente conoce la dinámica del entorno: las probabilidades de transición $P$ y las recompensas $R$) y **Aprendizaje por Refuerzo** (donde el entorno es desconocido y el agente aprende interactuando con él por ensayo y error).

Aquí tienes el formulario maestro estructurado con las ecuaciones exactas y el significado de cada variable para aplicar en tu examen:

---

### Bloque 1: Planificación bajo Incertidumbre (Procesos de Decisión de Markov)

Este bloque se resuelve aplicando métodos de programación dinámica cuando disponemos de un modelo completo del sistema.

#### 1. Probabilidad de una historia (o trayectoria) parcial

Se utiliza para calcular la probabilidad de experimentar una secuencia específica de estados bajo una política de acciones $\pi$:
$$\mathbb{P}(h|\pi) = \prod_{i \ge 0} P_{\pi(s_i)}(s_{i+1}|s_i)$$

- **$s_i$:** Estado en el instante de tiempo $i$.
- **$\pi(s_i)$:** Acción que dicta la política aplicar en el estado $s_i$.
- **$P_a(s'|s)$:** Probabilidad de transitar al estado $s'$ al aplicar la acción $a$ en el estado $s$.

#### 2. Fórmula General Descontada (Horizonte Infinito)

Esta es la versión estándar y definitiva que se utiliza en los Procesos de Decisión de Markov para garantizar que la suma de recompensas futuras esté acotada y sea comparable:

$$\mathbf{U(h|\pi) = \sum_{i\ge0} \gamma^i R(s_i, \pi(s_i))}$$

Donde:

- **$s_i$**: Estado visitado en el instante de tiempo $i$ (siendo $s_0$ el estado inicial de la historia).
- **$\pi(s_i)$**: Acción dictada por la política $\pi$ para el estado $s_i$.
- **$R(s_i, \pi(s_i))$**: Recompensa neta del par estado-acción.
- **$\gamma$ (gamma):** Factor de descuento, con $0 < \gamma < 1$.

_(Nota teórica: Si no existiera coste por aplicar acciones, la fórmula se simplifica sustituyendo $R(s_i, \pi(s_i))$ por la recompensa directa del estado $R(s_i)$)._

---

#### 3. Desglose de la Recompensa Neta

Cuando las acciones conllevan un coste de ejecución, la recompensa neta del paso se calcula como:

$$R(s, a) = R(s) - C(s, a)$$

Donde:

- **$R(s)$:** Recompensa base por estar en el estado $s$.
- **$C(s, a)$:** Coste de aplicar la acción $a$ en el estado $s$ (el coste de la acción de esperar suele ser siempre $0$).

---

#### 4. Utilidad de una Historia Parcial (Finita)

Si en el examen te dan una secuencia finita (historia parcial) de longitud $T$ (como en el Ejercicio 1 del boletín), la utilidad acumulada con descuento se calcula deteniendo el sumatorio en el último paso observable de la secuencia:

$$\mathbf{U = \sum_{i=0}^{T} \gamma^i R_i}$$

Donde $R_i$ representa la recompensa neta obtenida en el paso $i$ de dicha historia.

#### 5. Evaluación de una política `Utilidad esperada` (Sistema de Ecuaciones Lineales de $U_\pi$)

Se aplica cuando te dan una política concreta $\pi$ y te piden calcular la utilidad esperada de cada estado ($U_\pi(s)$). Genera un sistema de ecuaciones con tantas variables como estados tenga el problema:
$$U_\pi(s) = R(s, \pi(s)) + \gamma \sum_{s' \in S} P_{\pi(s)}(s'|s) U_\pi(s')$$

- **$R(s, a)$:** Recompensa neta del par estado-acción, calculada como $R(s) - C(s, a)$ (recompensa del estado menos el coste de la acción).
- **$\gamma$:** Factor de descuento ($0 < \gamma < 1$).
- **$U_\pi(s')$:** Utilidad esperada del posible estado futuro $s'$.

#### 6. Ecuaciones de Bellman para la Utilidad Óptima ($U^*$)

Caracterizan el límite máximo teórico de utilidad que se puede conseguir en cada estado bajo la mejor política posible:
$$U^*(s) = \max_{a \in A(s)} \left[ R(s, a) + \gamma \sum_{s' \in S} P_a(s'|s) U^*(s') \right]$$

- _Nota de examen:_ Es un sistema de ecuaciones no lineales debido al operador $\max$, por lo que se resuelve usando algoritmos iterativos.

#### 7. Paso de actualización en Iteración de Valores (Value Iteration)

Fórmula recursiva para calcular la utilidad de la iteración $i+1$ a partir de la obtenida en la iteración $i$:
$$U_{i+1}(s) = \max_{a \in A(s)} \left[ R(s, a) + \gamma \sum_{s' \in S} P_a(s'|s) U_i(s') \right]$$

- **Criterio de parada:** Se detiene cuando la diferencia máxima entre dos iteraciones consecutivas es menor que un margen de error $\epsilon$:
  $$\|U_i - U_{i-1}\| = \max_{s \in S} |U_i(s) - U_{i-1}(s)| < \epsilon$$

#### 8. Cota Superior de la Utilidad ($U_{max}$)

Define el límite asintótico máximo de utilidad acumulada si el agente recibiera siempre la recompensa máxima posible ($R_{max}$) en un horizonte infinito:
$$U_{max} = \frac{R_{max}}{1 - \gamma}$$

#### 9. Extracción de la Política Óptima ($\pi^*$)

Una vez hallada la utilidad óptima (bien resolviendo Bellman o tras estabilizar la Iteración de Valores), la política óptima se extrae seleccionando la acción voraz:
$$\pi^*(s) = \arg\max_{a \in A(s)} \left[ R(s, a) + \gamma \sum_{s' \in S} P_a(s'|s) U^*(s') \right]$$

</div>

<div class="summary">

## Aprendizaje por Refuerzo

La fórmula del retorno acumulado $U_t$ desde un paso temporal $t$ es el motor de cálculo del algoritmo de Montecarlo, y junto a ella existen otras tres ecuaciones clave de Aprendizaje por Refuerzo que debes incluir en tu recopilatorio para no dejar ningún cabo suelto en el examen.

A continuación, tienes las fórmulas que faltaban explicadas al detalle, seguidas del **recopilatorio final unificado** listo para imprimir o repasar.

---

### Las fórmulas que faltaban en tu lista:

#### A. Retorno Acumulado Descontado desde el paso $t$ ($U_t$)

Es la fórmula que utilizamos para calcular la utilidad de una historia de atrás hacia adelante en los ejercicios de Montecarlo (como el Ejercicio 6).

- **Forma de Sumatorio (Secuencial):**
  $$U_t = \sum_{i=t}^{T} \gamma^{i-t} R_i$$
- **Forma Recursiva (La que de verdad se usa en el papel para ir rápido):**
  $$U_t = R_t + \gamma U_{t+1} \quad \text{con } U_{T+1} = 0 \text{ (por ser } s_{T+1} \text{ terminal)}$$

---

#### B. Diferencias Temporales para $q$ (TD(0) de Pares Estado-Acción / SARSA)

En tu recopilatorio tenías las diferencias temporales para estimar estados ($U(s_t)$) y Q-learning para el control _off-policy_. Te faltaba la **actualización de diferencias temporales estándar para pares estado-acción** (_on-policy_), donde el estado siguiente de actualización se toma evaluando la acción real $a_{t+1}$ que dicta la política, en lugar del máximo:

$$\delta_t = R_t + \gamma q(s_{t+1}, a_{t+1}) - q(s_t, a_t)$$
$$q(s_t, a_t) \leftarrow q(s_t, a_t) + \alpha \delta_t$$

---

#### C. Extracción de Utilidades de Estado $U(s)$ y Política Voraz ($\pi$) desde la tabla $q$

Al finalizar los algoritmos de control (como Q-learning o Montecarlo para $q$), necesitas saber cómo obtener la utilidad de los estados y la política óptima a partir de la matriz de valores $q$ acumulada:

- **Utilidad de un estado:** $U(s) = \max_{a \in A(s)} q(s, a)$
- **Política voraz:** $\pi(s) = \arg\max_{a \in A(s)} q(s, a)$

---

#### D. Comportamiento de la Política $\epsilon$-voraz

Para los ejercicios conceptuales, necesitas la definición formal de cómo se distribuyen las probabilidades de exploración:

$$\mathbb{P}(a) = \begin{cases} 1 - \epsilon & \text{para la acción voraz (explotación)} \\ \epsilon & \text{para una acción elegida al azar (exploración)} \end{cases}$$

---

# COMPENDIO DEFINITIVO: APRENDIZAJE POR REFUERZO (EXAMEN)

### 1. Modelado Teórico y Relaciones de Utilidad

- **Utilidad Esperada del par Estado-Acción ($q_\pi(s, a)$):**
  $$q_\pi(s, a) = R(s, a) + \gamma \sum_{s' \in S} P_a(s'|s) U_\pi(s')$$
- **Relación de Consistencia con la Utilidad de un Estado ($U(s)$):**
  $$U_\pi(s) = q_\pi(s, \pi(s))$$
- **Extracción de Utilidad Óptima y Política Óptima:**
  $$U^*(s) = \max_{a \in A(s)} q^*(s, a)$$
  $$\pi^*(s) = \arg\max_{a \in A(s)} q^*(s, a)$$

---

### 2. Algoritmos de Montecarlo (Por Episodios Completos)

- **Retorno de una secuencia desde el paso $t$ ($U_t$):**
  $$U_t = \sum_{i=t}^{T} \gamma^{i-t} R_i \quad \Longleftrightarrow \quad U_t = R_t + \gamma U_{t+1}$$
- **Montecarlo de Primera Visita (MC):**  
  Se calcula $U_t$ únicamente para el primer instante $t$ en que el par $(s, a)$ aparece en el episodio.
- **Montecarlo de Cada Visita (MC):**  
  Se calcula $U_t$ para todas las apariciones del par $(s, a)$ en la secuencia, acumulándolas en la lista de retornos.
- **Actualización de valores de utilidad:**
  $$q(s,a) = \text{Media de } Racum(s,a)$$
- **Fórmula incremental de la media (para actualización paso a paso sin guardar listas):**
  $$U^n(s) = U^{n-1}(s) + \frac{1}{n} \left( U_n - U^{n-1}(s) \right)$$

---

### 3. Métodos de Diferencias Temporales (Paso a Paso en Tiempo Real)

#### A. Predicción de Utilidad de Estados (TD(0))

- **Ecuación de actualización:**
  $$U(s_t) \leftarrow U(s_t) + \alpha \delta_t$$
- **Error de Diferencia Temporal ($\delta_t$):**
  $$\delta_t = R_t + \gamma U(s_{t+1}) - U(s_t)$$

#### B. Predicción de Utilidad de Pares Estado-Acción (SARSA / TD(0) para $q$)

- **Ecuación de actualización:**
  $$q(s_t, a_t) \leftarrow q(s_t, a_t) + \alpha \delta_t$$
- **Error de Diferencia Temporal ($\delta_t$):**
  $$\delta_t = R_t + \gamma q(s_{t+1}, a_{t+1}) - q(s_t, a_t)$$

#### C. Algoritmo de Control Q-Learning (_Off-Policy_)

- **Ecuación de actualización:**
  $$q(s_t, a_t) \leftarrow q(s_t, a_t) + \alpha \delta_t$$
- **Error de Diferencia Temporal de Q-learning ($\delta_t$):**
  $$\delta_t = R_t + \gamma \max_{a' \in A(s_{t+1})} q(s_{t+1}, a') - q(s_t, a_t)$$

---

### 4. Parámetros de Control y Exploración

- **$\gamma$ (Factor de descuento):** $0 \le \gamma < 1$. Acota los retornos en horizontes infinitos y prioriza recompensas cercanas.
- **$\alpha$ (Factor de aprendizaje):** $0 < \alpha \le 1$. Determina la importancia que se le da a la nueva experiencia frente a la utilidad ya estimada.
- **$\epsilon$ (Factor de exploración):** $0 < \epsilon < 1$. Probabilidad de tomar una decisión puramente exploratoria (aleatoria) en una política $\epsilon$-voraz.

</div>
