<link rel="stylesheet" href="../css/estilo.css">

# Aprendizaje Automático

## 1. Modelos

<div class="highlight-theory">

### 2. Naive Bayes

- Indicado para abordar problemas de clasificación con atributos discretos.
- Discretización: Transformar atributos continuos en categorías discretas.
- Asume independencia entre atributos, lo que simplifica el cálculo de probabilidades.

El clasificador **Naive Bayes** (Bayes ingenuo) es un modelo probabilístico enfocado en resolver tareas de clasificación basándose en los atributos de los datos. Es un modelo de tipo **paramétrico**, lo que significa que el número de parámetros que necesita aprender es fijo y no crece independientemente de si le das mil o un millón de ejemplos de entrenamiento.

### 1. ¿Cómo realiza teóricamente la tarea de clasificación?

Dado un ejemplo nuevo descrito por una serie de atributos ($X_1=x_1, \dots, X_n=x_n$), el objetivo del modelo es asignarle la clase $\hat{c}$ más probable. Para ello, utiliza la **regla de Bayes**, que relaciona la probabilidad a posteriori de una clase con su probabilidad a priori y la verosimilitud de los datos.

El modelo se llama **"ingenuo" (naive)** porque, para que los cálculos sean viables y no crezcan exponencialmente, **hace la fuerte suposición de que todos los atributos son condicionalmente independientes entre sí** dentro de cada clase. Aunque en la vida real esta suposición rara vez se cumple (por ejemplo, el peso y la potencia de un coche suelen estar relacionados), en la práctica el modelo funciona sorprendentemente bien.

Gracias a esta asunción de independencia, la probabilidad de un ejemplo se calcula simplemente multiplicando las probabilidades individuales de cada atributo. _(Nota técnica: en la práctica, para evitar que el ordenador redondee a cero al multiplicar probabilidades muy pequeñas —numeric underflow—, se aplican logaritmos y las multiplicaciones se transforman en sumas)_.

### 2. Reglas de decisión: MAP frente a ML

A la hora de elegir la clase ganadora, el modelo puede usar dos reglas matemáticas distintas dependiendo de cómo trate la probabilidad previa de las clases:

- **Regla MAP (Maximum A Posteriori):** Es la regla estándar. Clasifica el ejemplo en la clase que maximice el producto de la **verosimilitud** de los atributos por la **probabilidad a priori** de esa clase.
  Fórmula: $\hat{c} = \arg\max \mathbb{P}(c) \prod_{i=1}^{n} \mathbb{P}(X_i=x_i|c)$.
  Esta regla tiene en cuenta si una clase es de por sí mucho más común que otra en el mundo real.
- **Regla ML (Maximum Likelihood / Máxima Verosimilitud):** Es un caso especial que solo se usa **si asumimos que todas las clases son igualmente probables a priori** (por ejemplo, si hay 2 clases, asumimos un 50% para cada una). Como la probabilidad previa $\mathbb{P}(c)$ es la misma para todas, se puede ignorar en el cálculo, y el modelo solo se fija en la verosimilitud empírica de los atributos.
  Fórmula: $\hat{c} = \arg\max \prod_{i=1}^{n} \mathbb{P}(X_i=x_i|c)$.

### 3. ¿Cómo aprende el modelo?

Como Naive Bayes es paramétrico, su fase de "entrenamiento" o aprendizaje consiste puramente en **contar frecuencias** en los datos de entrenamiento para estimar dos tipos de parámetros:

1.  **$\mathbb{P}(c)$:** La probabilidad a priori de cada clase (ej. ¿cuántos coches de consumo alto hay frente al total?).
2.  **$\mathbb{P}(X=x|c)$:** La probabilidad condicional de cada valor de cada atributo dentro de una clase concreta (ej. de todos los coches de consumo alto, ¿cuántos tienen 4 cilindros?).

Para hacer estos conteos de forma extremadamente eficiente durante el examen o en el ordenador, es muy recomendable transformar los datos usando una codificación **one-hot** (crear variables binarias con 1 o 0 para cada valor posible), de modo que el aprendizaje se reduce a sumar columnas.

### 4. El Suavizado de Laplace

**El problema:** Si durante el entrenamiento el modelo nunca ha visto un caso específico (por ejemplo, un coche de "6 cilindros" que tenga consumo "Alto"), aprenderá que esa probabilidad $\mathbb{P}(\text{Cilindros}=6 | \text{Alto})$ es exactamente $0$. Al ir a clasificar un ejemplo nuevo mediante multiplicaciones, ese único $0$ anulará todo el cálculo matemático del resto de atributos, descartando automáticamente la clase completa aunque el resto de atributos encajaran perfectamente.

**La solución:** El **Suavizado de Laplace**. Consiste en trucar ligeramente las matemáticas asumiendo que **ha existido al menos un "ejemplo virtual"** de cada posible combinación.
En lugar de dividir simplemente los casos favorables entre el total de la clase, la fórmula modificada suma $1$ al numerador y suma la cantidad total de posibles valores de ese atributo ($|X|$) al denominador:

$\mathbb{P}(X=x|c) = \frac{N_{x=x, c} + 1}{N_c + |X|}$

De esta forma, ninguna probabilidad será jamás un cero absoluto, permitiendo que el modelo siga generalizando y utilizando la información del resto de los atributos.

</div>

<div class="highlight-FAQ">

- 1. ¿Puedo clasificar cualquier tipo de atributos con Naive bayes?

Sí, en la práctica puedes clasificar casi cualquier tipo de atributo, pero **teóricamente el modelo estándar de Naive Bayes exige trabajar exclusivamente con atributos discretos**. Como su aprendizaje se basa puramente en contar la frecuencia con la que aparece un valor exacto dentro de una clase, necesita que los posibles valores pertenezcan a un conjunto finito.

Sin embargo, mediante **técnicas de procesamiento previo**, puedes adaptar otro tipo de datos para que el modelo los digiera sin problema. Dependiendo de la naturaleza de los atributos, los ejercicios se dividen en tres tipologías:

**1. Atributos discretos (categóricos, booleanos u ordinales)**
El modelo los procesa de manera nativa. Simplemente calcula las probabilidades condicionales contando cuántas veces aparece cada categoría cualitativa (por ejemplo, el origen "Europa" o "Japón") dentro de una misma clase. Para agilizar estos conteos matemáticos, es altamente recomendable transformar los datos usando una codificación _one-hot_.

**2. Atributos continuos numéricos (ej. peso, aceleración, distancia)**
No puedes pasárselos directamente al algoritmo. Tienes que **discretizarlos** de forma obligatoria. Esto consiste en dividir el rango total de los valores continuos en una serie de subintervalos. Por ejemplo:

- Puedes usar la mediana para dividir los datos en dos mitades exactas.
- O puedes tomar el valor mínimo ($m$) y el máximo ($M$) del conjunto de entrenamiento y dividir matemáticamente en cuartiles o tramos iguales.
  Una vez haces esto, debes ajustar los extremos exteriores a $-\infty$ y $+\infty$ para garantizar que cualquier dato anómalo en el futuro encaje en algún hueco. A partir de este momento, sustituyes el número continuo por el "intervalo" al que pertenece, y el modelo lo trata exactamente igual que un atributo discreto del caso 1.

**3. Datos de texto libre (Procesamiento del Lenguaje Natural)**
Tampoco se pueden clasificar directamente palabras sueltas sin estructura, pero se adaptan transformando los textos mediante el modelo de **bolsa de palabras**. Se define un vocabulario finito ($V$) y las palabras se convierten en los "atributos". El modelo aprenderá calculando la probabilidad de cada palabra basándose en el número de veces que dicha palabra ocurre dentro de los textos pertenecientes a una clase. En este caso específico, no se usan matrices _one-hot_ de ceros y unos, sino que se necesitan vectores de frecuencias completas que recojan el número exacto de repeticiones de cada término.

- 2. ¿qué proceso sigo para crear la matriz one-hot y como la uso?

El proceso para crear y utilizar una matriz _one-hot_ en Naive Bayes es muy mecánico y sirve para transformar la fase de aprendizaje en una simple suma de columnas, lo que acelera enormemente los cálculos.

**Proceso de creación de la matriz _one-hot_:**

1. **Identificar los valores únicos:** Tomas un atributo discreto (por ejemplo, "Origen") y observas todos los posibles valores que puede tomar en tu conjunto de datos (ej. Europa, Japón, Norteamérica).
2. **Desdoblar en columnas binarias:** Creas una nueva columna por cada uno de esos valores posibles.
3. **Asignar 1 o 0:** Para cada ejemplo de entrenamiento, colocas un **1** en la columna que coincida con su valor original, y un **0** en el resto de las columnas de ese atributo.

**Cómo se usa para aprender:**
Una vez transformada la tabla, **agrupas las filas separándolas por clase** (ej. todos los ejemplos de la clase "Consumo Alto" por un lado y los de "Bajo" por otro). Al sumar los unos (1) de cada columna, obtienes automáticamente la frecuencia absoluta de ese rasgo. Si divides esa suma entre el total de ejemplos de esa clase, **obtienes la probabilidad condicional** que el modelo necesita $\mathbb{P}(X=x|c)$.

### Ejemplo numérico ilustrativo

Imagina que quieres predecir el tipo de consumo de un coche. Tienes 4 ejemplos de entrenamiento que sabes que pertenecen a la clase **Tipo de consumo = Alto**:

- $E_3$: Origen Europa
- $E_5$: Origen Europa
- $E_6$: Origen Japón
- $E_8$: Origen Norteamérica

**1. Creación de la matriz _one-hot_:**
Desdoblamos el atributo "Origen" en tres columnas y rellenamos con ceros y unos:

| Ejemplo          | Europa | Japón | Norteamérica |
| :--------------- | :----: | :---: | :----------: |
| $E_3$ (Europa)   | **1**  |   0   |      0       |
| $E_5$ (Europa)   | **1**  |   0   |      0       |
| $E_6$ (Japón)    |   0    | **1** |      0       |
| $E_8$ (Norteam.) |   0    |   0   |    **1**     |

**2. Uso de la matriz (Cálculo de probabilidades):**
Simplemente sumamos verticalmente los valores de cada columna para esta clase:

- **Suma Europa:** $1 + 1 + 0 + 0 = 2$
- **Suma Japón:** $0 + 0 + 1 + 0 = 1$
- **Suma Norteamérica:** $0 + 0 + 0 + 1 = 1$

Como hay 4 ejemplos en total en esta clase ($N_{Alto} = 4$), las probabilidades condicionales que el modelo aprende de forma directa dividiendo la suma entre el total son:

- $\mathbb{P}(\text{Origen}=\text{Europa}|\text{Alto}) = \mathbf{2 / 4}$
- $\mathbb{P}(\text{Origen}=\text{Japón}|\text{Alto}) = \mathbf{1 / 4}$
- $\mathbb{P}(\text{Origen}=\text{Norteamérica}|\text{Alto}) = \mathbf{1 / 4}$

Al programar o hacer el ejercicio en papel, contar columnas de unos y ceros evita que te equivoques rastreando palabras sueltas por tablas enormes.

</div>

### Ejercicios de Naive Bayes

#### Ejercicio 3

Se dispone de los siguientes datos acerca de quince flores de tres especies de lirios:

| Longitud del sépalo | Anchura del sépalo | Longitud del pétalo | Anchura del pétalo | Especie    |
| ------------------- | ------------------ | ------------------- | ------------------ | ---------- |
| 5.2                 | 3.5                | 1.5                 | 0.2                | setosa     |
| 5.1                 | 3.5                | 1.4                 | 0.3                | setosa     |
| 5.0                 | 3.3                | 1.4                 | 0.2                | setosa     |
| 5.1                 | 3.7                | 1.5                 | 0.4                | setosa     |
| 5.4                 | 3.9                | 1.7                 | 0.4                | setosa     |
| 6.0                 | 3.4                | 4.5                 | 1.6                | versicolor |
| 5.2                 | 2.7                | 3.9                 | 1.4                | versicolor |
| 5.6                 | 2.5                | 3.9                 | 1.1                | versicolor |
| 6.9                 | 3.1                | 4.9                 | 1.5                | versicolor |
| 5.9                 | 3.0                | 4.2                 | 1.5                | versicolor |
| 6.7                 | 3.3                | 5.7                 | 2.5                | virginica  |
| 7.2                 | 3.2                | 6.0                 | 1.8                | virginica  |
| 6.5                 | 3.2                | 5.1                 | 2.0                | virginica  |
| 6.3                 | 2.8                | 5.1                 | 1.5                | virginica  |
| 7.4                 | 2.8                | 6.1                 | 1.9                | virginica  |

Se pide usar un modelo naive Bayes con suavizado de Laplace para determinar la especie de lirio a la que pertenecen las flores con las siguientes medidas:

| Longitud del sépalo | Anchura del sépalo | Longitud del pétalo | Anchura del pétalo |
| ------------------- | ------------------ | ------------------- | ------------------ |
| 6.5                 | 3.0                | 5.2                 | 2.0                |
| 6.4                 | 2.9                | 4.3                 | 1.3                |
| 4.6                 | 3.6                | 1.0                 | 0.2                |

El ejercicio debe resolverse de las siguientes dos maneras:

1. Dividiendo el rango de valores de cada atributo continuo en cuatro subintervalos de la misma longitud.
2. Dividiendo el rango de valores de cada atributo continuo en cuatro subintervalos con la misma cantidad de valores.

_Nota_:supongamos que tras discretizar un atributo 𝑋 se han obtenido 𝑚, 𝑥𝟣,…, 𝑥𝘣, 𝑀 como extremos de los intervalos, donde 𝑏 ≥ 1 y 𝑚 y 𝑀 son los valores mínimo y máximo, respectivamente, que 𝑋 toma en el conjunto de entrenamiento. Entonces, al considerar un ejemplo nuevo hay que usar −∞, 𝑥𝟣,…, 𝑥𝘣,+∞ como extremos de los intervalos de discretización, ya que el valor del atributo 𝑋 para ese ejemplo nuevo puede ser menor que 𝑚 o mayor que 𝑀.

**Solución**

- Apartado 1.

- 1.1 Cálculo de intervalos

Intervalo longitud sépalo = 7.4 - 5.0 = 2.4, entonces podemos dividir en 4 intervalos de longitud 0,6: ($-\infty$, 5.6], (5.6,6.2], (6.2, 6.8], (6.8, +$\infty$)
Intervalo anchura sépalo = 3.9 - 2.5 = 1.4, entonces podemos dividir en 4 intervalos de longitud 0.35: ($-\infty$, 2.85], (2.85, 3.2], (3.2, 3.55], (3.55, $+\infty$)
Intervalo Longitud del pétalo = 6.1 - 1.4 = 4.7, entonces podemos dividir en 4 intervalos de longitud 1.175: ($-\infty$, 2.575], (2.575, 3.75], (3.75, 4.925], (4.925, $+\infty$)
Intervalo Anchura del pétalo = 2.5 - 0.2 = 2.3, entonces podemos dividir en 4 intervalos de longitud 0,575: ($-\infty$, 0.775], (0.775, 1.35], (1.35, 1.95], (1.95, $+\infty$)

- 1.2 Discretización de atributos

| Longitud del sépalo | Anchura del sépalo | Longitud del pétalo | Anchura del pétalo | Especie    |
| ------------------- | ------------------ | ------------------- | ------------------ | ---------- |
| ($-\infty$, 5.6]    | (3.2, 3.55]        | ($-\infty$, 2.575]  | ($-\infty$, 0.775] | setosa     |
| ($-\infty$, 5.6]    | (3.2, 3.55]        | ($-\infty$, 2.575]  | ($-\infty$, 0.775] | setosa     |
| ($-\infty$, 5.6]    | (3.2, 3.55]        | ($-\infty$, 2.575]  | ($-\infty$, 0.775] | setosa     |
| ($-\infty$, 5.6]    | (3.55, $+\infty$)  | ($-\infty$, 2.575]  | ($-\infty$, 0.775] | setosa     |
| ($-\infty$, 5.6]    | (3.55, $+\infty$)  | ($-\infty$, 2.575]  | ($-\infty$, 0.775] | setosa     |
| (5.6,6.2]           | (3.2, 3.55]        | (3.75, 4.925]       | (1.35, 1.95]       | versicolor |
| ($-\infty$, 5.6]    | ($-\infty$, 2.85]  | (3.75, 4.925]       | (1.35, 1.95]       | versicolor |
| ($-\infty$, 5.6]    | ($-\infty$, 2.85]  | (3.75, 4.925]       | (0.775, 1.35]      | versicolor |
| (6.8, +$\infty$)    | (2.85, 3.2]        | (3.75, 4.925]       | (1.35, 1.95]       | versicolor |
| (5.6,6.2]           | (2.85, 3.2]        | (3.75, 4.925]       | (1.35, 1.95]       | versicolor |
| (6.2, 6.8]          | (3.2, 3.55]        | (4.925, $+\infty$)  | (1.95, $+\infty$)  | virginica  |
| (6.8, +$\infty$)    | (2.85, 3.2]        | (4.925, $+\infty$)  | (1.35, 1.95]       | virginica  |
| (6.2, 6.8]          | (2.85, 3.2]        | (4.925, $+\infty$)  | (1.95, $+\infty$)  | virginica  |
| (6.2, 6.8]          | ($-\infty$, 2.85]  | (4.925, $+\infty$)  | (1.35, 1.95]       | virginica  |
| (6.8, +$\infty$)    | ($-\infty$, 2.85]  | (4.925, $+\infty$)  | (1.35, 1.95]       | virginica  |

Tenemos que aplicar la formula $$ P(A*j \mid C_i) = \frac{N*{ij} + 1}{N_i + k} $$

- 1.3 Prioridad a priori de cada clase

P(setosa) = 5/15 = 1/3
P(versicolor) = 5/15 = 1/3
P(virginica) = 5/15 = 1/3

- 1.4 On-hot de cada atributo

**Clase Setosa**
Tenemos que aplicar la formula: P(A=ai|C_setosa) = (N_x=x,c + k) / (N_c + k |X|)

|X| = cantidad total de posibles valores del atributo, en este caso es 4 para todos al dividir en 4 intervalos (número de columnas).
N_x=x,c = dado un valor del atributo x, contamos cuantos veces aparece (igual al número de 1 de esa columna)
N_c = Número de ejemplos (número de filas)
k = 1 => suavizado de Laplace, 1 en este caso.

Longitud Sépalo

| :--     | ($-\infty$, 5.6]    | (5.6,6.2]         | (6.2, 6.8]        | (6.8, +$\infty$)  |
| :------ | :------------------ | :---------------- | :---------------- | :---------------- |
| E1      | 1                   | 0                 | 0                 | 0                 |
| E2      | 1                   | 0                 | 0                 | 0                 |
| E3      | 1                   | 0                 | 0                 | 0                 |
| E4      | 1                   | 0                 | 0                 | 0                 |
| E5      | 1                   | 0                 | 0                 | 0                 |
| N_x=x,c | 5                   | 0                 | 0                 | 0                 |
| N_c     | 5                   | 5                 | 5                 | 5                 |
| P       | (5 + 1)/(5+4) = 6/9 | (0+1)/(5+4) = 1/9 | (0+1)/(5+4) = 1/9 | (0+1)/(5+4) = 1/9 |

Anchura sépalo

| :--     | ($-\infty$, 2.85] | (2.85, 3.2]       | (3.2, 3.55]       | (3.55, $+\infty$) |
| :------ | :---------------- | :---------------- | :---------------- | :---------------- |
| E1      | 0                 | 0                 | 1                 | 0                 |
| E2      | 0                 | 0                 | 1                 | 0                 |
| E3      | 0                 | 0                 | 1                 | 0                 |
| E4      | 0                 | 0                 | 0                 | 1                 |
| E5      | 0                 | 0                 | 0                 | 1                 |
| N_x=x,c | 0                 | 0                 | 3                 | 2                 |
| N_c     | 5                 | 5                 | 5                 | 5                 |
| P       | (0+1)/(5+4) = 1/9 | (0+1)/(5+4) = 1/9 | (3+1)/(5+4) = 4/9 | (2+1)/(5+4) = 3/9 |

Longitud del pétalo

| :--     | ($-\infty$, 2.575] | (2.575, 3.75]     | (3.75, 4.925]     | (4.925, $+\infty$) |
| :------ | :----------------- | :---------------- | :---------------- | :----------------- |
| E1      | 1                  | 0                 | 0                 | 0                  |
| E2      | 1                  | 0                 | 0                 | 0                  |
| E3      | 1                  | 0                 | 0                 | 0                  |
| E4      | 1                  | 0                 | 0                 | 0                  |
| E5      | 1                  | 0                 | 0                 | 0                  |
| N_x=x,c | 0                  | 0                 | 0                 | 0                  |
| N_c     | 5                  | 5                 | 5                 | 5                  |
| P       | (0+1)/(5+4) = 1/9  | (0+1)/(5+4) = 1/9 | (0+1)/(5+4) = 1/9 | (0+1)/(5+4) = 1/9  |

Anchura del pétalo

| :--     | ($-\infty$, 0.775] | (0.775, 1.35]     | (1.35, 1.95]      | (1.95, $+\infty$) |
| :------ | :----------------- | :---------------- | :---------------- | :---------------- |
| E1      | 1                  | 0                 | 0                 | 0                 |
| E2      | 1                  | 0                 | 0                 | 0                 |
| E3      | 1                  | 0                 | 0                 | 0                 |
| E4      | 1                  | 0                 | 0                 | 0                 |
| E5      | 1                  | 0                 | 0                 | 0                 |
| N_x=x,c | 5                  | 0                 | 0                 | 0                 |
| N_c     | 5                  | 5                 | 5                 | 5                 |
| P       | (5+1)/(5+4) = 6/9  | (0+1)/(5+4) = 1/9 | (0+1)/(5+4) = 1/9 | (0+1)/(5+4) = 1/9 |

**Clase Versicolor**
Tenemos que aplicar la formula: P(A=ai|C_setosa) = (N_x=x,c + k) / (N_c + k |X|)

|X| = cantidad total de posibles valores del atributo, en este caso es 4 para todos al dividir en 4 intervalos (número de columnas).
N_x=x,c = dado un valor del atributo x, contamos cuantos veces aparece (igual al número de 1 de esa columna)
N_c = Número de ejemplos (número de filas)
k = 1 => suavizado de Laplace, 1 en este caso.

Longitud Sépalo

| :--     | ($-\infty$, 5.6] | (5.6,6.2]   | (6.2, 6.8]  | (6.8, +$\infty$) |
| :------ | :--------------- | :---------- | :---------- | :--------------- |
| E1      | 0                | 1           | 0           | 0                |
| E2      | 1                | 0           | 0           | 0                |
| E3      | 1                | 0           | 0           | 0                |
| E4      | 0                | 0           | 0           | 1                |
| E5      | 0                | 1           | 0           | 0                |
| N_x=x,c | 2                | 2           | 0           | 1                |
| N_c     | 5                | 5           | 5           | 5                |
| P       | (2+1)/(5+4)      | (2+1)/(5+4) | (0+1)/(5+4) | (1+1)/(5+4)      |

Anchura sépalo

| :--     | ($-\infty$, 2.85] | (2.85, 3.2] | (3.2, 3.55] | (3.55, $+\infty$) |
| :------ | :---------------- | :---------- | :---------- | :---------------- |
| E1      | 0                 | 0           | 1           | 0                 |
| E2      | 1                 | 0           | 0           | 0                 |
| E3      | 1                 | 0           | 0           | 0                 |
| E4      | 0                 | 1           | 0           | 0                 |
| E5      | 0                 | 1           | 0           | 0                 |
| N_x=x,c | 2                 | 2           | 1           | 0                 |
| N_c     | 5                 | 5           | 5           | 5                 |
| P       | (2+1)/(5+4)       | (2+1)/(5+4) | (1+1)/(5+4) | (0+1)/(5+4)       |

Longitud del pétalo

| :--     | ($-\infty$, 2.575] | (2.575, 3.75] | (3.75, 4.925] | (4.925, $+\infty$) |
| :------ | :----------------- | :------------ | :------------ | :----------------- |
| E1      | 0                  | 0             | 1             | 0                  |
| E2      | 0                  | 0             | 1             | 0                  |
| E3      | 0                  | 0             | 1             | 0                  |
| E4      | 0                  | 0             | 1             | 0                  |
| E5      | 0                  | 0             | 1             | 0                  |
| N_x=x,c | 0                  | 0             | 5             | 0                  |
| N_c     | 5                  | 5             | 5             | 5                  |
| P       | (0+1)/(5+4)        | (0+1)/(5+4)   | (5+1)/(5+4)   | (0+1)/(5+4)        |

Anchura del pétalo

| :--     | ($-\infty$, 0.775] | (0.775, 1.35]     | (1.35, 1.95]      | (1.95, $+\infty$) |
| :------ | :----------------- | :---------------- | :---------------- | :---------------- |
| E1      | 0                  | 0                 | 1                 | 0                 |
| E2      | 0                  | 0                 | 1                 | 0                 |
| E3      | 0                  | 1                 | 0                 | 0                 |
| E4      | 0                  | 0                 | 1                 | 0                 |
| E5      | 0                  | 0                 | 1                 | 0                 |
| N_x=x,c | 0                  | 1                 | 4                 | 0                 |
| N_c     | 5                  | 5                 | 5                 | 5                 |
| P       | (0+1)/(5+4) = 1/9  | (1+1)/(5+4) = 2/9 | (4+1)/(5+4) = 5/9 | (0+1)/(5+4) = 1/9 |

**Clase Virginica**
Tenemos que aplicar la formula: P(A=ai|C_setosa) = (N_x=x,c + k) / (N_c + k |X|)

|X| = cantidad total de posibles valores del atributo, en este caso es 4 para todos al dividir en 4 intervalos (número de columnas).
N_x=x,c = dado un valor del atributo x, contamos cuantos veces aparece (igual al número de 1 de esa columna)
N_c = Número de ejemplos (número de filas)
k = 1 => suavizado de Laplace, 1 en este caso.

Longitud Sépalo

| :--     | ($-\infty$, 5.6]  | (5.6,6.2]         | (6.2, 6.8]        | (6.8, +$\infty$)  |
| :------ | :---------------- | :---------------- | :---------------- | :---------------- |
| E1      | 0                 | 0                 | 1                 | 0                 |
| E2      | 0                 | 0                 | 0                 | 1                 |
| E3      | 0                 | 0                 | 1                 | 0                 |
| E4      | 0                 | 0                 | 1                 | 0                 |
| E5      | 0                 | 0                 | 0                 | 1                 |
| N_x=x,c | 0                 | 0                 | 3                 | 2                 |
| N_c     | 5                 | 5                 | 5                 | 5                 |
| P       | (0+1)/(5+4) = 1/9 | (0+1)/(5+4) = 1/9 | (3+1)/(5+4) = 4/9 | (2+1)/(5+4) = 3/9 |

Anchura sépalo

| :--     | ($-\infty$, 2.85] | (2.85, 3.2]       | (3.2, 3.55]       | (3.55, $+\infty$) |
| :------ | :---------------- | :---------------- | :---------------- | :---------------- |
| E1      | 0                 | 0                 | 1                 | 0                 |
| E2      | 0                 | 1                 | 0                 | 0                 |
| E3      | 0                 | 1                 | 0                 | 0                 |
| E4      | 1                 | 0                 | 0                 | 0                 |
| E5      | 1                 | 0                 | 0                 | 0                 |
| N_x=x,c | 2                 | 2                 | 1                 | 0                 |
| N_c     | 5                 | 5                 | 5                 | 5                 |
| P       | (2+1)/(5+4) = 3/9 | (2+1)/(5+4) = 3/9 | (1+1)/(5+4) = 2/9 | (0+1)/(5+4) = 1/9 |

Longitud del pétalo

| :--     | ($-\infty$, 2.575] | (2.575, 3.75]     | (3.75, 4.925]     | (4.925, $+\infty$) |
| :------ | :----------------- | :---------------- | :---------------- | :----------------- |
| E1      | 0                  | 0                 | 0                 | 1                  |
| E2      | 0                  | 0                 | 0                 | 1                  |
| E3      | 0                  | 0                 | 0                 | 1                  |
| E4      | 0                  | 0                 | 0                 | 1                  |
| E5      | 0                  | 0                 | 0                 | 1                  |
| N_x=x,c | 0                  | 0                 | 0                 | 5                  |
| N_c     | 5                  | 5                 | 5                 | 5                  |
| P       | (0+1)/(5+4) = 1/9  | (0+1)/(5+4) = 1/9 | (0+1)/(5+4) = 1/9 | (5+1)/(5+4) = 6/9  |

Anchura del pétalo

| :--     | ($-\infty$, 0.775] | (0.775, 1.35]     | (1.35, 1.95]      | (1.95, $+\infty$) |
| :------ | :----------------- | :---------------- | :---------------- | :---------------- |
| E1      | 0                  | 0                 | 0                 | 1                 |
| E2      | 0                  | 0                 | 1                 | 0                 |
| E3      | 0                  | 0                 | 0                 | 1                 |
| E4      | 0                  | 0                 | 1                 | 0                 |
| E5      | 0                  | 0                 | 1                 | 0                 |
| N_x=x,c | 0                  | 0                 | 3                 | 2                 |
| N_c     | 5                  | 5                 | 5                 | 5                 |
| P       | (0+1)/(5+4) = 1/9  | (0+1)/(5+4) = 1/9 | (3+1)/(5+4) = 4/9 | (2+1)/(5+4) = 3/9 |

1.5 Listos para clasificar

| Longitud del sépalo | Anchura del sépalo | Longitud del pétalo | Anchura del pétalo |
| ------------------- | ------------------ | ------------------- | ------------------ |
| 6.5                 | 3.0                | 5.2                 | 2.0                |
| 6.4                 | 2.9                | 4.3                 | 1.3                |
| 4.6                 | 3.6                | 1.0                 | 0.2                |

Hay que seguir exactamente estos tres pasos:

1. Discretizar el nuevo ejemplo.
2. Aplicar la regla de Máximo a Posteriori (MAP). Hay que calcular la probabilidad de pertenecer a cada una de las tres clases. La fórmula matemática aplicada a tu problema es:

P(clase)×
P(Int. Long. Sepalo∣clase)×
P(Int. Anch. Sepalo∣clase)×
P(Int. Long. Petalo∣clase)×
P(Int. Anch. Petalo∣clase)

3. Elegir la clase ganadora: La flor pertenecerá a la clase que haya obtenido el valor matemático más alto (la probabilidad máxima a posteriori).

**ejemplo 1**

**Discretizamos**

Recuerda los intervalos
Intervalo longitud sépalo = 7.4 - 5.0 = 2.4, entonces podemos dividir en 4 intervalos de longitud 0,6: ($-\infty$, 5.6], (5.6,6.2], (6.2, 6.8], (6.8, +$\infty$)
Intervalo anchura sépalo = 3.9 - 2.5 = 1.4, entonces podemos dividir en 4 intervalos de longitud 0.35: ($-\infty$, 2.85], (2.85, 3.2], (3.2, 3.55], (3.55, $+\infty$)
Intervalo Longitud del pétalo = 6.1 - 1.4 = 4.7, entonces podemos dividir en 4 intervalos de longitud 1.175: ($-\infty$, 2.575], (2.575, 3.75], (3.75, 4.925], (4.925, $+\infty$)
Intervalo Anchura del pétalo = 2.5 - 0.2 = 2.3, entonces podemos dividir en 4 intervalos de longitud 0,575: ($-\infty$, 0.775], (0.775, 1.35], (1.35, 1.95], (1.95, $+\infty$)

| Longitud del sépalo | Anchura del sépalo | Longitud del pétalo | Anchura del pétalo |
| ------------------- | ------------------ | ------------------- | ------------------ |
| (6.2, 6.8]          | (2.85, 3.2]        | (4.925, $+\infty$)  | (1.95, $+\infty$)  |

**Aplicamos la regla del máximo a posteriori (MAP)**
clase = setosa
P(setosa) = 1/3
P(Int. Long. Sepalo∣setosa) = 1/9
P(Int. Anch. Sepalo∣setosa) = 1/9
P(Int. Long. Petalo∣setosae) = 1/9
P(Int. Anch. Petalo∣setosa) = 1/9

MAP(setosa) = 1/3*1/9*1/9*1/9*1/9 = 0,000050805

clase = Versicolor
P(Versicolor) = 1/3
P(Int. Long. Sepalo∣Versicolor) = 1/9
P(Int. Anch. Sepalo∣Versicolor) = 3/9
P(Int. Long. Petalo∣Versicolor) = 1/9
P(Int. Anch. Petalo∣Versicolor) = 1/9

MAP(versicolor) = 1/3*1/9*3/9*1/9*1/9 = 0,000152416

clase = Virginica
P(Virginica) = 1/3
P(Int. Long. Sepalo∣Virginica) = 4/9
P(Int. Anch. Sepalo∣Virginica) = 3/9
P(Int. Long. Petalo∣Virginica) = 6/9
P(Int. Anch. Petalo∣Virginica) = 3/9

MAP(Virginica) = 1/3*4/9*3/9*6/9*3/9 = 0,010973937

**Apartado 2. Dividiendo el rango de valores de cada atributo continuo en cuatro subintervalos con la misma cantidad de valores.**

Como tenemos 15 valores en el conjunto de flores, el cálculo (15 / 4 = 3.75) indica que debemos formar grupos desiguales, típicamente **tres intervalos con 4 valores y un intervalo con 3 valores** (ya que 4 + 4 + 4 + 3 = 15).

Para resolver este segundo apartado, hay seguir estos pasos para cada uno de los atributos:

1. **Ordenar los 15 valores numéricos** de menor a mayor.
2. **Agruparlos por cantidad:** Dividir la lista ordenada en grupos lo más cercanos a 4 elementos (por ejemplo: los primeros 4, los siguientes 4, los siguientes 4 y los últimos 3).
3. **Fijar los puntos de corte:** Calcular la media entre el último valor de un grupo y el primer valor del grupo siguiente.
4. **Hacer el ajuste al infinito:** Reemplazar el límite inferior del primer grupo por $-\infty$ y el límite superior del último por $+\infty$, tal y como exige la nota del enunciado.

### Un ejemplo práctico con el primer atributo ("Longitud del sépalo")

Los 15 valores en bruto que proporciona el ejercicio para este atributo son:
`5.2, 5.1, 5.0, 5.1, 5.4, 6.0, 5.2, 5.6, 6.9, 5.9, 6.7, 7.2, 6.5, 6.3, 7.4`

**Paso 1 y 2 (Ordenar y agrupar):**

- **Grupo 1 (4 elementos):** 5.0, 5.1, 5.1, 5.2
- **Grupo 2 (4 elementos):** 5.2, 5.4, 5.6, 5.9
- **Grupo 3 (4 elementos):** 6.0, 6.3, 6.5, 6.7
- **Grupo 4 (3 elementos):** 6.9, 7.2, 7.4

_(Nota importante: En el primer corte ves que el número 5.2 coincide en dos grupos distintos. En la práctica real esto es un problema porque el mismo valor no puede ir a dos intervalos distintos. En los exámenes suele ser válido dejar el corte en 5.2, o bien agrupar los dos 5.2 juntos y tener un intervalo de 5 elementos y el siguiente de 3)._

**Paso 3 y 4 (Calcular cortes y aplicar infinito):**

- Corte 1 (entre 5.2 y 5.2) = 5.2
- Corte 2 (entre 5.9 y 6.0) = 5.95
- Corte 3 (entre 6.7 y 6.9) = 6.8

Los intervalos finales aplicando el ajuste al infinito te quedarían así:

- **Intervalo 1:** $(-\infty, 5.2]$
- **Intervalo 2:** $(5.2, 5.95]$
- **Intervalo 3:** $(5.95, 6.8]$
- **Intervalo 4:** $(6.8, +\infty)$

Con esto habrás conseguido intervalos basados **en la densidad de elementos** (cuántos hay) en lugar de en la distancia absoluta, cumpliendo así el objetivo del segundo apartado del Ejercicio 3. Puedes aplicar exactamente esta misma lógica agrupando de 4 en 4 para la Anchura del sépalo y los datos de los pétalos.

---

<div class="highlight-exercise">

**Ejercicio 4**

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

</div>
