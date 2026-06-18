# Ayuda en línea para explorar bibliotecas de Python

### 1. Las funciones integradas de Python: `dir()` y `help()`

Esta es la forma más estándar. Abres la terminal de VSCode, escribes `python` (o `python3`) para entrar al modo interactivo, y usas estas dos funciones.

- **Para ver los módulos, métodos y atributos:** Usa `dir()`. Te devolverá una lista con todo lo que contiene el objeto que le pases.
- **Para leer la documentación (clases y cómo usarlas):** Usa `help()`. Te abrirá un manual interactivo en la misma terminal (puedes bajar con las flechas y presionar la tecla `q` para salir).

**Ejemplo de uso:**

```python
# 1. Importas la biblioteca principal o el módulo que quieras investigar
import unified_planning as up
from unified_planning.shortcuts import Problem

# 2. Quieres saber qué contiene la biblioteca principal (módulos)
dir(up)

# 3. Quieres saber qué métodos y atributos tiene la clase Problem
dir(Problem)

# 4. Quieres leer la documentación exacta de Problem y cómo inicializarla
help(Problem)

```

### 2. La herramienta `pydoc` (Directo desde la terminal)

Si no quieres entrar al entorno interactivo de Python (`>>>`) y prefieres consultarlo directamente desde la línea de comandos (Bash, PowerShell, Zsh), Python incluye una herramienta llamada `pydoc`.

Funciona exactamente igual que las páginas `man` de Linux. Solo tienes que escribir esto en tu terminal de VSCode:

```bash
# Para ver toda la documentación del módulo principal
python -m pydoc unified_planning

# Para ir directo a la clase Problem o a un submódulo específico
python -m pydoc unified_planning.model.Problem

```

_Nota: Al igual que con `help()`, navegas con las flechas y sales presionando la tecla `q`._

---

### 3. La recomendación profesional: `IPython`

Si vas a explorar bibliotecas complejas, el intérprete estándar de Python se queda un poco corto (no tiene colores y el autocompletado es básico). Te recomiendo encarecidamente instalar **IPython**, que es una terminal interactiva mejorada.

**Cómo instalarlo:**

```bash
pip install ipython

```

**Por qué es mejor para lo que pides:**
Una vez que entras escribiendo `ipython` en la terminal, tienes magia a tu disposición:

1. **Autocompletado con Tab:** Escribes `up.` y presionas la tecla `Tab`. Te desplegará un menú visual con **todos** los módulos, clases y métodos disponibles sin tener que usar `dir()`.
2. **El operador `?` (Información):** Escribes cualquier clase o método seguido de un signo de interrogación y te muestra su documentación con colores resaltados.

```python
import unified_planning as up
up.model.Problem?

```

3. **El operador `??` (Código fuente):** Si la documentación no es clara y quieres ver exactamente el código fuente en Python de cómo programaron ese método, usas dos signos.

```python
up.model.Problem.add_goal??

```

Cualquiera de estas tres opciones te permitirá hacer ingeniería inversa a la biblioteca `unified_planning` directamente desde VSCode. Te sugiero probar IPython, ya que su autocompletado con la tecla `Tab` responde perfectamente a tu necesidad de explorar qué contiene cada módulo rápidamente.
