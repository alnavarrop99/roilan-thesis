# Diff: Introducción

## Overview

La Introducción mantiene la misma estructura y función que el documento base (pp. 1–4). Se actualiza la redacción para reflejar el alcance ampliado de la investigación (incorporación del Filtro de Kalman Adaptativo), se actualizan los objetivos específicos para incluir el método mejorado, y se reformula la hipótesis para contemplar el enfoque híbrido Exel+AKF.

---

## Changes by Section

### Introducción (documento completo)

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Modified | Objetivo específico 2: «Analizar herramientas empleadas y métodos existentes para mejorar el sincronismo» | Ampliado: «Analizar las herramientas empleadas y los métodos existentes —incluyendo técnicas novedosas basadas en filtrado de Kalman—» | Refleja la revisión sistemática de 15 métodos realizada en el Capítulo 2 |
| 2 | Modified | Objetivo específico 3: «Implementar una versión del protocolo gPTP (...) que mitigue el efecto de los retardos asimétricos» | Reformulado: «Implementar una versión mejorada del protocolo gPTP que incorpore un Filtro de Kalman Adaptativo como segunda etapa de corrección de asimetrías» | El método específico (Exel+AKF) se nombra explícitamente como contribución |
| 3 | Modified | Objetivo específico 4: «Evaluar el rendimiento de la implementación en la mejora del sincronismo a través de distintas métricas» | Reformulado: «Evaluar el rendimiento de la implementación mejorada en comparación con la implementación de referencia y el protocolo estándar» | Enfatiza la comparación con el baseline |
| 4 | Modified | Hipótesis: «si se emplea una versión adaptada del protocolo gPTP (...) entonces se logra mitigar los efectos negativos de los retardos (...) en comparación con la precisión alcanzada por el protocolo estándar» | Reformulada: «si se emplea una versión del protocolo gPTP que combine la corrección determinista de estampas de tiempo con un filtrado estadístico adaptativo, entonces se logra mitigar los efectos negativos (...) con una efectividad superior a la alcanzada por el método de corrección determinista por sí solo» | La hipótesis ahora compara Exel+AKF contra Exel (no solo contra el estándar) |
| 5 | Modified | Descripción del Capítulo 2: «se hace un análisis de los procedimientos y metodologías existentes (...) incluyendo una descripción del método seleccionado» | Ampliado: «se efectúa un análisis sistemático de 15 métodos existentes (...) organizados en siete categorías (...) y se selecciona y describe en detalle un enfoque híbrido que combina la corrección de Exel con un Filtro de Kalman Adaptativo» | Refleja el contenido real del Capítulo 2 ampliado |
| 6 | Modified | Descripción del Capítulo 3: «explica las características de la implementación que se desarrolla y las modificaciones al estándar como parte de la aplicación del método de corrección» | Actualizado: «describe las características de la implementación desarrollada en MATLAB/GNU Octave y presenta los resultados de la simulación Monte Carlo, comparando el rendimiento del método propuesto con el método de referencia Exel» | Refleja el alcance ampliado (dos implementaciones comparadas) |
| 7 | Added | — | Mención de GNU Octave como alternativa a MATLAB | Documenta el entorno de implementación dual |

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Párrafos preservados | ~60% (contexto, motivación, metodología) |
| Párrafos modificados | 4 (objetivos, hipótesis, descripción de capítulos) |
| Párrafos añadidos | 1 (mención de GNU Octave) |
| Párrafos eliminados | 0 |

---

## Validation Notes

- Los métodos científicos, la estructura general y la motivación del problema se preservan del original.
- Los cambios principales están en la formulación de la hipótesis (ahora más específica) y en la descripción del contenido de los capítulos (que refleja el trabajo efectivamente realizado).
- Todas las referencias se mantienen con su numeración original del documento base.
