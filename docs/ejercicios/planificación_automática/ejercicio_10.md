## Ejercicio 10

Consideremos el siguiente problema de planificación automática:

- Hechos: 𝐻𝘪 , para 𝑖 = 1, … , 9.
- Acciones:

| Acción | Precondiciones | Lista de borrado | Lista de adición | Coste |
| ------ | -------------- | ---------------- | ---------------- | ----- |
| A      | H9             | H2               | H3, H5, H8       | 1     |
| B      | H1, H6, H8     | H4               | H9               | 3     |
| C      | H3             | H3, H5           | H4, H6, H8       | 4     |
| D      | H1, H2, H3     | H1, H2           | H6               | 5     |
| E      | H1             | H1, H2           | H6               | 0     |

- Estado inicial: {𝐻𝟣}
- Objetivo: {𝐻𝟤, 𝐻𝟧, 𝐻𝟪}

Para cada estado 𝑠 siguiente se pide **determinar todos los posibles planes relajados** para 𝑠 y calcular el valor de ℎ+(𝑠):

- 1. {𝐻𝟣, 𝐻𝟤, 𝐻𝟥}
- 2. {𝐻𝟣, 𝐻𝟥, 𝐻𝟨, 𝐻𝟪}

## Solución

- **S0 = {H1, H2, H3}**
  _(Acciones aplicables: C, D, E)_
  - ➔ **Rama 1: Ejecuto C**
    - **S1 = {H1, H2, H3, H4, H6, H8}**
      _(Acciones aplicables: B)_
      - ➔ **Ejecuto B:**
        - **S2 = {H1, H2, H3, H4, H6, H8, H9}**
          _(Acciones aplicables: A)_
          - ➔ **Ejecuto A:**
            - **S3 = {H1, H2, H3, H4, H5, H6, H8, H9}** **[¡OBJETIVO ALCANZADO!]**

  - ➔ **Rama 2: Ejecuto D**
    - **S1 = {H1, H2, H3, H6}**
      _(Acciones aplicables: C)_
      - ➔ **Ejecuto C:**
        - **S2 = {H1, H2, H3, H4, H6, H8}** _(Igual que Rama 1, seguimos el mismo camino)_
          - ➔ **Ejecuto B:**
            - **S3 = {..., H9}**
              - ➔ **Ejecuto A:** **[¡OBJETIVO ALCANZADO!]**

  - ➔ **Rama 3: Ejecuto E**
    - **S1 = {H1, H2, H3, H6}** _(Mismo estado exacto que en la Rama 2, seguimos igual)_
      - ➔ **Ejecuto C:**
        - ➔ **Ejecuto B:**
          - ➔ **Ejecuto A:** **[¡OBJETIVO ALCANZADO!]**

**Cálculo de los costes de los planes:**

- **Plan 1 (Rama 1):** C + B + A ➔ 4 + 3 + 1 = **8**
- **Plan 2 (Rama 2):** D + C + B + A ➔ 5 + 4 + 3 + 1 = **13**
- **Plan 3 (Rama 3):** E + C + B + A ➔ 0 + 4 + 3 + 1 = **8**

**Valor final de la heurística:**
Como $h^+(s)$ es el coste del plan relajado más barato, buscamos el mínimo entre (8, 13, 8).
Por tanto, la respuesta final es: **$h^+(s_1) = 8$**.

---

## Base teórica

Estos conceptos pertenecen a la teoría de búsqueda heurística en planificación clásica, y son fundamentales para entender cómo los algoritmos (como el A\*) estiman cuánto falta para llegar a la meta.

Para resolver el Ejercicio 10, necesitas comprender cómo el sistema "simplifica" el problema original para poder hacer estas estimaciones. Aquí tienes la explicación de ambos conceptos:

### 1. La "Relajación del borrado" y los Planes Relajados

En un problema real de STRIPS, calcular el coste exacto desde un estado hasta el objetivo es computacionalmente demasiado complejo. Para solucionarlo, los planificadores usan una técnica llamada **relajación del problema**, que consiste en eliminar ciertas restricciones para hacer el problema más fácil de resolver matemáticamente.

El método más habitual es la **relajación del borrado**:

- Consiste en **ignorar por completo las listas de borrado** de todas las acciones del problema.
- Al aplicar una acción en este "mundo relajado", solo se añaden los hechos de su lista de adición, pero no se elimina nada. Por tanto, los hechos se van acumulando en el estado; una vez que un hecho se hace verdadero, nunca vuelve a ser falso.

Un **plan relajado** para un estado $s$ es, simplemente, una secuencia de acciones que logra alcanzar el objetivo dentro de este problema simplificado. Al no haber listas de borrado, no tienes que preocuparte por si una acción "deshace" el trabajo de otra; vas aplicando acciones que generen hechos nuevos hasta que los hechos de tu objetivo estén dentro de tu estado acumulado.

### 2. La heurística $h^{+}(s)$

Una vez que entiendes que en el mundo relajado es más fácil llegar al objetivo, surge el concepto de **$h^{+}(s)$**.

La función $h^{+}(s)$ es una heurística que representa **el coste del plan relajado óptimo** desde el estado $s$.

Para calcular el valor de $h^{+}(s)$ en tu ejercicio, el procedimiento matemático que debes aplicar es el siguiente:

1.  **Determinar todos los planes relajados posibles:** Para el estado $s$ que te dé el ejercicio, tienes que buscar todas las secuencias de acciones (sin borrar nada) que logren alcanzar el conjunto objetivo.
2.  **Medir sus costes:** Para cada uno de esos planes relajados que hayas encontrado, sumas el coste de las acciones individuales que lo componen (el enunciado del Ejercicio 10 te da una tabla con el coste de cada acción A, B, C, D y E).
3.  **Seleccionar el mínimo:** El valor final de $h^{+}(s)$ será el coste del plan relajado que resulte ser **el más barato** de todos. Si resultase imposible llegar al objetivo incluso en el problema relajado, $h^{+}(s)$ valdría infinito ($+\infty$).

**¿Por qué usamos $h^{+}(s)$?**
Porque es una heurística matemática perfecta (es admisible, consistente y segura), lo que significa que el coste que predice **siempre subestima o iguala el coste real**, pero nunca lo sobreestima. El único problema que tiene (y por lo que el boletín te pide que lo calcules a mano en un problema pequeño como el Ejercicio 10) es que encontrar _todos_ los planes relajados posibles para calcular este mínimo exacto es muy costoso para un ordenador en problemas grandes.
