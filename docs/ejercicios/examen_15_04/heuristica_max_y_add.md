Estas fórmulas describen dos heurísticas clásicas utilizadas en la **Planificación Automática en Inteligencia Artificial** (específicamente en la planificación clásica tipo STRIPS/PDDL basada en la "relajación" del problema, donde se ignoran los efectos negativos de las acciones).

Son conocidas como la heurística **Max** ($h^{\max}$) y la heurística **Aditiva** ($h^{\text{add}}$). A continuación te explico qué significa cada término y cómo funciona cada fórmula.

### 1. Diccionario de Términos Comunes

Ambas ecuaciones comparten la misma notación base. Esto es lo que significa cada letra:

- $s$: El **estado actual**. En planificación, un estado es un conjunto de condiciones o proposiciones que son verdaderas en un momento dado.
- $G$: Un **conjunto de metas** (o submetas) que se desean alcanzar a partir del estado $s$.
- $g$: Una **única meta** o proposición individual.
- $|G|$: La **cantidad de elementos** en el conjunto de metas. Si $|G| > 1$, significa que hay múltiples objetivos que cumplir simultáneamente.
- $a \in A$: Una **acción** $a$ que pertenece al conjunto total de acciones posibles $A$.
- $\text{pre}(a)$: Las **precondiciones** de la acción $a$. Son las condiciones previas que deben cumplirse en el estado para poder ejecutar esa acción.
- $\text{add}(a)$: Los **efectos de adición** (efectos positivos) de la acción $a$. Son las cosas que se vuelven verdaderas después de ejecutar la acción.
- $c_a$: El **coste** de ejecutar la acción $a$.
- $S_G$: El **conjunto total de metas finales** del problema.

---

### 2. La Heurística Max: $h^{\max}$

Esta heurística calcula el coste de alcanzar un conjunto de metas asumiendo que **puedes trabajar en todas ellas de forma paralela**. Se define por tres casos:

1.  **Caso Base ($0 \text{ si } G = \{g\} \text{ y } g \in s$):**
    Si tu objetivo es una sola meta $g$ y esa meta _ya es verdadera_ en tu estado actual $s$, el coste para alcanzarla es $0$.
2.  **Búsqueda de Acciones ($\min(\dots) \text{ si } G = \{g\} \text{ y } g \notin s$):**
    Si tu objetivo es una sola meta $g$, pero _no está_ en el estado actual, tienes que buscar una acción para conseguirla. Revisas todas las acciones posibles ($a \in A$) que produzcan esa meta ($g \in \text{add}(a)$). El coste será el **mínimo** posible sumando: el coste de la acción en sí ($c_a$) más el coste acumulado de satisfacer las precondiciones de esa acción ($h^{\max}(s, \text{pre}(a))$).
3.  **Metas Múltiples ($\max(\dots) \text{ si } |G| > 1$):**
    Si tienes un conjunto con múltiples metas, la heurística asume que el coste total para alcanzar todo el conjunto es simplemente el **coste de la meta más difícil** de conseguir (el valor máximo entre los costes individuales).

_Nota: La última línea ($h^{\max}(s) = h^{\max}(s, S_G)$) simplemente indica que el valor heurístico general para un estado $s$ equivale a aplicar esta fórmula al conjunto total de metas finales del problema._

---

### 3. La Heurística Aditiva: $h^{\text{add}}$

Esta heurística es casi idéntica a la anterior, pero cambia drásticamente en cómo trata las metas múltiples. Asume que **debes alcanzar cada meta de forma completamente independiente y secuencial**.

1.  **Caso Base:** Igual que arriba, cuesta $0$ si ya estás ahí.
2.  **Búsqueda de Acciones:** Igual que arriba, busca la acción más barata para lograr una meta individual.
3.  **Metas Múltiples ($\sum \dots \text{ si } |G| > 1$):**
    Aquí está la gran diferencia. Si tienes múltiples metas, la heurística **suma** ($\sum$) los costes individuales de alcanzar cada meta por separado.

### Resumen de la diferencia fundamental:

- **$h^{\max}$** es optimista (es una heurística "admisible"). Piensa: _"Si tengo que hacer la tarea A que cuesta 3 y la tarea B que cuesta 5, como puedo hacerlas a la vez, el coste total será 5"_.
- **$h^{\text{add}}$** es pesimista y no toma en cuenta que una misma acción podría ayudar a lograr ambas metas (es "inadmisible"). Piensa: _"Si tengo que hacer la tarea A que cuesta 3 y la tarea B que cuesta 5, el coste total será 8"_. Aunque sobreestima el coste, suele guiar a los algoritmos de búsqueda de forma mucho más rápida en la práctica.

![alt text](image.png)
