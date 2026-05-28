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

#### 3.1 Realización de la tarea

- Los CART son árboles binarios donde cada nodo interno está etiquetado con un atributo y un valor umbral, y cada nodo hoja con una clase (clasificación) o un valor numérico (regresión)
- Dado un ejemplo, el CART lo "clasifica" asignándole como salida el valor de un nodo hoja, resultado de recorrer el árbol de la raíz a las hojas.
- En cada nodo interno (con atributo X y umbral u) se toma la rama de la izquierda si el valor de X del ejemplo en menor o igual (<=) al valor umbral, se toma la rama derecha en caso contrario.
- Un CART puede entenderse como una colección de reglas de tipo condicional (si X <= u_x && Y > u_y && Z <= u_z entonces Clase = A)

#### 3.1 Aprendizaje del modelo

- ¿Cómo construimos el árbol?

Supongamos que estamos en un nodo intermedio, entonces tengo que **buscar la condición que proporcione la mejor partición**, asociarla a ese nodo, y bifurcar el subconjunto de entrenamiento en dos ramas. Continuando el proceso hasta que el conjunto resultante sea indivisible.

Se dice que se va particionando el conjunto de entrenamiento D de tal manera que se obtengan conjuntos **cada vez más puros**.

Necesitamos una medida la de impureza.

- En tareas de clasificación se usa el **índice de Gini**. Siempre toma valores entre 0 y 1, y **toma el valor 0 solamente para los conjuntos puros**.

La fórmula matemática para calcular el **índice de Gini** de un conjunto de ejemplos $D$ es la siguiente:

**$G(D) = 1 - \sum_{c \in C} \hat{\Pi}_{c}^{2}$**

Donde los componentes de la expresión significan lo siguiente:

- **$C$**: es el **conjunto de clases posibles** en tu problema.
- **$\hat{\Pi}_{c}$**: es la **proporción de ejemplos del conjunto $D$ que están etiquetados con la clase $c$**, lo cual sirve para estimar la probabilidad de que un ejemplo pertenezca a esa clase en particular.

---

**Ejercicio 11**

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

Ácido palmítico
Valores ordenados: 875, 1030, 1075, 1088, 1092, 1096, 1098, 1106, 1110, 1220, 1306, 1350, 1361, 1454.

Ácido oleico
6437 - 7193 - 7320 - 7354 - 7365 - 7377 - 7396 - 7743 - 7760 - 7910 - 7955 - 7960

2. **Calcular los umbrales candidatos:** Determinas los posibles puntos de corte (umbrales, $u$). Estos se calculan como el punto medio entre cada par de valores consecutivos de la secuencia ordenada ($u_i = \frac{x_i + x_{i+1}}{2}$).

Ácido palmítico

3. **Evaluar cada partición:** Para cada umbral candidato, divides tu conjunto de 15 ejemplos en dos ramas:
   - **Rama Izquierda:** Los ejemplos cuyo valor en ese atributo es menor o igual al umbral ($\le u$).
   - **Rama Derecha:** Los ejemplos cuyo valor es mayor al umbral ($> u$).
     A continuación, calculas el índice de Gini para el subconjunto izquierdo y el índice de Gini para el subconjunto derecho.

**Ácido palmítico**

- Primer umbral (u_1): La media entre 875 y 1030, que es **952.5**
  Rama Izquierda = {E1}
  Rama Derecha = Caen los 14 ejemplos restantes (4 Sur, 5 Cerdeña, 5 Centro norte).
  G(R_izquierda) = 1 - $(\frac{1}{1})^2$ = **0**
  G(R_derecha) = 1 - $(\frac{4}{14})^2$ - $(\frac{5}{14})^2$ - $(\frac{5}{14})^2$ = **0.6633**

- Segundo umbral (u_2): la media entre 1030 y 1075, que es 1052,5
  Rama Izquierda = {E1 (Sur), E6 (Cerdeña)}
  Rama Derecha = los 13 ejemplos restantes: 4 Sur, 4 Cerdeña y 5 Centro Norte
  G(R_izquierda) = 1 - $(\frac{1}{2})^2$ - $(\frac{1}{2})^2$ = 0.5
  G(R_derecha) = 1 - $(\frac{4}{13})^2$ - $(\frac{4}{13})^2$ - $(\frac{5}{13})^2$ = 0.6627

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

4. **Calcular la impureza promedio:** Combinas ambos índices de Gini haciendo una media ponderada según la cantidad de ejemplos que hayan caído en cada lado. La fórmula es:
   $\text{Impureza Promedio} = \frac{\text{Nº ejemplos Izq.}}{\text{Total ejemplos}} \cdot G(\text{Izq.}) + \frac{\text{Nº ejemplos Der.}}{\text{Total ejemplos}} \cdot G(\text{Der.})$

5. **Elegir el ganador:** Repites este proceso para todos los umbrales candidatos del "Ácido palmítico" y todos los del "Ácido oléico". El par exacto de **(Atributo, Umbral)** que te dé como resultado la **impureza promedio más baja** será la condición elegida para construir tu nodo raíz y separar los datos por primera vez.
