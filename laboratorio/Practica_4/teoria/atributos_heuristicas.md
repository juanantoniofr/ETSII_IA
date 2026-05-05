# Atributos de las funciones heurísticas

## Admisible

Una heurística es **admisible** si **para cualquier estado** el coste mínimo estimado desde ese estado hasta el objetivo es **menor o igual que el coste mínimo real**. Es decir, siempre peca de optimista y **nunca sobreestima** el esfuerzo real necesario para alcanzar la meta.

## Perfecta

Cuando nos referimos a una heurística como **perfecta** (como mencionamos que ocurre con $h^+$ en su problema relajado), nos referimos a que **calcula exactamente el coste del plan óptimo relajado**, agrupando así todas las propiedades matemáticas ideales que garantizan que algoritmos como A\* funcionen de forma impecable y encuentren siempre el camino más corto.

Además de la admisibilidad, la teoría de planificación clásica establece otros **tres atributos fundamentales** que se deben considerar al evaluar una función heurística:

- 1. **Segura:** Si la estimación de la heurística para un estado $s$ es infinito ($h(s) = +\infty$), esto implica con absoluta certeza que **no hay camino posible** desde ese estado hasta el objetivo. Es decir, **si la heurística determina que el problema no tiene solución desde ese punto, nunca se equivoca**.
- 2. **Consciente del objetivo:** Establece que si el problema ya se encuentra en un estado que cumple la meta, el coste estimado para llegar al objetivo debe ser estrictamente cero ($h(s) = 0$). **Nunca estimará un coste positivo si la meta ya ha sido alcanzada**.
- 3. **Consistente:** Define que al aplicar una acción $a$ (con coste $c_a$) para transitar de un estado $s$ a un estado resultante $s'$, la estimación debe cumplir la inecuación **$h(s) \le c_a + h(s')$**. Esto significa que, **al dar un paso** en el plan, tu **estimación de cuánto falta** para el objetivo **no puede disminuir** de golpe en **una cantidad que sea mayor al coste real de la acción que acabas de aplicar**.

Existe una relación directa entre todas estas propiedades: **toda heurística que sea consistente y consciente del objetivo es, por definición matemática, también admisible**.
Al mismo tiempo, **toda heurística admisible es obligatoriamente segura y consciente del objetivo**.
