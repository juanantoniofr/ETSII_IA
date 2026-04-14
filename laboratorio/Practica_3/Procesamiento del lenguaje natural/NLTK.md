# Práctica 3: Procesamiento del lenguaje natural
# Inteligencia Artificial
# Grado en Ingeniería Informática - Ingeniería del Software
# Universidad de Sevilla

[NLTK](https://www.nltk.org) (_Natural Language Toolkit_) es una biblioteca de Python para trabajar con datos del lenguaje humano. Proporciona interfaces fáciles de usar para más de 50 corpus y recursos léxicos, junto con un conjunto de herramientas de procesamiento de texto para clasificación, tokenización, derivación, etiquetado, análisis y razonamiento semántico. Esta práctica presenta una introducción a esa biblioteca, mostrando cómo construir un filtro de correo electrónico no deseado y un sistema de texto predictivo.

En esta práctica también se hará uso de la biblioteca scikit-learn.

En primer lugar establecemos la semilla aleatoria inicial, para que el cuaderno sea reproducible.


```python
import numpy as np
np.random.seed(357823)
```

## Filtro de correo electrónico no deseado

En la comunicación por correo electrónico se emplea el término _spam_ para designar a aquellos mensajes enviados de forma masiva y que no han sido solicitados por sus destinatarios. Los gestores de correo electrónico suelen incorporar la posibilidad de crear filtros de mensajes no deseados que permitan identificar estos de forma automática y actuar en consecuencia (usualmente moviéndolos de la bandeja de
entrada a una carpeta específica).

En esta primera parte de la práctica se va a construir un filtro de correo electrónico que, aplicando técnicas de aprendizaje automático, identifique lo mejor posible los mensajes no deseados. En concreto, se van a considerar los siguientes modelos predictivos:

* Modelo naive Bayes multinomial, usando el modelo de bolsa de palabras como modelo de lenguaje. Se probarán distintos valores del parámetro de suavizado.
* Modelo $k$NN, usando el modelo tf-idf como modelo de lenguaje. Se probarán distintos valores del número de vecinos.

Para entrenar los modelos y evaluar su rendimiento se usará [Enron-Spam](https://auebgr-my.sharepoint.com/:f:/g/personal/nlp_aueb_gr/Em7LRLHD3p9OqKOB3oK8BXoBZMANfisgs-jg0VLsZGQGWw?e=vJdUIF), que es un conjunto público de mensajes (en inglés) de correo electrónico, ya preclasificados en mensajes legítimos y no deseados. Este conjunto se encuentra en la carpeta `Filtro antispam/Enron-Spam/`, dividido en las subcarpetas `train/` (subconjunto de entrenamiento) y `test/` (subconjunto de prueba). En cada una de estas subcarpetas, los mensajes se encuentran organizados, a su vez, en subcarpetas `legítimo` y `no_deseado`.

Los mensajes se proporcionan en bruto, incluyendo las cabeceras. Para su lectura usaremos el paquete [email](https://docs.python.org/es/3/library/email.html) de la biblioteca estándar de Python. Por ejemplo, el contenido del mensaje no deseado `5` del subconjunto de entrenamiento se puede obtener con el siguiente código.


```python
from email import parser
from email import policy
```


```python
analizador_mensaje = parser.Parser(policy=policy.default)
with open('Filtro antispam/Enron-Spam/train/no_deseado/5') as fichero_mensaje:
    mensaje = analizador_mensaje.parse(fichero_mensaje)
    contenido_mensaje_5 = mensaje.get_content()
contenido_mensaje_5
```




    "Hi, \nI have a special offer available for you at our casino.\n\n$20 to try our internet casino, no deposit is necessary!\nAt the casino software's cashier enter bonus code: FR93P\n\n$200 bonus on your first deposit!\nAt the casino software's cashier enter bonus code: FMJKU\n\nAllow us to show you our quality operation, fast payouts,\ngenerous bonuses, and super friendly around-the-clock\ncustomer support.\n\nClick here: http://bigbonus-casino.net \n\nBest regards,\nJamie Zawinsky\n\n\n\nNo thanks: http://bigbonus-casino.com/u/\n\n"



Antes de poder entrenar un modelo de aprendizaje automático capaz de discriminar los mensajes legítimos de los no deseados, es necesario vectorizar el contenido de los mensajes. Es decir, representar esos contenidos mediante vectores numéricos.

En esta práctica, la vectorización del contenido de los mensajes se va a llevar a cabo haciendo uso de un vocabulario fijo de términos que aparecen habitualmente en correos electrónicos no deseados. Ese vocabulario se ha extraído de [spam_words_api_lists](https://github.com/roumilb/spam_words_api_lists) y se encuentra en el fichero `Filtro antispam/términos_spam.txt`.


```python
with open('Filtro antispam/términos_spam.txt', 'r') as f:
    términos_spam = f.read()
términos_spam = términos_spam.split(sep='\n')

print(f"términos: {len(términos_spam)}")
```

    términos: 494


El paquete `pprint` de la biblioteca estándar de Python facilita mostrar el vocabulario de una manera compacta.


```python
from pprint import pprint
```


```python
pprint(términos_spam, compact=True)
print(f"términos: {len(términos_spam)}")
```

    ['#1', '$$$', '$earn extra cash', '$save big money', '$save', '100% free',
     '100% satisfied', '100%', '4u', '50% off', 'accept credit cards', 'acceptance',
     'access', 'accordingly', 'act now!', 'act now', 'action', 'ad',
     'additional income', 'additional', 'addresses on cd', 'affordable',
     'all natural', 'all new', 'amazed', 'amazing stuff', 'amazing', 'americans',
     'apply now', 'apply online', 'as seen on', 'auto email removal',
     'avoid bankruptcy', 'avoid', 'bargain', 'be amazed', 'be your own boss',
     'being a member', 'beneficiary', 'best price', 'beverage', 'big bucks cash',
     'big bucks', 'bill 1618', 'billing address', 'billing', 'billion dollars',
     'billion', 'bonus', 'boss', 'brand new pager', 'bulk email', 'buy direct',
     'buy', 'buying judgments', 'cable converter', 'call free', 'call now', 'call',
     'calling creditors', "can't live without", 'cancel at any time', 'cancel',
     'cannot be combined with any other offer', 'can’t live without',
     'cards accepted', 'cash bonus', 'cash', 'cashcashcash', 'casino', 'celebrity',
     'cell phone cancer scam', 'cents on the dollar', 'certified',
     'certifiedchance', 'chance', 'cheap', 'check or money order', 'check',
     'checkclaims', 'claims not to be selling anything',
     'claims to be in accordance with some spam law', 'claims to be legal',
     'claims', 'clearance', 'click below', 'click here', 'click to remove', 'click',
     'collect child support', 'collect', 'compare rates', 'compare',
     'compete for your business', 'confidentially on all orders', 'congratulations',
     'consolidate debt and credit', 'consolidate your debt', 'copy accurately',
     'copy dvd', 'copy dvds', 'cost', 'costs', 'credit bureaus discount',
     'credit bureaus', 'credit card offers', 'credit', 'cures baldness', 'cures',
     'deal', 'dear', 'debt', 'diagnostics', 'dig up dirt on friends',
     'direct email', 'direct marketing', 'discount', 'do it today', "don't delete",
     "don't hesitate", 'don’t delete', 'don’t hesitate', 'dormant',
     'double your cash', 'double your income', 'double your', 'drastically reduced',
     'earn $', 'earn extra cash', 'earn per week', 'earn', 'easy terms f r e e',
     'easy terms', 'eliminate bad credit', 'eliminate debt', 'email harvest',
     'email marketing', 'exclusive deal', 'expect to earn', 'expire',
     'explode your business', 'extra cash', 'extra income', 'extra', 'f r e e',
     'fantastic deal', 'fantastic', 'fast cash', 'fast viagra delivery', 'fast',
     'financial freedom', 'financially independent', 'for free',
     'for instant access', 'for just $', 'for only', 'for you', 'form',
     'free access', 'free cell phone', 'free consultation', 'free dvd', 'free gift',
     'free grant money', 'free hosting', 'free info', 'free installation',
     'free instant', 'free investment', 'free leads', 'free membership',
     'free money', 'free offer', 'free preview', 'free priority mail', 'free quote',
     'free sample', 'free trial', 'free website', 'free', 'freedom', 'friend',
     'full refund', 'get it now', 'get out of debt', 'get paid', 'get started now',
     'get', 'gift certificate', 'give it away', 'giving away', 'great offer',
     'great', 'guarantee', 'guaranteed', 'have you been turned down?', 'hello',
     'here', 'hidden assets', 'hidden charges', 'hidden', 'home based business',
     'home based', 'home employment', 'home', 'homebased business',
     'human growth hormone', 'if only it were that easy',
     'important information regarding', 'in accordance with laws',
     'income from home', 'income', 'increase sales', 'increase traffic',
     'increase your sales', 'incredible deal', 'info you requested',
     'information you requested', 'instant', 'insurance', 'internet market',
     'internet marketing', 'investment decision', 'investment', 'it’s effective',
     'join millions of americans', 'join millions of', 'join millions', 'junk',
     'laser printer', 'leave', 'legal', 'life insurance', 'life', 'lifetime',
     'limited time offer', 'limited time only', 'limited time', 'limited', 'loan',
     'loans', 'long distance phone offer', 'lose weight spam', 'lose weight',
     'lose weightlose weight spam', 'lose', 'lower interest rate',
     'lower interest rates', 'lower monthly payment', 'lower your mortgage rate',
     'lowest insurance rates', 'lowest price', 'luxury car', 'luxury',
     'mail in order form', 'maintained', 'make $', 'make money',
     'marketing solutions', 'marketing', 'mass email', 'medicine', 'medium',
     'meet singles', 'member stuff', 'member', 'message contains disclaimer',
     'message contains', 'million dollars', 'million', 'miracle', 'mlm',
     'money back', 'money making', 'money', 'month trial offer',
     'more internet traffic', 'mortgage rates', 'mortgage', 'multi level marketing',
     'multi-level marketing', 'name brand', 'never', 'new customers only',
     'new domain extensions', 'nigerian', 'no age restrictions', 'no catch',
     'no claim forms', 'no cost', 'no credit check', 'no disappointment',
     'no experience', 'no fees', 'no gimmick', 'no hidden costs', 'no hidden',
     'no interests', 'no inventory', 'no investment', 'no medical exams',
     'no middleman', 'no obligation', 'no purchase necessary', 'no questions asked',
     'no refund!', 'no refund', 'no selling', 'no strings attached',
     'no-obligation', 'not intended', 'not intendednot junk', 'not spam', 'notspam',
     'now only', 'now', 'obligation', 'off shore', 'offer expires', 'offer',
     'offshore', 'once in lifetime', 'one hundred percent free',
     'one hundred percent guaranteed', 'one time mailing', 'one time',
     'online biz opportunity', 'online degree', 'online marketing',
     'online pharmacy', 'only $', 'only', 'open', 'opportunity', 'opt in',
     'order now', 'order shipped by', 'order status', 'order today', 'order',
     'orders shipped by', 'outstanding values', 'passwords', 'pennies a day price',
     'pennies a day', 'per day', 'per week', 'performance', 'phone', 'please read',
     'potential earnings', 'pre-approved', 'presently', 'price',
     'print form signature', 'print out and fax', 'priority mail', 'prize',
     'prizes', 'problem', 'produced and sent out', 'profits', 'promise you',
     'promise', 'purchase', 'pure profit', 'pure profits', 'quote', 'rates',
     'real thing', 'refinance home', 'refinance', 'refund', 'removal instructions',
     'removal', 'remove', 'removes wrinkles', 'request',
     'requires initial investment', 'reserves the right', 'reverses aging',
     'reverses', 'risk free', 'rolex', 'round the world', 's 1618',
     'safeguard notice', 'sale', 'sales', 'sample', 'satisfaction guaranteed',
     'satisfaction', 'satisfied', 'save $', 'save big money', 'save up to', 'save',
     'score with babes', 'score', 'search engine listings', 'search engines',
     'section 301', 'see for yourself', 'sent in compliance', 'serious cash',
     'serious only', 'serious', 'shopper', 'shopping spree', 'sign up free today',
     'social security number', 'solution', 'spam', 'special promotion',
     'stainless steel', 'stock alert', 'stock disclaimer statement', 'stock pick',
     'stop snoring', 'stop', 'strong buy', 'stuff on sale', 'subject to cash',
     'subject to credit', 'subscribe', 'subscribethe following form', 'success',
     'supplies are limited', 'supplies', 'take action now', 'take action',
     'talks about hidden charges', 'talks about prizes', 'teen',
     'tells you it’s an ad', 'terms and conditions', 'terms', 'the best rates',
     'the following form', 'they keep your money', 'they’re just giving it away',
     "this isn't junk", "this isn't spam", 'this isn’t a scam', 'this isn’t junk',
     'this isn’t spam', 'this won’t last', 'thousands', 'time limited', 'traffic',
     'trial', 'undisclosed recipient', 'university diplomas', 'unlimited',
     'unsecured credit', 'unsecured debt', 'unsolicited', 'unsubscribe', 'urgent',
     'us dollars', 'vacation offers', 'vacation', 'valium', 'viagra delivery',
     'viagra', 'vicodin', 'visit our website', 'wants credit card', 'warranty',
     'we hate spam', 'we honor all', 'web traffic', 'weekend getaway',
     'weight loss', 'weight', 'what are you waiting for?', 'what’s keeping you?',
     'while supplies last', 'while you sleep', 'who really wins?', 'why pay more?',
     'wife', 'will not believe your eyes', 'win', 'winner', 'winning', 'won',
     'work at home', 'work from home', 'xanax', 'you are a winner!',
     'you have been selected', 'your income', 'you’re a winner!']
    términos: 494


Obsérvese que el vocabulario contiene términos de hasta 9 palabras, algo que habrá que tener en cuenta al construir los vectorizadores del contenido de los mensajes.


```python
max(len(término.split()) for término in términos_spam)
```




    9



El primer vectorizador que vamos a construir es el modelo de bolsa de palabras, que representará el contenido de cada mensaje mediante **el vector del número de ocurrencias en el mensaje de cada término del vocabulario**. La clase `CountVectorizer` de scikit-learn implementa este modelo de lenguaje.


```python
from sklearn.feature_extraction.text import CountVectorizer
```

Una vez creada una instancia de esta clase, sería posible, a través del método `fit`, pedirle que aprendiera el vocabulario de términos a partir de un corpus de entrenamiento. Nosotros, sin embargo, usamos un vocabulario fijo y, por tanto, hay que proporcionárselo explícitamente.


```python
vectorizador = CountVectorizer(vocabulary=términos_spam)
```

Ahora basta aplicar el método `fit_transform` del vectorizador para obtener la representación como bolsa de palabras de la secuencia de contenidos de mensajes proporcionada. A la hora de mostrar esa representación, debe tenerse en cuenta que se obtiene en forma de matriz dispersa (_sparse matrix_).

**Nota**: aunque, como se ha comentado antes, el vocabulario es fijo, sigue siendo adecuado aplicar el método `fit`, ya que este realiza una serie de comprobaciones convenientes.


```python
vectorizador.fit_transform([contenido_mensaje_5]).toarray()

```




    array([[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0]])



El proceso de vectorización de una cadena consta de cuatro pasos:

1. En primer lugar, un preprocesador transforma la cadena a un formato adecuado. El preprocesamiento por defecto de CountVectorizer consiste en transformar la cadena a minúsculas.
2. A continuación, un tokenizador divide la cadena en una secuencia de tókenes. El tokenizador por defecto de CountVectorizer divide la cadena en tókenes constituidos por dos o más caracteres alfanuméricos.
3. Un analizador construye entonces los atributos que representan a la cadena. El analizador por defecto de CountVectorizer construye unigramas de tókenes.
4. Finalmente, se cuentan las ocurrencias de los atributos que sean términos del vocabulario.

### ¿Qué diferencia hay entre build_tokenizer() y build_analyzer()?

Diferencia clave:

**build_tokenizer()**
- Devuelve solo la función que separa texto en tokens.
- No genera n-gramas ni aplica todo el pipeline completo.
- Por eso en tu ejemplo lo llamas sobre el texto ya preprocesado (preprocesador(...)).

**build_analyzer()**
Devuelve la función completa de análisis de características para el vectorizador.
Incluye internamente:

- preprocesado (por ejemplo, minúsculas),
- tokenización,
- construcción de n-gramas según ngram_range,
- filtrados internos del vectorizador.
- Se le pasa el texto crudo directamente.

En tu caso concreto:

tokenizador(...) te devuelve palabras/tokens.
analizador(...) te devuelve las características finales que se van a contar (con tu configuración, desde 1-gramas hasta 9-gramas).
Regla práctica:

- Si quieres inspeccionar cómo se parte el texto: build_tokenizer.
- Si quieres ver exactamente qué usa CountVectorizer para crear el vector: build_analyzer.


```python
preprocesador = vectorizador.build_preprocessor()
preprocesador(contenido_mensaje_5)
```




    "hi, \ni have a special offer available for you at our casino.\n\n$20 to try our internet casino, no deposit is necessary!\nat the casino software's cashier enter bonus code: fr93p\n\n$200 bonus on your first deposit!\nat the casino software's cashier enter bonus code: fmjku\n\nallow us to show you our quality operation, fast payouts,\ngenerous bonuses, and super friendly around-the-clock\ncustomer support.\n\nclick here: http://bigbonus-casino.net \n\nbest regards,\njamie zawinsky\n\n\n\nno thanks: http://bigbonus-casino.com/u/\n\n"




```python
tokenizador = vectorizador.build_tokenizer()
pprint(tokenizador(preprocesador(contenido_mensaje_5)),
       compact=True)

```

    ['hi', 'have', 'special', 'offer', 'available', 'for', 'you', 'at', 'our',
     'casino', '20', 'to', 'try', 'our', 'internet', 'casino', 'no', 'deposit',
     'is', 'necessary', 'at', 'the', 'casino', 'software', 'cashier', 'enter',
     'bonus', 'code', 'fr93p', '200', 'bonus', 'on', 'your', 'first', 'deposit',
     'at', 'the', 'casino', 'software', 'cashier', 'enter', 'bonus', 'code',
     'fmjku', 'allow', 'us', 'to', 'show', 'you', 'our', 'quality', 'operation',
     'fast', 'payouts', 'generous', 'bonuses', 'and', 'super', 'friendly', 'around',
     'the', 'clock', 'customer', 'support', 'click', 'here', 'http', 'bigbonus',
     'casino', 'net', 'best', 'regards', 'jamie', 'zawinsky', 'no', 'thanks',
     'http', 'bigbonus', 'casino', 'com']



```python
analizador = vectorizador.build_analyzer()
pprint(analizador(contenido_mensaje_5),
       compact=True)
```

    ['hi', 'have', 'special', 'offer', 'available', 'for', 'you', 'at', 'our',
     'casino', '20', 'to', 'try', 'our', 'internet', 'casino', 'no', 'deposit',
     'is', 'necessary', 'at', 'the', 'casino', 'software', 'cashier', 'enter',
     'bonus', 'code', 'fr93p', '200', 'bonus', 'on', 'your', 'first', 'deposit',
     'at', 'the', 'casino', 'software', 'cashier', 'enter', 'bonus', 'code',
     'fmjku', 'allow', 'us', 'to', 'show', 'you', 'our', 'quality', 'operation',
     'fast', 'payouts', 'generous', 'bonuses', 'and', 'super', 'friendly', 'around',
     'the', 'clock', 'customer', 'support', 'click', 'here', 'http', 'bigbonus',
     'casino', 'net', 'best', 'regards', 'jamie', 'zawinsky', 'no', 'thanks',
     'http', 'bigbonus', 'casino', 'com']


Para nuestros propósitos, nos interesa usar un tokenizador más avanzado que el usado por defecto. En concreto, usaremos el tokenizador recomendado por NLTK, que divide cualquier texto en párrafos, frases y palabras como sigue: las líneas en blanco separan los párrafos; las frases se separan en palabras formadas bien por secuencias de caracteres alfanuméricos, bien por secuencias de caracteres no alfanuméricos ni espacios (que se descartan); los párrafos se separan en frases usando un modelo entrenado mediante aprendizaje no supervisado que se ha comprobado que funciona bien para muchos lenguajes europeos.

El tokenizador está implementado por la función `word_tokenize` del módulo `nltk.tokenize`, que usa el modelo de separación de párrafos en frases implementado en el módulo `nltk.tokenize.punkt`. En principio, la documentación recomienda entrenar este modelo con un corpus adecuado para la tarea que se pretende realizar. No obstante, NLTK proporciona modelo preentrenados para distintos idiomas, pero para poder usarlos es necesario descargar previamente sus parámetros.


```python
# Los corpus, gramáticas, tokenizadores, etcétera que proporciona NLTK se descargan y buscan en ciertas carpetas por defecto.
# Para usar una carpeta distinta a ellas es necesario establecer la variable de entorno NLTK_DATA, con la prevención de hacerlo
# antes de cargar el paquete nltk

import os
os.environ['NLTK_DATA'] = '.'
```


```python
from nltk import download

download('punkt_tab')
```

    [nltk_data] Downloading package punkt_tab to ....
    [nltk_data]   Unzipping tokenizers/punkt_tab.zip.





    True




```python
from nltk.tokenize import word_tokenize
```

Basta entonces indicarle al vectorizador que use el tokenizador proporcionado por NLTK que, además, por defecto usa el modelo de separación en frases preentrenado para el idioma inglés. También nos interesa que los atributos construidos por el analizador sean desde unigramas hasta 9-gramas.


```python
vectorizador = CountVectorizer(vocabulary=términos_spam,
                               token_pattern=None,  # Anulamos el tokenizador por defecto basado en expresiones regulares
                               tokenizer=word_tokenize,  # Usamos el tokenizador proporcionado por NLTK
                               ngram_range=(1, 9))
```


```python
tokenizador = vectorizador.build_tokenizer()
pprint(tokenizador(preprocesador(contenido_mensaje_5)),
       compact=True)
```

    ['hi', ',', 'i', 'have', 'a', 'special', 'offer', 'available', 'for', 'you',
     'at', 'our', 'casino', '.', '$', '20', 'to', 'try', 'our', 'internet',
     'casino', ',', 'no', 'deposit', 'is', 'necessary', '!', 'at', 'the', 'casino',
     'software', "'s", 'cashier', 'enter', 'bonus', 'code', ':', 'fr93p', '$',
     '200', 'bonus', 'on', 'your', 'first', 'deposit', '!', 'at', 'the', 'casino',
     'software', "'s", 'cashier', 'enter', 'bonus', 'code', ':', 'fmjku', 'allow',
     'us', 'to', 'show', 'you', 'our', 'quality', 'operation', ',', 'fast',
     'payouts', ',', 'generous', 'bonuses', ',', 'and', 'super', 'friendly',
     'around-the-clock', 'customer', 'support', '.', 'click', 'here', ':', 'http',
     ':', '//bigbonus-casino.net', 'best', 'regards', ',', 'jamie', 'zawinsky',
     'no', 'thanks', ':', 'http', ':', '//bigbonus-casino.com/u/']



```python
analizador = vectorizador.build_analyzer()
pprint(analizador(contenido_mensaje_5),
       compact=True)
```

    ['hi', ',', 'i', 'have', 'a', 'special', 'offer', 'available', 'for', 'you',
     'at', 'our', 'casino', '.', '$', '20', 'to', 'try', 'our', 'internet',
     'casino', ',', 'no', 'deposit', 'is', 'necessary', '!', 'at', 'the', 'casino',
     'software', "'s", 'cashier', 'enter', 'bonus', 'code', ':', 'fr93p', '$',
     '200', 'bonus', 'on', 'your', 'first', 'deposit', '!', 'at', 'the', 'casino',
     'software', "'s", 'cashier', 'enter', 'bonus', 'code', ':', 'fmjku', 'allow',
     'us', 'to', 'show', 'you', 'our', 'quality', 'operation', ',', 'fast',
     'payouts', ',', 'generous', 'bonuses', ',', 'and', 'super', 'friendly',
     'around-the-clock', 'customer', 'support', '.', 'click', 'here', ':', 'http',
     ':', '//bigbonus-casino.net', 'best', 'regards', ',', 'jamie', 'zawinsky',
     'no', 'thanks', ':', 'http', ':', '//bigbonus-casino.com/u/', 'hi ,', ', i',
     'i have', 'have a', 'a special', 'special offer', 'offer available',
     'available for', 'for you', 'you at', 'at our', 'our casino', 'casino .',
     '. $', '$ 20', '20 to', 'to try', 'try our', 'our internet', 'internet casino',
     'casino ,', ', no', 'no deposit', 'deposit is', 'is necessary', 'necessary !',
     '! at', 'at the', 'the casino', 'casino software', "software 's", "'s cashier",
     'cashier enter', 'enter bonus', 'bonus code', 'code :', ': fr93p', 'fr93p $',
     '$ 200', '200 bonus', 'bonus on', 'on your', 'your first', 'first deposit',
     'deposit !', '! at', 'at the', 'the casino', 'casino software', "software 's",
     "'s cashier", 'cashier enter', 'enter bonus', 'bonus code', 'code :',
     ': fmjku', 'fmjku allow', 'allow us', 'us to', 'to show', 'show you',
     'you our', 'our quality', 'quality operation', 'operation ,', ', fast',
     'fast payouts', 'payouts ,', ', generous', 'generous bonuses', 'bonuses ,',
     ', and', 'and super', 'super friendly', 'friendly around-the-clock',
     'around-the-clock customer', 'customer support', 'support .', '. click',
     'click here', 'here :', ': http', 'http :', ': //bigbonus-casino.net',
     '//bigbonus-casino.net best', 'best regards', 'regards ,', ', jamie',
     'jamie zawinsky', 'zawinsky no', 'no thanks', 'thanks :', ': http', 'http :',
     ': //bigbonus-casino.com/u/', 'hi , i', ', i have', 'i have a',
     'have a special', 'a special offer', 'special offer available',
     'offer available for', 'available for you', 'for you at', 'you at our',
     'at our casino', 'our casino .', 'casino . $', '. $ 20', '$ 20 to',
     '20 to try', 'to try our', 'try our internet', 'our internet casino',
     'internet casino ,', 'casino , no', ', no deposit', 'no deposit is',
     'deposit is necessary', 'is necessary !', 'necessary ! at', '! at the',
     'at the casino', 'the casino software', "casino software 's",
     "software 's cashier", "'s cashier enter", 'cashier enter bonus',
     'enter bonus code', 'bonus code :', 'code : fr93p', ': fr93p $', 'fr93p $ 200',
     '$ 200 bonus', '200 bonus on', 'bonus on your', 'on your first',
     'your first deposit', 'first deposit !', 'deposit ! at', '! at the',
     'at the casino', 'the casino software', "casino software 's",
     "software 's cashier", "'s cashier enter", 'cashier enter bonus',
     'enter bonus code', 'bonus code :', 'code : fmjku', ': fmjku allow',
     'fmjku allow us', 'allow us to', 'us to show', 'to show you', 'show you our',
     'you our quality', 'our quality operation', 'quality operation ,',
     'operation , fast', ', fast payouts', 'fast payouts ,', 'payouts , generous',
     ', generous bonuses', 'generous bonuses ,', 'bonuses , and', ', and super',
     'and super friendly', 'super friendly around-the-clock',
     'friendly around-the-clock customer', 'around-the-clock customer support',
     'customer support .', 'support . click', '. click here', 'click here :',
     'here : http', ': http :', 'http : //bigbonus-casino.net',
     ': //bigbonus-casino.net best', '//bigbonus-casino.net best regards',
     'best regards ,', 'regards , jamie', ', jamie zawinsky', 'jamie zawinsky no',
     'zawinsky no thanks', 'no thanks :', 'thanks : http', ': http :',
     'http : //bigbonus-casino.com/u/', 'hi , i have', ', i have a',
     'i have a special', 'have a special offer', 'a special offer available',
     'special offer available for', 'offer available for you',
     'available for you at', 'for you at our', 'you at our casino',
     'at our casino .', 'our casino . $', 'casino . $ 20', '. $ 20 to',
     '$ 20 to try', '20 to try our', 'to try our internet',
     'try our internet casino', 'our internet casino ,', 'internet casino , no',
     'casino , no deposit', ', no deposit is', 'no deposit is necessary',
     'deposit is necessary !', 'is necessary ! at', 'necessary ! at the',
     '! at the casino', 'at the casino software', "the casino software 's",
     "casino software 's cashier", "software 's cashier enter",
     "'s cashier enter bonus", 'cashier enter bonus code', 'enter bonus code :',
     'bonus code : fr93p', 'code : fr93p $', ': fr93p $ 200', 'fr93p $ 200 bonus',
     '$ 200 bonus on', '200 bonus on your', 'bonus on your first',
     'on your first deposit', 'your first deposit !', 'first deposit ! at',
     'deposit ! at the', '! at the casino', 'at the casino software',
     "the casino software 's", "casino software 's cashier",
     "software 's cashier enter", "'s cashier enter bonus",
     'cashier enter bonus code', 'enter bonus code :', 'bonus code : fmjku',
     'code : fmjku allow', ': fmjku allow us', 'fmjku allow us to',
     'allow us to show', 'us to show you', 'to show you our',
     'show you our quality', 'you our quality operation', 'our quality operation ,',
     'quality operation , fast', 'operation , fast payouts', ', fast payouts ,',
     'fast payouts , generous', 'payouts , generous bonuses',
     ', generous bonuses ,', 'generous bonuses , and', 'bonuses , and super',
     ', and super friendly', 'and super friendly around-the-clock',
     'super friendly around-the-clock customer',
     'friendly around-the-clock customer support',
     'around-the-clock customer support .', 'customer support . click',
     'support . click here', '. click here :', 'click here : http', 'here : http :',
     ': http : //bigbonus-casino.net', 'http : //bigbonus-casino.net best',
     ': //bigbonus-casino.net best regards', '//bigbonus-casino.net best regards ,',
     'best regards , jamie', 'regards , jamie zawinsky', ', jamie zawinsky no',
     'jamie zawinsky no thanks', 'zawinsky no thanks :', 'no thanks : http',
     'thanks : http :', ': http : //bigbonus-casino.com/u/', 'hi , i have a',
     ', i have a special', 'i have a special offer',
     'have a special offer available', 'a special offer available for',
     'special offer available for you', 'offer available for you at',
     'available for you at our', 'for you at our casino', 'you at our casino .',
     'at our casino . $', 'our casino . $ 20', 'casino . $ 20 to', '. $ 20 to try',
     '$ 20 to try our', '20 to try our internet', 'to try our internet casino',
     'try our internet casino ,', 'our internet casino , no',
     'internet casino , no deposit', 'casino , no deposit is',
     ', no deposit is necessary', 'no deposit is necessary !',
     'deposit is necessary ! at', 'is necessary ! at the',
     'necessary ! at the casino', '! at the casino software',
     "at the casino software 's", "the casino software 's cashier",
     "casino software 's cashier enter", "software 's cashier enter bonus",
     "'s cashier enter bonus code", 'cashier enter bonus code :',
     'enter bonus code : fr93p', 'bonus code : fr93p $', 'code : fr93p $ 200',
     ': fr93p $ 200 bonus', 'fr93p $ 200 bonus on', '$ 200 bonus on your',
     '200 bonus on your first', 'bonus on your first deposit',
     'on your first deposit !', 'your first deposit ! at', 'first deposit ! at the',
     'deposit ! at the casino', '! at the casino software',
     "at the casino software 's", "the casino software 's cashier",
     "casino software 's cashier enter", "software 's cashier enter bonus",
     "'s cashier enter bonus code", 'cashier enter bonus code :',
     'enter bonus code : fmjku', 'bonus code : fmjku allow',
     'code : fmjku allow us', ': fmjku allow us to', 'fmjku allow us to show',
     'allow us to show you', 'us to show you our', 'to show you our quality',
     'show you our quality operation', 'you our quality operation ,',
     'our quality operation , fast', 'quality operation , fast payouts',
     'operation , fast payouts ,', ', fast payouts , generous',
     'fast payouts , generous bonuses', 'payouts , generous bonuses ,',
     ', generous bonuses , and', 'generous bonuses , and super',
     'bonuses , and super friendly', ', and super friendly around-the-clock',
     'and super friendly around-the-clock customer',
     'super friendly around-the-clock customer support',
     'friendly around-the-clock customer support .',
     'around-the-clock customer support . click', 'customer support . click here',
     'support . click here :', '. click here : http', 'click here : http :',
     'here : http : //bigbonus-casino.net', ': http : //bigbonus-casino.net best',
     'http : //bigbonus-casino.net best regards',
     ': //bigbonus-casino.net best regards ,',
     '//bigbonus-casino.net best regards , jamie', 'best regards , jamie zawinsky',
     'regards , jamie zawinsky no', ', jamie zawinsky no thanks',
     'jamie zawinsky no thanks :', 'zawinsky no thanks : http',
     'no thanks : http :', 'thanks : http : //bigbonus-casino.com/u/',
     'hi , i have a special', ', i have a special offer',
     'i have a special offer available', 'have a special offer available for',
     'a special offer available for you', 'special offer available for you at',
     'offer available for you at our', 'available for you at our casino',
     'for you at our casino .', 'you at our casino . $', 'at our casino . $ 20',
     'our casino . $ 20 to', 'casino . $ 20 to try', '. $ 20 to try our',
     '$ 20 to try our internet', '20 to try our internet casino',
     'to try our internet casino ,', 'try our internet casino , no',
     'our internet casino , no deposit', 'internet casino , no deposit is',
     'casino , no deposit is necessary', ', no deposit is necessary !',
     'no deposit is necessary ! at', 'deposit is necessary ! at the',
     'is necessary ! at the casino', 'necessary ! at the casino software',
     "! at the casino software 's", "at the casino software 's cashier",
     "the casino software 's cashier enter",
     "casino software 's cashier enter bonus",
     "software 's cashier enter bonus code", "'s cashier enter bonus code :",
     'cashier enter bonus code : fr93p', 'enter bonus code : fr93p $',
     'bonus code : fr93p $ 200', 'code : fr93p $ 200 bonus',
     ': fr93p $ 200 bonus on', 'fr93p $ 200 bonus on your',
     '$ 200 bonus on your first', '200 bonus on your first deposit',
     'bonus on your first deposit !', 'on your first deposit ! at',
     'your first deposit ! at the', 'first deposit ! at the casino',
     'deposit ! at the casino software', "! at the casino software 's",
     "at the casino software 's cashier", "the casino software 's cashier enter",
     "casino software 's cashier enter bonus",
     "software 's cashier enter bonus code", "'s cashier enter bonus code :",
     'cashier enter bonus code : fmjku', 'enter bonus code : fmjku allow',
     'bonus code : fmjku allow us', 'code : fmjku allow us to',
     ': fmjku allow us to show', 'fmjku allow us to show you',
     'allow us to show you our', 'us to show you our quality',
     'to show you our quality operation', 'show you our quality operation ,',
     'you our quality operation , fast', 'our quality operation , fast payouts',
     'quality operation , fast payouts ,', 'operation , fast payouts , generous',
     ', fast payouts , generous bonuses', 'fast payouts , generous bonuses ,',
     'payouts , generous bonuses , and', ', generous bonuses , and super',
     'generous bonuses , and super friendly',
     'bonuses , and super friendly around-the-clock',
     ', and super friendly around-the-clock customer',
     'and super friendly around-the-clock customer support',
     'super friendly around-the-clock customer support .',
     'friendly around-the-clock customer support . click',
     'around-the-clock customer support . click here',
     'customer support . click here :', 'support . click here : http',
     '. click here : http :', 'click here : http : //bigbonus-casino.net',
     'here : http : //bigbonus-casino.net best',
     ': http : //bigbonus-casino.net best regards',
     'http : //bigbonus-casino.net best regards ,',
     ': //bigbonus-casino.net best regards , jamie',
     '//bigbonus-casino.net best regards , jamie zawinsky',
     'best regards , jamie zawinsky no', 'regards , jamie zawinsky no thanks',
     ', jamie zawinsky no thanks :', 'jamie zawinsky no thanks : http',
     'zawinsky no thanks : http :', 'no thanks : http : //bigbonus-casino.com/u/',
     'hi , i have a special offer', ', i have a special offer available',
     'i have a special offer available for',
     'have a special offer available for you',
     'a special offer available for you at',
     'special offer available for you at our',
     'offer available for you at our casino', 'available for you at our casino .',
     'for you at our casino . $', 'you at our casino . $ 20',
     'at our casino . $ 20 to', 'our casino . $ 20 to try',
     'casino . $ 20 to try our', '. $ 20 to try our internet',
     '$ 20 to try our internet casino', '20 to try our internet casino ,',
     'to try our internet casino , no', 'try our internet casino , no deposit',
     'our internet casino , no deposit is',
     'internet casino , no deposit is necessary',
     'casino , no deposit is necessary !', ', no deposit is necessary ! at',
     'no deposit is necessary ! at the', 'deposit is necessary ! at the casino',
     'is necessary ! at the casino software',
     "necessary ! at the casino software 's", "! at the casino software 's cashier",
     "at the casino software 's cashier enter",
     "the casino software 's cashier enter bonus",
     "casino software 's cashier enter bonus code",
     "software 's cashier enter bonus code :",
     "'s cashier enter bonus code : fr93p", 'cashier enter bonus code : fr93p $',
     'enter bonus code : fr93p $ 200', 'bonus code : fr93p $ 200 bonus',
     'code : fr93p $ 200 bonus on', ': fr93p $ 200 bonus on your',
     'fr93p $ 200 bonus on your first', '$ 200 bonus on your first deposit',
     '200 bonus on your first deposit !', 'bonus on your first deposit ! at',
     'on your first deposit ! at the', 'your first deposit ! at the casino',
     'first deposit ! at the casino software',
     "deposit ! at the casino software 's", "! at the casino software 's cashier",
     "at the casino software 's cashier enter",
     "the casino software 's cashier enter bonus",
     "casino software 's cashier enter bonus code",
     "software 's cashier enter bonus code :",
     "'s cashier enter bonus code : fmjku",
     'cashier enter bonus code : fmjku allow', 'enter bonus code : fmjku allow us',
     'bonus code : fmjku allow us to', 'code : fmjku allow us to show',
     ': fmjku allow us to show you', 'fmjku allow us to show you our',
     'allow us to show you our quality', 'us to show you our quality operation',
     'to show you our quality operation ,', 'show you our quality operation , fast',
     'you our quality operation , fast payouts',
     'our quality operation , fast payouts ,',
     'quality operation , fast payouts , generous',
     'operation , fast payouts , generous bonuses',
     ', fast payouts , generous bonuses ,', 'fast payouts , generous bonuses , and',
     'payouts , generous bonuses , and super',
     ', generous bonuses , and super friendly',
     'generous bonuses , and super friendly around-the-clock',
     'bonuses , and super friendly around-the-clock customer',
     ', and super friendly around-the-clock customer support',
     'and super friendly around-the-clock customer support .',
     'super friendly around-the-clock customer support . click',
     'friendly around-the-clock customer support . click here',
     'around-the-clock customer support . click here :',
     'customer support . click here : http', 'support . click here : http :',
     '. click here : http : //bigbonus-casino.net',
     'click here : http : //bigbonus-casino.net best',
     'here : http : //bigbonus-casino.net best regards',
     ': http : //bigbonus-casino.net best regards ,',
     'http : //bigbonus-casino.net best regards , jamie',
     ': //bigbonus-casino.net best regards , jamie zawinsky',
     '//bigbonus-casino.net best regards , jamie zawinsky no',
     'best regards , jamie zawinsky no thanks',
     'regards , jamie zawinsky no thanks :', ', jamie zawinsky no thanks : http',
     'jamie zawinsky no thanks : http :',
     'zawinsky no thanks : http : //bigbonus-casino.com/u/',
     'hi , i have a special offer available',
     ', i have a special offer available for',
     'i have a special offer available for you',
     'have a special offer available for you at',
     'a special offer available for you at our',
     'special offer available for you at our casino',
     'offer available for you at our casino .',
     'available for you at our casino . $', 'for you at our casino . $ 20',
     'you at our casino . $ 20 to', 'at our casino . $ 20 to try',
     'our casino . $ 20 to try our', 'casino . $ 20 to try our internet',
     '. $ 20 to try our internet casino', '$ 20 to try our internet casino ,',
     '20 to try our internet casino , no',
     'to try our internet casino , no deposit',
     'try our internet casino , no deposit is',
     'our internet casino , no deposit is necessary',
     'internet casino , no deposit is necessary !',
     'casino , no deposit is necessary ! at', ', no deposit is necessary ! at the',
     'no deposit is necessary ! at the casino',
     'deposit is necessary ! at the casino software',
     "is necessary ! at the casino software 's",
     "necessary ! at the casino software 's cashier",
     "! at the casino software 's cashier enter",
     "at the casino software 's cashier enter bonus",
     "the casino software 's cashier enter bonus code",
     "casino software 's cashier enter bonus code :",
     "software 's cashier enter bonus code : fr93p",
     "'s cashier enter bonus code : fr93p $",
     'cashier enter bonus code : fr93p $ 200',
     'enter bonus code : fr93p $ 200 bonus', 'bonus code : fr93p $ 200 bonus on',
     'code : fr93p $ 200 bonus on your', ': fr93p $ 200 bonus on your first',
     'fr93p $ 200 bonus on your first deposit',
     '$ 200 bonus on your first deposit !', '200 bonus on your first deposit ! at',
     'bonus on your first deposit ! at the',
     'on your first deposit ! at the casino',
     'your first deposit ! at the casino software',
     "first deposit ! at the casino software 's",
     "deposit ! at the casino software 's cashier",
     "! at the casino software 's cashier enter",
     "at the casino software 's cashier enter bonus",
     "the casino software 's cashier enter bonus code",
     "casino software 's cashier enter bonus code :",
     "software 's cashier enter bonus code : fmjku",
     "'s cashier enter bonus code : fmjku allow",
     'cashier enter bonus code : fmjku allow us',
     'enter bonus code : fmjku allow us to', 'bonus code : fmjku allow us to show',
     'code : fmjku allow us to show you', ': fmjku allow us to show you our',
     'fmjku allow us to show you our quality',
     'allow us to show you our quality operation',
     'us to show you our quality operation ,',
     'to show you our quality operation , fast',
     'show you our quality operation , fast payouts',
     'you our quality operation , fast payouts ,',
     'our quality operation , fast payouts , generous',
     'quality operation , fast payouts , generous bonuses',
     'operation , fast payouts , generous bonuses ,',
     ', fast payouts , generous bonuses , and',
     'fast payouts , generous bonuses , and super',
     'payouts , generous bonuses , and super friendly',
     ', generous bonuses , and super friendly around-the-clock',
     'generous bonuses , and super friendly around-the-clock customer',
     'bonuses , and super friendly around-the-clock customer support',
     ', and super friendly around-the-clock customer support .',
     'and super friendly around-the-clock customer support . click',
     'super friendly around-the-clock customer support . click here',
     'friendly around-the-clock customer support . click here :',
     'around-the-clock customer support . click here : http',
     'customer support . click here : http :',
     'support . click here : http : //bigbonus-casino.net',
     '. click here : http : //bigbonus-casino.net best',
     'click here : http : //bigbonus-casino.net best regards',
     'here : http : //bigbonus-casino.net best regards ,',
     ': http : //bigbonus-casino.net best regards , jamie',
     'http : //bigbonus-casino.net best regards , jamie zawinsky',
     ': //bigbonus-casino.net best regards , jamie zawinsky no',
     '//bigbonus-casino.net best regards , jamie zawinsky no thanks',
     'best regards , jamie zawinsky no thanks :',
     'regards , jamie zawinsky no thanks : http',
     ', jamie zawinsky no thanks : http :',
     'jamie zawinsky no thanks : http : //bigbonus-casino.com/u/',
     'hi , i have a special offer available for',
     ', i have a special offer available for you',
     'i have a special offer available for you at',
     'have a special offer available for you at our',
     'a special offer available for you at our casino',
     'special offer available for you at our casino .',
     'offer available for you at our casino . $',
     'available for you at our casino . $ 20', 'for you at our casino . $ 20 to',
     'you at our casino . $ 20 to try', 'at our casino . $ 20 to try our',
     'our casino . $ 20 to try our internet',
     'casino . $ 20 to try our internet casino',
     '. $ 20 to try our internet casino ,', '$ 20 to try our internet casino , no',
     '20 to try our internet casino , no deposit',
     'to try our internet casino , no deposit is',
     'try our internet casino , no deposit is necessary',
     'our internet casino , no deposit is necessary !',
     'internet casino , no deposit is necessary ! at',
     'casino , no deposit is necessary ! at the',
     ', no deposit is necessary ! at the casino',
     'no deposit is necessary ! at the casino software',
     "deposit is necessary ! at the casino software 's",
     "is necessary ! at the casino software 's cashier",
     "necessary ! at the casino software 's cashier enter",
     "! at the casino software 's cashier enter bonus",
     "at the casino software 's cashier enter bonus code",
     "the casino software 's cashier enter bonus code :",
     "casino software 's cashier enter bonus code : fr93p",
     "software 's cashier enter bonus code : fr93p $",
     "'s cashier enter bonus code : fr93p $ 200",
     'cashier enter bonus code : fr93p $ 200 bonus',
     'enter bonus code : fr93p $ 200 bonus on',
     'bonus code : fr93p $ 200 bonus on your',
     'code : fr93p $ 200 bonus on your first',
     ': fr93p $ 200 bonus on your first deposit',
     'fr93p $ 200 bonus on your first deposit !',
     '$ 200 bonus on your first deposit ! at',
     '200 bonus on your first deposit ! at the',
     'bonus on your first deposit ! at the casino',
     'on your first deposit ! at the casino software',
     "your first deposit ! at the casino software 's",
     "first deposit ! at the casino software 's cashier",
     "deposit ! at the casino software 's cashier enter",
     "! at the casino software 's cashier enter bonus",
     "at the casino software 's cashier enter bonus code",
     "the casino software 's cashier enter bonus code :",
     "casino software 's cashier enter bonus code : fmjku",
     "software 's cashier enter bonus code : fmjku allow",
     "'s cashier enter bonus code : fmjku allow us",
     'cashier enter bonus code : fmjku allow us to',
     'enter bonus code : fmjku allow us to show',
     'bonus code : fmjku allow us to show you',
     'code : fmjku allow us to show you our',
     ': fmjku allow us to show you our quality',
     'fmjku allow us to show you our quality operation',
     'allow us to show you our quality operation ,',
     'us to show you our quality operation , fast',
     'to show you our quality operation , fast payouts',
     'show you our quality operation , fast payouts ,',
     'you our quality operation , fast payouts , generous',
     'our quality operation , fast payouts , generous bonuses',
     'quality operation , fast payouts , generous bonuses ,',
     'operation , fast payouts , generous bonuses , and',
     ', fast payouts , generous bonuses , and super',
     'fast payouts , generous bonuses , and super friendly',
     'payouts , generous bonuses , and super friendly around-the-clock',
     ', generous bonuses , and super friendly around-the-clock customer',
     'generous bonuses , and super friendly around-the-clock customer support',
     'bonuses , and super friendly around-the-clock customer support .',
     ', and super friendly around-the-clock customer support . click',
     'and super friendly around-the-clock customer support . click here',
     'super friendly around-the-clock customer support . click here :',
     'friendly around-the-clock customer support . click here : http',
     'around-the-clock customer support . click here : http :',
     'customer support . click here : http : //bigbonus-casino.net',
     'support . click here : http : //bigbonus-casino.net best',
     '. click here : http : //bigbonus-casino.net best regards',
     'click here : http : //bigbonus-casino.net best regards ,',
     'here : http : //bigbonus-casino.net best regards , jamie',
     ': http : //bigbonus-casino.net best regards , jamie zawinsky',
     'http : //bigbonus-casino.net best regards , jamie zawinsky no',
     ': //bigbonus-casino.net best regards , jamie zawinsky no thanks',
     '//bigbonus-casino.net best regards , jamie zawinsky no thanks :',
     'best regards , jamie zawinsky no thanks : http',
     'regards , jamie zawinsky no thanks : http :',
     ', jamie zawinsky no thanks : http : //bigbonus-casino.com/u/']



```python
vectorizador.fit_transform([contenido_mensaje_5]).toarray()[0]
```




    array([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
           1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
           0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 0, 0, 0, 0, 0])



Estamos ya en condiciones de construir la representación como bolsa de palabras de todos los mensajes de entrenamiento.

**Nota**: el formato de algunos de los mensajes requiere de un código elaborado para su adecuada lectura, por lo que simplemente haremos uso de una estructura `try...except` para descartar aquellos mensajes que produzcan error al tratar de leerlos con nuestro código simple.

Para una mayor flexibilidad en la gestión de las rutas de los ficheros, nos apoyaremos en el paquete [pathlib](https://docs.python.org/es/3/library/pathlib.html) de la biblioteca estándar de Python.


```python
from pathlib import Path
```


```python
carpeta_Enron_Spam = Path('Filtro antispam/Enron-Spam/')
carpeta_entrenamiento = carpeta_Enron_Spam / 'train'
```


```python
contenidos_mensajes_entrenamiento = []
clases_mensajes_entrenamiento = []

# Leemos los mensajes legítimos (clase 0)
for ruta_mensaje in (carpeta_entrenamiento / 'legítimo').iterdir():
    with open(ruta_mensaje, 'r') as fichero_mensaje:
        try:
            mensaje = analizador_mensaje.parse(fichero_mensaje)
            contenidos_mensajes_entrenamiento.append(mensaje.get_content())
            clases_mensajes_entrenamiento.append(0)
        except (KeyError, UnicodeDecodeError, LookupError):
            pass

# Leemos los mensajes no deseados (clase 1)
for ruta_mensaje in (carpeta_entrenamiento / 'no_deseado').iterdir():
    with open(ruta_mensaje, 'r') as fichero_mensaje:
        try:
            mensaje = analizador_mensaje.parse(fichero_mensaje)
            contenidos_mensajes_entrenamiento.append(mensaje.get_content())
            clases_mensajes_entrenamiento.append(1)
        except (KeyError, UnicodeDecodeError, LookupError):
            pass
```


```python
bolsa_de_palabras_entrenamiento = vectorizador.transform(
    contenidos_mensajes_entrenamiento
)
bolsa_de_palabras_entrenamiento
```




    <Compressed Sparse Row sparse matrix of dtype 'int64'
    	with 84608 stored elements and shape (20991, 494)>



Ahora haremos una búsqueda en rejilla para determinar el mejor valor de suavizado para el modelo naive Bayes multinomial. Como nuestro objetivo es identificar los mensajes no deseados, elegimos la sensibilidad como medida de rendimiento.


```python
from sklearn.naive_bayes import MultinomialNB
from sklearn.model_selection import GridSearchCV
```


```python
filtro_NB = MultinomialNB()
búsqueda_en_rejilla = GridSearchCV(
    filtro_NB,
    {'alpha': range(1, 5)},
    scoring='recall',
    cv=5
)
búsqueda_en_rejilla.fit(bolsa_de_palabras_entrenamiento,
                        clases_mensajes_entrenamiento)
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

  /* Specific color for light theme */
  --sklearn-color-text-on-default-background: var(--sg-text-color, var(--theme-code-foreground, var(--jp-content-font-color1, black)));
  --sklearn-color-background: var(--sg-background-color, var(--theme-background, var(--jp-layout-color0, white)));
  --sklearn-color-border-box: var(--sg-text-color, var(--theme-code-foreground, var(--jp-content-font-color1, black)));
  --sklearn-color-icon: #696969;

  @media (prefers-color-scheme: dark) {
    /* Redefinition of color scheme for dark theme */
    --sklearn-color-text-on-default-background: var(--sg-text-color, var(--theme-code-foreground, var(--jp-content-font-color1, white)));
    --sklearn-color-background: var(--sg-background-color, var(--theme-background, var(--jp-layout-color0, #111)));
    --sklearn-color-border-box: var(--sg-text-color, var(--theme-code-foreground, var(--jp-content-font-color1, white)));
    --sklearn-color-icon: #878787;
  }
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
  align-items: start;
  justify-content: space-between;
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
  max-height: 0;
  max-width: 0;
  overflow: hidden;
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
  max-height: 200px;
  max-width: 100%;
  overflow: auto;
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
  display: inline-block;
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
  background-color: var(--sklearn-color-background);
  border-radius: 1em;
  height: 1em;
  width: 1em;
  text-decoration: none !important;
  margin-left: 0.5em;
  text-align: center;
  /* unfitted */
  border: var(--sklearn-color-unfitted-level-1) 1pt solid;
  color: var(--sklearn-color-unfitted-level-1);
}

.sk-estimator-doc-link.fitted,
a:link.sk-estimator-doc-link.fitted,
a:visited.sk-estimator-doc-link.fitted {
  /* fitted */
  border: var(--sklearn-color-fitted-level-1) 1pt solid;
  color: var(--sklearn-color-fitted-level-1);
}

/* On hover */
div.sk-estimator:hover .sk-estimator-doc-link:hover,
.sk-estimator-doc-link:hover,
div.sk-label-container:hover .sk-estimator-doc-link:hover,
.sk-estimator-doc-link:hover {
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-3);
  color: var(--sklearn-color-background);
  text-decoration: none;
}

div.sk-estimator.fitted:hover .sk-estimator-doc-link.fitted:hover,
.sk-estimator-doc-link.fitted:hover,
div.sk-label-container:hover .sk-estimator-doc-link.fitted:hover,
.sk-estimator-doc-link.fitted:hover {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-3);
  color: var(--sklearn-color-background);
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
  background-color: var(--sklearn-color-background);
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
</style><div id="sk-container-id-1" class="sk-top-container"><div class="sk-text-repr-fallback"><pre>GridSearchCV(cv=5, estimator=MultinomialNB(), param_grid={&#x27;alpha&#x27;: range(1, 5)},
             scoring=&#x27;recall&#x27;)</pre><b>In a Jupyter environment, please rerun this cell to show the HTML representation or trust the notebook. <br />On GitHub, the HTML representation is unable to render, please try loading this page with nbviewer.org.</b></div><div class="sk-container" hidden><div class="sk-item sk-dashed-wrapped"><div class="sk-label-container"><div class="sk-label fitted sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-1" type="checkbox" ><label for="sk-estimator-id-1" class="sk-toggleable__label fitted sk-toggleable__label-arrow"><div><div>GridSearchCV</div></div><div><a class="sk-estimator-doc-link fitted" rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.6/modules/generated/sklearn.model_selection.GridSearchCV.html">?<span>Documentation for GridSearchCV</span></a><span class="sk-estimator-doc-link fitted">i<span>Fitted</span></span></div></label><div class="sk-toggleable__content fitted"><pre>GridSearchCV(cv=5, estimator=MultinomialNB(), param_grid={&#x27;alpha&#x27;: range(1, 5)},
             scoring=&#x27;recall&#x27;)</pre></div> </div></div><div class="sk-parallel"><div class="sk-parallel-item"><div class="sk-item"><div class="sk-label-container"><div class="sk-label fitted sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-2" type="checkbox" ><label for="sk-estimator-id-2" class="sk-toggleable__label fitted sk-toggleable__label-arrow"><div><div>best_estimator_: MultinomialNB</div></div></label><div class="sk-toggleable__content fitted"><pre>MultinomialNB(alpha=1)</pre></div> </div></div><div class="sk-serial"><div class="sk-item"><div class="sk-estimator fitted sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-3" type="checkbox" ><label for="sk-estimator-id-3" class="sk-toggleable__label fitted sk-toggleable__label-arrow"><div><div>MultinomialNB</div></div><div><a class="sk-estimator-doc-link fitted" rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.6/modules/generated/sklearn.naive_bayes.MultinomialNB.html">?<span>Documentation for MultinomialNB</span></a></div></label><div class="sk-toggleable__content fitted"><pre>MultinomialNB(alpha=1)</pre></div> </div></div></div></div></div></div></div></div></div>




```python
búsqueda_en_rejilla.best_params_
```




    {'alpha': 1}




```python
búsqueda_en_rejilla.best_score_
```




    np.float64(0.616353887399464)



Para construir un filtro de correo electrónico no deseado usando el modelo tf-idf como modelo de lenguaje y el modelo $k$NN como modelo predictivo, basta replicar convenientemente los pasos realizados anteriormente.


```python
from sklearn.feature_extraction.text import TfidfVectorizer
```


```python
vectorizador = TfidfVectorizer(vocabulary=términos_spam,
                               token_pattern=None,
                               tokenizer=word_tokenize,
                               ngram_range=(1, 9))
# Calculamos la frecuencia documental inversa a partir de todos los
# mensajes de entrenamiento
vectorizador.fit(contenidos_mensajes_entrenamiento)
# Construimos la representación tf-idf del mensaje no deseado 5
vectorizador.transform([contenido_mensaje_5]).toarray()
```




    array([[0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.48457398, 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.8362666 ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.10987924, 0.        , 0.09355635, 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.13054217,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.10868301, 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.07471252, 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.10288232,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        , 0.        ,
            0.        , 0.        , 0.        , 0.        ]])



Sin embargo, en este caso existe la dificultad de que la frecuencia documental inversa debe calcularse únicamente a partir del corpus de entrenamiento. Esto quiere decir que la búsqueda en rejilla debe realizar tanto la vectorización de los mensajes como la construcción del modelo predictivo.

Es necesario, entonces, el uso de las tuberías de scikit-learn. Además, por eficiencia, se usará la clase `TfidfTransformer` para obtener directamente las frecuencias documentales inversas a partir de la bolsa de palabras ya construida.


```python
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.neighbors import KNeighborsClassifier
```


```python
tubería_filtro_kNN = Pipeline([
    ('vectorizador', TfidfTransformer()),
    ('filtro_kNN', KNeighborsClassifier(metric='cosine'))
])
```


```python
búsqueda_en_rejilla = GridSearchCV(
    tubería_filtro_kNN,
    {'filtro_kNN__n_neighbors': range(1, 6, 2)},
    scoring='recall',
    cv=5
)
búsqueda_en_rejilla.fit(bolsa_de_palabras_entrenamiento,
                        clases_mensajes_entrenamiento)
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
</style><body><div id="sk-container-id-1" class="sk-top-container"><div class="sk-text-repr-fallback"><pre>GridSearchCV(cv=5,
             estimator=Pipeline(steps=[(&#x27;vectorizador&#x27;, TfidfTransformer()),
                                       (&#x27;filtro_kNN&#x27;,
                                        KNeighborsClassifier(metric=&#x27;cosine&#x27;))]),
             param_grid={&#x27;filtro_kNN__n_neighbors&#x27;: range(1, 6, 2)},
             scoring=&#x27;recall&#x27;)</pre><b>In a Jupyter environment, please rerun this cell to show the HTML representation or trust the notebook. <br />On GitHub, the HTML representation is unable to render, please try loading this page with nbviewer.org.</b></div><div class="sk-container" hidden><div class="sk-item sk-dashed-wrapped"><div class="sk-label-container"><div class="sk-label fitted sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-1" type="checkbox" ><label for="sk-estimator-id-1" class="sk-toggleable__label fitted sk-toggleable__label-arrow"><div><div>GridSearchCV</div></div><div><a class="sk-estimator-doc-link fitted" rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.model_selection.GridSearchCV.html">?<span>Documentation for GridSearchCV</span></a><span class="sk-estimator-doc-link fitted">i<span>Fitted</span></span></div></label><div class="sk-toggleable__content fitted" data-param-prefix="">
        <div class="estimator-table">
            <details>
                <summary>Parameters</summary>
                <table class="parameters-table">
                  <tbody>

        <tr class="user-set">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('estimator',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.model_selection.GridSearchCV.html#:~:text=estimator,-estimator%20object">
            estimator
            <span class="param-doc-description">estimator: estimator object<br><br>This is assumed to implement the scikit-learn estimator interface.<br>Either estimator needs to provide a ``score`` function,<br>or ``scoring`` must be passed.</span>
        </a>
    </td>
            <td class="value">Pipeline(step...c=&#x27;cosine&#x27;))])</td>
        </tr>


        <tr class="user-set">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('param_grid',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.model_selection.GridSearchCV.html#:~:text=param_grid,-dict%20or%20list%20of%20dictionaries">
            param_grid
            <span class="param-doc-description">param_grid: dict or list of dictionaries<br><br>Dictionary with parameters names (`str`) as keys and lists of<br>parameter settings to try as values, or a list of such<br>dictionaries, in which case the grids spanned by each dictionary<br>in the list are explored. This enables searching over any sequence<br>of parameter settings.</span>
        </a>
    </td>
            <td class="value">{&#x27;filtro_kNN__n_neighbors&#x27;: range(1, 6, 2)}</td>
        </tr>


        <tr class="user-set">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('scoring',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.model_selection.GridSearchCV.html#:~:text=scoring,-str%2C%20callable%2C%20list%2C%20tuple%20or%20dict%2C%20default%3DNone">
            scoring
            <span class="param-doc-description">scoring: str, callable, list, tuple or dict, default=None<br><br>Strategy to evaluate the performance of the cross-validated model on<br>the test set.<br><br>If `scoring` represents a single score, one can use:<br><br>- a single string (see :ref:`scoring_string_names`);<br>- a callable (see :ref:`scoring_callable`) that returns a single value;<br>- `None`, the `estimator`'s<br>  :ref:`default evaluation criterion <scoring_api_overview>` is used.<br><br>If `scoring` represents multiple scores, one can use:<br><br>- a list or tuple of unique strings;<br>- a callable returning a dictionary where the keys are the metric<br>  names and the values are the metric scores;<br>- a dictionary with metric names as keys and callables as values.<br><br>See :ref:`multimetric_grid_search` for an example.</span>
        </a>
    </td>
            <td class="value">&#x27;recall&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('n_jobs',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.model_selection.GridSearchCV.html#:~:text=n_jobs,-int%2C%20default%3DNone">
            n_jobs
            <span class="param-doc-description">n_jobs: int, default=None<br><br>Number of jobs to run in parallel.<br>``None`` means 1 unless in a :obj:`joblib.parallel_backend` context.<br>``-1`` means using all processors. See :term:`Glossary <n_jobs>`<br>for more details.<br><br>.. versionchanged:: v0.20<br>   `n_jobs` default changed from 1 to None</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('refit',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.model_selection.GridSearchCV.html#:~:text=refit,-bool%2C%20str%2C%20or%20callable%2C%20default%3DTrue">
            refit
            <span class="param-doc-description">refit: bool, str, or callable, default=True<br><br>Refit an estimator using the best found parameters on the whole<br>dataset.<br><br>For multiple metric evaluation, this needs to be a `str` denoting the<br>scorer that would be used to find the best parameters for refitting<br>the estimator at the end.<br><br>Where there are considerations other than maximum score in<br>choosing a best estimator, ``refit`` can be set to a function which<br>returns the selected ``best_index_`` given ``cv_results_``. In that<br>case, the ``best_estimator_`` and ``best_params_`` will be set<br>according to the returned ``best_index_`` while the ``best_score_``<br>attribute will not be available.<br><br>The refitted estimator is made available at the ``best_estimator_``<br>attribute and permits using ``predict`` directly on this<br>``GridSearchCV`` instance.<br><br>Also for multiple metric evaluation, the attributes ``best_index_``,<br>``best_score_`` and ``best_params_`` will only be available if<br>``refit`` is set and all of them will be determined w.r.t this specific<br>scorer.<br><br>See ``scoring`` parameter to know more about multiple metric<br>evaluation.<br><br>See :ref:`sphx_glr_auto_examples_model_selection_plot_grid_search_digits.py`<br>to see how to design a custom selection strategy using a callable<br>via `refit`.<br><br>See :ref:`this example<br><sphx_glr_auto_examples_model_selection_plot_grid_search_refit_callable.py>`<br>for an example of how to use ``refit=callable`` to balance model<br>complexity and cross-validated score.<br><br>.. versionchanged:: 0.20<br>    Support for callable added.</span>
        </a>
    </td>
            <td class="value">True</td>
        </tr>


        <tr class="user-set">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('cv',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.model_selection.GridSearchCV.html#:~:text=cv,-int%2C%20cross-validation%20generator%20or%20an%20iterable%2C%20default%3DNone">
            cv
            <span class="param-doc-description">cv: int, cross-validation generator or an iterable, default=None<br><br>Determines the cross-validation splitting strategy.<br>Possible inputs for cv are:<br><br>- None, to use the default 5-fold cross validation,<br>- integer, to specify the number of folds in a `(Stratified)KFold`,<br>- :term:`CV splitter`,<br>- An iterable yielding (train, test) splits as arrays of indices.<br><br>For integer/None inputs, if the estimator is a classifier and ``y`` is<br>either binary or multiclass, :class:`StratifiedKFold` is used. In all<br>other cases, :class:`KFold` is used. These splitters are instantiated<br>with `shuffle=False` so the splits will be the same across calls.<br><br>Refer :ref:`User Guide <cross_validation>` for the various<br>cross-validation strategies that can be used here.<br><br>.. versionchanged:: 0.22<br>    ``cv`` default value if None changed from 3-fold to 5-fold.</span>
        </a>
    </td>
            <td class="value">5</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('verbose',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.model_selection.GridSearchCV.html#:~:text=verbose,-int">
            verbose
            <span class="param-doc-description">verbose: int<br><br>Controls the verbosity: the higher, the more messages.<br><br>- >1 : the computation time for each fold and parameter candidate is<br>  displayed;<br>- >2 : the score is also displayed;<br>- >3 : the fold and candidate parameter indexes are also displayed<br>  together with the starting time of the computation.</span>
        </a>
    </td>
            <td class="value">0</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('pre_dispatch',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.model_selection.GridSearchCV.html#:~:text=pre_dispatch,-int%2C%20or%20str%2C%20default%3D%272%2An_jobs%27">
            pre_dispatch
            <span class="param-doc-description">pre_dispatch: int, or str, default='2*n_jobs'<br><br>Controls the number of jobs that get dispatched during parallel<br>execution. Reducing this number can be useful to avoid an<br>explosion of memory consumption when more jobs get dispatched<br>than CPUs can process. This parameter can be:<br><br>- None, in which case all the jobs are immediately created and spawned. Use<br>  this for lightweight and fast-running jobs, to avoid delays due to on-demand<br>  spawning of the jobs<br>- An int, giving the exact number of total jobs that are spawned<br>- A str, giving an expression as a function of n_jobs, as in '2*n_jobs'</span>
        </a>
    </td>
            <td class="value">&#x27;2*n_jobs&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('error_score',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.model_selection.GridSearchCV.html#:~:text=error_score,-%27raise%27%20or%20numeric%2C%20default%3Dnp.nan">
            error_score
            <span class="param-doc-description">error_score: 'raise' or numeric, default=np.nan<br><br>Value to assign to the score if an error occurs in estimator fitting.<br>If set to 'raise', the error is raised. If a numeric value is given,<br>FitFailedWarning is raised. This parameter does not affect the refit<br>step, which will always raise the error.</span>
        </a>
    </td>
            <td class="value">nan</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('return_train_score',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.model_selection.GridSearchCV.html#:~:text=return_train_score,-bool%2C%20default%3DFalse">
            return_train_score
            <span class="param-doc-description">return_train_score: bool, default=False<br><br>If ``False``, the ``cv_results_`` attribute will not include training<br>scores.<br>Computing training scores is used to get insights on how different<br>parameter settings impact the overfitting/underfitting trade-off.<br>However computing the scores on the training set can be computationally<br>expensive and is not strictly required to select the parameters that<br>yield the best generalization performance.<br><br>.. versionadded:: 0.19<br><br>.. versionchanged:: 0.21<br>    Default value was changed from ``True`` to ``False``</span>
        </a>
    </td>
            <td class="value">False</td>
        </tr>

                  </tbody>
                </table>
            </details>
        </div>
    </div></div></div><div class="sk-parallel"><div class="sk-parallel-item"><div class="sk-item"><div class="sk-label-container"><div class="sk-label fitted sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-2" type="checkbox" ><label for="sk-estimator-id-2" class="sk-toggleable__label fitted sk-toggleable__label-arrow"><div><div>best_estimator_: Pipeline</div></div></label><div class="sk-toggleable__content fitted" data-param-prefix="best_estimator___"></div></div><div class="sk-serial"><div class="sk-item"><div class="sk-serial"><div class="sk-item"><div class="sk-estimator fitted sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-3" type="checkbox" ><label for="sk-estimator-id-3" class="sk-toggleable__label fitted sk-toggleable__label-arrow"><div><div>TfidfTransformer</div></div><div><a class="sk-estimator-doc-link fitted" rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfTransformer.html">?<span>Documentation for TfidfTransformer</span></a></div></label><div class="sk-toggleable__content fitted" data-param-prefix="best_estimator___vectorizador__">
        <div class="estimator-table">
            <details>
                <summary>Parameters</summary>
                <table class="parameters-table">
                  <tbody>

        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('norm',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfTransformer.html#:~:text=norm,-%7B%27l1%27%2C%20%27l2%27%7D%20or%20None%2C%20default%3D%27l2%27">
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
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfTransformer.html#:~:text=use_idf,-bool%2C%20default%3DTrue">
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
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfTransformer.html#:~:text=smooth_idf,-bool%2C%20default%3DTrue">
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
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfTransformer.html#:~:text=sublinear_tf,-bool%2C%20default%3DFalse">
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
    </div></div></div><div class="sk-item"><div class="sk-estimator fitted sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-4" type="checkbox" ><label for="sk-estimator-id-4" class="sk-toggleable__label fitted sk-toggleable__label-arrow"><div><div>KNeighborsClassifier</div></div><div><a class="sk-estimator-doc-link fitted" rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html">?<span>Documentation for KNeighborsClassifier</span></a></div></label><div class="sk-toggleable__content fitted" data-param-prefix="best_estimator___filtro_kNN__">
        <div class="estimator-table">
            <details>
                <summary>Parameters</summary>
                <table class="parameters-table">
                  <tbody>

        <tr class="user-set">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('n_neighbors',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=n_neighbors,-int%2C%20default%3D5">
            n_neighbors
            <span class="param-doc-description">n_neighbors: int, default=5<br><br>Number of neighbors to use by default for :meth:`kneighbors` queries.</span>
        </a>
    </td>
            <td class="value">1</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('weights',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=weights,-%7B%27uniform%27%2C%20%27distance%27%7D%2C%20callable%20or%20None%2C%20default%3D%27uniform%27">
            weights
            <span class="param-doc-description">weights: {'uniform', 'distance'}, callable or None, default='uniform'<br><br>Weight function used in prediction.  Possible values:<br><br>- 'uniform' : uniform weights.  All points in each neighborhood<br>  are weighted equally.<br>- 'distance' : weight points by the inverse of their distance.<br>  in this case, closer neighbors of a query point will have a<br>  greater influence than neighbors which are further away.<br>- [callable] : a user-defined function which accepts an<br>  array of distances, and returns an array of the same shape<br>  containing the weights.<br><br>Refer to the example entitled<br>:ref:`sphx_glr_auto_examples_neighbors_plot_classification.py`<br>showing the impact of the `weights` parameter on the decision<br>boundary.</span>
        </a>
    </td>
            <td class="value">&#x27;uniform&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('algorithm',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=algorithm,-%7B%27auto%27%2C%20%27ball_tree%27%2C%20%27kd_tree%27%2C%20%27brute%27%7D%2C%20default%3D%27auto%27">
            algorithm
            <span class="param-doc-description">algorithm: {'auto', 'ball_tree', 'kd_tree', 'brute'}, default='auto'<br><br>Algorithm used to compute the nearest neighbors:<br><br>- 'ball_tree' will use :class:`BallTree`<br>- 'kd_tree' will use :class:`KDTree`<br>- 'brute' will use a brute-force search.<br>- 'auto' will attempt to decide the most appropriate algorithm<br>  based on the values passed to :meth:`fit` method.<br><br>Note: fitting on sparse input will override the setting of<br>this parameter, using brute force.</span>
        </a>
    </td>
            <td class="value">&#x27;auto&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('leaf_size',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=leaf_size,-int%2C%20default%3D30">
            leaf_size
            <span class="param-doc-description">leaf_size: int, default=30<br><br>Leaf size passed to BallTree or KDTree.  This can affect the<br>speed of the construction and query, as well as the memory<br>required to store the tree.  The optimal value depends on the<br>nature of the problem.</span>
        </a>
    </td>
            <td class="value">30</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('p',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=p,-float%2C%20default%3D2">
            p
            <span class="param-doc-description">p: float, default=2<br><br>Power parameter for the Minkowski metric. When p = 1, this is equivalent<br>to using manhattan_distance (l1), and euclidean_distance (l2) for p = 2.<br>For arbitrary p, minkowski_distance (l_p) is used. This parameter is expected<br>to be positive.</span>
        </a>
    </td>
            <td class="value">2</td>
        </tr>


        <tr class="user-set">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('metric',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=metric,-str%20or%20callable%2C%20default%3D%27minkowski%27">
            metric
            <span class="param-doc-description">metric: str or callable, default='minkowski'<br><br>Metric to use for distance computation. Default is "minkowski", which<br>results in the standard Euclidean distance when p = 2. See the<br>documentation of `scipy.spatial.distance<br><https://docs.scipy.org/doc/scipy/reference/spatial.distance.html>`_ and<br>the metrics listed in<br>:class:`~sklearn.metrics.pairwise.distance_metrics` for valid metric<br>values.<br><br>If metric is "precomputed", X is assumed to be a distance matrix and<br>must be square during fit. X may be a :term:`sparse graph`, in which<br>case only "nonzero" elements may be considered neighbors.<br><br>If metric is a callable function, it takes two arrays representing 1D<br>vectors as inputs and must return one value indicating the distance<br>between those vectors. This works for Scipy's metrics, but is less<br>efficient than passing the metric name as a string.</span>
        </a>
    </td>
            <td class="value">&#x27;cosine&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('metric_params',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=metric_params,-dict%2C%20default%3DNone">
            metric_params
            <span class="param-doc-description">metric_params: dict, default=None<br><br>Additional keyword arguments for the metric function.</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('n_jobs',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=n_jobs,-int%2C%20default%3DNone">
            n_jobs
            <span class="param-doc-description">n_jobs: int, default=None<br><br>The number of parallel jobs to run for neighbors search.<br>``None`` means 1 unless in a :obj:`joblib.parallel_backend` context.<br>``-1`` means using all processors. See :term:`Glossary <n_jobs>`<br>for more details.<br>Doesn't affect :meth:`fit` method.</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>

                  </tbody>
                </table>
            </details>
        </div>
    </div></div></div></div></div></div></div></div></div></div></div></div><script>function copyToClipboard(text, element) {
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
búsqueda_en_rejilla.best_params_
```




    {'filtro_kNN__n_neighbors': 1}




```python
búsqueda_en_rejilla.best_score_
```




    np.float64(0.8348759221998658)



La conclusión es, por tanto, que de todos los filtros considerados, el que mejor identifica los mensajes no deseados es el modelo $k$NN con el valor 1 para el número de vecinos.

Procedemos a entrenar ese modelo sobre todo el corpus de entrenamiento y a evaluar su rendimiento sobre el corpus de prueba.


```python
filtro_seleccionado = Pipeline([
    ('vectorizador', TfidfVectorizer(vocabulary=términos_spam,
                                     token_pattern=None,
                                     tokenizer=word_tokenize,
                                     ngram_range=(1, 9))),
    ('filtro_kNN', KNeighborsClassifier(metric='cosine',
                                        n_neighbors=1))
])
```


```python
filtro_seleccionado.fit(contenidos_mensajes_entrenamiento,
                        clases_mensajes_entrenamiento)
```




<style>#sk-container-id-2 {
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

#sk-container-id-2.light {
  /* Specific color for light theme */
  --sklearn-color-text-on-default-background: black;
  --sklearn-color-background: white;
  --sklearn-color-border-box: black;
  --sklearn-color-icon: #696969;
}

#sk-container-id-2.dark {
  --sklearn-color-text-on-default-background: white;
  --sklearn-color-background: #111;
  --sklearn-color-border-box: white;
  --sklearn-color-icon: #878787;
}

#sk-container-id-2 {
  color: var(--sklearn-color-text);
}

#sk-container-id-2 pre {
  padding: 0;
}

#sk-container-id-2 input.sk-hidden--visually {
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

#sk-container-id-2 div.sk-dashed-wrapped {
  border: 1px dashed var(--sklearn-color-line);
  margin: 0 0.4em 0.5em 0.4em;
  box-sizing: border-box;
  padding-bottom: 0.4em;
  background-color: var(--sklearn-color-background);
}

#sk-container-id-2 div.sk-container {
  /* jupyter's `normalize.less` sets `[hidden] { display: none; }`
     but bootstrap.min.css set `[hidden] { display: none !important; }`
     so we also need the `!important` here to be able to override the
     default hidden behavior on the sphinx rendered scikit-learn.org.
     See: https://github.com/scikit-learn/scikit-learn/issues/21755 */
  display: inline-block !important;
  position: relative;
}

#sk-container-id-2 div.sk-text-repr-fallback {
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

#sk-container-id-2 div.sk-parallel-item::after {
  content: "";
  width: 100%;
  border-bottom: 2px solid var(--sklearn-color-text-on-default-background);
  flex-grow: 1;
}

#sk-container-id-2 div.sk-parallel {
  display: flex;
  align-items: stretch;
  justify-content: center;
  background-color: var(--sklearn-color-background);
  position: relative;
}

#sk-container-id-2 div.sk-parallel-item {
  display: flex;
  flex-direction: column;
}

#sk-container-id-2 div.sk-parallel-item:first-child::after {
  align-self: flex-end;
  width: 50%;
}

#sk-container-id-2 div.sk-parallel-item:last-child::after {
  align-self: flex-start;
  width: 50%;
}

#sk-container-id-2 div.sk-parallel-item:only-child::after {
  width: 0;
}

/* Serial-specific style estimator block */

#sk-container-id-2 div.sk-serial {
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

#sk-container-id-2 div.sk-toggleable {
  /* Default theme specific background. It is overwritten whether we have a
  specific estimator or a Pipeline/ColumnTransformer */
  background-color: var(--sklearn-color-background);
}

/* Toggleable label */
#sk-container-id-2 label.sk-toggleable__label {
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

#sk-container-id-2 label.sk-toggleable__label .caption {
  font-size: 0.6rem;
  font-weight: lighter;
  color: var(--sklearn-color-text-muted);
}

#sk-container-id-2 label.sk-toggleable__label-arrow:before {
  /* Arrow on the left of the label */
  content: "▸";
  float: left;
  margin-right: 0.25em;
  color: var(--sklearn-color-icon);
}

#sk-container-id-2 label.sk-toggleable__label-arrow:hover:before {
  color: var(--sklearn-color-text);
}

/* Toggleable content - dropdown */

#sk-container-id-2 div.sk-toggleable__content {
  display: none;
  text-align: left;
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-0);
}

#sk-container-id-2 div.sk-toggleable__content.fitted {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-0);
}

#sk-container-id-2 div.sk-toggleable__content pre {
  margin: 0.2em;
  border-radius: 0.25em;
  color: var(--sklearn-color-text);
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-0);
}

#sk-container-id-2 div.sk-toggleable__content.fitted pre {
  /* unfitted */
  background-color: var(--sklearn-color-fitted-level-0);
}

#sk-container-id-2 input.sk-toggleable__control:checked~div.sk-toggleable__content {
  /* Expand drop-down */
  display: block;
  width: 100%;
  overflow: visible;
}

#sk-container-id-2 input.sk-toggleable__control:checked~label.sk-toggleable__label-arrow:before {
  content: "▾";
}

/* Pipeline/ColumnTransformer-specific style */

#sk-container-id-2 div.sk-label input.sk-toggleable__control:checked~label.sk-toggleable__label {
  color: var(--sklearn-color-text);
  background-color: var(--sklearn-color-unfitted-level-2);
}

#sk-container-id-2 div.sk-label.fitted input.sk-toggleable__control:checked~label.sk-toggleable__label {
  background-color: var(--sklearn-color-fitted-level-2);
}

/* Estimator-specific style */

/* Colorize estimator box */
#sk-container-id-2 div.sk-estimator input.sk-toggleable__control:checked~label.sk-toggleable__label {
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-2);
}

#sk-container-id-2 div.sk-estimator.fitted input.sk-toggleable__control:checked~label.sk-toggleable__label {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-2);
}

#sk-container-id-2 div.sk-label label.sk-toggleable__label,
#sk-container-id-2 div.sk-label label {
  /* The background is the default theme color */
  color: var(--sklearn-color-text-on-default-background);
}

/* On hover, darken the color of the background */
#sk-container-id-2 div.sk-label:hover label.sk-toggleable__label {
  color: var(--sklearn-color-text);
  background-color: var(--sklearn-color-unfitted-level-2);
}

/* Label box, darken color on hover, fitted */
#sk-container-id-2 div.sk-label.fitted:hover label.sk-toggleable__label.fitted {
  color: var(--sklearn-color-text);
  background-color: var(--sklearn-color-fitted-level-2);
}

/* Estimator label */

#sk-container-id-2 div.sk-label label {
  font-family: monospace;
  font-weight: bold;
  line-height: 1.2em;
}

#sk-container-id-2 div.sk-label-container {
  text-align: center;
}

/* Estimator-specific */
#sk-container-id-2 div.sk-estimator {
  font-family: monospace;
  border: 1px dotted var(--sklearn-color-border-box);
  border-radius: 0.25em;
  box-sizing: border-box;
  margin-bottom: 0.5em;
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-0);
}

#sk-container-id-2 div.sk-estimator.fitted {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-0);
}

/* on hover */
#sk-container-id-2 div.sk-estimator:hover {
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-2);
}

#sk-container-id-2 div.sk-estimator.fitted:hover {
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

#sk-container-id-2 a.estimator_doc_link {
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

#sk-container-id-2 a.estimator_doc_link.fitted {
  /* fitted */
  background-color: var(--sklearn-color-fitted-level-0);
  border: var(--sklearn-color-fitted-level-1) 1pt solid;
  color: var(--sklearn-color-fitted-level-1);
}

/* On hover */
#sk-container-id-2 a.estimator_doc_link:hover {
  /* unfitted */
  background-color: var(--sklearn-color-unfitted-level-3);
  color: var(--sklearn-color-background);
  text-decoration: none;
}

#sk-container-id-2 a.estimator_doc_link.fitted:hover {
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
</style><body><div id="sk-container-id-2" class="sk-top-container"><div class="sk-text-repr-fallback"><pre>Pipeline(steps=[(&#x27;vectorizador&#x27;,
                 TfidfVectorizer(ngram_range=(1, 9), token_pattern=None,
                                 tokenizer=&lt;function word_tokenize at 0x7125d85798a0&gt;,
                                 vocabulary=[&#x27;#1&#x27;, &#x27;$$$&#x27;, &#x27;$earn extra cash&#x27;,
                                             &#x27;$save big money&#x27;, &#x27;$save&#x27;,
                                             &#x27;100% free&#x27;, &#x27;100% satisfied&#x27;,
                                             &#x27;100%&#x27;, &#x27;4u&#x27;, &#x27;50% off&#x27;,
                                             &#x27;accept credit cards&#x27;,
                                             &#x27;acceptance&#x27;, &#x27;access&#x27;,
                                             &#x27;accordingly&#x27;, &#x27;act now!&#x27;,
                                             &#x27;act now&#x27;, &#x27;action&#x27;, &#x27;ad&#x27;,
                                             &#x27;additional income&#x27;, &#x27;additional&#x27;,
                                             &#x27;addresses on cd&#x27;, &#x27;affordable&#x27;,
                                             &#x27;all natural&#x27;, &#x27;all new&#x27;, &#x27;amazed&#x27;,
                                             &#x27;amazing stuff&#x27;, &#x27;amazing&#x27;,
                                             &#x27;americans&#x27;, &#x27;apply now&#x27;,
                                             &#x27;apply online&#x27;, ...])),
                (&#x27;filtro_kNN&#x27;,
                 KNeighborsClassifier(metric=&#x27;cosine&#x27;, n_neighbors=1))])</pre><b>In a Jupyter environment, please rerun this cell to show the HTML representation or trust the notebook. <br />On GitHub, the HTML representation is unable to render, please try loading this page with nbviewer.org.</b></div><div class="sk-container" hidden><div class="sk-item sk-dashed-wrapped"><div class="sk-label-container"><div class="sk-label fitted sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-5" type="checkbox" ><label for="sk-estimator-id-5" class="sk-toggleable__label fitted sk-toggleable__label-arrow"><div><div>Pipeline</div></div><div><a class="sk-estimator-doc-link fitted" rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.pipeline.Pipeline.html">?<span>Documentation for Pipeline</span></a><span class="sk-estimator-doc-link fitted">i<span>Fitted</span></span></div></label><div class="sk-toggleable__content fitted" data-param-prefix="">
        <div class="estimator-table">
            <details>
                <summary>Parameters</summary>
                <table class="parameters-table">
                  <tbody>

        <tr class="user-set">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('steps',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.pipeline.Pipeline.html#:~:text=steps,-list%20of%20tuples">
            steps
            <span class="param-doc-description">steps: list of tuples<br><br>List of (name of step, estimator) tuples that are to be chained in<br>sequential order. To be compatible with the scikit-learn API, all steps<br>must define `fit`. All non-last steps must also define `transform`. See<br>:ref:`Combining Estimators <combining_estimators>` for more details.</span>
        </a>
    </td>
            <td class="value">[(&#x27;vectorizador&#x27;, ...), (&#x27;filtro_kNN&#x27;, ...)]</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('transform_input',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.pipeline.Pipeline.html#:~:text=transform_input,-list%20of%20str%2C%20default%3DNone">
            transform_input
            <span class="param-doc-description">transform_input: list of str, default=None<br><br>The names of the :term:`metadata` parameters that should be transformed by the<br>pipeline before passing it to the step consuming it.<br><br>This enables transforming some input arguments to ``fit`` (other than ``X``)<br>to be transformed by the steps of the pipeline up to the step which requires<br>them. Requirement is defined via :ref:`metadata routing <metadata_routing>`.<br>For instance, this can be used to pass a validation set through the pipeline.<br><br>You can only set this if metadata routing is enabled, which you<br>can enable using ``sklearn.set_config(enable_metadata_routing=True)``.<br><br>.. versionadded:: 1.6</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('memory',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.pipeline.Pipeline.html#:~:text=memory,-str%20or%20object%20with%20the%20joblib.Memory%20interface%2C%20default%3DNone">
            memory
            <span class="param-doc-description">memory: str or object with the joblib.Memory interface, default=None<br><br>Used to cache the fitted transformers of the pipeline. The last step<br>will never be cached, even if it is a transformer. By default, no<br>caching is performed. If a string is given, it is the path to the<br>caching directory. Enabling caching triggers a clone of the transformers<br>before fitting. Therefore, the transformer instance given to the<br>pipeline cannot be inspected directly. Use the attribute ``named_steps``<br>or ``steps`` to inspect estimators within the pipeline. Caching the<br>transformers is advantageous when fitting is time consuming. See<br>:ref:`sphx_glr_auto_examples_neighbors_plot_caching_nearest_neighbors.py`<br>for an example on how to enable caching.</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('verbose',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.pipeline.Pipeline.html#:~:text=verbose,-bool%2C%20default%3DFalse">
            verbose
            <span class="param-doc-description">verbose: bool, default=False<br><br>If True, the time elapsed while fitting each step will be printed as it<br>is completed.</span>
        </a>
    </td>
            <td class="value">False</td>
        </tr>

                  </tbody>
                </table>
            </details>
        </div>
    </div></div></div><div class="sk-serial"><div class="sk-item"><div class="sk-estimator fitted sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-6" type="checkbox" ><label for="sk-estimator-id-6" class="sk-toggleable__label fitted sk-toggleable__label-arrow"><div><div>TfidfVectorizer</div></div><div><a class="sk-estimator-doc-link fitted" rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html">?<span>Documentation for TfidfVectorizer</span></a></div></label><div class="sk-toggleable__content fitted" data-param-prefix="vectorizador__">
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


        <tr class="user-set">
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
            <td class="value">&lt;function wor...x7125d85798a0&gt;</td>
        </tr>


        <tr class="default">
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
            <td class="value">&#x27;word&#x27;</td>
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


        <tr class="user-set">
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
            <td class="value">None</td>
        </tr>


        <tr class="user-set">
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


        <tr class="user-set">
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
            <td class="value">[&#x27;#1&#x27;, &#x27;$$$&#x27;, ...]</td>
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
    </div></div></div><div class="sk-item"><div class="sk-estimator fitted sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-7" type="checkbox" ><label for="sk-estimator-id-7" class="sk-toggleable__label fitted sk-toggleable__label-arrow"><div><div>KNeighborsClassifier</div></div><div><a class="sk-estimator-doc-link fitted" rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html">?<span>Documentation for KNeighborsClassifier</span></a></div></label><div class="sk-toggleable__content fitted" data-param-prefix="filtro_kNN__">
        <div class="estimator-table">
            <details>
                <summary>Parameters</summary>
                <table class="parameters-table">
                  <tbody>

        <tr class="user-set">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('n_neighbors',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=n_neighbors,-int%2C%20default%3D5">
            n_neighbors
            <span class="param-doc-description">n_neighbors: int, default=5<br><br>Number of neighbors to use by default for :meth:`kneighbors` queries.</span>
        </a>
    </td>
            <td class="value">1</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('weights',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=weights,-%7B%27uniform%27%2C%20%27distance%27%7D%2C%20callable%20or%20None%2C%20default%3D%27uniform%27">
            weights
            <span class="param-doc-description">weights: {'uniform', 'distance'}, callable or None, default='uniform'<br><br>Weight function used in prediction.  Possible values:<br><br>- 'uniform' : uniform weights.  All points in each neighborhood<br>  are weighted equally.<br>- 'distance' : weight points by the inverse of their distance.<br>  in this case, closer neighbors of a query point will have a<br>  greater influence than neighbors which are further away.<br>- [callable] : a user-defined function which accepts an<br>  array of distances, and returns an array of the same shape<br>  containing the weights.<br><br>Refer to the example entitled<br>:ref:`sphx_glr_auto_examples_neighbors_plot_classification.py`<br>showing the impact of the `weights` parameter on the decision<br>boundary.</span>
        </a>
    </td>
            <td class="value">&#x27;uniform&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('algorithm',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=algorithm,-%7B%27auto%27%2C%20%27ball_tree%27%2C%20%27kd_tree%27%2C%20%27brute%27%7D%2C%20default%3D%27auto%27">
            algorithm
            <span class="param-doc-description">algorithm: {'auto', 'ball_tree', 'kd_tree', 'brute'}, default='auto'<br><br>Algorithm used to compute the nearest neighbors:<br><br>- 'ball_tree' will use :class:`BallTree`<br>- 'kd_tree' will use :class:`KDTree`<br>- 'brute' will use a brute-force search.<br>- 'auto' will attempt to decide the most appropriate algorithm<br>  based on the values passed to :meth:`fit` method.<br><br>Note: fitting on sparse input will override the setting of<br>this parameter, using brute force.</span>
        </a>
    </td>
            <td class="value">&#x27;auto&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('leaf_size',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=leaf_size,-int%2C%20default%3D30">
            leaf_size
            <span class="param-doc-description">leaf_size: int, default=30<br><br>Leaf size passed to BallTree or KDTree.  This can affect the<br>speed of the construction and query, as well as the memory<br>required to store the tree.  The optimal value depends on the<br>nature of the problem.</span>
        </a>
    </td>
            <td class="value">30</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('p',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=p,-float%2C%20default%3D2">
            p
            <span class="param-doc-description">p: float, default=2<br><br>Power parameter for the Minkowski metric. When p = 1, this is equivalent<br>to using manhattan_distance (l1), and euclidean_distance (l2) for p = 2.<br>For arbitrary p, minkowski_distance (l_p) is used. This parameter is expected<br>to be positive.</span>
        </a>
    </td>
            <td class="value">2</td>
        </tr>


        <tr class="user-set">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('metric',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=metric,-str%20or%20callable%2C%20default%3D%27minkowski%27">
            metric
            <span class="param-doc-description">metric: str or callable, default='minkowski'<br><br>Metric to use for distance computation. Default is "minkowski", which<br>results in the standard Euclidean distance when p = 2. See the<br>documentation of `scipy.spatial.distance<br><https://docs.scipy.org/doc/scipy/reference/spatial.distance.html>`_ and<br>the metrics listed in<br>:class:`~sklearn.metrics.pairwise.distance_metrics` for valid metric<br>values.<br><br>If metric is "precomputed", X is assumed to be a distance matrix and<br>must be square during fit. X may be a :term:`sparse graph`, in which<br>case only "nonzero" elements may be considered neighbors.<br><br>If metric is a callable function, it takes two arrays representing 1D<br>vectors as inputs and must return one value indicating the distance<br>between those vectors. This works for Scipy's metrics, but is less<br>efficient than passing the metric name as a string.</span>
        </a>
    </td>
            <td class="value">&#x27;cosine&#x27;</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('metric_params',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=metric_params,-dict%2C%20default%3DNone">
            metric_params
            <span class="param-doc-description">metric_params: dict, default=None<br><br>Additional keyword arguments for the metric function.</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>


        <tr class="default">
            <td><i class="copy-paste-icon"
                 onclick="copyToClipboard('n_jobs',
                          this.parentElement.nextElementSibling)"
            ></i></td>
            <td class="param">
        <a class="param-doc-link"
            rel="noreferrer" target="_blank" href="https://scikit-learn.org/1.8/modules/generated/sklearn.neighbors.KNeighborsClassifier.html#:~:text=n_jobs,-int%2C%20default%3DNone">
            n_jobs
            <span class="param-doc-description">n_jobs: int, default=None<br><br>The number of parallel jobs to run for neighbors search.<br>``None`` means 1 unless in a :obj:`joblib.parallel_backend` context.<br>``-1`` means using all processors. See :term:`Glossary <n_jobs>`<br>for more details.<br>Doesn't affect :meth:`fit` method.</span>
        </a>
    </td>
            <td class="value">None</td>
        </tr>

                  </tbody>
                </table>
            </details>
        </div>
    </div></div></div></div></div></div></div><script>function copyToClipboard(text, element) {
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

forceTheme('sk-container-id-2');</script></body>




```python
carpeta_prueba = carpeta_Enron_Spam / 'test'

contenidos_mensajes_prueba = []
clases_mensajes_prueba = []

# Leemos los mensajes legítimos (clase 0)
for ruta_mensaje in (carpeta_prueba / 'legítimo').iterdir():
    with open(ruta_mensaje, 'r') as fichero_mensaje:
        try:
            mensaje = analizador_mensaje.parse(fichero_mensaje)
            contenidos_mensajes_prueba.append(mensaje.get_content())
            clases_mensajes_prueba.append(0)
        except (KeyError, UnicodeDecodeError, LookupError):
            pass

# Leemos los mensajes no deseados (clase 1)
for ruta_mensaje in (carpeta_prueba / 'no_deseado').iterdir():
    with open(ruta_mensaje, 'r') as fichero_mensaje:
        try:
            mensaje = analizador_mensaje.parse(fichero_mensaje)
            contenidos_mensajes_prueba.append(mensaje.get_content())
            clases_mensajes_prueba.append(1)
        except (KeyError, UnicodeDecodeError, LookupError):
            pass
```


```python
from sklearn.metrics import recall_score
```


```python
predicciones_mensajes_prueba = filtro_seleccionado.predict(
    contenidos_mensajes_prueba)
recall_score(clases_mensajes_prueba, predicciones_mensajes_prueba)
```




    0.8380849919311458



## Sistema de texto predictivo

Los sistemas de texto predictivo son una tecnología de entrada de texto diseñada para dispositivos móviles. Esta tecnología permite formar palabras presionando una zona de la pantalla asociada a un grupo de letras. La aplicación principal de esta tecnología es simplificar la escritura de mensajes de texto.

Aunque esta tecnología se utilizó inicialmente para facilitar la escritura de mensajes en teléfonos móviles con teclado numérico, la aparición del smartphone con teclado ampliado provocó que cambiase el tipo de aplicaciones a las que se aplica. Actualmente se utiliza tanto para facilitar la escritura en teclados ampliados (samsung swype) como para sugerir nuevas entradas de texto (escritura inteligente). También es notable su uso en dispositivos móviles más pequeños como los Smart Watch.

Los sistemas de texto predicen la palabra que queremos escribir a partir de las pulsaciones realizadas. Para ello han efectuado previamente un análisis estadístico de un corpus de textos de referencia, determinando las probabilidades de las correspondencias entre distintas secuencias de pulsaciones y posibles palabras.

Estos sistemas suelen mostrar la palabra que corresponde con mayor probabilidad a la combinación de pulsaciones realizada por el usuario, actualizándose esta palabra a medida que el usuario realiza nuevas pulsaciones. Además, es habitual ofrecer al usuario la posibilidad de requerir otras posibilidades, aparte de aceptar la palabra propuesta por el sistema.

La efectividad de un sistema de prediccion de texto dependerá de varios factores:

* La calidad del corpus.
* El modelo de lenguaje obtenido a partir del análisis estadístico del corpus.

En esta segunda parte de la práctica se va utilizar la biblioteca NLTK para construir un sistema de predicción de texto en español basado en modelos de $n$-gramas.

En primer lugar se debe cargar un corpus de textos en español que nos permita entrenar el modelo. Por ejemplo, el [corpus InfoLibros](https://zenodo.org/records/7313105) es un corpus de 218 millones de tókenes de narrativas españolas extraídas de libros gratuitos recopilados por el proyecto abierto [Infolibros.org](http://infolibros.org/). Por motivos de eficiencia computacional, nosotros usaremos únicamente una parte de ese corpus, guardado en el fichero `Texto predictivo/corpus_InfoLibros_parcial.txt`.

NLTK proporciona diferentes clases que permiten leer corpus de muy diversos tipos. Entre ellas se encuentra la clase `PlaintextCorpusReader` para leer corpus proporcionados en ficheros de texto plano, como es el caso que nos ocupa. Para identificar las frases contenidas en el corpus, usaremos el modelo proporcionado por NLTK para el español, creando para ello una instancia adecuada de la clase `PunktTokenizer`. Mantendremos la separación por defecto de cada una de esas frases en palabras que sean secuencias solo de caracteres alfanuméricos o solo de caracteres no alfanuméricos, aunque ese comportamiento también es configurable.


```python
# Nos aseguramos de haber descargado el tokenizador

from nltk import download

download('punkt_tab')
```

    [nltk_data] Downloading package punkt_tab to ....
    [nltk_data]   Package punkt_tab is already up-to-date!





    True




```python
from nltk.corpus.reader.plaintext import PlaintextCorpusReader
from nltk.tokenize.punkt import PunktTokenizer
```


```python
corpus_InfoLibros = PlaintextCorpusReader(
    root='Texto predictivo',
    fileids=['corpus_InfoLibros_parcial.txt'],
    encoding='utf8',
    sent_tokenizer=PunktTokenizer(lang='spanish')
)
```

Los métodos `paras`, `sents` y `words` proporcionan, respectivamente, los párrafos, frases y palabras identificados en el corpus.


```python
for para in corpus_InfoLibros.paras()[:5]:
    pprint(para[:3] + [['...']], compact=True)
    print()
```

    [['Venga', 'usted', 'aquí', ',', 'querida', 'Elena', '-', 'dijo', 'Ana',
      'Pavlovna', 'a', 'la', 'bella', 'Princesa', ',', 'que', ',', 'sentada', 'un',
      'poco', 'más', 'lejos', ',', 'formaba', 'el', 'centro', 'del', 'otro',
      'grupo', '.'],
     ['La', 'princesa', 'Elena', 'sonrió', 'y', 'se', 'levantó', 'con', 'la',
      'misma', 'invariable', 'sonrisa', 'de', 'mujer', 'absolutamente', 'hermosa',
      'con', 'que', 'había', 'entrado', 'en', 'el', 'salón', '.'],
     ['Con', 'el', 'ligero', 'rumor', 'de', 'su', 'leve', 'vestido', 'de', 'baile',
      'con', 'adornos', 'de', 'felpa', ',', 'deslumbradora', 'por', 'la',
      'blancura', 'de', 'sus', 'hombros', 'y', 'el', 'esplendor', 'de', 'sus',
      'cabellos', 'y', 'de', 'sus', 'diamantes', ',', 'cruzó', 'entre', 'los',
      'hombres', ',', 'que', 'le', 'abrieron', 'paso', ',', 'rígida', ',', 'sin',
      'ver', 'a', 'nadie', ',', 'pero', 'sonriendo', 'a', 'todos', 'como', 'si',
      'concediese', 'a', 'cada', 'uno', 'el', 'derecho', 'de', 'admirar', 'la',
      'belleza', 'de', 'su', 'aspecto', ',', 'de', 'sus', 'redondeados', 'hombros',
      ',', 'de', 'su', 'espalda', ',', 'de', 'su', 'pecho', ',', 'muy', 'escotado',
      ',', 'según', 'la', 'moda', 'de', 'la', 'época', ',', 'y', 'con', 'su',
      'gracioso', 'caminar', 'se', 'acercó', 'a', 'Ana', 'Pavlovna', '.'],
     ['...']]
    
    [['Libro', 'descargado', 'en', 'www', '.', 'elejandria', '.', 'com', ',', 'tu',
      'sitio', 'web', 'de', 'obras', 'de', 'dominio', 'público', '¡', 'Esperamos',
      'que', 'lo', 'disfrutéis', '!'],
     ['Las', 'Aventuras', 'de', 'Pinocho', 'Por', 'C', '.', 'Collodi', 'I', 'Cómo',
      'fue', 'que', 'el', 'maestro', 'Cereza', ',', 'carpintero', 'de', 'oficio',
      ',', 'encontró', 'un', 'palo', 'que', 'lloraba', 'y', 'reía', 'como', 'un',
      'niño', '.'],
     ['-¡', 'Un', 'rey', '!'], ['...']]
    
    [['La', 'Comunicación', 'no', 'verbal', '(', 'CNV', ')', 'y', 'su', 'relación',
      'con', 'la', 'interpretación', 'es', 'el', 'tema', 'que', 'pretendemos',
      'abordar', 'en', 'este', 'trabajo', '.'],
     ['Muchos', 'estudiosos', 'consideran', 'importante', 'conocer', 'este', 'tipo',
      'de', 'comunicación', ',', 'para', 'una', 'mejor', 'compresión', 'del',
      'mensaje', ',', 'una', 'reproducción', 'más', 'fidedigna', 'del', 'mismo',
      ',', 'por', 'ende', 'un', 'mejor', 'trabajo', 'del', 'intérprete', '.'],
     ['Se', 'realiza', 'un', 'análisis', 'de', 'la', 'CNV', ',', 'de', 'forma',
      'específica', 'la', 'kinesica', 'y', 'la', 'paralingüística', '.'],
     ['...']]
    
    [['Este', 'documento', 'no', 'ha', 'sido', 'sometido', 'a', 'revision',
      'editorial', '.'],
     ['Este', 'documento', 'contiene', 'el', 'material', 'docente', 'empleado',
      'por', 'el', 'Banco', 'Interamericano', 'de', 'Desarrollo', '(', 'BID', ')',
      'y', 'el', 'Instituto', 'Latinoamericano', 'de', 'Planificacion', 'Economica',
      'y', 'Social', '(', 'ILPES', ')', 'en', 'el', 'marco', 'del', 'programa',
      'de', 'Capacitacion', 'para', 'los', 'paises', 'C', 'y', 'DI', '.'],
     ['El', 'proposito', 'de', 'este', 'programa', 'es', 'contribuir', 'al',
      'desarrollo', 'de', 'una', 'capacidad', 'nacional', 'perrnanente', 'de',
      'entrenamiento', 'a', 'funcionarios', 'de', 'las', 'instituciones',
      'responsables', 'de', 'la', 'gestion', 'de', 'programas', 'y', 'proyectos',
      '.'],
     ['...']]
    
    [['A', 'mi', 'madre', 'con', 'infinito', 'cariño', '.'],
     ['A', 'mi', 'padre', 'dondequiera', 'que', 'se', 'encuentre', '.'],
     ['A', 'mi', 'hijo', 'Eliud', 'que', 'es', 'el', 'motivo', 'de', 'mi',
      'existencia', '.'],
     ['...']]
    



```python
pprint(corpus_InfoLibros.sents()[:5], compact=True)
```

    [['Venga', 'usted', 'aquí', ',', 'querida', 'Elena', '-', 'dijo', 'Ana',
      'Pavlovna', 'a', 'la', 'bella', 'Princesa', ',', 'que', ',', 'sentada', 'un',
      'poco', 'más', 'lejos', ',', 'formaba', 'el', 'centro', 'del', 'otro',
      'grupo', '.'],
     ['La', 'princesa', 'Elena', 'sonrió', 'y', 'se', 'levantó', 'con', 'la',
      'misma', 'invariable', 'sonrisa', 'de', 'mujer', 'absolutamente', 'hermosa',
      'con', 'que', 'había', 'entrado', 'en', 'el', 'salón', '.'],
     ['Con', 'el', 'ligero', 'rumor', 'de', 'su', 'leve', 'vestido', 'de', 'baile',
      'con', 'adornos', 'de', 'felpa', ',', 'deslumbradora', 'por', 'la',
      'blancura', 'de', 'sus', 'hombros', 'y', 'el', 'esplendor', 'de', 'sus',
      'cabellos', 'y', 'de', 'sus', 'diamantes', ',', 'cruzó', 'entre', 'los',
      'hombres', ',', 'que', 'le', 'abrieron', 'paso', ',', 'rígida', ',', 'sin',
      'ver', 'a', 'nadie', ',', 'pero', 'sonriendo', 'a', 'todos', 'como', 'si',
      'concediese', 'a', 'cada', 'uno', 'el', 'derecho', 'de', 'admirar', 'la',
      'belleza', 'de', 'su', 'aspecto', ',', 'de', 'sus', 'redondeados', 'hombros',
      ',', 'de', 'su', 'espalda', ',', 'de', 'su', 'pecho', ',', 'muy', 'escotado',
      ',', 'según', 'la', 'moda', 'de', 'la', 'época', ',', 'y', 'con', 'su',
      'gracioso', 'caminar', 'se', 'acercó', 'a', 'Ana', 'Pavlovna', '.'],
     ['Elena', 'era', 'tan', 'hermosa', 'que', 'no', 'solamente', 'no', 'veíase',
      'en', 'ella', 'una', 'sombra', 'de', 'coquetería', ',', 'sino', 'que', ',',
      'al', 'contrario', ',', 'parecía', 'que', 'se', 'avergonzase', 'de', 'su',
      'indiscutible', 'belleza', ',', 'que', 'ejercía', 'victoriosamente', 'sobre',
      'los', 'demás', 'una', 'influencia', 'demasiado', 'fuerte', '.'],
     ['Hubiérase', 'dicho', 'que', 'deseaba', ',', 'sin', 'poder', 'conseguirlo',
      ',', 'amenguar', 'el', 'efecto', 'de', 'su', 'hermosura', '.']]



```python
pprint(corpus_InfoLibros.words()[:50], compact=True)
```

    ['Venga', 'usted', 'aquí', ',', 'querida', 'Elena', '-', 'dijo', 'Ana',
     'Pavlovna', 'a', 'la', 'bella', 'Princesa', ',', 'que', ',', 'sentada', 'un',
     'poco', 'más', 'lejos', ',', 'formaba', 'el', 'centro', 'del', 'otro', 'grupo',
     '.', 'La', 'princesa', 'Elena', 'sonrió', 'y', 'se', 'levantó', 'con', 'la',
     'misma', 'invariable', 'sonrisa', 'de', 'mujer', 'absolutamente', 'hermosa',
     'con', 'que', 'había', 'entrado']


Siguiendo el procedimiento habitual en aprendizaje automático, dividimos el corpus en un subcorpus de entrenamiento y un subcorpus de prueba. Sin embargo, debido al tamaño del corpus, una división aleatoria resulta muy costosa computacionalmente. Es por ello que para el corpus de entrenamiento seleccionaremos el 80 % de las frases iniciales del corpus, dejando para el corpus de prueba el 20 % de las frases finales.


```python
total_frases = len(corpus_InfoLibros.sents())
total_frases
```




    1008664




```python
total_frases_entrenamiento = int(total_frases * .8)
total_frases_entrenamiento
```




    806931




```python
corpus_entrenamiento = corpus_InfoLibros.sents()[:total_frases_entrenamiento]
corpus_prueba = corpus_InfoLibros.sents()[total_frases_entrenamiento:]
```

El primer paso en la construcción del sistema de texto predictivo consiste en identificar el vocabulario de todas las palabras que aparecen en el corpus de entrenamiento. Para ello se hará uso de la clase `Vocabulary`, que proporciona una estructura de tipo diccionario que guarda el número de ocurrencias de cada palabra identificada. Esto permite establecer un número mínimo de ocurrencias para que una palabra se considere parte del vocabulario.


```python
from nltk.lm.vocabulary import Vocabulary
# flatten es una utilidad que permite aplanar listas de listas
from nltk.lm.preprocessing import flatten
```


```python
vocabulario_palabras = Vocabulary(
    flatten(corpus_entrenamiento),  # lista de todas las palabras
    unk_cutoff=50  # mínimo número de ocurrencias
)
```

El vocabulario incluye por defecto el término `<UNK>` para representar los términos desconocidos que no aparecen en el corpus de entrenamiento.


```python
# Hola aparece en el corpus de entrenamiento y, por tanto,
# pertenece al vocabulario
vocabulario_palabras.lookup('Hola')
```




    'Hola'




```python
# hola no aparece en el corpus de entrenamiento y, por tanto,
# es un término desconocido
vocabulario_palabras.lookup('hola')
```




    '<UNK>'



Por otra parte, los símbolos especiales de inicio y fin de secuencia que es necesario considerar en los modelos de $n$-gramas hay que incluirlos explícitamente en el vocabulario y, además, en este caso con frecuencia 50, para que sean considerados parte del vocabulario.


```python
inicio_frase = '<s>'
fin_frase = '</s>'
vocabulario_palabras.update({inicio_frase: 50, fin_frase: 50})
```

La siguiente función facilitará delimitar adecuadamente, en función de los n-gramas pretendidos, las frases con esos símbolos especiales.


```python
def delimita_frase(frase, n):
    return ['<s>'] * (n - 1) + frase + ['</s>']
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

    ['Venga', 'usted', 'aquí', ',', 'querida', 'Elena', '-', 'dijo', 'Ana',
     'Pavlovna', 'a', 'la', 'bella', 'Princesa', ',', 'que', ',', 'sentada', 'un',
     'poco', 'más', 'lejos', ',', 'formaba', 'el', 'centro', 'del', 'otro', 'grupo',
     '.', '</s>']
    ['<s>', 'Venga', 'usted', 'aquí', ',', 'querida', 'Elena', '-', 'dijo', 'Ana',
     'Pavlovna', 'a', 'la', 'bella', 'Princesa', ',', 'que', ',', 'sentada', 'un',
     'poco', 'más', 'lejos', ',', 'formaba', 'el', 'centro', 'del', 'otro', 'grupo',
     '.', '</s>']
    ['<s>', '<s>', 'Venga', 'usted', 'aquí', ',', 'querida', 'Elena', '-', 'dijo',
     'Ana', 'Pavlovna', 'a', 'la', 'bella', 'Princesa', ',', 'que', ',', 'sentada',
     'un', 'poco', 'más', 'lejos', ',', 'formaba', 'el', 'centro', 'del', 'otro',
     'grupo', '.', '</s>']


Para obtener los $n$-gramas de una frase basta aplicar la función `ngrams` de NLTK, o específicamente las funciones `bigrams` y `trigrams` para los bigramas y trigramas.


```python
from nltk.util import ngrams, bigrams, trigrams
```


```python
list(ngrams(delimita_frase(primera_frase_entrenamiento, 1), n=1))
```




    [('Venga',),
     ('usted',),
     ('aquí',),
     (',',),
     ('querida',),
     ('Elena',),
     ('-',),
     ('dijo',),
     ('Ana',),
     ('Pavlovna',),
     ('a',),
     ('la',),
     ('bella',),
     ('Princesa',),
     (',',),
     ('que',),
     (',',),
     ('sentada',),
     ('un',),
     ('poco',),
     ('más',),
     ('lejos',),
     (',',),
     ('formaba',),
     ('el',),
     ('centro',),
     ('del',),
     ('otro',),
     ('grupo',),
     ('.',),
     ('</s>',)]




```python
list(bigrams(delimita_frase(primera_frase_entrenamiento, 2)))
```




    [('<s>', 'Venga'),
     ('Venga', 'usted'),
     ('usted', 'aquí'),
     ('aquí', ','),
     (',', 'querida'),
     ('querida', 'Elena'),
     ('Elena', '-'),
     ('-', 'dijo'),
     ('dijo', 'Ana'),
     ('Ana', 'Pavlovna'),
     ('Pavlovna', 'a'),
     ('a', 'la'),
     ('la', 'bella'),
     ('bella', 'Princesa'),
     ('Princesa', ','),
     (',', 'que'),
     ('que', ','),
     (',', 'sentada'),
     ('sentada', 'un'),
     ('un', 'poco'),
     ('poco', 'más'),
     ('más', 'lejos'),
     ('lejos', ','),
     (',', 'formaba'),
     ('formaba', 'el'),
     ('el', 'centro'),
     ('centro', 'del'),
     ('del', 'otro'),
     ('otro', 'grupo'),
     ('grupo', '.'),
     ('.', '</s>')]




```python
list(trigrams(delimita_frase(primera_frase_entrenamiento, 3)))
```




    [('<s>', '<s>', 'Venga'),
     ('<s>', 'Venga', 'usted'),
     ('Venga', 'usted', 'aquí'),
     ('usted', 'aquí', ','),
     ('aquí', ',', 'querida'),
     (',', 'querida', 'Elena'),
     ('querida', 'Elena', '-'),
     ('Elena', '-', 'dijo'),
     ('-', 'dijo', 'Ana'),
     ('dijo', 'Ana', 'Pavlovna'),
     ('Ana', 'Pavlovna', 'a'),
     ('Pavlovna', 'a', 'la'),
     ('a', 'la', 'bella'),
     ('la', 'bella', 'Princesa'),
     ('bella', 'Princesa', ','),
     ('Princesa', ',', 'que'),
     (',', 'que', ','),
     ('que', ',', 'sentada'),
     (',', 'sentada', 'un'),
     ('sentada', 'un', 'poco'),
     ('un', 'poco', 'más'),
     ('poco', 'más', 'lejos'),
     ('más', 'lejos', ','),
     ('lejos', ',', 'formaba'),
     (',', 'formaba', 'el'),
     ('formaba', 'el', 'centro'),
     ('el', 'centro', 'del'),
     ('centro', 'del', 'otro'),
     ('del', 'otro', 'grupo'),
     ('otro', 'grupo', '.'),
     ('grupo', '.', '</s>')]



La clase `MLE` implementa los modelos de $n$-gramas de máxima verosimilitud y la clase `Laplace` los modelos análogos que, adicionalmente, incorporan un suavizado de Laplace. Para crear instancias de esas clases hay que proporcionar el orden de los $n$-gramas y el vocabulario de términos. Una vez creadas, se entrenan aplicando el método `fit` a la secuencia de las secuencias de $n$-gramas de cada frase de entrenamiento y se evalua aplicando el método `perplexity` a la secuencia de los $n$-gramas de todas las frases de prueba.


```python
from nltk.lm import MLE, Laplace
```


```python
modelo_unigrama_MLE = MLE(1, vocabulary=vocabulario_palabras)
modelo_unigrama_MLE.fit(ngrams(delimita_frase(frase, 1), n=1)
                        for frase in corpus_entrenamiento)
modelo_unigrama_MLE.perplexity(flatten(ngrams(delimita_frase(frase, 1), n=1)
                                       for frase in corpus_prueba))
```




    569.4380946356334




```python
modelo_unigrama_Laplace = Laplace(1, vocabulary=vocabulario_palabras)
modelo_unigrama_Laplace.fit(ngrams(delimita_frase(frase, 1), n=1)
                            for frase in corpus_entrenamiento)
modelo_unigrama_Laplace.perplexity(flatten(ngrams(delimita_frase(frase, 1), n=1)
                                           for frase in corpus_prueba))
```




    569.4578979334117




```python
modelo_bigrama_MLE = MLE(2, vocabulary=vocabulario_palabras)
modelo_bigrama_MLE.fit(bigrams(delimita_frase(frase, 2))
                       for frase in corpus_entrenamiento)
modelo_bigrama_MLE.perplexity(flatten(bigrams(delimita_frase(frase, 2))
                                      for frase in corpus_prueba))
```




    inf



La perplejidad no tiene una cota superior absoluta. Se calcula como el inverso de la probabilidad asignada por el modelo al corpus de prueba, normalizado por la cantidad de términos que este contiene.

- Puesto que el modelo puede asignar a una secuencia una probabilidad arbitrariamente pequeña (muy cercana a 0), el valor inverso puede crecer indefinidamente hacia el infinito
- De hecho, si el modelo se encuentra con una secuencia a la que le asigna una probabilidad de 0 (por ejemplo, si no se han aplicado técnicas de suavizado ante palabras desconocidas), la perplejidad se dispararía matemáticamente al **infinito**.


#### Se interpreta siguiendo esta regla principal:
En cuanto a su interpretación, la perplejidad evalúa el nivel de "sorpresa" o "duda" de un modelo de lenguaje al enfrentarse a un texto real nuevo. 

- Cuanto menor sea el valor de la perplejidad, mejor será el modelo. Un valor bajo (cuyo límite inferior ideal roza el 1) significa que el modelo ha asignado una probabilidad alta a la secuencia real, es decir, el texto encaja perfectamente con lo que el modelo esperaba leer.
- Una perplejidad muy alta indica que el modelo está sumamente "sorprendido" por la secuencia, ya que la considera altamente improbable basándose en lo que aprendió en su entrenamiento. Como vimos en los ejercicios anteriores, si una frase está compuesta puramente por elementos "raros" o poco frecuentes, la duda del modelo se dispara y la perplejidad alcanza valores máximos correspondientes a la inversa de esa probabilidad mínima.


```python
modelo_bigrama_Laplace = Laplace(2, vocabulary=vocabulario_palabras)
modelo_bigrama_Laplace.fit(bigrams(delimita_frase(frase, 2))
                           for frase in corpus_entrenamiento)
modelo_bigrama_Laplace.perplexity(flatten(bigrams(delimita_frase(frase, 2))
                                          for frase in corpus_prueba))
```




    366.2692890116132




```python
modelo_trigrama_MLE = MLE(3, vocabulary=vocabulario_palabras)
modelo_trigrama_MLE.fit(trigrams(delimita_frase(frase, 3))
                        for frase in corpus_entrenamiento)
modelo_trigrama_MLE.perplexity(flatten(trigrams(delimita_frase(frase, 3))
                                       for frase in corpus_prueba))
```




    inf




```python
modelo_trigrama_Laplace = Laplace(3, vocabulary=vocabulario_palabras)
modelo_trigrama_Laplace.fit(trigrams(delimita_frase(frase, 3))
                            for frase in corpus_entrenamiento)
modelo_trigrama_Laplace.perplexity(flatten(trigrams(delimita_frase(frase, 3))
                                           for frase in corpus_prueba))
```




    2138.444556966786



El mejor modelo parece ser, por tanto, el modelo bigrama con suavizado de Laplace, ya que es el que _menos perplejo se queda_ ante el corpus de prueba.

La idea es, entonces, usar estos modelos para predecir, a partir de las palabras anteriores y de las letras de la palabra ya escritas, qué palabra se pretende escribir.


```python
def predice_palabras(prefijo, contexto, numero_palabras, modelo):
    def puntua_palabra(palabra):
        return modelo.score(palabra, contexto)  # contexto debe ser una tupla
    palabras_candidatas = filter(lambda palabra: palabra.startswith(prefijo),
                                 vocabulario_palabras)
    palabras_candidatas_ordenadas = sorted(palabras_candidatas,
                                           key=puntua_palabra,
                                           reverse=True)
    return palabras_candidatas_ordenadas[:numero_palabras]
```

Por ejemplo, si se ha escrito _Procesamiento del lenguaje nat_ podríamos usar el modelo bigrama con suavizado de Laplace (luego el contexto sería una tupla con la palabra _lenguaje_) para predecir las cinco palabras más probables que se estarían queriendo escribir.


```python
predice_palabras('nat', ('lenguaje',), 5, modelo_bigrama_Laplace)
```




    ['natural', 'naturalmente', 'nata', 'naturales', 'naturaleza']


