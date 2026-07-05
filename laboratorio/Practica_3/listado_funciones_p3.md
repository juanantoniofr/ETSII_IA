# Listado de funciones y clases usados en la práctica 3

_Universidad de Sevilla – Dpto. de Ciencias de la Computación e Inteligencia Artificial_ [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

## Biblioteca NLTK

### Función `download`

Descarga de corpus, modelos y otros paquetes de datos proporcionados por NLTK. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `corpus.reader.plaintext`

#### Clase `PlaintextCorpusReader`

Lectura de corpus de documentos en texto plano. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `lm`

#### Clase `Laplace`

Modelo de _n_-gramas con suavizado de Laplace. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

#### Clase `MLE`

Modelo de _n_-gramas. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `lm.preprocessing`

#### Función `flatten`

Aplana una secuencia. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `lm.vocabulary`

#### Clase `Vocabulary`

Vocabulario de términos. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `tokenize`

#### Función `word_tokenize`

Divide una cadena en una secuencia de tókenes. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `tokenize.punkt`

#### Clase `PunktTokenizer`

Proporciona modelos preentrenados para distintos idiomas de división de texto en frases. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `util`

#### Función `bigrams`

Determina los bigramas de una secuencia de términos. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

#### Función `ngrams`

Determina los _n_-gramas de una secuencia de términos. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

#### Función `trigrams`

Determina los trigramas de una secuencia de términos. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

---

## Biblioteca NumPy

### Módulo `random`

#### Función `seed`

Establece la semilla para el generador de números pseudoaleatorios. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

---

## Biblioteca scikit-learn

### Módulo `feature_extraction.text`

#### Clase `CountVectorizer`

Obtiene la representación bolsa de palabras de una colección de documentos. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

#### Clase `TfidfTransformer`

Obtiene la representación TF-IDF de una colección de documentos a partir de su representación bolsa de palabras. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

#### Clase `TfidfVectorizer`

Obtiene la representación TF-IDF de una colección de documentos. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `metrics`

#### Función `recall_score`

Calcula la métrica sensibilidad (_recall_). [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `model_selection`

#### Clase `GridSearchCV`

Búsqueda exhaustiva sobre valores especificados de hiperparámetros para un estimador. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `naive_bayes`

#### Clase `MultinomialNB`

Clasificador Naive Bayes multinomial. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `neighbors`

#### Clase `KNeighborsClassifier`

Clasificador de _k_ vecinos más cercanos. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)

### Módulo `pipeline`

#### Clase `Pipeline`

Una secuencia de transformadores de datos con un predictor final opcional. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_3.pdf)
