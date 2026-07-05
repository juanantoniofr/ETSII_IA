<link rel="stylesheet" href="../css/estilo.css">

# Plantilla Maestra para el Examen de Laboratorio (Tema 5: Aprendizaje por Refuerzo)

Este documento contiene la estructura de código exacta y simplificada que se utiliza en las prácticas de la asignatura (basada en la biblioteca **Gymnasium**), diseñada para ser memorizada y adaptada rápidamente a cualquier enunciado de examen.

## 1. Estructura de un Entorno de Gymnasium Personalizado (`Env`)

Esta es la plantilla base para definir un entorno físico o de rejilla. Hereda de `gymnasium.Env` y requiere definir obligatoriamente los espacios de estados y acciones, el método `reset()` y el método `step()`.

```python
import numpy as np
from gymnasium import Env
from gymnasium.spaces import Box, Discrete, Dict

class MiEntorno(Env):
    def __init__(self, anchura, altura, no_accesibles=None):
        super().__init__()
        self.anchura = anchura
        self.altura = altura
        self.no_accesibles = no_accesibles if no_accesibles is not None else []

        # 1. Definición de Espacios (Box para coordenadas continuas/discretas, Discrete para acciones)
        # Estados: coordenadas [x, y] desde [0, 0] hasta [anchura-1, altura-1]
        self.espacio_de_estados = Box(
            low=np.array([0, 0]),
            high=np.array([anchura - 1, altura - 1]),
            dtype=int
        )
        # Acciones: 4 posibles direcciones (0: arriba, 1: abajo, 2: izquierda, 3: derecha)
        self.espacio_de_acciones = Discrete(n=4)

        # Alias estándar para Gymnasium
        self.observation_space = self.espacio_de_estados
        self.action_space = self.espacio_de_acciones

    def reset(self, seed=None, options=None):
        # Obligatorio para fijar la semilla aleatoria de forma reproducible
        if seed is not None:
            super().reset(seed=seed)
            self.espacio_de_estados.seed(seed)
            self.espacio_de_acciones.seed(seed)

        # Determinar posición inicial aleatoria que no sea un obstáculo o terminal
        posicion_inicial = self.espacio_de_estados.sample()
        posicion_objetivo = np.array([self.anchura - 1, self.altura - 1])

        while (posicion_inicial.tolist() in self.no_accesibles or
               np.array_equal(posicion_inicial, posicion_objetivo)):
            posicion_inicial = self.espacio_de_estados.sample()

        self._estado_actual = posicion_inicial

        # reset() debe devolver siempre una tupla: (estado, info_dict)
        return self._estado_actual, {}

    def step(self, action):
        # 1. Validar que la acción sea válida
        assert self.espacio_de_acciones.contains(action), 'Acción no válida'

        # 2. Definir efectos stocásticos (opcional, ej: 80% éxito, 10% perpendicular izq, 10% derecha)
        # movimientos = { 0: arriba, 1: abajo, 2: izquierda, 3: derecha }
        efectos = {
            0: np.array([0, 1]),   # Arriba
            1: np.array([0, -1]),  # Abajo
            2: np.array([-1, 0]),  # Izquierda
            3: np.array([1, 0])    # Derecha
        }

        # Si hay transiciones estocásticas, usar self.np_random:
        # idx = self.np_random.choice(3, p=[0.8, 0.1, 0.1])
        movimiento = efectos[action]
        estado_candidato = self._estado_actual + movimiento

        # 3. Controlar límites de la cuadrícula y celdas bloqueadas
        fuera_limites = (
            estado_candidato[0] < 0 or estado_candidato[0] >= self.anchura or
            estado_candidato[1] < 0 or estado_candidato[1] >= self.altura
        )

        if fuera_limites or estado_candidato.tolist() in self.no_accesibles:
            nuevo_estado = self._estado_actual.copy()  # Choca y se queda igual
        else:
            nuevo_estado = estado_candidato

        # 4. Asignar recompensas
        posicion_objetivo = np.array([self.anchura - 1, self.altura - 1])
        celda_a_evitar = np.array([self.anchura - 1, self.altura - 2])

        if np.array_equal(nuevo_estado, celda_a_evitar):
            recompensa = -1.0
        elif np.array_equal(nuevo_estado, posicion_objetivo):
            recompensa = 0.0
        else:
            recompensa = -0.04  # Penalización por paso para buscar el camino más corto

        # 5. Comprobar si el episodio ha terminado (alcanzar objetivo)
        terminado = np.array_equal(nuevo_estado, posicion_objetivo)
        truncado = False  # El truncamiento suele gestionarse externamente con la envoltura TimeLimit

        self._estado_actual = nuevo_estado

        # step() debe devolver obligatoriamente: (estado, recompensa, terminado, truncado, info_dict)
        return self._estado_actual, recompensa, terminado, truncado, {}
```

---

## 2. Implementación de la Clase `AgenteQLearning`

Esta clase encapsula la tabla de valores de utilidad $q(s, a)$, la toma de decisiones con exploración ($\epsilon$-voraz) y la actualización de diferencias temporales.

```python
class AgenteQLearning:
    def __init__(self, entorno, gamma=0.9, alfa=0.5, epsilon=0.25):
        self.entorno = entorno.unwrapped  # unwrapped permite acceder a los atributos del entorno base
        self.gamma = gamma
        self.alfa = alfa
        self.epsilon = epsilon

        # Inicializar tabla Q con ceros: dimensiones (anchura, altura, num_acciones)
        self.tabla_q = np.zeros((
            self.entorno.anchura,
            self.entorno.altura,
            self.entorno.action_space.n
        ))

    def elige_accion(self, estado):
        # Política epsilon-voraz para equilibrar exploración y explotación
        if self.entorno.np_random.random() < self.epsilon:
            # Acción aleatoria (Exploración)
            accion_elegida = self.entorno.action_space.sample()
        else:
            # Acción greedy basada en argmax sobre la tabla Q (Explotación)
            # Usar tuple(estado) para poder indexar correctamente arrays de NumPy en la tabla Q
            accion_elegida = np.argmax(self.tabla_q[tuple(estado)])

        return int(accion_elegida)

    def actualiza_tabla_q(self, estado, accion, recompensa, nuevo_estado):
        # Ecuación de actualización de diferencias temporales Q-learning
        diferencia_temporal = (
            recompensa +
            self.gamma * np.max(self.tabla_q[tuple(nuevo_estado)]) -
            self.tabla_q[tuple(estado)][accion]
        )
        # Actualización incremental
        self.tabla_q[tuple(estado)][accion] += self.alfa * diferencia_temporal

    def ejecuta_algoritmo(self, num_episodios):
        # Bucle de entrenamiento por episodios
        for episodio in range(1, num_episodios + 1):
            estado, _ = self.entorno.reset()

            while True:
                # 1. El agente elige e interactúa
                accion = self.elige_accion(estado)
                nuevo_estado, recompensa, terminado, truncado, _ = self.entorno.step(accion)

                # 2. El agente aprende de la transición
                self.actualiza_tabla_q(estado, accion, recompensa, nuevo_estado)

                # 3. Comprobar fin del episodio
                if terminado or truncado:
                    break

                estado = nuevo_estado

        # Devuelve la política voraz final aprendida (el argmax para cada estado)
        return np.argmax(self.tabla_q, axis=-1)
```

---

## 3. Entrenamiento con Envolturas de Gymnasium (Wrappers)

Para monitorizar el entrenamiento o limitar el número de pasos de los episodios, se utilizan las clases `RecordEpisodeStatistics` y `TimeLimit`.

```python
from gymnasium.wrappers import RecordEpisodeStatistics, TimeLimit

# 1. Instanciar entorno base
entorno_base = MiEntorno(anchura=5, altura=4, no_accesibles=[[1, 1], [1, 2]])

# 2. Aplicar límites de pasos por episodio (emite señal de truncado=True en el paso 50)
entorno_limitado = TimeLimit(entorno_base, max_episode_steps=50)

# 3. Aplicar registro estadístico de recompensas y longitudes
entorno_con_registro = RecordEpisodeStatistics(entorno_limitado, buffer_length=1000)

# 4. Crear agente y entrenar
agente = AgenteQLearning(entorno_con_registro, gamma=0.9, alfa=0.5, epsilon=0.25)
politica_optima = agente.ejecuta_algoritmo(num_episodios=1000)

# 5. Recuperar datos estadísticos tras el entrenamiento
recompensas_acumuladas = entorno_con_registro.return_queue
longitudes_episodios = entorno_con_registro.length_queue
```

---

## 4. El "Atajo" de Examen: Q-learning con Máscaras de Acción (Acciones Restringidas)

Si en el examen el entorno restringe qué acciones son aplicables en función del estado actual (como en el ejercicio de alquiler de coches), la política voraz debe ignorar las acciones no válidas asignándoles una probabilidad nula o un valor de $-\infty$ en la tabla Q para evitar que sean seleccionadas por el `argmax`:

```python
# Dentro del método 'elige_accion(self, estado, mascara_acciones)' del agente:
def elige_accion_con_mascara(self, estado, mascara_acciones):
    if self.entorno.np_random.random() < self.epsilon:
        # Muestrear solo de entre las válidas usando el parámetro 'mask' de Gymnasium
        accion_elegida = self.entorno.action_space.sample(mask=mascara_acciones)
    else:
        # Copiar los valores Q del estado actual
        q_valores = self.tabla_q[tuple(estado)].copy()
        # Forzar a -inf las acciones no aplicables (donde la máscara sea 0)
        q_valores[mascara_acciones == 0] = -np.inf
        accion_elegida = np.argmax(q_valores)

    return int(accion_elegida)
```
