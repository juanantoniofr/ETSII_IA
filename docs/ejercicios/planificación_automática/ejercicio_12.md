## Ejercicio 12

Consideremos el siguiente problema de planificación automática:

- Hechos: Hi, para i = 1, ... , 6.

- Acciones:

  | Acción | Precondiciones | Lista de borrado | Lista de adición | Coste |
  | ------ | -------------- | ---------------- | ---------------- | ----- |
  | A      | H1             | H1               | H3, H4           | 3     |
  | B      | H3, H4         | H4               | H2, H5, H6       | 2     |
  | C      | H4             | H5               | H3, H6           | 2     |
  | D      | H2             | H1               | H4, H5, H6       | 3     |
  | E      | H4, H6         | H3               | H1, H2, H5       | 3     |
  | F      | H3             | H3               | H1, H2, H6       | 3     |

- Estado inicial: {H2}
- Objetivo: {H3, H4, H5}

Se pide calcular, mediante el algoritmo de programación dinámica, el valor de hmax y de hadd para el estado inicial del problema.

## Solución

Idea: buscar acciones tales que en sus prerrequisitos todas las acciones tengan un peso menor que infinito

| Pasos | To Hmax ToHinf | (1)     | (2) (x) | (3) |
| ----- | -------------- | ------- | ------- | --- |
| H1    | inf inf        | inf inf | 6 9     | 6 8 |
| H2    | 0 0            | 0 0     | 0 0     | 0 0 |
| H3    | inf inf        | inf inf | 5 5     | 5 5 |
| H4    | inf inf        | 3 3     | 3 3     | 3 3 |
| H5    | inf inf        | 3 3     | 3 3     | 3 3 |
| H6    | inf inf        | 3 3     | 3 3     | 3 3 |

(1) La única acción con predicados finitos en D(coste=3)
Cpred(D) = máximo de los pesos de sus predecesores
Cpred(D) = 0

**Los hechos en add(D) son:**

- H4 -> (D) Ch4=3, Ch4=3
- H5 -> (D) Ch4=3, Ch4=3
- H6 -> (D) Ch4=3, Ch4=3

(2)
tengo que considerar las acciones con pre finito son: C, D

- C
  -pre = 3
  -pre = 3
- D -> Calculado antes en la anterior iteración
- E
  -pre = 3
  -pre = 3 + 3 = 6
  **Los hechos en add(C) o add(E) son:**
- H3 -> (C) Ch3 = Cpre + C = 3 + 2 = 5
  -> (E) Ch3 = Cpre + C = 3 + 2 = 5
- H1 -> (E) Ch1 = 3+3=6
  (c) Ch1 = 6+3=9
- H6 -> (c)
