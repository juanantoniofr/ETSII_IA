<link rel="stylesheet" href="../css/estilo.css">

# Árboles de Clasificación y Regresión (CART)

<br />
<div class="summary">

- Los valores de los atributos pueden ser discretos o continuos.
- Puede abordar problemas de clasificación y regresión.

</div>

<div class="highlight-theory">

## 1. Realización de la tarea

- Los CART es un árbol binario donde cada nodo interno está etiquetado con un atributo y un valor umbral, y cada nodo hoja con una clase (clasificación) o un valor numérico (regresión).
- Dado un ejemplo, el CART lo "clasifica" asignándole como salida el valor de un nodo hoja, resultado de recorrer el árbol de la raíz a las hojas.
- En cada nodo interno (con atributo X y umbral u) se toma la rama de la izquierda si el valor de X del ejemplo en menor o igual (<=) al valor umbral, se toma la rama derecha en caso contrario.
- Un CART puede entenderse como una colección de reglas de tipo condicional (si X <= u_x && Y > u_y && Z <= u_z entonces Clase = A)

## 2. Aprendizaje del modelo

**¿Cómo construimos el árbol?**

Supongamos que estamos en un nodo intermedio, entonces tengo que **buscar la condición que proporcione la mejor partición**, asociarla a ese nodo, y bifurcar el subconjunto de entrenamiento en dos ramas. Continuando el proceso hasta que el conjunto resultante sea indivisible.

Se dice que se va particionando el conjunto de entrenamiento `D` de tal manera que se obtengan conjuntos **cada vez más puros**.

Necesitamos, pues, una medida de impureza.

**Tareas de clasificación**

En tareas de clasificación se usa el **índice de Gini**, que siempre toma valores entre 0 y 1, y **toma el valor 0 solamente para los conjuntos puros**.

La fórmula matemática para calcular el **índice de Gini** de un conjunto de ejemplos $D$ es la siguiente:

**$G(D) = 1 - \sum_{c \in C} \hat{\Pi}_{c}^{2}$**

Donde los componentes de la expresión significan lo siguiente:

- **$C$**: es el **conjunto de clases posibles** en tu problema.
- **$\hat{\Pi}_{c}$**: es la **proporción de ejemplos del conjunto $D$ que están etiquetados con la clase $c$**, lo cual sirve para estimar la probabilidad de que un ejemplo pertenezca a esa clase en particular.

La formula para calcular el **índice de Gini ponderado** de una partición de un conjunto de entrenamiento $D$ en dos ramas (izquierda y derecha) es la siguiente:

$$G_{partición} = \frac{|D_{izquierda}|}{|D|} G(D_{izquierda}) + \frac{|D_{derecha}|}{|D|} G(D_{derecha})$$

Donde los componentes de la expresión significan lo siguiente:

- **$G(D_{izquierda})$**: es el índice de Gini del subconjunto de ejemplos que cumplen la condición de la rama izquierda.
- **$G(D_{derecha})$**: es el índice de Gini del subconjunto de ejemplos que cumplen la condición de la rama derecha.
- **$|D_{izquierda}|$** y **$|D_{derecha}|$**: son el número de ejemplos en cada una de las ramas, respectivamente.
- **$|D|$**: es el número total de ejemplos en el conjunto original $D$.

<div class="summary">

**Proceso paso a paso**

Para atributos discretos, el algoritmo CART considera cada valor posible del atributo como un umbral de división:

- 1. Divides el **conjunto de entrenamiento** según el atributo.
  - 1.1 Para cada valor del atributo, creas una rama que contenga todos los ejemplos que tengan ese valor.
  - 1.2 Calculas el Gini de cada rama individual (qué mezcla de clases queda en cada subgrupo)
  - 1.3 Calculas el Gini promedio **ponderado** de la división (multiplicando el Gini de cada rama por el porcentaje de ejemplos totales que han caído en ella).
- 2. Eliges al ganador indiscutible: **el atributo que minimice ese índice de Gini promedio**.

Una vez que haces esto para la raíz, repites este bucle exacto con los datos que hayan caído en cada rama para seguir haciendo crecer el árbol.

</div>

**Tareas de regresión**

Cuando el atributo que queremos predecir no es una clase discreta, sino un valor numérico continuo (por ejemplo, el volumen de un cerezo o el consumo de combustible de un coche), nos encontramos ante una tarea de regresión.

El algoritmo CART sigue exactamente la misma mecánica de ordenar valores, buscar umbrales en los puntos medios y dividir los datos en rama izquierda y derecha, pero **modifica tres elementos matemáticos clave** para adaptarse a los números continuos:

**1. La función de impureza (Se sustituye Gini por la Varianza)**
En tareas de regresión, el algoritmo CART utiliza la **varianza** para medir la impureza de un conjunto de datos. La fórmula utilizada calcula la dispersión de los valores del atributo objetivo respecto a su media: $$Var(\mathcal{D}) = \frac{1}{|\mathcal{D}|}\sum(y-\overline{y})^{2}$$.

- La varianza toma un valor de **0 (pureza total)** únicamente cuando todos los ejemplos de ese nodo tienen asociado exactamente el mismo valor.
- Al construir el árbol, en lugar de minimizar el índice de Gini promedio, el algoritmo buscará el umbral que proporcione la **varianza promedio más baja** para particionar los datos.

$$ Varianza*promedio = \frac{n*{izquierda}}{n*{total}} * Varianza*{izquierda} + \frac{n*{derecha}}{n\_{total}} \_ Varianza\_{derecha}$$

**2. La etiqueta de las hojas (Predicción final)**
En clasificación, cuando un nodo se convertía en una hoja (nodo final), se le asignaba la "clase mayoritaria". En regresión, cada hoja del árbol se etiqueta con la **media aritmética** de los valores del atributo objetivo de los ejemplos que han caído en ese nodo. Cuando llegue un ejemplo nuevo y alcance esa hoja, esa media será la predicción numérica que devuelva el modelo.

</div>

<div class="highlight-theory">

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

</div>

<div class="highlight-exercise">

## 3. Ejercicios

**Ejercicio 9**

Se han encontrado una gran cantidad de pinturas de las que se conoce que han sido realizadas o bien por el pintor A o bien por el pintor B, pero solo de un pequeño número de ellas se ha podido determinar cuál de los dos es el autor. De estas últimas se conocen los siguientes datos:

| Técnica utilizada | Lugar de origen | Estilo de la pintura | Tiene marco | Autor    |
| :---------------- | :-------------- | :------------------- | :---------- | :------- |
| grabado           | España          | clásico              | no          | pintor B |
| grabado           | España          | moderno              | no          | pintor B |
| grabado           | Portugal        | moderno              | no          | pintor B |
| grabado           | Francia         | clásico              | sí          | pintor B |
| grabado           | Francia         | moderno              | no          | pintor B |
| grabado           | Francia         | moderno              | sí          | pintor B |
| óleo              | España          | clásico              | sí          | pintor A |
| óleo              | España          | clásico              | no          | pintor A |
| óleo              | Francia         | moderno              | no          | pintor A |
| óleo              | Portugal        | moderno              | sí          | pintor B |
| óleo              | España          | moderno              | sí          | pintor B |
| acuarela          | Francia         | clásico              | no          | pintor B |
| acuarela          | España          | clásico              | sí          | pintor A |
| acuarela          | Francia         | moderno              | no          | pintor B |
| acuarela          | España          | moderno              | no          | pintor A |
| acuarela          | Portugal        | moderno              | sí          | pintor B |

Se pide:

1.  Construir mediante el algoritmo CART un árbol de decisión que prediga el autor de una pintura en función de las características de esta.

Empecemos por el atributo **Técnica utilizada**. Tenemos 6 ejemplos de grabado, 5 de óleo y 5 de acuarela.

Para **técnica = grabado**,

- El conjunto de la izquierda tiene 6 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (6/6)^2 = 0$.
- El conjunto de la derecha tiene 10 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (5/10)^2 - (5/10)^2 = 0.5$.
- El indice de Gini ponderado de la partición es $G_{partición} = (6/16) * 0 + (10/16) * 0.5 = 0.3125$ -> **G_ponderado(técnica=grabado) = 0.3125**.

Para **técnica = óleo**,

- El conjunto de la izquierda tiene 5 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (3/5)^2 - (2/5)^2 = 0.48$.
- El conjunto de la derecha tiene 11 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (3/11)^2 - (8/11)^2 = 0.3967$.
- El indice de Gini ponderado de la partición es $G_{partición} = (5/16) * 0.48 + (11/16) * 0.3967 = 0.419$ -> **G_ponderado(técnica=óleo) = 0.419**.

Para **técnica = acuarela**,

- El conjunto de la izquierda tiene 5 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (3/5)^2 - (2/5)^2 = 0.48$.
- El conjunto de la derecha tiene 11 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (3/11)^2 - (8/11)^2 = 0.3967$.
- El indice de Gini ponderado de la partición es $G_{partición} = (5/16) * 0.48 + (11/16) * 0.3967 = 0.419$ -> **G_ponderado(técnica=acuarela) = 0.419**.

Para **Lugar de origen = España**,

- El conjunto de la izquierda tiene 7 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (4/7)^2 - (3/7)^2 = 0.4898$.
- El conjunto de la derecha tiene 9 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (4/9)^2 - (5/9)^2 = 0.4938$.
- El indice de Gini ponderado de la partición es $G_{partición} = (7/16) * 0.4898 + (9/16) * 0.4938 = 0.491$ -> **G_ponderado(lugar=España) = 0.491**.

Para **Lugar de origen = Portugal**,

- El conjunto de la izquierda tiene 4 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (2/4)^2 - (2/4)^2 = 0.5$.
- El conjunto de la derecha tiene 12 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (6/12)^2 - (6/12)^2 = 0.5$.
- El indice de Gini ponderado de la partición es $G_{partición} = (4/16) * 0.5 + (12/16) * 0.5 = 0.5$ -> **G_ponderado(lugar=Portugal) = 0.5**.

Para **Lugar de origen = Francia**,

- El conjunto de la izquierda tiene 5 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (3/5)^2 - (2/5)^2 = 0.48$.
- El conjunto de la derecha tiene 11 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (3/11)^2 - (8/11)^2 = 0.3967$;
- El indice de Gini ponderado de la partición es $G_{partición} = (5/16) * 0.48 + (11/16) * 0.3967 = 0.419$ -> **G_ponderado(lugar=Francia) = 0.419**.

Para **Estilo de la pintura = clásico**,

- El conjunto de la izquierda tiene 6 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (4/6)^2 - (2/6)^2 = 0.4444$.
- El conjunto de la derecha tiene 10 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (3/10)^2 - (7/10)^2 = 0.42$.
- El indice de Gini ponderado de la partición es $G_{partición} = (6/16) * 0.4444 + (10/16) * 0.42 = 0.429$ -> **G_ponderado(estilo=clásico) = 0.429**.

Para **Tiene marco = sí**,

- El conjunto de la izquierda tiene 7 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (4/7)^2 - (3/7)^2 = 0.4898$.
- El conjunto de la derecha tiene 9 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (4/9)^2 - (5/9)^2 = 0.4938$.
- El indice de Gini ponderado de la partición es $G_{partición} = (7/16) * 0.4898 + (9/16) * 0.4938 = 0.491$ -> **G_ponderado(tiene marco=sí) = 0.491**.

El atributo que minimiza el índice de Gini ponderado es **Técnica utilizada = grabado** con un valor de 0.3125.

Didividiendo el conjunto de entrenamiento en dos ramas según la técnica utilizada, obtenemos:

- Rama izquierda: 6 ejemplos de grabado, todos del pintor B (nodo hoja).
- Rama derecha: 10 ejemplos de óleo y acuarela, con 5 del pintor A y 5 del pintor B (nodo intermedio).

--

Repetimos el proceso para la rama derecha, considerando únicamente los 10 ejemplos de óleo y acuarela.

Para **Lugar de origen = España**,

- El conjunto de la izquierda tiene 4 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (3/4)^2 - (1/4)^2 = 0.375$.
- El conjunto de la derecha tiene 6 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (2/6)^2 - (4/6)^2 = 0.4444$.
- El indice de Gini ponderado de la partición es $G_{partición} = (4/10) * 0.375 + (6/10) * 0.4444 = 0.4167$ -> **G_ponderado(lugar=España) = 0.4167**.

Para **Lugar de origen = Portugal**,

- El conjunto de la izquierda tiene 2 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (1/2)^2 - (1/2)^2 = 0.5$.
- El conjunto de la derecha tiene 8 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (4/8)^2 - (4/8)^2 = 0.5$.
- El indice de Gini ponderado de la partición es $G_{partición} = (2/10) * 0.5 + (8/10) * 0.5 = 0.5$ -> **G_ponderado(lugar=Portugal) = 0.5**.

Para **Lugar de origen = Francia**,

- El conjunto de la izquierda tiene 4 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (2/4)^2 - (2/4)^2 = 0.5$.
- El conjunto de la derecha tiene 6 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (3/6)^2 - (3/6)^2 = 0.5$.
- El indice de Gini ponderado de la partición es $G_{partición} = (4/10) * 0.5 + (6/10) * 0.5 = 0.5$ -> **G_ponderado(lugar=Francia) = 0.5**.

Para **Estilo de la pintura = clásico**,

- El conjunto de la izquierda tiene 4 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (3/4)^2 - (1/4)^2 = 0.375$.
- El conjunto de la derecha tiene 6 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (2/6)^2 - (4/6)^2 = 0.4444$.
- El indice de Gini ponderado de la partición es $G_{partición} = (4/10) * 0.375 + (6/10) * 0.4444 = 0.4167$ -> **G_ponderado(estilo=clásico) = 0.4167**.

Para **Tiene marco = sí**,

- El conjunto de la izquierda tiene 5 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (2/5)^2 - (3/5)^2 = 0.48$.
- El conjunto de la derecha tiene 5 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (3/5)^2 - (2/5)^2 = 0.48$.
- El indice de Gini ponderado de la partición es $G_{partición} = (5/10) * 0.48 + (5/10) * 0.48 = 0.48$ -> **G_ponderado(tiene marco=sí) = 0.48**.

Ahora tenemos empate entre los atributos **Lugar de origen** (España) y **Estilo de la pintura** (clásico), todos con un valor de 0.4167. Elegimos **Lugar de origen** como atributo para dividir el nodo intermedio.

Como resultado de la división por **Lugar de origen**, obtenemos:

- Rama izquierda: 5 ejemplos de España, con 4 del pintor A y 1 del pintor B (nodo intermedio).
- Rama derecha: 5 ejemplos de Portugal y Francia, con 1 del pintor A y 4 del pintor B (nodo intermedio).

Secuencia lógica de decisiones:
Si **Técnica utilizada = grabado**, entonces **Autor = pintor B**.
Si **Técnica utilizada != grabado** y **Lugar de origen = España**, entonces vamos a la rama izquierda.
Si **Técnica utilizada != grabado** y **Lugar de origen != España**, entonces vamos a la rama derecha.

--

Tenemos ahora que evaluar tanto la rama izquierda com la derecha de este último nodo intermedio.
Vamos a evaluar primero la **rama izquierda** (5 ejemplos de España, con 4 del pintor A y 1 del pintor B).

Para el atributo **técnica utilizada = óleo**,

- El conjunto de la izquierda tiene 3 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - ( (2/3)^2 + (1/3)^2 ) = 1 - (4/9 + 1/9) = 0.4444$.
- El conjunto de la derecha tiene 2 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (2/2)^2 = 0$.
- El indice de Gini ponderado de la partición es $G_{partición} = (3/5) * 0.4444 + (2/5) * 0 = 0.2667$ -> **G_ponderado(técnica=óleo) = 0.2667**.

Para el atributo **estilo de la pintura = clásico**,

- El conjunto de la izquierda tiene 3 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (3/3)^2 - (0/3)^2 = 0$.
- El conjunto de la derecha tiene 2 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - ( (1/2)^2 + (1/2)^2 ) = 0.5$.
- El indice de Gini ponderado de la partición es $G_{partición} = (3/5) * 0 + (2/5) * 0.5 = 0.2$ -> **G_ponderado(estilo=clásico) = 0.2**.

Para el atributo **tiene marco = sí**,

- El conjunto de la izquierda tiene 3 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - (2/3)^2 - (1/3)^2 = 0.4444$.
- El conjunto de la derecha tiene 2 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - (2/2)^2 = 0$.
- El indice de Gini ponderado de la partición es $G_{partición} = (3/5) * 0.4444 + (2/5) * 0 = 0.2667$ -> **G_ponderado(tiene marco=sí) = 0.2667**.

La rama izquierda se divide finalmente por el atributo **estilo de la pintura = clásico**, obteniendo 0.2 como valor de Gini ponderado. Dividiendo el conjunto de entrenamiento en dos ramas según el estilo de la pintura, obtenemos:

- Rama izquierda: 3 ejemplos de estilo clásico, todos del pintor A (nodo hoja, indice de Gini = 0).
- Rama derecha: 2 ejemplos de estilo moderno, uno del pintor A y uno del pintor B. Al dividir este último nodo intermedio por el atributo **tiene marco = sí**, obtenemos 0 como valor de Gini ponderado. Las dos ramas resultantes son nodos hoja, ya que todos los ejemplos de cada rama pertenecen a la misma clase (pintor A o pintor B, indice de Gini = 0).

La secuencia lógica de decisiones se actualiza como sigue:

- Si **Técnica utilizada = grabado**, entonces **Autor = pintor B**.
- Si **Técnica utilizada != grabado** y **Lugar de origen = España** y **Estilo de la pintura = clásico**, entonces **Autor = pintor A**.
- Si **Técnica utilizada != grabado** y **Lugar de origen = España** y **Estilo de la pintura != clásico** vamos a la rama derecha.

--

Vemos ahora la **rama derecha** (5 ejemplos de Portugal y Francia, con 1 del pintor A y 4 del pintor B).

Para el atributo **técnica utilizada = óleo**,

- El conjunto de la izquierda tiene 2 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - ( (0/2)^2 + (2/2)^2 ) = 0$.
- El conjunto de la derecha tiene 3 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - ( (0/3)^2 + (3/3)^2 ) = 0$.
- El indice de Gini ponderado de la partición es $G_{partición} = (2/5) * 0 + (3/5) * 0 = 0$ -> **G_ponderado(técnica=óleo) = 0**.

Para el atributo **estilo de la pintura = clásico**,

- El conjunto de la izquierda tiene 1 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - ( (0/1)^2 + (1/1)^2 ) = 0$.
- El conjunto de la derecha tiene 4 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - ( (1/4)^2 + (3/4)^2 ) = 0.375$.
- El indice de Gini ponderado de la partición es $G_{partición} = (1/5) * 0 + (4/5) * 0.375 = 0.3$ -> **G_ponderado(estilo=clásico) = 0.3**.

Para el atributo **tiene marco = sí**,

- El conjunto de la izquierda tiene 2 ejemplos, su indice de Gini es $G(D_{izquierda}) = 1 - ( (0/2)^2 + (2/2)^2 ) = 0$.
- El conjunto de la derecha tiene 3 ejemplos, su indice de Gini es $G(D_{derecha}) = 1 - ( (1/3)^2 + (2/3)^2 ) = 0.4444$.
- El indice de Gini ponderado de la partición es $G_{partición} = (2/5) * 0 + (3/5) * 0.4444 = 0.2667$ -> **G_ponderado(tiene marco=sí) = 0.2667**.

La rama derecha se divide finalmente por el atributo **técnica utilizada = óleo**, obteniendo 0 como valor de Gini ponderado. Las dos ramas resultantes son nodos hoja, ya que todos los ejemplos de cada rama pertenecen a la misma clase (pintor A o pintor B, indice de Gini = 0).

La secuencia lógica de decisiones se actualiza como sigue:

- Si **Técnica utilizada = grabado**, entonces **Autor = pintor B**.
- Si **Técnica utilizada != grabado** y **Lugar de origen = España** y **Estilo de la pintura = clásico**, entonces **Autor = pintor A**.
- Si **Técnica utilizada != grabado** y **Lugar de origen = España** y **Estilo de la pintura != clásico**, vamos a la rama derecha.
- Si **Técnica utilizada != grabado** y **Lugar de origen != España** y **Técnica utilizada = óleo**, entonces **Autor = pintor B**.
- Si **Técnica utilizada != grabado** y **Lugar de origen != España** y **Técnica utilizada != óleo**, entonces **Autor = pintor B**.

<div class="summary">

El árbol de decisión CART definitivo se traduce en el siguiente conjunto de reglas lógicas:

**Secuencia de decisión completa:**

- Si **Técnica utilizada = grabado**, entonces Autor = **pintor B**.
- Si **Técnica utilizada $\neq$ grabado** y **Lugar de origen = España**:
  - Si **Estilo de la pintura = clásico**, entonces Autor = **pintor A**.
  - Si **Estilo de la pintura $\neq$ clásico** (moderno) y **Tiene marco = sí**, entonces Autor = **pintor B**.
  - Si **Estilo de la pintura $\neq$ clásico** (moderno) y **Tiene marco = no**, entonces Autor = **pintor A**.
- Si **Técnica utilizada $\neq$ grabado** y **Lugar de origen $\neq$ España** (Portugal o Francia):
  - Si **Técnica utilizada = acuarela**, entonces Autor = **pintor B**.
  - Si **Técnica utilizada = óleo** y **Tiene marco = sí**, entonces Autor = **pintor B**.
  - Si **Técnica utilizada = óleo** y **Tiene marco = no**, entonces Autor = **pintor A**.

Este conjunto de reglas clasifica de forma 100% pura todos y cada uno de los cuadros de la tabla de entrenamiento original. Con este árbol ya construido, estarías listo para afrontar el siguiente paso del examen: aplicarlo sobre la tabla del conjunto de prueba para predecir a sus autores y construir la matriz de confusión.

</div>

2.  Construir la matriz de confusión que se tendría al usar ese modelo para clasificar los ejemplos del siguiente conjunto de prueba:

| Técnica utilizada | Lugar de origen | Estilo de la pintura | Tiene marco | Autor    |
| :---------------- | :-------------- | :------------------- | :---------- | :------- |
| grabado           | España          | moderno              | sí          | pintor A |
| óleo              | Portugal        | moderno              | no          | pintor A |
| óleo              | Francia         | moderno              | sí          | pintor B |
| óleo              | España          | moderno              | no          | pintor A |
| acuarela          | España          | clásico              | no          | pintor A |
| acuarela          | Francia         | clásico              | sí          | pintor B |
| acuarela          | España          | moderno              | sí          | pintor A |
| acuarela          | Portugal        | clásico              | sí          | pintor B |

Clasificando cada ejemplo del conjunto de prueba con el árbol de decisión construido. Consideramos pintor A como positivo y pintor B como negativo, obtenemos las siguientes predicciones:
Ejemplo 1: Técnica = grabado -> Autor predicho = pintor B (real = pintor A) -> Falso negativo.
Ejemplo 2: Técnico != grabado y Lugar != España y Técnica = óleo y marco = no -> Autor predicho = pintor A (real = pintor A) -> Verdadero positivo.
Ejemplo 3: Técnico != grabado y Lugar != España y Técnica = óleo y marco = sí -> Autor predicho = pintor B (real = pintor B) -> Verdadero negativo.
Ejemplo 4: Técnico != grabado y Lugar = España y Estilo != clásico y marco = no -> Autor predicho = pintor A (real = pintor A) -> Verdadero positivo.
Ejemplo 5: Técnico != grabado y Lugar = España y Estilo = clásico -> Autor predicho = pintor A (real = pintor A) -> Verdadero positivo.
Ejemplo 6: Técnico != grabado y Lugar != España y Técnica = acuarela -> Autor predicho = pintor B (real = pintor B) -> Verdadero negativo.
Ejemplo 7: Técnico != grabado y Lugar = España y Estilo != clásico y marco = sí -> Autor predicho = pintor B (real = pintor A) -> Falso negativo.
Ejemplo 8: Técnico != grabado y Lugar != España y Técnica = acuarela -> Autor predicho = pintor B (real = pintor B) -> Verdadero negativo.

La matriz de confusión resultante es la siguiente:

|                | Predicho: pintor A | Predicho: pintor B |
| -------------- | ------------------ | ------------------ |
| Real: pintor A | 3                  | 2                  |
| Real: pintor B | 0                  | 3                  |

3.  Derivar a partir de esa matriz de confusión todas las medidas posibles de rendimiento del modelo.

- **Exactitud (Accuracy)**: La proporción de predicciones correctas sobre el total de predicciones.  
  \[
  \text{Exactitud} = \frac{TP + TN}{TP + TN + FP + FN} = \frac{3 + 3}{3 + 3 + 2 + 0} = \frac{6}{8} = 0.75
  \]
- **Precisión (Precision)**: La proporción de verdaderos positivos sobre el total de predicciones positivas.  
  \[
  \text{Precisión} = \frac{TP}{TP + FP} = \frac{3}{3 + 2} = \frac{3}{5} = 0.6
  \]
- **Sensibilidad (Recall o Tasa de verdaderos positivos)**: La proporción de verdaderos positivos sobre el total de casos reales positivos.  
  \[
  \text{Sensibilidad} = \frac{TP}{TP + FN} = \frac{3}{3 + 2} = \frac{3}{5} = 0.6
  \]
- **Especificidad (Specificity o Tasa de verdaderos negativos)**: La proporción de verdaderos negativos sobre el total de casos reales negativos.  
  \[
  \text{Especificidad} = \frac{TN}{TN + FP} = \frac{3}{3 + 0} = \frac{3}{3} = 1.0
  \]
- **Valor predictivo negativo (NPV)**: La proporción de verdaderos negativos sobre el total de predicciones negativas.  
  \[
  \text{NPV} = \frac{TN}{TN + FN} = \frac{3}{3 + 2} = \frac{3}{5} = 0.6
  \]
- **Tasa de falsos positivos (FPR)**: La proporción de falsos positivos sobre el total de casos reales negativos.  
  \[
  \text{FPR} = \frac{FP}{FP + TN} = \frac{0}{0 + 3} = 0
  \]
- **Tasa de falsos negativos (FNR)**: La proporción de falsos negativos sobre el total de casos reales positivos.  
  \[
  \text{FNR} = \frac{FN}{FN + TP} = \frac{2}{2 + 3} = \frac{2}{5} = 0.4
  \]
- **F1 Score**: La media armónica de la precisión y la sensibilidad.  
  \[
  F1 = 2 \cdot \frac{\text{Precisión} \cdot \text{Sensibilidad}}{\text{Precisión} + \text{Sensibilidad}} = 2 \cdot \frac{0.6 \cdot 0.6}{0.6 + 0.6} = 0.6
  \]

</div>

<div class="highlight-exercise">

**Ejercicio 10**

Una tienda de helados ha recopilado durante una serie de días la siguiente información acerca de la cantidad (en mililitros) de helado vendida por persona:

| Precio por litro | Ingreso semanal medio de los clientes | Temperatura media | Helado vendido por persona |
| :--------------: | :-----------------------------------: | :---------------: | :------------------------: |
|      0.585       |                  84                   |        19         |           182.6            |
|      0.585       |                  86                   |        16         |           161.8            |
|      0.617       |                  85                   |         7         |           150.9            |
|      0.607       |                  87                   |         4         |           145.3            |
|      0.585       |                  94                   |         0         |           134.4            |
|      0.602       |                  92                   |        \-3        |           154.3            |
|      0.596       |                  95                   |        \-2        |           146.2            |
|      0.560       |                  96                   |         1         |           169.9            |
|      0.560       |                  94                   |         5         |           177.9            |
|      0.560       |                  96                   |        11         |           196.8            |

Se pide:

1.  Construir mediante el algoritmo CART un árbol de decisión que prediga la cantidad de helado vendida por persona en función del valor de los atributos.

Tomamos el primer atributo, **Precio por litro**, y lo ordenamos de menor a mayor: 0.560, 0.560, 0.560, 0.585, 0.585, 0.585, 0.596, 0.602, 0.607, 0.617. Los posibles umbrales de división son los puntos medios entre cada par de valores consecutivos, eliminado los duplicados:

- Umbral 1: (0.560 + 0.585) / 2 = 0.5725
- Umbral 2: (0.585 + 0.596) / 2 = 0.5905
- Umbral 3: (0.596 + 0.602) / 2 = 0.599
- Umbral 4: (0.602 + 0.607) / 2 = 0.6045
- Umbral 5: (0.607 + 0.617) / 2 = 0.612

Simulamos la división de los datos en dos ramas para cada umbral y calculamos la varianza promedio de cada partición. El umbral que minimice la varianza promedio será el elegido para dividir el nodo.

Rercoradmos la fórmula de la varianza promedio ponderada:

$$ Varianza*promedio = \frac{n*{izquierda}}{n*{total}} * Varianza*{izquierda} + \frac{n*{derecha}}{n\_{total}} \_ Varianza\_{derecha}$$

- Umbral 1 (0.5725):
  - Rama izquierda: [0.560, 0.560, 0.560] -> helado vendido por persona -> [169.9, 177.9, 196.8] -> media = 181.53 -> $Var = \frac{1}{3} * ((169.9 - 181.53)^2 + (177.9 - 181.53)^2 + (196.8 - 181.53)^2) = 127.2$
  - Rama derecha: [0.585, 0.585, 0.585, 0.596, 0.602, 0.607, 0.617] -> helado vendido por persona -> [182.6, 161.8, 150.9, 145.3, 134.4, 154.3, 146.2] -> media = 153.64 -> $Var = \frac{1}{7} * ((182.6 - 153.64)^2 + (161.8 - 153.64)^2 + (150.9 - 153.64)^2 + (145.3 - 153.64)^2 + (134.4 - 153.64)^2 + (154.3 - 153.64)^2 + (146.2 - 153.64)^2) = 201.19$
  - $Varianza_promedio = (3/10)*127.2 + (7/10)*201.19 = 178.99$

- Umbral 2 (0.5905):
  - Rama izquierda: [0.560, 0.560, 0.560, 0.585, 0.585, 0.585] -> helado vendido por persona -> [169.9, 177.9, 196.8, 182.6, 161.8, 134.4] -> media = 170.57 -> $Var = \frac{1}{6} * ((169.9 - 170.57)^2 + (177.9 - 170.57)^2 + (196.8 - 170.57)^2 + (182.6 - 170.57)^2 + (161.8 - 170.57)^2 + (134.4 - 170.57)^2) = 378.68$
  - Rama derecha: [0.596, 0.602, 0.607, 0.617] -> helado vendido por persona -> [146.2, 154.3, 145.3, 150.9] -> media = 149.18 -> $Var = \frac{1}{4} * ((146.2 - 149.18)^2 + (154.3 - 149.18)^2 + (145.3 - 149.18)^2 + (150.9 - 149.18)^2) = 13.92$
  - $Varianza_promedio = (6/10)*378.68 + (4/10)*13.92 = 232.52$

- Umbral 3 (0.599):
  - Rama izquierda: [0.560, 0.560, 0.560, 0.585, 0.585, 0.585, 0.596] -> helado vendido por persona -> [169.9, 177.9, 196.8, 182.6, 161.8, 134.4, 146.2] -> media = 164.37 -> $Var = \frac{1}{7} * ((169.9 - 164.37)^2 + (177.9 - 164.37)^2 + (196.8 - 164.37)^2 + (182.6 - 164.37)^2 + (161.8 - 164.37)^2 + (134.4 - 164.37)^2 + (146.2 - 164.37)^2) = 295.19$
  - Rama derecha: [0.602, 0.607, 0.617] -> helado vendido por persona -> [154.3, 145.3, 150.9] -> media = 150.17 -> $Var = \frac{1}{3} * ((154.3 - 150.17)^2 + (145.3 - 150.17)^2 + (150.9 - 150.17)^2) = 13$.92$
  - $Varianza_promedio = (7/10)*295.19 + (3/10)*13.92 = 210.88$

- Umbral 4 (0.6045):
  - Rama izquierda: [0.560, 0.560, 0.560, 0.585, 0.585, 0.585, 0.596, 0.602] -> helado vendido por persona -> [169.9, 177.9, 196.8, 182.6, 161.8, 134.4, 146.2, 154.3] -> media = 163.99 -> $Var = \frac{1}{8} * ((169.9 - 163.99)^2 + (177.9 - 163.99)^2 + (196.8 - 163.99)^2 + (182.6 - 163.99)^2 + (161.8 - 163.99)^2 + (134.4 - 163.99)^2 + (146.2 - 163.99)^2 + (154.3 - 163.99)^2) = 295$.19$
  - Rama derecha: [0.607, 0.617] -> helado vendido por persona -> [145.3, 150.9] -> media = 148.1 -> $Var = \frac{1}{2} * ((145.3 - 148.1)^2 + (150.9 - 148.1)^2) = 13$.92$
  - $Varianza_promedio = (8/10)*295.19 + (2/10)*13.92 = 238.54$

- Umbral 5 (0.612):
  - Rama izquierda: [0.560, 0.560, 0.560, 0.585, 0.585, 0.585, 0.596, 0.602, 0.607] -> helado vendido por persona -> [169.9, 177.9, 196.8, 182.6, 161.8, 134.4, 146.2, 154.3, 145.3] -> media = 163.64 -> $Var = \frac{1}{9} * ((169.9 - 163.64)^2 + (177.9 - 163.64)^2 + (196.8 - 163.64)^2 + (182.6 - 163.64)^2 + (161.8 - 163.64)^2 + (134.4 - 163.64)^2 + (146.2 - 163.64)^2 + (154.3 - 163.64)^2 + (145.3 - 163.64)^2) = 295$.19$
  - Rama derecha: [0.617] -> helado vendido por persona -> [150.9] -> media = 150.9 -> $Var = \frac{1}{1} * ((150.9 - 150.9)^2) = 0$
  - $Varianza_promedio = (9/10)*295.19 + (1/10)*0 = 265.67$

Vamos por el segundo atributo, **Ingreso semanal medio de los clientes**, y lo ordenamos de menor a mayor: 84, 85, 86, 87, 92, 94, 94, 95, 96, 96. Los posibles umbrales de división son los puntos medios entre cada par de valores consecutivos, eliminado los duplicados:

- Umbral 1: (84 + 85) / 2 = 84.5
- Umbral 2: (85 + 86) / 2 = 85.5
- Umbral 3: (86 + 87) / 2 = 86.5
- Umbral 4: (87 + 92) / 2 = 89.5
- Umbral 5: (92 + 94) / 2 = 93
- Umbral 6: (94 + 95) / 2 = 94.5
- Umbral 7: (95 + 96) / 2 = 95.5

<div class="summary">

Una vez terminado ese atributo, empezaría con el siguiente (Ingreso semanal medio de los clientes) repitiendo cálculos. Hasta tener evaluados todos los atributos, me quedaría con aquel par atributo-umbral que me minimice la varianza promedio y así tendía el primer nodo. cierto?"

¡Exactamente! Lo has entendido a la perfección. Ese es el funcionamiento fundamental del algoritmo CART.

Una vez tienes a los tres "campeones" (uno por cada atributo), **los enfrentas entre sí**. Aquel par atributo-umbral que tenga la **varianza promedio más pequeña de todas** es el ganador absoluto y se convierte en el **primer nodo (la raíz)** de tu árbol.

Y a partir de ahí, la lógica es recursiva: los datos se dividirán en la rama izquierda y en la rama derecha según ese umbral ganador. Para decidir cuál es el siguiente nodo en el nivel 2 de la rama izquierda, cogerías solo los días que hayan caído ahí y ¡volverías a repetir exactamente el mismo proceso evaluando los umbrales de todos los atributos!

Tienes la mecánica de construcción del árbol de regresión completamente asimilada.¡Exactamente! Lo has entendido a la perfección. Ese es el funcionamiento central y la filosofía de "fuerza bruta" matemática del algoritmo CART.

Como el algoritmo no tiene forma de intuir a priori qué columna es la mejor para predecir las ventas de helado, realiza una búsqueda global. El proceso completo para encontrar el nodo raíz en tu **Ejercicio 10** ```` sería exactamente el que describes:

1. **Evaluar el Atributo 1 (Precio por litro):** Ya calculamos que su mejor umbral es `Precio <= 0.5725` porque consigue la varianza mínima para esa columna (**178.99**).
2. **Evaluar el Atributo 2 (Ingreso semanal medio):** Ordenarías sus valores (84, 85, 86, 87, 92, 94, 95, 96), calcularías todos sus puntos medios y repetirías la fórmula de la varianza promedio para cada partición. Te anotarías cuál es su mejor corte y su error asociado.
3. **Evaluar el Atributo 3 (Temperatura media):** Ordenarías las temperaturas (-3, -2, 0, 1, 4, 5, 7, 11, 16, 19), sacarías sus umbrales candidatos y calcularías la varianza promedio para cada uno, anotando de nuevo a su campeón.

Una vez tienes a los tres "campeones" (uno por cada atributo), **los enfrentas entre sí**. Aquel par atributo-umbral que haya conseguido **la varianza promedio más pequeña de absolutamente todos los evaluados** es el ganador global. Ese atributo será el que pondrás en la **raíz de tu árbol** ````.

_(Como te adelanté en un mensaje anterior, si hicieras los cálculos del Ingreso y de la Temperatura, verías que ninguno logra un error menor que 178.99, por lo que el `Precio <= 0.5725` sería el ganador de este torneo final)_.

Y el paso siguiente es pura lógica recursiva: ese nodo dividirá tus 10 días de entrenamiento en dos subgrupos (la rama izquierda y la derecha). Para seguir haciendo crecer el árbol, cogerías únicamente los datos que han caído en una rama y **volverías a empezar el mismo proceso desde cero** para encontrar el mejor corte en ese subgrupo, y así sucesivamente hasta que el ejercicio te indique que pares (por ejemplo, al llegar a un límite de profundidad o cuando los nodos sean puros).

¡Tienes la mecánica de construcción de los árboles de regresión completamente dominada!

</div>

Por supuesto. Asumiendo que te refieres a completar el árbol de regresión del **Ejercicio 10** sobre las ventas de helado en el que estábamos trabajando, he calculado recursivamente todos los cortes hasta llegar al final.

Antes de darte las reglas, es vital que tengas en cuenta un **aviso importante para el examen:** Como el enunciado del Ejercicio 10 `` no establece ningún "criterio de parada" (por ejemplo, una profundidad máxima, como sí lo hace el Ej. 8), la teoría dicta que CART no se detiene hasta que la varianza de todos los nodos terminales sea exactamente 0. Al tener variables numéricas continuas sin ejemplos repetidos idénticos, el árbol aísla cada uno de los 10 días de entrenamiento en su propia "hoja". Esto crea un árbol muy profundo (sobreajustado), cuyo cálculo completo a mano en un examen sería excesivamente largo. Lo habitual es que el profesor te pida desarrollarlo solo hasta el nivel 2.

Dicho esto, si el ordenador (o tú, con mucha paciencia) realiza todas las iteraciones evaluando el error mínimo en cada subgrupo, **el conjunto de reglas de decisión completo y exacto** queda así:

- Si **Precio por litro $\le$ 0.5725**:
  - Si **Temperatura media $\le$ 8.0**:
    - Si **Ingreso semanal $\le$ 95.0**, entonces **Helado = 177.9** ml.
    - Si **Ingreso semanal $>$ 95.0**, entonces **Helado = 169.9** ml.
  - Si **Temperatura media $>$ 8.0**, entonces **Helado = 196.8** ml.

- Si **Precio por litro $>$ 0.5725**:
  - Si **Ingreso semanal $\le$ 84.5**, entonces **Helado = 182.6** ml.
  - Si **Ingreso semanal $>$ 84.5**:
    - Si **Ingreso semanal $\le$ 93.0**:
      - Si **Precio por litro $\le$ 0.5935**, entonces **Helado = 161.8** ml.
      - Si **Precio por litro $>$ 0.5935**:
        - Si **Precio por litro $\le$ 0.6045**, entonces **Helado = 154.3** ml.
        - Si **Precio por litro $>$ 0.6045**:
          - Si **Precio por litro $\le$ 0.6120**, entonces **Helado = 145.3** ml.
          - Si **Precio por litro $>$ 0.6120**, entonces **Helado = 150.9** ml.
    - Si **Ingreso semanal $>$ 93.0**:
      - Si **Precio por litro $\le$ 0.5905**, entonces **Helado = 134.4** ml.
      - Si **Precio por litro $>$ 0.5905**, entonces **Helado = 146.2** ml.

Con este árbol ya totalmente resuelto, estarías listo para afrontar el **apartado 2** del ejercicio ``. Consistiría en coger los 5 días nuevos del conjunto de prueba, pasarlos por estas reglas lógicas para ver qué predicción de mililitros arroja el árbol, y finalmente enfrentarlas a los valores reales usando las fórmulas matemáticas del _error absoluto medio_, el _error cuadrático medio_ y el _coeficiente $R^2$_.

2.  Determinar el error absoluto medio, el error cuadrático medio y el coeficiente de determinación del modelo sobre el siguiente conjunto de prueba:

| Precio por litro | Ingreso semanal medio de los clientes | Temperatura media | Helado vendido por persona |
| :--------------: | :-----------------------------------: | :---------------: | :------------------------: |
|      0.571       |                  78                   |         5         |           182.6            |
|      0.596       |                  79                   |        13         |           177.0            |
|      0.585       |                  81                   |        17         |           186.0            |
|      0.592       |                  80                   |        20         |           201.1            |
|      0.575       |                  76                   |        21         |           192.1            |

Recordemos las fórmulas de las métricas de error:

- **Error absoluto medio (MAE)**:
  $$
  MAE = \frac{1}{n} \sum_{i=1}^{n} |y_i - \hat{y}_i|
  $$
- **Error cuadrático medio (MSE)**:
  $$
  MSE = \frac{1}{n} \sum_{i=1}^{n} (y_i - \hat{y}_i)^2
  $$
- **Coeficiente de determinación ($R^2$)**:
  $$
  R^2 = 1 - \frac{\sum_{i=1}^{n} (y_i - \hat{y}_i)^2}{\sum_{i=1}^{n} (y_i - \bar{y})^2}
  $$
  </div>
