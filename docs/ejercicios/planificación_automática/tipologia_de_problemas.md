Analizando el boletín, podemos agrupar los **6 ejercicios** en distintas categorías de similitud. Aunque **todos comparten la misma base fundamental** —que es modelar problemas de planificación utilizando el formalismo **STRIPS** definiendo predicados y esquemas de acciones—, podemos clasificarlos según dos criterios: por la temática del dominio y por las tareas específicas que se exigen en el enunciado.

**1. Agrupación por temática del dominio (Tipos de problemas):**

- **Tipo A: Transporte y Logística (Rutas y vehículos).** Es el grupo más numeroso del boletín. Se centran en mover entidades (paquetes o personas) de un lugar a otro utilizando vehículos, lidiando con conexiones espaciales y de carga.
  - **Ejercicio 1:** Transporte de paquetes usando furgonetas y conductores a través de carreteras y caminos.
  - **Ejercicio 2:** Un ascensor que mueve personas entre las distintas plantas de un edificio.
  - **Ejercicio 6:** Una red logística mixta para mover paquetes utilizando camiones (dentro de una ciudad) y aviones (entre aeropuertos).
- **Tipo B: Observación y Gestión de Estados (Dependencias y recursos).** Se basan en gestionar el estado de los equipos y cumplir cadenas de requisitos antes de poder realizar la acción final.
  - **Ejercicio 3:** Satélites espaciales. Para lograr el objetivo (tomar fotografías), hay que gestionar la energía, encender instrumentos, apuntar hacia los objetivos y calibrar los equipos previamente.
- **Tipo C: Puzles clásicos y Manipulación física.** Son adaptaciones de problemas teóricos clásicos de la Inteligencia Artificial que exigen interacciones encadenadas con objetos del entorno local.
  - **Ejercicio 4:** El clásico problema del mono que debe mover una caja y subirse a ella para alcanzar unos plátanos.
  - **Ejercicio 5:** Un robot con dos pinzas (restricción de capacidad) que debe trasladar pelotas entre dos habitaciones.

**2. Agrupación por tareas exigidas (Nivel de detalle):**

Si nos fijamos en lo que te pide hacer el profesorado, los problemas se dividen en tres niveles:

- **Nivel 1 (Modelado completo + Trazabilidad del plan):** Los **Ejercicios 1 y 2**. En ellos tienes que hacer el trabajo completo: definir las acciones STRIPS, representar matemáticamente un estado inicial y un objetivo concretos, y además **escribir y comprobar un plan solución paso a paso**, describiendo cómo cambia el estado tras cada acción.
- **Nivel 2 (Modelado + Definición de estados):** El **Ejercicio 3**. Te pide definir detalladamente las acciones STRIPS y modelar un estado inicial y objetivo bastante complejos, pero no te exige que resuelvas el problema simulando el plan final.
- **Nivel 3 (Solo modelado del dominio):** Los **Ejercicios 4, 5 y 6**. Son problemas planteados de forma directa donde solo se pide "Representar en el formalismo STRIPS", lo que implica que solo debes diseñar los predicados y las acciones generales que rigen ese mundo, sin llegar a plantear un escenario con objetos concretos ni buscar su solución.

**¿Cómo enfocar el estudio en base a esto?**
Te recomendaría empezar por los ejercicios de "Solo modelado" (4, 5 y 6) para soltarte creando predicados y acciones STRIPS. Luego, pasa a los ejercicios de transporte (1 y 2) para practicar cómo aplicar esas acciones paso a paso hasta llegar al objetivo. Finalmente, el Ejercicio 3 es perfecto para poner a prueba tu capacidad de modelar acciones con muchas precondiciones entrelazadas.
