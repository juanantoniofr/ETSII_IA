# ETSII_IA

Repositorio de prácticas y materiales de la asignatura de **Inteligencia Artificial (ETSII)**.
Contiene notebooks y recursos para el desarrollo de ejercicios y prácticas en entorno Python.

---

# Requisitos previos

## 1. Instalar Python

Se requiere **Python 3.8 o superior**.

Descarga oficial:

[https://www.python.org/downloads/](https://www.python.org/downloads/)

Durante la instalación en Windows, asegúrate de marcar la opción:

Add Python to PATH

Comprobar instalación:

```
python --version
```

o

```
python3 --version
```

---

# Configuración del entorno de desarrollo

Se recomienda trabajar con un entorno virtual aislado utilizando `venv`.

---

## 2. Clonar el repositorio

```
git clone https://github.com/juanantoniofr/ETSII_IA.git
cd ETSII_IA
```

---

## 2.1 Crear un entorno virtual con venv

```
python -m venv .venv
```

o

```
python3 -m venv .venv
```

---

## 2.2 Activar el entorno virtual

### macOS / Linux

```
source .venv/bin/activate
```

### Windows (PowerShell)

```
.\.venv\Scripts\Activate.ps1
```

Si aparece error de política de ejecución:

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 2.3 Actualizar pip

```
pip install --upgrade pip
```

---

## 2.4 Instalar Jupyter Lab

```
pip install jupyterlab
```

---

## 2.5 Configurar el kernel de Jupyter

Instalar ipykernel:

```
pip install ipykernel
```

Registrar el entorno como kernel:

```
python -m ipykernel install --user --name etsii_ia --display-name "Python (ETSII_IA)"
```

---

# Ejecutar Jupyter Lab

```
jupyter lab
```

Seleccionar el kernel:

Python (ETSII_IA)

---

# Ejemplo de estructura del repositorio

```
ETSII_IA/
│── laboratorio/
│     └── Practica_0/
│         └── notebooks .ipynb
├── .gitignore
└── README.md
```

---

# Buenas prácticas

Generar fichero de dependencias:

```
pip freeze > requirements.txt
```

Reinstalar dependencias:

```
pip install -r requirements.txt
```
