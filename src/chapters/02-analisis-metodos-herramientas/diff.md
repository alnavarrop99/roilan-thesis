# Diff: Capítulo 2 — Análisis de métodos y herramientas para mejorar el sincronismo en redes inalámbricas empleando el protocolo gPTP

## Overview

Este capítulo mantiene la misma estructura de cinco secciones que el original (pp. 25–41 del documento base), pero con transformaciones sustanciales en las secciones 2.2, 2.3 y 2.4. La sección 2.2 se expande de un análisis informal de ~6 métodos a una revisión sistemática de 15 métodos organizados en 7 categorías con tabla comparativa. La sección 2.3 se reemplaza completamente: de describir únicamente el método Exel a presentar un enfoque híbrido Exel + Filtro de Kalman Adaptativo con modelo de espacio de estados completo. La sección 2.4 se actualiza para incluir GNU Octave como alternativa a MATLAB. Las secciones 2.1 y 2.5 se preservan con modificaciones menores de redacción y actualización de referencias.

---

## Changes by Section

### 2.1 Sistemas de estampado por Software

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Modified | Descripción general de fuentes de incertidumbre | Misma información reorganizada con formato de lista para las 4 fuentes de imprecisión | Mejora la legibilidad |
| 2 | Modified | Referencias [53]–[57] del original | Mismas referencias con formato actualizado y algunas renumeradas | Reorganización lógica |
| 3 | Added | — | Mención explícita del esquema basado en interrupciones (ISR) y sus fuentes de retardo | Mayor detalle técnico sobre el mecanismo de estampado |

### 2.2 Análisis de los modelos, metodologías y procedimientos existentes

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Restructured | ~6 métodos descritos en prosa continua sin organización temática | 7 subsecciones (2.2.1–2.2.7) organizadas por categoría metodológica | Facilita la comparación sistemática y la navegación |
| 2 | Expanded | Método Exel descrito en §2.3 | Método Exel ahora en §2.2.1 como baseline, con resultados cuantitativos de la implementación de referencia | Posiciona Exel como punto de partida para la comparación |
| 3 | Added | — | §2.2.2: 5 métodos basados en Filtro de Kalman (Li2024, Hollósi2024, Liu2024, Wang2021, Raittila2025) | Revisión sistemática de la categoría más prometedora |
| 4 | Added | — | §2.2.3: 2 métodos de Estimación Robusta (Karthik2020, Vázquez2025) | Cubre enfoques alternativos con fundamento teórico riguroso |
| 5 | Added | — | §2.2.4: 2 métodos de Lógica Difusa (Nguyen2020, Zhang2024) | Cubre enfoques heurísticos relevantes |
| 6 | Added | — | §2.2.5: 2 métodos de Aprendizaje Computacional (Wang2026, Goodarzi2022) | Cubre los enfoques más recientes basados en ML |
| 7 | Added | — | §2.2.6: 3 métodos adicionales (PTP-LP, PDD, PPAM) preservados del original | Mantiene los métodos del análisis original |
| 8 | Added | — | §2.2.7: Tabla 2.2 comparativa con 10 métodos evaluados en 5 criterios | Herramienta de decisión transparente y reproducible |
| 9 | Modified | Métodos del original descritos sin datos de precisión cuantitativos | Cada método incluye precisión reportada, complejidad y compatibilidad | Permite comparación objetiva entre métodos |

### 2.3 Descripción del método seleccionado

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Replaced | Descripción del método Exel: corrección determinista con $p_1$–$p_4$, Ecuaciones (2.3)–(2.8) | Enfoque híbrido Exel + AKF con arquitectura de dos etapas | El método Exel por sí solo no alcanza los objetivos de mejora; el enfoque híbrido combina sus fortalezas con filtrado adaptativo |
| 2 | Added | — | §2.3.1: Arquitectura de dos etapas (Exel determinista → AKF estadístico) | Define claramente la interacción entre ambos componentes |
| 3 | Added | — | §2.3.2: Modelo de espacio de estados completo: vector $\mathbf{x}_k = [\theta_k, s_k, \Delta_k]^T$, matrices $\mathbf{F}$ y $\mathbf{H}$ | Proporciona el fundamento matemático riguroso del método propuesto |
| 4 | Added | — | §2.3.3: Algoritmo AKF: ecuaciones de predicción, actualización y adaptación de $R_k$ | Detalla la implementación computacional del filtro |
| 5 | Added | — | §2.3.4: Tabla de parámetros de diseño con métodos de determinación | Guía la fase de implementación (Capítulo 3) |
| 6 | Added | — | §2.3.5: Seis ventajas del enfoque híbrido | Justifica la selección frente a alternativas |

### 2.4 Herramientas de implementación

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Expanded | Descripción de MATLAB exclusivamente | Añadida descripción de GNU Octave como alternativa de código abierto | Relevante para la implementación práctica sin licencia MATLAB |
| 2 | Modified | §2.4.1 Archivos-M | Misma información con mención de compatibilidad MATLAB/Octave | Actualización para reflejar el entorno dual |
| 3 | Modified | §2.4.2 Graficado en 2-D | Añadida nota sobre compatibilidad de gráficos en Octave | Verificación de portabilidad |
| 4 | Modified | §2.4.3 Ventajas y desventajas | Añadida la ventaja de Octave (gratuito) como mitigación del costo de MATLAB | Contextualiza la elección de herramientas |

### 2.5 Conclusiones del capítulo

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Restructured | 2 párrafos en prosa | 6 conclusiones numeradas | Formato estándar para sección de conclusiones |
| 2 | Replaced | Conclusión centrada en Exel como método seleccionado | Conclusión centrada en el enfoque híbrido Exel+AKF | Refleja el cambio fundamental del capítulo |
| 3 | Added | — | Conclusión 4: descripción del diseño híbrido de dos etapas | Resume la contribución central del capítulo |
| 4 | Added | — | Conclusión 6: parámetros a determinar experimentalmente | Conecta con el Capítulo 3 |

---

## New References Added

| # | Citation | Reason |
|---|----------|--------|
| 1 | Q. Li et al., «An enhanced time synchronization method… based on Kalman filtering», Scientific Reports, 2024 | KF de segundo orden para sincronización PTP |
| 2 | G. Hollósi y D. Ficzere, «Adaptive Kalman filtering in offset estimation for PTP», IEEE Trans. Ind. Inform., 2024 | AKF con estimación adaptativa de $R_k$ |
| 3 | X. Liu y H. Wang, «Robust clock parameters tracking for IEEE 1588…», IEEE Trans. Commun., 2024 | KF robusto para retardos asimétricos |
| 4 | H. Wang et al., «Timestamp-free clock parameters tracking using EKF…», IEEE Trans., 2021 | EKF sin marcas de tiempo para WSN |
| 5 | S. Raittila, «Adaptive Control in PTP… AKF-Based Approach for Wi-Fi», Master's thesis, 2025 | AKF en Simulink para Wi-Fi |
| 6 | V. Vázquez et al., «PTP over WAN with offset measurement outlier filtering», 2025 | Filtrado de outliers en mediciones PTP |
| 7 | V. Q. Nguyen et al., «Adaptive fuzzy-PI clock servo based on IEEE 1588», IEEE Access, 2020 | Servo Fuzzy-PI adaptativo |
| 8 | H. Wang et al., «Competitive Learning-Based Clock Parameters Estimation…», IEEE Trans., 2026 | Aprendizaje competitivo para PTP |
| 9 | M. Goodarzi et al., «DNN-assisted particle-based Bayesian joint sync and localization», IEEE Trans., 2022 | Filtro de partículas con DNN |
| 10 | J. W. Eaton et al., «GNU Octave manual», 2024 | Documentación de referencia para Octave |

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Sections unchanged | 0 |
| Sections modified | 5 (todas) |
| Secciones del original eliminadas | 0 (contenido redistribuido) |
| Subsecciones nuevas añadidas | 8 (2.2.1–2.2.7, 2.3.1–2.3.5 dentro de 2.3) |
| Métodos analizados (original) | ~6 |
| Métodos analizados (nuevo) | 15 |
| Nuevas referencias añadidas | 10 |
| Referencias eliminadas | 0 |

---

## Validation Notes

- Las Ecuaciones (2.1)–(2.6) del nuevo capítulo (método Exel) corresponden a las Ecuaciones 2.3–2.8 del original. La renumeración se debe a la nueva organización.
- Las ecuaciones del AKF (§2.3.2–2.3.3) son nuevas y no tienen equivalente en el original.
- Todas las referencias del documento base que describían métodos en §2.2 se preservan en §2.2.6 o se redistribuyen en las nuevas subcategorías.
- La Tabla 2.2 (comparación de métodos) es nueva y sintetiza los hallazgos de la Fase 2 de investigación.
- La inclusión de GNU Octave como alternativa a MATLAB es una adición pragmática que no altera el contenido técnico.
