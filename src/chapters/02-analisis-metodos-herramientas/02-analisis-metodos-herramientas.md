# Capítulo 2. Análisis de métodos y herramientas para mejorar el sincronismo en redes inalámbricas empleando el protocolo gPTP

En el capítulo anterior se realizó una revisión bibliográfica de los principales conceptos, desafíos y protocolos existentes en el ámbito de la sincronización de tiempo, concluyendo que el protocolo gPTP presenta las mejores cualidades para ser adaptado al entorno inalámbrico. De ahí surge la necesidad de implementar una versión de este estándar que contrarreste los efectos negativos que provocan los retardos asimétricos en estas redes.

Por consiguiente, en el presente capítulo se efectúa un análisis de los principales modelos y metodologías referentes a mitigar el impacto de los retardos asimétricos en redes inalámbricas, con el propósito de seleccionar y describir el de mejores resultados. A diferencia del trabajo de referencia, este análisis se amplía con una revisión sistemática de métodos novedosos publicados entre 2020 y 2026, incluyendo filtros de Kalman adaptativos, estimación robusta, lógica difusa y aprendizaje computacional. Asimismo, se realiza una descripción del software especializado MATLAB y su alternativa de código abierto GNU Octave, herramientas que posibilitan un ambiente de desarrollo adecuado para el estudio de esta problemática.

## 2.1 Sistemas de estampado por Software

La clave para obtener una sincronización de tiempo de alto rendimiento está estrechamente relacionada con la calidad de las estampas de tiempo (*Timestamping*, TS) [1], [2]. Los enfoques de estampado de tiempo se pueden clasificar en términos generales en estampa de tiempo de hardware y software. Los sistemas de estampado por hardware toman la marca de tiempo dentro del hardware del receptor (por ejemplo, dentro del chipset inalámbrico), mientras que las soluciones de estampado por software utilizan el procesador principal para generar una estampa de tiempo (por ejemplo, leyendo el reloj del sistema).

Como el retardo de procesamiento de las soluciones de sellado de tiempo de hardware se puede diseñar para que sea constante, las correcciones de tiempo requeridas pueden ser muy precisas (en el orden de los nanosegundos) y, por lo tanto, las estampas de tiempo también. Por el contrario, el estampado de tiempo por medios de software crea retardos indeterministas debido a la programación, las cachés, la concurrencia, etc. y, por lo tanto, la estampa de tiempo debe estar lo más cerca posible del medio [3]. Los protocolos de sincronismo, como PTP y gPTP, suelen mejorarse en términos de rendimiento si se utiliza la estampa de tiempo de hardware. Sin embargo, para llevar a cabo el sellado de tiempo por hardware, se requieren dispositivos dedicados o modificaciones dentro de los chipsets WLAN. Debido a esto, en la presente investigación, la atención e implementación del protocolo gPTP se centra en el estampado por software.

![Ubicaciones para la estampa de tiempo](../../figures/ch02/fig_2_1_ubicaciones_ts.pdf)
*Figura 2.1. Ubicaciones para la estampa de tiempo (TS) en redes orientadas a paquetes.*

Los protocolos de sincronismo basados en paquetes, como gPTP, dependen de la calidad de las estampas de tiempo tomadas en la recepción y transmisión de los mismos. Dado que la estampa de tiempo basada en software genera grandes retardos en su mayoría no deterministas, las implementaciones de sincronización de Ethernet han acercado la estampa de tiempo a la capa física. Sin embargo, la mayoría de los enfoques de sincronización inalámbrica se limitan a la estampa de tiempo de software debido a la falta de funciones de sellado de tiempo por hardware [4].

Una de las fuentes de incertidumbre de un enfoque de sincronismo basado en sistemas de sellado de tiempo por software es el método de estampa de tiempo. Según [5], entre las diversas fuentes de imprecisión en el sellado de tiempo por software se tienen:

- **Capacidad de sellado de tiempo del maestro**: este término incluye las capacidades de estampa de tiempo de los mensajes de eventos gPTP (mensaje de sincronización *Sync* y de solicitud de retardo *PdelayReq*) en el lado maestro. La incertidumbre en la identificación de $t_1$ y $t_4$ afecta a la estimación tanto del *Pdelay* como del desfasaje (*offset*).

- **Capacidad de sellado de tiempo del esclavo**: este término incluye las capacidades de estampa de tiempo de los mensajes de eventos gPTP en el lado esclavo (mensaje de respuesta a la solicitud de retardo *PdelayResp* y de seguimiento *PdelayRespFollowUp*). Estas estampas de tiempo, $t_2$ y $t_3$, también son utilizadas para estimar el *Pdelay* y el desfasaje.

- **Capacidad de sellado de tiempo de la infraestructura**: la exactitud de la información de tiempo contenida en la sincronización depende también de la capacidad de los dispositivos de red para transferir correctamente la hora. El uso de conmutadores de red que soporten gPTP puede reducir esta fuente de incertidumbre.

- **Variabilidad y comportamiento asimétrico del retardo de propagación**: el retardo de propagación en la red no es constante y puede verse afectado por el tráfico, los dispositivos de red en la ruta y la carga de la red.

Las estampas de tiempo basadas en detectores de inicio de trama convencionales tienen dos problemas principales en los sistemas inalámbricos: en primer lugar, no pueden garantizar una precisión de transferencia de tiempo mejor que el período de muestreo y, en segundo lugar, la propagación por trayectos múltiples y el carácter de variación temporal del canal inalámbrico reducen la precisión del tiempo de llegada (*Time of Arrival*, ToA) de las tramas, lo que introduce un componente de error en la sincronización de tiempo. Esto es especialmente crítico en condiciones sin visibilidad directa (*Non-Line of Sight*, NLoS), donde no existe un trayecto de propagación prevalente, por lo que el ToA puede tener fuertes variaciones [1].

En el esquema de sincronización basado en interrupciones, donde las estampas de tiempo son tomadas mediante rutina de servicio de interrupción (*Interrupt Service Routine*, ISR), el retardo de estampa de tiempo y la fluctuación se limitan principalmente al tiempo de recepción del paquete y al tiempo de notificación de interrupción [6].

El escenario tomado en cuenta en esta investigación es una red de sincronización sencilla, compuesta por un dispositivo maestro y un dispositivo esclavo que realizan el estampado de tiempo a nivel de software.

## 2.2 Análisis de los modelos, metodologías y procedimientos existentes para el diseño de protocolos más robustos ante los retardos asimétricos

Para desarrollar una implementación de cualquier índole es imprescindible y necesario escoger la tecnología o modelo que se empleará en dicho proceso, lo que demanda necesariamente un estudio profundo de la bibliografía que se relaciona con este aspecto. En el análisis de la literatura se pueden encontrar diferentes metodologías y procedimientos empleados; cada uno de los métodos definidos posee ciertas limitaciones que fomentan y ofrecen argumentos para su crítica. A continuación, se analizan los métodos existentes, organizados por categorías para facilitar su comparación sistemática.

### 2.2.1 Método de corrección determinista de estampas de tiempo (Exel)

El método propuesto por Reinhard Exel en [7] constituye el punto de partida de esta investigación y el método de referencia (*baseline*) contra el cual se compararán las mejoras propuestas. Este enfoque propone un esquema de mitigación de los retardos asimétricos basado en la corrección de la estampa de tiempo por software y logra aumentar la precisión del protocolo sin modificaciones al mismo, ni el uso de mensajes adicionales.

El funcionamiento del modelo de estampa de tiempo de software en el protocolo se basa en que las estampas de tiempo tomadas por el software ($\hat{t}_1$ a $\hat{t}_4$) difieren de las estampas de tiempo ideales ($t_1$ a $t_4$) debido a los retardos de procesamiento $p_1$ a $p_4$. Las estampas ideales pueden ser calculadas aplicando las correcciones de retardo de las Ecuaciones (2.1) a (2.4), donde $p_1$ y $p_3$ corresponden a los retardos de procesamiento de salida, $p_2$ y $p_4$ a los retardos de entrada, y la variación de los signos se debe a que todas las latencias $p > 0$:

$$t_1 = \hat{t}_1 + p_1 \quad \text{(2.1)}$$
$$t_2 = \hat{t}_2 - p_2 \quad \text{(2.2)}$$
$$t_3 = \hat{t}_3 + p_3 \quad \text{(2.3)}$$
$$t_4 = \hat{t}_4 - p_4 \quad \text{(2.4)}$$

El verdadero valor de corrección del desfasaje ($t_{offset}$) y el tiempo de ida y vuelta ($t_{RTT}$) quedan definidos en las Ecuaciones (2.5) y (2.6):

$$\hat{t}_{offset} = t_{offset} - \frac{(p_1 + p_2) - (p_3 + p_4)}{2} \quad \text{(2.5)}$$
$$\hat{t}_{RTT} = t_{RTT} + (p_1 + p_2 + p_3 + p_4) \quad \text{(2.6)}$$

Los retardos asimétricos de procesamiento $p$ se componen de términos deterministas y no deterministas. En la mayoría de los casos existen grandes retardos asimétricos deterministas que se pueden corregir aplicando el método descrito y que abarca también otros factores como la velocidad de datos, el tamaño del encabezado, la modulación, el tamaño de transferencia de acceso directo a memoria (DMA) y la velocidad de la interfaz DMA [7].

El método Exel alcanza, según sus autores, una precisión de entre 10 y 100 ns en condiciones controladas. En la implementación de referencia sobre gPTP con simulación Monte Carlo (3000 ejecuciones), se obtuvo una precisión media de 101.5 µs, una reducción del error del 33.31% respecto al protocolo sin corrección, y un offset estabilizado en el rango de [-2.55, 6.68] µs [8].

**Limitaciones del método Exel:** (1) solo corrige los retardos deterministas conocidos; las asimetrías desconocidas o variantes en el tiempo no son compensadas; (2) no realiza filtrado estadístico de las mediciones, por lo que es sensible al ruido de medición y a valores atípicos; (3) no estima ni compensa la deriva (*skew*) de los relojes, solo el offset.

![Latencias de estampa de tiempo de software](../../figures/ch02/fig_2_2_latencias_sw.pdf)
*Figura 2.2. Latencias de estampa de tiempo de software.*

### 2.2.2 Métodos basados en Filtros de Kalman

El Filtro de Kalman (KF) es un estimador óptimo para sistemas lineales con ruido Gaussiano que ha sido ampliamente aplicado a la sincronización de relojes en redes de paquetes [9]. En el contexto de PTP/gPTP, el KF permite estimar conjuntamente el offset, el skew y, en formulaciones más avanzadas, parámetros relacionados con la asimetría del canal.

**Li et al. (2024)** [10] proponen un método mejorado de sincronización de tiempo basado en filtrado de Kalman de segundo orden. El algoritmo emplea el KF para estimar con precisión el offset de tiempo, la deriva del reloj y los parámetros del reloj. Los resultados experimentales demuestran que, en enlaces asimétricos, el offset máximo se mantiene dentro de ±3 µs, lo que representa una mejora sustancial respecto a los métodos que no emplean KF.

**Hollósi y Ficzere (2024)** [11] introducen un Filtro de Kalman Adaptativo (AKF) para la estimación del offset en PTP. La principal innovación de este enfoque es la estimación en tiempo real de la varianza del ruido de medición ($R_k$), lo que permite que el filtro se adapte automáticamente a cambios en las condiciones del canal. Los resultados muestran una reducción de la varianza del offset de entre un 40% y un 60% en comparación con el KF estándar. La complejidad computacional adicional del AKF es moderada, ya que solo requiere el cálculo de la varianza muestral sobre una ventana deslizante.

**Liu y Wang (2024)** [12] desarrollan un esquema robusto de seguimiento de parámetros de reloj para IEEE 1588 en presencia de retardos asimétricos de paquetes en redes industriales. El método emplea un Filtro de Kalman recursivo robusto de tres pasos que incorpora un mecanismo de rechazo de outliers. Los resultados experimentales reportan un RMSE de offset inferior a 5 µs en presencia de asimetrías significativas. Este trabajo es particularmente relevante porque aborda explícitamente el problema de los retardos asimétricos en PTP, que es directamente trasladable al contexto de gPTP.

**Wang et al. (2021)** [13] proponen un enfoque de seguimiento de parámetros de reloj sin marcas de tiempo (*timestamp-free*) utilizando Filtro de Kalman Extendido (EKF) en redes de sensores inalámbricos. Aunque está diseñado para WSN, el marco del EKF es adaptable a PTP/gPTP y ha demostrado errores de estimación inferiores a 1 µs en simulaciones.

**Raittila (2025)** [14] desarrolla un modelo en Simulink de un lazo de control PTP con un Filtro de Kalman Adaptativo específicamente para redes Wi-Fi industriales. Este trabajo, aunque en fase de tesis de maestría, demuestra la viabilidad de implementar AKF en entornos inalámbricos reales.

### 2.2.3 Métodos basados en Estimación Robusta

**Karthik y Blum (2020)** [15] abordan el problema de la estimación robusta de skew y offset para IEEE 1588 en presencia de asimetrías deterministas desconocidas en el retardo de trayectoria. Los autores derivan cotas inferiores de rendimiento (cotas de Cramér-Rao modificadas) y proponen esquemas de estimación robusta que superan al estimador de máxima verosimilitud (MLE) convencional cuando existen asimetrías no modeladas. Este trabajo proporciona un marco teórico riguroso para comprender los límites fundamentales de la sincronización bajo asimetría.

**Vázquez et al. (2025)** [16] proponen un enfoque de filtrado de outliers en las mediciones de offset para PTP sobre redes de área amplia (WAN). El método emplea técnicas de detección de anomalías para identificar y rechazar mediciones de offset atípicas antes de que sean utilizadas por el servo de reloj, mejorando así la estabilidad de la sincronización.

### 2.2.4 Métodos basados en Lógica Difusa

**Nguyen et al. (2020)** [17] proponen un servo de reloj Fuzzy-PI adaptativo basado en IEEE 1588 para mejorar la sincronización de tiempo sobre redes Ethernet. El sistema utiliza lógica difusa para ajustar dinámicamente las ganancias del controlador PI en función del error de sincronización y su tasa de cambio. Los resultados experimentales muestran una precisión inferior a 100 ns y una mejora del 45% respecto al controlador PI tradicional.

**Zhang et al. (2024)** [18] diseñan un servo de reloj Fuzzy-PI con filtro de ventana para compensar la asimetría de retardo inducida por colas (*Queue-Induced Delay Asymmetry*, QIDA) en redes IEEE 1588. El filtro de ventana descarta las mediciones de retardo extremas, mientras que el controlador difuso ajusta los parámetros del servo. Se reporta una reducción del 52% en el error de offset causado por QIDA.

### 2.2.5 Métodos basados en Aprendizaje Computacional

**Wang et al. (2026)** [19] proponen un método de estimación de parámetros de reloj basado en aprendizaje competitivo (*Competitive Learning*) para PTP con distribuciones de retardo desconocidas. El algoritmo no asume ninguna distribución particular para los retardos, lo que lo hace robusto ante una amplia variedad de condiciones de canal. Sin embargo, su complejidad computacional es elevada y requiere una fase de entrenamiento con datos históricos.

**Goodarzi et al. (2022)** [20] presentan un enfoque de filtro de partículas asistido por redes neuronales profundas (DNN) para sincronización y localización conjunta. Aunque logra alta precisión en entornos no Gaussianos, el costo computacional del filtro de partículas (cientos o miles de partículas) lo hace prohibitivo para aplicaciones que requieren simulación Monte Carlo extensiva.

### 2.2.6 Otros métodos relevantes

**Puttnies et al. (2018)** [21] introducen PTP-LP, un enfoque que utiliza programación lineal para aumentar la robustez de IEEE 1588 PTP ante retardos variables. El método es totalmente compatible con PTP y gPTP, y se ha demostrado que supera tanto al PTP estándar como al PTP con filtrado de Kalman en ciertas condiciones, aumentando la precisión en un factor de hasta $10^4$ en escenarios favorables.

**Baniabdelghany et al. (2020)** [22] proponen una extensión de IEEE 802.1AS (gPTP) para mejorar la sincronización en redes híbridas cableadas-inalámbricas. El enfoque introduce un filtro de retraso de desviación de ruta (*Path Deviation Delay*, PDD) para monitorear el tráfico de paquetes de temporización y excluir valores atípicos.

**Levesque y Tipper (2015)** [23] proponen el mecanismo de mitigación de asimetría por paquete (*Per-Packet Asymmetry Mitigation*, PPAM), que estima los componentes de retardo por paquete individual. Los resultados de simulación muestran que PPAM supera al PTP estándar a cargas de red bajas y medias.

### 2.2.7 Comparación sistemática y selección del método

La Tabla 2.2 presenta una comparación sistemática de los métodos analizados, evaluados según cinco criterios: precisión reportada, complejidad computacional, compatibilidad con gPTP, capacidad de manejar asimetrías desconocidas y madurez de la técnica.

**Tabla 2.2. Comparación de métodos para mitigación de retardos asimétricos en PTP/gPTP.**

| Método | Categoría | Precisión | Complejidad | Compat. gPTP | Asimetría desconocida | Madurez |
|--------|-----------|-----------|-------------|-------------|---------------------|---------|
| Exel (2014) [7] | Corrección determinista | 101.5 µs (sim.) | Baja | Alta | No | Alta |
| Li et al. (2024) [10] | KF 2.º orden | ±3 µs | Media | Alta | Sí | Alta |
| Hollósi & Ficzere (2024) [11] | AKF | 40–60% mejora | Media-Alta | Alta | Sí | Alta |
| Liu & Wang (2024) [12] | KF robusto 3 pasos | <5 µs RMSE | Media-Alta | Alta | Sí | Alta |
| Wang et al. (2021) [13] | EKF sin timestamp | <1 µs | Media | Media | Sí | Media |
| Karthik & Blum (2020) [15] | Estimación robusta | Cotas óptimas | Alta | Alta | Sí | Alta |
| Nguyen et al. (2020) [17] | Fuzzy-PI | <100 ns | Media | Media | Parcial | Media |
| Zhang et al. (2024) [18] | Fuzzy-PI + ventana | 52% reducción | Media-Alta | Media | Parcial | Baja |
| Wang et al. (2026) [19] | Competitive Learning | Robusto | Alta | Media-Alta | Sí | Baja |
| Puttnies et al. (2018) [21] | Prog. Lineal | Factor $10^4$ | Media-Alta | Media | No | Media |

Del análisis comparativo se concluye que los métodos basados en Filtro de Kalman, y en particular el Filtro de Kalman Adaptativo (AKF), ofrecen la mejor relación entre precisión, complejidad computacional y compatibilidad con gPTP. El AKF combina la capacidad de estimación óptima del KF con la adaptabilidad a condiciones cambiantes del canal, y su implementación en MATLAB/Octave es factible mediante operaciones matriciales estándar.

No obstante, el método de Exel ofrece una ventaja fundamental: su corrección determinista elimina una parte significativa de la asimetría (los retardos de procesamiento conocidos $p_1$–$p_4$) antes de cualquier procesamiento estadístico. Esto sugiere que un enfoque híbrido que combine la corrección determinista de Exel con el filtrado adaptativo del AKF podría superar a cualquiera de los dos métodos por separado.

## 2.3 Descripción del método seleccionado: Enfoque híbrido Exel + Filtro de Kalman Adaptativo

Como resultado del análisis sistemático presentado en la Sección 2.2, se selecciona un **enfoque híbrido que combina la corrección determinista de estampas de tiempo de Exel con un Filtro de Kalman Adaptativo (AKF)** para la compensación de retardos asimétricos en el protocolo gPTP. Esta sección describe en detalle la arquitectura y el fundamento teórico del método propuesto.

![Arquitectura del método híbrido Exel + AKF](../../figures/ch02/fig_2_4_metodo_hibrido.pdf)
*Figura 2.4. Arquitectura del método híbrido Exel + AKF.*

### 2.3.1 Arquitectura de dos etapas

El método híbrido opera en dos etapas consecutivas, como se ilustra en la Figura 2.4:

**Etapa 1 — Corrección determinista (Exel):** Se aplican las Ecuaciones (2.1)–(2.6) a las marcas de tiempo $\hat{t}_1, \hat{t}_2, \hat{t}_3, \hat{t}_4$ capturadas por el software. Se utilizan los valores conocidos de los retardos de procesamiento asimétricos $p_1, p_2, p_3, p_4$ para obtener una primera estimación del offset $\hat{\theta}_{Exel}$. Esta etapa elimina la componente determinista de la asimetría, que en muchos casos representa la mayor parte del error de sincronización [7].

**Etapa 2 — Filtro de Kalman Adaptativo (AKF):** El offset corregido por Exel, $\hat{\theta}_{Exel}$, se utiliza como medición de entrada para un Filtro de Kalman Adaptativo que estima el estado verdadero del sistema, filtrando el ruido de medición residual y compensando las asimetrías desconocidas que el método de Exel no puede corregir.

### 2.3.2 Modelo de espacio de estados

El vector de estado del AKF se define como:

$$\mathbf{x}_k = \begin{bmatrix} \theta_k \\ s_k \\ \Delta_k \end{bmatrix}$$

donde:
- $\theta_k$: offset verdadero entre maestro y esclavo en el instante $k$ [s]
- $s_k$: skew (diferencia normalizada de frecuencia) entre los relojes [adimensional]
- $\Delta_k$: asimetría residual no corregida por Exel [s]

**Modelo de transición de estado:**

$$\mathbf{x}_{k+1} = \mathbf{F} \mathbf{x}_k + \mathbf{w}_k, \quad \mathbf{w}_k \sim \mathcal{N}(0, \mathbf{Q}_k)$$

$$\mathbf{F} = \begin{bmatrix} 1 & \tau & 0 \\ 0 & 1 & 0 \\ 0 & 0 & 1 \end{bmatrix}$$

donde $\tau$ es el intervalo entre mediciones (el período de sincronización de gPTP, típicamente 2 segundos), y $\mathbf{w}_k$ es el ruido de proceso con matriz de covarianza $\mathbf{Q}_k$. La estructura de $\mathbf{F}$ refleja que el offset evoluciona linealmente con el skew, el skew se modela como un proceso de caminata aleatoria, y la asimetría residual se considera aproximadamente constante entre períodos de sincronización.

**Modelo de medición:**

$$z_k = \mathbf{H} \mathbf{x}_k + v_k, \quad v_k \sim \mathcal{N}(0, R_k)$$

$$\mathbf{H} = \begin{bmatrix} 1 & 0 & 1/2 \end{bmatrix}$$

donde $z_k = \hat{\theta}_{Exel}[k]$ es el offset estimado por la etapa Exel en el instante $k$, y $v_k$ es el ruido de medición con varianza $R_k$. El término $1/2$ en la matriz de observación refleja que la mitad de la asimetría residual se propaga al error de offset, de acuerdo con la Ecuación (2.5).

### 2.3.3 Algoritmo del Filtro de Kalman Adaptativo

El AKF se implementa en dos fases por cada iteración $k$:

**Fase de predicción:**

$$\hat{\mathbf{x}}_{k|k-1} = \mathbf{F} \hat{\mathbf{x}}_{k-1|k-1}$$
$$\mathbf{P}_{k|k-1} = \mathbf{F} \mathbf{P}_{k-1|k-1} \mathbf{F}^T + \mathbf{Q}_{k-1}$$

**Fase de actualización:**

$$\mathbf{K}_k = \mathbf{P}_{k|k-1} \mathbf{H}^T (\mathbf{H} \mathbf{P}_{k|k-1} \mathbf{H}^T + \hat{R}_k)^{-1}$$
$$\hat{\mathbf{x}}_{k|k} = \hat{\mathbf{x}}_{k|k-1} + \mathbf{K}_k (z_k - \mathbf{H} \hat{\mathbf{x}}_{k|k-1})$$
$$\mathbf{P}_{k|k} = (\mathbf{I} - \mathbf{K}_k \mathbf{H}) \mathbf{P}_{k|k-1}$$

**Adaptación de $R_k$:** La principal innovación respecto al KF estándar es la estimación adaptativa de la varianza del ruido de medición. Siguiendo el enfoque de [11], se utiliza una ventana deslizante de las últimas $N$ innovaciones:

$$\hat{R}_k = \frac{1}{N-1} \sum_{i=k-N+1}^{k} (\nu_i - \bar{\nu})^2$$

donde $\nu_i = z_i - \mathbf{H} \hat{\mathbf{x}}_{i|i-1}$ es la innovación (residuo de la medición) y $\bar{\nu}$ es su media sobre la ventana. Esta adaptación permite que el filtro responda automáticamente a cambios en la calidad de las mediciones, por ejemplo, cuando las condiciones del canal inalámbrico varían.

### 2.3.4 Parámetros de diseño

Los siguientes parámetros deben determinarse experimentalmente durante la fase de implementación:

| Parámetro | Descripción | Método de determinación |
|-----------|-------------|------------------------|
| $\mathbf{Q}_0$ | Covarianza inicial del ruido de proceso | Calibración mediante simulaciones preliminares |
| $\mathbf{P}_0$ | Covarianza inicial del error de estimación | Matriz diagonal con valores grandes (baja confianza inicial) |
| $\mathbf{x}_0$ | Estado inicial $[\theta_0, s_0, \Delta_0]^T$ | $\theta_0$ de la primera medición Exel; $s_0=0$; $\Delta_0=0$ |
| $N$ | Tamaño de la ventana deslizante para $\hat{R}_k$ | Optimización empírica (valores típicos: 10–50) |
| $\tau$ | Intervalo entre mediciones | 2 s (período nominal de gPTP) |

### 2.3.5 Ventajas del enfoque híbrido

![Ciclo del Filtro de Kalman Adaptativo](../../figures/ch02/fig_2_5_ciclo_akf.pdf)
*Figura 2.5. Ciclo del Filtro de Kalman Adaptativo.*

1. **Herencia de Exel**: se preserva la corrección determinista que ya demostró una mejora del 33.31% en la implementación de referencia [8], proporcionando una base sólida sobre la cual construir.

2. **Filtrado óptimo**: el AKF reduce la varianza residual de las estimaciones de offset al combinar óptimamente la información de múltiples mediciones, ponderándolas según su calidad estimada.

3. **Estimación de asimetría residual**: a diferencia de Exel, que solo corrige asimetrías conocidas, el AKF estima y compensa la componente de asimetría desconocida ($\Delta_k$) que varía con las condiciones del canal.

4. **Adaptabilidad**: la estimación adaptativa de $R_k$ permite que el filtro se ajuste automáticamente a cambios en el entorno inalámbrico sin necesidad de reconfiguración manual.

5. **Comparabilidad**: el diseño permite comparar directamente el rendimiento de Exel (etapa 1 solamente) contra Exel+AKF (etapas 1+2) bajo condiciones de simulación idénticas.

6. **Implementabilidad**: todas las operaciones del AKF son algebra lineal estándar (multiplicaciones e inversiones de matrices de 3×3), perfectamente realizables en MATLAB/GNU Octave con un costo computacional moderado.

## 2.4 Herramientas de implementación: MATLAB y GNU Octave

MATLAB (abreviatura de *MATrix LABoratory*) es un programa informático de propósito especial optimizado para realizar cálculos científicos y de ingeniería, con funciones integradas para cumplir una amplia gama de tareas, desde operaciones matemáticas hasta imágenes tridimensionales [24], [25]. Comenzó su vida como un programa diseñado para realizar matemáticas matriciales, pero a lo largo de los años se ha convertido en un sistema informático flexible y fácil de usar, capaz de resolver esencialmente cualquier problema técnico [26].

Además, el programa implementa un lenguaje propio y proporciona una amplia biblioteca de funciones predefinidas para facilitar y hacer más eficientes las tareas de programación técnica. El producto básico ofrece más de mil funciones y cuenta con varios kits de herramientas (*toolbox*) que amplían esta capacidad en diversas especialidades [25], [27].

**GNU Octave** es una alternativa de código abierto a MATLAB que ofrece una compatibilidad sustancial con el lenguaje MATLAB. Octave implementa un intérprete de alto nivel para cálculo numérico con una sintaxis mayoritariamente compatible con MATLAB, lo que permite ejecutar la mayoría de los scripts y funciones diseñados para MATLAB sin modificaciones significativas [28]. Para los propósitos de esta investigación, donde las operaciones requeridas son fundamentalmente álgebra matricial, generación de números aleatorios y visualización gráfica, Octave proporciona todas las capacidades necesarias sin costo de licencia.

### 2.4.1 Archivos-M

MATLAB y Octave ofrecen una buena combinación de funciones de programación prácticas con potentes capacidades numéricas integradas. Los archivos-M proporcionan una forma alternativa de realizar operaciones que amplían en gran medida las capacidades de resolución de problemas. Existen dos tipos de archivos-M: scripts y funciones [25], [29].

Un archivo de script es una serie de comandos que se guardan en un fichero y son útiles para retener una serie de comandos que se quieren ejecutar en más de una ocasión. Los scripts comparten el área de trabajo (*workspace*) de la ventana de comandos, por lo que las variables definidas antes de su ejecución son visibles para él, y las variables que crea permanecen en el área de trabajo después de que termine de ejecutarse [24].

Por el contrario, una función es un tipo especial de archivo-M que se ejecuta en su propio espacio de trabajo independiente, recibe datos de entrada a través de una lista de argumentos y devuelve resultados mediante una lista de argumentos de salida [25]. Las funciones pueden llamar a otras funciones y son análogas a las funciones definidas por el usuario en otros lenguajes de programación.

### 2.4.2 Graficado en 2-D

Los gráficos son una herramienta muy útil para presentar información, especialmente en la ciencia y la ingeniería. MATLAB dispone de comandos para crear diferentes tipos de gráficas: estándar con ejes lineales, con ejes logarítmicos y semilogarítmicos, de barras y escaleras, polares, tridimensionales, entre otros [26]. La función `plot` permite trazar datos bidimensionales conectando los puntos con líneas rectas, y puede personalizarse mediante especificadores de color, estilo de línea y marcadores [30]. Funciones adicionales como `hold on/off`, `subplot`, `grid on/off`, `title`, `xlabel` e `ylabel` proporcionan un control completo sobre la presentación visual.

Octave implementa un sistema de gráficos compatible con la sintaxis de MATLAB, incluyendo las funciones `plot`, `figure`, `subplot` y `hold`, lo que garantiza que los scripts de visualización desarrollados para esta investigación sean ejecutables en ambos entornos.

### 2.4.3 Ventajas y desventajas de la programación en MATLAB/Octave

Según [25], las principales ventajas de MATLAB incluyen: facilidad de uso (lenguaje interpretado con entorno de desarrollo integrado), independencia de plataforma (compatible con Windows, Linux y Mac), amplia biblioteca de funciones predefinidas, trazado independiente del dispositivo, e interfaz gráfica de usuario.

Las desventajas principales son: (1) velocidad de ejecución inferior a los lenguajes compilados, mitigable mediante vectorización y el compilador JIT; (2) costo elevado de la licencia de MATLAB. Esta segunda desventaja se resuelve en el contexto de esta investigación mediante el uso de GNU Octave como alternativa gratuita y de código abierto.

## 2.5 Conclusiones del capítulo

1. Los sistemas de estampado de tiempo por software, aunque menos precisos que los de hardware, constituyen el enfoque más viable para la sincronización en redes inalámbricas con dispositivos de propósito general. La calidad de las estampas de tiempo depende críticamente de la ubicación del punto de referencia de temporización y de la minimización de los retardos indeterministas en la pila de software.

2. El análisis sistemático de 15 métodos publicados entre 2014 y 2026 revela que los enfoques basados en Filtro de Kalman, particularmente en su variante adaptativa (AKF), ofrecen la mejor relación entre precisión, complejidad computacional y compatibilidad con el protocolo gPTP. El AKF permite la estimación conjunta de offset, skew y asimetría residual, adaptándose dinámicamente a cambios en las condiciones del canal inalámbrico.

3. El método de corrección determinista de Exel, utilizado como referencia en esta investigación, logra una mejora del 33.31% sobre el protocolo sin corrección (precisión media de 101.5 µs), pero está limitado a la compensación de asimetrías deterministas conocidas.

4. Se propone un **enfoque híbrido Exel + AKF** que combina la corrección determinista de estampas de tiempo (etapa 1) con el filtrado estadístico adaptativo (etapa 2). Este diseño permite eliminar las asimetrías conocidas mediante Exel y, a continuación, filtrar el ruido residual y compensar asimetrías desconocidas mediante el AKF. Las operaciones requeridas —álgebra lineal sobre matrices de 3×3— son perfectamente realizables en MATLAB/GNU Octave con un costo computacional moderado.

5. Las herramientas de implementación seleccionadas, MATLAB y su alternativa de código abierto GNU Octave, proporcionan todas las capacidades necesarias para el desarrollo de la simulación: generación de variables aleatorias, operaciones matriciales, visualización gráfica y ejecución de simulaciones Monte Carlo.

6. Los parámetros específicos del AKF (covarianzas iniciales, tamaño de ventana deslizante, estado inicial) se determinarán experimentalmente durante la fase de implementación descrita en el Capítulo 3.

---

## Referencias del capítulo

[1] O. Seijo, J. A. Lopez-Fernandez, H.-P. Bernhard, y I. Val, «Enhanced Timestamping Method for Subnanosecond Time Synchronization in IEEE 802.11 Over WLAN Standard Conditions», *IEEE Trans. Ind. Inform.*, vol. 16, n.º 9, pp. 5792-5805, sep. 2020.

[2] P. Ferrari, G. Giorgi, C. Narduzzi, S. Rinaldi, y M. Rizzi, «Timestamp Validation Strategy for Wireless Sensor Networks Based on IEEE 802.15.4 CSS», *IEEE Trans. Instrum. Meas.*, vol. 63, n.º 11, pp. 2512-2521, nov. 2014.

[3] A. Mahmood, R. Exel, y T. Sauter, «Impact of hard- and software timestamping on clock synchronization performance over IEEE 802.11», en *2014 10th IEEE Workshop on Factory Communication Systems (WFCS 2014)*, Toulouse, France, may 2014.

[4] R. Exel, «Clock synchronization in IEEE 802.11 wireless LANs using physical layer timestamps», en *2012 IEEE International Symposium on Precision Clock Synchronization for Measurement, Control and Communication (ISPCS)*, San Francisco, CA, USA, sep. 2012.

[5] P. Ferrari, A. Flammini, S. Rinaldi, A. Bondavalli, y F. Brancati, «Evaluation of timestamping uncertainty in a software-based IEEE1588 implementation», en *2011 IEEE International Instrumentation and Measurement Technology Conference (I2MTC)*, Hangzhou, China, may 2011.

[6] A. Mahmood, G. Gaderer, H. Trsek, S. Schwalowsky, y N. Kero, «Towards high accuracy in IEEE 802.11 based clock synchronization using PTP», en *2011 IEEE International Symposium on Precision Clock Synchronization for Measurement, Control and Communication (ISPCS)*, Munich, Germany, sep. 2011.

[7] R. Exel, «Mitigation of Asymmetric Link Delays in IEEE 1588 Clock Synchronization Systems», *IEEE Commun. Lett.*, vol. 18, n.º 3, pp. 507-510, mar. 2014.

[8] M. D. Eupierre Oquendo, «Mejora del sincronismo en redes inalámbricas empleando el protocolo gPTP», Tesis de Diploma, Universidad Central Marta Abreu de Las Villas (UCLV), Santa Clara, Cuba, 2024.

[9] G. Giorgi y C. Narduzzi, «Performance Analysis of Kalman-Filter-Based Clock Synchronization in IEEE 1588 Networks», *IEEE Trans. Instrum. Meas.*, vol. 60, n.º 8, pp. 2902-2909, ago. 2011.

[10] Q. Li, J. Guo, W. Liu, W. Gao, Y. Zhang, y Y. Hu, «An enhanced time synchronization method for a network based on Kalman filtering», *Scientific Reports*, vol. 14, 2024.

[11] G. Hollósi y D. Ficzere, «Adaptive Kalman filtering in offset estimation for precision time protocol», *IEEE Trans. Ind. Inform.*, 2024.

[12] X. Liu y H. Wang, «Robust clock parameters tracking for IEEE 1588 with asymmetric packet delays in industrial networks», *IEEE Trans. Commun.*, 2024.

[13] H. Wang, R. Lu, Z. Peng, y M. Li, «Timestamp-free clock parameters tracking using extended Kalman filtering in wireless sensor networks», *IEEE Trans.*, 2021.

[14] S. Raittila, «Adaptive Control in the Precision Time Protocol for Industrial Applications: An Adaptive Kalman Filter-Based Approach for Wi-Fi Networks», Tesis de Maestría, 2025.

[15] A. K. Karthik y R. S. Blum, «Robust clock skew and offset estimation for IEEE 1588 in the presence of unexpected deterministic path delay asymmetries», *IEEE Trans. Commun.*, vol. 68, n.º 8, pp. 5102-5119, 2020.

[16] V. Vázquez, C. Megías, C. Vélez, H. Esteban, y J. Díaz, «PTP over wide area networks with offset measurement outlier filtering», *IEEE*, 2025.

[17] V. Q. Nguyen, T. H. Nguyen, y J. W. Jeon, «An adaptive fuzzy-PI clock servo based on IEEE 1588 for improving time synchronization over Ethernet networks», *IEEE Access*, vol. 8, 2020.

[18] Y. Zhang, H. Li, S. Wang, y F. Chen, «A Fuzzy-PI Clock Servo with Window Filter for Compensating Queue-Induced Delay Asymmetry in IEEE 1588 Networks», *Sensors*, vol. 24, n.º 7, 2024.

[19] H. Wang, X. Sun, W. Ma, X. Liu, y X. Zhu, «Competitive Learning-Based Clock Parameters Estimation for PTP Synchronization With Unknown Delay Distributions», *IEEE Trans.*, 2026.

[20] M. Goodarzi, V. Sark, N. Maletic, y J. G. Terán, «DNN-assisted particle-based Bayesian joint synchronization and localization», *IEEE Trans.*, 2022.

[21] H. Puttnies, P. Danielis, y D. Timmermann, «PTP-LP: Using Linear Programming to Increase the Delay Robustness of IEEE 1588 PTP», en *2018 IEEE Global Communications Conference (GLOBECOM)*, Abu Dhabi, dic. 2018.

[22] H. Baniabdelghany, R. Obermaisser, y A. Khalifeh, «Extended Synchronization Protocol Based on IEEE802.1AS for Improved Precision in Dynamic and Asymmetric TSN Hybrid Networks», en *2020 9th Mediterranean Conference on Embedded Computing (MECO)*, Budva, Montenegro, jun. 2020.

[23] M. Levesque y D. Tipper, «Improving the PTP synchronization accuracy under asymmetric delay conditions», en *2015 IEEE International Symposium on Precision Clock Synchronization for Measurement, Control, and Communication (ISPCS)*, Beijing, China, oct. 2015.

[24] D. C. Attaway, *MATLAB: A Practical Introduction to Programming and Problem Solving*, 6.ª ed. Butterworth-Heinemann, 2022.

[25] S. J. Chapman, *MATLAB Programming for Engineers*, 6.ª ed. Cengage, 2020.

[26] A. Gilat, *MATLAB: An Introduction with Applications*, 6.ª ed. Wiley, 2017.

[27] D. Belfadel, M. Zabinski, y I. Macwan, «Introduction to MATLAB Programming in Fundamentals of Engineering Course», en *2021 ASEE Virtual Annual Conference*, jul. 2021.

[28] J. W. Eaton, D. Bateman, S. Hauberg, y R. Wehbring, *GNU Octave version 8.4.0 manual: a high-level interactive language for numerical computations*, 2024. [En línea]. Disponible en: https://docs.octave.org/latest/.

[29] T. Young y M. J. Mohlenkamp, *Introduction to Numerical Methods and Matlab Programming for Engineers*. Ohio University, 2023.

[30] J. P. Mueller y J. Sizemore, *MATLAB for Dummies*, 2.ª ed. Hoboken, N.J: John Wiley & Sons, 2021.
