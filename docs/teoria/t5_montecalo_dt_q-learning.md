<link rel="stylesheet" href="../css/estilo.css">

# Aprendizaje por Refuerzo: Montecarlo, Diferencias Temporales y Q-learning

### 1. Cuadro Comparativo de Filosofía y Dinámica de Actualización

- **Montecarlo (MC):** Es un método **no local**. Requiere obligatoriamente generar **secuencias o episodios completos** hasta alcanzar un estado terminal absorbente antes de poder estimar o actualizar cualquier valor de utilidad. No realiza _bootstrapping_ (es decir, no estima la utilidad de un estado basándose en estimaciones de estados futuros).
- **Diferencias Temporales (DT):** Combina el aprendizaje directo a partir de la experiencia (MC) con la realización de **estimaciones locales** (_bootstrapping_). Actualiza las estimaciones de utilidad paso a paso **tras cada transición individual** ($s_t \to s_{t+1}$), sin esperar a que termine el episodio.
- **Q-learning:** Es un algoritmo de diferencias temporales que aproxima directamente la utilidad óptima $q^*$ de manera **independiente de la política seguida** (_off-policy_). Realiza actualizaciones locales e incrementales en línea (_online_) tras cada transición.

---

### 2. Pasos Estructurados de Ejecución y Fórmulas

#### A. Método de Montecarlo (MC) - Primera Visita / Cada Visita

1.  **Inicialización:** Inicializar arbitrariamente la política $\pi(s)$ y la tabla de utilidades $q(s,a)$. Configurar una lista vacía de retornos acumulados $Racum(s,a)$ para registrar la experiencia.
2.  **Generación de Trayectoria Completa:** Elegir aleatoriamente un estado inicial y generar un episodio completo $\{s_0, a_0, R_0, s_1, a_1, R_1, \dots, s_T, a_T, R_T, s_{T+1}\}$ hasta alcanzar el estado terminal $s_{T+1}$ siguiendo la política $\pi$.
3.  **Cálculo de Retornos (Hacia Atrás):** Recorrer el episodio hacia atrás para cada paso $t = 0, \dots, T$:
    - _En Montecarlo de Primera Visita:_ Evaluar si el par $s_t, a_t$ es la **primera vez** que ocurre en la secuencia. (En el de _Cada Visita_ se omite este condicional).
    - Calcular la utilidad real descontada obtenida desde ese instante hasta el final del episodio:
      $$\mathbf{U \leftarrow \sum_{i=t}^{T} \gamma^{i-t} R_i}$$
4.  **Actualización de Utilidades (Promedio):** Registrar el retorno $U$ en la lista de ese par y actualizar la tabla $q$ con la media aritmética:
    $$Racum(s_t, a_t) \leftarrow \text{añadir } U$$
    $$\mathbf{q(s_t, a_t) \leftarrow \text{media}(Racum(s_t, a_t))}$$
    _(Nota: El promedio de historias también se puede calcular de forma incremental a medida que se generan nuevos retornos mediante la fórmula: $U_{\pi}^n(s) = U*{\pi}^{n-1}(s) + \frac{1}{n}(U_n - U*{\pi}^{n-1}(s))$).\_
5.  **Mejora de la Política:** Derivar la nueva política aplicando un criterio voraz sobre la tabla $q$ actualizada:
    $$\mathbf{\pi(s_t) \leftarrow \arg\max_{a \in A(s_t)} q(s_t, a)}$$

#### B. Método de las Diferencias Temporales (DT)

1.  **Inicialización:** Inicializar las estimaciones de utilidad $U(s)$ o $q(s,a)$
2.  **Transición en Línea:** Estando en el estado $s_t$, aplicar la acción $a_t$ dictada por la política actual, recibir la recompensa inmediata $R_t$ del entorno y transitar al estado siguiente $s_{t+1}$
3.  **Actualización Inmediata por Diferencia Temporal:** Aplicar el ajuste de utilidad de forma local utilizando la estimación de utilidad del estado siguiente (sin esperar al final de la historia):
    - **Para utilidades de estado $U(s)$:**
      - _Error DT ($\delta_t$):_
        $$\mathbf{\delta_t \leftarrow R_t + \gamma U(s_{t+1}) - U(s_t)}$$
      - _Actualización:_
        $$\mathbf{U(s_t) \leftarrow U(s_t) + \alpha \delta_t}$$
    - **Para utilidades de par estado-acción $q(s,a)$ (SARSA):** \* \_Error DT ($\delta_t$):
      $$\mathbf{\delta_t \leftarrow R_t + \gamma q(s_{t+1}, a_{t+1}) - q(s_t, a_t)}$$
      - _Actualización:_
        $$\mathbf{q(s_t, a_t) \leftarrow q(s_t, a_t) + \alpha(s_t, a_t) \delta_t}$$

      \_(Donde $\alpha \in (0, 1]$ representa el factor de aprendizaje)\_

#### C. Algoritmo Q-learning

1.  **Inicialización:** Inicializar arbitrariamente la tabla $q(s,a)$ para todo estado y acción, y fijar $q(\text{terminal}, a) \leftarrow 0$.
2.  **Selección con Exploración:** En el estado actual $s$, elegir la acción $a \in A(s)$ utilizando la **política $\epsilon$-voraz** derivada de la tabla $q$ actual.
3.  **Transición:** Realizar la acción $a$, observar la recompensa inmediata $R$ y el nuevo estado $s'$.
4.  **Actualización Off-policy (Bootstrap de Bellman):** Actualizar el valor $q(s,a)$ utilizando el valor máximo de utilidad del estado siguiente $s'$, asumiendo un comportamiento óptimo futuro (independientemente de qué acción elija la política de exploración en el siguiente paso):
    - _Error DT de Bellman ($\delta_t$):_
      $$\mathbf{\delta_t \leftarrow R + \gamma \max_{a' \in A(s')} q(s', a') - q(s, a)}$$
    - _Actualización:_
      $$\mathbf{q(s, a) \leftarrow q(s, a) + \alpha \delta_t}$$
      O de forma expandida en un solo paso:
      $$\mathbf{q(s, a) \leftarrow q(s, a) + \alpha \left( R + \gamma \max_{a' \in A(s')} q(s', a') - q(s, a) \right)}$$
5.  **Avanzar de Estado:** Hacer $s \leftarrow s'$ y repetir el ciclo hasta que $s$ sea terminal. Al cumplir el criterio de parada, devolver la política voraz derivada de la tabla $q$ entrenada.

---
