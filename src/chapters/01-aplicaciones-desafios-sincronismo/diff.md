# Diff: Capítulo 1 — Aplicaciones y desafíos del sincronismo en redes inalámbricas

## Overview

Este capítulo conserva la misma estructura de seis secciones y el mismo enfoque temático que el capítulo original (pp. 5–24 del documento base). Se ha mejorado la calidad de la redacción académica, se ha reorganizado el contenido para mayor claridad, se han añadido cuatro referencias recientes (2024–2026) y se han expandido las secciones sobre desafíos (1.3) y asimetrías (1.4) con nuevos contenidos sobre integración 5G-TSN y seguridad. No se ha eliminado ninguna sección del original.

---

## Changes by Section

### 1.1 Sincronismo en redes inalámbricas

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Modified | Definición de sincronismo y tipos de relojes en prosa continua | Misma información reorganizada con subtítulos implícitos para los 4 tipos de relojes (numerados 1–4) | Mejora la legibilidad sin alterar el contenido |
| 2 | Added | — | Párrafo sobre integración TSN-5G y renovado interés en sincronización inalámbrica | Refleja desarrollos recientes (2024–2025) en el campo |
| 3 | Modified | Referencias [1]–[22] del original | Mismas referencias reordenadas para seguir el flujo narrativo | Reorganización lógica; no se añaden ni eliminan referencias base |
| 4 | Expanded | Descripción breve de sincronización unidireccional vs bidireccional | Descripción más detallada del esquema bidireccional, vinculándolo explícitamente con PTP/gPTP | Conecta los fundamentos con los protocolos que se analizan en 1.5 |

### 1.2 Aplicaciones del sincronismo en IoT

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Expanded | Lista genérica de aplicaciones | Lista estructurada con 5 categorías concretas (automatización industrial, smart grids, vehículos autónomos, SHM, audiovisual) con requisitos de precisión | Proporciona ejemplos tangibles y contextualiza los requisitos de precisión |
| 2 | Added | — | Párrafo sobre convergencia TSN-5G (3GPP Release 16+) y desafíos de sincronización en 5G | Incorpora el contexto tecnológico más reciente |
| 3 | Modified | Referencia a Industry 4.0 en prosa | Misma información pero con estructura más clara de los 4 pilares TSN | Mejora de formato, mismo contenido |

### 1.3 Desafíos del sincronismo en redes inalámbricas

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Restructured | Texto continuo sin subdivisiones | Seis subsecciones numeradas (1.3.1–1.3.6): retardos variables, deriva de osciladores, asimetrías, limitaciones de recursos, escalabilidad, seguridad | Organiza los desafíos para facilitar la lectura y referencia cruzada |
| 2 | Expanded | Descripción breve de retardos variables | Explicación detallada de causas: multitrayectoria, modulación, buffering, CSMA/CA | Mayor profundidad técnica |
| 3 | Expanded | Mención breve de osciladores | Cuantificación de deriva típica (±20–50 ppm, 100 µs/s de error acumulado) y mención del jitter de software | Aporta datos cuantitativos que fundamentan la necesidad de corrección |
| 4 | Added | — | Subsección 1.3.6 sobre seguridad en sincronización (delay box, suplantación, inyección de mensajes) | La seguridad es un área de investigación activa no cubierta en el original; relevante para trabajos futuros |

### 1.4 Asimetrías en los canales de comunicación

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Expanded | Descripción general de causas de asimetría | Cuatro categorías estructuradas: medio físico, procesamiento, tráfico de red, sistemas 5G | Mayor granularidad y claridad |
| 2 | Added | — | Categoría 4: asimetrías en sistemas 5G (uplink/downlink, asignación de recursos, potencia) | Contextualiza el problema en la tecnología inalámbrica más reciente |
| 3 | Added | — | Ecuaciones para cuantificar el error por asimetría ($t_{ms}$, $t_{sm}$, error = $\Delta/2$) | Formaliza matemáticamente el impacto de la asimetría |
| 4 | Modified | Referencia genérica a estudios experimentales | Mención explícita del orden de magnitud del error (decenas a cientos de µs en Wi-Fi) | Cuantifica el problema con datos de la literatura |

### 1.5 Protocolos de sincronismo

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Added | — | Lista de protocolos tradicionales (NTP, RBS, TPSN, FTSP) con breve descripción | Contextualiza PTP/gPTP dentro del espectro de protocolos existentes |
| 2 | Modified | Descripción de PTP | Misma información con mayor detalle: 4 mensajes del intercambio, ecuaciones de offset y delay, tipos de dispositivos (OC, BC, TC) | Mejora la completitud técnica |
| 3 | Modified | Descripción de gPTP | Misma estructura (5 características) con más detalle: medición peer-to-peer, rate ratio, ecuación de Pdelay, TransTime | Enriquece la explicación del estándar IEEE 802.1AS |
| 4 | Added | — | Párrafo sobre IEEE 802.1AS-2020 y trabajos recientes en integración TSN-5G | Actualización con el estándar más reciente y aplicaciones emergentes |
| 5 | Added | — | Referencia explícita a que gPTP es el único protocolo especificado para redes inalámbricas | Refuerza la justificación de la elección de gPTP |
| 6 | Added | — | Figura 1.1: Sincronización de reloj unidireccional y bidireccional | Ilustra los dos esquemas de sincronización descritos en el texto |
| 7 | Added | — | Figura 1.2: Fuentes de error de sincronización | Diagrama de los componentes del error: send, access, propagation y receive time |
| 8 | Added | — | Figura 1.3: Medición del retardo en gPTP (Peer Delay) | Muestra el intercambio de mensajes Pdelay_Req/Resp/FollowUp con las estampas t1–t4 |
| 9 | Added | — | Figura 1.4: Cálculo del retardo de propagación e impacto de la deriva | Dos subfiguras: (a) timeline del cálculo de Pdelay, (b) efecto del skew |
| 10 | Added | — | Tabla 1.1: Comparación de protocolos de sincronización (NTP, PTP, gPTP, GPS) | Proporciona una visión comparativa de los protocolos discutidos en la sección 1.5 |

### 1.6 Conclusiones del capítulo

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | Restructured | 2 párrafos en prosa | 5 conclusiones numeradas | Formato más adecuado para una sección de conclusiones; facilita la referencia |
| 2 | Expanded | Mención genérica de aplicaciones | Enumeración de dominios de aplicación con requisitos de precisión | Vincula las conclusiones con el contenido desarrollado en 1.2 |
| 3 | Added | — | Conclusión 5 sobre gPTP como opción más apropiada y su limitación ante asimetrías, conectando con Capítulo 2 | Sirve como transición explícita al siguiente capítulo |

---

## New References Added

| # | Citation | Reason |
|---|----------|--------|
| 1 | A. B. Muslim y R. Tönjes, «A Novel Method for gPTP-Based Time Synchronization of 5G UEs Considering Asymmetric Uplink/Downlink Latency», 2025 | Documenta el problema de asimetría en 5G y métodos de compensación para gPTP |
| 2 | S. K. Nagireddy, «Time Synchronization of Multi-Sensor Systems using Generalized Precision Time Protocol (gPTP)», 2025 | Aplicación de gPTP en fusión de sensores para plataformas autónomas |
| 3 | M. Adil et al., «Integrated 5G and Time Sensitive Networking for Emerging Applications», 2025 | Revisión exhaustiva de la integración 5G-TSN, incluyendo desafíos de sincronización |
| 4 | A. Karami y M. A. Gebremedhin, «Securing TTEthernet clock synchronization in the IIoT», 2026 | Aborda la seguridad en la sincronización de relojes en entornos industriales |

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Sections unchanged | 0 |
| Sections modified | 5 (1.1, 1.2, 1.3, 1.4, 1.5) |
| Sections added | 0 (misma estructura de 6 secciones) |
| Sections removed | 0 |
| New references added | 4 |
| References removed | 0 |
| Total references in chapter | 33 (29 del original + 4 nuevas) |
| Figuras añadidas | 4 (1.1–1.4) |
| Tablas añadidas | 1 (1.1) |

---

## Validation Notes

- La estructura de secciones (1.1–1.6) se mantiene idéntica al original.
- Todas las referencias del documento base [1]–[33] (según la numeración del nuevo capítulo) corresponden a las referencias originales verificadas en el PDF base.
- Las 4 nuevas referencias fueron obtenidas mediante búsqueda en Google Scholar con filtro 2024–2026 y las palabras clave "gPTP wireless synchronization asymmetric delay".
- Las ecuaciones (1.1) y (1.2) del nuevo capítulo corresponden a las Ecuaciones 1.1 y 1.2 del original, respectivamente.
- Las ecuaciones de offset, delay, Pdelay y TransTime se mantienen matemáticamente equivalentes a las del original, con notación consistente.
- El contenido técnico central (definición de sincronismo, tipos de relojes, funcionamiento de PTP y gPTP, cálculo de Pdelay) se ha preservado íntegramente.
