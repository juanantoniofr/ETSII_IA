# Redes Neuronales

## 1. Perceptron

El **perceptrón** es un tipo fundamental de neurona artificial utilizado principalmente como un modelo de clasificación binaria, donde asocia a cada entrada una salida que suele ser 0 o 1 (clase negativa y positiva).

Para dominar este concepto, estos son los puntos clave que debes conocer sobre su funcionamiento, entrenamiento y limitaciones:

### 1.1 Su funcionamiento matemático

El perceptrón toma decisiones calculando una combinación lineal de las entradas y aplicando una regla muy sencilla:

- Recibe una serie de argumentos o características de entrada ($x_1, \dots, x_m$) y a cada uno le asocia un **peso** ($w_1, \dots, w_m$) que determina su importancia.
- A esta suma ponderada se le añade un **sesgo** ($b$, a menudo representado como un peso virtual $w_0$ asociado a una entrada $x_0=1$). El sesgo determina con qué facilidad se activa el perceptrón; un sesgo mayor hace más fácil que la salida sea 1. Geométricamente, el sesgo es crucial porque permite que el hiperplano que separa las clases no tenga que pasar obligatoriamente por el origen de coordenadas.
- Finalmente, el resultado de esta suma ($z$) pasa por una **función de activación**. En el perceptrón clásico se usa la **función umbral**, que devuelve 1 si $z > 0$, y 0 si $z \le 0$. También se puede utilizar la función signo, que devuelve 1 o -1.

### 1.2 Cómo aprende (Entrenamiento)

El perceptrón aprende mediante **aprendizaje supervisado** ajustando sus pesos cuando se equivoca al predecir.

- Inicialmente, los pesos se asignan de forma aleatoria.
- Si al evaluar un ejemplo de entrenamiento la salida obtenida ($a$) es diferente a la salida real esperada ($y$), los pesos se actualizan usando la fórmula: $w_i \leftarrow w_i + \eta(y - a)x_i$.
- En esta fórmula, $\eta$ representa el **factor de aprendizaje**, un número mayor que cero que regula cómo de grandes son los pasos que da el modelo al ajustar sus pesos.

### 1.3 Su gran limitación: La separabilidad lineal

El aspecto teórico más importante del perceptrón es que **solo es capaz de aprender a clasificar conjuntos de ejemplos que sean linealmente separables**. Esto significa que debe existir un hiperplano (una línea en 2D, un plano en 3D, etc.) que divida perfectamente los ejemplos positivos de los negativos.

- El **Teorema de Minsky y Papert (1969)** demostró que si un problema es linealmente separable y el factor de aprendizaje es adecuado, el algoritmo del perceptrón siempre convergerá y encontrará la solución en un número finito de pasos.
- Sin embargo, si los datos no son linealmente separables, el perceptrón fracasará. El ejemplo clásico de este fracaso es la **función lógica XOR (disyunción exclusiva)**, que es imposible de separar con una sola línea recta, por lo que un perceptrón individual no puede aprenderla.

### 1.4 Evolución hacia las redes neuronales modernas

Para solucionar las limitaciones del perceptrón simple, surgieron dos grandes avances:

- **Redes multicapa:** Al combinar múltiples perceptrones en distintas capas (capas ocultas), la red adquiere una capacidad expresiva mucho mayor, siendo capaz de resolver problemas no lineales como el XOR.
- **Cambio en la función de activación:** La función umbral del perceptrón clásico da saltos bruscos (de 0 a 1) y no es derivable de forma útil, lo que impide usar algoritmos de entrenamiento eficientes como el descenso por el gradiente. Por ello, en las redes neuronales modernas, el perceptrón evoluciona sustituyendo la función umbral por funciones suaves y diferenciables, como la función **sigmoide**, la **tangente hiperbólica** o la función **ReLU**.

### 1.5 Ejercicios

#### 1.5.1 Ejercicio 2

Consideremos un perceptrón con cuatro argumentos, con sesgo 𝑤𝟢 = 0.6 y pesos 𝑤𝟣 = −0.7, 𝑤𝟤 = −0.1, 𝑤𝟥 = −0.4, 𝑤𝟦 = 0.5 y que usa la función signo como función de activación. Se pide calcular la matriz de confusión del perceptrón sobre el siguiente conjunto de ejemplos y derivar a partir de ella su tasa de aciertos, sensibilidad, especificidad y precisión:

| x1   | x2   | x3   | x4   | y   |
| ---- | ---- | ---- | ---- | --- |
| 0.5  | -1.0 | -1.0 | 1.0  | -1  |
| -1.0 | -0.5 | 0.0  | 0.5  | -1  |
| 1.0  | -1.0 | 0.5  | -0.5 | 1   |
| 0.5  | 1.0  | 0.0  | 0.0  | 1   |
| -1.0 | -1.0 | -0.5 | -0.5 | -1  |
| 1.0  | -0.5 | 0.0  | 0.0  | -1  |
| -0.5 | 0.0  | -0.5 | 0.0  | -1  |
| 1.0  | 1.0  | 0.5  | -1.0 | 1   |
| 0.0  | 0.0  | -0.5 | -1.0 | 1   |
| 0.0  | 0.0  | -0.5 | 0.5  | -1  |

Recordemos primero los pesos y la regla de activación:

- **Pesos:** $w_0 = 0.6$, $w_1 = -0.7$, $w_2 = -0.1$, $w_3 = -0.4$, $w_4 = 0.5$.
- **Función signo:** Si $z > 0 \rightarrow 1$ (Positivo). Si $z \le 0 \rightarrow -1$ (Negativo).

Aquí tienes el desarrollo de los ejemplos del 2 al 10:

- **Ejemplo_1** = (1 _ 0.6) + (0.5 _ -0.7) + (-1.0 _ -0.1) + (-1.0 _ -0.4) + (1.0 \* 0.5) = 0.6 - O.35 + 0.1 + 0.4 + 0.5 = 1.25 ->f_signo(1.25) = 1 -> **Falso Positivo (FP)**

- **Ejemplo 2:** $x_1 = -1.0,\; x_2 = -0.5,\; x_3 = 0.0,\; x_4 = 0.5$ (Clase real $y = -1$)
  - $z_2 = (1 \times 0.6) + (-1.0 \times -0.7) + (-0.5 \times -0.1) + (0.0 \times -0.4) + (0.5 \times 0.5)$
  - $z_2 = 0.6 + 0.7 + 0.05 - 0.0 + 0.25 = \mathbf{1.6}$
  - $f\_signo(1.6) = 1$. Predice Positivo (1), la realidad es Negativo (-1) $\rightarrow$ **Falso Positivo (FP)**.

- **Ejemplo 3:** $x_1 = 1.0,\; x_2 = -1.0,\; x_3 = 0.5,\; x_4 = -0.5$ (Clase real $y = 1$)
  - $z_3 = (1 \times 0.6) + (1.0 \times -0.7) + (-1.0 \times -0.1) + (0.5 \times -0.4) + (-0.5 \times 0.5)$
  - $z_3 = 0.6 - 0.7 + 0.1 - 0.2 - 0.25 = \mathbf{-0.45}$
  - $f\_signo(-0.45) = -1$. Predice Negativo (-1), la realidad es Positivo (1) $\rightarrow$ **Falso Negativo (FN)**.

- **Ejemplo 4:** $x_1 = 0.5,\; x_2 = 1.0,\; x_3 = 0.0,\; x_4 = 0.0$ (Clase real $y = 1$)
  - $z_4 = (1 \times 0.6) + (0.5 \times -0.7) + (1.0 \times -0.1) + (0.0 \times -0.4) + (0.0 \times 0.5)$
  - $z_4 = 0.6 - 0.35 - 0.1 - 0.0 + 0.0 = \mathbf{0.15}$
  - $f\_signo(0.15) = 1$. Predice Positivo (1), la realidad es Positivo (1) $\rightarrow$ **Verdadero Positivo (VP)**.

- **Ejemplo 5:** $x_1 = -1.0,\; x_2 = -1.0,\; x_3 = -0.5,\; x_4 = -0.5$ (Clase real $y = -1$)
  - $z_5 = (1 \times 0.6) + (-1.0 \times -0.7) + (-1.0 \times -0.1) + (-0.5 \times -0.4) + (-0.5 \times 0.5)$
  - $z_5 = 0.6 + 0.7 + 0.1 + 0.2 - 0.25 = \mathbf{1.35}$
  - $f\_signo(1.35) = 1$. Predice Positivo (1), la realidad es Negativo (-1) $\rightarrow$ **Falso Positivo (FP)**.

- **Ejemplo 6:** $x_1 = 1.0,\; x_2 = -0.5,\; x_3 = 0.0,\; x_4 = 0.0$ (Clase real $y = -1$)
  - $z_6 = (1 \times 0.6) + (1.0 \times -0.7) + (-0.5 \times -0.1) + (0.0 \times -0.4) + (0.0 \times 0.5)$
  - $z_6 = 0.6 - 0.7 + 0.05 - 0.0 + 0.0 = \mathbf{-0.05}$
  - $f\_signo(-0.05) = -1$. Predice Negativo (-1), la realidad es Negativo (-1) $\rightarrow$ **Verdadero Negativo (VN)**.

- **Ejemplo 7:** $x_1 = -0.5,\; x_2 = 0.0,\; x_3 = -0.5,\; x_4 = 0.0$ (Clase real $y = -1$)
  - $z_7 = (1 \times 0.6) + (-0.5 \times -0.7) + (0.0 \times -0.1) + (-0.5 \times -0.4) + (0.0 \times 0.5)$
  - $z_7 = 0.6 + 0.35 - 0.0 + 0.2 + 0.0 = \mathbf{1.15}$
  - $f\_signo(1.15) = 1$. Predice Positivo (1), la realidad es Negativo (-1) $\rightarrow$ **Falso Positivo (FP)**.

- **Ejemplo 8:** $x_1 = 1.0,\; x_2 = 1.0,\; x_3 = 0.5,\; x_4 = -1.0$ (Clase real $y = 1$)
  - $z_8 = (1 \times 0.6) + (1.0 \times -0.7) + (1.0 \times -0.1) + (0.5 \times -0.4) + (-1.0 \times 0.5)$
  - $z_8 = 0.6 - 0.7 - 0.1 - 0.2 - 0.5 = \mathbf{-0.9}$
  - $f\_signo(-0.9) = -1$. Predice Negativo (-1), la realidad es Positivo (1) $\rightarrow$ **Falso Negativo (FN)**.

- **Ejemplo 9:** $x_1 = 0.0,\; x_2 = 0.0,\; x_3 = -0.5,\; x_4 = -1.0$ (Clase real $y = 1$)
  - $z_9 = (1 \times 0.6) + (0.0 \times -0.7) + (0.0 \times -0.1) + (-0.5 \times -0.4) + (-1.0 \times 0.5)$
  - $z_9 = 0.6 - 0.0 - 0.0 + 0.2 - 0.5 = \mathbf{0.3}$
  - $f\_signo(0.3) = 1$. Predice Positivo (1), la realidad es Positivo (1) $\rightarrow$ **Verdadero Positivo (VP)**.

- **Ejemplo 10:** $x_1 = 0.0,\; x_2 = 0.0,\; x_3 = -0.5,\; x_4 = 0.5$ (Clase real $y = -1$)
  - $z_{10} = (1 \times 0.6) + (0.0 \times -0.7) + (0.0 \times -0.1) + (-0.5 \times -0.4) + (0.5 \times 0.5)$
  - $z_{10} = 0.6 - 0.0 - 0.0 + 0.2 + 0.25 = \mathbf{1.05}$
  - $f\_signo(1.05) = 1$. Predice Positivo (1), la realidad es Negativo (-1) $\rightarrow$ **Falso Positivo (FP)**.

¡Ahí los tienes todos! Con esto ya tienes todas las predicciones listas para cuando desees avanzar al siguiente paso por tu cuenta.

- matriz de confusión

  $$
  \begin{pmatrix}
  VP & FN \\
  FP & VN
  \end{pmatrix}
  $$

  Como VP = 2, FP = 5, FN = 2, VN = 1

$$
  \begin{pmatrix}
  2 & 5 \\
  2 & 1
  \end{pmatrix}
$$

tasa de aciertos = VP + VN / |numero_de_ejemplos| = 2+1/10 = 0.3
sensibilidad = VP / (FN + VP) = 2 /(2+2) = 0.5
especificidad = VN / (FP + VN) = 1 /(1+5) = 0.1666
precisión = VP / (VP + FP) = 2 / (5+2) = 0.2857

#### 1.5.2 ejercicio 4

Consideremos el siguiente conjunto de ejemplos:

| x1  | x2  | y   |
| --- | --- | --- |
| 2   | 0   | 1   |
| 0   | 0   | -1  |
| 2   | 2   | 1   |
| 0   | 1   | -1  |
| 1   | 1   | 1   |
| 1   | 2   | -1  |

Se pide:

- Representar gráficamente el conjunto de ejemplos y comprobar que es linealmente separable.
- Tomando η = 0.1 como factor de aprendizaje y 𝑤𝟢 = 𝑤𝟣 = 𝑤𝟤 = 0 como valor inicial para el sesgo y los pesos, entrenar un perceptrón con función de activación signo hasta que clasifique correctamente todos los ejemplos.

- **Ejemplo 1** $x_0 = 1; x_1 = 2,\; x_2 = 0,\;$ (Clase real $y = 1$)
  $z_1 = (1 \times 0) + (2 \times 0) + (0 \times 0) = 0$ => f_signo(0) = -1
- Como hemos fallado en la predicción -> actualizamos los pesos
  w0 <- w0 + η(y - a )x0 = 0 + (0.1 _ 2 _ 1) = 0.2
  w1 <- w1 + η(y - a)x1 = 0 + (0.1 _ 2 _ 2) = 0.4
  w2 <- w2 + η(y - a)x2 = 0 + (0.1 _ 2 _ 0) = 0

- **Ejemplo 2** $x_0 = 1; x_1 = 0,\; x_2 = 0,\;$ (Clase real $y = -1$)
  $z_1 = (1 \times 0.2) + (0 \times 0.4) + (0 \times 0) = 0$ => f_signo(0.2) = 1
- Como hemos fallado en la predicción -> actualizamos los pesos
  w0 <- w0 + η(y - a)x0 = 0.2 + (0.1 _ -2 _ 1) = 0
  w1 <- w1 + η(y - a)x1 = 0.4 + (0.1 _ -2 _ 0) = 0.4
  w2 <- w2 + η(y - a)x2 = 0 + (0.1 _ -2 _ 0) = 0

- **Ejemplo 3** $x_0 = 1; x_1 = 2,\; x_2 = 2,\;$ (Clase real $y = 1$)
  $z_1 = (1 \times 0) + (2 \times 0.4) + (2 \times 0) = 0.8$ => f_signo(0.8) = 1
- Esta vez si hemos acertado, pasamos al ejemplo 4

- **Ejemplo 4** $x_0 = 1; x_1 = 0,\; x_2 = 1,\;$ (Clase real $y = -1$)
  $z_1 = (1 \times 0) + (0 \times 0.4) + (1 \times 0) = 0$ => f_signo(0) = -1
- También acertamos

- **Ejemplo 5** $x_0 = 1; x_1 = 1,\; x_2 = 1,\;$ (Clase real $y = 1$)
  $z_1 = (1 \times 0) + (1 \times 0.4) + (1 \times 0) = 0.4$ => f_signo(0.4) = 1
- Acierto

- **Ejemplo 6** $x_0 = 1; x_1 = 1,\; x_2 = 2,\;$ (Clase real $y = -1$)
  $z_1 = (1 \times 0) + (1 \times 0.4) + (2 \times 0) = 0.4$ => f_signo(0.4) = 1
- Fallamos, actualizamos pesos
  w0 <- w0 + η(y - a)x0 = 0 + (0.1 _ -2 _ 1) = -0.2
  w1 <- w1 + η(y - a)x1 = 0.4 + (0.1 _ -2 _ 1) = 0.2
  w2 <- w2 + η(y - a)x2 = 0 + (0.1 _ -2 _ 2) = -0.4

**Época 2**

- **Ejemplo 1** $x_0 = 1; x_1 = 2,\; x_2 = 0,\;$ (Clase real $y = 1$)
  $z_1 = (1 \times -0.2) + (2 \times 0.2) + (0 \times -0.4) = 0.2$ => f_signo(0.2) = 1
- Acierto
- **Ejemplo 2** $x_0 = 1; x_1 = 0,\; x_2 = 0,\;$ (Clase real $y = -1$)
  $z_1 = (1 \times -0.2) + (0 \times 0.2) + (0 \times -0.4) = -0.2$ => f_signo(-0.2) = -1
- Acierto
- **Ejemplo 3** $x_0 = 1; x_1 = 2,\; x_2 = 2,\;$ (Clase real $y = 1$)
  $z_1 = (1 \times -0.2) + (2 \times 0.2) + (2 \times -0.4) = -0.6$ => f_signo(-0.6) = -1
- Fallo, ajustamos pesos
  w0 <- w0 + η(y - a)x0 = -0.2 + (0.1 _ 2 _ 1) = 0
  w1 <- w1 + η(y - a)x1 = 0.2 + (0.1 _ 2 _ 2) = 0.6
  w2 <- w2 + η(y - a)x2 = -0.4+ (0.1 _ 2 _ 2) = 0
- **Ejemplo 4** $x_0 = 1; x_1 = 0,\; x_2 = 1,\;$ (Clase real $y = -1$)
  $z_1 = (1 \times 0) + (0 \times 0.6) + (0 \times 0) = 0$ => f_signo(0) = -1
- Acierto
- **Ejemplo 5** $x_0 = 1; x_1 = 0,\; x_2 = 1,\;$ (Clase real $y = 1$)
  $z_1 = (1 \times 0) + (0 \times 0.6) + (1 \times 0) = 0.6$ => f_signo(0.6) = 1
- Acierto
- **Ejemplo 6** $x_0 = 1; x_1 = 1,\; x_2 = 2,\;$ (Clase real $y = -1$)
  $z_1 = (1 \times 0) + (1 \times 0.6) + (2 \times 0) = 0.6$ => f_signo(0.6) = 1
- Fallo....

--- Seguimos hasta que se clasifiquen correctamente todos los ejemplos ---

#### 1.5.3 ejercicio 18

Para encontrar la solución no hay que realizar ningún entrenamiento numérico, sino deducir lógicamente los parámetros basándonos en cómo funciona la combinación lineal del perceptrón.

Esta es la solución paso a paso:

**1. Los pesos de los argumentos ($w_1, w_2, \dots, w_n$)**
Para saber si hay mayoría de unos, el primer paso lógico es contar cuántos unos hemos recibido en la entrada. Para que el producto escalar actúe como un "contador", lo ideal es asignar a cada argumento un peso de exactamente 1.

- Establecemos **$w_i = 1$** para todo $i = 1, \dots, n$.
- De esta forma, la suma $\sum_{i=1}^n w_i x_i$ nos dará como resultado directo la cantidad total de unos presentes en la entrada.

**2. El sesgo ($w_0$)**
El enunciado exige que haya _estrictamente más_ unos que ceros. En un conjunto de $n$ bits totales, esto ocurre matemáticamente cuando la cantidad de unos es estrictamente mayor que la mitad del total de bits, es decir, cuando la suma de los unos es $> \frac{n}{2}$.

Sabemos que este perceptrón, al usar la función umbral, se activará y devolverá 1 solo cuando el resultado de $z$ sea mayor que cero:
$$ \sum\_{i=1}^n x_i + w_0 > 0 $$

Como nuestra condición para que se active es que la suma sea mayor que $\frac{n}{2}$ (es decir, $\sum x_i > \frac{n}{2}$), si reorganizamos esta inecuación pasando la mitad de $n$ al lado izquierdo obtenemos:
$$ \sum\_{i=1}^n x_i - \frac{n}{2} > 0 $$

Por comparación directa con la fórmula del perceptrón, obtenemos que el sesgo necesario es **$w_0 = -\frac{n}{2}$**.

**Solución final:**

El perceptrón que resuelve el problema de la mayoría simple se diseña con los siguientes parámetros:

- **Pesos:** $w_1 = 1,\; w_2 = 1,\; \dots,\; w_n = 1$
- **Sesgo:** $w_0 = -\frac{n}{2}$
- **Función de activación:** Función umbral.

**Un pequeño ejemplo de comprobación para $n=4$ bits:**

- El sesgo sería $w_0 = -\frac{4}{2} = -2$.
- Si tenemos empate (ej. $x_1=1, x_2=1, x_3=0, x_4=0$): El producto escalar es $z = (1+1+0+0) - 2 = 0$. La función umbral para $0$ devuelve **0** (no hay estrictamente más unos).
- Si tenemos mayoría (ej. $x_1=1, x_2=1, x_3=1, x_4=0$): El producto escalar es $z = (1+1+1+0) - 2 = 1$. Al ser $1 > 0$, la función umbral devuelve **1** (sí hay mayoría).

#### 1.5.4 ejercicio 19
