<link rel="stylesheet" href="../css/estilo.css">

# Fórmulas

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
