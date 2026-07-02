<link rel="stylesheet" href="../css/estilo.css">

# Planificación automática (Teoría)

<div class="highlight-theory">

## Introducción

La planificación automática es un área de la inteligencia artificial que se ocupa de la generación de planes o secuencias de acciones para alcanzar objetivos específicos. En este contexto, un plan es una serie de pasos que un agente puede seguir para lograr un objetivo dado, considerando las restricciones y el entorno en el que opera.

Existen tres tipos principales de planificadores:

- 1. **Planificadores de dominio específico**: Estos planificadores están diseñados para resolver problemas específicos en un dominio particular, como la planificación de rutas para vehículos o la programación de tareas en una fábrica.
- 2. **Planificadores independientes del dominio**: Estos planificadores son más flexibles y pueden aplicarse a una amplia variedad de problemas, aunque pueden ser menos eficientes que los planificadores de dominio específico. **Este tipo es el que estudiaremos en este curso**.
- 3. **Planificadores configurables**: Estos planificadores permiten a los usuarios configurar ciertos aspectos del proceso de planificación, como la heurística utilizada o las restricciones aplicadas.

</div>

<div class="summary">

## Hilo argumental del documento

El hilo argumental del documento se centra en la **planificación automática** dentro de la inteligencia artificial, estructurándose desde sus conceptos fundamentales hasta los métodos algorítmicos para su resolución:

- **Fundamentos y Clasificación**: Define la planificación como el proceso de seleccionar y organizar acciones para alcanzar un objetivo. Clasifica los planificadores en específicos de un dominio, independientes del dominio y configurables.
- **Planificación Clásica**: Se enfoca en este modelo simplificado, estableciendo ocho restricciones básicas (sistema finito, determinista, estático, totalmente observable, etc.) y definiendo el problema como un sistema de transición de estados.
- **Representación de Problemas**:
  - Introduce la **representación factorizada** para descomponer estados en componentes simples.
  - Explica el formalismo **STRIPS**, que utiliza hechos (proposiciones), precondiciones y listas de borrado/adición para definir acciones.
  - Menciona el lenguaje **PDDL** como el estándar práctico para implementar STRIPS.
- **Resolución mediante Búsqueda**: Propone resolver los problemas mediante la búsqueda de caminos en un grafo de estados. Detalla algoritmos como:
  - Búsqueda en anchura y profundidad.
  - Algoritmo de **Dijkstra** para encontrar planes óptimos basándose en costes.
  - Algoritmo **A**\*, que utiliza funciones heurísticas para mejorar la eficiencia.
- **Heurísticas Independientes del Dominio**: Ante el crecimiento exponencial de los estados, el documento explica cómo generar heurísticas mediante la **relajación del borrado** (ignorar los hechos que dejan de cumplirse al actuar).
- **Cálculo de Heurísticas Específicas**: Describe métodos para aproximar el coste del plan relajado óptimo ($h^+$), destacando:
  - **$h^{max}$**: Estima el coste basándose en el objetivo más costoso (puede ser muy optimista).
  - **$h^{add}$**: Suma los costes de todos los objetivos por separado (puede ser muy pesimista y no es admisible).

A lo largo del texto, se utiliza el ejemplo del **"mundo de los bloques"** y el **transporte de paquetes** para ilustrar de forma práctica cada uno de estos conceptos teóricos.

</div>

## Planificación clásica

Son aquellos que asumene estas 8 condiciones:

1. El mundo es finito: el número de estados posibles y acciones es limitado.
2. El mundo es completamente observable: el agente tiene acceso a toda la información relevante sobre el estado del mundo.
3. El mundo es determinista: las acciones tienen resultados predecibles y no hay incertidumbre en los efectos de las acciones.
4. El mundo es estático: el entorno no cambia mientras el agente está planificando.
5. El mundo es discreto: el estado del mundo y las acciones disponibles son finitos y discretos.
6. El agente es único: no hay otros agentes que interactúen con el agente planificador.
7. El objetivo es alcanzable: existe al menos una secuencia de acciones que puede llevar al agente desde el estado inicial hasta el estado objetivo.
8. El agente tiene un modelo completo del mundo: el agente conoce todas las acciones disponibles, sus efectos y las condiciones bajo las cuales se pueden ejecutar.

En este marco un problema de planificación se puede representar como una tupla (S, A, s_i, S_g) donde:

- S es el conjunto de estados posibles del mundo.
- A es el conjunto de acciones disponibles para el agente.
- s_i es el estado inicial del mundo.
- S_g es el conjunto de estados objetivo que el agente desea alcanzar.

<div class="highlight-theory">

## Formalismo STRIPS

En este formalismo, un problema de planificación se representa mediante:

- Un conjunto de **predicados** que describen las propiedades del mundo.
- Un conjunto de **acciones** que el agente puede ejecutar, cada una con precondiciones y efectos.
- Un estado inicial que describe la situación actual del mundo.
- Un objetivo que especifica lo que el agente desea lograr.

El **dominio del problema** se define mediante un conjunto de predicados y acciones.
**Los estados** se representan mediante un conjunto de hechos, que son instancias de los predicados.
**Las acciones** se definen mediante precondiciones (lo que debe ser cierto para que la acción pueda ejecutarse) y efectos (lo que cambia en el mundo después de ejecutar la acción) y será aplicable si sus precondiciones son satisfechas en el estado actual. El resultado de aplicar una acción a un estado es un nuevo estado donde se han eliminado todos los hechos de la lista de borrado y se han añadido todos los hechos de la lista de adición.
Se asume la **hipótesis del mundo cerrado**, lo que significa que cualquier hecho que no se mencione explícitamente en el estado actual se considera falso.
**Los estados objetivos** son aquellos que contienen todos y cada uno de los hechos especificados en el objetivo.
Un **plan solución** es una secuencia de acciones que, cuando se ejecuta desde el estado inicial, conduce a un estado objetivo.

</div>

<div class="summary">

## El mundo de los bloques

Si no se utilizan variables genéricas, el formalismo exige definir una regla de acción explícita para cada posible combinación física. El cálculo exacto de estas **$2n^2$ acciones** se obtiene sumando los dos grandes grupos de movimientos que puede hacer el brazo robótico:

- **Interacciones directas con la mesa (1 solo bloque implicado):** Las acciones como `AGARRAR(b)` (coger desde la mesa) y `BAJAR(b)` (dejar sobre la mesa) operan individualmente. Para $n$ bloques, se necesitan definir $n$ acciones explícitas para agarrar y otras $n$ acciones para bajar, sumando **$2n$ acciones**.
- **Interacciones entre bloques (2 bloques implicados):** Las acciones como `DESAPILAR(b1, b2)` y `APILAR(b1, b2)` requieren relacionar un bloque superior y un bloque inferior. Dado que cualquier bloque puede interactuar con cualquiera de los demás (excepto consigo mismo), existen $n(n-1)$ combinaciones posibles de pares de bloques. Como se necesita definir una regla por cada par para apilar y otra regla distinta por cada par para desapilar, el sistema requiere $2 \cdot n(n-1) = \mathbf{2n^2 - 2n}$ **acciones**.

Al sumar ambos grupos algebraicamente ($2n + 2n^2 - 2n$), el número total de reglas necesarias para definir el dominio asciende a exactamente **$2n^2$ acciones**.

Para evitar tener que escribir manualmente esta enorme explosión combinatoria al definir problemas con muchos bloques, la solución práctica consiste en utilizar **esquemas de acciones**, los cuales emplean variables genéricas (como $b_1$ y $b_2$) en lugar de identificar bloques concretos, permitiendo generalizar el dominio drásticamente.

</div>

### PDDL (Planning Domain Definition Language)

Es un lenguaje estándar para describir dominios de planificación y problemas de planificación. Fue desarrollado para facilitar la comunicación entre diferentes planificadores y para proporcionar una forma estructurada de representar problemas de planificación. Con el tiempo se ha ampliando con extensiones que permiten condiciones negadas y cuantificadas, efectos condicionales, variables numéricas, etc.

## Resolución de problemas de planificación

<div class="highlight-theory">

- `Búsqueda en el espacio de estados del problema`: consiste en aplicar un algoritmo de búsqueda en el grafo dirigido cuyos vértices son los estados del mundo y cuyas aristas conectan estados para los que existe una acción que los transforma de uno a otro. El objetivo es encontrar un camino desde el estado inicial hasta un estado objetivo.

### Algoritmos de búsqueda de caminos en grafos

El esquema general de estos algoritmos es el siguiente:

- disponemos de un conjunto de nodos abiertos (inicialmente solo el nodo raíz) y un conjunto de nodos cerrados (inicialmente vacío).
- mientras el conjunto de nodos abiertos no esté vacío:
  - seleccionamos un nodo n del conjunto de nodos abiertos.
  - si n es un nodo objetivo, entonces hemos encontrado una solución y podemos reconstruir el camino desde el nodo raíz hasta n.
  - si n no es un nodo objetivo, entonces expandimos n generando sus nodos hijos (aplicando las acciones disponibles) y los añadimos al conjunto de nodos abiertos, siempre y cuando no estén ya en el conjunto de nodos cerrados.
  - añadimos n al conjunto de nodos cerrados para evitar volver a expandirlo en el futuro.

Los algoritmos de búsqueda se diferencian en la forma en que seleccionan el nodo n del conjunto de nodos abiertos. Algunos ejemplos de algoritmos de búsqueda son:

- **Búsqueda en anchura (Breadth-First Search)**: selecciona el nodo más antiguo del conjunto de nodos abiertos (el que se añadió primero). Este algoritmo garantiza encontrar la solución óptima (con el menor número de pasos) si el costo de cada acción es el mismo.
- **Búsqueda en profundidad (Depth-First Search)**: selecciona el nodo más reciente del conjunto de nodos abiertos (el que se añadió último). Este algoritmo puede ser más rápido que la búsqueda en anchura, pero no garantiza encontrar la solución óptima y puede quedarse atrapado en ciclos si el grafo tiene ciclos.

**Algoritmo de busqueda en profundidad/anchura:**

- Entrada: Problema de palanificación P=(H, A, s_i, S_g)
- Salida: Plan solución o fallo

- 1. Inicializar el conjunto de nodos abiertos con el nodo raíz (s_i) y el conjunto de nodos cerrados vacío.
- 2. Mientras el conjunto de nodos abiertos no esté vacío, hacer:
  - a. Busqueda en profundidad: Seleccionar el nodo _s_ más reciente del conjunto de nodos abiertos.
  - b. Busqueda en anchura: Seleccionar el nodo _s_ más antiguo del conjunto de nodos abiertos.
  - c. Insertar _s_ en el conjunto de nodos cerrados.
  - d. Si G está contenido o es igual a _s_, entonces reconstruir el camino desde el nodo raíz hasta _s_ y **devolverlo como plan solución**.
  - e. Para cada acción _a_ en A que sea aplicable a _s_, hacer:
    - generar el nodo hijo _s'_ aplicando la acción _a_ a _s_.
    - Si _s'_ no está en el conjunto de nodos cerrados ni en el conjunto de nodos abiertos, entonces
      - Padre de _s'_ = _s_.
      - insertar _s'_ en el conjunto de nodos abiertos.

3. Devolver fallo (no se ha encontrado un plan solución).

</div>

<div class="summary">

## Algoritmo de Dijkstra

Cuando cada acción _a_ tiene un costo asociado, el **algoritmo de Dijkstra** selecciona el nodo _s_ del conjunto de nodos abiertos que tiene el costo acumulado más bajo desde el nodo raíz hasta _s_. Este algoritmo garantiza encontrar la solución óptima en términos de costo total.

El algoritmo de Dijkstra se utiliza en planificación automática para calcular un **plan óptimo**, es decir, encontrar un camino en el grafo del espacio de estados desde el nodo inicial hasta un nodo objetivo con el **menor coste posible**, `asumiendo que todas las acciones tienen un coste no negativo ($c_a$)`.

A diferencia del algoritmo $A^*$, Dijkstra no utiliza ninguna estimación heurística; simplemente explora los estados utilizando una cola de prioridades donde a cada nodo $s$ se le asocia un valor **$f(s)$** que representa el coste exacto acumulado desde el inicio.

El pseudocódigo proporcionado en la teoría estructura la ejecución de la siguiente manera:

**1. Inicialización (Líneas 1-3):**

- Se inicializa el coste de los estados: al **estado inicial $I$ se le asigna $f(I) = 0$**, y a cualquier otro estado se le asigna inicialmente un coste de $+\infty$.
- Se crea un conjunto `Cerrados` vacío (para los nodos ya expandidos) y se inserta el estado inicial $I$ en la estructura `Abiertos` (nodos descubiertos que esperan ser explorados).

**2. Búsqueda y extracción (Líneas 4-8):**

- Mientras la cola `Abiertos` no esté vacía, se extrae de ella el **estado $s$ con el menor valor $f(s)$** y se transfiere al conjunto `Cerrados`.
- Si los hechos de ese estado $s$ **satisfacen las condiciones del objetivo** ($G \subseteq S$), el algoritmo termina inmediatamente y **devuelve el camino trazado como plan solución**.

**3. Expansión y actualización (Líneas 9-17):**
Si el estado $s$ no es el objetivo, se aplica cada acción $a$ disponible para generar sus estados sucesores $s'$. Por cada sucesor $s'$, se calcula su coste acumulado ($f(s) + c_a$) y se evalúan dos situaciones:

- **Si $s'$ ya estaba en `Abiertos`:** Se comprueba si el nuevo camino hacia él es estrictamente más barato que el que ya tenía asignado ($f(s) + c_a < f(s')$). Si es así, **se actualiza su registro**, asignando a $s$ como su nuevo nodo padre y guardando el nuevo coste mínimo $f(s')$.
- **Si $s'$ es un estado completamente nuevo** (no está en `Abiertos` ni en `Cerrados`): Se designa a $s$ como su padre, se calcula su coste $f(s') = f(s) + c_a$ y **se inserta en `Abiertos`** para que el algoritmo lo explore en el futuro.

**4. Fracaso (Línea 18):**
Si el bucle principal termina porque la estructura `Abiertos` se ha vaciado por completo sin haber alcanzado nunca los hechos del objetivo $G$, el algoritmo concluye y devuelve que **no existe ningún plan solución** para el problema.

</div>

### Función heurística

Es una función que para cada estado del problema estima el coste de un plan óptimo desde ese estado hasta un estado objetivo. Las funciones heurísticas se utilizan para guiar la búsqueda hacia los estados que parecen más prometedores, lo que puede reducir significativamente el tiempo de búsqueda.

<div class="summary">

### Algoritmo A\*

El algoritmo $A^*$ es un método de búsqueda en espacios de estados que **incorpora información de una función heurística para guiar la exploración**, logrando así encontrar planes solución de forma mucho más eficiente que las búsquedas ciegas.

Su funcionamiento se basa en gestionar los estados generados pero aún no expandidos en una estructura de "nodos abiertos" mediante una **cola de prioridades**. Para decidir qué nodo explorar primero, el algoritmo evalúa cada estado $s$ calculando el valor **$f(s) = g(s) + h(s)$**, donde:

- **$g(s)$**: Es el coste mínimo exacto y ya conocido que tiene el camino desde el nodo inicial hasta el estado actual $s$.
- **$h(s)$**: Es el valor de la función heurística, el cual estima el coste mínimo necesario para transitar desde el estado actual $s$ hasta alcanzar el objetivo.

El algoritmo sigue este esquema general paso a paso:

1.  En cada iteración, extrae de la cola de nodos abiertos aquel estado $s$ que posea el **menor valor $f(s)$** y lo clasifica como cerrado.
2.  Si los hechos del estado $s$ satisfacen las condiciones del objetivo ($G \subseteq S$), el algoritmo termina y **devuelve el camino trazado como el plan solución**.
3.  Si no es el objetivo, expande el estado $s$ aplicando todas las acciones disponibles para generar los estados sucesores $s'$.
4.  Para cada sucesor $s'$, suma el coste de la acción aplicada al coste acumulado para calcular su nuevo $g(s')$. Si el estado $s'$ no había sido explorado antes, o si se ha encontrado un camino más barato hacia él, **se actualizan sus valores $g(s')$ y $f(s')$** y se inserta en la cola de nodos abiertos para ser explorado en el futuro.
5.  El ciclo se repite hasta hallar el objetivo o hasta que la cola de abiertos se vacíe (lo que indicaría que no existe plan solución).

Una de las propiedades matemáticas más importantes del algoritmo $A^*$ es que, **siempre que utilice una heurística admisible** (aquella que siempre subestima o acierta el coste real para llegar al objetivo, pero nunca lo sobreestima), garantiza ser:

- **Completo:** Si existe una solución para el problema, el algoritmo la encontrará.
- **Óptimo:** Si el problema tiene solución, el plan proporcionado tendrá matemáticamente el coste mínimo posible.

</div>

<div class="highlight-theory">

## Heurísticas independientes del dominio

Una **heurística independiente del dominio** es una función que estima el coste necesario para llegar desde un estado actual hasta el objetivo, diseñada de tal forma que **no utiliza ningún conocimiento específico ni reglas particulares del problema** que se está resolviendo. Al prescindir de información exclusiva de un dominio concreto (como reglas sobre cómo mover bloques o rutas de camiones), puede ser generada y aplicada de forma "automática" por los planificadores genéricos para guiar algoritmos de búsqueda heurística como $A^*$.

Dado que la cantidad de estados en los problemas de planificación clásica es enorme, estas heurísticas independientes se construyen habitualmente empleando la técnica de **relajación del problema**. El método más común es la **relajación del borrado**: se eliminan las restricciones del problema ignorando por completo las listas de borrado de las acciones, de forma que se asume que su ejecución solo añade hechos nuevos pero nunca invalida los que ya se cumplían.

A partir de este problema relajado, se definen las tres principales heurísticas independientes del dominio:

- **Heurística $\mathbf{h^+}$ (Plan relajado óptimo):** Estima el coste calculando el plan solución óptimo (de coste mínimo) dentro del problema relajado. Es una heurística admisible y segura, pero tiene el inconveniente de ser computacionalmente muy costosa, ya que exige generar todos los posibles planes relajados para encontrar el menor.
- **Heurística $\mathbf{h^{max}}$:** Es una aproximación más eficiente que $h^+$. Para simplificar los cálculos, asume que para lograr un conjunto de objetivos basta con **lograr únicamente el objetivo individual más costoso**, tomando el valor máximo de entre ellos. Es una heurística admisible, aunque a veces peca de ser demasiado optimista.
- **Heurística $\mathbf{h^{add}}$:** Es otra aproximación computacionalmente eficiente. Asume que los objetivos son totalmente independientes y que para lograrlos hay que **sumar el coste de alcanzar cada objetivo por separado**. Por lo general no es admisible y tiende a ser demasiado pesimista, ya que al sumar todos los costes ignora la posibilidad de que distintos objetivos compartan partes del mismo plan.

### Heurísticas optimistas vs. pesimistas

En planificación automática, clasificar una heurística como optimista o pesimista depende de si su predicción matemática estima un coste menor o mayor al coste real que verdaderamente tendrá alcanzar el objetivo:

- **Heurística optimista:** Es aquella que **subestima el coste real**, es decir, asume que llegar al objetivo será más "barato" o requerirá menos esfuerzo del que realmente hace falta.
  - Al no sobreestimar nunca los costes, estas heurísticas cumplen la propiedad de ser **admisibles**, lo que garantiza que un algoritmo como $A^*$ encontrará siempre un plan óptimo.
  - Un ejemplo de la teoría es la **heurística $\mathbf{h^{max}}$** `. Sin embargo, puede llegar a ser *demasiado optimista*: al estimar el coste basándose únicamente en el valor del objetivo individual más costoso, asume erróneamente que los demás objetivos "saldrán gratis" `. Por ejemplo, en un dominio logístico asume que llevar 100 paquetes en un camión cuesta exactamente el mismo esfuerzo que llevar solo uno, estimando un coste bajísimo.

- **Heurística pesimista:** Es aquella que **sobreestima el coste real**, es decir, calcula que llegar al objetivo será mucho más "caro" y difícil de lo que será en realidad.
  - Al superar el coste real, estas heurísticas **no son admisibles**, por lo que su uso provoca que el algoritmo de búsqueda pierda la garantía matemática de encontrar el plan más corto o barato.
  - Un ejemplo de la teoría es la **heurística $\mathbf{h^{add}}$** `. Tiende a ser *demasiado pesimista* porque asume que los objetivos son completamente independientes y que no se pueden aprovechar tareas ni subplanes compartidos `. Por ejemplo, para transportar esos mismos 100 paquetes, esta heurística suma el coste íntegro de mover el camión por cada paquete individual, asumiendo ciegamente que el vehículo tendrá que repetir el viaje completo 100 veces.

### Heurísticas admisibles

Decimos que una heurística es **admisible** cuando, para cualquier estado posible del problema, **el coste mínimo estimado para llegar desde ese estado hasta el objetivo es siempre menor o igual que el coste mínimo real**.

Es decir, una heurística es admisible si tiene un comportamiento estrictamente **optimista**, asegurando matemáticamente que **siempre subestima el coste real** (o lo acierta con exactitud), pero jamás sobreestima el esfuerzo, los pasos o el precio necesario para alcanzar la meta `. Adicionalmente, la teoría establece que cualquier heurística que sea consistente y consciente del objetivo es por definición admisible `.

Esta propiedad es el pilar fundamental para que los algoritmos de búsqueda funcionen correctamente. Si un algoritmo como el $A^*$ es guiado por una heurística admisible, se asegura que el proceso de búsqueda sea:

- **Completo:** Garantiza que, si el problema tiene solución, el algoritmo logrará encontrar un plan solución.
- **Óptimo:** Garantiza que el plan devuelto por el algoritmo tendrá estrictamente el **coste mínimo posible** de entre todos los caminos existentes.
</div>

<div class="summary">

**¿Qué significa una función heurística $h$ sea `consistente` y `consciente del objetivo`?**

- **Consciente del objetivo:** Significa que $h(s)=0$ para cualquier estado $s$ que cumpla las condiciones del objetivo (es decir, donde $G \subseteq S$). En términos prácticos, significa que la función heurística "se da cuenta" de que ya está en la meta y no estima un coste positivo para alcanzar un objetivo desde un estado que ya es objetivo.
- **Consistente:** Significa que para cualquier estado $s$, cualquier acción $a$ aplicable a ese estado, y el estado resultante $s'$ obtenido tras aplicar la acción, se cumple matemáticamente la desigualdad $h(s) \le c_a + h(s')$. Esto quiere decir que, al aplicar una acción, la estimación del coste restante para llegar al objetivo nunca disminuye en mayor medida que el coste real ($c_a$) que ha supuesto aplicar dicha acción.

Además, los apuntes confirman literalmente la regla lógica de tu premisa: "Una heurística consistente y consciente del objetivo es admisible". Y, en consecuencia, al utilizar una heurística admisible (que siempre subestima el coste real), el algoritmo A\* garantiza matemáticamente encontrar planes óptimos y ser completo.

---

**Ejemplo práctico de consistencia:**

Para entenderlo fácilmente, la regla matemática de la consistencia ($h(s) \le c_a + h(s')$) significa que la estimación de lo que te falta para llegar a la meta **nunca puede dar "saltos mágicos" o rebajas que sean mayores al coste que realmente acabas de pagar** por moverte.

Vamos a verlo con un ejemplo numérico imaginando un problema de transporte (como los de camiones que aparecen en tus ejercicios):

- **Estado actual ($s$):** Tu camión está en la ciudad A.
- **Acción ($a$):** Conducir de la ciudad A a la ciudad B.
- **Coste real de la acción ($c_a$):** Conducir ese tramo te cuesta **10** (por ejemplo, litros de gasolina).
- **Estado resultante ($s'$):** Tu camión está ahora en la ciudad B.

Supongamos que tu heurística calcula que, desde la ciudad B, todavía te faltan **20** litros para llegar al objetivo final ($h(s') = 20$).

Para que la heurística sea **consistente**, aplicamos la fórmula:
$$h(s) \le 10 + 20$$
$$h(s) \le 30$$

Esto significa que, cuando estabas en la ciudad A, tu heurística **no podía estimar un coste mayor a 30**. Veamos qué pasa en dos casos numéricos distintos:

**Caso 1: Una heurística CONSISTENTE**
Imagina que en la ciudad A tu heurística estimaba que faltaban **25** ($h(s) = 25$).

- Fórmula: $25 \le 10 + 20 \rightarrow 25 \le 30$ **(Se cumple)**.
- _¿Qué significa intuitivamente?_ Arrancaste pensando que te faltaban 25. Gastaste 10 en moverte. Ahora te faltan 20. Tu estimación total se ha reajustado un poco al alza (de 25 pasó a 30 reales estimados), pero la diferencia entre tus estimaciones (25 - 20 = 5) no es mayor que el coste real que pagaste (10). La heurística se comporta de forma lógica y estable.

**Caso 2: Una heurística INCONSISTENTE**
Imagina que en la ciudad A tu heurística estimaba que faltaban **35** ($h(s) = 35$).

- Fórmula: $35 \le 10 + 20 \rightarrow 35 \le 30$ **(Falso, se rompe la regla)**.
- _¿Qué significa intuitivamente?_ Estabas en A y la heurística decía: "¡Uf, esto está carísimo, costará 35!". Pero das un pequeño paso hacia B que solo te cuesta 10, y de repente la heurística dice: "¡Ah, desde aquí solo quedan 20!". En un solo paso, la estimación del coste total ha caído de 35 a 30. La estimación ha disminuido en 15, que es una bajada mucho mayor que el coste real que acabas de pagar (10).

Si una heurística es inconsistente (Caso 2), vuelve "loco" al algoritmo A\*, porque el algoritmo pensará que ha encontrado atajos milagrosos y tendrá que estar reevaluando constantemente estados que ya había dado por cerrados. Por eso, una heurística consistente garantiza que el algoritmo avance con paso firme.

</div>

<div class="highlight-theory">

## Algoritmo voráz: cálculo de la heurística óptima $h^+$

El **algoritmo voraz de cálculo de planes relajados** es un método diseñado para resolver una versión simplificada de un problema de planificación partiendo de un estado concreto, basándose en la premisa de que las acciones añaden nueva información al mundo pero nunca borran la anterior (relajación del borrado).

El objetivo de este algoritmo es resolver el problema simplemente añadiendo cada vez nuevos hechos que se cumplen, sin preocuparse por las posibles interacciones o conflictos entre las acciones.

El pseudocódigo y funcionamiento del algoritmo siguen estos pasos matemáticos estrictos:

1. **Inicialización:** Se define un conjunto de hechos acumulados (llamado $S^+$) que arranca conteniendo exactamente los mismos hechos que el estado inicial $s$. Además, se inicializa una secuencia vacía $a^+$ que irá guardando las acciones del plan.
2. **Bucle de búsqueda:** Mientras el objetivo del problema ($G$) no esté completamente contenido dentro del conjunto $S^+$, el algoritmo repite el siguiente proceso de selección.
3. **Selección de la acción (el paso "voraz"):** El sistema busca dentro de todas las acciones del dominio una acción $a$ que cumpla simultáneamente dos condiciones:
   - **Es aplicable:** Sus precondiciones ya existen dentro de $S^+$.
   - **Aporta información útil:** Su lista de adición contiene algún hecho que todavía no está presente en $S^+$.
4. **Actualización:** Si existe al menos una acción que cumpla esto (en los ejercicios teóricos se suele pedir desempatar escogiendo la primera por orden alfabético), se elige, se vuelcan todos los hechos de su lista de adición dentro de $S^+$ y se añade la acción al plan $a^+$.
5. **Terminación:**
   - Si a base de acumular hechos se alcanza un punto en el que $G \subseteq S^+$, el algoritmo termina con éxito y **devuelve la secuencia de acciones obtenida** como el plan relajado definitivo.
   - Si, por el contrario, no se ha alcanzado el objetivo pero ya no queda ninguna acción aplicable que pueda aportar un hecho nuevo, el algoritmo se detiene y determina que **no existe ningún plan relajado** posible para ese estado.

El enfoque se denomina "voraz" porque engulle de forma continua cualquier acción que le proporcione información nueva hasta tropezar con la meta. El tamaño o coste del plan ficticio que devuelve este algoritmo se utiliza posteriormente para **estimar matemáticamente (mediante la heurística $h^+$)** cuánto esfuerzo costaría encontrar la solución óptima en el problema real, guiando así al planificador verdadero `.El **algoritmo voraz de cálculo de planes relajados** es un método diseñado para resolver una versión simplificada de un problema de planificación partiendo de un estado concreto, basándose en la premisa de que las acciones añaden nueva información al mundo pero nunca borran la anterior (relajación del borrado) `.

</div>

<div class="highlight-theory">

## Cómo calcular $h^{max}$ y $h^{add}$

Como hemos visto, **calcular la heurística óptima $h^+$ exige aplicar el algoritmo voraz** generando todos los planes relajados posibles y compararlos, lo cual resulta computacionalmente muy costoso (el abanico de planes crece de forma exponencial según el número de acciones del dominio).

Para solucionar este cuello de botella, $h^{max}$ y $h^{add}$ actúan como **aproximaciones eficientes** que no construyen ninguna secuencia de acciones (no hay planes). En su lugar, el sistema **utiliza un algoritmo de programación dinámica** puramente matemático.

Este algoritmo funciona rellenando una tabla de valores numéricos, donde calcula el coste iterativo de alcanzar cada hecho individual del dominio basándose en una gran simplificación: **asumir la independencia entre los objetivos**.

Dependiendo de la heurística que elijas, el cálculo final al evaluar esa tabla cambia:

- **$h^{max}$:** Asume que, para lograr un conjunto de objetivos, es suficiente con lograr **el objetivo individual más costoso**. Toma el valor máximo de entre los objetivos aislados, asumiendo (de forma optimista) que en el esfuerzo de lograr el más difícil se habrán completado los demás.
- **$h^{add}$:** Asume que los objetivos se deben lograr por separado de forma aislada, por lo que su valor es la **suma de los costes individuales** de cada objetivo. Al ignorar que ciertas acciones pueden servir para varios objetivos a la vez, esta heurística suele ser demasiado pesimista.

En resumen: no tienes que trazar ni un solo plan relajado. El sistema simplemente rellena una tabla actualizando de forma matemática el coste estimado de cada hecho a partir del coste de sus precondiciones, deteniéndose en cuanto los números dejan de cambiar. Esto hace que calcular $h^{max}$ y $h^{add}$ sea **drásticamente más rápido** en la práctica computacional.

</div>

<div class="summary">

## Si las heurísticas $h^{max}$ y $h^{add}$ simplemente rellena una tabla actualizando de forma matemática el coste estimado de cada hecho a partir del coste de sus precondiciones, ¿Cómo se "usan" para estimar el coste desde un estado cualquiera `s` al estado objetivo S?

Para estimar el coste total desde un estado concreto $s$ hasta el estado objetivo general $S_G$, el algoritmo no utiliza toda la tabla que ha calculado, sino que **extrae exclusivamente los valores de los hechos que componen el objetivo** y los combina matemáticamente dependiendo de la heurística.

Para entender el proceso completo, hay que fijarse en dos puntos clave:

**1. La tabla está hecha "a medida" para el estado $s$**
El algoritmo de programación dinámica que genera la tabla empieza siempre inicializando los costes basándose en el estado $s$ que quieres evaluar: le asigna un coste de $0$ a los hechos que ya se cumplen en $s$, y un coste de $\infty$ al resto. A partir de ahí, rellena matemáticamente la tabla propagando el coste de las precondiciones hasta que los valores se estabilizan. Esto garantiza que cada valor de la celda $T^s(g)$ representa el coste estimado para alcanzar el hecho $g$ individual partiendo específicamente de $s$.

**2. Cómo se combinan esos valores para obtener el coste final**
Dado que un estado objetivo en planificación automática casi siempre está compuesto por varios hechos a la vez ($g_1, g_2, \dots$), las heurísticas cogen las estimaciones individuales de la tabla y las fusionan aplicando su propia lógica:

- **Heurística $h^{max}$:** Se basa en la suposición relajada de que para lograr un conjunto de objetivos, es suficiente con lograr el objetivo individual más costoso de todos. Por lo tanto, busca en la tabla los hechos que forman el objetivo $S_G$ y **se queda con el valor máximo**:
  $h^{max}(s) = \max(T^s(g) \mid g \in S_G)$.
- **Heurística $h^{add}$:** Se basa en la suposición de que los objetivos son independientes y hay que lograr cada uno por separado (ignorando que varias metas puedan compartir un mismo plan). Por lo tanto, extrae de la tabla los costes individuales de los hechos del objetivo y **los suma todos**:
  $h^{add}(s) = \sum_{g \in S_G} T^s(g)$.

**Ejemplo práctico de los apuntes:**
Imagina el problema de transportar un paquete. El objetivo final requiere que se cumplan simultáneamente dos hechos: que el camión haya regresado al lugar $L_0$ y que el paquete esté en el lugar $L_3$.

- Cuando la tabla para la heurística $h^{max}$ termina de estabilizarse evaluando el estado inicial, nos dice que el coste individual para el camión es $0$ y para el paquete es $3$.
- ¿Cómo se usa la tabla entonces? El algoritmo aplica la regla del máximo a esos dos hechos concretos: $h^{max} = \max(0, 3) = \mathbf{3}$.
- Por el contrario, si estuviéramos aplicando $h^{add}$, tras estabilizarse su respectiva tabla (donde el coste para el paquete resulta ser $4$), el algoritmo usa la suma: $h^{add} = 0 + 4 = \mathbf{4}$.

</div>

<div class="summary">

## ¿Cuál es el pseudocódigo del algoritmo de propagación dinámica?

El pseudocódigo oficial para el **algoritmo de cálculo por programación dinámica** de las heurísticas $h^{max}$ y $h^{add}$ se estructura de la siguiente manera:

### Algoritmo de Cálculo de $h^{max}$ / $h^{add}$

**Entrada:** Un problema de planificación $P = (H, A, I, G)$ y el estado $s$ de $P$.  
**Salida:** El valor estimado de la heurística $h^{max}(s)$ o $h^{add}(s)$.

```text
1.  Para cada hecho g ∈ H hacer:
2.      i ← 0
3.      Inicializar T_0^s(g) como:
            0   si g ∈ s
            ∞   si g ∉ s

4.  Repetir:
5.      i ← i + 1
6.      Para cada hecho g ∈ H hacer:

7.          Para cada acción a ∈ A tal que g ∈ add(a) hacer:
                # Paso A: Calcular el coste de satisfacer las precondiciones de "a"
8.              (h^max) c_{pre(a)} ← max( T_{i-1}^s(g') | g' ∈ pre(a) )
9.              (h^add) c_{pre(a)} ← sum( T_{i-1}^s(g') | g' ∈ pre(a) )

                # Paso B: Quedarse con el coste de la mejor acción que añade "g"
10.         c_g ← min( c_{pre(a)} + c_a  |  a ∈ A, g ∈ add(a) )

            # Paso C: Actualizar el coste acumulado del hecho "g"
11.         T_i^s(g) ← min( T_{i-1}^s(g), c_g )

12. Si T_i^s = T_{i-1}^s entonces:  (La tabla se ha estabilizado)
13.     (h^max) Devolver max( T_i^s(g) | g ∈ G )
14.     (h^add) Devolver sum( T_i^s(g) | g ∈ G )
```

---

### Explicación rápida de las variables para tus apuntes:

- **$T_i^s(g)$:** Es el coste estimado de alcanzar el hecho individual $g$ partiendo desde el estado $s$ en la iteración de tiempo $i$.
- **$c_{pre(a)}$:** Es el coste estimado acumulado para poder cumplir todas las precondiciones necesarias de la acción $a$.
  - En **$h^{max}$** se asume que las precondiciones se pueden lograr en paralelo, por lo que su coste conjunto equivale únicamente al de la precondición más cara de conseguir ($\max$).
  - En **$h^{add}$** se asume que las precondiciones son independientes y hay que pagarlas por separado, por lo que sus costes individuales se suman ($\sum$).
- **$c_a$:** Es el coste individual de ejecutar la acción $a$.
- **$c_g$:** El coste mínimo que costaría obtener el hecho $g$ utilizando la mejor acción aplicable posible del dominio que lo tenga en su lista de adición ($add(a)$).
- **Condición de parada ($T_i^s = T_{i-1}^s$):** El bucle iterativo de programación dinámica se detiene en el momento exacto en que los costes de todos los hechos en una iteración $i$ son idénticos a los de la iteración anterior $i-1$ (es decir, la tabla se ha estabilizado por completo).

</div>

<div class="highlight-exercise">

## El problema de transportes

Las características y restricciones exactas de este problema son las siguientes:

- **Topología:** Existe una red de cuatro lugares o localizaciones denominadas **$L_0$, $L_1$, $L_2$ y $L_3$** `. Las rutas (conexiones bidireccionales) que unen estos lugares son: entre $L_0$ y $L_1$, entre $L_1$ y $L_2$, entre $L_2$ y $L_3$, y adicionalmente existe una ruta directa entre **$L_1$ y $L_3$** `.
- **Elementos móviles:** Se cuenta con un único camión **$C$** y un único paquete **$P$**. A efectos de la planificación, se asume que tanto el camión como los lugares tienen capacidad infinita.
- **Estado Inicial:** El camión $C$ comienza su jornada físicamente en el lugar **$L_0$**, mientras que el paquete $P$ se encuentra esperando en el lugar **$L_1$**.
- **Objetivo:** El sistema de planificación debe lograr dos condiciones simultáneas: el paquete debe ser transportado hasta el lugar **$L_3$**, y el camión debe regresar para finalizar en su posición original **$L_0$**.

Para moverse y operar en este mundo, el modelo dispone de tres **esquemas de acciones** estructuradas en STRIPS:

1.  **`IR(c, l1, l2)`**: Permite trasladar el camión de un lugar a otro, siempre y cuando la precondición `CONECTADOS(l1, l2)` se cumpla.
2.  **`CARGAR_PAQUETE(p, c, l)`**: Permite introducir el paquete en el camión si ambos coinciden en la misma localización.
3.  **`DESCARGAR_PAQUETE(p, c, l)`**: Permite depositar el paquete en la ubicación actual del camión.

## Dado un problema de planificación y su representación en el formalismo STRIPS ¿Qué estrategia se debe seguir para encontrar el `plan óptimo`?

Para abordar el problema de encontrar el **"Plan óptimo"**, existen dos enfoques complementarios: la estrategia algorítmica (cómo lo resuelve matemáticamente un planificador) y la estrategia de razonamiento lógico (cómo debes trazarlo tú para responder al Ejercicio 8).

**1. Estrategia algorítmica (Enfoque del sistema)**
Computacionalmente, la estrategia consiste en transformar el problema en una **búsqueda dentro de un grafo de espacio de estados**, donde los vértices son las posibles situaciones del mundo y los arcos son las acciones.
Para asegurar la optimalidad sin tener que explorar todas las combinaciones posibles, la estrategia a seguir es utilizar el **algoritmo de búsqueda A\***. Este algoritmo avanza evaluando en cada paso la función $f(s) = g(s) + h(s)$, que suma el coste real acumulado hasta el momento y la estimación heurística hasta la meta. La clave teórica es que si se alimenta al algoritmo A\* con una **heurística admisible** (una estimación que nunca sea mayor que el coste real, como $h^+$ o $h^{max}$), se **garantiza matemáticamente encontrar el plan de menor coste**. Si las acciones no tuvieran una heurística disponible pero tuvieran costes asignados, la alternativa sería usar el **algoritmo de Dijkstra**.

**2. Estrategia de razonamiento lógico (Para resolver el Ejercicio 8)**
El enunciado te pide expresamente "razonar" el plan, lo que significa deducir la ruta más corta aprovechando la topología de la red. La estrategia humana es dividir la meta en tres fases lógicas: ida, descarga y regreso.

- **Ida y Recogida:** El camión parte de $L_0$ y el paquete está en $L_1$. La única opción lógica es moverse e introducir la carga:
  1. `IR(C, L0, L1)`
  2. `CARGAR_PAQUETE(P, C, L1)`
- **Transporte (Búsqueda del atajo):** El objetivo de la carga es $L_3$. Aunque la red conecta $L_1$ con $L_2$ y luego $L_2$ con $L_3$, el enunciado establece explícitamente que **existe una conexión directa entre $L_1$ y $L_3$**. Para que el plan sea óptimo, debemos usar esta conexión directa y evitar el rodeo, para luego dejar la carga: 3. `IR(C, L1, L3)` 4. `DESCARGAR_PAQUETE(P, C, L3)`
- **Regreso a la base:** Una de las condiciones del objetivo es que el camión debe terminar su recorrido donde empezó (en $L_0$). Como $L_3$ y $L_0$ no tienen conexión directa, el camino óptimo de vuelta consiste en deshacer la ruta transitada: 5. `IR(C, L3, L1)` 6. `IR(C, L1, L0)`

**Plan solución óptimo definitivo:**
`⟨ IR(C, L0, L1), CARGAR_PAQUETE(P, C, L1), IR(C, L1, L3), DESCARGAR_PAQUETE(P, C, L3), IR(C, L3, L1), IR(C, L1, L0) ⟩`

**Cálculo del coste:**
Dado que el enunciado general del problema no especifica costes individuales para las acciones, en planificación clásica se asume un coste unitario (valor 1) para cada paso. Al constar de 6 acciones estrictamente necesarias, **el coste de este plan óptimo es 6**. _(Nota: En apartados teóricos más avanzados se aplican costes asimétricos, como 3 para viajar entre L1 y L3, lo que cambiaría el valor numérico total, pero esta es la secuencia fundamental más corta)_.

</div>

# Ejercicios

<div class="summary">

Para resolver solventemente cualquier ejercicio de modelado en el formalismo **STRIPS** en tu examen, debes estructurar tu respuesta siguiendo un conjunto de reglas metodológicas y evitar caer en las trampas típicas de diseño.

Aquí tienes la **guía maestra de "tips" y buenas prácticas** basada estrictamente en los dominios y la teoría de tu asignatura:

---

### 1. Domina la Estructura de la Tupla $P = \langle H, A, I, G \rangle$

Todo problema de planificación STRIPS debe quedar definido por estos cuatro conjuntos:

- **$H$ (Hechos/Proposiciones):** Definidos por predicados aplicados a constantes.
- **$A$ (Acciones):** Los esquemas de acciones parametrizados.
- **$I$ (Estado Inicial):** El conjunto de hechos verdaderos al comenzar.
- **$G$ (Objetivos):** El conjunto de hechos que se desean alcanzar.

---

### 2. Aplica la "Regla de Oro" de la Representación Factorizada

La mayor ventaja de STRIPS es que trabaja con estados factorizados. Al diseñar las listas de efectos de tus esquemas de acciones:

- **Especifica únicamente lo que cambia** al aplicar la acción.
- Todo lo que **no** aparezca explícitamente en la lista de borrado (efectos negativos) ni en la lista de adición (efectos positivos) **permanece inalterado por defecto**. No intentes listar hechos que siguen igual.
- **Regla estricta:** La lista de borrado y la de adición para una misma acción deben ser completamente **disjuntas** (un hecho no puede borrarse y añadirse al mismo tiempo).

---

### 3. Evita Errores de Coherencia de Variables

Un error clásico de examen que penaliza gravemente es usar variables "huérfanas".

- **Regla:** Toda variable que aparezca en las precondiciones o en los efectos de un esquema de acción **debe figurar en los parámetros de la cabecera de la acción**.
- _Ejemplo correcto:_ Si representas `CONDUCIR(c, f, l1, l2)`, necesitas que el conductor `c`, la furgoneta `f`, el origen `l1` y el destino `l2` estén en los parámetros para poder comprobar `CONDUCTOR_EN(c, l1)` y cambiar la ubicación de la furgoneta.

---

### 4. No te olvides de los "Flags de Control" (Exclusión Mutua)

Muchos enunciados limitan el uso de recursos con frases como: _"el procesador solo puede ejecutar un programa a la vez"_, _"el satélite solo dispone de energía para encender un instrumento"_ o _"el robot solo tiene dos pinzas"_.

- **Tip de examen:** Para modelar esto, es obligatorio introducir un **predicado de control de disponibilidad** (un flag de estado):
  - `PROCESADOR_EN_ESPERA()`
  - `BRAZO_LIBRE()`
  - `HAY_ENERGÍA(s)`
  - `AVAILABLE(x)`
- **La trampa:** Si pones en las precondiciones que el recurso debe estar libre (`BRAZO_LIBRE()` o `AVAILABLE(x)`), debes **borrarlo de inmediato** en la lista de efectos de la acción que lo ocupa, y **volver a añadirlo** en la acción que lo libera o descarga. Si olvidas este ciclo de borrado/adición, tu modelo permitirá que un robot coja infinitas cosas a la vez.

---

### 5. Clasifica Hechos Estáticos vs. Hechos Dinámicos

- **Hechos Dinámicos:** Cambian a lo largo del tiempo (ej. `PAQUETE_EN(p, l)` o `ASCENSOR_EN(pl)`). Aparecen en precondiciones, borrados y adiciones.
- **Hechos Estáticos:** Describen la geografía inmutable del entorno (ej. `HAY_CARRETERA(l1, l2)`, `SUPERIOR(pl1, pl2)` o `MOVE-DIR(f, t, d)`).
  - **Tip de examen:** Colócalos en las **precondiciones** para validar que la acción es física o lógicamente posible.
  - **La trampa:** **Nunca** los pongas en la lista de borrado o adición. Las carreteras no desaparecen por conducir por ellas.

---

### 6. Aplica la Hipótesis del Mundo Cerrado en $I$ y $G$

- En el **Estado Inicial ($I$):** Solo debes listar aquellos hechos que son **verdaderos**. Todo lo que no listes (como que un programa no está copiado) se asume automáticamente como falso.
- En el **Objetivo ($G$):** **Nunca diseñes un estado completo**. El objetivo debe ser el conjunto **mínimo** de condiciones que se deben cumplir para dar el problema por resuelto. Por ejemplo, si el objetivo es que el paquete esté en su destino, solo pon `PAQUETE_EN(P1, L3)`. No incluyas dónde debe acabar el camión o el conductor a menos que el enunciado lo exija explícitamente.

---

### 7. El truco del "Desdoblamiento de Acciones"

A veces, el efecto de una acción cambia drásticamente según las propiedades del destino.

- _Por ejemplo:_ En Sokoban, empujar una piedra a una casilla objetivo añade el hecho `AT-GOAL(s)`, pero empujarla a una casilla no-objetivo debe borrarlo (por si la piedra ya estaba en una zona objetivo y la has sacado de ahí).
- **Tip de examen:** En lugar de intentar escribir condiciones complejas (que STRIPS básico no permite), **desdobla la acción en dos esquemas de acciones diferentes**. Crea una acción `PUSH-TO-GOAL` (con la precondición estática `is_goal(t)`) y otra `PUSH-TO-NONGOAL` (con la precondición estática `is_nongoal(t)`).

---

### 8. Cómo redactar la comprobación de un plan solución

Si el examen te pide _"comprobar que el plan efectivamente es solución describiendo la secuencia de estados"_:

1.  Escribe el estado inicial completo $S_0 = I$.
2.  Para cada acción $a_i$ de tu plan:
    - Muestra que se cumplen sus precondiciones en $S_{i-1}$.
    - Escribe el nuevo estado $S_i = (S_{i-1} \setminus \text{del}(a_i)) \cup \text{add}(a_i)$.
3.  Al llegar al último estado $S_n$, escribe explícitamente: _"Como $G \subseteq S_n$, se cumplen todos los objetivos y el plan es válido"_.

</div>

## Ejercicio 1

Consideremos un dominio de planificación automática consistente en un ordenador que debe gestionar la ejecución de varios programas de software. El proceso para ejecutar un programa consiste en primero copiarlo desde el disco duro a la memoria y después asignarlo al procesador para que este lo ejecute. Asumimos que la memoria del ordenador tiene capacidad infinita, pero que el procesador solo puede ejecutar un programa a la vez.

En este dominio los hechos se especifican a partir de los siguientes predicados:

- **NO_EN_MEMORIA(p)**: representa que el programa p no se ha copiado todavía en la memoria del ordenador.
- **EN_MEMORIA(p)**: representa que el programa p ya se ha copiado en la memoria del ordenador.
- **ASIGNADO(p)**: representa que el programa p se ha asignado al procesador del ordenador para su ejecución.
- **EJECUTADO(p)**: representa que el procesador ya ha ejecutado el programa p.
- **PROCESADOR_EN_ESPERA()**: representa que el procesador del ordenador no tiene asignado ningún programa para su ejecución.

Se pide:

1.  Representar en el formalismo STRIPS los siguientes esquemas de acciones:
    - **COPIAR(p)**: representa que el programa p se copia del disco duro a la memoria.
    - **ASIGNAR(p)**: representa que el programa p, que debe estar copiado en la memoria, se asigna al procesador para su ejecución.
    - **EJECUTAR(p)**: representa que el procesador ejecuta el programa p, quedando libre para la ejecución de un nuevo programa.
2.  Representar el estado inicial y el objetivo de un problema en ese dominio en el que se deben ejecutar los programas P1 y P2.
3.  Especificar un posible plan solución del problema anterior y comprobar que efectivamente lo es describiendo la secuencia de estados que se obtiene al aplicar las acciones contenidas en el plan.

### Solución ejercicio 1

#### Apartado 1

- COPIAR(p)
  - precondiciones: NO_EN_MEMORIA(p)
  - lista de borrado: NO_EN_MEMORIA(p)
  - lista de adición: EN_MEMORIA(p)
- ASIGNAR(p):
  - precondiciones: EN_MEMORIA(p), PROCESADOR_EN_ESPERA()
  - lista de borrado: PROCESADOR_EN_ESPERA()
  - lista de adición: ASIGNADO(p)
- EJECUTAR(p):
  - precondiciones: ASIGNADO(p)
  - lista de borrado: ASIGNADO(p)
  - lista de adición: EJECUTADO(p), PROCESADOR_EN_ESPERA()

#### Apartado 2

- Estado inicial S_i: {NO_EN_MEMORIA(P1), NO_EN_MEMORIA(P2), PROCESADOR_EN_ESPERA()}
- Estadi final S_f: { EJECUTADO(P1), EJECUTADO(P2), PROCESADOR_EN_ESPERA()}

#### Apartado 3

- Plan de acción sería: { COPIAR(P1), COPIAR(P2), ASIGNAR(P1), EJECUTAR(P1), ASIGNAR(P2), EJECUTAR(P2)}
- Secuencia de estados sería:
  -> S_i: {NO_EN_MEMORIA(P1), NO_EN_MEMORIA(P2), PROCESADOR_EN_ESPERA()}
  -> COPIAR(P1) => S_1 => {EN_MEMORIA(P1), NO_EN_MEMORIA(P2), PROCESADOR_EN_ESPERA()}
  -> COPIAR(P2) => S_2 => {EN_MEMORIA(P1), EN_MEMORIA(P2), PROCESADOR_EN_ESPERA()}
  -> ASIGNAR(P1) => S_3 => {EN_MEMORIA(P1), ASIGNADO(P1), EN_MEMORIA(P2)}
  -> EJECUTAR(P1) => S_4 => {EN_MEMORIA(P1), EN_MEMORIA(P2), EJECUTADO(P1), PROCESADOR_EN_ESPERA()}
  -> ASIGNAR(P2) => S_5 => {EN_MEMORIA(P1), EN_MEMORIA(P2), EJECUTADO(P1), ASIGNADO(P2)}
  -> EJECUTAR(P2) => S_6 => {EN_MEMORIA(P1), EN_MEMORIA(P2), EJECUTADO(P1), EJECUTADO(P2), PROCESADOR_EN_ESPERA()}

---

## Ejercicio 2

Consideremos un dominio de planificación automática consistente en furgonetas conducidas por conductores para transportar paquetes entre distintos lugares.

En este dominio los hechos se especifican a partir de los siguientes predicados:

- **CONDUCTOR_EN(c, l)**: representa que el conductor $c$ está en el lugar $l$.
- **FURGONETA_EN(f, l)**: representa que la furgoneta $f$ está en el lugar $l$.
- **PAQUETE_EN(p, l)**: representa que el paquete $p$ está en el lugar $l$.
- **CARGADO_EN(p, f)**: representa que el paquete $p$ está cargado en la furgoneta $f$.
- **CONDUCIENDO(c, f)**: representa que el conductor $c$ conduce la furgoneta $f$.
- **SIN_CONDUCTOR(f)**: representa que ningún conductor conduce la furgoneta $f$.
- **HAY_CARRETERA(l1, l2)**: representa que hay una carretera entre los lugares $l\_1$ y $l\_2$.
- **HAY_CAMINO(l1, l2)**: representa que hay un camino entre los lugares $l\_1$ y $l\_2$.

Se pide:

1.  Representar en el formalismo STRIPS los siguientes esquemas de acciones:
    - **CARGAR_FURGONETA(p, f, l)**: representa que en el lugar $l$ se carga el paquete $p$ en la furgoneta $f$.
    - **DESCARGAR_FURGONETA(p, f, l)**: representa que en el lugar $l$ se descarga el paquete $p$ de la furgoneta $f$.
    - **SUBIR_A(c, f, l)**: representa que en el lugar $l$ el conductor $c$ se sube a la furgoneta $f$ para conducirla. Una furgoneta solo puede ser conducida por un único conductor.
    - **BAJAR_DE(c, f, l)**: representa que en el lugar $l$ el conductor $c$ se baja de la furgoneta $f$.
    - **CONDUCIR(c, f, l1, l2)**: representa que el conductor $c$ conduce por carretera la furgoneta $f$ del lugar $l\_1$ al lugar $l\_2$.
    - **CAMINAR(c, l1, l2)**: representa que el conductor $c$ va andando por un camino del lugar $l\_1$ al lugar $l\_2$.
2.  Representar el estado inicial y el objetivo de un problema en ese dominio en el que:
    - Hay tres lugares L1, L2 y L3, dos furgonetas F1 y F2, dos conductores C1 y C2 y dos paquetes P1 y P2.
    - Hay una carretera entre los lugares L1 y L3 y entre los lugares L2 y L3.
    - Hay un camino entre los lugares L1 y L2.
    - La furgoneta F1, el conductor C1 y el paquete P1 se encuentran en el lugar L1, mientras que la furgoneta F2, el conductor C2 y el paquete P2 se encuentran en el lugar L2.
    - El objetivo es que ambos paquetes y el conductor C1 se encuentren en el lugar L3, la furgoneta F1 en el lugar L1 y el conductor C2 en el lugar L2.
3.  Especificar un posible plan solución del problema anterior y comprobar que efectivamente lo es describiendo la secuencia de estados que se obtiene al aplicar las acciones contenidas en el plan.

### Solución ejercicio 2

#### Apartado 1

- **CARGAR_FURGONETA(p, f, l)**: representa que en el lugar $l$ se carga el paquete $p$ en la furgoneta $f$.
  - precondiciones: FURGONETA_EN(f, l), PAQUETE_EN(p, l)
  - lista de borrado: PAQUETE_EN(p, l)
  - lista de adición: CARGADO_EN(p, f)
- **DESCARGAR_FURGONETA(p, f, l)**: representa que en el lugar $l$ se descarga el paquete $p$ de la furgoneta $f$.
  - precondiciones: CARGADO_EN(p, f)
  - lista de borrado: CARGADO_EN(p, f)
  - lista de adición: PAQUETE_EN(p, l)
- **SUBIR_A(c, f, l)**: representa que en el lugar $l$ el conductor $c$ se sube a la furgoneta $f$ para conducirla. Una furgoneta solo puede ser conducida por un único conductor.
  - precondiciones: CONDUCTOR_EN(c, l), FURGONETA_EN(f, l), SIN_CONDUCTOR(f)
  - lista de borrado: SIN_CONDUCTOR(f), CONDUCTOR_EN(c, l)
  - lista de adición: CONDUCIENDO(c, f)
- **BAJAR_DE(c, f, l)**: representa que en el lugar $l$ el conductor $c$ se baja de la furgoneta $f$.
  - precondiciones: FURGONETA_EN(f, l), CONDUCIENDO(c, f)
  - lista de borrado: CONDUCIENDO(c, f)
  - lista de adición: SIN_CONDUCTOR(f), CONDUCTOR_EN(c, l)
- **CONDUCIR(c, f, l1, l2)**: representa que el conductor $c$ conduce por carretera la furgoneta $f$ del lugar $l\_1$ al lugar $l\_2$.
  - precondiciones: CONDUCIENDO(c, f), FURGONETA_EN(f, l1), HAY_CARRETERA(l1, l2)
  - lista de borrado: FURGONETA_EN(f, l1)
  - lista de adición: FURGONETA_EN(f, l2)
- **CAMINAR(c, l1, l2)**: representa que el conductor $c$ va andando por un camino del lugar $l\_1$ al lugar $l\_2$.
  - precondiciones: CONDUCTOR_EN(c, l1), HAY_CAMINO(l1, l2)
  - lista de borrado: CONDUCTOR_EN(c, l1)
  - lista de adición: CONDUCTOR_EN(c, l2)

#### Apartado 2

S_INICIAL = { HAY_CARRETERA(L1, L3), HAY_CARRETERA(L3, L1), HAY_CARRETERA(L2, L3), HAY_CARRETERA(L3, L2), HAY_CAMINO(L1, L2), HAY_CAMINO(L2, L1), FURGONETA_EN(F1, L1), FURGONETA_EN(F2, L2), CONDUCTOR_EN(C1, L1), CONDUCTOR_EN(C2, L2), PAQUETE_EN(P1, L1), PAQUETE_EN(P2, L2), SIN_CONDUCTOR(F1), SIN_CONDUCTOR(F2)}

S_OBJETIVO = { **PAQUETE_EN(P1, L3)**, **PAQUETE_EN(P2, L3)**, **CONDUCTOR_EN(C1, L3)**, CONDUCTOR_EN(C2, L2), **FURGONETA_EN(F1, L1)**}

#### Apartado 3

Especificar un posible plan solución del problema anterior y comprobar que efectivamente lo es describiendo la secuencia de estados que se obtiene al aplicar las acciones contenidas en el plan.

S_INICIAL = { HAY_CARRETERA(L1, L3), HAY_CARRETERA(L2, L3), HAY_CAMINO(L1, L2), FURGONETA_EN(F1, L1), FURGONETA_EN(F2, L2), CONDUCTOR_EN(C1, L1), CONDUCTOR_EN(C2, L2), PAQUETE_EN(P1, L1), PAQUETE_EN(P2, L2), SIN_CONDUCTOR(F1), SIN_CONDUCTOR(F2)}
-> CARGAR_FURGONETA(P1, F1, L1) => { CARGADO_EN(P1, F1), FURGONETA_EN(F1, L1), FURGONETA_EN(F2, L2), CONDUCTOR_EN(C1, L1), CONDUCTOR_EN(C2, L2), PAQUETE_EN(P2, L2), SIN_CONDUCTOR(F1), SIN_CONDUCTOR(F2)}
-> CARGAR_FURGONETA(P2, F2, L2) => { CARGADO_EN(P2, F2), CARGADO_EN(P1, F1), FURGONETA_EN(F1, L1), FURGONETA_EN(F2, L2), CONDUCTOR_EN(C1, L1), CONDUCTOR_EN(C2, L2), SIN_CONDUCTOR(F1), SIN_CONDUCTOR(F2)}
-> SUBIR_A(C1, F1, L1) => { CONDUCIENDO(C1, F1), CARGADO_EN(P2, F2), CARGADO_EN(P1, F1), FURGONETA_EN(F1, L1), FURGONETA_EN(F2, L2), CONDUCTOR_EN(C2, L2), SIN_CONDUCTOR(F2)}
-> SUBIR_A(C2, F2, L2) => { CONDUCIENDO(C2, F2), CONDUCIENDO(C1, F1), CARGADO_EN(P2, F2), CARGADO_EN(P1, F1), FURGONETA_EN(F1, L1), FURGONETA_EN(F2, L2)}
-> CONDUCIR(C1, F1, L1, L3) => { FURGONETA_EN(F1, L3), CONDUCIENDO(C2, F2), CONDUCIENDO(C1, F1), CARGADO_EN(P2, F2), CARGADO_EN(P1, F1), FURGONETA_EN(F2, L2),}
-> CONDUCIR(C2, F2, L2, L3) => { FURGONETA_EN(F2, L3), FURGONETA_EN(F1, L3), CONDUCIENDO(C2, F2), CONDUCIENDO(C1, F1), CARGADO_EN(P2, F2), CARGADO_EN(P1, F1)}
-> BAJAR_DE(C1, F1, L3) => { SIN_CONDUCTOR(F1), **CONDUCTOR_EN(C1, L3)**, FURGONETA_EN(F2, L3), FURGONETA_EN(F1, L3), CONDUCIENDO(C2, F2), CARGADO_EN(P2, F2), CARGADO_EN(P1, F1)}
-> DESCARGAR_FURGONETA(P1, F1, L3) => {**PAQUETE_EN(P1, L3)**, SIN_CONDUCTOR(F1), **CONDUCTOR_EN(C1, L3)**, FURGONETA_EN(F2, L3), FURGONETA_EN(F1, L3), CONDUCIENDO(C2, F2), CARGADO_EN(P2, F2)}
-> BAJAR_DE(C2, F2, L3) => { SIN_CONDUCTOR(F2), CONDUCTOR_EN(C2, L3), **PAQUETE_EN(P1, L3)**, SIN_CONDUCTOR(F1), **CONDUCTOR_EN(C1, L3)**, FURGONETA_EN(F2, L3), FURGONETA_EN(F1, L3), CARGADO_EN(P2, F2)}
-> DESCARGAR_FURGONETA(P2, F2, L3) => { **PAQUETE_EN(P2, L3)**, SIN_CONDUCTOR(F2), CONDUCTOR_EN(C2, L3), **PAQUETE_EN(P1, L3)**, SIN_CONDUCTOR(F1), **CONDUCTOR_EN(C1, L3)**, FURGONETA_EN(F2, L3), FURGONETA_EN(F1, L3)}
-> SUBIR_A(C2, F1, L3) => {CONDUCIENDO(C2, F1), **PAQUETE_EN(P2, L3)**, SIN_CONDUCTOR(F2), **PAQUETE_EN(P1, L3)**, **CONDUCTOR_EN(C1, L3)**, FURGONETA_EN(F2, L3), FURGONETA_EN(F1, L3)}
-> CONDUCIR(C2, F1, L3, L1) => {**FURGONETA_EN(F1, L1)**, CONDUCIENDO(C2, F1), **PAQUETE_EN(P2, L3)**, SIN_CONDUCTOR(F2), **PAQUETE_EN(P1, L3)**, **CONDUCTOR_EN(C1, L3)**, FURGONETA_EN(F2, L3)}
-> BAJAR_DE(C2, F1, L1) => { CONDUCTOR_EN(C2, L1), SIN_CONDUCTOR(F1), **FURGONETA_EN(F1, L1)**, **PAQUETE_EN(P2, L3)**, SIN_CONDUCTOR(F2), **PAQUETE_EN(P1, L3)**, **CONDUCTOR_EN(C1, L3)**, FURGONETA_EN(F2, L3)}
-> CAMINAR(C2, L1, L2) => { **CONDUCTOR_EN(C2, L2)**, SIN_CONDUCTOR(F1), **FURGONETA_EN(F1, L1)**, **PAQUETE_EN(P2, L3)**, SIN_CONDUCTOR(F2), **PAQUETE_EN(P1, L3)**, **CONDUCTOR_EN(C1, L3)**, FURGONETA_EN(F2, L3)}

<div class="highlight-exercise">

## Ejercicio 3

Consideremos un dominio de planificación automática consistente en un ascensor (que asumimos con capacidad infinita) que permite moverse a personas entre distintas plantas de un edificio.

En este dominio los hechos se especifican a partir de los siguientes predicados:

- **SUPERIOR(pl1, pl2)**: representa que la planta $pl\_{1}$ del edificio está por encima de la planta $pl\_{2}$.
- **ASCENSOR_EN(pl)**: representa que el ascensor se encuentra en la planta $pl$ del edificio.
- **ORIGEN(pe, pl)**: representa que la persona $pe$ se encuentra inicialmente en la planta $pl$ del edificio.
- **DESTINO(pe, pl)**: representa que la persona $pe$ desea ir a la planta $pl$ del edificio.
- **DENTRO_ASCENSOR(pe)**: representa que la persona $pe$ ha entrado en el ascensor.
- **FUERA_ASCENSOR(pe)**: representa que la persona $pe$ no ha entrado en el ascensor.
- **EN_DESTINO(pe)**: representa que la persona $pe$ ha llegado a su destino.

Se pide:

1.  Representar en el formalismo STRIPS los siguientes esquemas de acciones:
    - **ENTRAR(pe, pl)**: representa que la persona $pe$ entra en el ascensor en la planta $pl$ en la que se encuentra inicialmente.
    - **SALIR(pe, pl)**: representa que la persona $pe$ sale del ascensor en la planta $pl$ del edificio a la que desea ir.
    - **SUBIR(pl1, pl2)**: representa que el ascensor sube de la planta $pl\_{1}$ a la planta $pl\_{2}$ del edificio.
    - **BAJAR(pl1, pl2)**: representa que el ascensor baja de la planta $pl\_{1}$ a la planta $pl\_{2}$ del edificio.
2.  Representar el estado inicial y el objetivo de un problema en ese dominio en el que: el edificio tiene cuatro plantas (plantas PL0 a PL3); el ascensor se encuentra inicialmente en la planta PL1; hay una persona PE0 en la planta PL0 que desea ir a la planta PL2; hay una persona PE1 en la planta PL3 que desea ir a la planta PL0.
3.  Especificar un posible plan solución de ese problema anterior y comprobar que efectivamente lo es describiendo la secuencia de estados que se obtiene al aplicar las acciones contenidas en el plan.

### Solución ejercicio 3

#### Apartado 1

- **ENTRAR(pe, pl)**: representa que la persona $pe$ entra en el ascensor en la planta $pl$ en la que se encuentra inicialmente.
  - precondiciones: ASCENSOR_EN(pl), ORIGEN(pe, pl), FUERA_ASCENSOR(pe)
  - lista de borrado: FUERA_ASCENSOR(pe)
  - lista de adición: DENTRO_ASCENSOR(pe)
- **SALIR(pe, pl)**: representa que la persona $pe$ sale del ascensor en la planta $pl$ del edificio a la que desea ir.
  - precondiciones: ASCENSOR_EN(pl), DESTINO(pe, pl), DENTRO_ASCENSOR(pe)
  - lista de borrado: DENTRO_ASCENSOR(pe)
  - lista de adición: FUERA_ASCENSOR(pe), EN_DESTINO(pe)
- **SUBIR(pl1, pl2)**: representa que el ascensor sube de la planta $pl\_{1}$ a la planta $pl\_{2}$ del edificio.
  - precondiciones: SUPERIOR(pl2, pl1), ASCENSOR_EN(pl1)
  - lista de borrado: ASCENSOR_EN(pl1)
  - lista de adición: ASCENSOR_EN(pl2)
- **BAJAR(pl1, pl2)**: representa que el ascensor baja de la planta $pl\_{1}$ a la planta $pl\_{2}$ del edificio.
  - precondiciones: SUPERIOR(pl1, pl2), ASCENSOR_EN(pl1)
  - lista de borrado: ASCENSOR_EN(pl1)
  - lista de adición: ASCENSOR_EN(pl2)

#### Apartado 2

- Estado inicicial -> S_i = {ASCENSOR_EN(PL1), ORIGEN(PE0, PL0), FUERA_ASCENSOR(PE0), DESTINO(PE0, PL2), ORIGEN(PE1, PL3), FUERA_ASCENSOR(PE1), DESTINO(PE1, PL0), SUPERIOR(PL1, PL0), SUPERIOR(PL2, PL0), SUPERIOR(PL3, PL0), SUPERIOR(PL2, PL1), SUPERIOR(PL3, PL1), SUPERIOR(PL3, PL2)}
- Estado objetivo -> S_o = {EN_DESTINO(PE0), EN_DESTINO(PE1)}

#### Apartado 3

Plan = { BAJAR(PL1, PL0), ENTRAR(PE0, PL0), SUBIR(PL0, PL1), SUBIR(PL1, PL2), SALIR(PE0, PL2), SUBIR(PL2, PL3), ENTRAR(PE1, PL3), BAJAR(PL3, PL2), BAJAR(PL2, PL1), BAJAR(PL1, PL0), SALIR(PE1, PL0) }

Ya que ORIGEN(PE0, PL0) y ORIGEN(PE1, PL3), y SUPERIOR(PL1, PL0), SUPERIOR(PL2, PL0), SUPERIOR(PL3, PL0), SUPERIOR(PL2, PL1), SUPERIOR(PL3, PL1), SUPERIOR(PL3, PL2), Y DESTINO(PE0, PL2), DESTINO(PE1, PL0) no están en ninguan lista de borrado ni de adición, sustituimos estos hechos por el simbolo H para claridad de la exposición.

S_i = {ASCENSOR_EN(PL1), FUERA_ASCENSOR(PE0), FUERA_ASCENSOR(PE1), H}

- BAJAR(PL1, PL0) -> { **ASCENSOR_EN(PL0)**, FUERA_ASCENSOR(PE0), , FUERA_ASCENSOR(PE1), H}
- ENTRAR(PE0, PL0) -> { ASCENSOR_EN(PL0), **DENTRO_ASCENSOR(PE0)**, FUERA_ASCENSOR(PE1), H}
- SUBIR(PL0, PL1) -> { **ASCENSOR_EN(PL1)**, DENTRO_ASCENSOR(PE0), FUERA_ASCENSOR(PE1), H}
- SUBIR(PL1, PL2) -> { **ASCENSOR_EN(PL2)**, DENTRO_ASCENSOR(PE0), FUERA_ASCENSOR(PE1), H}
- SALIR(PE0, PL2) -> { **ASCENSOR_EN(PL2)**, FUERA_ASCENSOR(PE0), **EN_DESTINO(PE0)**, FUERA_ASCENSOR(PE1), H}
- SUBIR(PL2, PL3) -> { **ASCENSOR_EN(PL3)**, FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), FUERA_ASCENSOR(PE1), H}
- ENTRAR(PE1, PL3) -> { ASCENSOR_EN(PL3), **DENTRO_ASCENSOR(PE1)**, FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), H}
- BAJAR(PL3, PL2) -> { **ASCENSOR_EN(PL2)**, DENTRO_ASCENSOR(PE1), FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), H}
- BAJAR(PL2, PL1) -> { **ASCENSOR_EN(PL1)**, DENTRO_ASCENSOR(PE1), FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), H}
- BAJAR(PL1, PL0) -> { **ASCENSOR_EN(PL0)**, DENTRO_ASCENSOR(PE1), FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), H}
- SALIR(PE1, PL0) -> { ASCENSOR_EN(PL0), **FUERA_ASCENSOR(PE1)**, **EN_DESTINO(PE1)**, FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), H}

<div class="highlight-exercise">

## Ejercicio 4

Aquí tienes el enunciado del **Ejercicio 4** en formato markdown:

### Ejercicio 4

Consideremos un dominio de planificación automática consistente en un conjunto de satélites que se pretenden usar para, con unos instrumentos a bordo de esos satélites, tomar una serie de distintos tipos de fotografías de ciertos fenómenos galácticos.

En este dominio los hechos se especifican a partir de los siguientes predicados:

- **SON_DISTINTOS($o\_1, o\_2$)**: representa que los objetos $o\_1$ y $o\_2$ son distintos.
- **APUNTA_A($s, o$)**: representa que el satélite $s$ está orientado hacia el objeto $o$.
- **A_BORDO($i, s$)**: representa que el instrumento $i$ se encuentra a bordo del satélite $s$.
- **NO_CALIBRADO($i$)**: representa que el instrumento $i$ no está calibrado.
- **CALIBRADO($i$)**: representa que el instrumento $i$ está calibrado.
- **OBJETIVO_CALIBRACIÓN($i, o$)**: representa que el objeto $o$ se usa para calibrar el instrumento $i$.
- **COMPATIBLE_CON($i, t$)**: representa que el instrumento $i$ puede tomar imágenes de tipo $t$.
- **HAY_ENERGÍA($s$)**: representa que el satélite $s$ dispone de energía para encender un instrumento.
- **ENCENDIDO($i$)**: representa que el instrumento $i$ está encendido.
- **SIN_IMAGEN($o, t$)**: representa que no se tiene una imagen de tipo $t$ del objeto $o$.
- **CON_IMAGEN($o, t$)**: representa que se tiene una imagen de tipo $t$ del objeto $o$.

Se pide:

1.  Representar en el formalismo **STRIPS** los siguientes esquemas de acciones:
    - **GIRAR_HACIA($s, o\_1, o\_2$)**: representa que el satélite $s$ pasa de apuntar hacia el objeto $o\_1$ a apuntar hacia el objeto $o\_2$.
    - **ENCENDER($i, s$)**: representa que se enciende el instrumento $i$ a bordo del satélite $s$. Para ello el satélite debe tener energía disponible, ya que en cada satélite no puede estar encendido más de un instrumento a la vez.
    - **APAGAR($i, s$)**: representa que se apaga el instrumento $i$ a bordo del satélite $s$, volviendo a haber energía disponible en ese satélite para poder encender otro instrumento. Los instrumentos dejan de estar calibrados cuando se apagan.
    - **CALIBRAR($i, s, o$)**: representa que se calibra el instrumento $i$ a bordo del satélite $s$ con el objetivo de calibración $o$ del instrumento. Para ello, el satélite debe apuntar hacia ese objetivo y el instrumento debe estar encendido.
    - **TOMAR_IMAGEN($i, s, o, t$)**: representa que con el instrumento $i$ a bordo del satélite $s$ se toma una imagen de tipo $t$ del objeto $o$. Para ello, el satélite debe apuntar hacia ese objeto y el instrumento debe estar encendido y calibrado y debe poder tomar imágenes de ese tipo.

2.  Representar el **estado inicial** y el **objetivo** de un problema en ese dominio en el que:
    - Hay dos satélites, SATÉLITE0 y SATÉLITE1.
    - Hay cuatro instrumentos, INSTRUMENTO0 a INSTRUMENTO3.
    - Hay tres tipos de imágenes, VISIBLE, INFRARROJOS y ESPECTRÓGRAFO.
    - Hay ocho objetos galácticos, ESTRELLA0 a ESTRELLA4 y NEBULOSA0 a NEBULOSA2.
    - El INSTRUMENTO0 puede tomar imágenes de tipo INFRARROJOS y ESPECTRÓGRAFO y se calibra con ESTRELLA1.
    - El INSTRUMENTO1 puede tomar imágenes de tipo VISIBLE y se calibra con ESTRELLA2.
    - El INSTRUMENTO2 puede tomar imágenes de tipo VISIBLE e INFRARROJOS y se calibra con ESTRELLA0.
    - El INSTRUMENTO3 puede tomar imágenes de tipo VISIBLE, INFRARROJOS y ESPECTRÓGRAFO y se calibra con ESTRELLA0.
    - El satélite SATÉLITE0 tiene a bordo los instrumentos INSTRUMENTO0, INSTRUMENTO1 e INSTRUMENTO2, apagados, y apunta inicialmente a ESTRELLA4.
    - El satélite SATÉLITE1 tiene a bordo el instrumento INSTRUMENTO3, apagado, y apunta inicialmente a ESTRELLA0.
    - Se desean una imagen de infrarrojos de ESTRELLA3, una imagen de espectrógrafo de ESTRELLA4 y NEBULOSA0 y una imagen del visible y de espectrógrafo de NEBULOSA2.

### Solución ejercicio 4

#### Apartado 1

- **GIRAR_HACIA($s, o\_1, o\_2$)**: representa que el satélite $s$ pasa de apuntar hacia el objeto $o\_1$ a apuntar hacia el objeto $o\_2$.
  - precondiciones: SON_DISTINTOS($o\_1, o\_2$), APUNTA_A($s, o\_1$)
  - lista de borrado: APUNTA_A($s, o\_1$)
  - lista de adición: APUNTA_A($s, o\_2$)
- **ENCENDER($i, s$)**: representa que se enciende el instrumento $i$ a bordo del satélite $s$. Para ello el satélite debe tener energía disponible, ya que en cada satélite no puede estar encendido más de un instrumento a la vez.
  - precondiciones: HAY_ENERGÍA($s$), A_BORDO($i, s$), NO_CALIBRADO($i$)
  - lista de borrado: HAY_ENERGÍA($s$)
  - lista de adición: ENCENDIDO($i$)
- **APAGAR($i, s$)**: representa que se apaga el instrumento $i$ a bordo del satélite $s$, volviendo a haber energía disponible en ese satélite para poder encender otro instrumento. Los instrumentos dejan de estar calibrados cuando se apagan.
  - precondiciones: A_BORDO($i, s$), ENCENDIDO($i$)
  - lista de borrado: ENCENDIDO($i$), CALIBRADO($i$)
  - lista de adición: HAY_ENERGÍA($s$), NO_CALIBRADO($i$)
- **CALIBRAR($i, s, o$)**: representa que se calibra el instrumento $i$ a bordo del satélite $s$ con el objetivo de calibración $o$ del instrumento. Para ello, el satélite debe apuntar hacia ese objetivo y el instrumento debe estar encendido.
  - precondiciones: A_BORDO($i, s$), ENCENDIDO($i$), APUNTA_A($s, o$), OBJETIVO_CALIBRACIÓN($i, o$), NO_CALIBRADO($i$)
  - lista de borrado: NO_CALIBRADO($i$)
  - lista de adición: CALIBRADO($i$)
- **TOMAR_IMAGEN($i, s, o, t$)**: representa que con el instrumento $i$ a bordo del satélite $s$ se toma una imagen de tipo $t$ del objeto $o$. Para ello, el satélite debe apuntar hacia ese objeto y el instrumento debe estar encendido y calibrado y debe poder tomar imágenes de ese tipo.
  - precondiciones: A_BORDO($i, s$), APUNTA_A($s, o$), ENCENDIDO($i$), CALIBRADO($i$), COMPATIBLE_CON($i, t$), SIN_IMAGEN($o, t$)
  - lista de borrado: SIN_IMAGEN($o, t$)
  - lista de adición: CON_IMAGEN($o, t$)
    `Nota`: Suponemos que, dado un objeto $o$, solo se puede tomar una imagen del tipo $t$.

#### Apartado 2

Estado Incial $S_i$ = {

- SON_DISTINTOS(o_1, o_2); $\forall o_1, o_2 \in {ESTRELLA_0,\ldots,ESTRELLA_4,\;NEBULOSA_0,\ldots,NEBULOSA_2}$ con $o_1 \neq o_2$
- APUNTA_A($SATÉLITE_1$, $ESTRELLA_0$), APUNTA_A($SATÉLITE_0$, $ESTRELLA_4$)
- A_BORDO($INTRUMENTO_i$, $SATÉLITE_0$) para $i \in \{0,1,2\}$, A_BORDO($INTRUMENTO_3$, $SATÉLITE_1$)
- NO_CALIBRADO($INSTRUMENTO_i$) para $i \in \{0,1,2,3\}$
- OBJETIVO_CALIBRACIÓN($INSTRUMENTO_0$, $ESTRELLA_1$), OBJETIVO_CALIBRACIÓN($INSTRUMENTO_1$, $ESTRELLA_2$), OBJETIVO_CALIBRACIÓN($INSTRUMENTO_2$, $ESTRELLA_0$), OBJETIVO_CALIBRACIÓN($INSTRUMENTO_3$, $ESTRELLA_0$)
- COMPATIBLE_CON($INSTRUMENTO_0$, $INFRAROJOS$), COMPATIBLE_CON($INSTRUMENTO_0$, $ESPECTRÓGRAFO$), COMPATIBLE_CON($INSTRUMENTO_1$, $VISIBLE$), COMPATIBLE_CON($INSTRUMENTO_2$, $VISIBLE$), COMPATIBLE_CON($INSTRUMENTO_2$, $INFRAROJOS$), COMPATIBLE_CON($INSTRUMENTO_3$, $INFRAROJOS$, COMPATIBLE_CON($INSTRUMENTO_3$, $ESPECTRÓGRAFO$), COMPATIBLE_CON($INSTRUMENTO_3$, $VISIBLE$)
- HAY_ENERGÍA($SATÉLITE_0$), HAY_ENERGÍA($SATÉLITE_1$),
- SIN_IMAGEN(ESTRELLA_i, TIPO) para $i \in \{0,1,2,3,4\}$, TIPO $\in \{VISIBLE, INFRARROJOS, ESPECTRÓGRAFO\}$
- SIN_IMAGEN(NEBULOSA_i, VISIBLE), SIN_IMAGEN(NEBULOSA_i, TIPO) para $i, j \in \{0,1,2\}$, TIPO $\in \{VISIBLE, INFRARROJOS, ESPECTRÓGRAFO\}$ )
  }

Estado objetivo, $S_o$ { CON_IMAGEN(ESTRELLA_3, INFRAROJOS), CON_IMAGEN(ESTRELLA_4, ESPECTRÓGRAFO), CON_IMAGEN(NEBULOSA_0, ESPECTRÓGRAFO), CON_IMAGEN(NEBULOSA_2, VISIBLE), CON_IMAGEN(NEBULOSA_2, ESPECTRÓGRAFO) }

</div>
<div class="highlight-exercise">

## Ejercicio 5

Representar en el formalismo **STRIPS** el siguiente dominio: hay dos habitaciones conectadas en una de las cuales hay N pelotas y un robot; el robot dispone de dos pinzas, con cada una de las cuales puede sujetar una sola pelota a la vez; se desea trasladar todas las pelotas a la otra habitación.

### Solución

- Predicados
  - **CONECTADAS(h_1, h_2)** - representa que las habitaciones $h_1$ y $h_2$ están conectadas.
  - **PELOTA_EN(p,h)** - representa que la pelota $p$ está en la habitación $h$
  - **ROBOT_EN(h)** - representa que el robot está en la habitación $h$
  - **PINZA_LIBRE(pinza)** - representa que la pinza $pinza$ está libre.
  - **PINZA_OCUPADA(pinza, p)** - representa que la pinza $pinza$ está ocupada con la pelota $p$.

- Esquema de acciones
  - **COGER($pinza, $p, $h)** - el robot coge una pelota $p con la pinza $pinza en la habotación $h.
    - precondiciones: PINZA_LIBRE($pinza), ROBOT_EN($h), PELOTA_EN($h)
    - lista de borrado: PINZA_LIBRE($pinza), PELOTA_EN($p,$h)
    - lista de adición: PINZA_OCUPADA($pinza, $p)
  - **SOLTAR($pinza, $p, $h)** - el robot suelta la pelota $p que sujeta con la pinza $pinza en la habotación $h.
    - precondiciones: ROBOT_EN($h), PINZA_OCUPADA($pinza, $p)
    - lista de borrado: PINZA_OCUPADA($pinza, $p)
    - lista de adición: PINZA_LIBRE($pinza), PELOTA_EN($p,$h)
  - **IR($h1,$h2)** - EL Robot va de la habitación $h1 a la habitación $h2
    - precondiciones: ROBOT_EN($h1), CONECTADAS($h1, $h2)
    - lista de borrado: ROBOT_EN($h1)
    - lista de adición: ROBOT_EN($h2)

**Estado inicial**

- PELOTA_EN(P_i,HABITACIÓN_1) con i en {1,2,..., N}
- ROBOT_EN(HABITACIÓN_1)
- PINZA_LIBRE(PINZA_1), PINZA_LIBRE(PINZA_2)
- CONECTADAS(HABITACIÓN_1, HABITACIÓN_2), CONECTADAS(HABITACIÓN_2, HABITACIÓN_1)

**Objetivo**

- PELOTA_EN(P_i,HABITACIÓN_2) con i en {1,2,..., N}

</div>

## Ejercicio 6

Representar en el formalismo **STRIPS** el siguiente dominio: hay varias ciudades, cada una de ellas conteniendo varias localizaciones, algunas de las cuales son aeropuertos; hay también camiones, que pueden moverse de una localización a otra dentro de una misma ciudad, y aviones, que pueden volar entre aeropuertos; el objetivo es transportar diversos paquetes de ciertas localizaciones de partida a ciertas localizaciones de llegada, que pueden estar en la misma o en otra ciudad.

### Solución

**HECHOS**

- **EN_CIUDAD(l,c)** - Representa que la localización 'l' está contenida en la ciudad 'c'.
- **ES_AEROPUERTO(l)** - Representa que la localización 'l' es un aeropuerto.
- **PAQUETE_EN(p,l)** - Representa que el paquete 'p' está en la localización 'l'.
- **VEHÍCULO_EN(v,l)** - Representa que el vehículo 'v' está en la localización 'l'.
- **CARGADO(p,v)** - Representa que le paquete 'p' está cargado en el vehiculo 'v'.
- **ES_AVIÓN(v)** - Representa que el vehículo 'v' es un avión.
- **ES_CAMIÓN(v)** - Representa que el vehículo 'v' es un camión.

**Esquemas de acciones**

- CARGAR(p,v,l)
  - precondiciones: PAQUETE_EN(p,l), VEHÍCULO_EN(v,l)
  - lista de borrado: PAQUETE_EN(p,l)
  - lista de adición: CARGADO(p,v)

- DESCARGAR(p,v,l)
  - precondiciones: CARGADO(p,v), VEHÍCULO_EN(v,l)
  - lista de borrado: CARGADO(p,v)
  - lista de adición: PAQUETE_EN(p,l)

- CONDUCIR(v, l1, l2)
  - precondiciones: CONECTADAS(l1,l2), ES_CAMIÓN(v), VEHÍCULO_EN(v,l1)
  - lista de borrado: VEHÍCULO_EN(v,l1)
  - lista de adición: VEHÍCULO_EN(v,l2)

- VOLAR(v, l1, l2)
  - precondiciones: ES_AVIÓN(v), VEHÍCULO_EN(v,l1), ES_AEROPUERTO(l1), ES_AEROPUERTO(l2)
  - lista de borrado: VEHÍCULO_EN(v,l1)
  - lista de adición: VEHÍCULO_EN(v,l2)

**Estado Incial - I**
Suponemos M ciudades, cada una de ellas con un número distinto de localizaciones N, y siendo CN el conjunto con todas las localizaciones posibles.
Suponemos P paquetes.
Suponemos K aeropuertos.

- CONTENIDA_EN(L_i, C_m) Para cada m en {1,2,....M}, tomamos i en {1,2,...N} siendo N el número de localizaciones en la ciudad 'm'.
- ES_AEROPUERTO(L_i) Para cada m en {1,2,....M}, tomamos i en {1,2,...K} siendo k el número de aeropuertos en la ciudad 'm'.
- CONECTADAS(L_i, L_j), para cada m en {1,2,...M}, tomamos i, j en {1,2,....N}, con i != j, siendo N el número de localizaciones en la ciudad 'm'.
- PAQUETE_EN(P_p, L_i), para cada p en {1,2,...P} y m en {1,2,...M}, tomamos i en {1,2,....N}, siendo N el número de localizaciones de salida en la ciudad 'm'.
- ES_AVIÓN(V_v), con v en {1,2,... V}, siendo V el número de aviones.
- ES_CAMIÓN(V_v), con v en {1,2,... C}, siendo C el número de camiones.
- VEHÍCULO_EN(V_v,L_i), para cada v en {1,2,...V} y m en {1,2,...M}, tomamos i en {1,2,....N}, siendo N el número de localizaciones en la ciudad 'm'.

**Estado objetivo - G**

- PAQUETE_EN(P_p, L_i), para cada p en {1,2,...P} y m en {1,2,...M}, tomamos i en {1,2,....N}, siendo N el número de localizaciones de llegada en la ciudad 'm'.

## Ejercicio 7

Consideremos la instancia del dominio del mundo de los bloques en la que hay dos bloques A y B, que inicialmente se hallan en la disposición A sobre la mesa y B sobre A, y que se pretenden llevar a una disposición en la que A esté sobre B.

Se pide obtener un plan relajado para el problema. Para ello aplicar el algoritmo voraz de cálculo de planes relajados, eligiendo en cada paso, de entre todas las acciones aplicables que proporcionen hechos nuevos, aquella cuyo nombre sea el primero por orden alfabético.

### Solución

**Estado inicial - I**: SOBRE_LA_MESA(A), SOBRE(B,A), DESPEJADO(B), BRAZO_LIBRE()
**Estado Objetivo - G**: SOBRE(A,B)

En el dominio estándar del mundo de los bloques, el sistema cuenta con **cuatro esquemas de acciones posibles** que modelan los movimientos del brazo robótico:

- **AGARRAR(b):** El brazo robótico coge el bloque `b` que se encuentra directamente apoyado sobre la mesa.
- **APILAR(b1, b2):** El brazo robótico deja el bloque `b1` (que tiene agarrado) colocándolo encima del bloque `b2`.
- **BAJAR(b):** El brazo robótico deja el bloque `b` (que tenía previamente agarrado) directamente sobre la mesa.
- **DESAPILAR(b1, b2):** El brazo robótico coge el bloque `b1` cuando este se encuentra apoyado encima del bloque `b2`.

**PLAN RELAJADO**:
-> DESAPILAR(B, A) -> { SOBRE_LA_MESA(A), SOBRE(B,A), DESPEJADO(B), BRAZO_LIBRE(), AGARRADO(B), DESPEJADO(A) }
-> AGARRAR(A) -> { SOBRE_LA_MESA(A), SOBRE(B,A), DESPEJADO(B), BRAZO_LIBRE(), AGARRADO(B), DESPEJADO(A), AGARRADO(A)}
-> APILAR(A,B) -> { SOBRE_LA_MESA(A), SOBRE(B,A), DESPEJADO(B), BRAZO_LIBRE(), AGARRADO(B), DESPEJADO(A), AGARRADO(A), SOBRE(A,B)}

## Ejercicio 8

Consideremos el problema del transporte de paquetes descrito en el tema. Se pide lo siguiente:

1.  Razonar cuál sería un plan solución óptimo del problema y calcular su coste.

Si algoritmos, solo razonando el plan óptimo es: ⟨ IR(C, L0, L1), CARGAR_PAQUETE(P, C, L1), IR(C, L1, L3), DESCARGAR_PAQUETE(P, C, L3), IR(C, L3, L1), IR(C, L1, L0) ⟩

2.  Determinar todos los posibles planes relajados para el estado inicial del problema y calcular el valor de la heurística $h^{+}$ para ese estado.

Para resolver este apartado, debemos aplicar la técnica de **relajación del borrado**. Esto implica que al ejecutar las acciones relajadas (indicadas con el superíndice $+$), estas solo añaden nuevos hechos al estado, pero **ningún hecho deja de cumplirse jamás**.

El estado inicial es $I = \{CAMI\acute{O}N\_EN(C, L_0), PAQUETE\_EN(P, L_1)\}$ y el objetivo es $G = \{CAMI\acute{O}N\_EN(C, L_0), PAQUETE\_EN(P, L_3)\}$ ``.

El detalle fundamental para resolver este ejercicio es darte cuenta de que, como los hechos nunca se borran, **el hecho objetivo $CAMI\acute{O}N\_EN(C, L_0)$ ya se cumple desde el principio** porque forma parte del estado inicial `. Por lo tanto, en el problema relajado **no es necesario planificar el viaje de vuelta** del camión; solo nos interesa lograr $PAQUETE\_EN(P, L_3)$ `.

Al aplicar el algoritmo voraz eligiendo acciones de todas las maneras posibles para alcanzar la meta, obtenemos distintas ramificaciones o **posibles planes relajados** :

**1. Plan relajado óptimo (Ruta directa):**
Se elige el camino más corto posible aprovechando la conexión directa entre $L_1$ y $L_3$.
`⟨ IR(C, L0, L1)⁺, CARGAR_PAQUETE(P, C, L1)⁺, IR(C, L1, L3)⁺, DESCARGAR_PAQUETE(P, C, L3)⁺ ⟩`
_Coste: 4 acciones._

**2. Plan relajado subóptimo (Ruta por L2):**
El algoritmo decide explorar moviendo el camión a través del lugar intermedio $L_2$.
`⟨ IR(C, L0, L1)⁺, CARGAR_PAQUETE(P, C, L1)⁺, IR(C, L1, L2)⁺, IR(C, L2, L3)⁺, DESCARGAR_PAQUETE(P, C, L3)⁺ ⟩`
_Coste: 5 acciones._

**3. Planes relajados con acciones irrelevantes (Derivados del algoritmo voraz ciego):**
Dado que el algoritmo voraz coge cualquier acción aplicable que aporte información nueva, puede generar múltiples combinaciones con acciones inútiles, como descargar el paquete en lugares intermedios para luego volver a cargarlo. Un ejemplo explícito de esto (detallado en la teoría) es:
`⟨ IR(C, L0, L1)⁺, CARGAR_PAQUETE(P, C, L1)⁺, DESCARGAR_PAQUETE(P, C, L0)⁺, IR(C, L1, L3)⁺, DESCARGAR_PAQUETE(P, C, L3)⁺ ⟩` ``.
_Coste: 5 o más acciones (dependiendo de cuántas acciones inútiles encadene)._

**Cálculo de la heurística $h^+$:**

Por definición, el valor de la heurística **$h^+(s)$ equivale al coste del plan relajado óptimo** (es decir, el de menor coste de entre todos los planes relajados posibles para ese estado).

Revisando todos los planes anteriores, el plan de menor coste es el "Plan relajado óptimo (Ruta directa)". Asumiendo un coste unitario de valor 1 para cada acción (estándar en planificación clásica), el cálculo es el siguiente:
**$h^+(I) = 1 + 1 + 1 + 1 = 4$**.

<div class="highlight-exercise">

## Ejercicio 9

Consideremos el siguiente problema de planificación automática:

- **Hechos:** $H\_i$ para $i=1,...,6$
- **Acciones:**

| Acción | Precondiciones | Lista de borrado   | Lista de adición    | Coste |
| :----- | :------------- | :----------------- | :------------------ | :---- |
| **A**  | $H\_5, H\_6$   | $H\_4, H\_5, H\_6$ | $H\_1, H\_2$        | 5     |
| **B**  | $H\_1, H\_6$   | $H\_1, H\_2, H\_6$ | $H\_3, H\_5$        | 1     |
| **C**  | $H\_2, H\_3$   | $H\_3, H\_6$       | $H\_1, H\_4, $H\_5$ | 3     |
| **D**  | $H\_1, H\_5$   | $H\_5, H\_6$       | $H\_3$              | 3     |
| **E**  | $H\_3, H\_5$   | $H\_2, H\_6$       | $H\_1, H\_4$        | 2     |

- **Estado inicial:** $H\_5, H\_6$
- **Objetivo:** $H\_1, H\_3, H\_4$

Se pide determinar todos los posibles planes relajados para el estado inicial del problema y calcular el valor de la heurística $h^+$ para ese estado.

<div class="nota">
Como lo que estás haciendo en realidad es una **búsqueda en árbol sobre el espacio de estados relajado**, la mejor forma de presentarlo es imitando esa estructura jerárquica.

Aquí tienes una propuesta de presentación **altamente visual, limpia y estructurada**, diseñada específicamente para sacar la máxima nota en tu examen de planificación:

</div>

### Solución propuesta para el Ejercicio 9

**Objetivo a alcanzar:** $G = \{H_1, H_3, H_4\}$
**Estado inicial relajado:** $S_0^+ = \{H_5, H_6\}$

---

#### 1. Árbol de Exploración de Planes Relajados

Representamos la búsqueda sistemática del algoritmo voraz en forma de árbol jerárquico. En cada nodo indicamos el conjunto acumulado de hechos $S^+$ y las acciones elegibles que aportan hechos nuevos:

- **Raíz ($S_0^+ = \{H_5, H_6\}$)**: La única acción aplicable que aporta hechos nuevos es la **Acción A** (pre: $\{H_5, H_6\}$).
  - **Aplicamos A** (coste 5) $\rightarrow$ **$S_1^+ = \{H_1, H_2, H_5, H_6\}$**.
  - _Desde aquí, las acciones aplicables que añaden nuevos hechos (buscando conseguir $H_3$) son **B** (pre: $\{H_1, H_6\}$) y **D** (pre: $\{H_1, H_5\}$). Esto abre dos ramas principales:_

##### **RAMA 1: Elegimos la Acción B** (coste 1)

- **Estado acumulado:** $S_{2.B}^+ = \{H_1, H_2, H_3, H_5, H_6\}$
- _Para conseguir el último objetivo restante ($H_4$), podemos aplicar **C** o **E**. Se abren dos soluciones:_
  - **Sub-rama C:** Aplicamos **C** (coste 3) $\rightarrow S_3^+ = \{H_1, H_2, H_3, H_4, H_5, H_6\}$ (Objetivos cumplidos).  
    $$\mathbf{P_1 = \langle A, B, C \rangle}$$
  - **Sub-rama E:** Aplicamos **E** (coste 2) $\rightarrow S_3^+ = \{H_1, H_2, H_3, H_4, H_5, H_6\}$ (Objetivos cumplidos).  
    $$\mathbf{P_3 = \langle A, B, E \rangle}$$

##### **RAMA 2: Elegimos la Acción D** (coste 3)

- **Estado acumulado:** $S_{2.D}^+ = \{H_1, H_2, H_3, H_5, H_6\}$
- _De igual forma, para conseguir $H_4$ podemos aplicar **C** o **E**:_
  - **Sub-rama C:** Aplicamos **C** (coste 3) $\rightarrow S_3^+ = \{H_1, H_2, H_3, H_4, H_5, H_6\}$ (Objetivos cumplidos).  
    $$\mathbf{P_2 = \langle A, D, C \rangle}$$
  - **Sub-rama E:** Aplicamos **E** (coste 2) $\rightarrow S_3^+ = \{H_1, H_2, H_3, H_4, H_5, H_6\}$ (Objetivos cumplidos).  
    $$\mathbf{P_4 = \langle A, D, E \rangle}$$

---

#### 2. Tabla de Evaluación de Planes Relajados y Selección de $h^+$

Una vez encontrados todos los caminos posibles en el árbol que satisfacen el objetivo, evaluamos sus costes de ejecución para determinar el plan óptimo:
| Identificador | Plan Relajado Secuencial $\langle a^+ \rangle$ | Desglose de Costes | Coste Total | ¿Es el óptimo ($h^+$)? |
| :-----------: | :--------------------------------------------- | :----------------: | :---------: | :--------------------: |
| **$P_1$** | $\langle A, B, C \rangle$ | $5 + 1 + 3$ | **9** | No |
| **$P_2$** | $\langle A, D, C \rangle$ | $5 + 3 + 3$ | **11** | No |
| **$P_3$** | $\langle A, B, E \rangle$ | $5 + 1 + 2$ | **8** | **Sí (Mínimo Coste)** |
| **$P_4$** | $\langle A, D, E \rangle$ | $5 + 3 + 2$ | **10** | No |

---

#### 3. Conclusión Final

El valor de la heurística $h^+$ para el estado inicial $I$ equivale al coste del **plan relajado óptimo** (el plan relajado de mínimo coste posible). Por lo tanto:

$$h^+(I) = \text{coste}(P_3) = \mathbf{8}$$

---

### ¿Por qué esta presentación es mucho mejor para tu examen?

1.  **Reduce el texto repetitivo:** En lugar de escribir "Paso 1, Paso 2, Paso 3" cuatro veces, la jerarquía visual del árbol muestra la herencia de los pasos de forma natural.
2.  **Es extremadamente fácil de corregir:** El corrector del examen puede comprobar de un solo vistazo la tabla de planes y el valor final de $h^+$. Si todo coincide, apenas tendrá que leer el resto y te pondrá la máxima nota de inmediato.
3.  **Evita errores de copia:** Al tener los planes limpios y agrupados en una tabla comparativa final, calcular los costes y compararlos es un proceso visual sencillísimo en el que no cometerás erratas de cálculo.

</div>

## Ejercicio 10

Consideremos el siguiente problema de planificación automática:

- **Hechos:** $H\_i$ para $i=1,...,9$
- **Acciones:**

| Acción | Precondiciones     | Lista de borrado | Lista de adición   | Coste |
| :----: | :----------------- | :--------------- | :----------------- | :---: |
| **A**  | $H\_9$             | $H\_2$           | $H\_3, H\_5, H\_8$ |   1   |
| **B**  | $H\_1, H\_6, H\_8$ | $H\_4$           | $H\_9$             |   3   |
| **C**  | $H\_3$             | $H\_3, H\_5$     | $H\_4, H\_6, H\_8$ |   4   |
| **D**  | $H\_1, H\_2, H\_3$ | $H\_1, H\_2$     | $H\_6$             |   5   |
| **E**  | $H\_1$             | $H\_1, H\_2$     | $H\_6$             |   0   |

- **Estado inicial:** ${H\_1}$
- **Objetivo:** ${H\_2, H\_5, H\_8}$

Para cada estado $s$ siguiente se pide determinar todos los posibles planes relajados para $s$ y calcular el valor de $h^+(s)$:

1.  ${H\_1, H\_2, H\_3}$
2.  ${H\_1, H\_3, H\_6, H\_8}$

### Solución

Empecemos por el estado incicial 1. s = ${H\_1, H\_2, H\_3}$

- S^+ = ${H\_1, H\_2, H\_3}$, acciones candidatas (Aportan hechos nuevos a <S^+> y cumplen las precondiciones) -> { C, D, E }
- Añadimos C a a^+ -> a^+ = { **C** }, y S^+ = ${H\_1, H\_2, H\_3, H\_4, H\_6, H\_8}$ -> acciones candidatas -> { B }
- Añadimos B a a^+ -> a^+ = { **C**, **B** }, y S^+ = ${H\_1, H\_2, H\_3, H\_4, H\_6, H\_8, H\_9}$ -> acciones candidatas -> { A }
- Añadimos A a a^+ -> a^+ = { **C**, **B**, **A** }, y S^+ = ${H\_1, H\_2, H\_3, H\_4, H\_5, H\_6, H\_8, H\_9}$ -> este estado contiene al objetivo, por lo tanto el primer plan relajado P_1 = < **C**, **B**, **A** >

- S^+ = ${H\_1, H\_2, H\_3}$, acciones candidatas (Aportan hechos nuevos a <S^+> y cumplen las precondiciones) -> { C, D, E }
- Añadimos D a a^+ -> a^+ = { **D** }, y S^+ = ${H\_1, H\_2, H\_3, H\_6}$ -> acciones candidatas -> { C }
- Añadimos C a a^+ -> a^+ = { **D**, **C** }, y S^+ = ${H\_1, H\_2, H\_3, H\_4, H\_6, H\_8}$ -> acciones candidatas -> { B }
- Añadimos B a a^+ -> a^+ = { **D**, **C**, **B** }, y S^+ = ${H\_1, H\_2, H\_3, H\_4, H\_6, H\_8, H\_9}$ -> acciones candidatas -> { A }
- Añadimos A a a^+ -> a^+ = { **D**, **C**, **B**, **A** }, y S^+ = ${H\_1, H\_2, H\_3, H\_4, H\_5, H\_6, H\_8, H\_9}$ -> este estado contiene al objetivo, por lo tanto el primer plan relajado P_2 = < **D**, **C**, **B**, **A** >

- S^+ = ${H\_1, H\_2, H\_3}$, acciones candidatas (Aportan hechos nuevos a <S^+> y cumplen las precondiciones) -> { C, D, E }
- Añadimos E a a^+ -> a^+ = { **E** }, y S^+ = ${H\_1, H\_2, H\_3, H\_6}$ -> acciones candidatas -> { C }
- Añadimos C a a^+ -> a^+ = { **E**, **C** }, y S^+ = ${H\_1, H\_2, H\_3, H\_4, H\_6, H\_8}$ -> acciones candidatas -> { B }
- Añadimos B a a^+ -> a^+ = { **E**, **C**, **B** }, y S^+ = ${H\_1, H\_2, H\_3, H\_4, H\_6, H\_8, H\_9}$ -> acciones candidatas -> { A }
- Añadimos A a a^+ -> a^+ = { **E**, **C**, **B**, **A** }, y S^+ = ${H\_1, H\_2, H\_3, H\_4, H\_5, H\_6, H\_8, H\_9}$ este estado contiene al objetivo, por lo tanto el primer plan relajado P_3 = < **E**, **C**, **B**, **A** >

Calculemos los costes para encontrar h^+ como aquél plan con coste mínimo.

P_1 = 4 + 3 + 1 = 8
P_2 = 5 + 4 + 3 + 1 = 13
P_3 = 0 + 4 + 3 + 1 = 8

Tanto P_1 como P_3 podemos tomarlo como h^+, es este caso, tomamos P_1 por tener menor número de acciones

--

Seguimos con el segundo estado 2. s = ${H\_1, H\_3, H\_6, H\_8}$

Como $H\_2$ no estáen ninguna lista de adición, nunca vamos a llegar a obtener un estado S^+ que contenga al estado objetivo, por lo que el algoritmo voraz nunca encontrara un plan relajado.

La consecuencia teórica y matemática de tu deducción, y lo que cierra el ejercicio de forma sobresaliente, es que cuando no existe un plan relajado para un estado, el valor de la heurística estimada tiende a infinito. Por lo tanto, la respuesta final a este apartado es h^+(s)=+∞

<div class="highlight-exercise">

## Ejercicio 11

Consideremos el siguiente problema de planificación automática:

- **Hechos:** $H\_i$ para $i=1,...,5$.
- **Acciones:**

| Acción | Precondiciones | Lista de borrado | Lista de adición | Coste |
| :----- | :------------- | :--------------- | :--------------- | :---- |
| **A**  | $H\_5$         | $H\_4$           | $H\_3$           | 0     |
| **B**  | $H\_3$         | $H\_1$           | $H\_4, H\_5$     | 4     |
| **C**  | $H\_5$         | $H\_5$           | $H\_3$           | 2     |
| **D**  | $H\_5$         | $H\_3$           | $H\_2, H\_4$     | 2     |
| **E**  | $H\_2$         | $H\_3$           | $H\_1, H\_5$     | 1     |

- **Estado inicial:** ${H\_2, H\_3}$
- **Objetivo:** ${H\_1, H\_4, H\_5}$

Se pide calcular, mediante el algoritmo de programación dinámica, el valor de $h^{max}$ y de $h^{add}$ para el estado inicial del problema.

### Solución

Para resolver el **Ejercicio 11**, vamos a aplicar el algoritmo de programación dinámica paso a paso.

Antes de empezar, hay un detalle matemático clave en este problema: **todas las acciones del dominio (A, B, C, D, E) tienen exactamente una única precondición**. Como el coste de las precondiciones es el máximo (para $h^{max}$) o la suma (para $h^{add}$) de los costes de los hechos individuales, al haber solo un hecho en cada precondición, **la tabla de costes calculada será exactamente idéntica para ambas heurísticas**. La única diferencia radicará en el cálculo final sobre el conjunto objetivo.

El estado inicial es $I = \{H_2, H_3\}$ y el objetivo es $G = \{H_1, H_4, H_5\}$.

**Paso 0: Inicialización ($T_0$)**
Asignamos coste 0 a los hechos del estado inicial y $\infty$ al resto.

- $T_0(H_1) = \infty$
- $T_0(H_2) = 0$
- $T_0(H_3) = 0$
- $T_0(H_4) = \infty$
- $T_0(H_5) = \infty$

**Paso 1: Iteración 1 ($T_1$)**
Evaluamos cuánto costaría aplicar las acciones basándonos en $T_0$:

- **Acción A** (pre: $H_5$): Coste base = $T_0(H_5) + 0 = \infty + 0 = \infty$
- **Acción B** (pre: $H_3$): Coste base = $T_0(H_3) + 4 = 0 + 4 = 4$. (Añade $H_4$ y $H_5$).
- **Acción C** (pre: $H_5$): Coste base = $T_0(H_5) + 2 = \infty + 2 = \infty$
- **Acción D** (pre: $H_5$): Coste base = $T_0(H_5) + 2 = \infty + 2 = \infty$
- **Acción E** (pre: $H_2$): Coste base = $T_0(H_2) + 1 = 0 + 1 = 1$. (Añade $H_1$ y $H_5$).

Actualizamos los costes mínimos para cada hecho ($T_1$):

- $T_1(H_1) = \min(\infty, 1 \text{ [por E]}) = 1$
- $T_1(H_2) = \min(0, \infty) = 0$
- $T_1(H_3) = \min(0, \infty) = 0$
- $T_1(H_4) = \min(\infty, 4 \text{ [por B]}) = 4$
- $T_1(H_5) = \min(\infty, 1 \text{ [por E]}, 4 \text{ [por B]}) = 1$

**Paso 2: Iteración 2 ($T_2$)**
Repetimos el proceso usando los nuevos valores de $T_1$:

- **Acción A** (pre: $H_5$): Coste base = $T_1(H_5) + 0 = 1 + 0 = 1$. (Añade $H_3$).
- **Acción B** (pre: $H_3$): Coste base = $T_1(H_3) + 4 = 0 + 4 = 4$. (Añade $H_4$ y $H_5$).
- **Acción C** (pre: $H_5$): Coste base = $T_1(H_5) + 2 = 1 + 2 = 3$. (Añade $H_3$).
- **Acción D** (pre: $H_5$): Coste base = $T_1(H_5) + 2 = 1 + 2 = 3$. (Añade $H_2$ y $H_4$).
- **Acción E** (pre: $H_2$): Coste base = $T_1(H_2) + 1 = 0 + 1 = 1$. (Añade $H_1$ y $H_5$).

Actualizamos de nuevo:

- $T_2(H_1) = \min(1, 1 \text{ [por E]}) = 1$
- $T_2(H_2) = \min(0, 3 \text{ [por D]}) = 0$
- $T_2(H_3) = \min(0, 1 \text{ [por A]}, 3 \text{ [por C]}) = 0$
- $T_2(H_4) = \min(4 \text{ [anterior]}, 4 \text{ [por B]}, 3 \text{ [por D]}) = 3$ _(El coste baja porque ahora D es aplicable)_.
- $T_2(H_5) = \min(1 \text{ [anterior]}, 4 \text{ [por B]}, 1 \text{ [por E]}) = 1$

**Paso 3: Iteración 3 ($T_3$)**
Si recalculamos basándonos en $T_2$:

- $C_A = 1+0=1$, $C_B = 0+4=4$, $C_C = 1+2=3$, $C_D = 1+2=3$, $C_E = 0+1=1$.
  Al buscar los mínimos, ningún coste logra superar los registros anteriores. Como $T_3 = T_2$, **el algoritmo se estabiliza y termina**.

Los costes definitivos para alcanzar cada hecho son: **$\{H_1=1, H_2=0, H_3=0, H_4=3, H_5=1\}$**.

**Cálculo final de las heurísticas**
Sabiendo que nuestro objetivo global es $G = \{H_1, H_4, H_5\}$, aplicamos las fórmulas correspondientes:

- Para **$h^{max}$**, se asume que basta con el coste del objetivo más caro:
  $h^{max}(I) = \max(T(H_1), T(H_4), T(H_5)) = \max(1, 3, 1)$
  **$h^{max}(I) = 3$**

- Para **$h^{add}$**, se asume que los objetivos son independientes y se suman todos sus costes:
  $h^{add}(I) = T(H_1) + T(H_4) + T(H_5) = 1 + 3 + 1$
  **$h^{add}(I) = 5$**

</div>

<div class="highlight-exercise">

## Ejercicio 12

Consideremos el siguiente problema de planificación automática:

- **Hechos:** $H\_i$ para $i=1,...,6$.
- **Acciones:**

| Acción | Precondiciones | Lista de borrado |  Lista de adición  | Coste |
| :----: | :------------: | :--------------: | :----------------: | :---: |
| **A**  |     $H\_1$     |      $H\_1$      |    $H\_3, H\_4$    |   3   |
| **B**  |  $H\_3, H\_4$  |      $H\_4$      | $H\_2, H\_5, H\_6$ |   2   |
| **C**  |     $H\_4$     |      $H\_5$      |    $H\_3, H\_6$    |   2   |
| **D**  |     $H\_2$     |      $H\_1$      | $H\_4, H\_5, H\_6$ |   3   |
| **E**  |  $H\_4, H\_6$  |      $H\_3$      | $H\_1, H\_2, H\_5$ |   3   |
| **F**  |     $H\_3$     |      $H\_3$      | $H\_1, H\_2, H\_6$ |   3   |

- **Estado inicial:** ${H\_2}$
- **Objetivo:** ${H\_3, H\_4, H\_5}$

Se pide calcular, mediante el algoritmo de programación dinámica, el valor de $h^{max}$ y de $h^{add}$ para el estado inicial del problema.

### Solución

Empecemos por $h^{max}$
**Paso 1: Iteración 1 ($T_0$)**

- Inicializamos la tabla dinámica de costes ($T_0$), asignamos coste 0 a los hechos del estado inicial y $\infty$ al resto.

$T_0(H_1)$ = $\infty$
$T_0(H_2)$ = 0
$T_0(H_3)$ = $\infty$
$T_0(H_4)$ = $\infty$
$T_0(H_5)$ = $\infty$
$T_0(H_6)$ = $\infty$

#### Paso 1: Iteración 1 ($T_1$)

**Evaluamos cuánto costaría aplicar las acciones basándonos en $T_0$**

- **Acción A** (pre: $H_1$): Coste base = $T_0(H_1)$ + 3 = $\infty$ + 3 = $\infty$
- **Acción B** (pre: $H_3$ y $H_4$): Coste base = $\max(T_0(H_3), T_0(H_4)) + 2 = \infty + 2 = \infty$
- **Acción C** (pre: $H_4$): Coste base = $\infty$ + 2 = $\infty$
- **Acción D** (pre: $H_2$): Coste base = 0 + 3 = 3 **Añade $H\_4, H\_5, H\_6$**
- **Acción E** (pre: $H_4$ y $H_6$): Coste base = $\max(T_0(H_4), T_0(H_6)) + 3 = $\infty$ + 3 = $\infty$
- **Acción F** (pre: $H_3$): Coste base = $\infty$ + 3 = $\infty$

**Actualizamos los costes mínimos para cada hecho ($T_1$)**

- $T_1(H_1) = \min(\infty, \infty) = \infty$
- $T_1(H_2) = \min(0, \infty) = 0$
- $T_1(H_3) = \min(\infty, \infty) = \infty$
- $T_1(H_4) = \min(\infty, 3 \text{ [por D]}) = 3$
- $T_1(H_5) = \min(\infty, 3 \text{ [por D]}) = 3$
- $T_1(H_6) = \min(\infty, 3 \text{ [por D]}) = 3$

#### Paso 2: Iteración 2 ($T_2$)

**Evaluamos cuánto costaría aplicar las acciones basándonos en $T_1$ y Actualizamos los costes mínimos para cada hecho ($T_2$)**

Para todos los hechos ($H_1$ a $H_6$), manteniendo estrictamente tu estructura de desglose y aplicando la notación dual unificada `[h^max, h^add]`, queda de la siguiente manera:

- **$T_2(H_1)$**:
  - Acciones que añaden $H_1$: E (pre: $H_4$ y $H_6$ y coste 3) y F (pre: $H_3$ y coste 3)
  - Miramos los costes acumulados de los hechos $H_4$ y $H_6$ para E, y de $H_3$ para F en $T_1$: **$T_1(H_4) = 3$, $T_1(H_6) = 3$, $T_1(H_3) = \infty$**
  - Coste acción F ($h^{max}$ y $h^{add}$): $T_1(H_3) + 3 = \infty + 3 = \infty$
  - Coste acción E: (como hay dos precondiciones, tomamos el máximo y la suma de sus costes)
    - $h^{max}$ = $\max(T_1(H_4), T_1(H_6)) + 3 = \max(3, 3) + 3 = 6$
    - $h^{add}$ = $(T_1(H_4) + T_1(H_6)) + 3 = (3 + 3) + 3 = 9$
      **Por último actualizamos la tabla para $H_1$** -> $T_2(H_1):
    - h^{max} = \min($T_1(H_1), Coste de E, Coste de F$) = \min(\infty, 6, \infty) = 6
    - h^{add} = \min($T_1(H_1), Coste de E, Coste de F$) = \min(\infty, 9, \infty) = 9$
  **En nuestro formato unificado, $T_2(H_1) = [6, 9]$\*\*

- **$T_2(H_2)$**:
  - Acciones que añaden $H_2$: D (pre: $H_2$ y coste 3) y E (pre: $H_4$ y $H_6$ y coste 3)
  - Miramos los costes acumulados de los hechos $H_2$ para D, y de $H_4$ y $H_6$ para E en $T_1$: **$T_1(H_2) = 0$, $T_1(H_4) = 3$, $T_1(H_6) = 3$**
  - Coste acción D ($h^{max}$ y $h^{add}$): $T_1(H_2) + 3 = 0 + 3 = 3$
  - Coste acción E:
    - $h^{max}$ = $\max(T_1(H_4), T_1(H_6)) + 3 = \max(3, 3) + 3 = 6$
    - $h^{add}$ = $(T_1(H_4) + T_1(H_6)) + 3 = (3 + 3) + 3 = 9$
      **Por último actualizamos la tabla para $H_2$** -> $T_2(H_2):
    - h^{max} = \min($T_1(H_2), Coste de D, Coste de E$) = \min(0, 3, 6) = 0
    - h^{add} = \min($T_1(H_2), Coste de D, Coste de E$) = \min(0, 3, 9) = 0$
  **En nuestro formato unificado, $T_2(H_2) = [0, 0]$\*\*

- **$T_2(H_3)$**:
  - Acciones que añaden $H_3$: A (pre: $H_1$ y coste 3) y C (pre: $H_4$ y coste 2).
  - Por A, miramos los costes acumulados de $H_1$ en $T_1$: **$T_1(H_1) = \infty$**, y por C, miramos los costes acumulados de $H_4$ en $T_1$: **$T_1(H_4) = 3$**
  - Coste acción A ($h^{max}$ y $h^{add}$): $T_1(H_1) + 3 = \infty + 3 = \infty$
  - Coste acción C: ($h^{max}$ y $h^{add}$): $T_1(H_4) + 2 = 3 + 2 = 5$
    **Por último actualizamos la tabla para $H_3$** -> $T_2(H_3):
    - h^{max} = \min($T_1(H_3), Coste de A, Coste de C$) = \min(\infty, \infty, 5) = 5
    - h^{add} = \min($T_1(H_3), Coste de A, Coste de C$) = \min(\infty, \infty, 5) = 5$
      **En nuestro formato unificado, $T_2(H_3) = [5, 5]**
- **$T_2(H_4)$**:
  - Acciones que añaden $H_4$: A (pre: $H_1$ y coste 3) y D (pre: $H_2$ y coste 3)
  - Costes acumulados:
    - Por A: $T_1(H_1) = \infty$, coste acción A = $\infty + 3 = \infty$
    - Por D: $T_1(H_2) = 0$, coste acción D = $0 + 3 = 3$
    <div class="nota">
      <b>Recuerda:</b> Si solo tenemos una precondición, los costes acumulados de $h^{max}$ y $h^{add}$ son iguales, por lo que no es necesario calcularlos por separado.
    </div>

  **Por último actualizamos la tabla para $H_4$** -> $T_2(H_4):
  - h^{max} = \min($T_1(H_4), Coste de A, Coste de D$) = \min(3, \infty, 3) = 3
  - h^{add} = \min($T_1(H_4), Coste de A, Coste de D$) = \min(3, \infty, 3) = 3$
    **En nuestro formato unificado, $T_2(H_4) = [3, 3]**

- **$T_2(H_5)$**:
  - Acciones que añaden $H_5$: B (pre: ($H_3$ y $H_4$) y coste 2), D (pre: $H_2$ y coste 3) y E (pre: $H_4$ y $H_6$ y coste 3)
  - Miramos los costes acumulados:
  <div class="nota">
    <b>Recuerda:</b> Si tenemos más de una precondición, los costes acumulados de $h^{max}$ y $h^{add}$ se evalúan separadamente, el primero toma el valor máximo y el segundo la suma de los costes.
  </div>
  - Por B:
    - $h^{max}$ = $\max(T_1(H_3), T_1(H_4)) + 2 = \max(\infty, 3) + 2 = \infty$
    - $h^{add}$ = $(T_1(H_3) + T_1(H_4)) + 2 = (\infty + 3) + 2 = \infty$
  - Por D: $T_1(H_2) + 2 = 0 + 3 = 3$ (para ambos $h^{max}$ y $h^{add}$)
  - Por E:
    - $h^{max}$ = $\max(T_1(H_4), T_1(H_6)) + 3 = \max(3, 3) + 3 = 6$
    - $h^{add}$ = $(T_1(H_4) + T_1(H_6)) + 3 = (3 + 3) + 3 = 9$

  **Por último actualizamos la tabla para $H_5$** -> $T_2(H_5):
  - h^{max} = \min($T_1(H_5), Coste de B, Coste de D, Coste de E$) = \min(\infty, \infty, 3, 6) = 3
  - h^{add} = \min($T_1(H_5), Coste de B, Coste de D, Coste de E$) = \min(\infty, \infty, 3, 9) = 3$
    **En nuestro formato unificado, $T_2(H_5) = [3, 3]**

- **$T_2(H_6)$**:
  - Acciones que añaden $H_6$: B (pre: ($H_3$ y $H_4$) y coste 2), C (pre: $H_4$ y coste 2), D (pre: $H_2$ y coste 3) y F (pre: $H_3$ y coste 3)
  - Miramos los costes acumulados:
    - Por B:
      - $h^{max}$ = $\max(T_1(H_3), T_1(H_4)) + 2 = \max(\infty, 3) + 2 = \infty$
      - $h^{add}$ = $(T_1(H_3) + T_1(H_4)) + 2 = (\infty + 3) + 2 = \infty$
    - Por C: $T_1(H_4) + 2 = 3 + 2 = 5$ (para ambos $h^{max}$ y $h^{add}$)
    - Por D: $T_1(H_2) + 3 = 0 + 3 = 3$ (para ambos $h^{max}$ y $h^{add}$)
    - Por F: $T_1(H_3) + 3 = \infty + 3 = \infty$ (para ambos $h^{max}$ y $h^{add}$)

  **Por último actualizamos la tabla para $H_6$** -> $T_2(H_6):
  - h^{max} = \min($T_1(H_6), Coste de B, Coste de C, Coste de D, Coste de F$) = \min(\infty, \infty, 5, 3, \infty) = 3
  - h^{add} = \min($T_1(H_6), Coste de B, Coste de C, Coste de D, Coste de F$) = \min(\infty, \infty, 5, 3, \infty) = 3$

**Resultado de la iteración 2 ($T_2$)**

- $T_2(H_1) = [6, 9]$
- $T_2(H_2) = [0, 0]$
- $T_2(H_3) = [5, 5]$
- $T_2(H_4) = [3, 3]$
- $T_2(H_5) = [3, 3]$
- $T_2(H_6) = [3, 3]$

#### Paso 3: Iteración 3 ($T_3$)

- **T_3(H_1)**:
  - Acciones que añaden $H_1$: E (pre: $H_4$ y $H_6$ y coste 3) y F (pre: $H_3$ y coste 3)
  - Miramos los costes acumulados de los hechos $H_4$ y $H_6$ para E, y de $H_3$ para F en $T_2$: **$T_2(H_4) = 3$, $T_2(H_6) = 3$, $T_2(H_3) = 5$**
  - Coste acción F ($h^{max}$ y $h^{add}$): $T_2(H_3) + 3 = 5 + 3 = 8$
  - Coste acción E:
    - $h^{max}$ = $\max(T_2(H_4), T_2(H_6)) + 3 = \max(3, 3) + 3 = 6$
    - $h^{add}$ = $(T_2(H_4) + T_2(H_6)) + 3 = (3 + 3) + 3 = 9$
      **Por último actualizamos la tabla para $H_1$** -> $T_3(H_1):
    - h^{max} = \min($T_2(H_1), Coste de E, Coste de F$) = \min(6, 6, 8) = 6
    - h^{add} = \min($T_2(H_1), Coste de E, Coste de F$) = \min(9, 9, 8) = 8$
      **En nuestro formato unificado, $T_3(H_1) = [6, 8]$\*\*

Para completar formalmente el **Ejercicio 12** y demostrar en el examen que has llegado a la estabilización de la tabla, aquí tienes el desglose detallado de los cálculos que faltan para el resto de los hechos en la **Iteración 3 ($T_3$)**, la comprobación de parada en la **Iteración 4 ($T_4$)** y el cálculo de los valores heurísticos finales.

---

### Paso 1: Completar la Iteración 3 ($T_3$) para el resto de hechos

Dado que ya calculaste con total precisión que $T_3(H_1) =$, evaluamos el resto de hechos basándonos en la columna anterior ($T_2$):

- **$T_3(H_2)$:**
  - Acciones que añaden $H_2$: B, E y F.
  - Costes de las acciones en $T_2$:
    - Por B ($h^{max}$): $\max(T_2(H_3), T_2(H_4)) + 2 = \max(5, 3) + 2 = 7$.
    - Por B ($h^{add}$): $(T_2(H_3) + T_2(H_4)) + 2 = (5 + 3) + 2 = 10$.
    - Por E ($h^{max}$): $\max(T_2(H_4), T_2(H_6)) + 3 = \max(3, 3) + 3 = 6$.
    - Por E ($h^{add}$): $(T_2(H_4) + T_2(H_6)) + 3 = (3 + 3) + 3 = 9$.
    - Por F ($h^{max}$ y $h^{add}$): $T_2(H_3) + 3 = 5 + 3 = 8$.
  - Actualizamos la celda:
    - $h^{max} = \min(T_2(H_2), 7, 6, 8) = \min(0, 6) = 0$.
    - $h^{add} = \min(T_2(H_2), 10, 9, 8) = \min(0, 8) = 0$.
  - **En formato unificado: $T_3(H_2) = $**

- **$T_3(H_3)$:**
  - Acciones que añaden $H_3$: A y C.
  - Costes de las acciones en $T_2$:
    - Por A ($h^{max}$): $T_2(H_1) + 3 = 6 + 3 = 9$.
    - Por A ($h^{add}$): $T_2(H_1) + 3 = 9 + 3 = 12$.
    - Por C ($h^{max}$ y $h^{add}$): $T_2(H_4) + 2 = 3 + 2 = 5$.
  - Actualizamos la celda:
    - $h^{max} = \min(T_2(H_3), 9, 5) = \min(5, 5) = 5$.
    - $h^{add} = \min(T_2(H_3), 12, 5) = \min(5, 5) = 5$.
  - **En formato unificado: $T_3(H_3) =$**

- **$T_3(H_4)$:**
  - Acciones que añaden $H_4$: A y D.
  - Costes de las acciones en $T_2$:
    - Por A ($h^{max}$): $T_2(H_1) + 3 = 9$.
    - Por A ($h^{add}$): $T_2(H_1) + 3 = 12$.
    - Por D ($h^{max}$ y $h^{add}$): $T_2(H_2) + 3 = 0 + 3 = 3$.
  - Actualizamos la celda:
    - $h^{max} = \min(T_2(H_4), 9, 3) = \min(3, 3) = 3$.
    - $h^{add} = \min(T_2(H_4), 12, 3) = \min(3, 3) = 3$.
  - **En formato unificado: $T_3(H_4) =$**

- **$T_3(H_5)$:**
  - Acciones que añaden $H_5$: B, D y E.
  - Costes de las acciones en $T_2$:
    - Por B: $7$ ($h^{max}$) / $10$ ($h^{add}$).
    - Por D: $3$ (para ambas).
    - Por E: $6$ ($h^{max}$) / $9$ ($h^{add}$).
  - Actualizamos la celda:
    - $h^{max} = \min(T_2(H_5), 7, 3, 6) = \min(3, 3) = 3$.
    - $h^{add} = \min(T_2(H_5), 10, 3, 9) = \min(3, 3) = 3$.
  - **En formato unificado: $T_3(H_5) =$**

- **$T_3(H_6)$:**
  - Acciones que añaden $H_6$: B, C, D y F.
  - Costes de las acciones en $T_2$:
    - Por B: $7$ ($h^{max}$) / $10$ ($h^{add}$).
    - Por C: $5$ (para ambas).
    - Por D: $3$ (para ambas).
    - Por F: $8$ (para ambas).
  - Actualizamos la celda:
    - $h^{max} = \min(T_2(H_6), 7, 5, 3, 8) = \min(3, 3) = 3$.
    - $h^{add} = \min(T_2(H_6), 10, 5, 3, 8) = \min(3, 3) = 3$.
  - **En formato unificado: $T_3(H_6) =$**

---

### Paso 2: Iteración 4 ($T_4$) y Estabilización

Como muy bien identificaste, al haber cambiado un coste en la columna anterior ($H_1$ bajó a $8$ en $h^{add}$), el algoritmo nos obliga a realizar la columna $T_4$ para demostrar que ya no hay más cambios:

1.  **Evaluamos la Acción A en $T_3$:**
    Dado que $T_3(H_1) =$, su coste base baja ligeramente para $h^{add}$:
    - $h^{max} = 6 + 3 = 9$
    - $h^{add} = T_3(H_1) + 3 = 8 + 3 = 11$
2.  **Actualizamos $T_4(H_3)$:**
    - $h^{add} = \min(T_3(H_3), \text{Coste A}, \text{Coste C}) = \min(5, 11, 5) = \mathbf{5}$. No se altera.
3.  **Comprobamos el resto de hechos:** Ningún otro cálculo se ve afectado por el cambio de $H_1$, por lo que todos los costes de los hechos se mantienen idénticos a los de $T_3$.

Dado que **$T_4 = T_3$**, el algoritmo de programación dinámica se detiene oficialmente por **estabilización de la tabla**.

---

### Paso 3: Cálculo de las Heurísticas para el Estado Inicial ($I$)

El objetivo establecido para este problema es el conjunto de hechos **$G = \{H_3, H_4, H_5\}$**. Una vez estabilizada nuestra tabla de hechos, extraemos los costes individuales correspondientes de la columna final:

- $T(H_3) =$
- $T(H_4) =$
- $T(H_5) =$

Aplicamos las definiciones de cada heurística para obtener las estimaciones finales:

- **Para $h^{max}(I)$:** Asume que el coste para lograr un conjunto de metas es el del hecho individual más costoso:
  $$h^{max}(I) = \max( T(H_3), T(H_4), T(H_5) )$$
  $$h^{max}(I) = \max( 5, 3, 3 ) = \mathbf{5}$$

- **Para $h^{add}(I)$:** Asume que las metas son independientes y se deben lograr sumando todos sus costes individuales:
  $$h^{add}(I) = T(H_3) + T(H_4) + T(H_5)$$
  $$h^{add}(I) = 5 + 3 + 3 = \mathbf{11}$$

</div>

<div class="summary">

¡Has planteado dos dudas excelentes que suelen ser los puntos conflictivos típicos al preparar este tema para el examen! Vamos a resolverlas con total precisión matemática y metodológica:

### 1. ¿Para qué sirve registrar los hechos que se añaden al estado inicial?

Registrar qué hechos "añade" cada acción que se vuelve aplicable en una iteración tiene una utilidad tanto teórica como extremadamente práctica para ahorrar tiempo en el examen:

- **Utilidad metodológica (en el examen):** El algoritmo de programación dinámica te obliga a calcular para cada hecho $g$ el valor $T_i^s(g) = \min(T_{i-1}^s(g), c_g)$ . Si tuvieras que revisar todas las acciones del problema para cada una de las celdas en cada iteración, tardarías una eternidad. Al anotar que la **Acción D** es la única que ha "desbloqueado" un coste finito (coste 3) y que añade $\{H_4, H_5, H_6\}$, sabes de golpe que **solo los hechos $H_4, H_5, H_6$ pueden cambiar su coste** en esta iteración. El resto de hechos ($H_1, H_3$) seguirán siendo $\infty$ sin necesidad de que pierdas tiempo recalculándolos.

- **Utilidad teórica:** Permite hacer un seguimiento de la "frontera de alcanzabilidad" en el problema relajado. Te dice qué nuevos hechos de la base de datos se vuelven "accesibles" (pasan de coste $\infty$ a un coste finito) gracias a las acciones que has podido activar con los recursos del estado anterior.

---

### 2. ¿Cuando hay más de un hecho como pre-condición, además del máximo, no deberíamos calcular la suma en vista de calcular $h^+$?

Aquí hay una **confusión conceptual muy común** entre las heurísticas $h^{max}$, $h^{add}$ y $h^+$ que debes separar claramente en tus apuntes:

- **La heurística $h^+$ NO se calcula con la tabla de programación dinámica:** El valor de $h^+(s)$ representa el coste de un _plan relajado óptimo_. La única forma de calcular $h^+(s)$ de forma exacta es aplicando el algoritmo voraz explorando **todas las ramas posibles** (todas las combinaciones de acciones), medir el coste de cada plan relajado válido y quedarte con el mínimo . Como este cálculo es de coste exponencial (NP-difícil), en la práctica no se usa una tabla para él [Excerpt 87, 91].
- **La tabla sirve para aproximar $h^+$ a través de $h^{max}$ y $h^{add}$ [Excerpt 91]:** Dado que el Ejercicio 12 te pide calcular expresamente tanto $h^{max}$ como $h^{add}$, **sí, debes calcular la suma de las precondiciones, pero únicamente para rellenar la tabla de $h^{add}$**.

Para tu examen, la regla de oro para combinar precondiciones en tus tablas es:

1.  **Si estás calculando la tabla de $h^{max}$:** Para cualquier acción con múltiples precondiciones, calculas su coste utilizando el **máximo** de los costes de sus precondiciones en la iteración anterior [Excerpt 88].
    $$c_{pre(a)} = \max(T_{i-1}(g') \mid g' \in pre(a))$$
2.  **Si estás calculando la tabla de $h^{add}$:** Para esa misma acción, calculas su coste utilizando la **suma** de los costes de sus precondiciones.
    $$c_{pre(a)} = \sum_{g' \in pre(a)} T_{i-1}(g')$$

#### ¿Cómo se traduce esto a tu ejercicio 12?

En la iteración 1 ($T_1$) que has escrito, como todos los valores de las precondiciones de las acciones con más de una variable ($H_3$, $H_4$, $H_6$) parten de $\infty$ en $T_0$, el resultado de la suma y del máximo coincide ($\infty + \infty = \infty$ y $\max(\infty, \infty) = \infty$).

Pero en las siguientes iteraciones, cuando esos hechos tomen valores numéricos (por ejemplo, si en $T_1$ ya tienes que $H_4=3$ y $H_6=3$), verás la diferencia al evaluar la **Acción E** (pre: $H_4$ y $H_6$; coste: 3):

- En la tabla de **$h^{max}$**: $c_{pre(E)} = \max(3, 3) = 3$. El coste base de la acción E sería $3 + 3 = 6$.
- En la tabla de **$h^{add}$**: $c_{pre(E)} = 3 + 3 = 6$. El coste base de la acción E sería $6 + 3 = 9$.

Por lo tanto, para resolver el Ejercicio 12 al completo, debes desarrollar **dos procesos de tablas paralelos** (o una sola tabla con las celdas divididas en dos): uno aplicando la regla del máximo ($h^{max}$) y otro aplicando la regla de la suma ($h^{add}$).

</div>

<div class="highlight-theory">

### Recuerda

Para asegurar que no quede ninguna duda de cara al examen, vamos a dividir tu consulta en las dos cuestiones que planteas: la diferencia teórica de los planes y la corrección de tus cálculos de la iteración 2.

### Parte 2: Corrección de tus cálculos de la Iteración 2 ($T_2$)

Al revisar tus cálculos, has cometido un **error sistemático en la columna de $h^{add}$**: has aplicado operaciones de **suma** en el paso final de actualización de las celdas en lugar de aplicar el **mínimo**.

La regla de actualización de la celda para cualquier hecho $g$ en cualquier iteración $i$ **es exactamente la misma para ambas heurísticas**:
$$T_i^s(g) = \min(T_{i-1}^s(g), c_g)$$

La operación de **suma** ($\sum$) en la heurística $h^{add}$ únicamente se utiliza en dos situaciones:

- 1.  **Para calcular el coste de las precondiciones de una acción con múltiples requisitos**: $c_{pre(a)} = \sum T_{i-1}^s(g')$.
- 2.  **Para calcular el valor final de la heurística** sumando los costes de los objetivos una vez la tabla se ha estabilizado por completo.

Pero al actualizar la celda de un hecho, **siempre nos quedamos con el mínimo** entre el coste que ya tenía el hecho en el paso anterior y el coste de la mejor acción que lo genera en este paso. No se suman.

### Resumen para recordar en el examen:

En la tabla de hechos, tanto para $h^{max}$ como para $h^{add}$, **los costes nunca pueden subir de una iteración a otra**. El paso de actualización siempre lleva un $\min()$, lo que significa que los costes de los hechos solo pueden mantenerse igual o disminuir a medida que descubrimos acciones más baratas para alcanzarlos [Excerpt 89].

</div>
