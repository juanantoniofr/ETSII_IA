Aquí tienes el enunciado adaptado para resolver el mismo problema de los correos electrónicos, pero utilizando la vectorización TF-IDF y el algoritmo kNN, junto con las fórmulas matemáticas necesarias.

### Enunciado del problema: Clasificación de Spam con TF-IDF y kNN

Considera un problema de clasificación de correos electrónicos en "Spam" y "No Spam". El vocabulario extraído es $V = \{\text{oferta}, \text{premio}, \text{hola}, \text{gratis}\}$. Tienes el siguiente corpus de entrenamiento:

- **Spam:** $D_1 =$ "oferta premio", $D_2 =$ "oferta gratis gratis", $D_3 =$ "premio gratis"
- **No Spam:** $D_4 =$ "hola hola", $D_5 =$ "hola premio"

Se pide:

1. Obtener la representación numérica de cada uno de los correos de entrenamiento y del nuevo correo $D_{nuevo} =$ "oferta hola gratis" bajo el **modelo tf-idf** (asumiendo logaritmo en base 2).
2. Clasificar el nuevo correo $D_{nuevo}$ como "Spam" o "No Spam" mediante un modelo **k-Vecinos más Cercanos (kNN) con $k=3$**, utilizando la **similitud del coseno** como métrica para evaluar la cercanía entre los correos.

---

### Fórmulas matemáticas a aplicar

Para resolver este problema, debes utilizar dos bloques de fórmulas: primero para transformar el texto en números (TF-IDF) y luego para calcular las distancias geométricas (kNN con Coseno).

**1. Fórmulas de Vectorización (TF-IDF)**
El peso de un término $t$ en un documento $D$ se calcula multiplicando su frecuencia local por su rareza global:

$$tf\text{-}idf_{t,D} = tf_{t,D} \times idf_t$$

Donde:

- **$tf_{t,D}$ (Term Frequency):** Es el número de veces entero que aparece el término $t$ exactamente en el documento $D$.
- **$idf_t$ (Inverse Document Frequency):** Se calcula con la fórmula **$\log_2(\frac{N}{df_t})$**.
  - **$N$**: Es la cantidad total de documentos en el corpus de entrenamiento (en este caso, 5 correos).
  - **$df_t$**: Es la cantidad de documentos del corpus de entrenamiento en los que aparece la palabra al menos una vez.

**2. Fórmula de k-Vecinos más Cercanos (kNN) y Similitud del Coseno**
En lugar de la distancia euclídea, al trabajar con TF-IDF en NLP, **la similitud geométrica se mide calculando el coseno del ángulo** que forman los dos vectores de los documentos a comparar ($D_{nuevo}$ y un documento de entrenamiento $D_i$). La fórmula es:

$$sim(D_{nuevo}, D_i) = \frac{D_{nuevo} \cdot D_i}{||D_{nuevo}||_2 \times ||D_i||_2}$$

Desglosando matemáticamente esta expresión para calcularla a mano, el numerador es el producto escalar y el denominador es el producto de los módulos de ambos vectores:

$$sim(D_{nuevo}, D_i) = \frac{\sum_{j=1}^{n} (tf\text{-}idf_{t_j, D_{nuevo}} \times tf\text{-}idf_{t_j, D_i})}{\sqrt{\sum_{j=1}^{n} (tf\text{-}idf_{t_j, D_{nuevo}})^2} \times \sqrt{\sum_{j=1}^{n} (tf\text{-}idf_{t_j, D_i})^2}}$$

**Regla de decisión final:**
Una vez apliques esta fórmula de similitud del coseno entre tu correo $D_{nuevo}$ y los 5 correos del corpus, deberás ordenar los resultados. Seleccionas los **$k=3$ documentos de entrenamiento que hayan obtenido el valor de similitud más alto** (es decir, los más cercanos geométricamente a 1) y asignas al $D_{nuevo}$ la **etiqueta mayoritaria** ("Spam" o "No Spam") entre esos 3 vecinos.

## Resolución paso a paso

### Parca cada documento en el Corpus -> calcular la frecuencia de cada término t del vocabulario.

- Vocabulario
  $V = \{\text{oferta}, \text{premio}, \text{hola}, \text{gratis}\}$

- **Spam:** $D_1 =$ "oferta premio", $D_2 =$ "oferta gratis gratis", $D_3 =$ "premio gratis"
  - $D_1 =$ "oferta premio" -> $V_tf_d1$ =$ (1 1 0 0)
  - $D_2 =$ "oferta gratis gratis" -> $V_tf_d2 =$ (1 0 0 2)
  - $D_3 =$ "premio gratis" -> $V_tf_d3 =$ (0 1 0 1)

- **No Spam:** $D_4 =$ "hola hola", $D_5 =$ "hola premio"
  - $D_4 =$ "hola hola" -> $V_tf_d4   =$ (0 0 2 0)
  - $D_5 =$ "hola premio" -> $V_tf_d5 =$ (0 1 1 0)

- **Documento nuevo**
  $D_{nuevo} =$ "oferta hola gratis" -> $V_tf_dn =$ (1 0 1 1)

### Calculo de idf_t para cada termino del vocabulario ( $\log_2(\frac{N}{df_t})$ )

N -> 5 (número de documentos en el Corpus)
denominador -> número de documentos donde el término aparece al menos 1 vez.

- $idf_{oferta} =$ $\log_2(\frac{5}{2})$ = 1.322
- $idf_{premio} =$ $\log_2(\frac{5}{3})$ = 0.737
- $idf_{hola} =$ $\log_2(\frac{5}{2})$ = 1.322
- $idf_{gratis} =$ $\log_2(\frac{5}{2})$ = 1.322

### Construir los vectores tf-idf

- $vector-tf-idf\_{d1} =$ (1x1.322,1x0.737,0,0) = (1.322, 0.737, 0, 0)
- $vector-tf-idf\_{d2} =$ (1x1.322,0,0,2x1.322) = (1.322, 0, 0, 2.644)
- $vector-tf-idf\_{d3} =$ (0,1x0.737,0,1x1.322) = (0, 0.737, 0, 1.322)
- $vector-tf-idf\_{d4} =$ (0,0,2x1.322,0) = (0, 0, 2.644, 0)
- $vector-tf-idf\_{d5} =$ (0,1x0.737,1x1.322,0) = (0, 0.737, 1.322, 0)
- $vector-tf-idf\_{dn} =$ (1×1.322,0,1×1.322,1×1.322) = (1.322, 0, 1.322, 1.322)

### Pasamos a la fase del algoritmo k-Vecinos más Cercanos (kNN).

Hay calcular la similitud del coseno entre tu nuevo documento D

**Fase k-Vecinos más Cercanos (kNN)**

Ahora pasamos a la fase del algoritmo **k-Vecinos más Cercanos (kNN)**.  
Tu siguiente misión es calcular la **similitud del coseno** entre tu nuevo documento  
\( D\_{\text{nuevo}} \) (con el vector corregido) y cada uno de los **5 documentos de entrenamiento**
(\( D_1 \) a \( D_5 \)).

### Fórmula de la similitud del coseno

Recuerda la fórmula matemática para comparar \( D\_{\text{nuevo}} \) con un documento \( D_i \):

sim(D_nuevo, Di) = (D_nuevo · Di) / (||D_nuevo||₂ × ||Di||₂)

### Donde:

- El **numerador** es el **producto escalar** (multiplicar posición a posición y sumar todo).
- El **denominador** es el **producto de las longitudes // módulos** (la raíz cuadrada de la suma de sus elementos al cuadrado) de los vectores.

### Calculo de D_nuevo y D1

$$
\operatorname{sim}(D_{\text{nuevo}}, D_1)=
\frac{(1.322,\,0,\,1.322,\,1.322)\cdot(1.322,\,0.737,\,0,\,0)}
{\sqrt{1.322^2+0^2+1.322^2+1.322^2}\;\sqrt{1.322^2+0.737^2+0^2+0^2}}
$$
