# Algoritmos y heurísticas

En los documentos proporcionados se detallan **tres combinaciones principales** de algoritmo y heurística para la resolución de problemas de planificación. Esto se debe a que las fuentes describen **un único algoritmo de búsqueda informada** capaz de utilizar heurísticas y **tres funciones heurísticas** distintas diseñadas para problemas de planificación.

## Algoritmos de búsqueda disponibles en las fuentes

El material teórico aborda cuatro algoritmos genéricos para buscar planes en el espacio de estados:

- Búsqueda en Profundidad
- Búsqueda en Anchura
- El Algoritmo de Dijkstra
- El Algoritmo $A^*$.

De todos ellos, **solo el algoritmo $A^*$ utiliza una heurística** $h(s)$ para guiar la búsqueda, combinándola con el coste acumulado $g(s)$ mediante la fórmula $f(s) = g(s) + h(s)$.

Los tres restantes son métodos de búsqueda ciega o de coste uniforme que no emplean ninguna heurística (por ejemplo, Dijkstra evalúa los nodos usando estrictamente $f(s)=g(s)$).

## Heurísticas de planificación disponibles en las fuentes:

Para guiar al algoritmo $A^*$, el temario introduce tres heurísticas independientes del dominio basadas en la técnica de "relajación del borrado" (que ignora las listas de borrado de las acciones para simplificar la estimación matemática):

- 1. **Heurística $h^+$:** Estima el coste buscando el "plan relajado óptimo" (el de menor coste) desde el estado actual hasta el objetivo. Es una heurística perfecta y admisible, pero muy costosa de calcular porque requiere encontrar todos los planes relajados posibles.
- 2. **Heurística $h^{max}$:** Aproxima el cálculo asumiendo que los objetivos son independientes y que el coste para lograr un conjunto de objetivos equivale únicamente al coste de lograr el objetivo individual más costoso. Es admisible pero en ocasiones subestima demasiado el coste real.
- 3. **Heurística $h^{add}$:** Otra aproximación que también asume independencia entre objetivos, pero considera que el esfuerzo total es igual a la suma de los costes de lograr cada objetivo por separado. No es admisible, ya que suele ser demasiado pesimista al ignorar que ciertos objetivos pueden compartir pasos de un mismo subplan.

**En conclusión**, cruzando el único algoritmo heurístico con las estimaciones presentadas en tu material, las **3 combinaciones teóricas** que tienes a tu disposición son:

- **$A^*$ con $h^+$**
- **$A^*$ con $h^{max}$**
- **$A^*$ con $h^{add}$**
