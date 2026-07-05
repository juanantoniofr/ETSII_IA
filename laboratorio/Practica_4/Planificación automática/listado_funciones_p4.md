# Listado de funciones y clases usados en la práctica 4

_Universidad de Sevilla – Dpto. de Ciencias de la Computación e Inteligencia Artificial_ [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

## Biblioteca Unified-Planning

### Módulo `io`

#### Clase `PDDLReader`

Lectura de ficheros PDDL. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

#### Clase `PDDLWriter`

Escritura de ficheros PDDL. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

### Módulo `shortcuts`

#### Clase `UserType`

Especifica un tipo de objeto del dominio.

**Argumentos:**

- `name`: nombre del tipo de objeto.
- `father` (opcional): indica que se trata de un subtipo de otro tipo de objetos. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

#### Clase `Fluent`

Especifica un fluente del dominio, generalización del concepto de predicado. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

- `BoolType`: implementa el tipo booleano para los fluentes.
- `IntType`: implementa el tipo entero para los fluentes.
- `Int`: construye constantes de tipo entero. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

#### Clase `InstantaneousAction`

Especifica una acción instantánea del dominio. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

**Métodos:**

- `add_precondition`: añade a la acción la precondición proporcionada.
- `add_effect`: añade a la acción el efecto proporcionado. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

#### Clase `Object`

Especifica un objeto concreto de un cierto tipo. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

#### Clase `Problem`

Especifica un problema de planificación clásica. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

**Atributos y métodos:**

- `user_types`: proporciona una lista con los tipos de objeto del problema.
- `add_fluent`: añade al problema el fluente proporcionado.
- `add_actions`: añade al problema cada acción de la lista proporcionada.
- `set_initial_value`: establece el valor inicial del fluente proporcionado.
- `add_goal`: añade al problema el objetivo proporcionado.
- `add_quality_metric`: añade al problema la métrica proporcionada.
- `kind`: proporciona el tipo del problema, en función de las características que este utilice.
- `clone`: devuelve una copia del problema. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

#### Clase `OneshotPlanner`

Planificador en modo _oneshot_. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

**Métodos:**

- `solve`: proporciona, si existe, un plan solución al problema proporcionado.
- `supports`: determina la compatibilidad del planificador con el tipo de problema proporcionado. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)

#### Clase `MinimizeActionCosts`

Implementa una métrica de minimización de costes de acciones. [1](https://uses0-my.sharepoint.com/personal/juanafr_us_es/Documents/Archivos%20de%20chat%20de%20Microsoft%C2%A0Copilot/Listado_pr%C3%A1ctica_4.pdf)
