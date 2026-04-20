# Modelado STRIPS

Los ejercicios de este documento piden se modele un problema siguiendo STRIPS. Para ello tenemos que:

- Predicados (Hechos - H): Representa las características el entorno (conjunto finito)

- Acciones (A): Conjunto finito de esquemas, que se definen por:
  - Nombre
  - Precondiciones (Hechos que deben cumplirse)
  - Lista de borrado (Hechos que dejan de cumplirse )
  - Lista de adición (Hechos que pasan a cumplirse)

- Estado Inicial (I): Hechos que se cumplen inicialmente
- Objetivo (G): Hechos que se quiere se cumplan para dar el problema por resuelto.

# Ejercicio 4

Representar en el formalismo STRIPS el problema del mono y los plátanos: un mono se encuentra en el sitio A de un laboratorio; hay una caja en el sitio C; el mono quiere los plátanos que cuelgan del techo del sitio B, pero necesita mover la caja y subirse a ella para alcanzarlos.

- Predicados
  - 1. mono_en(s)
  - 2. caja_en(s)
  - 3. mono_carga_caja(c)
  - 4. mono_encima_caja(c)
  - 5. plátanos_en(s)
  - 6. mono_come_plátanos_en(s)
- Acciones
  - 1. ir_a(s1,s2)
    - precondiciones: { mono_en(s1) }
    - lista de borrado: { mono_en(s1) }
    - Lista de adición: { mono_en(s2) }
  - 2. coger_caja(c,s1)
    - precondiciones: { mono_en(s1); caja_en(s1) }
    - lista de borrado: { }
    - Lista de adición: { mono_carga_caja(c, s1) }
  - 3. mover_caja(s1,s2)
    - precondiciones: { mono_en(s1); caja_en(s1); mono_carga_caja(c) }
    - lista de borrado: { mono_en(s1); caja_en(s1); }
    - Lista de adición: { mono_carga_caja(c); caja_en(s2); }
  - 4. mono_suelta_caja(c,s)
    - precondiciones: { mono_en(s); mono_carga_caja(c); }
    - lista de borrado: { mono_carga_caja(c); }
    - Lista de adición: { }
  - 4. subir_mono_caja(s1)
    - precondiciones: { mono_en(s1); caja_en(s1); }
    - lista de borrado: { }
    - Lista de adición: { mono_encima_caja(c) }
  - 5. coger_plátanos()
    - precondiciones: { mono_en(s); caja_en(s);mono_encima_caja(c) }
    - lista de borrado: { plátanos_en(s) }
    - Lista de adición: { mono_come_plátanos(s) }

# Ejercicio 5

# Ejercicio 6
