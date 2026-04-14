### SIMULACRO DE EXAMEN - BLOQUE 1 (Duración: 2 horas)

_Aviso: Durante la realización del examen práctico solo tendrías acceso a las páginas de las bibliotecas de Python y a los listados de funciones de las prácticas_.

#### PARTE I: CUESTIONES TEÓRICAS (2 Puntos)

_Cada cuestión vale 1.00 punto. Presta atención a las penalizaciones de cada formato_.

**Cuestión 1. Elección múltiple (1.00 punto)**
_Instrucciones: Cada respuesta elegida suma o resta 1.00/n puntos según sea correcta o no (donde n es el total de respuestas correctas). La nota mínima de la pregunta es 0._
Indica cuáles de las siguientes afirmaciones sobre los modelos de aprendizaje automático son **correctas**:

- [ ] a) El modelo k-Vecinos más Cercanos (kNN) es un modelo paramétrico porque debe aprender los valores de _k_ durante el entrenamiento.
- [x] b) Para utilizar un modelo Naive Bayes clásico con atributos continuos numéricos, es necesario aplicar previamente un procedimiento de discretización.
- [x] c) En un árbol de regresión (CART), las hojas se etiquetan con la media de los valores del atributo objetivo de los ejemplos asociados a esa hoja.
- [x] d) El Suavizado de Laplace es una técnica exclusiva de las redes neuronales para evitar que el gradiente se sature a 0.

**Cuestión 2. Emparejamiento (1.00 punto)**
_Instrucciones: Cada respuesta correcta sumará 1.00/n puntos (donde n es el número de respuestas)_.
Empareja cada concepto de Procesamiento del Lenguaje Natural y Evaluación con su definición correcta:

1. TF-IDF
2. Perplejidad
3. Exactitud (Accuracy)
4. Suavizado de Laplace

- [3] A. Métrica que evalúa la proporción total de aciertos correctos de un modelo sobre un conjunto de datos.
- [4] B. Técnica que evita que un término desconocido anule por completo la probabilidad de toda una secuencia o documento.
- [2] C. Métrica que mide la "duda" o sorpresa de un modelo de lenguaje al leer un texto real; cuanto menor sea su valor, mejor es el modelo.
- [1] D. Modelo de vectorización que premia la repetición de un término localmente pero penaliza si es muy común en el corpus global.

---

#### PARTE II: PROBLEMAS PARA RESOLVER EN PAPEL (3 Puntos)

_Cada problema tiene una puntuación máxima de 1.50 puntos. Debes mostrar el desarrollo matemático._

**Problema 1: Naive Bayes Multinomial y PLN (1.50 puntos)**
Considera un problema de clasificación de correos electrónicos en "Spam" y "No Spam". El vocabulario extraído es $V = \{\text{oferta}, \text{premio}, \text{hola}, \text{gratis}\}$. Tienes el siguiente corpus de entrenamiento:

- **Spam:** $D_1 =$ "oferta premio", $D_2 =$ "oferta gratis gratis", $D_3 =$ "premio gratis"
- **No Spam:** $D_4 =$ "hola hola", $D_5 =$ "hola premio"

Se pide: Usando el modelo de **bolsa de palabras** y un clasificador **Naive Bayes Multinomial con suavizado de Laplace ($k=1$)**, calcula las probabilidades y determina si el nuevo correo $D_{nuevo} =$ "oferta hola gratis" sería clasificado como Spam o No Spam.

**Solución**
Vocabulario = {oferta,premio,hola,gratis}

Corpus.
Spam -> D_1 = "oferta premio", D_2 = "oferta gratis gratis", D_3 = "premio gratis"
No spam -> D_4 = "hola hola", D_5 = "Hola premio"

**Bolsa de palabras**

- Contamos cuantas veces ocurre los términos del vocabulario en cada documento: n<sub>D,t</sub>

D_1 -> (1 1 0 0)
D_2 -> (1 0 0 2)
D_3 -> (0 1 0 1)
D_4 -> (0 0 0 2)
D_5 -> (0 1 1 0)

**naive Bayes Multinomial**

- 1. Calcular las probabilidades a priori
     P(spam) = 3/5
     P(no-spam) = 2/5
- 2. Calcular las probabilidades condicionadas de cada término del documento pertenezca a la clase c => P(t|c) = Cuantas veces aparece t en todos los documentos de la clase c / número total de palabras en la clase c.

Número total de palabras en la clase "spam": 7
Término únicos en la clase "spam": 3
Número toal de palabras en la clase "no spam": 4
Término únicos en la clase "no-spam": 2

D_nuevo ="oferta hola gratis"
D_nuevo=(1 0 1 1)

P(oferta|spam)=3+1/7+3
P(hola|spam)=0+1/7+3
P(gratis|spam)=3+1/7+3

P(oferta|no-spam)=0+1/4+2
P(hola|no-spam)=2+1/4+2
P(gratis|no-spam)=0+1/4+2

- Regla de decisión: multiplicar P(c) por las P(t|c) elevado al n<sub>D,t</sub>

Clase spam para D*nuevo =3/5 * 4/10 _ 1/10 _ 4/10
Calse no-spam para D*nuevo = 2/5 * 1/6 _ 3/6 _ 1/6

**Problema 2: Redes Neuronales - Perceptrón (1.50 puntos)**
Considera un perceptrón con función de activación umbral (devuelve 1 si $z > 0$, y 0 si $z \le 0$). Sus parámetros iniciales son:

- Pesos: $w_1 = 0.2$, $w_2 = -0.1$
- Sesgo: $b = 0.1$ (o $w_0 = 0.1$)
- Factor de aprendizaje: $\eta = 0.1$

Dado el siguiente conjunto de entrenamiento ordenado:

1.  $E_1$: $x_1=1$, $x_2=1$, salida esperada $y=0$
2.  $E_2$: $x_1=0$, $x_2=1$, salida esperada $y=1$

Se pide: Realiza paso a paso **una única iteración (época)** del algoritmo de entrenamiento del perceptrón (método de descenso) procesando $E_1$ y luego $E_2$. Muestra cuáles son los pesos finales ($w_1$, $w_2$) y el sesgo ($b$) al terminar.

Formulas a aplicar
actualización de pesos: wi <- wi + (y - a) f*aprendizaje
calculo de z: a = w0 * 1 + w1 \_ x1 + w2 \* x2
salida del perceptron: umbral(z)

E*1 = (1,1)
z = 0.1 * 1 + 0.2 _ 1 + (-0,1) _ 1 = 0.2 => f(z) = 1, como y = 0 => Fallo => se actualizan los pesos
w0 <- 0.1 + (0 - 1) _ 0.1 = 0 => w0 = 0
w1 <- 0.2 + (0 - 1) _ 0.1 = 0.1 => w1 = 0.1
w2 <- -0.1 + (0 - 1) \_ 0.1 = 0 => w2 = 0

E*2 ? (1,0)
z = (0 * 1) + (0.1 \_ 1) + (0 \* 0)= 0.1 => f(z) = 1, como y es 1 => Acierto => no se actualizan los pesos

Fin de la primera época

---

#### PARTE III: EJERCICIO PRÁCTICO EN JUPYTER (2 Puntos)

_Puntuación máxima de 2.00 puntos. El ejercicio tiene apartados para escalonar la nota y requiere código Python usando librerías como Pandas y Scikit-learn_.

**Ejercicio Práctico:**
Imagina que te han proporcionado un archivo de texto llamado `vehiculos.csv` que contiene atributos numéricos continuos (potencia, peso, cilindros) y un atributo objetivo llamado `consumo` que tiene las etiquetas "Alto" y "Bajo".

Escribe los bloques de código Python necesarios para resolver los siguientes apartados:

- **Apartado A (0.50 ptos):** Importa la librería necesaria y lee el archivo `vehiculos.csv`. Separa el DataFrame en la matriz de características `X` (todas las columnas menos 'consumo') y el vector objetivo `y` ('consumo'). A continuación, divide ambos en un conjunto de entrenamiento (75%) y prueba (25%).
- **Apartado B (0.50 ptos):** Construye un modelo encadenado (`Pipeline`) que primero estandarice / tipifique los atributos numéricos continuos para que tengan media 0 y varianza 1, y posteriormente aplique un clasificador de k-Vecinos más Cercanos (`KNeighborsClassifier`).
- **Apartado C (0.50 ptos):** Configura una búsqueda exhaustiva en rejilla (`GridSearchCV`) sobre el Pipeline anterior para probar los valores de vecinos $k =$. Entrena esta rejilla usando el conjunto de entrenamiento.
- **Apartado D (0.50 ptos):** Utiliza el mejor modelo encontrado por la rejilla para predecir las etiquetas del conjunto de prueba. Calcula e imprime por pantalla la exactitud (`accuracy_score`) y la matriz de confusión (`confusion_matrix`).

---

### ¿Cómo quieres proceder?

Puedes tomarte tu tiempo (te sugiero cronometrarte), coger papel y lápiz, y responderme con tus soluciones detalladas, ya sea completas o sección por sección. Yo evaluaré tus respuestas aplicando los criterios del examen, corregiré tus fallos y, a partir de tu nota final, elaboraremos un plan de estudio enfocándonos en lo que te sea más rentable repasar. ¡Mucha suerte!
