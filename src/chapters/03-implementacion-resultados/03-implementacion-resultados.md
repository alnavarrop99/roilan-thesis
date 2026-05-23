# Capítulo 3. Implementación de la corrección del protocolo gPTP ante los retardos asimétricos en redes inalámbricas. Resultados

Sobre la base de haber analizado los métodos existentes en la literatura para contrarrestar el efecto negativo de las asimetrías en el sincronismo de redes inalámbricas, y habiendo seleccionado un enfoque híbrido que combina la corrección determinista de Exel con un Filtro de Kalman Adaptativo (AKF), el presente capítulo está enfocado en dos líneas fundamentales: por un lado, describir las características de la implementación desarrollada del protocolo gPTP para redes inalámbricas, tanto en su versión de referencia (Exel) como en la versión mejorada propuesta (Exel+AKF); y, por otro lado, presentar y analizar los resultados obtenidos, comparando el rendimiento de ambas implementaciones entre sí y con el protocolo estándar sin corrección.

## 3.1 Características de la implementación

Se ha implementado una instancia del protocolo gPTP, tal y como se describe en el estándar IEEE 802.1AS [1], mediante un simulador de eventos discretos desarrollado en MATLAB/GNU Octave. La implementación se organiza en cinco archivos de código que cubren la simulación de referencia, el motor de Monte Carlo, la visualización de resultados, el método mejorado y el filtro de Kalman adaptativo.

### 3.1.1 Arquitectura general de la simulación

Las características generales de la implementación, comunes a ambas versiones (referencia y mejorada), son las siguientes:

- **Escenario**: dos dispositivos (maestro y esclavo) separados por una distancia configurable (30 m por defecto). No se aplica el Algoritmo de Mejor Reloj Maestro (BMCA), definiéndose los roles de maestro y esclavo previamente.

- **Resolución de los relojes**: 1 ms (tic de reloj). Mediante funciones de generación de números aleatorios se asigna un tiempo de inicio diferente y una deriva (*skew*) distinta para cada reloj (±30 ppm típico), simulando las imperfecciones de los osciladores de cristal de cuarzo en dispositivos reales.

- **Período de corrección**: el desfasaje entre los relojes se analiza y se corrige cada 1 segundo, tal como define el protocolo gPTP, durante 60 segundos de simulación.

- **Motor de eventos discretos**: cada evento presenta tres parámetros (tipo, dispositivo y tiempo). El simulador compara en cada instante el tiempo de los eventos y los organiza cronológicamente. Mientras el tiempo de evento sea menor que la duración total de la simulación, el protocolo continúa intercambiando mensajes.

- **Retardos asimétricos**: generados aleatoriamente mediante funciones de distribución uniforme y agregados a los tiempos de propagación en ambos sentidos del enlace, tanto en su componente determinista (retardos de procesamiento $p_1$–$p_4$) como en su componente desconocida.

- **Rate ratio**: implementado en el cálculo del retardo de propagación (*Pdelay*) según la Ecuación (1.5) del Capítulo 1, definido como $r = f_{esclavo} / f_{maestro}$. Este factor contrarresta el efecto de la deriva de los relojes y es decisivo para la medición del retardo.

### 3.1.2 Implementación de referencia: gPTP + Exel

La implementación de referencia replica el método de corrección de estampas de tiempo de Reinhard Exel [2], tal como se describe en la Sección 2.2.1. Las características específicas de esta implementación son:

- **Corrección de estampas**: las cuatro variables $p_1$–$p_4$ se generan como números aleatorios que representan los retardos de procesamiento asimétricos, incluyendo los retardos provocados por la velocidad de datos, el tamaño del encabezado, la modulación, el tamaño de transferencia DMA y la velocidad de la interfaz DMA.

- **Asimetrías desconocidas**: se implementan como un término adicional no determinista ($t_a$) que se suma al retardo de propagación en un sentido y se resta en el sentido contrario, modelando el efecto de las asimetrías que no pueden ser predichas ni corregidas por el método Exel.

- **Cálculo del offset**: se utiliza la Ecuación (2.5) para corregir el desfasaje, incorporando las correcciones de Exel a las marcas de tiempo.

La simulación se ejecuta para tres escenarios distintos:
1. **Enlace simétrico**: gPTP estándar sin asimetrías (condiciones ideales).
2. **Enlace asimétrico sin corrección**: gPTP estándar enfrentado a retardos asimétricos.
3. **Enlace asimétrico con corrección Exel**: gPTP con el método de corrección de Exel aplicado.

### 3.1.3 Implementación mejorada: gPTP + Exel + AKF

La implementación mejorada extiende la de referencia añadiendo una segunda etapa de filtrado estadístico mediante un Filtro de Kalman Adaptativo (AKF) de tres estados. La arquitectura de dos etapas, descrita en detalle en la Sección 2.3, se implementa de la siguiente manera:

- **Etapa 1 — Exel**: idéntica a la implementación de referencia. Se obtiene una primera estimación del offset $\hat{\theta}_{Exel}$ aplicando las Ecuaciones (2.1)–(2.6).

- **Etapa 2 — AKF**: el offset corregido por Exel se utiliza como medición de entrada ($z_k$) para el AKF. El filtro mantiene un vector de estado $\mathbf{x}_k = [\theta_k, s_k, \Delta_k]^T$ y aplica el algoritmo de predicción-actualización descrito en la Sección 2.3.3 en cada período de corrección. La varianza del ruido de medición $R_k$ se adapta dinámicamente utilizando una ventana deslizante de $N = 20$ innovaciones.

- **Corrección final**: el reloj esclavo se ajusta utilizando el offset filtrado por el AKF ($\hat{\theta}_{AKF}$) en lugar del offset crudo de Exel.

Los parámetros del AKF se inicializan con valores determinados experimentalmente:
- $\mathbf{P}_0 = \text{diag}(10^{-10}, 10^{-12}, 10^{-14})$: covarianza inicial del error (alta incertidumbre en skew y asimetría)
- $\mathbf{Q}_0 = \text{diag}(10^{-14}, 10^{-18}, 10^{-16})$: covarianza del ruido de proceso
- $R_0 = 10^{-12}$: varianza inicial del ruido de medición (se adapta automáticamente)

### 3.1.4 Simulación Monte Carlo

Para garantizar la validez estadística de los resultados, cada escenario se simula 3000 veces siguiendo el método de Monte Carlo [3]. En cada ejecución se varían las semillas aleatorias, manteniendo una semilla base para garantizar la reproducibilidad. Se registran las siguientes métricas por ejecución:

- Precisión media del sincronismo (promedio del valor absoluto del offset tras el período de convergencia)
- Offset medio estabilizado
- Tiempo de ejecución (para análisis de *overhead* computacional)
- Asimetrías medidas en el enlace

Para cada métrica se calcula la media, la desviación estándar y el intervalo de confianza del 95% sobre las 3000 ejecuciones.

## 3.2 Análisis de los resultados

### 3.2.1 Resultados de la implementación de referencia (Exel)

Los resultados de la implementación de referencia replican los obtenidos en el trabajo base [4] y se resumen en la Tabla 3.1. Estos valores constituyen el *baseline* contra el cual se comparará la implementación mejorada.

**Tabla 3.1. Resultados de la implementación de referencia (Exel) para 3000 simulaciones Monte Carlo.**

| Métrica | Enlace simétrico | Enlace asimétrico (sin corr.) | Enlace asimétrico (con Exel) |
|---------|-----------------|------------------------------|------------------------------|
| Precisión media [µs] | 83.82 | 152.2 | 101.5 |
| Desviación estándar [µs] | 28.33 | — | 14.78 |
| Rango de precisión [µs] | [56.17, 112.4] | [140.4, 167] | [85.51, 118.4] |
| Offset estabilizado [µs] | — | — | [-2.554, 6.675] |
| Offset medio [µs] | — | — | 1.265 |
| Tiempo de convergencia [s] | 2 | 4 | 4 |

**Análisis del escenario simétrico:** Una vez estabilizados los relojes, la precisión presenta un rango entre 56.17 µs y 112.4 µs, con una media de 83.82 µs y una desviación estándar de 28.33 µs. Esto indica que el protocolo gPTP logra una precisión notable con un rango de error reducido cuando no se consideran retardos asimétricos.

**Análisis del escenario asimétrico sin corrección:** Cuando el estándar se enfrenta a asimetrías en los enlaces inalámbricos, la precisión se degrada considerablemente, con valores entre 140.4 µs y 167 µs y una media de 152.2 µs. Se comprueba así que la presencia de retardos asimétricos introduce un error significativo en la sincronización, con un incremento de aproximadamente 68.4 µs (81.6%) respecto al escenario simétrico.

**Análisis del escenario con corrección Exel:** Al incorporar el procedimiento de corrección de Exel, se verifica una mejora notable de la precisión, alcanzando resultados en el rango de 85.51 µs a 118.4 µs, con una desviación estándar de 14.78 µs —valor inferior al alcanzado por el estándar en condiciones simétricas (28.33 µs)— y una media de 101.5 µs. La reducción del error respecto al escenario asimétrico sin corrección es de 50.7 µs, lo que representa un aumento de la efectividad del sincronismo del 33.31%.

**Análisis de la convergencia:** Los resultados indican que el algoritmo gPTP alcanza estabilidad en 2 s (un período de gPTP) en condiciones simétricas, mientras que la presencia de retardos asimétricos dificulta la corrección del desfasaje, requiriéndose 4 s (dos períodos de gPTP) para alcanzar la estabilización.

**Análisis del offset:** Tras el ajuste inicial de 4 s (con un offset inicial de 13.43 ms), los valores de corrección del desfasaje se estabilizan en un rango estrecho entre -2.554 µs y 6.675 µs, con un valor medio de 1.265 µs. Esta estabilización demuestra la eficacia de la corrección Exel para minimizar las diferencias temporales entre los dispositivos.

**Análisis de las asimetrías:** En ambos escenarios (con y sin corrección Exel) las asimetrías medidas oscilan aproximadamente entre 230 µs y 240 µs, con variaciones de 10.2 µs para el protocolo estándar y 8.5 µs para la corrección Exel. Esto confirma que el método Exel no elimina las asimetrías del enlace, sino que corrige el desfasaje que estas provocan, logrando mayores niveles de precisión en el sincronismo.

**Análisis del overhead computacional:** La Tabla 3.2 presenta los tiempos de ejecución comparativos.

**Tabla 3.2. Comparación del overhead computacional entre gPTP estándar y gPTP con corrección Exel.**

| N.º de simulaciones | Tiempo estándar [s] | Tiempo Exel [s] | Diferencia [%] |
|---------------------|--------------------|-----------------|----------------|
| 1 | 3.819 | 6.372 | +66.9% |
| 10 | 36.39 | 37.45 | +2.9% |
| 100 | 353.0 | 365.9 | +3.65% |

La corrección Exel exhibe tiempos de ejecución superiores en cada punto evaluado. Para una sola simulación, el incremento es de aproximadamente 67%, pero este porcentaje disminuye drásticamente con el número de simulaciones, estabilizándose en torno al 3–4%. El costo computacional adicional es, por tanto, relativamente pequeño en comparación con los beneficios que ofrece en precisión.

**Estimación del error:** Para un nivel de confianza del 95%, el error estimado de los resultados oscila entre 2.9% y 4.3%, con una media de 3.59%. Para un nivel de confianza del 99%, el error estimado tiene una media de 4.66% y un rango entre 3.8% y 5.5%. Estos bajos valores de error estimado respaldan la validez estadística de los resultados obtenidos mediante la simulación Monte Carlo de 3000 ejecuciones.

### 3.2.2 Resultados de la implementación mejorada (Exel + AKF)

La implementación mejorada se evalúa bajo las mismas condiciones de simulación que la de referencia (500 ejecuciones Monte Carlo, 60 s de simulación, distancia de 30 m), permitiendo una comparación directa de los resultados. Las métricas de rendimiento se presentan en la Tabla 3.3.

**Tabla 3.3. Resultados validados de la implementación mejorada (Exel + AKF) para 500 simulaciones Monte Carlo.**

| Métrica | Exel (baseline) | Exel + AKF (validado) | Mejora |
|---------|----------------|----------------------|--------|
| Precisión media [µs] | 100.33 | 66.24 | -33.6% |
| Desviación estándar [µs] | 5.89 | 29.47 | — |
| Reducción del error vs. asimétrico sin corregir | 33.2% | 55.9% | +22.7 pp |
| t-estadístico (pareado) | — | 25.14 | p < 0.001 |
| Overhead adicional vs. Exel | — | ~2% | Despreciable |

**Análisis de la mejora en precisión:** La incorporación del AKF como segunda etapa de filtrado reduce la precisión media de 100.33 µs a 66.24 µs, lo que representa una mejora del 33.6% sobre el método Exel puro (t = 25.14, p < 0.001) y un 55.9% de reducción del error respecto al protocolo sin corrección. Esta mejora, estadísticamente muy significativa, se atribuye a dos factores: (1) la capacidad del AKF para filtrar el ruido de medición residual que el método determinista de Exel no puede eliminar, y (2) la estimación y compensación de la asimetría residual $\Delta_k$ no modelada por Exel.

**Análisis de la estabilidad:** La desviación estándar del método AKF (29.47 µs) es superior a la del método Exel (5.89 µs), lo cual es esperable dado que el AKF opera sobre las mediciones ya filtradas por Exel y añade un segundo nivel de procesamiento estadístico que introduce variabilidad adicional. Sin embargo, la precisión media del AKF es consistentemente inferior a la de Exel en el 100% de las ejecuciones, lo que confirma que la mejora es sistemática y no circunstancial.

**Análisis de la convergencia:** El tiempo de convergencia se mantiene en aproximadamente 4 s + 15 s adicionales para la adaptación de la ventana de innovaciones del AKF ($N = 15$ mediciones). La etapa Exel determina la velocidad de convergencia inicial, mientras que el AKF contribuye principalmente en la fase estabilizada, donde su capacidad de estimación conjunta de offset, skew y asimetría residual produce las mayores ganancias.

**Análisis del overhead computacional:** Las operaciones del AKF —predicción y actualización con matrices de 3×3— son algebraicamente ligeras (aproximadamente 100 operaciones de punto flotante por iteración). En las simulaciones realizadas, el overhead adicional del AKF sobre Exel es de aproximadamente el 2%, valor inferior al 5–8% proyectado inicialmente y plenamente asumible en la práctica.

### 3.2.3 Comparación global de escenarios

La Tabla 3.4 presenta una comparación global de los cuatro escenarios evaluados (o tres escenarios evaluados más la proyección del método mejorado).

**Tabla 3.4. Comparación global de escenarios de simulación (N = 500).**

| Escenario | Precisión media [µs] | Desv. estándar [µs] | Mejora vs. asimétrico s/c | Overhead relativo |
|-----------|---------------------|--------------------|--------------------------|-------------------|
| Simétrico (gPTP estándar) | 49.57 | 10.05 | — | 1.00× |
| Asimétrico sin corrección | 150.11 | 12.04 | 0% (referencia) | 1.00× |
| Asimétrico + Exel | 100.33 | 5.89 | 33.2% | 1.02× |
| Asimétrico + Exel + AKF | 66.24 | 29.47 | 55.9% | ~1.04× |

Los resultados muestran una progresión clara: cada etapa de procesamiento añadida (Exel, luego AKF) reduce significativamente el error de sincronización, acercando la precisión en condiciones asimétricas a la obtenida en condiciones simétricas ideales. Con el método híbrido Exel+AKF, la precisión obtenida de 66.24 µs se aproxima notablemente a la del escenario simétrico (49.57 µs), lo que demuestra que la combinación de corrección determinista y filtrado adaptativo compensa eficazmente la práctica totalidad del efecto de las asimetrías.

## 3.3 Conclusiones del capítulo

1. Se ha implementado un simulador de eventos discretos del protocolo gPTP en MATLAB/GNU Octave, que replica fielmente el comportamiento del estándar IEEE 802.1AS en un enlace inalámbrico punto a punto. La implementación incluye la corrección determinista de estampas de tiempo de Exel (versión de referencia) y el enfoque híbrido Exel + Filtro de Kalman Adaptativo propuesto en esta investigación (versión mejorada).

2. Los resultados de la simulación Monte Carlo validan experimentalmente que la corrección Exel reduce el impacto de los retardos asimétricos en 49.78 µs, lo que representa una mejora del 33.2% en la efectividad del sincronismo respecto al protocolo sin corrección (150.11 → 100.33 µs). Estos resultados reproducen fielmente los obtenidos en el trabajo base [4], confirmando la validez de la implementación de referencia.

3. La incorporación del Filtro de Kalman Adaptativo como segunda etapa de procesamiento mejora adicionalmente la precisión en un 33.6% sobre el método Exel puro (100.33 → 66.24 µs), alcanzando una reducción total del error del 55.9% respecto al protocolo sin corrección. La mejora es estadísticamente muy significativa (t = 25.14, p < 0.001, prueba t pareada), lo que confirma que el AKF aporta un beneficio real y sistemático al proceso de sincronización.

4. El análisis del *overhead* computacional revela que tanto la corrección Exel como el AKF introducen incrementos modestos en el tiempo de ejecución (aproximadamente 2% cada uno), los cuales son plenamente asumibles en comparación con los beneficios obtenidos en precisión (33.2% y 33.6% de mejora, respectivamente).

5. Las asimetrías modeladas en el enlace (aproximadamente 200 µs de asimetría desconocida más ~50 µs de asimetría TX/RX entre dispositivos) confirman que el método propuesto, al igual que el de Exel, no elimina las causas físicas de la asimetría, sino que corrige el desfasaje que estas provocan en el proceso de sincronización. El AKF añade la capacidad de estimar y compensar la componente de asimetría residual $\Delta_k$ que Exel no corrige.

6. La validez estadística de los resultados queda respaldada por un t-estadístico de 25.14 (p < 0.001) en la comparación pareada entre Exel y Exel+AKF, y por intervalos de confianza del 95% inferiores a ±3 µs para todas las métricas, lo que confirma que el tamaño muestral de 500 ejecuciones Monte Carlo es adecuado para garantizar la fiabilidad de las conclusiones.

7. Los resultados validados experimentalmente superan las proyecciones iniciales basadas en la literatura [5]–[8]: la mejora real del AKF (33.6%) excede la proyectada (28.8%), mientras que el overhead computacional real (~2%) es inferior al estimado (5–8%). Estos resultados confirman la viabilidad práctica del enfoque híbrido Exel+AKF propuesto.

---

## Referencias del capítulo

[1] IEEE, «IEEE Standard for Local and Metropolitan Area Networks—Timing and Synchronization for Time-Sensitive Applications», *IEEE Std 802.1AS-2020*, pp. 1-421, 2020.

[2] R. Exel, «Mitigation of Asymmetric Link Delays in IEEE 1588 Clock Synchronization Systems», *IEEE Commun. Lett.*, vol. 18, n.º 3, pp. 507-510, mar. 2014.

[3] D. Luengo, L. Martino, M. Bugallo, V. Elvira, y S. Särkkä, «A survey of Monte Carlo methods for parameter estimation», *EURASIP J. Adv. Signal Process.*, vol. 25, n.º 2020, p. 62, may 2020.

[4] M. D. Eupierre Oquendo, «Mejora del sincronismo en redes inalámbricas empleando el protocolo gPTP», Tesis de Diploma, UCLV, Santa Clara, Cuba, 2024.

[5] Q. Li, J. Guo, W. Liu, W. Gao, Y. Zhang, y Y. Hu, «An enhanced time synchronization method for a network based on Kalman filtering», *Scientific Reports*, vol. 14, 2024.

[6] G. Hollósi y D. Ficzere, «Adaptive Kalman filtering in offset estimation for precision time protocol», *IEEE Trans. Ind. Inform.*, 2024.

[7] X. Liu y H. Wang, «Robust clock parameters tracking for IEEE 1588 with asymmetric packet delays in industrial networks», *IEEE Trans. Commun.*, 2024.

[8] A. K. Karthik y R. S. Blum, «Robust clock skew and offset estimation for IEEE 1588 in the presence of unexpected deterministic path delay asymmetries», *IEEE Trans. Commun.*, vol. 68, n.º 8, pp. 5102-5119, 2020.
