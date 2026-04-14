# Práctica 3: Soluciones de los ejercicios propuestos
# Inteligencia Artificial
# Grado en Ingeniería Informática - Ingeniería del Software
# Universidad de Sevilla

Los ejercicios que se plantean a continuación tienen como objetivo el practicar con la biblioteca [NLTK](https://www.nltk.org) de Python.

**Nota de clase**:
- De cara al examen es importante ser capaces de explicar si el modelo mejora o no con cada una de las modificaciones que se proponen, y por qué. Por lo tanto, es importante entender el impacto que tiene cada una de las modificaciones que se proponen en el rendimiento del modelo, y ser capaces de justificarlo.
- Para ello, es importante entender el impacto que tiene cada una de las modificaciones que se proponen en el rendimiento del modelo, y ser capaces de justificarlo. Por ejemplo, si se elimina el preprocesado de los mensajes, es probable que el rendimiento del modelo disminuya, ya que el modelo tendrá que lidiar con más ruido en los datos, como por ejemplo, caracteres no alfanuméricos, contracciones, etc. Por otro lado, si se eliminan las palabras vacías, es posible que el rendimiento del modelo mejore, ya que las palabras vacías no aportan información relevante para distinguir entre mensajes no deseados y mensajes legítimos, y pueden incluso introducir ruido en el modelo. Por lo tanto, es importante entender el impacto que tiene cada una de las modificaciones que se proponen en el rendimiento del modelo, y ser capaces de justificarlo.

### Ejercicio 1

El objetivo de este ejercicio es entrenar y evaluar el rendimiento de un filtro de correo electrónico no deseado. Para ello se usará el corpus Enron-Spam, pero no se proporcionará un vocabulario fijo, sino que este deberá aprenderse a partir de los mensajes de entrenamiento. Con el objetivo de homogeneizar el vocabulario aprendido y de mejorar el rendimiento del filtro construido, se pedirá que se apliquen distintas técnicas de preprocesado.

En todos los apartados de este ejercicio se deberá realizar lo siguiente:

* Construir el filtro como una tubería de scikit-learn que concatene un vectorizador tf-idf y un modelo $k$NN clasificador con 5 vecinos y que use la métrica del coseno.
* Definir una función `procesa_mensaje` que, dado el contenido en bruto de un mensaje, aplique todos los pasos de procesamiento pedidos hasta obtener la lista de tókenes correspondiente. Esta función se deberá proporcionar como argumento `analyzer` del vectorizador tf-idf.
* Entrenar el filtro con el corpus de entrenamiento.
* Calcular la sensibilidad del filtro sobre el corpus de prueba.


```python
from email import parser
from email import policy
```


```python
analizador_mensaje = parser.Parser(policy=policy.default)
```


```python
from pathlib import Path
```


```python
carpeta_Enron_Spam = Path('Filtro antispam/Enron-Spam/')
carpeta_entrenamiento = carpeta_Enron_Spam / 'train'
carpeta_prueba = carpeta_Enron_Spam / 'test'

contenidos_mensajes_entrenamiento = []
clases_mensajes_entrenamiento = []
for ruta_mensaje in (carpeta_entrenamiento / 'legítimo').iterdir():
    with open(ruta_mensaje, 'r') as fichero_mensaje:
        try:
            mensaje = analizador_mensaje.parse(fichero_mensaje)
            contenidos_mensajes_entrenamiento.append(mensaje.get_content())
            clases_mensajes_entrenamiento.append(0)
        except (KeyError, UnicodeDecodeError, LookupError):
            pass
for ruta_mensaje in (carpeta_entrenamiento / 'no_deseado').iterdir():
    with open(ruta_mensaje, 'r') as fichero_mensaje:
        try:
            mensaje = analizador_mensaje.parse(fichero_mensaje)
            contenidos_mensajes_entrenamiento.append(mensaje.get_content())
            clases_mensajes_entrenamiento.append(1)
        except (KeyError, UnicodeDecodeError, LookupError):
            pass

contenidos_mensajes_prueba = []
clases_mensajes_prueba = []
for ruta_mensaje in (carpeta_prueba / 'legítimo').iterdir():
    with open(ruta_mensaje, 'r') as fichero_mensaje:
        try:
            mensaje = analizador_mensaje.parse(fichero_mensaje)
            contenidos_mensajes_prueba.append(mensaje.get_content())
            clases_mensajes_prueba.append(0)
        except (KeyError, UnicodeDecodeError, LookupError):
            pass
for ruta_mensaje in (carpeta_prueba / 'no_deseado').iterdir():
    with open(ruta_mensaje, 'r') as fichero_mensaje:
        try:
            mensaje = analizador_mensaje.parse(fichero_mensaje)
            contenidos_mensajes_prueba.append(mensaje.get_content())
            clases_mensajes_prueba.append(1)
        except (KeyError, UnicodeDecodeError, LookupError):
            pass
```

#### Apartado 0

En este apartado se pide procesar los mensajes realizando los siguientes 3 pasos:

* Extraer el contenido de texto de los mensajes en formato HTML. Para ello hacer uso de la biblioteca [Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/).
* Dividir el contenido de los mensajes en secuencias de tókenes mediante el tokenizador de NLTK.
* Eliminar de los tókenes los caracteres no alfanuméricos (y eliminar por completo aquellos tókenes que no contengan caracteres alfanuméricos).


```python
contenidos_mensajes_entrenamiento[-21]
```

**Nota de clase**:
- esta librería sirve para extraer el texto de los mensajes, eliminando las etiquetas HTML y quedándonos solo con el contenido textual en páginas web o correos electrónicos que estén en formato HTML.
- La calidad de los datos influye mucho en la calidad del modelo, por lo que es importante eliminar los caracteres no alfanuméricos para reducir el ruido en los datos y mejorar el rendimiento del filtro de correo electrónico no deseado.


```python
from bs4 import BeautifulSoup
```


```python
def elimina_html(contenido):
    return BeautifulSoup(contenido).get_text()
```


```python
elimina_html(contenidos_mensajes_entrenamiento[-21])
```




    '"I just wanted to write and thank you for Spur-M. \nI suffered from poor sperm count and motility. I found \nyour site and ordered Spur-M Fertility Blend for Men. \nI have wondered for years what caused low semen and sperm \ncount, and how I could improve my fertility and help my wife\nconceive. Spur-M seems to have done just that! Thank you\nfor your support."\nAndrew H., London, UK\n\n"Spur-M really does help improve fertility and effectiveness\nof sperm and semen motility. I used it for the past few months,\nand not only does it work - I also feel better to. I have \nmore energy. This is an excellent counter to low sperm count\nand motility. I\'ll be buying more!!!"\nFranz K., Bonn, Germany\n\n"I had been wondering on the causes of low semen and \nsperm count, I was searching for this type of information \nwhen I found your site. I hadn\'t been made aware of this \nproduct before then, so was quite surprised to be able \nto find a Male fertility product. Usually everything is \ngeared towards female fertility. Suffice to say I ordered \nand a few months later we received the good news from the \nDoctors - My wife is pregnant. I can\'t be 100% sure if \nit was Spur-M that helped. But I am happy enough to be able\nto say it should be considered by any man looking to increase \nhis fertility. It worked for me. Thanks."\nRoy B., Essex, UK\n\nhttp://Richard.provencaux.net/spur/?sheep\n\n\n\nnot interested in promotional campaign, go here\nhttp://Munoz.provencaux.net/rm.php\n'




```python
import os

os.environ['NLTK_DATA'] = '.'

from nltk import download

download('punkt', download_dir='.')

download('punkt_tab', download_dir='.')
```

    [nltk_data] Downloading package punkt to ....
    [nltk_data]   Package punkt is already up-to-date!
    [nltk_data] Downloading package punkt_tab to ....
    [nltk_data]   Package punkt_tab is already up-to-date!





    True




```python
from nltk.tokenize import word_tokenize
```


```python
from pprint import pprint
```


```python
elimina_html(contenidos_mensajes_entrenamiento[-21])
```




    '"I just wanted to write and thank you for Spur-M. \nI suffered from poor sperm count and motility. I found \nyour site and ordered Spur-M Fertility Blend for Men. \nI have wondered for years what caused low semen and sperm \ncount, and how I could improve my fertility and help my wife\nconceive. Spur-M seems to have done just that! Thank you\nfor your support."\nAndrew H., London, UK\n\n"Spur-M really does help improve fertility and effectiveness\nof sperm and semen motility. I used it for the past few months,\nand not only does it work - I also feel better to. I have \nmore energy. This is an excellent counter to low sperm count\nand motility. I\'ll be buying more!!!"\nFranz K., Bonn, Germany\n\n"I had been wondering on the causes of low semen and \nsperm count, I was searching for this type of information \nwhen I found your site. I hadn\'t been made aware of this \nproduct before then, so was quite surprised to be able \nto find a Male fertility product. Usually everything is \ngeared towards female fertility. Suffice to say I ordered \nand a few months later we received the good news from the \nDoctors - My wife is pregnant. I can\'t be 100% sure if \nit was Spur-M that helped. But I am happy enough to be able\nto say it should be considered by any man looking to increase \nhis fertility. It worked for me. Thanks."\nRoy B., Essex, UK\n\nhttp://Richard.provencaux.net/spur/?sheep\n\n\n\nnot interested in promotional campaign, go here\nhttp://Munoz.provencaux.net/rm.php\n'




```python
word_tokenize(elimina_html(contenidos_mensajes_entrenamiento[-21]))
```




    ['``',
     'I',
     'just',
     'wanted',
     'to',
     'write',
     'and',
     'thank',
     'you',
     'for',
     'Spur-M',
     '.',
     'I',
     'suffered',
     'from',
     'poor',
     'sperm',
     'count',
     'and',
     'motility',
     '.',
     'I',
     'found',
     'your',
     'site',
     'and',
     'ordered',
     'Spur-M',
     'Fertility',
     'Blend',
     'for',
     'Men',
     '.',
     'I',
     'have',
     'wondered',
     'for',
     'years',
     'what',
     'caused',
     'low',
     'semen',
     'and',
     'sperm',
     'count',
     ',',
     'and',
     'how',
     'I',
     'could',
     'improve',
     'my',
     'fertility',
     'and',
     'help',
     'my',
     'wife',
     'conceive',
     '.',
     'Spur-M',
     'seems',
     'to',
     'have',
     'done',
     'just',
     'that',
     '!',
     'Thank',
     'you',
     'for',
     'your',
     'support',
     '.',
     "''",
     'Andrew',
     'H.',
     ',',
     'London',
     ',',
     'UK',
     "''",
     'Spur-M',
     'really',
     'does',
     'help',
     'improve',
     'fertility',
     'and',
     'effectiveness',
     'of',
     'sperm',
     'and',
     'semen',
     'motility',
     '.',
     'I',
     'used',
     'it',
     'for',
     'the',
     'past',
     'few',
     'months',
     ',',
     'and',
     'not',
     'only',
     'does',
     'it',
     'work',
     '-',
     'I',
     'also',
     'feel',
     'better',
     'to',
     '.',
     'I',
     'have',
     'more',
     'energy',
     '.',
     'This',
     'is',
     'an',
     'excellent',
     'counter',
     'to',
     'low',
     'sperm',
     'count',
     'and',
     'motility',
     '.',
     'I',
     "'ll",
     'be',
     'buying',
     'more',
     '!',
     '!',
     '!',
     "''",
     'Franz',
     'K.',
     ',',
     'Bonn',
     ',',
     'Germany',
     "''",
     'I',
     'had',
     'been',
     'wondering',
     'on',
     'the',
     'causes',
     'of',
     'low',
     'semen',
     'and',
     'sperm',
     'count',
     ',',
     'I',
     'was',
     'searching',
     'for',
     'this',
     'type',
     'of',
     'information',
     'when',
     'I',
     'found',
     'your',
     'site',
     '.',
     'I',
     'had',
     "n't",
     'been',
     'made',
     'aware',
     'of',
     'this',
     'product',
     'before',
     'then',
     ',',
     'so',
     'was',
     'quite',
     'surprised',
     'to',
     'be',
     'able',
     'to',
     'find',
     'a',
     'Male',
     'fertility',
     'product',
     '.',
     'Usually',
     'everything',
     'is',
     'geared',
     'towards',
     'female',
     'fertility',
     '.',
     'Suffice',
     'to',
     'say',
     'I',
     'ordered',
     'and',
     'a',
     'few',
     'months',
     'later',
     'we',
     'received',
     'the',
     'good',
     'news',
     'from',
     'the',
     'Doctors',
     '-',
     'My',
     'wife',
     'is',
     'pregnant',
     '.',
     'I',
     'ca',
     "n't",
     'be',
     '100',
     '%',
     'sure',
     'if',
     'it',
     'was',
     'Spur-M',
     'that',
     'helped',
     '.',
     'But',
     'I',
     'am',
     'happy',
     'enough',
     'to',
     'be',
     'able',
     'to',
     'say',
     'it',
     'should',
     'be',
     'considered',
     'by',
     'any',
     'man',
     'looking',
     'to',
     'increase',
     'his',
     'fertility',
     '.',
     'It',
     'worked',
     'for',
     'me',
     '.',
     'Thanks',
     '.',
     "''",
     'Roy',
     'B.',
     ',',
     'Essex',
     ',',
     'UK',
     'http',
     ':',
     '//Richard.provencaux.net/spur/',
     '?',
     'sheep',
     'not',
     'interested',
     'in',
     'promotional',
     'campaign',
     ',',
     'go',
     'here',
     'http',
     ':',
     '//Munoz.provencaux.net/rm.php']




```python
pprint(word_tokenize(elimina_html(contenidos_mensajes_entrenamiento[-21])),
       compact=True)
```

    ['``', 'I', 'just', 'wanted', 'to', 'write', 'and', 'thank', 'you', 'for',
     'Spur-M', '.', 'I', 'suffered', 'from', 'poor', 'sperm', 'count', 'and',
     'motility', '.', 'I', 'found', 'your', 'site', 'and', 'ordered', 'Spur-M',
     'Fertility', 'Blend', 'for', 'Men', '.', 'I', 'have', 'wondered', 'for',
     'years', 'what', 'caused', 'low', 'semen', 'and', 'sperm', 'count', ',', 'and',
     'how', 'I', 'could', 'improve', 'my', 'fertility', 'and', 'help', 'my', 'wife',
     'conceive', '.', 'Spur-M', 'seems', 'to', 'have', 'done', 'just', 'that', '!',
     'Thank', 'you', 'for', 'your', 'support', '.', "''", 'Andrew', 'H.', ',',
     'London', ',', 'UK', "''", 'Spur-M', 'really', 'does', 'help', 'improve',
     'fertility', 'and', 'effectiveness', 'of', 'sperm', 'and', 'semen', 'motility',
     '.', 'I', 'used', 'it', 'for', 'the', 'past', 'few', 'months', ',', 'and',
     'not', 'only', 'does', 'it', 'work', '-', 'I', 'also', 'feel', 'better', 'to',
     '.', 'I', 'have', 'more', 'energy', '.', 'This', 'is', 'an', 'excellent',
     'counter', 'to', 'low', 'sperm', 'count', 'and', 'motility', '.', 'I', "'ll",
     'be', 'buying', 'more', '!', '!', '!', "''", 'Franz', 'K.', ',', 'Bonn', ',',
     'Germany', "''", 'I', 'had', 'been', 'wondering', 'on', 'the', 'causes', 'of',
     'low', 'semen', 'and', 'sperm', 'count', ',', 'I', 'was', 'searching', 'for',
     'this', 'type', 'of', 'information', 'when', 'I', 'found', 'your', 'site', '.',
     'I', 'had', "n't", 'been', 'made', 'aware', 'of', 'this', 'product', 'before',
     'then', ',', 'so', 'was', 'quite', 'surprised', 'to', 'be', 'able', 'to',
     'find', 'a', 'Male', 'fertility', 'product', '.', 'Usually', 'everything',
     'is', 'geared', 'towards', 'female', 'fertility', '.', 'Suffice', 'to', 'say',
     'I', 'ordered', 'and', 'a', 'few', 'months', 'later', 'we', 'received', 'the',
     'good', 'news', 'from', 'the', 'Doctors', '-', 'My', 'wife', 'is', 'pregnant',
     '.', 'I', 'ca', "n't", 'be', '100', '%', 'sure', 'if', 'it', 'was', 'Spur-M',
     'that', 'helped', '.', 'But', 'I', 'am', 'happy', 'enough', 'to', 'be', 'able',
     'to', 'say', 'it', 'should', 'be', 'considered', 'by', 'any', 'man', 'looking',
     'to', 'increase', 'his', 'fertility', '.', 'It', 'worked', 'for', 'me', '.',
     'Thanks', '.', "''", 'Roy', 'B.', ',', 'Essex', ',', 'UK', 'http', ':',
     '//Richard.provencaux.net/spur/', '?', 'sheep', 'not', 'interested', 'in',
     'promotional', 'campaign', ',', 'go', 'here', 'http', ':',
     '//Munoz.provencaux.net/rm.php']


La eliminación de los caracteres no alfanuméricos se puede realizar mediante expresiones regulares, usando para ello el paquete [re](https://docs.python.org/es/3/library/re.html) de la biblioteca estándar de Python.


```python
import re
```

**Nota de clase**:
- La biblioteca deja al programador implementar la función `procesa_mensaje`, por lo que se pueden usar distintas técnicas de preprocesado para mejorar el rendimiento del filtro. En este apartado se pide eliminar los caracteres no alfanuméricos, pero se podrían aplicar otras técnicas como convertir los tókenes a minúsculas, eliminar las palabras vacías (stop words), aplicar lematización o stemming, etc.


```python
def elimina_no_alfanumerico(contenido):
    return [re.sub(r'[^\w]', '', palabra)
            for palabra in contenido
            if re.search(r'\w', palabra)]
```


```python
def procesa_mensaje(contenido):
    contenido = elimina_html(contenido)
    contenido = word_tokenize(contenido)
    contenido = elimina_no_alfanumerico(contenido)
    return contenido
```


```python
pprint(procesa_mensaje(contenidos_mensajes_entrenamiento[-21]),
       compact=True)
```

    ['I', 'just', 'wanted', 'to', 'write', 'and', 'thank', 'you', 'for', 'SpurM',
     'I', 'suffered', 'from', 'poor', 'sperm', 'count', 'and', 'motility', 'I',
     'found', 'your', 'site', 'and', 'ordered', 'SpurM', 'Fertility', 'Blend',
     'for', 'Men', 'I', 'have', 'wondered', 'for', 'years', 'what', 'caused', 'low',
     'semen', 'and', 'sperm', 'count', 'and', 'how', 'I', 'could', 'improve', 'my',
     'fertility', 'and', 'help', 'my', 'wife', 'conceive', 'SpurM', 'seems', 'to',
     'have', 'done', 'just', 'that', 'Thank', 'you', 'for', 'your', 'support',
     'Andrew', 'H', 'London', 'UK', 'SpurM', 'really', 'does', 'help', 'improve',
     'fertility', 'and', 'effectiveness', 'of', 'sperm', 'and', 'semen', 'motility',
     'I', 'used', 'it', 'for', 'the', 'past', 'few', 'months', 'and', 'not', 'only',
     'does', 'it', 'work', 'I', 'also', 'feel', 'better', 'to', 'I', 'have', 'more',
     'energy', 'This', 'is', 'an', 'excellent', 'counter', 'to', 'low', 'sperm',
     'count', 'and', 'motility', 'I', 'll', 'be', 'buying', 'more', 'Franz', 'K',
     'Bonn', 'Germany', 'I', 'had', 'been', 'wondering', 'on', 'the', 'causes',
     'of', 'low', 'semen', 'and', 'sperm', 'count', 'I', 'was', 'searching', 'for',
     'this', 'type', 'of', 'information', 'when', 'I', 'found', 'your', 'site', 'I',
     'had', 'nt', 'been', 'made', 'aware', 'of', 'this', 'product', 'before',
     'then', 'so', 'was', 'quite', 'surprised', 'to', 'be', 'able', 'to', 'find',
     'a', 'Male', 'fertility', 'product', 'Usually', 'everything', 'is', 'geared',
     'towards', 'female', 'fertility', 'Suffice', 'to', 'say', 'I', 'ordered',
     'and', 'a', 'few', 'months', 'later', 'we', 'received', 'the', 'good', 'news',
     'from', 'the', 'Doctors', 'My', 'wife', 'is', 'pregnant', 'I', 'ca', 'nt',
     'be', '100', 'sure', 'if', 'it', 'was', 'SpurM', 'that', 'helped', 'But', 'I',
     'am', 'happy', 'enough', 'to', 'be', 'able', 'to', 'say', 'it', 'should', 'be',
     'considered', 'by', 'any', 'man', 'looking', 'to', 'increase', 'his',
     'fertility', 'It', 'worked', 'for', 'me', 'Thanks', 'Roy', 'B', 'Essex', 'UK',
     'http', 'Richardprovencauxnetspur', 'sheep', 'not', 'interested', 'in',
     'promotional', 'campaign', 'go', 'here', 'http', 'Munozprovencauxnetrmphp']


Debido a la naturaleza de los mensajes no deseados, algunos de ellos pueden confundir a la biblioteca Beautiful Soup, avisando esta de que el mensaje puede tratarse de una URL o de una ruta a un fichero, en lugar de un mensaje de correo electrónico. El código de la siguiente celda filtra ese tipo de avisos.


```python
from bs4 import MarkupResemblesLocatorWarning
import warnings

warnings.filterwarnings("ignore", category=MarkupResemblesLocatorWarning)
```

Estamos ya en condiciones de poder construir el filtro de correo electrónico no deseado.


```python
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import TfidfVectorizer # Convertir a vector tf-idf
from sklearn.neighbors import KNeighborsClassifier
```


```python

vectorizador = TfidfVectorizer(analyzer=procesa_mensaje)
vectorizador.fit(contenidos_mensajes_entrenamiento)
```




<style>#sk-container-id-1 {
  /* Definition of color scheme common for light and dark mode */
  --sklearn-color-text: #000;
  --sklearn-color-text-muted: #666;
  --sklearn-color-line: gray;
  /* Definition of color scheme for unfitted estimators */
  --sklearn-color-unfitted-level-0: #fff5e6;
  --sklearn-color-unfitted-level-1: #f6e4d2;
  --sklearn-color-unfitted-level-2: #ffe0b3;
  --sklearn-color-unfitted-level-3: chocolate;
  /* Definition of color scheme for fitted estimators */
  --sklearn-color-fitted-level-0: #f0f8ff;
  --sklearn-color-fitted-level-1: #d4ebff;
  --sklearn-color-fitted-level-2: #b3dbfd;
  --sklearn-color-fitted-level-3: cornflowerblue;
}

#sk-container-id-1.light {
  /* Specific color for light theme */
  --sklearn-color-text-on-default-background: black;
  --sklearn-color-background: white;
  --sklearn-color-border-box: black;
  --sklearn-color-icon: #696969;
}

#sk-container-id-1.dark {
  --sklearn-color-text-on-default-background: white;
  --sklearn-color-background: #111;
  --sklearn-color-border-box: white;
  --sklearn-color-icon: #878787;
}

#sk-container-id-1 {
  color: var(--sklearn-color-text);
}

#sk-container-id-1 pre {
  padding: 0;
}

#sk-container-id-1 input.sk-hidden--visually {
  border: 0;
  clip: rect(1px 1px 1px 1px);
  clip: rect(1px, 1px, 1px, 1px);
  height: 1px;
  margin: -1px;
  overflow: hidden;
  padding: 0;
  position: absolute;
  width: 1px;
}

#sk-container-id-1 div.sk-dashed-wrapped {
  border: 1px dashed var(--sklearn-color-line);
  margin: 0 0.4em 0.5em 0.4em;
  box-sizing: border-box;
  padding-bottom: 0.4em;
  background-color: var(--sklearn-color-background);
}

#sk-container-id-1 div.sk-container {
  /* jupyter's `normalize.less` sets `[hidden] { display: none; }`
     but bootstrap.min.css set `[hidden] { display: none !important; }`
     so we also need the `!important` here to be able to override the
     default hidden behavior on the sphinx rendered scikit-learn.org.
     See: https://github.com/scikit-learn/scikit-learn/issues/21755 */
  display: inline-block !important;
  position: relative;
}

#sk-container-id-1 div.sk-text-repr-fallback {
  display: none;
}

div.sk-parallel-item,
div.sk-serial,
div.sk-item {
  /* draw centered vertical line to link estimators */
  background-image: linear-gradient(var(--sklearn-color-text-on-default-background), var(--sklearn-color-text-on-default-background));
  background-size: 2px 100%;
  background-repeat: no-repeat;
  background-position: center center;
}

/* Parallel-specific style estimator block */

#sk-container-id-1 div.sk-parallel-item::after {
  content: "";
  width: 100%;
  border-bottom: 2px solid var(--sklearn-color-text-on-default-background);
  flex-grow: 1;
}

#sk-container-id-1 div.sk-parallel {
  display: flex;
  align-items: stretch;
  justify-content: center;
  background-color: var(--sklearn-color-background);
  position: relative;
}

#sk-container-id-1 div.sk-parallel-item {
  display: flex;
  flex-direction: column;
}

#sk-container-id-1 div.sk-parallel-item:first-child::after {
  align-self: flex-end;
  width: 50%;
}

#sk-container-id-1 div.sk-parallel-item:last-child::after {
  align-self: flex-start;
  width: 50%;
}

#sk-container-id-1 div.sk-parallel-item:only-child::after {
  width: 0;
}

/* Serial-specific style estimator block */

#sk-container-id-1 div.sk-serial {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: var(--sklearn-color-background);
  padding-right: 1em;
  padding-left: 1em;
}


/* Toggleable style: style used for estimator/Pipeline/ColumnTransformer box that is
clickable and can be expanded/collapsed.
- Pipeline and ColumnTransformer use this feature and define the default style
- Estimators will overwrite some part of the style using the `sk-estimator` class
*/

/* Pipeline and ColumnTransformer style (default) */

#sk-container-id-1 div.sk-toggleable {
  /* Default theme specific background. It is overwritten whether we have a
  specific estimator or a Pipeline/ColumnTransformer */
  background-color: var(--sklearn-color-background);
}

/* Toggleable label */
#sk-container-id-1 label.sk-toggleable__label {
  cursor: pointer;
  display: flex;
  width: 100%;
  margin-bottom: 0;
  padding: 0.5em;
  box-sizing: border-box;
  text-align: center;
  align-items: center;
  justify-content: center;
  gap: 0.5em;
}

#sk-container-id-1 label.sk-toggleable__label .caption {
  font-size: 0.6rem;
  font-weight: lighter;
  color: var(--sklearn-color-text-muted);
}

#sk-container-id-1 label.sk-toggleable__label-arrow:before {
  /* Arrow on the left of the label */
  content: "▸";
  float: left;
  margin-right: 0.25em;
  color: var(--sklearn-color-icon);
}

#sk-container-id-1 label.sk-toggleable__label-arrow:hover:before {
  color: var(--sklearn-color-text);
}

/* Toggleable content - dropdown */

#sk-container-id-1 div.sk-toggleable__content {
  display: none;
  text-align: left;
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-0);
}

#sk-container-id-1 div.sk-toggleable__content.fitted {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-0);
}

#sk-container-id-1 div.sk-toggleable__content pre {
  margin: 0.2em;
  border-radius: 0.25em;
  color: var(--sklearn-color-text);
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-0);
}

#sk-container-id-1 div.sk-toggleable__content.fitted pre {
  /* unfitted */
  background-color: var(--sklearn-color-fitted-level-0);
}

#sk-container-id-1 input.sk-toggleable__control:checked~div.sk-toggleable__content {
  /* Expand drop-down */
  display: block;
  width: 100%;
  overflow: visible;
}

#sk-container-id-1 input.sk-toggleable__control:checked~label.sk-toggleable__label-arrow:before {
  content: "▾";
}

/* Pipeline/ColumnTransformer-specific style */

#sk-container-id-1 div.sk-label input.sk-toggleable__control:checked~label.sk-toggleable__label {
  color: var(--sklearn-color-text);
  background-color: var(--sklearn-color-unfitted-level-2);
}

#sk-container-id-1 div.sk-label.fitted input.sk-toggleable__control:checked~label.sk-toggleable__label {
  background-color: var(--sklearn-color-fitted-level-2);
}

/* Estimator-specific style */

/* Colorize estimator box */
#sk-container-id-1 div.sk-estimator input.sk-toggleable__control:checked~label.sk-toggleable__label {
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-2);
}

#sk-container-id-1 div.sk-estimator.fitted input.sk-toggleable__control:checked~label.sk-toggleable__label {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-2);
}

#sk-container-id-1 div.sk-label label.sk-toggleable__label,
#sk-container-id-1 div.sk-label label {
  /* The background is the default theme color */
  color: var(--sklearn-color-text-on-default-background);
}

/* On hover, darken the color of the background */
#sk-container-id-1 div.sk-label:hover label.sk-toggleable__label {
  color: var(--sklearn-color-text);
  background-color: var(--sklearn-color-unfitted-level-2);
}

/* Label box, darken color on hover, fitted */
#sk-container-id-1 div.sk-label.fitted:hover label.sk-toggleable__label.fitted {
  color: var(--sklearn-color-text);
  background-color: var(--sklearn-color-fitted-level-2);
}

/* Estimator label */

#sk-container-id-1 div.sk-label label {
  font-family: monospace;
  font-weight: bold;
  line-height: 1.2em;
}

#sk-container-id-1 div.sk-label-container {
  text-align: center;
}

/* Estimator-specific */
#sk-container-id-1 div.sk-estimator {
  font-family: monospace;
  border: 1px dotted var(--sklearn-color-border-box);
  border-radius: 0.25em;
  box-sizing: border-box;
  margin-bottom: 0.5em;
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-0);
}

#sk-container-id-1 div.sk-estimator.fitted {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-0);
}

/* on hover */
#sk-container-id-1 div.sk-estimator:hover {
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-2);
}

#sk-container-id-1 div.sk-estimator.fitted:hover {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-2);
}

/* Specification for estimator info (e.g. "i" and "?") */

/* Common style for "i" and "?" */

.sk-estimator-doc-link,
a:link.sk-estimator-doc-link,
a:visited.sk-estimator-doc-link {
  float: right;
  font-size: smaller;
  line-height: 1em;
  font-family: monospace;
  background-color: var(--sklearn-color-unfitted-level-0);
  border-radius: 1em;
  height: 1em;
  width: 1em;
  text-decoration: none !important;
  margin-left: 0.5em;
  text-align: center;
  /* unfitted */
  border: var(--sklearn-color-unfitted-level-3) 1pt solid;
  color: var(--sklearn-color-unfitted-level-3);
}

.sk-estimator-doc-link.fitted,
a:link.sk-estimator-doc-link.fitted,
a:visited.sk-estimator-doc-link.fitted {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-0);
  border: var(--sklearn-color-fitted-level-3) 1pt solid;
  color: var(--sklearn-color-fitted-level-3);
}

/* On hover */
div.sk-estimator:hover .sk-estimator-doc-link:hover,
.sk-estimator-doc-link:hover,
div.sk-label-container:hover .sk-estimator-doc-link:hover,
.sk-estimator-doc-link:hover {
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-3);
  border: var(--sklearn-color-fitted-level-0) 1pt solid;
  color: var(--sklearn-color-unfitted-level-0);
  text-decoration: none;
}

div.sk-estimator.fitted:hover .sk-estimator-doc-link.fitted:hover,
.sk-estimator-doc-link.fitted:hover,
div.sk-label-container:hover .sk-estimator-doc-link.fitted:hover,
.sk-estimator-doc-link.fitted:hover {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-3);
  border: var(--sklearn-color-fitted-level-0) 1pt solid;
  color: var(--sklearn-color-fitted-level-0);
  text-decoration: none;
}

/* Span, style for the box shown on hovering the info icon */
.sk-estimator-doc-link span {
  display: none;
  z-index: 9999;
  position: relative;
  font-weight: normal;
  right: .2ex;
  padding: .5ex;
  margin: .5ex;
  width: min-content;
  min-width: 20ex;
  max-width: 50ex;
  color: var(--sklearn-color-text);
  box-shadow: 2pt 2pt 4pt #999;
  /* unfitted */
  background: var(--sklearn-color-unfitted-level-0);
  border: .5pt solid var(--sklearn-color-unfitted-level-3);
}

.sk-estimator-doc-link.fitted span {
  /* fitted */
  background: var(--sklearn-color-fitted-level-0);
  border: var(--sklearn-color-fitted-level-3);
}

.sk-estimator-doc-link:hover span {
  display: block;
}

/* "?"-specific style due to the `<a>` HTML tag */

#sk-container-id-1 a.estimator_doc_link {
  float: right;
  font-size: 1rem;
  line-height: 1em;
  font-family: monospace;
  background-color: var(--sklearn-color-unfitted-level-0);
  border-radius: 1rem;
  height: 1rem;
  width: 1rem;
  text-decoration: none;
  /* unfitted */
  color: var(--sklearn-color-unfitted-level-1);
  border: var(--sklearn-color-unfitted-level-1) 1pt solid;
}

#sk-container-id-1 a.estimator_doc_link.fitted {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-0);
  border: var(--sklearn-color-fitted-level-1) 1pt solid;
  color: var(--sklearn-color-fitted-level-1);
}

/* On hover */
#sk-container-id-1 a.estimator_doc_link:hover {
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-3);
  color: var(--sklearn-color-background);
  text-decoration: none;
}

#sk-container-id-1 a.estimator_doc_link.fitted:hover {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-3);
}

.estimator-table {
    font-family: monospace;
}

.estimator-table summary {
    padding: .5rem;
    cursor: pointer;
}

.estimator-table summary::marker {
    font-size: 0.7rem;
}

.estimator-table details[open] {
    padding-left: 0.1rem;
    padding-right: 0.1rem;
    padding-bottom: 0.3rem;
}

.estimator-table .parameters-table {
    margin-left: auto !important;
    margin-right: auto !important;
    margin-top: 0;
}

.estimator-table .parameters-table tr:nth-child(odd) {
    background-color: #fff;
}

.estimator-table .parameters-table tr:nth-child(even) {
    background-color: #f6f6f6;
}

.estimator-table .parameters-table tr:hover {
    background-color: #e0e0e0;
}

.estimator-table table td {
    border: 1px solid rgba(106, 105, 104, 0.232);
}

/*
    `table td`is set in notebook with right text-align.
    We need to overwrite it.
*/
.estimator-table table td.param {
    text-align: left;
    position: relative;
    padding: 0;
}

.user-set td {
    color:rgb(255, 94, 0);
    text-align: left !important;
}

.user-set td.value {
    color:rgb(255, 94, 0);
    background-color: transparent;
}

.default td {
    color: black;
    text-align: left !important;
}

.user-set td i,
.default td i {
    color: black;
}

/*
    Styles for parameter documentation links
    We need styling for visited so jupyter doesn't overwrite it
*/
a.param-doc-link,
a.param-doc-link:link,
a.param-doc-link:visited {
    text-decoration: underline dashed;
    text-underline-offset: .3em;
    color: inherit;
    display: block;
    padding: .5em;
}

/* "hack" to make the entire area of the cell containing the link clickable */
a.param-doc-link::before {
    position: absolute;
    content: "";
    inset: 0;
}

.param-doc-description {
    display: none;
    position: absolute;
    z-index: 9999;
    left: 0;
    padding: .5ex;
    margin-left: 1.5em;
    color: var(--sklearn-color-text);
    box-shadow: .3em .3em .4em #999;
    width: max-content;
    text-align: left;
    max-height: 10em;
    overflow-y: auto;

    /* unfitted */
    background: var(--sklearn-color-unfitted-level-0);
    border: thin solid var(--sklearn-color-unfitted-level-3);
}

/* Fitted state for parameter tooltips */
.fitted .param-doc-description {
    /* fitted */
    background: var(--sklearn-color-fitted-level-0);
    border: thin solid var(--sklearn-color-fitted-level-3);
}

.param-doc-link:hover .param-doc-description {
    display: block;
}

.copy-paste-icon {
    background-image: url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0NDggNTEyIj48IS0tIUZvbnQgQXdlc29tZSBGcmVlIDYuNy4yIGJ5IEBmb250YXdlc29tZSAtIGh0dHBzOi8vZm9udGF3ZXNvbWUuY29tIExpY2Vuc2UgLSBodHRwczovL2ZvbnRhd2Vzb21lLmNvbS9saWNlbnNlL2ZyZWUgQ29weXJpZ2h0IDIwMjUgRm9udGljb25zLCBJbmMuLS0+PHBhdGggZD0iTTIwOCAwTDMzMi4xIDBjMTIuNyAwIDI0LjkgNS4xIDMzLjkgMTQuMWw2Ny45IDY3LjljOSA5IDE0LjEgMjEuMiAxNC4xIDMzLjlMNDQ4IDMzNmMwIDI2LjUtMjEuNSA0OC00OCA0OGwtMTkyIDBjLTI2LjUgMC00OC0yMS41LTQ4LTQ4bDAtMjg4YzAtMjYuNSAyMS41LTQ4IDQ4LTQ4ek00OCAxMjhsODAgMCAwIDY0LTY0IDAgMCAyNTYgMTkyIDAgMC0zMiA2NCAwIDAgNDhjMCAyNi41LTIxLjUgNDgtNDggNDhMNDggNTEyYy0yNi41IDAtNDgtMjEuNS00OC00OEwwIDE3NmMwLTI2LjUgMjEuNS00OCA0OC00OHoiLz48L3N2Zz4=);
    background-repeat: no-repeat;
    background-size: 14px 14px;
    background-position: 0;
    display: inline-block;
    width: 14px;
    height: 14px;
    cursor: pointer;
}
</style><body><div id="sk-container-id-1" class="sk-top-container"><div class="sk-text-repr-fallback"><pre>TfidfVectorizer(analyzer=&lt;function procesa_mensaje at 0x00000200739A0A40&gt;)</pre><b>In a Jupyter environment, please rerun this cell to show the HTML representation or trust the notebook. <br />On GitHub, the HTML representation is unable to render, please try loading this page with nbviewer.org.</b></div><div class="sk-container" hidden><div class="sk-item"><div class="sk-estimator fitted sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-1" type="checkbox" checked><label for="sk-estimator-id-1" class="sk-toggleable__label fitted sk-toggleable__label-arrow"><div><div>TfidfVectorizer</div></div><div><a class="sk-estimator-doc-link fitted" rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html">?<span>Documentation for TfidfVectorizer</span></a><span class="sk-estimator-doc-link fitted">i<span>Fitted</span></span></div></label><div class="sk-toggleable__content fitted" data-param-prefix="">
        <div class="estimator-table">
            <details>
                <summary>Parameters</summary>
                <table class="parameters-table">
                  <tbody>

        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('input',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=input,-%7B%27filename%27%2C%20%27file%27%2C%20%27content%27%7D%2C%20default%3D%27content%27">
            input
            <span class="param-doc-description">input: {'filename', 'file', 'content'}, default='content'<br><br>- If `'filename'`, the sequence passed as an argument to fit is<br>  expected to be a list of filenames that need reading to fetch<br>  the raw content to analyze.<br><br>- If `'file'`, the sequence items must have a 'read' method (file-like<br>  object) that is called to fetch the bytes in memory.<br><br>- If `'content'`, the input is expected to be a sequence of items that<br>  can be of type string or byte.</span>
        </a>
    </td>
            <td class="value">&#x27;content&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('encoding',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=encoding,-str%2C%20default%3D%27utf-8%27">
            encoding
            <span class="param-doc-description">encoding: str, default='utf-8'<br><br>If bytes or files are given to analyze, this encoding is used to<br>decode.</span>
        </a>
    </td>
            <td class="value">&#x27;utf-8&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('decode_error',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=decode_error,-%7B%27strict%27%2C%20%27ignore%27%2C%20%27replace%27%7D%2C%20default%3D%27strict%27">
            decode_error
            <span class="param-doc-description">decode_error: {'strict', 'ignore', 'replace'}, default='strict'<br><br>Instruction on what to do if a byte sequence is given to analyze that<br>contains characters not of the given `encoding`. By default, it is<br>'strict', meaning that a UnicodeDecodeError will be raised. Other<br>values are 'ignore' and 'replace'.</span>
        </a>
    </td>
            <td class="value">&#x27;strict&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('strip_accents',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=strip_accents,-%7B%27ascii%27%2C%20%27unicode%27%7D%20or%20callable%2C%20default%3DNone">
            strip_accents
            <span class="param-doc-description">strip_accents: {'ascii', 'unicode'} or callable, default=None<br><br>Remove accents and perform other character normalization<br>during the preprocessing step.<br>'ascii' is a fast method that only works on characters that have<br>a direct ASCII mapping.<br>'unicode' is a slightly slower method that works on any characters.<br>None (default) means no character normalization is performed.<br><br>Both 'ascii' and 'unicode' use NFKD normalization from<br>:func:`unicodedata.normalize`.</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('lowercase',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=lowercase,-bool%2C%20default%3DTrue">
            lowercase
            <span class="param-doc-description">lowercase: bool, default=True<br><br>Convert all characters to lowercase before tokenizing.</span>
        </a>
    </td>
            <td class="value">True</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('preprocessor',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=preprocessor,-callable%2C%20default%3DNone">
            preprocessor
            <span class="param-doc-description">preprocessor: callable, default=None<br><br>Override the preprocessing (string transformation) stage while<br>preserving the tokenizing and n-grams generation steps.<br>Only applies if ``analyzer`` is not callable.</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('tokenizer',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=tokenizer,-callable%2C%20default%3DNone">
            tokenizer
            <span class="param-doc-description">tokenizer: callable, default=None<br><br>Override the string tokenization step while preserving the<br>preprocessing and n-grams generation steps.<br>Only applies if ``analyzer == 'word'``.</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>


        <tr class="user-set">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('analyzer',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=analyzer,-%7B%27word%27%2C%20%27char%27%2C%20%27char_wb%27%7D%20or%20callable%2C%20default%3D%27word%27">
            analyzer
            <span class="param-doc-description">analyzer: {'word', 'char', 'char_wb'} or callable, default='word'<br><br>Whether the feature should be made of word or character n-grams.<br>Option 'char_wb' creates character n-grams only from text inside<br>word boundaries; n-grams at the edges of words are padded with space.<br><br>If a callable is passed it is used to extract the sequence of features<br>out of the raw, unprocessed input.<br><br>.. versionchanged:: 0.21<br>    Since v0.21, if ``input`` is ``'filename'`` or ``'file'``, the data<br>    is first read from the file and then passed to the given callable<br>    analyzer.</span>
        </a>
    </td>
            <td class="value">&lt;function pro...00200739A0A40&gt;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('stop_words',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=stop_words,-%7B%27english%27%7D%2C%20list%2C%20default%3DNone">
            stop_words
            <span class="param-doc-description">stop_words: {'english'}, list, default=None<br><br>If a string, it is passed to _check_stop_list and the appropriate stop<br>list is returned. 'english' is currently the only supported string<br>value.<br>There are several known issues with 'english' and you should<br>consider an alternative (see :ref:`stop_words`).<br><br>If a list, that list is assumed to contain stop words, all of which<br>will be removed from the resulting tokens.<br>Only applies if ``analyzer == 'word'``.<br><br>If None, no stop words will be used. In this case, setting `max_df`<br>to a higher value, such as in the range (0.7, 1.0), can automatically detect<br>and filter stop words based on intra corpus document frequency of terms.</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('token_pattern',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=token_pattern,-str%2C%20default%3Dr%22%28%3Fu%29%5C%5Cb%5C%5Cw%5C%5Cw%2B%5C%5Cb%22">
            token_pattern
            <span class="param-doc-description">token_pattern: str, default=r"(?u)\\b\\w\\w+\\b"<br><br>Regular expression denoting what constitutes a "token", only used<br>if ``analyzer == 'word'``. The default regexp selects tokens of 2<br>or more alphanumeric characters (punctuation is completely ignored<br>and always treated as a token separator).<br><br>If there is a capturing group in token_pattern then the<br>captured group content, not the entire match, becomes the token.<br>At most one capturing group is permitted.</span>
        </a>
    </td>
            <td class="value">&#x27;(?u)\\b\\w\\w+\\b&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('ngram_range',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=ngram_range,-tuple%20%28min_n%2C%20max_n%29%2C%20default%3D%281%2C%201%29">
            ngram_range
            <span class="param-doc-description">ngram_range: tuple (min_n, max_n), default=(1, 1)<br><br>The lower and upper boundary of the range of n-values for different<br>n-grams to be extracted. All values of n such that min_n <= n <= max_n<br>will be used. For example an ``ngram_range`` of ``(1, 1)`` means only<br>unigrams, ``(1, 2)`` means unigrams and bigrams, and ``(2, 2)`` means<br>only bigrams.<br>Only applies if ``analyzer`` is not callable.</span>
        </a>
    </td>
            <td class="value">(1, ...)</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('max_df',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=max_df,-float%20or%20int%2C%20default%3D1.0">
            max_df
            <span class="param-doc-description">max_df: float or int, default=1.0<br><br>When building the vocabulary ignore terms that have a document<br>frequency strictly higher than the given threshold (corpus-specific<br>stop words).<br>If float in range [0.0, 1.0], the parameter represents a proportion of<br>documents, integer absolute counts.<br>This parameter is ignored if vocabulary is not None.</span>
        </a>
    </td>
            <td class="value">1.0</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('min_df',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=min_df,-float%20or%20int%2C%20default%3D1">
            min_df
            <span class="param-doc-description">min_df: float or int, default=1<br><br>When building the vocabulary ignore terms that have a document<br>frequency strictly lower than the given threshold. This value is also<br>called cut-off in the literature.<br>If float in range of [0.0, 1.0], the parameter represents a proportion<br>of documents, integer absolute counts.<br>This parameter is ignored if vocabulary is not None.</span>
        </a>
    </td>
            <td class="value">1</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('max_features',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=max_features,-int%2C%20default%3DNone">
            max_features
            <span class="param-doc-description">max_features: int, default=None<br><br>If not None, build a vocabulary that only consider the top<br>`max_features` ordered by term frequency across the corpus.<br>Otherwise, all features are used.<br><br>This parameter is ignored if vocabulary is not None.</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('vocabulary',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=vocabulary,-Mapping%20or%20iterable%2C%20default%3DNone">
            vocabulary
            <span class="param-doc-description">vocabulary: Mapping or iterable, default=None<br><br>Either a Mapping (e.g., a dict) where keys are terms and values are<br>indices in the feature matrix, or an iterable over terms. If not<br>given, a vocabulary is determined from the input documents.</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('binary',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=binary,-bool%2C%20default%3DFalse">
            binary
            <span class="param-doc-description">binary: bool, default=False<br><br>If True, all non-zero term counts are set to 1. This does not mean<br>outputs will have only 0/1 values, only that the tf term in tf-idf<br>is binary. (Set `binary` to True, `use_idf` to False and<br>`norm` to None to get 0/1 outputs).</span>
        </a>
    </td>
            <td class="value">False</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('dtype',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=dtype,-dtype%2C%20default%3Dfloat64">
            dtype
            <span class="param-doc-description">dtype: dtype, default=float64<br><br>Type of the matrix returned by fit_transform() or transform().</span>
        </a>
    </td>
            <td class="value">&lt;class &#x27;numpy.float64&#x27;&gt;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('norm',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=norm,-%7B%27l1%27%2C%20%27l2%27%7D%20or%20None%2C%20default%3D%27l2%27">
            norm
            <span class="param-doc-description">norm: {'l1', 'l2'} or None, default='l2'<br><br>Each output row will have unit norm, either:<br><br>- 'l2': Sum of squares of vector elements is 1. The cosine<br>  similarity between two vectors is their dot product when l2 norm has<br>  been applied.<br>- 'l1': Sum of absolute values of vector elements is 1.<br>  See :func:`~sklearn.preprocessing.normalize`.<br>- None: No normalization.</span>
        </a>
    </td>
            <td class="value">&#x27;l2&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('use_idf',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=use_idf,-bool%2C%20default%3DTrue">
            use_idf
            <span class="param-doc-description">use_idf: bool, default=True<br><br>Enable inverse-document-frequency reweighting. If False, idf(t) = 1.</span>
        </a>
    </td>
            <td class="value">True</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('smooth_idf',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=smooth_idf,-bool%2C%20default%3DTrue">
            smooth_idf
            <span class="param-doc-description">smooth_idf: bool, default=True<br><br>Smooth idf weights by adding one to document frequencies, as if an<br>extra document was seen containing every term in the collection<br>exactly once. Prevents zero divisions.</span>
        </a>
    </td>
            <td class="value">True</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('sublinear_tf',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html#:~:text=sublinear_tf,-bool%2C%20default%3DFalse">
            sublinear_tf
            <span class="param-doc-description">sublinear_tf: bool, default=False<br><br>Apply sublinear tf scaling, i.e. replace tf with 1 + log(tf).</span>
        </a>
    </td>
            <td class="value">False</td>
        </tr>

                  </tbody>
                </table>
            </details>
        </div>
    </div></div></div></div></div><script>function copyToClipboard(text, element) {
    // Get the parameter prefix from the closest toggleable content
    const toggleableContent = element.closest('.sk-toggleable__content');
    const paramPrefix = toggleableContent ? toggleableContent.dataset.paramPrefix : '';
    const fullParamName = paramPrefix ? `${paramPrefix}${text}` : text;

    const originalStyle = element.style;
    const computedStyle = window.getComputedStyle(element);
    const originalWidth = computedStyle.width;
    const originalHTML = element.innerHTML.replace('Copied!', '');

    navigator.clipboard.writeText(fullParamName)
        .then(() => {
            element.style.width = originalWidth;
            element.style.color = 'green';
            element.innerHTML = "Copied!";

            setTimeout(() => {
                element.innerHTML = originalHTML;
                element.style = originalStyle;
            }, 2000);
        })
        .catch(err => {
            console.error('Failed to copy:', err);
            element.style.color = 'red';
            element.innerHTML = "Failed!";
            setTimeout(() => {
                element.innerHTML = originalHTML;
                element.style = originalStyle;
            }, 2000);
        });
    return false;
}

document.querySelectorAll('.copy-paste-icon').forEach(function(element) {
    const toggleableContent = element.closest('.sk-toggleable__content');
    const paramPrefix = toggleableContent ? toggleableContent.dataset.paramPrefix : '';
    const paramName = element.parentElement.nextElementSibling
        .textContent.trim().split(' ')[0];
    const fullParamName = paramPrefix ? `${paramPrefix}${paramName}` : paramName;

    element.setAttribute('title', fullParamName);
});


/**
 * Adapted from Skrub
 * https://github.com/skrub-data/skrub/blob/403466d1d5d4dc76a7ef569b3f8228db59a31dc3/skrub/_reporting/_data/templates/report.js#L789
 * @returns "light" or "dark"
 */
function detectTheme(element) {
    const body = document.querySelector('body');

    // Check VSCode theme
    const themeKindAttr = body.getAttribute('data-vscode-theme-kind');
    const themeNameAttr = body.getAttribute('data-vscode-theme-name');

    if (themeKindAttr && themeNameAttr) {
        const themeKind = themeKindAttr.toLowerCase();
        const themeName = themeNameAttr.toLowerCase();

        if (themeKind.includes("dark") || themeName.includes("dark")) {
            return "dark";
        }
        if (themeKind.includes("light") || themeName.includes("light")) {
            return "light";
        }
    }

    // Check Jupyter theme
    if (body.getAttribute('data-jp-theme-light') === 'false') {
        return 'dark';
    } else if (body.getAttribute('data-jp-theme-light') === 'true') {
        return 'light';
    }

    // Guess based on a parent element's color
    const color = window.getComputedStyle(element.parentNode, null).getPropertyValue('color');
    const match = color.match(/^rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)\s*$/i);
    if (match) {
        const [r, g, b] = [
            parseFloat(match[1]),
            parseFloat(match[2]),
            parseFloat(match[3])
        ];

        // https://en.wikipedia.org/wiki/HSL_and_HSV#Lightness
        const luma = 0.299 * r + 0.587 * g + 0.114 * b;

        if (luma > 180) {
            // If the text is very bright we have a dark theme
            return 'dark';
        }
        if (luma < 75) {
            // If the text is very dark we have a light theme
            return 'light';
        }
        // Otherwise fall back to the next heuristic.
    }

    // Fallback to system preference
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}


function forceTheme(elementId) {
    const estimatorElement = document.querySelector(`#${elementId}`);
    if (estimatorElement === null) {
        console.error(`Element with id ${elementId} not found.`);
    } else {
        const theme = detectTheme(estimatorElement);
        estimatorElement.classList.add(theme);
    }
}

forceTheme('sk-container-id-1');</script></body>




```python
# total de rasgos
len(vectorizador.get_feature_names_out()) # Lo usamos para saber el número de rasgos que se han extraído de los mensajes de entrenamiento, es decir, el tamaño del vocabulario que se ha construido a partir de los mensajes de entrenamiento.
```




    171221




```python
contenidos_mensajes_entrenamiento[-21]
```




    '"I just wanted to write and thank you for Spur-M. \nI suffered from poor sperm count and motility. I found \nyour site and ordered Spur-M Fertility Blend for Men. \nI have wondered for years what caused low semen and sperm \ncount, and how I could improve my fertility and help my wife\nconceive. Spur-M seems to have done just that! Thank you\nfor your support."\nAndrew H., London, UK\n\n"Spur-M really does help improve fertility and effectiveness\nof sperm and semen motility. I used it for the past few months,\nand not only does it work - I also feel better to. I have \nmore energy. This is an excellent counter to low sperm count\nand motility. I\'ll be buying more!!!"\nFranz K., Bonn, Germany\n\n"I had been wondering on the causes of low semen and \nsperm count, I was searching for this type of information \nwhen I found your site. I hadn\'t been made aware of this \nproduct before then, so was quite surprised to be able \nto find a Male fertility product. Usually everything is \ngeared towards female fertility. Suffice to say I ordered \nand a few months later we received the good news from the \nDoctors - My wife is pregnant. I can\'t be 100% sure if \nit was Spur-M that helped. But I am happy enough to be able\nto say it should be considered by any man looking to increase \nhis fertility. It worked for me. Thanks."\nRoy B., Essex, UK\n\nhttp://Richard.provencaux.net/spur/?sheep\n\n\n\nnot interested in promotional campaign, go here\nhttp://Munoz.provencaux.net/rm.php\n'




```python
# obtener la representacion de 1 documento
tfidf = vectorizador.transform([contenidos_mensajes_entrenamiento[-21]])
```


```python
# valores internos de tfidf
print(tfidf)
```

    <Compressed Sparse Row sparse matrix of dtype 'float64'
    	with 150 stored elements and shape (1, 171221)>
      Coords	Values
      (0, 2972)	0.034484616367522
      (0, 27073)	0.054536963455873035
      (0, 28178)	0.0438099182176285
      (0, 30177)	0.07335954600793722
      (0, 30398)	0.07531821941864801
      (0, 31291)	0.042891765069407645
      (0, 38573)	0.06974950599581041
      (0, 41830)	0.08023673678243118
      (0, 43420)	0.07588016321730563
      (0, 44153)	0.07251630731903697
      (0, 45484)	0.058709981837101355
      (0, 46489)	0.04541650652083856
      (0, 48927)	0.2893622235538194
      (0, 50788)	0.027907769116665482
      (0, 51914)	0.04958443051673252
      (0, 55086)	0.043365478637554335
      (0, 56800)	0.05997371621910099
      (0, 57958)	0.06119658347111242
      (0, 59311)	0.09515499321222422
      (0, 59396)	0.037606120179473734
      (0, 68916)	0.09515499321222422
      (0, 69474)	0.06974950599581041
      (0, 74514)	0.3256746258437044
      (0, 75271)	0.07780482105265907
      (0, 77212)	0.03357215230920081
      :	:
      (0, 154590)	0.036658462163257195
      (0, 154639)	0.061316188148417654
      (0, 156339)	0.04709782888272145
      (0, 156352)	0.03504719161191632
      (0, 156375)	0.049308932766303666
      (0, 156460)	0.03387890544729388
      (0, 156651)	0.03420343921195766
      (0, 157306)	0.12394565966495817
      (0, 157696)	0.05501241299815767
      (0, 158983)	0.0436117346279474
      (0, 160532)	0.03778501394316584
      (0, 162669)	0.0418330519965975
      (0, 162755)	0.07533081800300127
      (0, 162951)	0.020385973694636694
      (0, 163374)	0.02859418935717565
      (0, 163409)	0.030802042248293526
      (0, 163679)	0.10521737106607304
      (0, 164189)	0.06347528523518348
      (0, 164193)	0.05639059233153559
      (0, 164264)	0.030637902207315573
      (0, 164279)	0.04799687288095623
      (0, 164531)	0.04993033759001974
      (0, 168004)	0.035118421529793886
      (0, 168247)	0.028971080887489085
      (0, 168298)	0.054058607468139286



```python
# vamos a buscar las palabras que corresponden a cada posición, e imprimir el valor de tfidf para cada una de ellas
palabras = vectorizador.get_feature_names_out()

indices_no_cero = tfidf.nonzero()[1] # mat5riz esparcida, obtenemos los índices de las columnas que tienen valores no cero, es decir, las palabras que aparecen en el documento y su valor de tf-idf correspondiente.

for i in indices_no_cero:
    print(f'{palabras[i]}: {tfidf[0, i]}')
```

    100: 0.034484616367522
    Andrew: 0.054536963455873035
    B: 0.0438099182176285
    Blend: 0.07335954600793722
    Bonn: 0.07531821941864801
    But: 0.042891765069407645
    Doctors: 0.06974950599581041
    Essex: 0.08023673678243118
    Fertility: 0.07588016321730563
    Franz: 0.07251630731903697
    Germany: 0.058709981837101355
    H: 0.04541650652083856
    I: 0.2893622235538194
    It: 0.027907769116665482
    K: 0.04958443051673252
    London: 0.043365478637554335
    Male: 0.05997371621910099
    Men: 0.06119658347111242
    Munozprovencauxnetrmphp: 0.09515499321222422
    My: 0.037606120179473734
    Richardprovencauxnetspur: 0.09515499321222422
    Roy: 0.06974950599581041
    SpurM: 0.3256746258437044
    Suffice: 0.07780482105265907
    Thank: 0.03357215230920081
    Thanks: 0.024390535836932927
    This: 0.02354710227088937
    UK: 0.09669339361566667
    Usually: 0.0771178969262048
    a: 0.02869448484315645
    able: 0.07223766116163874
    also: 0.027999935553830478
    am: 0.027953737781320796
    an: 0.022095471176530563
    and: 0.16097302305298294
    any: 0.021601494695949842
    aware: 0.043576152112533496
    be: 0.0840812121580213
    been: 0.05062208093661028
    before: 0.03328107266537603
    better: 0.039549447172966185
    buying: 0.04915322561159286
    by: 0.019472282136982818
    ca: 0.04572477548758319
    campaign: 0.05507359628222908
    caused: 0.05525960721759982
    causes: 0.06477837221515624
    conceive: 0.07212181229903804
    considered: 0.04507631296769271
    could: 0.029959776594936784
    count: 0.22054074441092403
    counter: 0.06181066452026896
    does: 0.06624900768265328
    done: 0.039665169448588465
    effectiveness: 0.06426801026292572
    energy: 0.03857858784071797
    enough: 0.044470264880198944
    everything: 0.045951418413832754
    excellent: 0.054251733754736915
    feel: 0.03854756973966164
    female: 0.06650339777115802
    fertility: 0.3256746258437044
    few: 0.07099362028910852
    find: 0.033107269438067466
    for: 0.09721998171222684
    found: 0.08163360066018283
    from: 0.03783914260124454
    geared: 0.07478840471241
    go: 0.03265912251900588
    good: 0.03426743588358306
    had: 0.06468392998639588
    happy: 0.04322764362366079
    have: 0.05015627625774524
    help: 0.06278680930124984
    helped: 0.05544942751419422
    here: 0.02829913172476049
    his: 0.033928941919040854
    how: 0.0319336082001664
    http: 0.0481076716886715
    if: 0.022297099554398073
    improve: 0.10250812415978018
    in: 0.015221446835490352
    increase: 0.040033374489040714
    information: 0.02618237277400497
    interested: 0.03612677677409002
    is: 0.04397645016315159
    it: 0.07904603564643466
    just: 0.05792224392109091
    later: 0.041472335901742534
    ll: 0.035262133460954415
    looking: 0.036557981679229676
    low: 0.12441700770522761
    made: 0.032453611832819876
    man: 0.0449313164084541
    me: 0.021411046776064993
    months: 0.07603206969052392
    more: 0.049170606706019304
    motility: 0.2066798282610254
    my: 0.05565248997240293
    news: 0.04307499039319979
    not: 0.03903442870770566
    nt: 0.054180112583241034
    of: 0.05683793187481364
    on: 0.01564344906670524
    only: 0.027819753925794357
    ordered: 0.10884363242519153
    past: 0.04069888622418238
    poor: 0.058441289578144165
    pregnant: 0.06974950599581041
    product: 0.08116490656742852
    promotional: 0.05936898656328323
    quite: 0.04989516018961137
    really: 0.040989813307697257
    received: 0.03538606529218499
    say: 0.0840827163069981
    searching: 0.0595662117459033
    seems: 0.04819932909516909
    semen: 0.20286458040825586
    sheep: 0.06410394874316916
    should: 0.027822998887802836
    site: 0.07094911014103963
    so: 0.02718348782576164
    sperm: 0.31662281332085435
    suffered: 0.06288656462286601
    support: 0.03676855942881078
    sure: 0.036658462163257195
    surprised: 0.061316188148417654
    thank: 0.04709782888272145
    that: 0.03504719161191632
    the: 0.049308932766303666
    then: 0.03387890544729388
    this: 0.03420343921195766
    to: 0.12394565966495817
    towards: 0.05501241299815767
    type: 0.0436117346279474
    used: 0.03778501394316584
    wanted: 0.0418330519965975
    was: 0.07533081800300127
    we: 0.020385973694636694
    what: 0.02859418935717565
    when: 0.030802042248293526
    wife: 0.10521737106607304
    wondered: 0.06347528523518348
    wondering: 0.05639059233153559
    work: 0.030637902207315573
    worked: 0.04799687288095623
    write: 0.04993033759001974
    years: 0.035118421529793886
    you: 0.028971080887489085
    your: 0.054058607468139286


**Nota de clase**:
- Un itf-idf bajo indica que la palabra es común en el corpus, mientras que un itf-idf alto indica que la palabra es rara en el corpus. Por lo tanto, las palabras con un itf-idf alto pueden ser más útiles para distinguir entre mensajes no deseados y mensajes legítimos, ya que son menos comunes y pueden estar más asociadas a los mensajes no deseados. Por otro lado, las palabras con un itf-idf bajo pueden ser menos útiles para distinguir entre mensajes no deseados y mensajes legítimos, ya que son más comunes y pueden aparecer tanto en mensajes no deseados como en mensajes legítimos.


```python
# buscar la aparicion de "00" en contenidos_mensajes_entrenamiento[-21]
# buscar la seccion donde aparezca, imprimir 30 caracteres hacia atras y adelante

mensaje = contenidos_mensajes_entrenamiento[-21]
patron = "00"

# Buscar todas las ocurrencias de "00"
indice = 0
ocurrencias = []

while indice < len(mensaje):
    posicion = mensaje.find(patron, indice)
    if posicion == -1:
        break
    ocurrencias.append(posicion)
    indice = posicion + 1

# Imprimir el contexto de cada ocurrencia
print(f"Se encontraron {len(ocurrencias)} ocurrencias de '{patron}':\n")
for i, pos in enumerate(ocurrencias, 1):
    inicio = max(0, pos - 60)
    fin = min(len(mensaje), pos + len(patron) + 60)
    contexto = mensaje[inicio:fin]
    print(f"Ocurrencia {i} (posición {pos}):")
    print(f"...{contexto}...")
    print()
```


```python
# mostrar las 10 palabras con mayor valor de tfidf

palabras_con_valores = [(palabras[i], tfidf[0, i]) for i in indices_no_cero]

palabras_ordenadas = sorted(palabras_con_valores, key=lambda x: x[1], reverse=True)

print("Las 10 palabras con mayor valor TF-IDF:\n")
for palabra, valor in palabras_ordenadas[:10]:
    print(f'{palabra}: {valor:.6f}')
```

**Nota de clase**:
- Si alguna palabra clave es "rara", por ejemplo, 33... puede ser que se haya colado algo en el procesado de los mensajes, por lo que es importante revisar el vocabulario aprendido para detectar posibles errores en el preprocesado de los mensajes.
- se puede considerar como una comprobación rápida del preprocesado de los mensajes el revisar el vocabulario aprendido por el vectorizador tf-idf, para detectar posibles errores en el preprocesado de los mensajes. Por ejemplo, si se detecta que hay palabras clave que son números o secuencias de caracteres sin sentido, puede ser un indicio de que se ha colado algo en el procesado de los mensajes, como por ejemplo, que no se han eliminado correctamente los caracteres no alfanuméricos.


```python
filtro_antispam = Pipeline([
    ('vectorizador', TfidfVectorizer(analyzer=procesa_mensaje)),
    ('modelo', KNeighborsClassifier(n_neighbors=5, metric='cosine'))
])
```


```python
filtro_antispam.fit(contenidos_mensajes_entrenamiento,
                    clases_mensajes_entrenamiento)
```


```python
from sklearn.metrics import recall_score
```


```python
predicciones_mensajes_prueba = filtro_antispam.predict(
    contenidos_mensajes_prueba
)
recall_score(clases_mensajes_prueba, predicciones_mensajes_prueba)
```


```python
from sklearn.metrics import (accuracy_score, precision_score, recall_score, 
                             f1_score, confusion_matrix, classification_report)

print("=" * 60)
print("RESUMEN DE EVALUACIÓN DEL FILTRO ANTISPAM")
print("=" * 60)

# Métricas individuales
accuracy = accuracy_score(clases_mensajes_prueba, predicciones_mensajes_prueba)
precision = precision_score(clases_mensajes_prueba, predicciones_mensajes_prueba)
recall = recall_score(clases_mensajes_prueba, predicciones_mensajes_prueba)
f1 = f1_score(clases_mensajes_prueba, predicciones_mensajes_prueba)

print(f"\nMÉTRICAS DE CLASIFICACIÓN:")
print(f"  Exactitud (Accuracy):   {accuracy:.4f}")
print(f"  Precisión (Precision):  {precision:.4f}")
print(f"  Sensibilidad (Recall):  {recall:.4f}")
print(f"  F1-Score:               {f1:.4f}")

# Matriz de confusión
print(f"\nMATRIZ DE CONFUSIÓN:")
cm = confusion_matrix(clases_mensajes_prueba, predicciones_mensajes_prueba)
print(f"                    Predicho: Legítimo  Predicho: Spam")
print(f"  Real: Legítimo           {cm[0][0]:6d}          {cm[0][1]:6d}")
print(f"  Real: Spam               {cm[1][0]:6d}          {cm[1][1]:6d}")

# Reporte de clasificación completo
print(f"\nREPORTE DETALLADO:")
print(classification_report(clases_mensajes_prueba, predicciones_mensajes_prueba, 
                           target_names=['Legítimo', 'No deseado']))

print("=" * 60)
```

#### Apartado 1

En este apartado se pide incorporar al procesado de mensajes los siguientes 2 pasos:

* Expandir las contracciones típicas del idioma inglés. Usar para ello el paquete [contractions](https://github.com/kootenpv/contractions).
* Convertir todos los caracteres a minúsculas.


```python

import contractions

#contractions.fix("I'm")

def expande_contraccion(contenido):
    return [contractions.fix(palabra) for palabra in contenido]
    

def procesa_mensaje(contenido):
    contenido = elimina_html(contenido)
    contenido = expande_contraccion(contenido)
    contenido = word_tokenize(contenido)
    contenido = elimina_no_alfanumerico(contenido)
    return contenido

pprint(procesa_mensaje(contenidos_mensajes_entrenamiento[-21]),compact=True)
```


    ---------------------------------------------------------------------------

    TypeError                                 Traceback (most recent call last)

    Cell In[33], line 16
         13     contenido = elimina_no_alfanumerico(contenido)
         14     return contenido
    ---> 16 pprint(procesa_mensaje(contenidos_mensajes_entrenamiento[-21]),
         17        compact=True)


    Cell In[33], line 12, in procesa_mensaje(contenido)
         10 contenido = elimina_html(contenido)
         11 contenido = expande_contraccion(contenido)
    ---> 12 contenido = word_tokenize(contenido)
         13 contenido = elimina_no_alfanumerico(contenido)
         14 return contenido


    File c:\Users\juana\ETSII_IA\jupyter-env\Lib\site-packages\nltk\tokenize\__init__.py:142, in word_tokenize(text, language, preserve_line)
        127 def word_tokenize(text, language="english", preserve_line=False):
        128     """
        129     Return a tokenized copy of *text*,
        130     using NLTK's recommended word tokenizer
       (...)    140     :type preserve_line: bool
        141     """
    --> 142     sentences = [text] if preserve_line else sent_tokenize(text, language)
        143     return [
        144         token for sent in sentences for token in _treebank_word_tokenizer.tokenize(sent)
        145     ]


    File c:\Users\juana\ETSII_IA\jupyter-env\Lib\site-packages\nltk\tokenize\__init__.py:120, in sent_tokenize(text, language)
        110 """
        111 Return a sentence-tokenized copy of *text*,
        112 using NLTK's recommended sentence tokenizer
       (...)    117 :param language: the model name in the Punkt corpus
        118 """
        119 tokenizer = _get_punkt_tokenizer(language)
    --> 120 return tokenizer.tokenize(text)


    File c:\Users\juana\ETSII_IA\jupyter-env\Lib\site-packages\nltk\tokenize\punkt.py:1282, in PunktSentenceTokenizer.tokenize(self, text, realign_boundaries)
       1278 def tokenize(self, text: str, realign_boundaries: bool = True) -> list[str]:
       1279     """
       1280     Given a text, returns a list of the sentences in that text.
       1281     """
    -> 1282     return list(self.sentences_from_text(text, realign_boundaries))


    File c:\Users\juana\ETSII_IA\jupyter-env\Lib\site-packages\nltk\tokenize\punkt.py:1342, in PunktSentenceTokenizer.sentences_from_text(self, text, realign_boundaries)
       1333 def sentences_from_text(
       1334     self, text: str, realign_boundaries: bool = True
       1335 ) -> list[str]:
       1336     """
       1337     Given a text, generates the sentences in that text by only
       1338     testing candidate sentence breaks. If realign_boundaries is
       1339     True, includes in the sentence closing punctuation that
       1340     follows the period.
       1341     """
    -> 1342     return [text[s:e] for s, e in self.span_tokenize(text, realign_boundaries)]


    File c:\Users\juana\ETSII_IA\jupyter-env\Lib\site-packages\nltk\tokenize\punkt.py:1342, in <listcomp>(.0)
       1333 def sentences_from_text(
       1334     self, text: str, realign_boundaries: bool = True
       1335 ) -> list[str]:
       1336     """
       1337     Given a text, generates the sentences in that text by only
       1338     testing candidate sentence breaks. If realign_boundaries is
       1339     True, includes in the sentence closing punctuation that
       1340     follows the period.
       1341     """
    -> 1342     return [text[s:e] for s, e in self.span_tokenize(text, realign_boundaries)]


    File c:\Users\juana\ETSII_IA\jupyter-env\Lib\site-packages\nltk\tokenize\punkt.py:1330, in PunktSentenceTokenizer.span_tokenize(self, text, realign_boundaries)
       1328 if realign_boundaries:
       1329     slices = self._realign_boundaries(text, slices)
    -> 1330 for sentence in slices:
       1331     yield (sentence.start, sentence.stop)


    File c:\Users\juana\ETSII_IA\jupyter-env\Lib\site-packages\nltk\tokenize\punkt.py:1459, in PunktSentenceTokenizer._realign_boundaries(self, text, slices)
       1446 """
       1447 Attempts to realign punctuation that falls after the period but
       1448 should otherwise be included in the same sentence.
       (...)   1456     ["(Sent1.)", "Sent2."].
       1457 """
       1458 realign = 0
    -> 1459 for sentence1, sentence2 in _pair_iter(slices):
       1460     sentence1 = slice(sentence1.start + realign, sentence1.stop)
       1461     if not sentence2:


    File c:\Users\juana\ETSII_IA\jupyter-env\Lib\site-packages\nltk\tokenize\punkt.py:323, in _pair_iter(iterator)
        321 iterator = iter(iterator)
        322 try:
    --> 323     prev = next(iterator)
        324 except StopIteration:
        325     return


    File c:\Users\juana\ETSII_IA\jupyter-env\Lib\site-packages\nltk\tokenize\punkt.py:1431, in PunktSentenceTokenizer._slices_from_text(self, text)
       1429 def _slices_from_text(self, text: str) -> Iterator[slice]:
       1430     last_break = 0
    -> 1431     for match, context in self._match_potential_end_contexts(text):
       1432         if self.text_contains_sentbreak(context):
       1433             yield slice(last_break, match.end())


    File c:\Users\juana\ETSII_IA\jupyter-env\Lib\site-packages\nltk\tokenize\punkt.py:1396, in PunktSentenceTokenizer._match_potential_end_contexts(self, text)
       1394 previous_slice = slice(0, 0)
       1395 previous_match = None
    -> 1396 for match in self._lang_vars.period_context_re().finditer(text):
       1397     # Get the slice of the previous word
       1398     before_text = text[previous_slice.stop : match.start()]
       1399     index_after_last_space = self._get_last_whitespace_index(before_text)


    TypeError: expected string or bytes-like object, got 'list'


#### Apartado 2

Palabras vacías (_stop words_, en inglés) es el nombre que reciben las palabras tales como artículos, pronombres y preposiciones que se considera que no aportan significado para un sistema de procesamiento del lenguaje natural y que, por tanto, deben eliminarse durante las operaciones de preprocesado de texto. El conjunto adecuado de palabras vacías a usar depende del sistema concreto que se esté construyendo, e incluso puede resultar conveniente no hacer uso de esta técnica.

NLTK provee de conjuntos genéricos de palabras vacías para distintos idiomas.


```python
download('stopwords', download_dir='.')
```


```python
from nltk.corpus import stopwords
from nltk.data import path
path.append(".")
```


```python
palabras_vacias_ingles = stopwords.words('english')
pprint(palabras_vacias_ingles, compact=True)
```

En este apartado se pide incorporar al procesado de mensajes la eliminación de palabras vacías.


```python
def elimina_palabras_vacias(contenido, palabras_vacias_ingles)
    return []

def procesa_mensaje(contenido):
    contenido = elimina_html(contenido)
    contenido = expande_contraccion(contenido)
    contenido = word_tokenize(contenido)
    contenido = elimina_no_alfanumerico(contenido)
    return contenido

procesa_mensaje(contenidos_mensajes_entrenamiento)
```

#### Apartado 3

Por razones gramaticales, en un documento de texto van a aparecer con seguridad diferentes formas de una palabra, como organizar, organiza y organizando. Además, existen familias de palabras relacionadas derivativamente con significados similares, como democracia, democrático y democratización. En muchas situaciones, parece que sería útil reducir esos conjuntos de palabras a una raíz común. Para ello se suelen usar los procedimientos de _stemming_ y lematización.

_Stemming_ generalmente se refiere a un proceso heurístico rudimentario que corta los extremos de las palabras con la esperanza de lograr el objetivo correctamente la mayor parte del tiempo y, a menudo, incluye la eliminación de afijos derivativos. La lematización generalmente se refiere a hacer las cosas correctamente con el uso de un vocabulario y análisis morfológico de las palabras, normalmente con el objetivo de eliminar únicamente las terminaciones flexivas y devolver la forma base o de diccionario de una palabra, lo que se conoce como lema.

NLTK provee de varios algoritmos de _stemming_ y lematización. En este apartado se pide incorporar al procesado de mensajes el procedimiento de _stemming_ mediante el [algoritmo de Lancaster](https://www.nltk.org/api/nltk.stem.lancaster.html).


```python

```

### Ejercicio 2

En el cuaderno NLTK.ipynb se ha construido un sistema de predicción de texto en español basado en modelos de $n$-gramas. Estos modelos se han entrenado a partir de un corpus de textos en español que se ha usado en bruto. El objetivo de este ejercicio es recrear la construcción del sistema de predicción de texto, pero usando una versión normalizada del corpus.

#### Apartado 1

En este apartado se pide:

1. Leer el corpus guardado en el fichero `Texto predictivo/corpus_InfoLibros_parcial.txt` y dividirlo en un corpus de entrenamiento y un corpus de prueba.
2. Construir modelos unigramas, bigramas y trigramas, con y sin suavizado, a partir del corpus de entrenamiento normalizado convirtiendo todas las palabras a minúsculas.
3. Seleccionar el modelo con menor perplejidad sobre el corpus de prueba normalizado convirtiendo todas las palabras a minúsculas.


```python
# Nos aseguramos de haber descargado el tokenizador

from nltk import download

download('punkt', download_dir='.')
```


```python
from nltk.corpus.reader.plaintext import PlaintextCorpusReader
from nltk.data import load
```


```python
corpus_InfoLibros = PlaintextCorpusReader(
    root='Texto predictivo',
    fileids=['corpus_InfoLibros_parcial.txt'],
    encoding='utf8',
    sent_tokenizer=load('tokenizers/punkt/spanish.pickle')
)
```


```python
total_frases = len(corpus_InfoLibros.sents())
total_frases
```


```python
total_frases_entrenamiento = int(total_frases * .8)
total_frases_entrenamiento
```


```python
corpus_entrenamiento = corpus_InfoLibros.sents()[:total_frases_entrenamiento]
```


```python
corpus_prueba = corpus_InfoLibros.sents()[total_frases_entrenamiento:]
```


```python
from nltk.lm.vocabulary import Vocabulary
from nltk.lm.preprocessing import flatten
```


```python
vocabulario_palabras = Vocabulary(
    (palabra.lower()
     for palabra in flatten(corpus_entrenamiento)),  # lista de todas las palabras
    unk_cutoff=50  # mínimo número de ocurrencias
)
```


```python
vocabulario_palabras.lookup('hola')
```


```python
inicio_frase = '<s>'
fin_frase = '</s>'
vocabulario_palabras.update({inicio_frase: 50, fin_frase: 50})
```


```python
def delimita_frase(frase, n):
    return (['<s>'] * (n - 1) +
            [palabra.lower() for palabra in frase] +
            ['</s>'])
```


```python
from pprint import pprint
```


```python
primera_frase_entrenamiento = corpus_entrenamiento[0]
pprint(delimita_frase(primera_frase_entrenamiento, 1),
       compact=True)
pprint(delimita_frase(primera_frase_entrenamiento, 2),
       compact=True)
pprint(delimita_frase(primera_frase_entrenamiento, 3),
       compact=True)
```


```python
from nltk.util import ngrams, bigrams, trigrams
from nltk.lm import MLE, Laplace
```


```python
for ii in ngrams(delimita_frase(corpus_entrenamiento[0], 1), n=1):
    print(ii)
```


```python
modelo_unigrama_MLE = MLE(1, vocabulary=vocabulario_palabras)
modelo_unigrama_MLE.fit
modelo_unigrama_MLE.perplexity(flatten())
```


```python
modelo_unigrama_Laplace = Laplace(1, vocabulary=vocabulario_palabras)
modelo_unigrama_Laplace.fit
modelo_unigrama_Laplace.perplexity(flatten())
```


```python
modelo_bigrama_MLE = MLE(2, vocabulary=vocabulario_palabras)
modelo_bigrama_MLE.fit
modelo_bigrama_MLE.perplexity(flatten())
```


```python
modelo_bigrama_Laplace = Laplace(2, vocabulary=vocabulario_palabras)
modelo_bigrama_Laplace.fit
modelo_bigrama_Laplace.perplexity(flatten())
```


```python
modelo_trigrama_MLE = MLE(3, vocabulary=vocabulario_palabras)
modelo_trigrama_MLE.fit
modelo_trigrama_MLE.perplexity(flatten())
```


```python
modelo_trigrama_Laplace = Laplace(3, vocabulary=vocabulario_palabras)
modelo_trigrama_Laplace.fit
modelo_trigrama_Laplace.perplexity(flatten())
```

#### Apartado 2

Definir una función `predice_palabras` que prediga, a partir de las palabras anteriores y de las letras de la palabra ya escritas, qué palabra se pretende escribir. La función debe actuar como sigue:

* Si todas las letras del prefijo escrito están en minúsculas, entonces debe predecir palabras en minúsculas.
* Si todas las letras del prefijo escrito están en mayúsculas, entonces debe predecir palabras en mayúsculas.
* Si el prefijo escrito mezcla letras en minúsculas y en mayúsculas, entonces:
  * Si la primera letra del prefijo está en minúsculas, entonces debe predecir palabras en minúsculas.
  * Si la primera letra del prefijo está en mayúsculas, entonces debe predecir palabras con la primera letra en mayúsculas y el resto en minúsculas.


```python

```


```python
predice_palabras('nat', ('Lenguaje',), 5, modelo_bigrama_Laplace)
```
