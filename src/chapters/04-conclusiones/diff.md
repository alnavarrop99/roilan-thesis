# Diff: Conclusiones

## Overview

Las Conclusiones del documento base (p. 53) contenían 4 conclusiones en formato de párrafos. La nueva versión mantiene el contenido esencial pero lo reorganiza en 8 conclusiones numeradas, añade las contribuciones específicas del método híbrido Exel+AKF, e incluye una sección de limitaciones.

---

## Changes by Section

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Restructured | 4 párrafos en prosa | 8 conclusiones numeradas | Formato estándar para tesis |
| 2 | Preserved | Conclusión 1 (original): el sincronismo es fundamental, gPTP es el más apropiado | Conclusión 1 (nueva): revisión del estado del arte confirmando gPTP como protocolo adecuado | Contenido equivalente, redacción mejorada |
| 3 | Preserved | Conclusión 2 (original): análisis de métodos, selección de Exel, MATLAB como herramienta | Conclusión 2 (nueva): análisis sistemático de 15 métodos en 7 categorías con matriz de comparación | Ampliado con detalles de la revisión sistemática |
| 4 | Added | — | Conclusión 3: selección del método híbrido Exel+AKF con arquitectura de dos etapas | Documenta la nueva contribución metodológica |
| 5 | Added | — | Conclusión 4: implementación del simulador gPTP en MATLAB/GNU Octave (5 módulos) | Documenta el desarrollo de software |
| 6 | Preserved | Conclusión 3 (original): 50.7 µs de mejora (33.31%), 101.5 µs de precisión, 14.78 µs std | Conclusión 5 (nueva): mismos datos del baseline Exel | Validación experimental preservada |
| 7 | Added | — | Conclusión 6: proyección del método Exel+AKF (72.3 µs, 52.5% mejora total) | Presenta los resultados proyectados del nuevo método |
| 8 | Added | — | Conclusión 7: contribución metodológica (arquitectura de dos etapas) | Resalta la contribución original |
| 9 | Added | — | Conclusión 8: limitaciones (naturaleza proyectada, ruido Gaussiano, un solo salto) | Transparencia metodológica requerida en trabajos académicos |
| 10 | Removed | Conclusión 4 (original): variación de offset (1.265 µs media) y overhead (~3%) | Integrado en Conclusión 5 | Información no eliminada, solo reorganizada |

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Conclusiones preservadas | 3 (sincronismo/gPTP, baseline Exel, overhead) |
| Conclusiones añadidas | 5 (método híbrido, implementación, proyección, contribución, limitaciones) |
| Conclusiones eliminadas | 0 (contenido reorganizado, no eliminado) |
| Total conclusiones | 8 (vs. 4 en original) |

---

## Validation Notes

- Todos los datos numéricos del baseline (50.7 µs, 33.31%, 101.5 µs, 14.78 µs, overhead 3.65%) se preservan sin modificación.
- Las nuevas conclusiones sobre el método AKF están respaldadas por las referencias de la Fase 2 y las proyecciones del Capítulo 3.
- La inclusión de una sección de limitaciones es una mejora metodológica respecto al original.
