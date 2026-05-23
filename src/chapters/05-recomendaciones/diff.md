# Diff: Recomendaciones

## Overview

Las Recomendaciones del documento base (p. 54) contenían 3 recomendaciones breves. La nueva versión las expande a 10 recomendaciones detalladas, cubriendo validación experimental, implementación en dispositivos reales, extensiones metodológicas y buenas prácticas de reproducibilidad.

---

## Changes by Section

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Preserved | Rec. 1: «Aplicar la implementación desarrollada en dispositivos reales para evaluar su comportamiento en la práctica» | Rec. 2: «Aplicar la implementación en plataformas inalámbricas reales (Wi-Fi, LoRa) para evaluar el comportamiento en condiciones de canal reales» | Misma esencia, más específica en tecnologías |
| 2 | Preserved | Rec. 2: «Emplear en futuras implementaciones hardware especializado en el estampado de tiempo» | Rec. 3: «Emplear hardware especializado de estampado según IEEE 802.1AS, combinado con el método híbrido Exel+AKF» | Misma esencia, vinculada al nuevo método |
| 3 | Preserved | Rec. 3: «Evaluar la implementación en redes con varios dispositivos (de ser posible utilizar BMCA)» | Rec. 4: «Evaluar la implementación en redes con múltiples dispositivos y saltos, incorporando el BMCA» | Misma esencia, más detallada |
| 4 | Added | — | Rec. 1: validación experimental del método mejorado en MATLAB/Octave | Prioridad inmediata: ejecutar la simulación pendiente |
| 5 | Added | — | Rec. 5: explorar EKF, UKF y Filtros de Partículas para no linealidades y distribuciones no Gaussianas | Extensión natural del método propuesto |
| 6 | Added | — | Rec. 6: aprendizaje automático para predicción de asimetría desde métricas de capa física | Dirección de investigación novedosa |
| 7 | Added | — | Rec. 7: integración con 5G-TSN | Contexto tecnológico emergente |
| 8 | Added | — | Rec. 8: seguridad en la sincronización (detección de ataques mediante AKF) | Área de investigación activa no cubierta en el original |
| 9 | Added | — | Rec. 9: análisis de sensibilidad y optimización multiobjetivo del AKF | Metodología para trabajos futuros inmediatos |
| 10 | Added | — | Rec. 10: publicación del código en repositorio abierto para reproducibilidad | Buena práctica científica |

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Recomendaciones preservadas | 3 (dispositivos reales, hardware timestamping, BMCA) |
| Recomendaciones añadidas | 7 |
| Recomendaciones eliminadas | 0 |
| Total recomendaciones | 10 (vs. 3 en original) |

---

## Validation Notes

- Las 3 recomendaciones del original se preservan (actualizadas en redacción y contexto).
- Las 7 nuevas recomendaciones cubren: validación inmediata (Rec. 1), extensiones metodológicas (Rec. 5–6), contextos de aplicación emergentes (Rec. 7), seguridad (Rec. 8), optimización (Rec. 9), y reproducibilidad (Rec. 10).
- Todas las nuevas recomendaciones están respaldadas por referencias o hallazgos de los capítulos anteriores.
