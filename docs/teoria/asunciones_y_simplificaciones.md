<link rel="stylesheet" href="../css/estilo.css" type="text/css" />

# Guía de Repaso: Asunciones y Simplificaciones en Inteligencia Artificial

He elaborado esta guía para ayudarles a identificar las simplificaciones críticas que permiten la viabilidad de los modelos de IA. En el examen no basta con memorizar el algoritmo; se debe comprender la asunción teórica que reduce la complejidad y justifica su implementación.

# 1. Fundamentos de la Simplificación y Aprendizaje Automático

## 1.1. La Paradoja de Moravec y el "Efecto IA"

La inteligencia artificial se define por la Paradoja de Moravec: tareas que requieren un alto esfuerzo consciente para los humanos (ajedrez, cálculo avanzado) son sencillas para las máquinas, mientras que tareas evolutivamente "simples" (percepción, movilidad, reconocer un gato en una fotografía) son extremadamente complejas para la computación.

Esta dualidad obliga a trabajar en el ámbito de la IA Débil (Narrow AI), que simplifica el espectro cognitivo humano enfocándose en dominios específicos. Además, debemos considerar el "Efecto IA" (Nick Bostrom/McCorduck): tan pronto como un problema complejo es resuelto (como el ajedrez), dejamos de considerarlo "inteligencia" para llamarlo simplemente "software" o cálculo masivo.

## 1.2. Clasificador Naive Bayes e Independencia Condicional

El modelo Naive Bayes aplica la asunción de independencia condicional de los atributos. Se asume que cada característica contribuye de forma independiente a la probabilidad de la clase, sin correlaciones entre ellas.

- Impacto en la Complejidad: Esta simplificación es la que permite transformar un espacio de búsqueda exponencial en un cálculo lineal O(n), haciendo el modelo tratable incluso con grandes volúmenes de datos.
- Modelos Paramétricos vs. No Paramétricos: Frente a modelos como kNN (no paramétricos, que no asumen una distribución predefinida), Naive Bayes utiliza distribuciones paramétricas:
  - Gaussian: Para datos continuos.
  - Multinomial: Basado en la frecuencia de términos (conteo).
  - Bernoulli: Basado en la presencia o ausencia (binario) de atributos.

## 1.3. El Principio de la Navaja de Occam

En la selección de modelos, priorizamos la simplicidad cuando la precisión es equiparable. Esta asunción busca evitar el sobreajuste (overfitting), garantizando que el modelo capture la tendencia general y no el ruido específico del conjunto de entrenamiento.

# 2. Redes Neuronales y Eficiencia en el Aprendizaje

## 2.1. Arquitecturas Feedforward y Funciones de Activación

La asunción de la red prealimentada (feedforward) establece un flujo unidireccional de la información. Al eliminar ciclos o retroalimentaciones directas, simplificamos el cálculo del estado de la red. Para el entrenamiento, es imperativo que las funciones de activación sean diferenciables.

Función de Activación Características y Asunciones
Sigmoide Estándar histórico. Sufre el problema de saturación, donde gradientes muy pequeños impiden que los pesos se actualicen en redes profundas.
ReLU El "atajo" para el Deep Learning. Se utiliza en capas ocultas para evitar la saturación en valores positivos, permitiendo un entrenamiento mucho más rápido y eficiente.

## 2.2. Retropropagación (Backpropagation) y el Problema XOR

El algoritmo de backpropagation (Hinton/Rumelhart, 1986) fue la respuesta necesaria a la crisis de los perceptrones de Minsky y Papert, quienes demostraron que las redes de una sola capa no podían resolver problemas no lineales como el OR exclusivo (XOR).

La asunción de eficiencia reside en el uso de la regla de la cadena, que permite propagar el error hacia atrás capa por capa. Esto evita el recálculo redundante de derivadas parciales, permitiendo que el entrenamiento de redes multicapa sea computacionalmente viable.

# 3. Procesamiento del Lenguaje Natural (PLN)

## 3.1. Bolsa de Palabras (Bag of Words)

Modelos como CountVectorizer asumen que el significado de un texto reside únicamente en la frecuencia de sus términos. Esta simplificación radical ignora el orden sintáctico y la estructura gramatical, representando el lenguaje como un vector en un espacio multidimensional.

## 3.2. N-gramas y la Propiedad de Markov

Para manejar la secuencia temporal del lenguaje sin recurrir a una memoria infinita, aplicamos la Propiedad de Markov. Se asume que la probabilidad de una palabra depende exclusivamente de los n-1 términos anteriores, acotando la historia del texto a una ventana finita y manejable.

## 3.3. Suavizado de Laplace y Perplejidad

La perplejidad mide la "sorpresa" del modelo ante nuevos datos. Matemáticamente, se define como el inverso de la probabilidad asignada al corpus, normalizado por el número de términos N:

Perplexity(W) = P(W)^{-\frac{1}{N}}

- Suavizado de Laplace: Es el "atajo" obligatorio para evitar que una palabra desconocida asigne una probabilidad de P=0, lo cual dispararía la perplejidad al infinito. Al sumar una constante a todas las frecuencias, aseguramos la convergencia del modelo.
- Relación Probabilidad-Perplejidad:
  - Alta probabilidad de secuencia \rightarrow Baja perplejidad (el modelo "entiende" el texto).
  - Baja probabilidad de secuencia \rightarrow Alta perplejidad (el modelo está "sorprendido").

## 4. Planificación Automática Clásica

### 4.1. El Modelo Clásico y sus 8 Restricciones

La planificación clásica es viable gracias a estas asunciones simplificadoras:

1. Sistema finito: Estados y acciones limitados. 2. Completamente observable: Conocimiento total del estado. 3. Determinista: Resultados predecibles. 4. Estático: Solo el agente cambia el mundo. 5. Estados objetivos: Metas claras. 6. Planes secuenciales: Acciones en orden. 7. Tiempo implícito: Sin duraciones reales. 8. Offline: El plan se genera antes de actuar.

### 4.2. Formalismo STRIPS y Representación Factorizada

STRIPS simplifica el problema del marco asumiendo que solo cambian los hechos explícitos en las listas de añadir y borrar (add/delete lists). Todo lo que no esté en la definición de la acción permanece inalterado.

### 4.3. Mundo Cerrado y Relajación del Borrado (h\_{max})

- Hipótesis del Mundo Cerrado: Lo que no está en la base de datos se asume falso.
- Relajación del Borrado: Para calcular heurísticas tratables como h\_{max}, se ignoran los efectos negativos de las acciones (se ignora la lista de borrar). Esto permite estimar la distancia al objetivo de forma optimista y rápida.

## 5. Planificación bajo Incertidumbre y Aprendizaje por Refuerzo (RL)

### 5.1. Propiedad de Markov y Factor de Descuento

En RL, el estado actual debe ser una "estadística suficiente", asumiendo que contiene toda la información relevante del pasado. El factor de descuento \gamma (gamma) es una asunción matemática para asegurar la convergencia de la suma de recompensas y priorizar el beneficio inmediato frente al incierto futuro.

### 5.2. El Dilema Exploración-Explotación (\epsilon-greedy)

El agente debe decidir entre usar su conocimiento actual (explotar) o buscar nuevas estrategias (explorar). El método \epsilon-greedy simplifica esta toma de decisiones: con probabilidad \epsilon se actúa al azar y con 1-\epsilon se elige la mejor acción conocida.

## 6. Anexo: Implementación Eficiente con NumPy

Para implementar estas asunciones teóricas en Python, recurrimos a NumPy, que optimiza el cálculo mediante el uso de Arrays (matrices de valores del mismo tipo).

Conceptos clave de NumPy para IA:

- Rank (Rango): El número de dimensiones del array.
- Shape (Forma): Tupla que indica el tamaño de cada dimensión (ej. (3, 4) para una matriz de 3 filas y 4 columnas).
- Broadcasting: Capacidad de operar con arrays de diferentes formas de manera automática, evitando bucles for y optimizando el cálculo.

Beneficios técnicos de NumPy frente a listas de Python:

1. Eficiencia de memoria: Almacenamiento contiguo en memoria.
2. Vectorización: Operaciones sobre todo el array sin bucles explícitos (crucial para el entrenamiento de redes).
3. Inicialización rápida: Funciones como zeros(), ones(), full() (matrices constantes) y eye() (identidad) permiten preparar estructuras de pesos y sesgos instantáneamente.
4. Indexado avanzado: Uso de máscaras booleanas y tuplas para acceso rápido a subconjuntos de datos.
