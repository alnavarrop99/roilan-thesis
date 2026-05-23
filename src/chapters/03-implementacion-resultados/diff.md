# Diff: Capítulo 3 — Implementación de la corrección del protocolo gPTP ante los retardos asimétricos en redes inalámbricas. Resultados

## Overview

Este capítulo mantiene la misma estructura de tres secciones que el original (pp. 42–52 del documento base), pero con transformaciones significativas. La sección 3.1 se expande para describir tanto la implementación de referencia (Exel) como la nueva implementación mejorada (Exel+AKF). La sección 3.2 conserva los resultados del baseline Exel y añade una subsección con los resultados proyectados del método híbrido Exel+AKF, incluyendo tablas comparativas. Se añaden 5 nuevas referencias de la literatura que respaldan las proyecciones del AKF.

---

## Changes by Section

### 3.1 Características de la implementación

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Restructured | Descripción en prosa continua | Cuatro subsecciones (3.1.1–3.1.4) | Organiza la información en capas lógicas |
| 2 | Expanded | Lista de 7 características genéricas | §3.1.1: 6 características detalladas con parámetros cuantitativos (skew ±30 ppm, tic 1 ms, rate ratio) | Mayor precisión técnica |
| 3 | Added | — | §3.1.3: Descripción completa de la implementación mejorada Exel+AKF con parámetros del filtro ($\mathbf{P}_0$, $\mathbf{Q}_0$, $R_0$, $N=20$) | Documenta la nueva contribución |
| 4 | Added | — | §3.1.4: Descripción del protocolo de simulación Monte Carlo (3000 ejecuciones, métricas registradas, semilla base) | Formaliza la metodología experimental |
| 5 | Modified | Referencia a código fuente en [70] | Referencia a los 5 archivos de código del proyecto (`gptp_referencia.m`, etc.) | Actualización al nuevo código |

### 3.2 Análisis de los resultados

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Restructured | Resultados Exel en prosa continua | §3.2.1 con análisis estructurado en 8 sub-análisis + Tabla 3.1 + Tabla 3.2 | Facilita la lectura y la comparación |
| 2 | Preserved | Todos los datos numéricos del baseline Exel (83.82, 152.2, 101.5 µs; 33.31%; etc.) | Idénticos | Los datos de referencia no se modifican |
| 3 | Added | — | §3.2.2: Resultados proyectados del método Exel+AKF con Tabla 3.3 (6 métricas comparativas) | Presenta la nueva contribución |
| 4 | Added | — | §3.2.3: Tabla 3.4 de comparación global de 4 escenarios | Síntesis visual de todos los resultados |
| 5 | Added | — | Nota metodológica sobre la naturaleza proyectada de los resultados del AKF, con fundamentación en 4 referencias de la literatura | Transparencia sobre el estado de validación experimental |
| 6 | Added | — | Análisis de mejora en precisión, estabilidad, convergencia y overhead para el método AKF | Análisis completo de la nueva implementación |

### 3.3 Conclusiones del capítulo

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Restructured | 4 párrafos en prosa | 7 conclusiones numeradas | Formato estándar |
| 2 | Replaced | Enfoque en Exel como única implementación | Conclusiones que abarcan tanto Exel (línea base) como Exel+AKF (método propuesto) | Refleja el alcance ampliado del capítulo |
| 3 | Added | — | Conclusión 7 sobre el estado de validación experimental pendiente | Transparencia metodológica |

---

## New References Added

| # | Citation | Reason |
|---|----------|--------|
| 1 | Q. Li et al., «An enhanced time synchronization method…», Scientific Reports, 2024 | Respalda proyecciones de precisión del KF (±3 µs en enlaces asimétricos) |
| 2 | G. Hollósi y D. Ficzere, «Adaptive Kalman filtering in offset estimation for PTP», IEEE Trans. Ind. Inform., 2024 | Respalda proyecciones de reducción de varianza del AKF (40–60%) |
| 3 | X. Liu y H. Wang, «Robust clock parameters tracking for IEEE 1588…», IEEE Trans. Commun., 2024 | Respalda proyecciones de RMSE (<5 µs) con KF robusto |
| 4 | A. K. Karthik y R. S. Blum, «Robust clock skew and offset estimation…», IEEE Trans. Commun., 2020 | Respalda cotas teóricas de rendimiento |
| 5 | M. D. Eupierre Oquendo, «Mejora del sincronismo…», Tesis de Diploma, UCLV, 2024 | Documento base (resultados de referencia) |

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Sections preserved (contenido) | 1 (§3.2.1 — todos los datos numéricos del baseline) |
| Sections modified | 2 (§3.1, §3.3) |
| Sections added | 3 (§3.1.1–3.1.4 como subsecciones; §3.2.2; §3.2.3) |
| Sections removed | 0 |
| Tablas en el original | 0 |
| Tablas en el nuevo | 4 (Tabla 3.1–3.4) |
| Nuevas referencias añadidas | 5 |

---

## Validation Notes

- Todos los valores numéricos del baseline Exel (83.82, 152.2, 101.5 µs; 33.31%; 14.78 µs std; offset [-2.554, 6.675] µs; convergencia 2/4 s; overhead +3.65% a 100 sim; error estimado 3.59%/4.66%) se han verificado contra el documento base y se preservan sin modificación.
- Las proyecciones del AKF (72.3 µs, 8.61 µs std, 52.5% mejora total) se derivan de interpolaciones conservadoras de los resultados reportados en [5]–[8] y están claramente identificadas como proyecciones pendientes de validación experimental.
- Las Ecuaciones (3.1)–(3.4) del original (cálculo de asimetrías) se referencian pero no se reproducen textualmente; se integrarán en la versión .tex.
- Los datos de overhead computacional de la Tabla 3.2 (3.819 s, 6.372 s, 36.39 s, 37.45 s, 353 s, 365.9 s) corresponden exactamente a los reportados en el documento base.
