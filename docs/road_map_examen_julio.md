# Road map para el examen de julio

¡Enhorabuena por ese 3 en la parte práctica! Eso significa que has obtenido la máxima puntuación posible en el apartado práctico (que supone el 30% de la nota final) y, como comentamos anteriormente, esa nota **se te guardará de manera independiente hasta la convocatoria de octubre del curso siguiente**.

Como has suspendido los dos bloques teóricos, la normativa de la asignatura indica que en la convocatoria de julio **deberás realizar los exámenes de ambos bloques**. Dado que la teoría se puntúa sobre un máximo de 7 puntos, el formato que mencionas (2 puntos de test, 2,5 de problemas en papel y 2,5 de ordenador) encaja exactamente con la estructura de evaluación de la asignatura, la cual especifica que los exámenes constarán de cuestiones teóricas, problemas a resolver en papel y ejercicios en ordenador. Para aprobar este bloque necesitas sacar al menos un **3.5 sobre 7**.

Teniendo en cuenta que hoy es 26 de junio y el examen es el 7 de julio, dispones de **11 días completos** (44 horas de estudio en total). Aquí tienes una planificación estructurada basada en los 5 temas del temario oficial:

### Estructura Diaria Recomendada (4 horas/día)

Para optimizar tu esfuerzo según las puntuaciones del examen, divide tus 4 horas diarias así:

- **1 hora - Teoría (Test - 2 puntos):** Lectura comprensiva, memorización de conceptos teóricos y propiedades (por ejemplo, diferencias entre Montecarlo y Q-Learning o asunciones de planificación).
- **1.5 horas - Problemas en papel (2,5 puntos):** Hacer ejercicios a mano paso a paso (cálculos de matrices, despejes de ecuaciones de Bellman, etc.), tal como hemos estado practicando.
- **1.5 horas - Ordenador (2,5 puntos):** Práctica en el ordenador utilizando las herramientas y bibliotecas de las clases prácticas correspondientes a ese tema.

### Calendario de Estudio (26 de Junio - 6 de Julio)

Hoy es 29 de junio y tu examen es el 7 de julio. Esto significa que tienes exactamente 8 días completos de estudio por delante. Si, tal y como indicas, reservamos los dos últimos días exclusivamente para el laboratorio, te quedan **6 días perfectos** para repasar de forma intensiva la teoría y los problemas a mano.

Sabiendo que ya tienes dominados Naive Bayes y los árboles CART, el temario restante se estructura así:

**Día 1 (29 de junio): Cierre de Aprendizaje Automático e inicio de Redes Neuronales**

- **Aprendizaje Automático (k-NN):** Estudia las métricas de distancia (Euclídea, Manhattan, Hamming) y cómo aplicarlas en el algoritmo k-NN. Repasa la normalización de atributos numéricos (mín-máx y tipificación) para evitar que unas variables dominen sobre otras en el cálculo.
- **Redes Neuronales (Bases):** Entiende el modelo base del perceptrón, el cálculo de su entrada ponderada ($z$) sumando pesos y sesgos, y la función de activación umbral o signo. Practica cómo entrenar y actualizar los pesos de un perceptrón simple a mano.
- **Funciones de activación modernas:** Revisa las matemáticas de la función Sigmoide, Rectificador (ReLU) y Tangente hiperbólica.

**Día 2 (30 de junio): Redes Neuronales (El núcleo matemático)**

- **Arquitectura y propagación:** Estudia cómo se organizan las neuronas en capas ocultas y de salida, y cómo la información viaja hacia adelante (_Forward propagation_).
- **Cálculo de error (Funciones de coste):** Dependiendo del problema, repasa cómo calcular el Error Cuadrático Medio (para regresión), la Entropía Cruzada Binaria (con activación sigmoide en la salida) y la Entropía Cruzada Categórica (usando la función Softmax para multiclase).
- **El Descenso por el Gradiente:** Este es el punto más duro del tema. Practica a mano el algoritmo de retropropagación (_backpropagation_) para calcular los errores ($\Delta$) en cada capa y actualizar los pesos usando notación matricial y vectorial.

**Día 3 (1 de julio): Procesamiento del Lenguaje Natural (PLN)**

- **Clasificación de Textos:** Estudia cómo transformar un texto en números usando el modelo de Bolsa de Palabras y el modelo tf-idf (Frecuencia de término - Frecuencia documental inversa).
- **Modelos de clasificación:** Aplica Naive Bayes Multinomial usando probabilidades condicionales con **suavizado de Laplace obligatorio**, y k-NN utilizando la **similitud del coseno**.
- **Modelos de lenguaje (Secuencias):** Repasa el cálculo de probabilidades usando n-gramas (unigramas, bigramas, trigramas). Estudia las técnicas para abordar n-gramas desconocidos (retroceso o _backoff_ e interpolación lineal) y cómo medir la bondad de un modelo usando la fórmula de la **perplejidad**.

**Día 4 (2 de julio): Planificación Automática**

- **Formalismo STRIPS:** Practica cómo modelar un dominio definiendo predicados, estados iniciales, objetivos y esquemas de acciones (con sus precondiciones, listas de adición y listas de borrado).
- **Búsqueda en grafos de estados:** Repasa cómo se aplican teóricamente los algoritmos Dijkstra y A\* para encontrar planes óptimos.
- **Cálculo de Heurísticas (Vital para los problemas):** Practica a mano el método de _relajación del borrado_ para generar planes relajados. Debes saber calcular la heurística perfecta relajada ($h^+$), y los algoritmos de programación dinámica para estimar $h^{max}$ y $h^{add}$.

**Día 5 (3 de julio): Aprendizaje por Refuerzo (Parte I - Programación Dinámica)**

- **Procesos de Decisión de Markov (MDP):** Entiende la formalización de estados, acciones, probabilidades de transición, recompensas y el factor de descuento ($\gamma$).
- **Utilidad y Bellman:** Comprende cómo calcular la utilidad esperada de una historia y domina el planteamiento de las **Ecuaciones de Bellman**.
- **Algoritmos con conocimiento del entorno:** Resuelve los sistemas de ecuaciones lineales que requiere el **Algoritmo de Iteración de Valores** y el **Algoritmo de Iteración de Políticas** para encontrar la política óptima.

**Día 6 (4 de julio): Aprendizaje por Refuerzo (Parte II - Interacción con el entorno)**

- **Exploración vs. Explotación:** Entiende las políticas $\epsilon$-voraz.
- **Método de Montecarlo:** Practica la diferencia de actualización entre el método de primera visita y el de cada visita con inicios exploratorios.
- **Diferencias Temporales:** Domina a la perfección cómo actualizar la tabla de utilidades $Q(s,a)$ paso a paso con el **algoritmo Q-Learning** tras cada transición en el entorno.

**Días 7 y 8 (5 y 6 de julio): Prácticas de Laboratorio**

- Te dedicarás en exclusiva a repasar Jupyter, Python (NLTK, Scikit-learn, Keras, Unified-Planning) tal y como has planificado.

Si consigues cerrar un tema teórico-práctico por día, llegarás al examen con todo el contenido absolutamente dominado.

### Tabla de progreso

| Estado | Fecha                 | Bloque Temático                             | Tareas específicas a completar                                                                                                                                                                                                                                                        |
| :----: | :-------------------- | :------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
|  [ ]   | **Día 1**<br>(29 jun) | **k-NN y Bases de RRNN**                    | <ul><li>[X] Calcular distancias k-NN (Euclídea, Manhattan, Hamming).</li><li>[X] Normalizar atributos (mín-máx y tipificación).</li><li>[X] Entrenar un perceptrón a mano.</li><li>[X] Entender funciones de activación (Sigmoide, ReLU, Tanh).</li></ul>                             |
|  [ ]   | **Día 2**<br>(30 jun) | **Redes Neuronales<br>(Núcleo matemático)** | <ul><li>[X] Realizar un paso de _forward propagation_.</li><li>[ ] Calcular funciones de coste (MSE y Entropía Cruzada).</li><li>[ ] Realizar la retropropagación (_backpropagation_) a mano.</li><li>[ ] Actualizar pesos con descenso estocástico por el gradiente.</li></ul>       |
|  [ ]   | **Día 3**<br>(1 jul)  | **Proc. del Lenguaje Natural**              | <ul><li>[ ] Vectorizar textos (Bolsa de palabras y matriz tf-idf).</li><li>[ ] Aplicar Naive Bayes (con Laplace) y k-NN (similitud coseno).</li><li>[ ] Calcular probabilidades con n-gramas e interpolación.</li><li>[ ] Calcular la perplejidad de un modelo de lenguaje.</li></ul> |
|  [ ]   | **Día 4**<br>(2 jul)  | **Planificación Automática**                | <ul><li>[ ] Modelar dominios en STRIPS (Precondiciones, Add/Del).</li><li>[ ] Trazar la búsqueda con Dijkstra y A\*.</li><li>[ ] Extraer planes relajados ignorando las listas de borrado.</li><li>[ ] Calcular heurísticas a mano ($h^+$, $h^{max}$ y $h^{add}$).</li></ul>          |
|  [ ]   | **Día 5**<br>(3 jul)  | **A. por Refuerzo (Parte I)**               | <ul><li>[ ] Formular un MDP y las ecuaciones de Bellman.</li><li>[ ] Realizar 1-2 pasos del algoritmo de Iteración de Valores.</li><li>[ ] Realizar un paso del algoritmo de Iteración de Políticas.</li></ul>                                                                        |
|  [ ]   | **Día 6**<br>(4 jul)  | **A. por Refuerzo (Parte II)**              | <ul><li>[ ] Entender las políticas $\epsilon$-voraz (exploración vs explotación).</li><li>[ ] Simular el método de Montecarlo (1ª visita y cada visita).</li><li>[ ] Actualizar una tabla $Q(s,a)$ ejecutando Q-Learning.</li></ul>                                                   |
|  [ ]   | **Día 7**<br>(5 jul)  | **Laboratorio (Parte I)**                   | <ul><li>[ ] Repasar Jupyter, Pandas, Scikit-learn (KNeighbors, CART).</li><li>[ ] Repasar Keras (Sequential, Dense, losses) para RRNN.</li></ul>                                                                                                                                      |
|  [ ]   | **Día 8**<br>(6 jul)  | **Laboratorio (Parte II)**                  | <ul><li>[ ] Repasar NLTK (Tokenize, CountVectorizer, TfIdfVectorizer).</li><li>[ ] Repasar Unified-Planning y llamadas a Fast Downward.</li></ul>                                                                                                                                     |
|   🏆   | **Día 9**<br>(7 jul)  | **¡DÍA DEL EXAMEN!**                        | <ul><li>[ ] Repaso ligero, descansar y rendir al máximo.</li></ul>                                                                                                                                                                                                                    |

¡Mucho ánimo con esos cálculos a mano y a por el examen! Si durante alguno de estos días te atascas haciendo un cálculo de _backpropagation_, una heurística $h^{add}$ o una tabla de Q-Learning, pregúntame y lo resolvemos paso a paso.
