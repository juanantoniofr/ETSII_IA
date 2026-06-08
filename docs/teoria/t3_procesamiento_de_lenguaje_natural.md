# Procesamiento de Lenguaje Natural

## 0. Introducción

Las dos aproximaciones más comunes para el procesamiento de lenguaje natural (PLN) son:

- **aproximación simbólica**: se basa en reglas y estructuras lingüísticas explícitas.
- **aproximación estadística o empírica**: se basa en modelos probabilísticos y aprendizaje automático. `esta es la aproximación más común en la actualidad y la que veremos en este tema`.

## 1. Clasificación de documentos

Para clasificarr documentos lo primero que necesitamos es construir un **modelo de lenguaje** que nos permita representar los documentos de forma numérica. El primero que vamos a ver es el **modelo de bolsa de palabras**.

### 1.1 Modelo de bolsa de palabras

Dado un vocabulario finito de términos V prejijado, cada documento se representa como un vector de frecuencias de términos. Por ejemplo, si tenemos el vocabulario V = { "gato", "perro", "pájaro" } y un documento D que contiene las palabras "gato" y "perro", el vector de características para D sería [1, 1, 0].

Una vez construido el modelo, abordamos la clasificación de documentos utilizando algoritmos de aprendizaje supervisado.

### 1.2 Algoritmos de clasificación

#### 1.2.1 Naive Bayes Multinomial

Asigna a cada documento D, la etiqueta c que maximiza la probabilidad condicional P(c|D). Utiliza la fórmula de Bayes y asume que las características (términos) son independientes entre sí.

$P(c|D) = \frac{P(D|c)P(c)}{P(D)}$

entonces c = argmax_c P(c|D) = argmax_c P(D|c)P(c)/P(D), como P(D) es constante para todas las clases, se puede simplificar a: argmax_c P(D|c)P(c), donde P(D|c) se calcula como el producto de las probabilidades de cada término dado la clase c, es decir, P(D|c) = Π P(t_i|c) para cada término t_i en el documento D.

Así concluimos que c = argmax_c P(c) Π P(t_i|c) y para evitar desbordamientos numéricos, se suele trabajar con logaritmos, lo que nos da: c = argmax_c log P(c) + Σ log P(t_i|c).

- El aprendizaje de parámetros se realiza a partir de una estimación de máxima verosimilitud, contando la frecuencia de cada término en los documentos de cada clase y aplicando suavizado para evitar probabilidades cero.
  - P(c) = (número de documentos en la clase c) / (número total de documentos)
  - P(t_i|c) = (número de veces que aparece el término t_i en los documentos de la clase c + k) / (número total de términos en los documentos de la clase c + k \* |V|), donde k es el parámetro de suavizado y |V| es el tamaño del vocabulario.

##### 1.2.1.1 Ejercicios

**Ejerecicio 3**

En las opiniones de diversos espectadores de cinco determinadas películas se han identificado las siguientes palabras clave que las describen:
𝑃𝟣: Divertida, de parejas, de amores, de amores.
𝑃𝟤: Rápida, frenética, de disparos.
𝑃𝟥: De parejas, rápida, divertida, divertida.
𝑃𝟦: Frenética, de disparos, de disparos, divertida.
𝑃𝟧: Rápida, de disparos, de amores.

Considerando 𝑉 = {de amores, de disparos, de parejas, divertida, freńetica, ŕapida} como vocabulario de términos y sabiendo que las películas 𝑃𝟣 y 𝑃𝟥 son comedias y las películas 𝑃𝟤 , 𝑃𝟦 y 𝑃𝟧 son de acción, se pide determinar el género de la película 𝑃 descrita por ciertos espectadores como
𝑃: rápida, de parejas, de disparos, rápida.

Usar para ello la bolsa de palabras como modelo de lenguaje y naive Bayes multinomial con suavizado de Laplace como modelo clasificador.

- Solución:

1. Construimos el modelo de bolsa de palabras para cada película:

|                   | D1 (comedia) | D2 (acción) | D3 (comedia) | D4 (acción) | D5 (acción) | Suma Comedia | Suma Acción |
| ----------------- | ------------ | ----------- | ------------ | ----------- | ----------- | ------------ | ----------- |
| de amores         | 2            | 0           | 0            | 0           | 1           | 2            | 1           |
| de disparos       | 0            | 1           | 0            | 2           | 1           | 0            | 4           |
| de parejas        | 1            | 0           | 1            | 0           | 0           | 2            | 0           |
| divertida         | 1            | 0           | 2            | 1           | 0           | 3            | 1           |
| frenética         | 0            | 1           | 0            | 1           | 0           | 0            | 2           |
| rápida            | 0            | 1           | 1            | 0           | 1           | 1            | 2           |
| Total de Palabras | 4            | 3           | 4            | 4           | 3           | 8 (N_c1)     | 10 (N_c2)   |

2. Calculamos los parámetros del modelo Naive Bayes Multinomial con suavizado de Laplace:

- P(comedia) = 2/5, P(acción) = 3/5, k = 1.

3. Calculamos P(D|comedia) y P(D|acción) para la película P:

- |V| = 6

- Para comedia:
  - P(de amores|comedia) = (2 + 1) / (8 + 6) = 3/14
  - P(de disparos|comedia) = (0 + 1) / (8 + 6) = 1/14
  - P(de parejas|comedia) = (2 + 1) / (8 + 6) = 3/14
  - P(divertida|comedia) = (3 + 1) / (8 + 6) = 4/14
  - P(frenética|comedia) = (0 + 1) / (8 + 6) = 1/14
  - P(rápida|comedia) = (1 + 1) / (8 + 6) = 2/14

- Para acción:
  - P(de amores|acción) = (0 + 1) / (10 + 6) = 1/16
  - P(de disparos|acción) = (4 + 1) / (10 + 6) = 5/16
  - P(de parejas|acción) = (0 + 1) / (10 + 6) = 1/16
  - P(divertida|acción) = (1 + 1) / (10 + 6) = 2/16
  - P(frenética|acción) = (2 + 1) / (10 + 6) = 3/16
  - P(rápida|acción) = (2 + 1) / (10 + 6) = 3/16

- Aplicamos el modelo Naive Bayes para clasificar la película P: rápida, de parejas, de disparos, rápida.
  - P(comedia|D) = P(comedia) _ P(de amores|comedia)^0 _ P(de disparos|comedia)^1 _ P(de parejas|comedia)^1 _ P(divertida|comedia)^0 _ P(frenética|comedia)^0 _ P(rápida|comedia)^2
  - P(comedia|D) = $(2/5) * (3/14)^0 * (1/14)^1 * (3/14)^1 * (4/14)^0 * (1/14)^0 * (2/14)^2$
  - P(comedia|D) = $(2/5) * (1/14) * (3/14) * (2/14)^2 = (2/5) * (1/14) * (3/14) * (4/196)$ = $(2/5) * (1/14) * (3/14) * (1/49)$ = 3 / 24010 = **0.00012495**

  - P(acción|D) = P(acción) _ P(de amores|acción)^0 _ P(de disparos|acción)^1 _ P(de parejas|acción)^1 _ P(divertida|acción)^0 _ P(frenética|acción)^0 _ P(rápida|acción)^2
  - P(acción|D) = $(3/5) * (1/16)^0 * (5/16)^1 * (1/16)^1 * (2/16)^0 * (3/16)^0 * (3/16)^2$
  - P(acción|D) = $(3/5) * (1/16) * ( 5/16) * (1/16) * (2/16) * (3/16) * (3/16)$
  - P(acción|D) = $(3/5) * (1/16) * (5/16) * (1/16) * (2/16) * (3/16) * (3/16) = (3/5) * (1/16) * (5/16) * (1/16) * (2/16) * (3/16) * (3/16)$ = 27 / 65535 = **0.00041199**

- Concluimos que la película P es de acción, ya que P(acción|D) > P(comedia|D). Se clasifica la película P como de acción con un nivel de confianza en tanto por ciento de: P(acción|D) / (P(acción|D) + P(comedia|D)) = 0.00041199 / (0.00041199 + 0.00012495) ≈ **76.8%**.

### 1.3 Modelo de lenguaje tf-idf

El modelo de bolsa de palabras **no tiene en cuenta la importancia de los términos** en el documento ni en el corpus, simplemente tiene en cuenta **el número de veces que aparece cada término en el documento**. Para solucionar esto, se utiliza el **modelo de lenguaje tf-idf (term frequency - inverse document frequency), que **asigna un peso a cada término en función de su frecuencia en el documento y su frecuencia inversa en el corpus\*\*.

Cada documento se representa como un vector de pesos tf-idf, donde el peso de cada término t en el documento d se calcula como:

$$tf-idf(t, d) = tf(t, d) * idf(t)$$

donde

- tf(t, d) es la frecuencia del término t en el documento d y
- idf(t) es la frecuencia inversa del término t en el corpus, calculada como: $idf(t) = log(N / df(t))$,
  - donde
    - N es el número total de documentos en el corpus y
    - df(t) es el número de documentos que contienen el término t.

De esta forma los términos raros en el corpus tienen una idf(t) alta, mientras que los términos comunes tienen una idf(t) baja.

Gráfica del log(X):

![alt text](500px-Logarithm_plots.png)

Por Richard F. Lyon - made myself, alt version of Logarithm plots.svg with better text, CC BY-SA 3.0, https://commons.wikimedia.org/w/index.php?curid=13257335

#### 1.3.1 Clasificador kNN con tf-idf

Dado un nuevo docuemnto D, se calcula su vector de pesos tf-idf y se compara con los vectores de los documentos de entrenamiento utilizando una medida de similitud, como la similitud del coseno. Se asigna a D la etiqueta de la clase mayoritaria entre sus k vecinos más cercanos.

El coseno del angulo de dos vectores A y B nos dicen como se parecen en términos de dirección, sin tener en cuenta su magnitud. El coseno del angulo se calcula como:
$$cos(\theta) = \frac{A \cdot B}{||A|| ||B||}$$

Entoces dada la representación tf-idf de dos documentos A y B, la similitud del coseno se calcula como:
$$sim(A, B) = \frac{A \cdot B}{||A|| ||B||} = \frac{\sum_{i=1}^n A_i \cdot B_i}{\sqrt{\sum_{i=1}^n A_i^2} \sqrt{\sum_{i=1}^n B_i^2}}$$

Como log en base a de x $log_a(x) = \frac{log_b(x)}{log_b(a)}$, entonces $log_a(x) = log_b(x) / log_b(a)$, la base del logaritmo es irrelevante para el cálculo de idf.

##### 1.3.1.1 Ejercicios

**Ejercicio 4**

A continuación se muestra el poema 1 del libro de poemas Marinero en tierra de Rafael Alberti, que consta de cinco estrofas, cada una de las cuales la consideramos un documento.

- D1: El mar. La mar. El mar. ¡Solo la mar!
- D2: ¿Por qué me trajiste, padre, a la ciudad?
- D3: ¿Por qué me desenterraste del mar?
- D4: En sueños, la marejada me tira del corazón. Se lo quisiera llevar.

Para pruebas, se añade una estrofa más:

- D5: Padre, ¿por qué me trajiste acá?

Tomando V = {la, mar, me, trajiste} como vocabulario de términos y **{D1, D2, D3, D4} como corpus de entrenamiento**, se pide:

- 1. Obtener la representación de cada una de las estrofas bajo el modelo tf-idf.
- D1: El mar. La mar. El mar. ¡Solo la mar!

  | Término      | $tf$ | $df$ | $idf = \log_2(4/df)$                   | $tf \times idf$                   |
  | :----------- | :--- | :--- | :------------------------------------- | :-------------------------------- |
  | **la**       | 2    | 3    | $\log_2(4/3) \approx \mathbf{0.415}$   | $2 \times 0.415 = \mathbf{0.830}$ |
  | **mar**      | 4    | 2    | $\log_2(4/2) = \log_2(2) = \mathbf{1}$ | $4 \times 1 = \mathbf{4}$         |
  | **me**       | 0    | 3    | $\log_2(4/3) \approx \mathbf{0.415}$   | $\mathbf{0}$                      |
  | **trajiste** | 0    | 1    | $\log_2(4/1) = \log_2(4) = \mathbf{2}$ | $\mathbf{0}$                      |

- D2: ¿Por qué me trajiste, padre, a la ciudad?

  | D2           | tf  | df  | idf                                    | $tf \times idf$                   |
  | :----------- | :-- | :-- | :------------------------------------- | :-------------------------------- |
  | **la**       | 1   | 3   | $\log_2(4/3) \approx \mathbf{0.415}$   | $1 \times 0.415 = \mathbf{0.415}$ |
  | **mar**      | 0   | 2   | $\log_2(4/2) = \log_2(2) = \mathbf{1}$ | $\mathbf{0}$                      |
  | **me**       | 1   | 3   | $\log_2(4/3) \approx \mathbf{0.415}$   | $1 \times 0.415 = \mathbf{0.415}$ |
  | **trajiste** | 1   | 1   | $\log_2(4/1) = \log_2(4) = \mathbf{2}$ | $1 \times 2 = \mathbf{2}$         |

- D3: ¿Por qué me desenterraste del mar?

  | D3           | tf  | df  | idf                                    | $tf \times idf$                   |
  | :----------- | :-- | :-- | :------------------------------------- | :-------------------------------- |
  | **la**       | 0   | 3   | $\log_2(4/3) \approx \mathbf{0.415}$   | $\mathbf{0}$                      |
  | **mar**      | 1   | 2   | $\log_2(4/2) = \log_2(2) = \mathbf{1}$ | $1 \times 1 = \mathbf{1}$         |
  | **me**       | 1   | 3   | $\log_2(4/3) \approx \mathbf{0.415}$   | $1 \times 0.415 = \mathbf{0.415}$ |
  | **trajiste** | 0   | 1   | $\log_2(4/1) = \log_2(4) = \mathbf{2}$ | $\mathbf{0}$                      |

- D4: En sueños, la marejada me tira del corazón. Se lo quisiera llevar.

  | D4           | tf  | df  | idf                                    | $tf \times idf$                   |
  | :----------- | :-- | :-- | :------------------------------------- | :-------------------------------- |
  | **la**       | 1   | 3   | $\log_2(4/3) \approx \mathbf{0.415}$   | $1 \times 0.415 = \mathbf{0.415}$ |
  | **mar**      | 1   | 2   | $\log_2(4/2) = \log_2(2) = \mathbf{1}$ | $1 \times 1 = \mathbf{1}$         |
  | **me**       | 1   | 3   | $\log_2(4/3) \approx \mathbf{0.415}$   | $1 \times 0.415 = \mathbf{0.415}$ |
  | **trajiste** | 0   | 1   | $\log_2(4/1) = \log_2(4) = \mathbf{2}$ | $\mathbf{0}$                      |

- 2. Suponiendo que las estrofas D1 y D2 son positivas y que las estrofas D3 y D4 son negativas, clasificar la estrofa D5 como positiva o negativa mediante un modelo kNN que use el coseno del ángulo de sus
     representaciones tf-idf como medida de similitud entre dos estrofas y k = 3 como cantidad a considerar de estrofas más similares.

- D5: Padre, ¿por qué me trajiste acá?

| d5           | tf  | df  | idf                                    | $tf \times idf$                   |
| :----------- | :-- | :-- | :------------------------------------- | :-------------------------------- |
| **la**       | 1   | 3   | $\log_2(4/3) \approx \mathbf{0.415}$   | $1 \times 0.415 = \mathbf{0.415}$ |
| **mar**      | 0   | 2   | $\log_2(4/2) = \log_2(2) = \mathbf{1}$ | $\mathbf{0}$                      |
| **me**       | 1   | 3   | $\log_2(4/3) \approx \mathbf{0.415}$   | $1 \times 0.415 = \mathbf{0.415}$ |
| **trajiste** | 1   | 1   | $\log_2(4/1) = \log_2(4) = \mathbf{2}$ | $1 \times 2 = \mathbf{2}$         |

- Postivas: D1, D2
  $$sim(D5, D1) = \frac{0.415 \cdot 0.830 + 0 \cdot 4 + 0.415 \cdot 0 + 2 \cdot 0}{\sqrt{0.415^2 + 0^2 + 0.415^2 + 2^2} \sqrt{0.830^2 + 4^2 + 0^2 + 0^2}} = \frac{0.34495}{\sqrt{4.173225} \sqrt{16.6889}} = \frac{0.34495}{2.0425 \cdot 4.086} = \mathbf{0.0413}$$
  $$sim(D5, D2) = \frac{0.415 \cdot 0.415 + 0 \cdot 0 + 0.415 \cdot 0.415 + 2 \cdot 2}{\sqrt{0.415^2 + 0^2 + 0.415^2 + 2^2} \sqrt{0.415^2 + 0^2 + 0.415^2 + 2^2}} = \frac{4.172225}{\sqrt{4.173225} \sqrt{4.173225}} = \mathbf{1}$$

- Negativas: D3, D4
  $$sim(D5, D3) = \frac{0.415 \cdot 0 + 0 \cdot 1 + 0.415 \cdot 0.415 + 0 \cdot 0}{\sqrt{0.415^2 + 0^2 + 0.415^2 + 2^2} \sqrt{0^2 + 1^2 + 0.415^2 + 0^2}} = \frac{0.172225}{\sqrt{4.173225} \sqrt{1.172225}} = \frac{0.172225}{2.0425 \cdot 1.0826} = \mathbf{0.0779}$$
  $$sim(D5, D4) = \frac{0.415 \cdot 0 + 0 \cdot 1 + 0.415 \cdot 0.415 + 2 \cdot 0}{\sqrt{0.415^2 + 0^2 + 0.415^2 + 2^2} \sqrt{0.415^2 + 1^2 + 0.415^2 + 0^2}} = \frac{0.172225}{\sqrt{4.173225} \sqrt{1.172225}} = \frac{0.172225}{2.0425 \cdot 1.0826} = \mathbf{0.0779}$$

- Concluimos que las estrofas más similares a D5 son D2, D4 y D3, de las cuales dos son positivas y una es negativa. Por lo tanto, clasificamos la estrofa D5 como positiva.

### 1.4 Predicción de secuencia de términos

#### 1.4.1 Modelos de lenguaje n-grama

- En primer lugar, usando la regla de la cadena de Markov, se asume que la probabilidad de una palabra depende solo de las n-1 palabras anteriores,
  es decir, P(w)=P(w*{1}w*{2}...w*{n-1})=P(w*{1})P(w*{2}|w*{1})P(w*{3}|w*{1}w*{2})...P(w*{n-1}|w*{1}w*{2}...w\_{n-2}).
- En segundo lugar, se utiliza el modelo de lenguaje n-grama, que estima la probabilidad de una palabra dada las n-1 palabras anteriores, es decir,
  P(w*{n}|w*{1}w*{2}...w*{n-1}) ≈ P(w*{n}|w*{n-1}w*{n-2}...w*{n-(n-1)}), donde n es el tamaño del n-grama.

En definitva, el modelo de n-gramas estima la probabilidad de una secuencia como el producto de las probabilidades de cada palabra dada las n-1 palabras anteriores, es decir,
P(w*{1}w*{2}...w*{n}) ≈ Π P(w*{i}|w*{i-(n-1)}...w*{i-1}), para i = 1, 2, ..., n.
Para evitar desbordamientos numéricos al multiplicar muchas probabilidades pequeñas, se suele trabajar con logaritmos, lo que nos da:
$$log P(w_{1}w_{2}...w_{n}) ≈ \sum_{i=1}^n log P(w_{i}|w_{i-(n-1)}...w_{i-1})$$

- **¿cómo se calculan las probabilidades P(w*{i}|w*{i-(n-1)}...w\_{i-1})?** Se pueden calcular con el **método de máxima verosimilitud**, contando la frecuencia de cada n-grama en un corpus de entrenamiento
  y aplicando suavizado para evitar probabilidades cero.

$$P(w_{i}|w_{i-(n-1)}...w_{i-1}) = \frac{C(w_{i-(n-1)}...w_{i}) + k}{C(w_{i-(n-1)}...w_{i-1}) + k \cdot |V|}$$

**Alternativas al suavizado son**:

- backoff: si el n-grama no se encuentra en el corpus, se retrocede a un n-grama de tamaño n-1, y así sucesivamente hasta llegar a un unigram.
- interpolación: se combina la probabilidad del n-grama con las probabilidades de los n-gramas de tamaño inferior, utilizando pesos $\lambda_i$ que suman 1.
  $$P(w*{i}|w*{i-(n-1)}...w*{i-1}) = \lambda_{1}P(w*{i}|w*{i-(n-1)}...w*{i-1}) + \lambda_{2}P(w*{i}|w*{i-(n-2)}...w*{i-2}) + ...\lambda_{n}P(w*{i}|w*{i-(n-n)}...w*{1})$$

- **¿cómo se evalúa la calidad (rendimiento) de un modelo de lenguaje?** Se puede utilizar la **perplejidad**, que mide la capacidad del modelo para predecir una secuencia de palabras. La perplejidad se
  define como la inversa de la probabilidad media de la secuencia, es decir,

$$P(W) = P(w_{1}w_{2}...w_{n})^{-1/n} = (\prod_{i=1}^m P(w_{i}|w_{i-(n-1)}...w_{i-1}))^{-1/n} = \sqrt[n]{\prod_{i=1}^m P(w_{i}|w_{i-(n-1)}...w_{i-1})}$$

Para evitar desbordamientos numéricos, se suele trabajar con logaritmos, lo que nos da:

$$log P(W) = -\frac{1}{n} \sum_{i=1}^m log P(w_{i}|w_{i-(n-1)}...w_{i-1})$$

donde n es el número de términos en el corpus de prueba (Vocabulario), unión con el símbolo final de secuencia </s> y m es el número de términos en la secuencia de prueba.

##### 1.4.1.1 Ejercicios

- Ejercicio 8
  Consideremos el vocabulario V = {a, b, c} y el corpus de entrenamiento formado por las siguientes secuencias de términos:

⟨s⟩a a a b⟨/s⟩ ⟨s⟩b a a c⟨/s⟩ ⟨s⟩a c a⟨/s⟩ ⟨s⟩b a c a⟨/s⟩ ⟨s⟩b b b a⟨/s⟩ ⟨s⟩a c b b⟨/s⟩ ⟨s⟩b a a b a⟨/s⟩ ⟨s⟩c b a⟨/s⟩ ⟨s⟩a b b b b⟨/s⟩ ⟨s⟩a a a⟨/s⟩

Se pide **construir un modelo bigrama** y calcular la probabilidad que le asigna a la secuencia de términos: ⟨s⟩a c c b c c c c b c⟨/s⟩

cuando se usa cada una de las siguientes técnicas para abordar el problema de las estimaciones nulas de las probabilidades de los bigramas que no aparecen en el corpus:

- 1. Aplicar un suavizado de Laplace.
- 2. Aplicar retroceso: si P(t1 | t2) se estima como 0, entonces usar P(t1) en su lugar.
- 3. Aplicar la interpolación lineal 1/2P(t1 | t2) + 1/2P(t1).

- Solución:

1. modelo bigrama:

N = 49, ya que el corpus de entrenamiento tiene 49 términos (contando el símbolo de inicio ⟨s⟩ y el símbolo de fin ⟨/s⟩). Suma de todas las frecuencias de los bigramas es 49.

| Unigramas                   | Frecuencia | P(t) = Frecuencia / N |
| --------------------------- | ---------- | --------------------- |
| ⟨s⟩                         | 10         | no se genera          |
| a                           | 20         | 20/49 ≈ 0.408         |
| b                           | 15         | 15/49 ≈ 0.306         |
| c                           | 4          | 4/49 ≈ 0.082          |
| ⟨/s⟩                        | 10         | 10/49 ≈ 0.204         |
| N = Suma de las frecuencias | 49         | -                     |

2. cálculo de probabilidades:
   ​

| Bigramas | Frecuencia | Suavizado de Laplace (k=1)        |  Retroceso (si 0→P(y))  | Interpolación (λ=1/2) - $1/2 C(x)/C(xy) + 1/2  P(y)$ |
| -------- | ---------- | --------------------------------- | :---------------------: | :--------------------------------------------------: |
| ⟨s⟩ a    | 5          | (5 + 1) / (10 + 4) = 6/14 ≈ 0.429 |       5/10 = 0.5        |     1/2 (5/10) + 1/2 (20/49) = 0.25 + 0.2 = 0.45     |
| ⟨s⟩ b    | 4          | (4 + 1) / (10 + 4) = 5/14 ≈ 0.38  |       4/10 = 0.4        |      1/2 (4/10) + 1/2 (10/49) = 0.2 + 0.1 = 0.3      |
| ⟨s⟩ c    | 1          | (1 + 1) / (10 + 4) = 2/14 ≈ 0.143 |       1/10 = 0.1        |     1/2 (1/10) + 1/2 (10/49) = 0.05 + 0.1 = 0.15     |
| <s></s⟩  | 0          | (0 + 1) / (10 + 4) = 1/14 ≈ 0.071 | P(⟨/s⟩) = 10/49 ≈ 0.204 |       1/2 (0/10) + 1/2 (10/49) = 0 + 0.1 = 0.1       |
| a a      | 8          | (8 + 1) / (20 + 4) = 9/24 ≈ 0.375 |       8/20 = 0.25       |     1/2 (6/20) + 1/2 (20/49) = 0.15 + 0.2 = 0.35     |
| a b      | 3          | (3 + 1) / (20 + 4) = 4/24 ≈ 0.167 |       3/20 = 0.15       |    1/2 (3/20) + 1/2 (10/49) = 0.075 + 0.1 = 0.175    |
| a c      | 3          | (3 + 1) / (20 + 4) = 4/24 ≈ 0.167 |       3/20 = 0.15       |    1/2 (3/20) + 1/2 (10/49) = 0.075 + 0.1 = 0.175    |
| a ⟨/s⟩   | 6          | (6 + 1) / (20 + 4) = 7/24 ≈ 0.292 |       6/20 = 0.3        |     1/2 (6/20) + 1/2 (10/49) = 0.15 + 0.1 = 0.25     |
| b a      | 6          | (6 + 1) / (15 + 4) = 7/19 ≈ 0.368 |       6/15 = 0.4        |      1/2 (6/15) + 1/2 (20/49) = 0.2 + 0.2 = 0.4      |
| b b      | 6          | (6 + 1) / (15 + 4) = 7/19 ≈ 0.368 |       6/15 = 0.4        |      1/2 (6/15) + 1/2 (10/49) = 0.2 + 0.1 = 0.3      |
| b c      | 0          | (0 + 1) / (15 + 4) = 1/19 ≈ 0.053 |   P(c) = 4/49 ≈ 0.082   |       1/2 (0/15) + 1/2 (10/49) = 0 + 0.1 = 0.1       |
| b ⟨/s⟩   | 3          | (3 + 1) / (15 + 4) = 4/19 ≈ 0.211 |       3/15 ≈ 0.2        |           1/2 (0/15) + 1/2 (0) = 0 + 0 = 0           |
| c a      | 1          | (1 + 1) / (4 + 4) = 2/8 ≈ 0.25    |       1/4 = 0.25        |     1/2 (2/4) + 1/2 (20/49) = 0.25 + 0.2 = 0.45      |
| c b      | 2          | (2 + 1) / (4 + 4) = 3/8 ≈ 0.375   |        2/4 = 0.5        |    1/2 (1/4) + 1/2 (10/49) = 0.125 + 0.1 = 0.225     |
| c c      | 0          | (0 + 1) / (4 + 4) = 1/8 ≈ 0.125   |   P(c) = 4/49 ≈ 0.082   |       1/2 (0/4) + 1/2 (10/49) = 0 + 0.1 = 0.1        |
| c ⟨/s⟩   | 1          | (0 + 1) / (4 + 4) = 1/8 ≈ 0.125   |       1/4 = 0.25        |       1/2 (0/4) + 1/2 (10/49) = 0 + 0.1 = 0.1        |

- La probabilidad de la secuencia ⟨s⟩a c c b c c c c b c⟨/s⟩ se calcula como el producto de las probabilidades de cada bigrama en la secuencia, utilizando cada una de las técnicas:

- 1. Aplicar un suavizado de Laplace.

  $$P(⟨s⟩a c c b c c c c b c⟨/s⟩) = P(a \| ⟨s⟩) P(c \| a) P(c \| c) P(b \| c) P(c \| b) P(c \| c) P(c \| c) P(c \| c) P(b \| c) P(c \| b) P(⟨/s⟩ \| c)$$
  $$= 0.049 \times 0.167 \times 0.125 \times 0.053 \times 0.375 \times 0.125 \times 0.125 \times 0.125 \times 0.053 \times 0.375 \times 0.125$$

- 2. Aplicar retroceso: si P(t1 | t2) se estima como 0, entonces usar P(t1) en su lugar.

  $$P(⟨s⟩a c c b c c c c b c⟨/s⟩) = P(a \| ⟨s⟩) P(c \| a) P(c \| c) P(b \| c) P(c \| b) P(c \| c) P(c \| c) P(c \| c) P(b \| c) P(c \| b) P(⟨/s⟩ \| c)$$
  $$= 0.5 \times 0.15 \times 0.082 \times 0.082 \times 0.15 \times 0.082 \times 0.082 \times 0.082 \times 0.082 \times 0.15 \times 0.25$$

- 3. Aplicar la interpolación lineal 1/2P(t1 | t2) + 1/2P(t1).
     $$P(⟨s⟩a c c b c c c c b c⟨/s⟩) = P(a \| ⟨s⟩) P(c \| a) P(c \| c) P(b \| c) P(c \| b) P(c \| c) P(c \| c) P(c \| c) P(b \| c) P(c \| b) P(⟨/s⟩ \| c)$$
     $$= 0.45 \times 0.175 \times 0.1 \times 0.1 \times 0.175 \times 0.1 \times 0.1 \times 0.1 \times 0.1 \times 0.175 \times 0.1$$
