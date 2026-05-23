# Capítulo 1. Aplicaciones y desafíos del sincronismo en redes inalámbricas. Asimetría en los canales inalámbricos y protocolos de sincronismo

## 1.1 Sincronismo en redes inalámbricas

La sincronización de tiempo constituye uno de los servicios más importantes en las redes de telecomunicaciones modernas, ya que permite coordinar el acceso distribuido a los recursos compartidos, comparar las marcas de tiempo establecidas en diferentes ubicaciones y medir el rendimiento de los sistemas distribuidos en tiempo real [1]. El propósito fundamental de la sincronización es el establecimiento de una noción global del tiempo con una precisión predefinida, asegurando desplazamientos máximos acotados entre dos nodos cualesquiera [2].

El sincronismo se define como el proceso de entrega de una «referencia común» a los elementos de red desde una fuente común dentro de una precisión y estabilidad dadas, a fin de controlar precisamente la tasa a la cual las señales digitales se transmiten y procesan a través de dicha red. Desde el Internet de las Cosas (*Internet of Things*, IoT) se imponen restricciones a las aplicaciones que requieren redes sincronizadas en el tiempo para un orden cronológico de la información o la ejecución sincrónica de algunas tareas [3]. A lo largo de los años, la sincronización de tiempo ha ganado relevancia en campos como las telecomunicaciones y la automatización industrial, impulsada por la necesidad de sistemas de comunicación más confiables y eficientes.

La sincronización horaria es un componente esencial de las redes sensibles al tiempo (*Time Sensitive Network*, TSN), en especial de las redes inalámbricas de sensores (*Wireless Sensors Network*, WSN), ya que una amplia gama de aplicaciones potenciales para estas redes requiere una sincronización precisa [4], [5]. Las WSN han adquirido un papel importante en una amplia gama de aplicaciones, atribuidas principalmente a su rentabilidad, capacidades funcionales, adaptabilidad y amplia cobertura. Estas redes son un tipo especial de red donde los dispositivos inalámbricos (generalmente denominados nodos de la red) trabajan juntos para formar espontáneamente una red sin la necesidad de ninguna infraestructura. Los nodos pueden enviar datos, recibirlos o actuar como enrutadores en la red [6].

Según [7], los principales tipos de sincronización de relojes son:

1. **Reloj global**: el Tiempo Universal Coordinado (UTC) es el estándar de tiempo comúnmente utilizado en todo el mundo. Los algoritmos tradicionales de sincronización de Internet utilizan el UTC para mantener esta hora global en todos los sistemas informáticos. Esta precisión del tiempo global es mantenida por un reloj atómico; sin embargo, mantener esta sincronización en las redes de sensores es significativamente más difícil, lo que impone una sobrecarga de comunicación.

2. **Reloj relativo**: esta es la idea del tiempo relativo dentro de la red de sensores. Cada nodo se sincroniza con todos los demás nodos con una información de tiempo determinada, que puede ser diferente de UTC.

3. **Ordenamiento físico**: este modelo se utiliza para ordenar los eventos de los procesos en un sistema que comparte el mismo reloj o tiene una memoria compartida.

4. **Noción relativa del tiempo**: el tiempo también se puede acordar entre nodos sin usar un reloj en tiempo real, sino usando un tiempo lógico. Este modelo no tiene por qué coincidir con el reloj físico, es decir, cuando dos nodos establecen una conexión, este momento se establece como un tiempo lógico «cero» y, a partir de este momento, cada unidad de tiempo se incrementa por ambos nodos, y así se establece un sincronismo.

La sincronización de tiempo tiene como objetivo crear o establecer una base de tiempo común entre los dispositivos o nodos de la red [6], [8], [9], con el fin de poder comparar eventos o sintonizar acciones [10], [11]. Esto es una necesidad para muchas aplicaciones; numerosas investigaciones en torno a la comunicación inalámbrica han demostrado el uso de la sincronización de tiempo en diferentes campos de la automatización industrial, incluida la robótica, las redes inteligentes, el monitoreo mediante redes de sensores de área amplia e incluso en entornos electromagnéticos muy desafiantes [12].

Existen muchos ejemplos de aplicaciones donde la sincronización temporal desempeña un papel fundamental, como los protocolos de Control de Acceso al Medio (*Medium Access Control*, MAC), la monitorización de la salud estructural (*Structural Health Monitoring*, SHM) y la medición inteligente [13]. Las técnicas de control de acceso al medio, como el Acceso Múltiple por División de Tiempo (TDMA), requieren sincronización de tiempo para una programación precisa de los accesos al medio sin colisiones. Además, las WSN tienen recursos energéticos limitados, por lo que se utilizan técnicas de ahorro de energía para reducir el consumo de toda la red. Para que los nodos enciendan y apaguen sus transceptores en los momentos adecuados, se requiere una sincronización precisa entre los nodos de la red [6].

Las técnicas de sincronización tradicionales que se han utilizado en redes cableadas no son adecuadas para redes inalámbricas. Para sincronizar los nodos en este tipo de redes, es necesario alcanzar una noción común del tiempo teniendo en cuenta que los relojes de los dispositivos pueden desviarse por múltiples razones, que los requisitos de tiempo de cada aplicación varían y que los parámetros objetivo a maximizar en la aplicación difieren en cada caso [14].

Los relojes tienen dos fuentes principales de imprecisión: el desfasaje (*offset*) y la desviación (*skew*); por tanto, estos son los principales objetos de corrección para lograr la sincronización de tiempo [10]. El desfasaje es la diferencia absoluta entre el valor de un reloj y el valor de otro, mientras que la desviación es la diferencia entre la frecuencia de los dos relojes. Debido a la desviación del reloj se produce un aumento constante del desfasaje con el paso del tiempo. Matemáticamente, el tiempo local $t_u$ en el nodo $u$ está relacionado con el tiempo global $t$ (desconocido) por la Ecuación (1.1):

$$t_u = \alpha_u t + \beta_u$$ (1.1)

Donde $\alpha_u$ y $\beta_u$ son la desviación y el desfasaje del reloj en el nodo $u$, respectivamente. El desfasaje relativo entre un par de nodos $u$ y $v$ en una red se puede medir (hasta algún error) intercambiando mensajes con marca de tiempo entre ellos [5].

Los protocolos de sincronización de relojes se basan en la comunicación de la estación maestra de tiempo (*master clock*) a la estación esclava (*slave*), y pueden ser unidireccionales o bidireccionales. En el primer caso, el maestro actúa como estación emisora y puede enviar señales de tiempo de forma continua o periódica, pero no recibe retroalimentación del esclavo. En el esquema bidireccional, los dispositivos intercambian mensajes con marcas de tiempo, permitiendo al esclavo estimar el desfasaje respecto al maestro y corregir su reloj local. Este último enfoque es el adoptado por los principales protocolos de sincronización de precisión, como el Protocolo de Tiempo de Precisión (PTP) y su perfil generalizado (gPTP).

![Sincronización unidireccional y bidireccional](../../figures/ch01/fig_1_1_sync_uni_vs_bidi.pdf)
*Figura 1.1. Sincronización de reloj unidireccional y bidireccional.*

En los últimos años, la integración de redes TSN con tecnologías inalámbricas como 5G ha generado un renovado interés en la sincronización de precisión sobre enlaces inalámbricos [15], [16]. La capacidad de 5G para proporcionar conectividad de baja latencia y alta confiabilidad lo convierte en un habilitador clave para aplicaciones de automatización industrial, vehículos conectados y sistemas multi-sensor que requieren sincronización precisa [17].

## 1.2 Aplicaciones del sincronismo en IoT

El Internet de las Cosas ha revolucionado la vida cotidiana al permitir el intercambio de datos sin interrupciones entre varios dispositivos a través de Internet. Sin embargo, ha traído consigo desafíos significativos para las aplicaciones que requieren una temporización sincronizada, como garantizar la secuencia ordenada de los datos o el rendimiento sincronizado de las actividades [1]. Las redes de IoT suelen estar compuestas por entidades con recursos variables, lo que dificulta la implementación de métodos de sincronización de tiempo tradicionales en dispositivos con recursos limitados. Por otro lado, es posible que las soluciones que funcionan para sistemas restringidos no sean escalables en diversas implementaciones de IoT [1]. Las aplicaciones de IoT cubren una amplia gama de necesidades humanas y vitales, desde entornos inteligentes (ciudades, hogar, transporte, etc.) hasta la salud y la calidad de vida [18].

Las redes inalámbricas de sensores son utilizadas en muchas aplicaciones en las que se requiere una sincronización parcial o completa en la red, como el control de fusión nuclear, la automatización de plantas de fabricación, la comunicación móvil, el diagnóstico de fallos mecánicos, la robótica, el Big Data, el diagnóstico médico y la educación [1], [6], [19].

Los sistemas de control industriales en la era de la Industria 4.0 presentan desafíos significativos desde el punto de vista de la comunicación, es decir, baja latencia, confiabilidad y sincronización precisa. En este sentido, las TSN se han convertido en la principal solución de estos desafíos; por tanto, un requisito estratégico de la sincronización para TSN inalámbricas es lograr que la solución sea autónoma, es decir, que las funcionalidades sean realizadas por la propia red, sin depender de una infraestructura externa [20].

Las TSN se han desarrollado para permitir la comunicación en tiempo real y la unificación de partes de la red antes separadas [10], prestando especial atención a las aplicaciones industriales, puentes de audio y video, así como redes corporativas. Las redes sensibles al tiempo se basan en cuatro conceptos claves: sincronización de tiempo precisa, baja latencia garantizada, ultra confiabilidad y gestión de recursos [21]. Para cada uno de estos pilares fundamentales, el Grupo de Trabajo (TG) de Redes Sensibles al Tiempo (TSN) del Instituto de Ingenieros Eléctricos y Electrónicos (IEEE) ha definido varios estándares para proporcionar la funcionalidad correspondiente.

La convergencia de TSN con 5G representa uno de los desarrollos más prometedores para las aplicaciones de IoT industrial [16]. El 3GPP ha incorporado en sus especificaciones (Release 16 y posteriores) capacidades de TSN, incluyendo el soporte para la sincronización gPTP. Sin embargo, la naturaleza asimétrica de los enlaces inalámbricos 5G (con diferencias significativas entre *uplink* y *downlink*) plantea desafíos específicos para la precisión de la sincronización que requieren métodos de compensación especializados [15].

Entre las aplicaciones concretas que dependen de una sincronización precisa se destacan:

- **Automatización industrial y fábricas inteligentes**: los sistemas de control de movimiento, los robots colaborativos y las líneas de producción sincronizadas requieren precisiones de sincronización del orden de microsegundos o incluso nanosegundos [12], [13].
- **Redes eléctricas inteligentes** (*smart grids*): la sincronización de fasores, la protección diferencial de línea y la localización de fallas dependen de marcas de tiempo precisas y consistentes a lo largo de toda la red eléctrica [22].
- **Vehículos autónomos y conectados**: la fusión de datos de múltiples sensores (LiDAR, radar, cámaras) y la coordinación entre vehículos requieren una base de tiempo común con alta precisión [17].
- **Monitorización de salud estructural**: en puentes, edificios y otras infraestructuras críticas, los sensores deben muestrear de forma sincronizada para detectar vibraciones y deformaciones con precisión [19].
- **Audiovisual profesional**: la sincronización de múltiples flujos de audio y video en estudios de grabación, conciertos y transmisiones en vivo exige una precisión temporal del orden de microsegundos [21].

## 1.3 Desafíos del sincronismo en redes inalámbricas

Lograr una sincronización precisa en redes inalámbricas presenta desafíos considerablemente mayores que en las redes cableadas. La tecnología inalámbrica ha aportado nuevas posibilidades y ventajas a las comunicaciones de red, en contraste con las redes cableadas, pero, a diferencia de la comunicación basada en Ethernet, los enlaces inalámbricos introducen falta de fiabilidad, canales y latencias asimétricas, interferencia de canal y distorsión de la señal en la ruta de comunicación, lo que dificulta el desarrollo de normas e implementaciones adecuadas para hacer posible el sincronismo en redes inalámbricas [21].

![Fuentes de error de sincronización](../../figures/ch01/fig_1_2_fuentes_error.pdf)
*Figura 1.2. Fuentes de error de sincronización.*

A continuación, se describen los principales desafíos que afectan la sincronización de tiempo en entornos inalámbricos.

### 1.3.1 Retardos de propagación variables

En las redes inalámbricas, el retardo de propagación de los mensajes de sincronización no es constante, sino que varía en función de múltiples factores: la distancia entre los dispositivos, las condiciones del canal, las reflexiones multitrayectoria, la velocidad de los datos, el tamaño de los paquetes, el esquema de modulación y la carga de la red [20]. Esta variabilidad introduce incertidumbre en las marcas de tiempo, ya que el instante exacto de recepción no refleja fielmente el instante de transmisión más un retardo determinista conocido.

En contraste con las redes cableadas Ethernet, donde los retardos de propagación son altamente predecibles (dominados por la longitud del cable y la velocidad de propagación en el medio), en los entornos inalámbricos el canal es inherentemente variable. Los mensajes de sincronización pueden experimentar retardos adicionales debido a reintentos de transmisión, contención del medio, *buffering* en los dispositivos y procesamiento de la señal en las capas física y de enlace [10].

### 1.3.2 Deriva y ruido de los osciladores

Los relojes de los dispositivos inalámbricos, típicamente basados en osciladores de cristal de cuarzo, están sujetos a derivas (*drift*) causadas por variaciones de temperatura, envejecimiento de los componentes, vibraciones mecánicas y fluctuaciones en la tensión de alimentación [8]. La estabilidad de un oscilador se mide en partes por millón (ppm); un oscilador típico de bajo costo puede tener una deriva de ±20 a ±50 ppm, lo que significa que dos nodos pueden acumular un desfasaje de hasta 100 µs por segundo si no se corrigen activamente.

Además, el ruido de fase (*jitter*) introduce fluctuaciones aleatorias de corto plazo en la señal de reloj, afectando la precisión con la que se pueden registrar las marcas de tiempo. En implementaciones de software, el *jitter* del sistema operativo y las interrupciones pueden añadir una incertidumbre adicional significativa [7].

### 1.3.3 Asimetrías en los canales de comunicación

La presencia de retardos asimétricos en los canales de comunicación es uno de los problemas más graves para la sincronización, ya que constituye una de las principales razones de la inexactitud del proceso de sincronismo [23]. La presencia de asimetrías puede degradar significativamente el rendimiento de los esquemas de estimación del desfasaje y la desviación del reloj y, desafortunadamente, no pueden ser medidas en un sistema de sincronización por pares ni siquiera intercambiando un número infinito de mensajes [24].

Los protocolos de sincronismo tradicionales generalmente asumen que los retardos son simétricos; por consiguiente, cuando surge una asimetría en el enlace, estos protocolos crean un desfasaje de reloj significativo. Debido a esta limitación fundamental, los protocolos convencionales no pueden mitigar el desfasaje de reloj creado por una asimetría desconocida [25], [14]. Esta cuestión se trata con mayor profundidad en la Sección 1.4.

### 1.3.4 Limitaciones de recursos en los dispositivos

Muchos dispositivos IoT y nodos de WSN operan con recursos limitados de procesamiento, memoria y energía. La implementación de protocolos de sincronización complejos puede exceder la capacidad de cómputo de estos dispositivos o consumir una cantidad inaceptable de energía, reduciendo la vida útil de la batería [6]. Los protocolos de sincronización para IoT deben, por tanto, equilibrar la precisión deseada con la eficiencia energética y la simplicidad computacional.

### 1.3.5 Escalabilidad y densidad de la red

Las redes de IoT pueden estar compuestas por cientos o miles de nodos distribuidos en áreas extensas. Los protocolos de sincronización deben ser escalables, es decir, su rendimiento no debe degradarse significativamente al aumentar el número de nodos [4]. La topología de la red, la presencia de múltiples saltos, y la dinámica de entrada y salida de nodos añaden complejidad al problema de la sincronización.

### 1.3.6 Seguridad

La sincronización de tiempo es un servicio crítico y, como tal, puede ser objeto de ataques maliciosos. Un adversario puede intentar manipular los mensajes de sincronización (ataques de *delay box*, suplantación de identidad del maestro, inyección de mensajes falsos) para degradar la precisión de la sincronización o causar fallos en las aplicaciones que dependen de ella [26]. La seguridad en la sincronización es un área de investigación activa que añade otra capa de complejidad al diseño de protocolos.

## 1.4 Asimetrías en los canales de comunicación

La asimetría en los retardos de propagación en los canales de comunicación inalámbrica es, sin duda, uno de los factores que más afecta la precisión del sincronismo. Se produce cuando el tiempo que tarda un mensaje en viajar del maestro al esclavo ($t_{ms}$) es diferente del tiempo que tarda en viajar del esclavo al maestro ($t_{sm}$). Los protocolos de sincronización bidireccionales como PTP y gPTP calculan el retardo de propagación como el promedio de los tiempos de ida y vuelta, bajo la suposición de que ambos son iguales. Esta suposición rara vez se cumple en la práctica, especialmente en enlaces inalámbricos [25].

Las causas de las asimetrías son múltiples y pueden clasificarse en:

1. **Asimetrías en el medio físico**: diferencias en la potencia de transmisión, la sensibilidad de recepción y la ganancia de las antenas entre maestro y esclavo pueden provocar que los mensajes en una dirección experimenten más errores y, por tanto, más reintentos de transmisión [5]. Además, los efectos de propagación multitrayectoria pueden ser diferentes en cada dirección debido a la movilidad de los objetos en el entorno.

2. **Asimetrías en el procesamiento**: los tiempos de procesamiento de los mensajes de sincronización en los dispositivos maestro y esclavo pueden ser diferentes. Estas diferencias incluyen los tiempos de codificación/decodificación, el procesamiento en la pila de protocolos, las interrupciones del sistema operativo y las operaciones de acceso al medio como *Clear Channel Assessment* (CCA) [27]. En implementaciones con estampado de tiempo por software, la incertidumbre y la asimetría en el estampado constituyen una fuente dominante de error [28].

3. **Asimetrías en el tráfico de red**: las diferencias en la carga de tráfico en cada dirección, las políticas de calidad de servicio (QoS) asimétricas, y los mecanismos de control de acceso al medio (como CSMA/CA en Wi-Fi) introducen retardos variables y asimétricos [21].

4. **Asimetrías en sistemas 5G**: en las redes celulares 5G, la asignación de recursos de radio es inherentemente asimétrica. El *uplink* y el *downlink* utilizan diferentes esquemas de asignación de recursos, diferentes potencias de transmisión y diferentes esquemas de modulación y codificación, lo que resulta en latencias significativamente diferentes en cada dirección [15]. Esta asimetría es especialmente problemática cuando se utiliza 5G como puente transparente para TSN.

La Ecuación (1.2) expresa el cálculo del retardo de propagación medio en un protocolo bidireccional, suponiendo simetría:

$$t_{prop\_sim} = \frac{(t_2 - t_1) + (t_4 - t_3)}{2}$$ (1.2)

Donde $t_1$, $t_2$, $t_3$ y $t_4$ son las marcas de tiempo de los mensajes *Sync*, *Follow_Up*, *Delay_Req* y *Delay_Resp*, respectivamente, en el intercambio de mensajes PTP/gPTP. Cuando existe una asimetría $\Delta$, los tiempos reales de propagación son:

$$t_{ms} = t_{prop} + \Delta/2$$
$$t_{sm} = t_{prop} - \Delta/2$$

El retardo calculado asumiendo simetría es exactamente $t_{prop}$, pero el desfasaje calculado contendrá un error de $\Delta/2$, lo que significa que la mitad de la asimetría se traduce directamente en error de sincronización [25].

El impacto de las asimetrías en la precisión del sincronismo ha sido ampliamente documentado. Estudios experimentales han demostrado que en enlaces Wi-Fi típicos, las asimetrías pueden introducir errores de sincronización del orden de decenas a cientos de microsegundos [27], [28], muy por encima de los requisitos de precisión de muchas aplicaciones industriales que exigen sincronización a nivel de nanosegundos [20], [12].

## 1.5 Protocolos de sincronismo

La sincronización de reloj es uno de los temas de investigación más populares en los sistemas distribuidos de medición y control de redes inalámbricas, ya que en ellas hay un gran número de nodos controlados por relojes independientes y se requiere que cada nodo tenga una referencia de tiempo común [22]. Por consiguiente, muchos estándares internacionales han sido diseñados para satisfacer las demandas de sincronización de las redes contemporáneas [1], siendo ampliamente estudiados y desarrollados para abordar diversas tareas dentro del ámbito de IoT.

A lo largo de las últimas décadas se han desarrollado diversos protocolos de sincronización, cada uno con diferentes enfoques, precisiones y ámbitos de aplicación. Entre los más relevantes se encuentran:

- **Network Time Protocol (NTP)**: ampliamente utilizado en Internet para sincronizar los relojes de los sistemas informáticos. Alcanza precisiones del orden de milisegundos en redes cableadas, pero su rendimiento se degrada significativamente en entornos inalámbricos [10].
- **Reference Broadcast Synchronization (RBS)**: protocolo diseñado específicamente para WSN que explota la propiedad de que los mensajes *broadcast* llegan a todos los receptores simultáneamente (con la misma demora de propagación), eliminando la incertidumbre del emisor [6].
- **Timing-sync Protocol for Sensor Networks (TPSN)**: protocolo basado en árbol que logra una precisión superior a RBS mediante el intercambio bidireccional de mensajes [6].
- **Flooding Time Synchronization Protocol (FTSP)**: utiliza *flooding* de mensajes de sincronización y compensación de deriva mediante regresión lineal para lograr alta precisión en WSN [4].

Sin embargo, estos protocolos tradicionales no son prácticos para lograr los altos niveles de precisión que requieren las aplicaciones industriales modernas y las TSN [6]. En este contexto, el Protocolo de Tiempo de Precisión (PTP), estandarizado como IEEE 1588, y su perfil generalizado (gPTP), estandarizado como IEEE 802.1AS, representan el estado del arte en sincronización de precisión.

### 1.5.1 Protocolo de Tiempo de Precisión (PTP)

El Protocolo de Tiempo de Precisión (*Precision Time Protocol*, PTP), definido en el estándar IEEE 1588 [29], es un protocolo de sincronización bidireccional diseñado para alcanzar precisiones del orden de nanosegundos en redes de área local (LAN). La versión más reciente, IEEE 1588-2019, incorpora mejoras significativas en cuanto a seguridad, escalabilidad y soporte para múltiples dominios de tiempo [29].

El funcionamiento básico de PTP se basa en el intercambio de cuatro mensajes entre un reloj maestro y uno o varios relojes esclavos:

1. El maestro envía un mensaje *Sync* y registra la marca de tiempo de salida $t_1$.
2. El maestro envía un mensaje *Follow_Up* que contiene $t_1$ (en implementaciones de dos pasos).
3. El esclavo registra la marca de tiempo de recepción $t_2$ y, posteriormente, envía un mensaje *Delay_Req*, registrando $t_3$.
4. El maestro recibe el *Delay_Req* en $t_4$ y envía un mensaje *Delay_Resp* con $t_4$ al esclavo.

Con estas cuatro marcas de tiempo, el esclavo calcula el desfasaje (*offset*) y el retardo de propagación medio mediante las Ecuaciones (1.3) y (1.4):

$$offset = \frac{(t_2 - t_1) - (t_4 - t_3)}{2}$$ (1.3)

$$delay = \frac{(t_2 - t_1) + (t_4 - t_3)}{2}$$ (1.4)

PTP incluye también un mecanismo de selección del mejor reloj maestro (*Best Master Clock Algorithm*, BMCA) que permite a la red elegir automáticamente el reloj de mayor calidad como referencia. El protocolo define distintos tipos de dispositivos: relojes ordinarios (*ordinary clocks*), relojes de frontera (*boundary clocks*) y relojes transparentes (*transparent clocks*), cada uno con diferentes capacidades y responsabilidades en la jerarquía de sincronización [29].

A pesar de su precisión, PTP asume simetría en los retardos de propagación, lo que constituye su principal limitación en entornos inalámbricos. Cuando existe asimetría, el *offset* calculado por la Ecuación (1.3) contiene un error igual a la mitad de la diferencia entre los retardos en ambos sentidos [25].

### 1.5.2 Protocolo de Tiempo de Precisión Generalizado (gPTP)

El Protocolo de Tiempo de Precisión Generalizado (*Generalized Precision Time Protocol*, gPTP), definido en el estándar IEEE 802.1AS [30], constituye un perfil de PTP diseñado específicamente para las Redes Sensibles al Tiempo (TSN). gPTP extiende y adapta PTP para garantizar una sincronización de tiempo precisa y robusta en redes que integran tanto segmentos cableados como inalámbricos, siendo uno de los pocos protocolos de sincronización especificados explícitamente para su uso en redes inalámbricas [30].

Las principales características que distinguen a gPTP de PTP incluyen:

1. **Dominio único de tiempo**: gPTP opera con un único dominio de tiempo activo, simplificando la administración y evitando conflictos entre múltiples dominios [30].

2. **Medición de retardo de enlace**: gPTP utiliza un mecanismo de medición de retardo *peer-to-peer* (*peer delay mechanism*) que permite calcular el retardo de propagación en cada enlace individual, en lugar del mecanismo *end-to-end* de PTP. Esto es particularmente útil en redes con topología en malla o con múltiples saltos [31].

3. **Requisitos de *hardware***: el estándar IEEE 802.1AS especifica requisitos precisos para las implementaciones de estampado de tiempo, incluyendo la ubicación del punto de referencia de temporización en la capa física (PHY) o en la interfaz dependiente del medio (MDI), lo que minimiza la incertidumbre introducida por las capas superiores [30].

4. **Compatibilidad con medios inalámbricos**: a diferencia de otros perfiles de PTP orientados exclusivamente a redes cableadas, gPTP incluye consideraciones específicas para medios inalámbricos, como Wi-Fi (IEEE 802.11) [30], [32].

5. **Soporte para múltiples saltos**: gPTP está diseñado para operar en redes con múltiples saltos (*multi-hop*), donde los relojes de frontera en cada salto regeneran la señal de sincronización, acumulando potencialmente errores [31].

![Medición del retardo en gPTP](../../figures/ch01/fig_1_3_gptp_medicion_retardo.pdf)
*Figura 1.3. Medición del retardo en gPTP.*

El intercambio de mensajes en gPTP sigue un esquema similar al de PTP de dos pasos. El cálculo del desfasaje se realiza mediante la Ecuación (1.3) anterior, y el retardo de propagación en cada enlace se mide periódicamente. La frecuencia de los mensajes *Sync* y del mecanismo de medición de retardo determina la velocidad de convergencia y la estabilidad de la sincronización [33].

![Cálculo del retardo e impacto de la deriva](../../figures/ch01/fig_1_4_retardo_y_deriva.pdf)
*Figura 1.4. (a) Procedimiento para calcular el retardo de propagación; (b) Impacto de la deriva de los relojes.*

Sin embargo, al igual que PTP, gPTP asume que el retardo de propagación es simétrico en ambos sentidos del enlace. Esta suposición, razonable en enlaces Ethernet cableados *full-duplex*, no se cumple en la mayoría de los enlaces inalámbricos. Como resultado, la presencia de retardos asimétricos en los canales inalámbricos introduce un error sistemático en el cálculo del *offset*, degradando significativamente la precisión del sincronismo [25], [14].

La versión 2020 del estándar IEEE 802.1AS [30] introduce mejoras significativas respecto a la versión anterior de 2011, incluyendo soporte para múltiples dominios de tiempo (opcional), mayor precisión en la medición de retardos, y mecanismos mejorados para la redundancia. No obstante, la compensación explícita de asimetrías sigue siendo un área de investigación activa no completamente resuelta por el estándar [31].

Trabajos recientes han explorado la aplicación de gPTP en contextos novedosos como la integración TSN-5G [15], [16] y los sistemas autónomos multisensor [17]. En estos escenarios, la asimetría de los enlaces inalámbricos se manifiesta de forma particularmente severa, lo que motiva el desarrollo de métodos de corrección específicos como los que se abordan en el Capítulo 2 de la presente investigación.

La Tabla 1.1 presenta una comparación resumida de los principales protocolos de sincronización, destacando las fortalezas y limitaciones de cada uno en el contexto de las redes inalámbricas.

**Tabla 1.1. Comparación de las principales características de los protocolos de sincronización.**

| Característica | NTP | PTP (IEEE 1588) | gPTP (IEEE 802.1AS) | GPS |
|----------------|-----|-----------------|----------------------|-----|
| Precisión típica | ∼ms | ∼ns–µs | ∼ns | ∼ns |
| Medio | IP genérico | Ethernet | Ethernet / Inalámbrico | Satelital |
| Timestamp | Software | HW/SW | HW preferido | Receptor dedicado |
| Comunicación | Cliente-servidor | Multicast (BMCA) | Peer-to-peer (Pdelay) | Unidireccional |
| Overhead | Bajo | Medio | Medio | Alto |
| Costo | Gratuito | Bajo | Bajo | Elevado |
| IoT | Limitada | Factible | Recomendado | Impracticable |

## 1.6 Conclusiones del capítulo

La revisión realizada en este capítulo permite establecer las siguientes conclusiones:

1. El sincronismo constituye un componente fundamental en las redes inalámbricas, especialmente en el contexto de IoT y la Industria 4.0, pues permite la coordinación de recursos compartidos, la comparación de eventos distribuidos y la optimización del rendimiento de sistemas en tiempo real.

2. Las aplicaciones que dependen de una sincronización precisa abarcan dominios tan diversos como la automatización industrial, las redes eléctricas inteligentes, los vehículos autónomos, la monitorización de infraestructuras y los sistemas audiovisuales profesionales, con requisitos de precisión que van desde microsegundos hasta nanosegundos.

3. Los principales desafíos para lograr una sincronización adecuada en redes inalámbricas incluyen: los retardos de propagación variables e impredecibles, la deriva y el ruido de los osciladores, las limitaciones de recursos en los dispositivos, los problemas de escalabilidad y, de manera destacada, las asimetrías en los canales de comunicación.

4. Las asimetrías en los retardos de propagación constituyen una de las mayores fuentes de error en los sistemas de sincronización, ya que los protocolos bidireccionales asumen simetría en los canales de comunicación. Las causas de las asimetrías son múltiples: diferencias en el medio físico, en el procesamiento de los mensajes, en las cargas de tráfico y en las características inherentes de tecnologías como 5G.

5. Entre los protocolos de sincronización disponibles, el Protocolo de Tiempo de Precisión Generalizado (gPTP), definido en IEEE 802.1AS, destaca como la opción más apropiada para redes inalámbricas dentro del ecosistema TSN, al ofrecer un mecanismo de medición de retardo por enlace y consideraciones específicas para medios inalámbricos. No obstante, su rendimiento se ve significativamente degradado ante la presencia de asimetrías, lo que motiva el estudio de métodos de corrección como los que se analizan en el Capítulo 2.

---

## Referencias del capítulo

[1] K. Balakrishnan, R. Dhanalakshmi, S. B. Bahadur, y R. Gopalakrishnan, «Clock synchronization in industrial Internet of Things and potential works in precision time protocol: Review, challenges and future directions», *Int. J. Cogn. Comput. Eng.*, vol. 4, pp. 205-219, jun. 2023.

[2] H. Baniabdelghany, R. Obermaisser, y A. Khalifeh, «Extended Synchronization Protocol Based on IEEE802.1AS for Improved Precision in Dynamic and Asymmetric TSN Hybrid Networks», en *2020 9th Mediterranean Conference on Embedded Computing (MECO)*, Budva, Montenegro: IEEE, jun. 2020.

[3] B. S. Durán, «Sincronismo de reloj: Protocolo de precisión de tiempo y su empleo en entornos IoT», *Telemática*, vol. 19, n.º 2, pp. 21-28, 2020.

[4] A. R. Swain y R. C. Hansdah, «A model for the classification and survey of clock synchronization protocols in WSNs», *Ad Hoc Netw.*, vol. 27, pp. 219-241, abr. 2015.

[5] P. Barooah, J. P. Hespanha, y A. Swami, «On the effect of asymmetric communication on distributed time synchronization», en *2007 46th IEEE Conference on Decision and Control*, New Orleans, LA, USA: IEEE, 2007.

[6] S. M. Lasassmeh y J. M. Conrad, «Time synchronization in wireless sensor networks: A survey», en *Proceedings of the IEEE SoutheastCon 2010 (SoutheastCon)*, 2010.

[7] L. Tavares Bruscato, T. Heimfarth, y E. Pignaton De Freitas, «Enhancing Time Synchronization Support in Wireless Sensor Networks», *Sensors*, vol. 17, n.º 12, dic. 2017.

[8] F. Tirado-Andrés y A. Araujo, «Performance of clock sources and their influence on time synchronization in wireless sensor networks», *Int. J. Distrib. Sens. Netw.*, vol. 15, n.º 9, sep. 2019.

[9] C. Lenzen, P. Sommer, y R. Wattenhofer, «PulseSync: An Efficient and Scalable Clock Synchronization Protocol», *IEEE/ACM Trans. Netw.*, vol. 23, n.º 3, pp. 717-727, jun. 2015.

[10] D. Krummacker et al., «Intra-Network Clock Synchronization for Wireless Networks: From State of the Art Systems to an Improved Solution», en *2020 2nd International Conference on Computer Communication and the Internet (ICCCI)*, Nagoya, Japan: IEEE, jun. 2020.

[11] F. Tirado-Andrés, A. Rozas, y A. Araujo, «A Methodology for Choosing Time Synchronization Strategies for Wireless IoT Networks», *Sensors*, vol. 19, n.º 16, ago. 2019.

[12] A. M. Romanov, F. Gringoli, y A. Sikora, «A Precise Synchronization Method for Future Wireless TSN Networks», *IEEE Trans. Ind. Inform.*, vol. 17, n.º 5, pp. 3682-3692, may 2021.

[13] Z. Idrees et al., «IEEE 1588 for Clock Synchronization in Industrial IoT and Related Applications: A Review on Contributing Technologies, Protocols and Enhancement Methodologies», *IEEE Access*, vol. 8, 2020.

[14] J. C. Oliva Pérez, «Implementación del protocolo de sincronismo gPTP sobre dispositivos LoRa», Tesis de Maestría, Universidad Central Marta Abreu de Las Villas (UCLV), Santa Clara, Cuba, 2024.

[15] A. B. Muslim y R. Tönjes, «A Novel Method for gPTP-Based Time Synchronization of 5G UEs Considering Asymmetric Uplink/Downlink Latency», en *2025 IEEE Future Networks World Forum*, 2025.

[16] M. Adil, T. Qiu, X. Zhou, D. Javeed et al., «Integrated 5G and Time Sensitive Networking for Emerging Applications: A Survey of Advancements, Challenges, and Future Directions», *IEEE Commun. Surv. Tutor.*, 2025.

[17] S. K. Nagireddy, «Time Synchronization of Multi-Sensor Systems using Generalized Precision Time Protocol (gPTP): Enabling Precise Sensor Fusion for Autonomous Platforms», *J. Eng. Comput. Sci.*, 2025.

[18] W. Ayoub, A. E. Samhat, F. Nouvel, M. Mroue, y J.-C. Prevotet, «Internet of Mobile Things: Overview of LoRaWAN, DASH7, and NB-IoT in LPWANs Standards and Supported Mobility», *IEEE Commun. Surv. Tutor.*, vol. 21, n.º 2, pp. 1561-1581, 2019.

[19] V. Masalskyi, D. Čičiurėnas, A. Dzedzickis, U. Prentice, G. Braziulis, y V. Bučinskas, «Synchronization of Separate Sensors' Data Transferred through a Local Wi-Fi Network: A Use Case of Human-Gait Monitoring», *Future Internet*, vol. 16, n.º 2, 2024.

[20] O. Seijo, I. Val, M. Luvisotto, y Z. Pang, «Clock Synchronization for Wireless Time-Sensitive Networking: A March From Microsecond to Nanosecond», *IEEE Ind. Electron. Mag.*, vol. 16, n.º 2, pp. 35-43, jun. 2022.

[21] A. Mildner, «Time Sensitive Networking for Wireless Networks – A State of the Art Analysis», pp. 33-37, 2019.

[22] Y. Zhang, H. Li, S. Wang, y F. Chen, «A Fuzzy-PI Clock Servo with Window Filter for Compensating Queue-Induced Delay Asymmetry in IEEE 1588 Networks», *Sensors*, vol. 24, n.º 7, 2024.

[23] N. M. Freris, S. R. Graham, y P. R. Kumar, «Fundamental Limits on Synchronizing Clocks Over Networks», *IEEE Trans. Autom. Control*, vol. 56, n.º 6, pp. 1352-1364, jun. 2011.

[24] M. Levesque y D. Tipper, «Improving the PTP synchronization accuracy under asymmetric delay conditions», en *2015 IEEE International Symposium on Precision Clock Synchronization for Measurement, Control, and Communication (ISPCS)*, Beijing, China: IEEE, oct. 2015.

[25] R. Exel, «Mitigation of Asymmetric Link Delays in IEEE 1588 Clock Synchronization Systems», *IEEE Commun. Lett.*, vol. 18, n.º 3, pp. 507-510, mar. 2014.

[26] A. Karami y M. A. Gebremedhin, «Securing TTEthernet clock synchronization in the IIoT: A multilayered defense against intelligent cyber-attacks», *Cluster Computing*, 2026.

[27] A. Mahmood, R. Exel, y T. Sauter, «Impact of hard- and software timestamping on clock synchronization performance over IEEE 802.11», en *2014 10th IEEE Workshop on Factory Communication Systems (WFCS 2014)*, Toulouse, France: IEEE, may 2014.

[28] P. Ferrari, A. Flammini, S. Rinaldi, A. Bondavalli, y F. Brancati, «Evaluation of timestamping uncertainty in a software-based IEEE1588 implementation», en *2011 IEEE International Instrumentation and Measurement Technology Conference (I2MTC)*, Hangzhou, China: IEEE, may 2011.

[29] IEEE, «IEEE Standard for a Precision Clock Synchronization Protocol for Networked Measurement and Control Systems», *IEEE Std 1588-2019*, pp. 1-499, 2020.

[30] IEEE, «IEEE Standard for Local and Metropolitan Area Networks—Timing and Synchronization for Time-Sensitive Applications», *IEEE Std 802.1AS-2020*, pp. 1-421, 2020.

[31] K. B. Stanton, «Distributing Deterministic, Accurate Time for Tightly Coordinated Network and Software Applications: IEEE 802.1AS, the TSN profile of PTP», *IEEE Commun. Stand. Mag.*, vol. 2, n.º 2, pp. 34-40, jun. 2018.

[32] A. Mahmood, R. Exel, H. Trsek, y T. Sauter, «Clock Synchronization Over IEEE 802.11—A Survey of Methodologies and Protocols», *IEEE Trans. Ind. Inform.*, vol. 13, n.º 2, pp. 907-922, abr. 2017.

[33] Q. Bailleul, K. Jaffrès-Runser, J.-L. Scharbarg, y P. Cuenot, «Assessing a precise gPTP simulator with IEEE802.1AS hardware measurements», en *11th European Congress on Embedded Real-Time Systems (ERTS 2022)*, Toulouse, France, jun. 2022.
