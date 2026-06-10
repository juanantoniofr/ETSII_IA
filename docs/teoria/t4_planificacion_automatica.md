# Planificación automática (Teoría)

## Introducción

La planificación automática es un área de la inteligencia artificial que se ocupa de la generación de planes o secuencias de acciones para alcanzar objetivos específicos. En este contexto, un plan es una serie de pasos que un agente puede seguir para lograr un objetivo dado, considerando las restricciones y el entorno en el que opera.

Existen tres tipos principales de planificadores:

- 1. **Planificadores de dominio específico**: Estos planificadores están diseñados para resolver problemas específicos en un dominio particular, como la planificación de rutas para vehículos o la programación de tareas en una fábrica.
- 2. **Planificadores independientes del dominio**: Estos planificadores son más flexibles y pueden aplicarse a una amplia variedad de problemas, aunque pueden ser menos eficientes que los planificadores de dominio específico. **Este tipo es el que estudiaremos en este curso**.
- 3. **Planificadores configurables**: Estos planificadores permiten a los usuarios configurar ciertos aspectos del proceso de planificación, como la heurística utilizada o las restricciones aplicadas.

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

## El mundo de los bloques

Si no se utilizan variables genéricas, el formalismo exige definir una regla de acción explícita para cada posible combinación física. El cálculo exacto de estas **$2n^2$ acciones** se obtiene sumando los dos grandes grupos de movimientos que puede hacer el brazo robótico:

- **Interacciones directas con la mesa (1 solo bloque implicado):** Las acciones como `AGARRAR(b)` (coger desde la mesa) y `BAJAR(b)` (dejar sobre la mesa) operan individualmente. Para $n$ bloques, se necesitan definir $n$ acciones explícitas para agarrar y otras $n$ acciones para bajar, sumando **$2n$ acciones**.
- **Interacciones entre bloques (2 bloques implicados):** Las acciones como `DESAPILAR(b1, b2)` y `APILAR(b1, b2)` requieren relacionar un bloque superior y un bloque inferior. Dado que cualquier bloque puede interactuar con cualquiera de los demás (excepto consigo mismo), existen $n(n-1)$ combinaciones posibles de pares de bloques. Como se necesita definir una regla por cada par para apilar y otra regla distinta por cada par para desapilar, el sistema requiere $2 \cdot n(n-1) = \mathbf{2n^2 - 2n}$ **acciones**.

Al sumar ambos grupos algebraicamente ($2n + 2n^2 - 2n$), el número total de reglas necesarias para definir el dominio asciende a exactamente **$2n^2$ acciones**.

Para evitar tener que escribir manualmente esta enorme explosión combinatoria al definir problemas con muchos bloques, la solución práctica consiste en utilizar **esquemas de acciones**, los cuales emplean variables genéricas (como $b_1$ y $b_2$) en lugar de identificar bloques concretos, permitiendo generalizar el dominio drásticamente.

### PDDL (Planning Domain Definition Language)

Es un lenguaje estándar para describir dominios de planificación y problemas de planificación. Fue desarrollado para facilitar la comunicación entre diferentes planificadores y para proporcionar una forma estructurada de representar problemas de planificación. Con el tiempo se ha ampliando con extensiones que permiten condiciones negadas y cuantificadas, efectos condicionales, variables numéricas, etc.

## Resolución de problemas de planificación

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

1. Inicializar el conjunto de nodos abiertos con el nodo raíz (s_i) y el conjunto de nodos cerrados vacío.
2. Mientras el conjunto de nodos abiertos no esté vacío, hacer:
   a. Busqueda en profundidad: Seleccionar el nodo _s_ más reciente del conjunto de nodos abiertos.
   b. Busqueda en anchura: Seleccionar el nodo _s_ más antiguo del conjunto de nodos abiertos.
   insertar _s_ en el conjunto de nodos cerrados.
   c. Si G está contenido o es igual a _s_, entonces
   reconstruir el camino desde el nodo raíz hasta _s_ y **devolverlo como plan solución**.
   d. Para cada acción _a_ en A que sea aplicable a _s_, hacer:
   generar el nodo hijo _s'_ aplicando la acción _a_ a _s_.
   Si _s'_ no está en el conjunto de nodos cerrados ni en el conjunto de nodos abiertos, entonces
   Padre de _s'_ = _s_.
   insertar _s'_ en el conjunto de nodos abiertos.
3. Devolver fallo (no se ha encontrado un plan solución).

### Algoritmo de Dijkstra

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

### Función heurística

Es una función que para cada estado del problema estima el coste de un plan óptimo desde ese estado hasta un estado objetivo. Las funciones heurísticas se utilizan para guiar la búsqueda hacia los estados que parecen más prometedores, lo que puede reducir significativamente el tiempo de búsqueda.

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

- **Completo:** Garantiza que, si el problema tiene solución, el algoritmo logrará encontrar un plan solución ``.
- **Óptimo:** Garantiza que el plan devuelto por el algoritmo tendrá estrictamente el **coste mínimo posible** de entre todos los caminos existentes ``.

# Ejercicios

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
  -> ASIGNAR(P1) => S_5 => {EN_MEMORIA(P1), EN_MEMORIA(P2), EJECUTADO(P1), ASIGNADO(P2)}
  -> EJECUTAR(P2) => S_6 => {EN_MEMORIA(P1), EN_MEMORIA(P2), EJECUTADO(P1), EJECUTADO(P1), PROCESADOR_EN_ESPERA()}

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
-> BAJAR(PL1, PL0) -> { ASCENSOR_EN(PL0), FUERA_ASCENSOR(PE0), , FUERA_ASCENSOR(PE1), H}
-> ENTRAR(PE0, PL0) -> { ASCENSOR_EN(PL0), DENTRO_ASCENSOR(PE0), FUERA_ASCENSOR(PE1), H}
-> SUBIR(PL0, PL1) -> { ASCENSOR_EN(PL1), DENTRO_ASCENSOR(PE0), FUERA_ASCENSOR(PE1), H}
-> SUBIR(PL1, PL2) -> { ASCENSOR_EN(PL2), DENTRO_ASCENSOR(PE0), FUERA_ASCENSOR(PE1), H}
-> SALIR(PE0, PL2) -> { ASCENSOR_EN(PL2), FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), FUERA_ASCENSOR(PE1), H}
-> SUBIR(PL2, PL3) -> { ASCENSOR_EN(PL3), FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), FUERA_ASCENSOR(PE1), H}
-> ENTRAR(PE1, PL3) -> { ASCENSOR_EN(PL3), DENTRO_ASCENSOR(PE1), FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), H}
-> BAJAR(PL3, PL2) -> { ASCENSOR_EN(PL2), DENTRO_ASCENSOR(PE1), FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), H}
-> BAJAR(PL2, PL1) -> { ASCENSOR_EN(PL1), DENTRO_ASCENSOR(PE1), FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), H}
-> BAJAR(PL1, PL0) -> { ASCENSOR_EN(PL0), DENTRO_ASCENSOR(PE1), FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), H}
-> SALIR(PE1, PL0) -> { ASCENSOR_EN(PL0), FUERA_ASCENSOR(PE1), EN_DESTINO(PE1), FUERA_ASCENSOR(PE0), EN_DESTINO(PE0), H}

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

Estado Incial S_i = {

- \(\text{SON_DISTINTOS}(o_1, o_2)\; \forall o_1, o_2 \in \{ESTRELLA_0,\ldots,ESTRELLA_4,\;NEBULOSA_0,\ldots,NEBULOSA_2\}\ \text{con}\ o_1 \neq o_2\)
- APUNTA_A(SATÉLITE_1, ESTRELLA_0$), APUNTA_A(SATÉLITE_0, ESTRELLA_4)
- A_BORDO(INTRUMENTO_i, SATÉLITE_0) \( i \in \{0,1,2\), A_BORDO(INTRUMENTO_3, SATÉLITE_1)
- NO_CALIBRADO(INSTRUMENTO_i) \( i \in \{0,1,2,3\)
- OBJETIVO_CALIBRACIÓN(INSTRUMENTO_0, ESTRELLA_1), OBJETIVO_CALIBRACIÓN(INSTRUMENTO_1, ESTRELLA_2), OBJETIVO_CALIBRACIÓN(INSTRUMENTO_2, ESTRELLA_0), OBJETIVO_CALIBRACIÓN(INSTRUMENTO_3, ESTRELLA_0)
- COMPATIBLE_CON(INSTRUMENTO_0, INFRAROJOS), COMPATIBLE_CON(INSTRUMENTO_0, ESPECTÓGRAFO), COMPATIBLE_CON(INSTRUMENTO_1, VISIBLE), COMPATIBLE_CON(INSTRUMENTO_2, VISIBLE), COMPATIBLE_CON(INSTRUMENTO_2, INFRAROJOS), COMPATIBLE_CON(INSTRUMENTO_3, INFRAROJOS, COMPATIBLE_CON(INSTRUMENTO_3, ESPECTÓGRAFO), COMPATIBLE_CON(INSTRUMENTO_3, VISIBLE)
- HAY_ENERGÍA(SATÉLITE_0), HAY_ENERGÍA(SATÉLITE_1),
- SIN_IMAGEN(ESTRELLA_i, TIPO) \( i \in \{0,1,2,3,4\}, TIPO \in \{VISIBLE, INFRARROJOS, ESPECTRÓGRAFO\} ), SIN_IMAGEN(NEBULOSA_i, TIPO) \( i, j \in \{0,1,2\}, TIPO \in \{VISIBLE, INFRARROJOS, ESPECTRÓGRAFO\} \)
  }

Representar el **estado inicial** y el **objetivo** de un problema en ese dominio en el que: - Hay dos satélites, SATÉLITE0 y SATÉLITE1. - Hay cuatro instrumentos, INSTRUMENTO0 a INSTRUMENTO3. - Hay tres tipos de imágenes, VISIBLE, INFRARROJOS y ESPECTRÓGRAFO. - Hay ocho objetos galácticos, ESTRELLA0 a ESTRELLA4 y NEBULOSA0 a NEBULOSA2. - El INSTRUMENTO0 puede tomar imágenes de tipo INFRARROJOS y ESPECTRÓGRAFO y se calibra con ESTRELLA1. - El INSTRUMENTO1 puede tomar imágenes de tipo VISIBLE y se calibra con ESTRELLA2. - El INSTRUMENTO2 puede tomar imágenes de tipo VISIBLE e INFRARROJOS y se calibra con ESTRELLA0. - El INSTRUMENTO3 puede tomar imágenes de tipo VISIBLE, INFRARROJOS y ESPECTRÓGRAFO y se calibra con ESTRELLA0. - El satélite SATÉLITE0 tiene a bordo los instrumentos INSTRUMENTO0, INSTRUMENTO1 e INSTRUMENTO2, apagados, y apunta inicialmente a ESTRELLA4. - El satélite SATÉLITE1 tiene a bordo el instrumento INSTRUMENTO3, apagado, y apunta inicialmente a ESTRELLA0.

    - Se desean una imagen de infrarrojos de ESTRELLA3, una imagen de espectrógrafo de ESTRELLA4 y NEBULOSA0 y una imagen del visible y de espectrógrafo de NEBULOSA2.
