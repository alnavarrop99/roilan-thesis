# Phase 2: Investigación de Métodos Novedosos — Resultados y Selección

## 1. Resumen de la búsqueda sistemática

Se realizó una búsqueda sistemática en Google Scholar (2020–2026) cubriendo siete categorías de técnicas avanzadas para la compensación de retardos asimétricos en protocolos de sincronización PTP/gPTP. Se identificaron y analizaron 15 artículos relevantes.

---

## 2. Matriz de comparación de métodos

### 2.1 Métodos basados en Filtro de Kalman

| # | Referencia | Técnica | Precisión reportada | Complejidad | Compatibilidad gPTP | Citas |
|---|-----------|---------|-------------------|-------------|-------------------|-------|
| K1 | Li et al. (2024) | KF de segundo orden para offset, drift y parámetros de reloj | ±3 µs offset máximo en enlaces asimétricos | Media | Alta — compatible con PTP/gPTP | 16 |
| K2 | Hollósi & Ficzere (2024) | AKF para estimación de ruido de medición en tiempo real | Reduce varianza del offset en 40–60% vs. KF estándar | Media-Alta | Alta — diseñado para IEEE 1588 | 14 |
| K3 | Liu & Wang (2024) | KF robusto de tres pasos con rechazo de outliers | RMSE de offset < 5 µs en presencia de asimetrías | Media-Alta | Alta — específico para IEEE 1588 con retardos asimétricos | 12 |
| K4 | Wang et al. (2021) | EKF sin marcas de tiempo (timestamp-free) | Error de estimación < 1 µs en WSN simuladas | Media | Media — diseñado para WSN, adaptable a gPTP | 49 |
| K5 | Raittila (2025) | AKF en Simulink para Wi-Fi PTP | Resultados preliminares (tesis de maestría) | Baja-Media | Alta — específico para Wi-Fi + PTP | 0 |

### 2.2 Métodos basados en Estimación Robusta

| # | Referencia | Técnica | Precisión reportada | Complejidad | Compatibilidad gPTP | Citas |
|---|-----------|---------|-------------------|-------------|-------------------|-------|
| R1 | Karthik & Blum (2020) | Estimación robusta de skew/offset ante asimetrías deterministas desconocidas | Cotas inferiores de rendimiento; supera MLE en presencia de asimetrías | Alta | Alta — IEEE 1588 | 61 |
| R2 | Vázquez et al. (2025) | Filtrado de outliers en mediciones de offset PTP | Mejora precisión en WAN con outliers | Baja-Media | Alta — PTP | 0 |

### 2.3 Métodos basados en Lógica Difusa

| # | Referencia | Técnica | Precisión reportada | Complejidad | Compatibilidad gPTP | Citas |
|---|-----------|---------|-------------------|-------------|-------------------|-------|
| F1 | Nguyen et al. (2020) | Servo de reloj Fuzzy-PI adaptativo | Precisión < 100 ns en Ethernet; mejora 45% vs. PI tradicional | Media | Media — requiere ajuste de reglas difusas | 24 |
| F2 | Zhang et al. (2024) | Fuzzy-PI con filtro de ventana para compensar asimetría de cola (QIDA) | Reducción del 52% en error de offset por asimetría de cola | Media-Alta | Media — enfocado en redes cableadas | 1 |

### 2.4 Métodos basados en Aprendizaje Automático / Competitivo

| # | Referencia | Técnica | Precisión reportada | Complejidad | Compatibilidad gPTP | Citas |
|---|-----------|---------|-------------------|-------------|-------------------|-------|
| M1 | Wang et al. (2026) | Competitive Learning para estimación de parámetros con distribuciones de retardo desconocidas | Robusto ante múltiples distribuciones de retardo | Alta | Media-Alta — PTP, adaptable a gPTP | 0 |

### 2.5 Métodos basados en Filtros de Partículas / SMC

| # | Referencia | Técnica | Precisión reportada | Complejidad | Compatibilidad gPTP | Citas |
|---|-----------|---------|-------------------|-------------|-------------------|-------|
| P1 | Goodarzi et al. (2022) | Filtro de partículas asistido por DNN para sincronización y localización conjunta | Alta precisión en entornos no Gaussianos | Muy Alta | Baja — requiere DNN + SMC, costo computacional prohibitivo | 9 |

### 2.6 Métodos basados en Programación Lineal

| # | Referencia | Técnica | Precisión reportada | Complejidad | Compatibilidad gPTP | Citas |
|---|-----------|---------|-------------------|-------------|-------------------|-------|
| L1 | Puttnies et al. (2018) | PTP-LP: Programación Lineal para robustez de retardos | Mejora la robustez ante variaciones de retardo | Media-Alta | Media — optimización fuera de línea | 8 |

### 2.7 Método de Referencia (Base)

| # | Referencia | Técnica | Precisión reportada | Complejidad | Compatibilidad gPTP | Citas |
|---|-----------|---------|-------------------|-------------|-------------------|-------|
| B1 | Exel (2014) | Corrección determinista de estampas de tiempo usando retardos de procesamiento conocidos (p1–p4) | 101.5 µs de precisión media; 33.31% de mejora | Baja | Alta — implementado en gPTP | 120+ |

---

## 3. Evaluación crítica de cada método

### 3.1 Filtro de Kalman (K1–K5)

**Fortalezas:**
- Marco teórico sólido y ampliamente validado (más de 40 años de desarrollo)
- Capacidad de estimación conjunta de offset, skew y parámetros de asimetría
- Funcionamiento en tiempo real con bajo costo computacional por iteración
- Extensa literatura de aplicación a PTP/IEEE 1588
- El KF de segundo orden (K1) y el AKF (K2) son directamente implementables en MATLAB/Octave

**Debilidades:**
- Asume ruido Gaussiano; las distribuciones de retardo en canales inalámbricos pueden ser multimodales o de cola pesada
- Requiere ajuste cuidadoso de las matrices de covarianza de ruido (Q y R)
- El AKF (K2) añade complejidad adaptativa pero puede diverger si no se configura adecuadamente

**Aplicabilidad al proyecto:** **ALTA**. El KF es el método con mayor respaldo en la literatura para este problema específico. Su complejidad computacional es manejable en MATLAB/Octave y los resultados reportados sugieren una mejora sustancial sobre el método Exel.

### 3.2 Estimación Robusta (R1–R2)

**Fortalezas:**
- R1 (Karthik & Blum) ofrece cotas teóricas de rendimiento que permiten cuantificar la mejora máxima alcanzable
- Robusto ante desviaciones del modelo Gaussiano
- Fundamentación matemática rigurosa

**Debilidades:**
- Complejidad matemática elevada (derivación de cotas de Cramér-Rao modificadas)
- Implementación más compleja que el KF
- R2 es específico para redes WAN, no inalámbricas de corto alcance

**Aplicabilidad al proyecto:** **MEDIA**. La robustez es deseable, pero la complejidad de implementación es alta. Podría incorporarse como una extensión futura del KF.

### 3.3 Lógica Difusa (F1–F2)

**Fortalezas:**
- No requiere modelo matemático preciso del sistema
- Robusto ante no linealidades e incertidumbres
- F2 aborda específicamente la asimetría inducida por colas (QIDA)

**Debilidades:**
- El diseño de reglas difusas es heurístico y depende de la experiencia del diseñador
- Difícil de garantizar optimalidad
- F2 está enfocado en redes cableadas con switches

**Aplicabilidad al proyecto:** **MEDIA-BAJA**. Aunque es técnicamente viable, la naturaleza heurística del diseño difuso dificulta la comparación objetiva y la reproducibilidad. La base teórica es menos rigurosa que el KF.

### 3.4 Aprendizaje Competitivo (M1)

**Fortalezas:**
- No asume ninguna distribución de retardo conocida
- Robusto ante múltiples fuentes de asimetría
- Enfoque novedoso (2026)

**Debilidades:**
- Complejidad computacional alta
- Requiere fase de entrenamiento con datos históricos
- Menos validado experimentalmente (artículo muy reciente)

**Aplicabilidad al proyecto:** **BAJA**. La complejidad y la falta de madurez del método lo hacen inadecuado para una implementación confiable en el alcance de esta tesis.

### 3.5 Filtros de Partículas (P1)

**Fortalezas:**
- Maneja distribuciones no Gaussianas y multimodales
- Teóricamente óptimo para cualquier distribución de retardo

**Debilidades:**
- Costo computacional muy elevado (cientos o miles de partículas)
- Requiere DNN adicional en P1, aumentando aún más la complejidad
- Difficultad de implementación en MATLAB/Octave para simulación Monte Carlo de 3000+ ejecuciones

**Aplicabilidad al proyecto:** **MUY BAJA**. El costo computacional es prohibitivo para el alcance de esta tesis, especialmente considerando la necesidad de simulaciones Monte Carlo extensivas.

---

## 4. Método seleccionado: Filtro de Kalman Adaptativo Híbrido (Exel + AKF)

### 4.1 Justificación de la selección

Tras evaluar las 7 categorías y 15 referencias, se selecciona un **enfoque híbrido que combina la corrección determinista de Exel con un Filtro de Kalman Adaptativo (AKF)**. Esta decisión se fundamenta en los siguientes criterios:

| Criterio | Evaluación |
|----------|-----------|
| **Mejora potencial sobre el baseline** | Alta — el KF puede reducir el error en 40–60% adicional sobre Exel |
| **Compatibilidad con gPTP** | Alta — el AKF opera sobre las mismas marcas de tiempo que Exel |
| **Implementabilidad en MATLAB/Octave** | Alta — el KF se implementa con operaciones matriciales estándar |
| **Rigor teórico** | Alto — amplia literatura y fundamentación matemática |
| **Complejidad computacional** | Media — compatible con simulación Monte Carlo de 3000+ ejecuciones |
| **Novedad** | Media-Alta — la combinación específica Exel+AKF para gPTP no está documentada en la literatura revisada |
| **Reproducibilidad** | Alta — el KF es determinista y sus parámetros son trazables |

### 4.2 Descripción del método propuesto

El método híbrido opera en dos etapas:

**Etapa 1 — Corrección determinista (Exel):**
- Se aplica la corrección de Exel a las marcas de tiempo $t_1, t_2, t_3, t_4$
- Se utiliza el modelo de retardos de procesamiento asimétricos $p_1, p_2, p_3, p_4$
- Se obtiene una primera estimación del offset $\hat{\theta}_{Exel}$

**Etapa 2 — Filtro de Kalman Adaptativo:**
- El vector de estado incluye: offset ($\theta_k$), skew ($s_k$), y asimetría residual ($\Delta_k$)
- Modelo de transición de estado:
  $$\mathbf{x}_{k+1} = \mathbf{F} \mathbf{x}_k + \mathbf{w}_k$$
  donde $\mathbf{x}_k = [\theta_k, s_k, \Delta_k]^T$ y $\mathbf{w}_k \sim \mathcal{N}(0, \mathbf{Q}_k)$

- Modelo de medición:
  $$z_k = \theta_k + \Delta_k/2 + v_k$$
  donde $z_k$ es la medición de offset corregida por Exel y $v_k \sim \mathcal{N}(0, R_k)$

- Adaptación de $R_k$: se estima la varianza del ruido de medición en tiempo real usando una ventana deslizante de las últimas $N$ mediciones:
  $$\hat{R}_k = \frac{1}{N-1} \sum_{i=k-N+1}^{k} (z_i - \hat{z}_i)^2$$

- El AKF produce estimaciones filtradas del offset $\hat{\theta}_k$ que combinan la corrección determinista de Exel con el filtrado estadístico óptimo del KF.

### 4.3 Ventajas del enfoque híbrido

1. **Herencia de Exel**: se preserva la corrección determinista que ya demostró una mejora del 33.31%, proporcionando una base sólida.
2. **Filtrado adaptativo**: el AKF reduce la varianza residual y se adapta a cambios en las condiciones del canal.
3. **Estimación de asimetría residual**: el KF estima la componente de asimetría que Exel no puede corregir (asimetrías desconocidas/no modeladas).
4. **Comparabilidad**: permite comparar directamente Exel vs. Exel+AKF bajo condiciones idénticas.
5. **Extensibilidad**: el marco del KF permite incorporar futuras mejoras (EKF, UKF) sin cambiar la arquitectura.

---

## 5. Plan de implementación

### 5.1 Arquitectura del código MATLAB/Octave

```
gptp_referencia.m       — gPTP estándar + corrección Exel (replicación del baseline)
gptp_mejorado.m         — gPTP + Exel + AKF híbrido (método propuesto)
gptp_montecarlo.m       — Motor de simulación Monte Carlo común
kalman_filter.m         — Implementación del AKF (funciones auxiliares)
plot_resultados.m       — Visualización comparativa
```

### 5.2 Parámetros del AKF a determinar experimentalmente

- $N$: tamaño de la ventana deslizante para adaptación de $R_k$
- $\mathbf{Q}_0$: covarianza inicial del ruido de proceso
- $\mathbf{P}_0$: covarianza inicial del error de estimación
- $\mathbf{x}_0$: estado inicial $[\theta_0, s_0, \Delta_0]^T$

### 5.3 Métricas de evaluación

| Métrica | Baseline (Exel) | Objetivo (Exel+AKF) |
|---------|----------------|-------------------|
| Precisión media | 101.5 µs | < 70 µs |
| Desviación estándar | 14.78 µs | < 10 µs |
| Reducción del error vs. asimétrico sin corregir | 33.31% | > 50% |
| Rango de offset estabilizado | [-2.55, 6.68] µs | Más estrecho que baseline |
| Tiempo de convergencia | ~4 s | ≤ 4 s |
| Overhead computacional | +67% (1 sim.) → +3.65% (100 sim.) | < +10% sobre Exel |

---

## Referencias de la Fase 2

1. Q. Li et al., "An enhanced time synchronization method for a network based on Kalman filtering," *Scientific Reports*, 2024.
2. G. Hollósi and D. Ficzere, "Adaptive Kalman filtering in offset estimation for precision time protocol," *IEEE Trans. Ind. Inform.*, 2024.
3. X. Liu and H. Wang, "Robust clock parameters tracking for IEEE 1588 with asymmetric packet delays in industrial networks," *IEEE Trans. Commun.*, 2024.
4. H. Wang et al., "Timestamp-free clock parameters tracking using extended Kalman filtering in wireless sensor networks," *IEEE Trans.*, 2021.
5. S. Raittila, "Adaptive Control in the Precision Time Protocol for Industrial Applications," Master's thesis, 2025.
6. A. K. Karthik and R. S. Blum, "Robust clock skew and offset estimation for IEEE 1588," *IEEE Trans. Commun.*, 2020.
7. V. Vázquez et al., "PTP over wide area networks with offset measurement outlier filtering," *IEEE*, 2025.
8. V. Q. Nguyen et al., "An adaptive fuzzy-PI clock servo based on IEEE 1588," *IEEE Access*, 2020.
9. Y. Zhang et al., "A Fuzzy-PI Clock Servo with Window Filter for Compensating Queue-Induced Delay Asymmetry in IEEE 1588 Networks," *Sensors*, 2024.
10. H. Wang et al., "Competitive Learning-Based Clock Parameters Estimation for PTP Synchronization With Unknown Delay Distributions," *IEEE Trans.*, 2026.
11. M. Goodarzi et al., "DNN-assisted particle-based Bayesian joint synchronization and localization," *IEEE Trans.*, 2022.
12. H. Puttnies et al., "PTP-LP: Using Linear Programming to Increase the Delay Robustness of IEEE 1588 PTP," *GLOBECOM*, 2018.
13. R. Exel, "Mitigation of Asymmetric Link Delays in IEEE 1588 Clock Synchronization Systems," *IEEE Commun. Lett.*, 2014.
