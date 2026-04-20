# Ejercicios del boletín de Redes Neuronales

## Ejercicio 3.

### Apartado a

Representar gráficamente el conjunto de ejemplos y comprobar que es linealmente separable. Razonar a qué clase deberían pertenecer los ejemplos (0,1), (−1,−1) y (0,0) para que el conjunto siguiera siendo linealmente separable.

**Solución**
Una vez representado el conjunto de ejemplos se aprecia que es un conjunto linealmente separable. Por ejemplo, la función x2=m⋅x1+b (a mayor "m" más vertical es la recta, a mayor b la recta se mueve entera hacia arriba) separa linealmente el conjunto de datos en dos clases:

- Clase positiva (y=1): (1, 1) y (-1, 1)
- Clase negativa (y=0): (0, -1) y (-1, 0)

#### ¿a qué clase pertenecen los ejemplos siguientes?

- (0,1) -> clase positiva
- (-1,-1) -> clase negativa
- (0,0) -> depende de f(x)?

### apartado b:

Tomando η = 0.1 como factor de aprendizaje y 𝑤𝟢 = 0.1, 𝑤𝟣 = 𝑤𝟤 = −0.1 como valores iniciales para el sesgo y los pesos, entrenar un perceptrón con función de activación umbral hasta que clasifique correctamente todos los ejemplos. Con el sesgo y los pesos aprendidos, calcular la salida proporcionada por el perceptrón para los ejemplos (0,1), (−1,−1) y (0,0).

**Solución**

Para resolver el segundo punto del Ejercicio 3, aplicaremos el algoritmo de aprendizaje del perceptrón sobre el conjunto de datos hasta que todos los ejemplos sean clasificados correctamente.

Los parámetros iniciales establecidos por el problema son:

- **Factor de aprendizaje ($\eta$):** $0.1$
- **Pesos iniciales:** $w_0 = 0.1$, $w_1 = -0.1$, $w_2 = -0.1$
- **Función de activación:** Umbral (devuelve $1$ si $z > 0$, y devuelve $0$ si $z \le 0$).
- **Regla de actualización:** $w_i = w_i + \eta(y - a)x_i$ (considerando $x_0 = 1$ para el sesgo).

A continuación tienes los cálculos tabulados época por época. El algoritmo se detiene cuando completa una pasada entera (época) sin cometer ningún error ni actualizar los pesos.

### Entrenamiento del Perceptrón

| Época | Ejemplo $(x_1, x_2)$ | Clase real ($y$) | Pesos actuales $(w_0, w_1, w_2)$ | Entrada neta ($z$) | Predicción ($a$) | ¿Falla? (Actualiza) | Nuevos pesos $(w_0, w_1, w_2)$ |
| :---: | :------------------: | :--------------: | :------------------------------- | :----------------: | :--------------: | :-----------------: | :----------------------------- |
| **1** |       $(1, 1)$       |        1         | $(0.1, -0.1, -0.1)$              |        -0.1        |        0         |         Sí          | **$(0.2, 0.0, 0.0)$**          |
| **1** |      $(0, -1)$       |        0         | $(0.2, 0.0, 0.0)$                |        0.2         |        1         |         Sí          | **$(0.1, 0.0, 0.1)$**          |
| **1** |      $(-1, 0)$       |        0         | $(0.1, 0.0, 0.1)$                |        0.1         |        1         |         Sí          | **$(0.0, 0.1, 0.1)$**          |
| **1** |      $(-1, 1)$       |        1         | $(0.0, 0.1, 0.1)$                |        0.0         |        0         |         Sí          | **$(0.1, 0.0, 0.2)$**          |
|       |                      |                  |                                  |                    |                  |                     |                                |
| **2** |       $(1, 1)$       |        1         | $(0.1, 0.0, 0.2)$                |        0.3         |        1         |         No          | $(0.1, 0.0, 0.2)$              |
| **2** |      $(0, -1)$       |        0         | $(0.1, 0.0, 0.2)$                |        -0.1        |        0         |         No          | $(0.1, 0.0, 0.2)$              |
| **2** |      $(-1, 0)$       |        0         | $(0.1, 0.0, 0.2)$                |        0.1         |        1         |         Sí          | **$(0.0, 0.1, 0.2)$**          |
| **2** |      $(-1, 1)$       |        1         | $(0.0, 0.1, 0.2)$                |        0.1         |        1         |         No          | $(0.0, 0.1, 0.2)$              |
|       |                      |                  |                                  |                    |                  |                     |                                |
| **3** |       $(1, 1)$       |        1         | $(0.0, 0.1, 0.2)$                |        0.3         |        1         |         No          | $(0.0, 0.1, 0.2)$              |
| **3** |      $(0, -1)$       |        0         | $(0.0, 0.1, 0.2)$                |        -0.2        |        0         |         No          | $(0.0, 0.1, 0.2)$              |
| **3** |      $(-1, 0)$       |        0         | $(0.0, 0.1, 0.2)$                |        -0.1        |        0         |         No          | $(0.0, 0.1, 0.2)$              |
| **3** |      $(-1, 1)$       |        1         | $(0.0, 0.1, 0.2)$                |        0.1         |        1         |         No          | $(0.0, 0.1, 0.2)$              |

### Conclusión

Como se puede observar en la tabla, durante la **Época 3** el modelo ha evaluado los cuatro ejemplos del conjunto de entrenamiento logrando una predicción correcta en todos ellos ($y = a$) y, por lo tanto, no se han producido modificaciones.

El entrenamiento converge aquí, y los pesos finales aprendidos por el modelo son:

- $w_0 = 0.0$
- $w_1 = 0.1$
- $w_2 = 0.2$

### Con el sesgo y los pesos aprendidos, calcular la salida proporcionada por el perceptrón para los ejemplos (0,1), (−1,−1) y (0,0).

| Ejemplo $(x_1, x_2)$ | Pesos finales $(w_0, w_1, w_2)$ | Cálculo de la entrada neta ($z$)              | Función de activación umbral     | Clase Predicha ($a$) |
| :------------------: | :-----------------------------: | :-------------------------------------------- | :------------------------------- | :------------------- |
|      **(0, 1)**      |        $(0.0, 0.1, 0.2)$        | $z = 0.0 + 0.1(0) + 0.2(1) = \mathbf{0.2}$    | Como $0.2 > 0$, se activa.       | **1** (Positiva)     |
|     **(-1, -1)**     |        $(0.0, 0.1, 0.2)$        | $z = 0.0 + 0.1(-1) + 0.2(-1) = \mathbf{-0.3}$ | Como $-0.3 \le 0$, no se activa. | **0** (Negativa)     |
|      **(0, 0)**      |        $(0.0, 0.1, 0.2)$        | $z = 0.0 + 0.1(0) + 0.2(0) = \mathbf{0.0}$    | Como $0.0 \le 0$, no se activa.  | **0** (Negativa)     |

Estos cálculos tabulados aplican directamente la regla matemática del perceptrón clásico, donde la entrada neta se calcula como la suma ponderada de las entradas más el sesgo ($z = w^Tx + b$) y la salida se determina mediante la función umbral, que devuelve 1 estrictamente cuando $z > 0$ y 0 en caso contrario.

## Ejercicio 11.

En la tabla se muestran los vectores de entrada neta ($z^l$) y de activación ($a^l$) calculados capa por capa. Recuerda que para las capas ocultas ($l=2$ y $l=3$) se aplica la función sigmoide vectorizada, mientras que para la capa de salida ($l=4$) se aplica la función identidad (es decir, $a^4 = z^4$).

_(Nota: Los valores han sido redondeados a 4 cifras decimales para mantener la tabla limpia y legible. El superíndice $T$ indica que matemáticamente son vectores columna)._

### Resultados detallados de las capas intermedias y de salida

|   Ejemplo $(x_1, x_2)$    |         Variable         | Capa Oculta 2 ($l=2$)                                             | Capa Oculta 3 ($l=3$)                           | Capa de Salida ($l=4$)   |
| :-----------------------: | :----------------------: | :---------------------------------------------------------------- | :---------------------------------------------- | :----------------------- |
| **1** <br> $(1.0, -1.9)$  | **$z^l$** <br> **$a^l$** | $(-2.6400, -0.4500, -0.0200)^T$ <br> $(0.0666, 0.3894, 0.4950)^T$ | $(0.5167, 0.5448)^T$ <br> $(0.6264, 0.6329)^T$  | $-0.0780$ <br> $-0.0780$ |
| **2** <br> $(-1.7, -3.9)$ | **$z^l$** <br> **$a^l$** | $(-1.4100, -1.4500, -0.7000)^T$ <br> $(0.1962, 0.1899, 0.3318)^T$ | $(0.5211, 0.5717)^T$ <br> $(0.6274, 0.6391)^T$  | $-0.0804$ <br> $-0.0804$ |
|  **3** <br> $(0.3, 0.0)$  | **$z^l$** <br> **$a^l$** | $(-0.8700, 0.5000, -0.6800)^T$ <br> $(0.2953, 0.6225, 0.3363)^T$  | $(0.7653, 0.1044)^T$ <br> $(0.6825, 0.5261)^T$  | $0.0147$ <br> $0.0147$   |
| **4** <br> $(-2.4, 4.7)$  | **$z^l$** <br> **$a^l$** | $(4.3800, 2.8500, -2.7000)^T$ <br> $(0.9876, 0.9453, 0.0630)^T$   | $(1.2437, -0.8220)^T$ <br> $(0.7762, 0.3053)^T$ | $0.1907$ <br> $0.1907$   |
|  **5** <br> $(0.9, 1.1)$  | **$z^l$** <br> **$a^l$** | $(-0.7500, 1.0500, -0.6600)^T$ <br> $(0.3208, 0.7408, 0.3407)^T$  | $(0.8304, -0.0212)^T$ <br> $(0.6964, 0.4947)^T$ | $0.0401$ <br> $0.0401$   |

Esta tabla te será muy útil si en el futuro necesitas practicar a mano la segunda fase del algoritmo (la **retropropagación** del error hacia atrás). Cuando tengas que calcular los "Deltas" ($\Delta^3$ o $\Delta^2$), simplemente tendrás que usar los vectores $a^l$ que acabamos de tabular aquí para evaluar las derivadas locales de la sigmoide, recordando el truco de que $\sigma'(z^l) = a^l \odot (1 - a^l)$.
