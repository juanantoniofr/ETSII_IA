<link rel="stylesheet" href="../css/estilo.css">

# Dudas sobre el funcionamiento de Montecarlo:

<div class="summary">

### 1. Situaciones del mundo real donde el método de Montecarlo tiene sentido

El método de Montecarlo tiene sentido en **entornos donde las funciones de transición $P$ (las probabilidades de acabar en un estado u otro) y de recompensa $R$ son completamente desconocidas o tan complejas que es imposible modelarlas matemáticamente [9: 50, 57].** En lugar de requerir un modelo teórico perfecto del mundo, el agente aprende de manera directa por ensayo y error interaccionando con el entorno (ya sea real o simulado) [9: 50, 51, 57].

Para que este enfoque sea viable en el mundo real, la situación debe cumplir dos condiciones físicas:

1.  **La existencia de un estado terminal absorbente:** El problema debe estructurarse obligatoriamente en historias o episodios con un final claro (como el fin de una partida, cruzar la meta o estrellarse), momento en el cual el episodio finaliza generando una recompensa nula de ahí en adelante [9: 51, 52].
2.  **Capacidad de simulación masiva:** Dado que Montecarlo no realiza actualizaciones locales paso a paso (necesita completar trayectorias enteras para calcular los retornos acumulados) [9: 57], tiene sentido utilizarlo cuando disponemos de un simulador computacional que nos permita recrear miles de episodios de forma rápida y de muy bajo coste.

**Ejemplos típicos del mundo real:**

- **Juegos de mesa por episodios (como el Blackjack, el Backgammon o el Blackjack de tu Ejercicio 6):** No conocemos de antemano la "fórmula matemática" que describe el comportamiento del crupier o de un oponente, pero podemos simular partidas completas hasta ganar, perder o pasarnos de 21 [9: 13, 52].
- **Entrenamiento de robots en entornos de simulación física:** Un robot con pinzas intenta aprender a apilar objetos o un coche autónomo a esquivar obstáculos en una cuadrícula virtual [9: 15, 69]. No necesitamos resolver las ecuaciones de fricción del motor de física; simplemente dejamos que el robot actúe y promediamos los éxitos o fracasos de sus intentos completos [9: 51, 57].

---

### 2. Ideas y suposiciones en las que se basa para encontrar la política óptima

Para asegurar matemáticamente que el aprendizaje por experiencia pura convergerá tarde o temprano hacia la **política óptima ($\pi^*$)**, el método de Montecarlo se apoya en tres principios fundamentales:

1.  **La Ley Fuerte de los Grandes Números:** Es el pilar estadístico del algoritmo [9: 52]. Asume que si el agente experimenta una cantidad infinita de historias que pasan por un estado $s$, el promedio de las utilidades reales observadas en la práctica ($U_1, U_2, \dots$) convergerá con total exactitud al valor esperado de la utilidad teórica de ese estado bajo la política actual ($U_\pi(s)$) [9: 51, 52]:
    $$U_{\pi}(s) = \lim_{n\to+\infty} \frac{U_1 + \dots + U_n}{n}$$
2.  **La suposición de Inicios Exploratorios (Exploring Starts):** Si el agente se limitara a seguir su política actual, habría acciones alternativas que jamás probaría y por tanto nunca sabría si eran mejores [9: 54]. Para solucionarlo, el método asume que **cada episodio simulado comienza seleccionando de forma totalmente aleatoria el estado inicial ($s_0$) y la primera acción ($a_0$)**, obligando al sistema a explorar y calcular la utilidad de todos los pares estado-acción posibles a lo largo de las iteraciones [9: 54, 56].
3.  **El esquema de Iteración de Políticas Generalizada (GPI):** Montecarlo asume que se puede replicar el atajo de la programación dinámica convencional pero usando muestras de experiencia [9: 55]. El algoritmo funciona intercalando de forma cíclica e indefinida dos fases: **evalúa** la utilidad de los pares estado-acción ($q$) mediante el promedio de los episodios de simulación, e inmediatamente **mejora** la política actual aplicando el criterio voraz (_greedy_) sobre esos nuevos valores [9: 55, 56]. La teoría garantiza que esta oscilación de evaluación-mejora converge a la política óptima en un número finito de iteraciones [9: 47, 55].
</div>
