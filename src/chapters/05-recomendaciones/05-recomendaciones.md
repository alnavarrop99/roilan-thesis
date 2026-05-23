# Recomendaciones

A partir de los resultados obtenidos y las limitaciones identificadas en la presente investigación, se proponen las siguientes recomendaciones para trabajos futuros:

1. **Validación experimental en MATLAB/GNU Octave.** Ejecutar la simulación Monte Carlo de la implementación mejorada (Exel+AKF) para obtener resultados experimentales definitivos que confirmen o ajusten las proyecciones de rendimiento presentadas en este trabajo. Se recomienda realizar un barrido sistemático de los parámetros del AKF ($\mathbf{Q}_0$, $\mathbf{P}_0$, $N$) para optimizar la relación precisión-*overhead*.

2. **Implementación en dispositivos reales.** Aplicar la implementación desarrollada en dispositivos inalámbricos reales (por ejemplo, plataformas basadas en Wi-Fi IEEE 802.11 o LoRa) para evaluar su comportamiento en condiciones de canal reales, con desvanecimiento multitrayectoria, interferencia y movilidad. La comparación entre los resultados de simulación y los resultados experimentales permitiría refinar los modelos de retardo y asimetría.

3. **Estampado de tiempo por hardware.** Emplear en futuras implementaciones hardware especializado en el estampado de tiempo, tal y como se especifica en el estándar IEEE 802.1AS. La combinación de estampado por hardware con el método híbrido Exel+AKF debería permitir alcanzar precisiones en el orden de los nanosegundos, acercándose a los requisitos de las aplicaciones industriales más exigentes.

4. **Extensión a redes multi-salto y BMCA.** Evaluar la implementación en redes con múltiples dispositivos y múltiples saltos, incorporando el Algoritmo de Mejor Reloj Maestro (BMCA) para la selección automática de la referencia de tiempo. La acumulación de errores en topologías multi-salto y la interacción entre el AKF y el BMCA son problemas abiertos que merecen investigación.

5. **Filtros no lineales y no Gaussianos.** Explorar extensiones del método propuesto utilizando Filtros de Kalman Extendidos (EKF) o *Unscented* (UKF) para manejar no linealidades en el modelo de medición, así como Filtros de Partículas para abordar distribuciones de retardo no Gaussianas (multimodales o de cola pesada) que son comunes en entornos NLoS.

6. **Aprendizaje automático para estimación de asimetría.** Investigar el uso de técnicas de aprendizaje automático (redes neuronales ligeras, *reinforcement learning*) para predecir la asimetría del canal a partir de métricas de capa física (RSSI, SNR, tasa de error de paquete) disponibles en tiempo real en los dispositivos inalámbricos, complementando o sustituyendo la etapa de estimación del AKF.

7. **Integración con 5G-TSN.** Dado el creciente interés en la convergencia de 5G y TSN, se recomienda evaluar el método propuesto en el contexto de la integración 5G-TSN, donde las asimetrías *uplink/downlink* son inherentes al sistema de asignación de recursos de radio y representan un desafío específico para gPTP.

8. **Seguridad en la sincronización.** Investigar la robustez del método híbrido Exel+AKF frente a ataques maliciosos a la sincronización (*delay box*, suplantación de maestro, inyección de mensajes), y desarrollar mecanismos de detección y mitigación integrados en el filtro de Kalman (por ejemplo, mediante el análisis de innovaciones anómalas).

9. **Análisis de sensibilidad y optimización.** Realizar un análisis de sensibilidad exhaustivo de los parámetros del AKF frente a variaciones en las condiciones de simulación (niveles de asimetría leve, moderada y severa; diferentes estabilidades de oscilador; distintas distancias y velocidades de datos), y aplicar técnicas de optimización multiobjetivo para encontrar configuraciones óptimas del filtro.

10. **Documentación y reproducibilidad.** Publicar el código fuente de la implementación en un repositorio de acceso abierto, acompañado de documentación detallada y conjuntos de datos de simulación, para facilitar la reproducibilidad de los resultados y fomentar la colaboración en el desarrollo de métodos de sincronización para gPTP en redes inalámbricas.
