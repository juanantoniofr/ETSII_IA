# Aprendizaje Automático

## 1. Modelos

### 2. Naive Bayes

- Indicado para abordar problemas de clasificación con atributos discretos.
- Discretización: Transformar atributos continuos en categorías discretas.
- Asume independencia entre atributos, lo que simplifica el cálculo de probabilidades.

#### 2.1 Realización de la tarea

Dado C = {C1, C2, ..., Ck} conjunto de clases y A = {A1, A2, ..., An} conjunto de atributos, el objetivo es encontrar la clase Ci que maximice **P(Ci | A)**.

- La regla de decisión se denomina a menudo como **"regla de máxima a posteriori" (MAP)**.
  $$ P(A \mid C*i) = P(C_i) \prod*{j=1}^n P(A_j \mid C_i) $$
  siendo
  - A = {A1 = a1, A2 = a2, ..., An = an} un ejemplo del conjunto de atributos.
  - $ P(C_i) = \frac{\text{Número de ejemplos en la clase } C_i}{\text{Número total de ejemplos}} $
- Si todos las clases son igualmente probables, la regla de decisión se reduce a, que se conoce como **"regla de máxima verosimilitud" (ML)**:
  $$ P(A \mid C*i) = \prod*{j=1}^n P(A_j \mid C_i) $$

Para evitar numeric underflow, se suele trabajar con logaritmos:
s

- MAP: $$\log P(A \mid C_i) = \log P(C_i) + \sum_{j=1}^{n} \log P(A_j \mid C_i) $$
- ML: $$\log P(A \mid C_i) = \sum_{j=1}^{n} \log P(A_j \mid C_i)$$

#### 2.2 Aprendizaje del modelo

Es un modelo paramétrico y solo necesita aprender estos parámetros:

**Probabilidades a priori de cada clase: $ P(C_i) $**

La $ P(C_i) = N_i / N $ se calcula contando el número de ejemplos en cada clase y dividiéndolo por el número total de ejemplos.

**Probabilidades condicionales de cada atributo dado cada clase: $ P(A_j \mid C_i) $**

Para calcular $ P(A_j \mid C_i) $, se cuenta el número de ejemplos en la clase $ C_i $ que tienen el valor específico del atributo $ A_j $ y se divide por el número total de ejemplos en la clase $ C_i $. P(A_j \mid C_i) = N\*{ij} / N_i $.

Para estimar convenientemente las estas probabilidades es conveniente considerar **las matrices One-Hot de cada atributo**.

##### 2.2.1 Suavizado de Laplace

Para evitar problemas de probabilidad cero, se puede aplicar el suavizado de Laplace, que consiste en agregar un pequeño valor (generalmente 1) a cada conteo. Esto asegura que ninguna probabilidad sea exactamente cero, lo que podría causar problemas en la clasificación.

Entonces
$$ P(A*j \mid C_i) = \frac{N*{ij} + 1}{N_i + k} $$
donde \( k \) es el número de posibles valores del atributo \( A_j \).

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
Tenemos que aplicar la formula: P(A=ai|C_setosa) = N_x=x,c + k / N_c + k |X|

|X| = cantidad total de posibles valores del atributo, en este caso es 4 para todos al dividir en 4 intervalos (número de columnas).
N_x=x,c = dado un valor del atributo x, contamos cuantos veces aparece (igual al número de 1 de esa columna)
N_c = Número de ejemplos (número de filas)
k = 1 => suavizado de Laplace, 1 en este caso.

Longitud Sépalo

| :--     | ($-\infty$, 5.6] | (5.6,6.2] | (6.2, 6.8] | (6.8, +$\infty$) |
| :------ | :--------------- | :-------- | :--------- | :--------------- |
| E1      | 1                | 0         | 0          | 0                |
| E2      | 1                | 0         | 0          | 0                |
| E3      | 1                | 0         | 0          | 0                |
| E4      | 1                | 0         | 0          | 0                |
| E5      | 1                | 0         | 0          | 0                |
| N_x=x,c | 5                | 0         | 0          | 0                |
| N_c     | 5                | 5         | 5          | 5                |
| P       | 5 + 1 /(5+4)     | 1/(5+4)   | 1/(5+4)    | 1/(5+4)          |

Anchura sépalo

| :--     | ($-\infty$, 2.85] | (2.85, 3.2] | (3.2, 3.55] | (3.55, $+\infty$) |
| :------ | :---------------- | :---------- | :---------- | :---------------- |
| E1      | 0                 | 0           | 1           | 0                 |
| E2      | 0                 | 0           | 1           | 0                 |
| E3      | 0                 | 0           | 1           | 0                 |
| E4      | 0                 | 0           | 0           | 1                 |
| E5      | 0                 | 0           | 0           | 1                 |
| N_x=x,c | 0                 | 0           | 3           | 2                 |
| N_c     | 5                 | 5           | 5           | 5                 |
| P       | (0+1)/(5+4)       | (0+1)/(5+4) | (3+1)/(5+4) | (2+1)/(5+4)       |

Longitud del pétalo

| :--     | ($-\infty$, 2.575] | (2.575, 3.75] | (3.75, 4.925] | (4.925, $+\infty$) |
| :------ | :----------------- | :------------ | :------------ | :----------------- |
| E1      | 1                  | 0             | 0             | 0                  |
| E2      | 1                  | 0             | 0             | 0                  |
| E3      | 1                  | 0             | 0             | 0                  |
| E4      | 1                  | 0             | 0             | 0                  |
| E5      | 1                  | 0             | 0             | 0                  |
| N_x=x,c | 0                  | 0             | 0             | 0                  |
| N_c     | 5                  | 5             | 5             | 5                  |
| P       | (5+1)/(5+4)        | (0+1)/(5+4)   | (0+1)/(5+4)   | (0+1)/(5+4)        |

Anchura del pétalo

| :--     | ($-\infty$, 0.775] | (0.775, 1.35] | (1.35, 1.95] | (1.95, $+\infty$) |
| :------ | :----------------- | :------------ | :----------- | :---------------- |
| E1      | 1                  | 0             | 0            | 0                 |
| E2      | 1                  | 0             | 0            | 0                 |
| E3      | 1                  | 0             | 0            | 0                 |
| E4      | 1                  | 0             | 0            | 0                 |
| E5      | 1                  | 0             | 0            | 0                 |
| N_x=x,c | 5                  | 0             | 0            | 0                 |
| N_c     | 5                  | 5             | 5            | 5                 |
| P       | (5+1)/(5+4)        | (0+1)/(5+4)   | (0+1)/(5+4)  | (0+1)/(5+4)       |

**Clase Versicolor**
Tenemos que aplicar la formula: P(A=ai|C_setosa) = N_x=x,c + k / N_c + k |X|

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

| :--     | ($-\infty$, 0.775] | (0.775, 1.35] | (1.35, 1.95] | (1.95, $+\infty$) |
| :------ | :----------------- | :------------ | :----------- | :---------------- |
| E1      | 0                  | 0             | 1            | 0                 |
| E2      | 0                  | 0             | 1            | 0                 |
| E3      | 0                  | 1             | 0            | 0                 |
| E4      | 0                  | 0             | 1            | 0                 |
| E5      | 0                  | 0             | 1            | 0                 |
| N_x=x,c | 0                  | 1             | 4            | 0                 |
| N_c     | 5                  | 5             | 5            | 5                 |
| P       | (0+1)/(5+4)        | (1+1)/(5+4)   | (4+1)/(5+4)  | (0+1)/(5+4)       |

**Clase Virginica**
Tenemos que aplicar la formula: P(A=ai|C_setosa) = N_x=x,c + k / N_c + k |X|

|X| = cantidad total de posibles valores del atributo, en este caso es 4 para todos al dividir en 4 intervalos (número de columnas).
N_x=x,c = dado un valor del atributo x, contamos cuantos veces aparece (igual al número de 1 de esa columna)
N_c = Número de ejemplos (número de filas)
k = 1 => suavizado de Laplace, 1 en este caso.

Longitud Sépalo

| :--     | ($-\infty$, 5.6] | (5.6,6.2]   | (6.2, 6.8]  | (6.8, +$\infty$) |
| :------ | :--------------- | :---------- | :---------- | :--------------- |
| E1      | 0                | 0           | 1           | 0                |
| E2      | 0                | 0           | 0           | 1                |
| E3      | 0                | 0           | 1           | 0                |
| E4      | 0                | 0           | 1           | 0                |
| E5      | 0                | 0           | 0           | 1                |
| N_x=x,c | 0                | 0           | 3           | 2                |
| N_c     | 5                | 5           | 5           | 5                |
| P       | (0+1)/(5+4)      | (0+1)/(5+4) | (3+1)/(5+4) | (2+1)/(5+4)      |

Anchura sépalo

| :--     | ($-\infty$, 2.85] | (2.85, 3.2] | (3.2, 3.55] | (3.55, $+\infty$) |
| :------ | :---------------- | :---------- | :---------- | :---------------- |
| E1      | 0                 | 0           | 1           | 0                 |
| E2      | 0                 | 1           | 0           | 0                 |
| E3      | 0                 | 1           | 0           | 0                 |
| E4      | 1                 | 0           | 0           | 0                 |
| E5      | 1                 | 0           | 0           | 0                 |
| N_x=x,c | 2                 | 2           | 1           | 0                 |
| N_c     | 5                 | 5           | 5           | 5                 |
| P       | (2+1)/(5+4)       | (2+1)/(5+4) | (1+1)/(5+4) | (0+1)/(5+4)       |

Longitud del pétalo

| :--     | ($-\infty$, 2.575] | (2.575, 3.75] | (3.75, 4.925] | (4.925, $+\infty$) |
| :------ | :----------------- | :------------ | :------------ | :----------------- |
| E1      | 0                  | 0             | 0             | 1                  |
| E2      | 0                  | 0             | 0             | 1                  |
| E3      | 0                  | 0             | 0             | 1                  |
| E4      | 0                  | 0             | 0             | 1                  |
| E5      | 0                  | 0             | 0             | 1                  |
| N_x=x,c | 0                  | 0             | 0             | 5                  |
| N_c     | 5                  | 5             | 5             | 5                  |
| P       | (0+1)/(5+4)        | (0+1)/(5+4)   | (0+1)/(5+4)   | (5+1)/(5+4)        |

Anchura del pétalo

| :--     | ($-\infty$, 0.775] | (0.775, 1.35] | (1.35, 1.95] | (1.95, $+\infty$) |
| :------ | :----------------- | :------------ | :----------- | :---------------- |
| E1      | 0                  | 0             | 0            | 1                 |
| E2      | 0                  | 0             | 1            | 0                 |
| E3      | 0                  | 0             | 0            | 1                 |
| E4      | 0                  | 0             | 1            | 0                 |
| E5      | 0                  | 0             | 1            | 0                 |
| N_x=x,c | 0                  | 0             | 3            | 2                 |
| N_c     | 5                  | 5             | 5            | 5                 |
| P       | (0+1)/(5+4)        | (0+1)/(5+4)   | (3+1)/(5+4)  | (2+1)/(5+4)       |

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

### 3. Árboles de Classificación y Regresión (CART)

- Los valores de los atributos pueden ser discretos o continuos, eso da igual, pero obligatoriamente **deben ser números**
- Puede abordar problemas de clasificación y regresión.

#### 3.1 Realización de la tarea

- Los CART son árboles binarios donde cada nodo interno está etiquetado con un atributo y un valor umbral, y cada nodo hoja con una clase (clasificación) o un valor numérico (regresión)
- Dado un ejemplo, el CART lo "clasifica" asignándole como salida el valor de un nodo hoja, resultado de recorrer el árbol de la raíz a las hojas.
- En cada nodo interno (con atributo X y umbral u) se toma la rama de la izquierda si el valor de X del ejemplo en menor o igual (<=) al valor umbral, se toma la rama derecha en caso contrario.
- Un CART puede entenderse como una colección de reglas de tipo condicional (si X <= u_x && Y > u_y && Z <= u_z entonces Clase = A)

#### 3.2 Aprendizaje del modelo

##### ¿Cómo construimos el árbol?

Supongamos que estamos en un nodo intermedio, entonces tengo que **buscar la condición que proporcione la mejor partición**, asociarla a ese nodo, y bifurcar el subconjunto de entrenamiento en dos ramas. Continuando el proceso hasta que el conjunto resultante sea indivisible.

Se dice que se va particionando el conjunto de entrenamiento D de tal manera que se obtengan conjuntos **cada vez más puros**.

Necesitamos una medida la de impureza.

###### Tareas de clasificación

- **En tareas de clasificación** se usa el **índice de Gini**. Siempre toma valores entre 0 y 1, y **toma el valor 0 solamente para los conjuntos puros**.

La fórmula matemática para calcular el **índice de Gini** de un conjunto de ejemplos $D$ es la siguiente:

**$G(D) = 1 - \sum_{c \in C} \hat{\Pi}_{c}^{2}$**

Donde los componentes de la expresión significan lo siguiente:

- **$C$**: es el **conjunto de clases posibles** en tu problema.
- **$\hat{\Pi}_{c}$**: es la **proporción de ejemplos del conjunto $D$ que están etiquetados con la clase $c$**, lo cual sirve para estimar la probabilidad de que un ejemplo pertenezca a esa clase en particular.

La formula para calcular el **índice de Gini ponderado** de una partición de un conjunto de entrenamiento $D$ en dos ramas (izquierda y derecha) es la siguiente:
**$G_{partición} = \frac{|D_{izquierda}|}{|D|} G(D_{izquierda}) + \frac{|D_{derecha}|}{|D|} G(D_{derecha})$**
Donde los componentes de la expresión significan lo siguiente:

- **$D_{izquierda}$**: es el subconjunto de ejemplos que cumplen la condición de la rama izquierda.
- **$D_{derecha}$**: es el subconjunto de ejemplos que cumplen la condición de la rama derecha.
- **$|D_{izquierda}|$** y **$|D_{derecha}|$**: son el número de ejemplos en cada una de las ramas, respectivamente.
- **$|D|$**: es el número total de ejemplos en el conjunto original $D$.

**Proceso paso a paso**

- 1. Para cada atributo, ordenamos los valores numéricos distintos que aparecen en el conjunto de entrenamiento.
- 2. Para cada atributo, calculamos los posibles puntos de corte (umbrales) como el punto medio entre cada par de valores consecutivos de la secuencia ordenada.
- 3. Para cada umbral candidato, dividimos el conjunto de entrenamiento en dos ramas (izquierda y derecha) y calculamos el índice de Gini para cada rama.
- 4. Calculamos el índice de Gini ponderado para la partición resultante.
- 5. Seleccionamos la partición que minimice el índice de Gini ponderado, y esa será la condición que se asignará al nodo interno del árbol.

###### Tareas de regresión

**¿qué pasa si la tarea es de regresión?**

Cuando el atributo que queremos predecir no es una clase discreta, sino un valor numérico continuo (por ejemplo, el volumen de un cerezo o el consumo de combustible de un coche), nos encontramos ante una tarea de regresión.

El algoritmo CART sigue exactamente la misma mecánica de ordenar valores, buscar umbrales en los puntos medios y dividir los datos en rama izquierda y derecha, pero **modifica tres elementos matemáticos clave** para adaptarse a los números continuos:

**1. La función de impureza (Se sustituye Gini por la Varianza)**
En tareas de regresión, el algoritmo CART utiliza la **varianza** para medir la impureza de un conjunto de datos. La fórmula utilizada calcula la dispersión de los valores del atributo objetivo respecto a su media: $Var(\mathcal{D}) = \frac{1}{|\mathcal{D}|}\sum(y-\overline{y})^{2}$.

- La varianza toma un valor de **0 (pureza total)** únicamente cuando todos los ejemplos de ese nodo tienen asociado exactamente el mismo valor.
- Al construir el árbol, en lugar de minimizar el índice de Gini promedio, el algoritmo buscará el umbral que proporcione la **varianza promedio más baja** para particionar los datos.

**2. La etiqueta de las hojas (Predicción final)**
En clasificación, cuando un nodo se convertía en una hoja (nodo final), se le asignaba la "clase mayoritaria". En regresión, cada hoja del árbol se etiqueta con la **media aritmética** de los valores del atributo objetivo de los ejemplos que han caído en ese nodo. Cuando llegue un ejemplo nuevo y alcance esa hoja, esa media será la predicción numérica que devuelva el modelo.

###### Poda a priori del árbol

**¿por qué es necesario la poda a priori del árbol?**

La **poda a priori** de un árbol de decisión es necesaria fundamentalmente para evitar que el modelo sufra de **sobreajuste (_overfitting_)** frente a los datos de entrenamiento.

Si el proceso de particionado del algoritmo (como CART) no se detiene de forma anticipada, seguirá dividiendo las ramas hasta que todos los nodos finales sean **totalmente puros**, lo que significa alcanzar un índice de Gini de 0 en tareas de clasificación o una varianza de 0 en tareas de regresión.

El gran problema de alcanzar esta pureza total es que el árbol termina **«memorizando» el conjunto de entrenamiento exacto**. Por ejemplo, al exigir una varianza de cero en una regresión, los nodos finales del árbol acabarían conteniendo, por lo general, un único ejemplo.

Al volverse el modelo demasiado complejo, ocurre lo siguiente:

- Empieza a detectar patrones donde no los hay, aprendiendo el "ruido" (fluctuaciones aleatorias o errores específicos) como si fueran reglas absolutas.
- El modelo pierde su capacidad de **generalización**. Aunque acertará a la perfección los datos de entrenamiento que ya conoce, fallará estrepitosamente al intentar predecir ejemplos nuevos y desconocidos en el mundo real.

Para prevenir esta "memorización" de los datos, la poda a priori introduce **condiciones de parada adicionales** (al margen de la pureza) para declarar un nodo como indivisible. Las estrategias más habituales para frenar el crecimiento del árbol son:

1.  Fijar una **profundidad máxima** que el árbol no puede superar.
2.  Exigir que un nodo contenga una **cantidad mínima de ejemplos** para permitir que se siga dividiendo.

#### 3.3 Ejercicio 11

Se ha realizado un análisis químico de diferentes tipos de aceite de oliva producidos entres regiones de Italia, obteniéndose para cada uno de ellos las siguientes medidas de ácidos palmítico y oléico:

|     | Ácido palmítico | Ácido oleico | Región       |
| --- | --------------- | ------------ | ------------ |
| E1  | 875             | 8018         | Sur          |
| E2  | 1361            | 6888         | Sur          |
| E3  | 1454            | 7057         | Sur          |
| E4  | 1088            | 7709         | Sur          |
| E5  | 1306            | 7082         | Sur          |
| E6  | 1030            | 7403         | Cerdeña      |
| E7  | 1075            | 7413         | Cerdeña      |
| E8  | 1092            | 7427         | Cerdeña      |
| E9  | 1106            | 7381         | Cerdeña      |
| E10 | 1096            | 7162         | Cerdeña      |
| E11 | 1110            | 7910         | Centro norte |
| E12 | 1220            | 7890         | Centro norte |
| E13 | 1350            | 7520         | Centro norte |
| E14 | 1098            | 7945         | Centro norte |
| E15 | 1075            | 7960         | Centro norte |

Se pide seleccionar, de entre los valores 2, 3 y 4, el mejor valor para el hiperparámetro de profundidad de un árbol dedecisión CART entrenado apartir de eso sejemplos, en función de la tasa de acierto del modelo sobre el siguiente conjunto de prueba:

|     | Ácido palmítico | Ácido oleico | Región       |
| --- | --------------- | ------------ | ------------ |
| P1  | 1206            | 7193         | Sur          |
| P2  | 1732            | 6437         | Sur          |
| P3  | 1260            | 7354         | Sur          |
| P4  | 993             | 7743         | Sur          |
| P5  | 1159            | 7320         | Cerdeña      |
| P6  | 1103            | 7365         | Cerdeña      |
| P7  | 1091            | 7377         | Cerdeña      |
| P8  | 1176            | 7396         | Cerdeña      |
| P9  | 1085            | 7955         | Centro norte |
| P10 | 1075            | 7960         | Centro norte |
| P11 | 1100            | 7910         | Centro norte |
| P12 | 1030            | 7760         | Centro norte |

**Construcción del árbol**

- tenemos que trabajar con números, así que asignamos => Sur = 0, Cerdeña = 1, Centro norte = 3
- Calculo del indice de Gini para encontrar la mejor partición
  G(D) = 1 - ( $(\frac{1}{3})^2$ + $(\frac{1}{3})^2$ + $(\frac{1}{3})^2$) = $\frac{2}{3}$

Para elegir cuál es la **mejor partición** para empezar el árbol, debes realizar sistemáticamente los siguientes pasos evaluando todos los atributos disponibles (en el Ejercicio 11 serían el "Ácido palmítico" y el "Ácido oléico"):

1. **Ordenar los valores:** Para un atributo concreto, tomas todos los valores numéricos distintos que aparecen en tu conjunto de datos y los ordenas de menor a mayor.

_Ácido palmítico_
Valores ordenados: 875, 1030, 1075, 1088, 1092, 1096, 1098, 1106, 1110, 1220, 1306, 1350, 1361, 1454.

_Ácido oleico_
6437 - 7193 - 7320 - 7354 - 7365 - 7377 - 7396 - 7743 - 7760 - 7910 - 7955 - 7960

2. **Calcular los umbrales candidatos:** Determinas los posibles puntos de corte (umbrales, $u$). Estos se calculan como el punto medio entre cada par de valores consecutivos de la secuencia ordenada ($u_i = \frac{x_i + x_{i+1}}{2}$).

_Ácido palmítico_

3. **Evaluar cada partición:** Para cada umbral candidato, divides tu conjunto de 15 ejemplos en dos ramas:
   - **Rama Izquierda:** Los ejemplos cuyo valor en ese atributo es menor o igual al umbral ($\le u$).
   - **Rama Derecha:** Los ejemplos cuyo valor es mayor al umbral ($> u$).
     A continuación, calculas el índice de Gini para el subconjunto izquierdo y el índice de Gini para el subconjunto derecho.

_Ácido palmítico_

- Primer umbral (u_1): La media entre 875 y 1030, que es **952.5**
  Rama Izquierda = {E1}
  Rama Derecha = Caen los 14 ejemplos restantes (4 Sur, 5 Cerdeña, 5 Centro norte).
  G(R_izquierda) = 1 - $(\frac{1}{1})^2$ = **0**
  G(R_derecha) = 1 - $(\frac{4}{14})^2$ - $(\frac{5}{14})^2$ - $(\frac{5}{14})^2$ = **0.6633**
  G(Partición) = $\frac{1}{15} \cdot 0 + \frac{14}{15} \cdot 0.6633$ = **0.6194**

- Segundo umbral (u_2): la media entre 1030 y 1075, que es 1052,5
  Rama Izquierda = {E1 (Sur), E6 (Cerdeña)}
  Rama Derecha = los 13 ejemplos restantes: 4 Sur, 4 Cerdeña y 5 Centro Norte
  G(R_izquierda) = 1 - $(\frac{1}{2})^2$ - $(\frac{1}{2})^2$ = 0.5
  G(R_derecha) = 1 - $(\frac{4}{13})^2$ - $(\frac{4}{13})^2$ - $(\frac{5}{13})^2$ = 0.6627
  G(Partición) = $\frac{2}{15} \cdot 0.5 + \frac{13}{15} \cdot 0.6627$ = **0.6449**

- Tercer umbral (u_3): la media de 1075 y 1088, que es 1.081,5
  Rama Izquierda: Sur -> 1, Cerdeña -> 2, Centro Norte -> 1.
  Rama Derecha: los restantes 11 ejemplos.
  G(R_izquierda) = 1 - $(\frac{1}{4})^2$ - $(\frac{2}{4})^2$ - $(\frac{1}{4})^2$ = **0,625**
  G(R_derecha) = 1 - $(\frac{4}{11})^2$ - $(\frac{3}{11})^2$ - $(\frac{4}{11})^2$ = **0,6612**
  G(Partición) = $\frac{4}{15} \cdot 0,625 + \frac{11}{15} \cdot 0,6612$ = **0.6515**

4. **Calcular la impureza promedio:** Combinas ambos índices de Gini haciendo una media ponderada según la cantidad de ejemplos que hayan caído en cada lado. La fórmula es:
   $\text{Impureza Promedio} = \frac{\text{Nº ejemplos Izq.}}{\text{Total ejemplos}} \cdot G(\text{Izq.}) + \frac{\text{Nº ejemplos Der.}}{\text{Total ejemplos}} \cdot G(\text{Der.})$

5. **Elegir el ganador:** Repites este proceso para todos los umbrales candidatos del "Ácido palmítico" y todos los del "Ácido oléico". El par exacto de **(Atributo, Umbral)** que te dé como resultado la **impureza promedio más baja** será la condición elegida para construir tu nodo raíz y separar los datos por primera vez.

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

`_nota_`

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

- TPR -> True Positive Ratio
- TNR -> True Negative Ratio
- FPR -> False Positive Ratio
- FNR -> False Negative Ratio

### 2.3 Métricas para Modelos de Regresión

| Métrica                                    | ¿Apropiada para? | Fórmula                                                     | Explicación                                                                                                                  | Interpretación (Aspectos relevantes)                                                                                                                                                                                                                               |
| :----------------------------------------- | :--------------- | :---------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Error Absoluto Medio (MAE)**             | Regresión        | $\frac{1}{\vert\mathcal{D}\vert}\sum \vert y-\hat{y}\vert$  | Calcula el promedio del error en valor absoluto cometido entre el valor predicho y el valor real correcto para cada ejemplo. | Da una idea directa de la magnitud del error promedio sin importar si el fallo del modelo fue por exceso o por defecto.                                                                                                                                            |
| **Error Cuadrático Medio (MSE)**           | Regresión        | $\frac{1}{\vert\mathcal{D}\vert}\sum(y-\hat{y})^{2}$        | Calcula el promedio de las diferencias al cuadrado entre el valor predicho y el valor real.                                  | Al elevarse al cuadrado, **penaliza de forma mucho más severa los errores grandes** frente a los pequeños. Al ser una función diferenciable, es más fácil de optimizar matemáticamente por los algoritmos.                                                         |
| **Raíz del Error Cuadrático Medio (RMSE)** | Regresión        | $\sqrt{\frac{1}{\vert\mathcal{D}\vert}\sum(y-\hat{y})^{2}}$ | Es la raíz cuadrada del Error Cuadrático Medio (MSE) calculado en el paso anterior.                                          | Su principal ventaja frente al MSE es que **devuelve el error medido exactamente en la misma unidad original** que el atributo objetivo, lo que facilita enormemente su comprensión en el contexto del problema.                                                   |
| **Coeficiente de determinación ($R^2$)**   | Regresión        | $1-\frac{MSE}{Var(\mathcal{D})}$                            | Compara el error cuadrático medio (MSE) del modelo con la varianza de los valores reales correctos del conjunto de datos.    | Mide la **calidad del ajuste numérico**. Un valor de 1 indica un ajuste perfecto; un 0 significa que el modelo es tan inútil como predecir siempre la media; y un valor negativo indica que las predicciones son peores que simplemente predecir la media siempre. |

_(Nota: **$y$** = valor real correcto, **$\hat{y}$** = valor numérico predicho por el modelo, **$Var(\mathcal{D})$** = varianza de los valores reales correctos, y **$\vert \mathcal{D} \vert$** = Total de ejemplos en el conjunto de datos evaluado)._
