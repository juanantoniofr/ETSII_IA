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
