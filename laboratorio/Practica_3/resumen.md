<link rel="stylesheet" href="../../docs/css/estilo.css">

# Resumen de la práctica 3

## instrucciones clave

```python

from email import parser
from email import policy


analizador_de_mesajes = parser.Parser(policy=policy.default)

# analizador de mensajes tiene 1 método principal:
# mensaje = analizador_de_mesajes.parse('fichero') -> devuelve un objeto de tipo email.message.Message
# y el objeto devuelto tiene el método `get_content` -> devuelve el contenido del mensaje en formato texto plano
# contenido_mesaje = mensaje.get_content()

```

```python

# Queremos eliminar palabras vacias como artículos, pronombres, preposiciones, etc. que no aportan significado

from nltk.corpus import stopwords

# Queremos eliminar diferentes formas gramaticales de una misma palabra por ejemplo: organizar, organizado, organización, organizando, etc. -> queremos quedarnos con la raíz de la palabra: organizar

from nltk.stem.lancaster import LancasterStemmer

```
