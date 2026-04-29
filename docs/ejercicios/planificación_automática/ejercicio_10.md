## Ejercicio 10

Consideremos el siguiente problema de planificación automática:

- Hechos: 𝐻𝘪 , para 𝑖 = 1, … , 9.
- Acciones:

| Acción | Precondiciones | Lista de borrado | Lista de adición | Coste |
| ------ | -------------- | ---------------- | ---------------- | ----- |
| A      | H9, H2         | H3, H5, H8       | H1               | 1     |
| B      | H1, H6, H8     | H4               | H9               | 3     |
| C      | H3             | H3, H5           | H4, H6, H8       | 4     |
| D      | H1, H2, H3     | H1, H2           | H6               | 5     |
| E      | H1             | H1, H2           | H6               | 0     |

- Estado inicial: {𝐻𝟣}
- Objetivo: {𝐻𝟤, 𝐻𝟧, 𝐻𝟪}

Para cada estado 𝑠 siguiente se pide **determinar todos los posibles planes relajados** para 𝑠 y calcular el valor de ℎ+(𝑠):

- 1. {𝐻𝟣, 𝐻𝟤, 𝐻𝟥}
- 2. {𝐻𝟣, 𝐻𝟥, 𝐻𝟨, 𝐻𝟪}

## Solución

Hay que llegar desde aquí ( S <- {𝐻𝟣, 𝐻𝟤, 𝐻𝟥} ) hasta {H1, H2, H3, H4, H5, H6, H7, H8, H9}

los posibles caminos son:
C-B-A -> COSTE = 8
D-C-B-A -> COSTE = 13
E-C-B-A -> COSTE = 8
