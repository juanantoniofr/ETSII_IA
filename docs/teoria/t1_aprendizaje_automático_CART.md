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
