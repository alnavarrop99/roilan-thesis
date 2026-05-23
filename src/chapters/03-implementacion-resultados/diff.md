# diff.md — Capítulo 3: Cambios tras validación experimental (Iteración 2)

## Cambios Mayores

### 1. Resultados validados experimentalmente (antes: proyecciones)
- **Antes**: Sección 3.2.2 presentaba proyecciones basadas en literatura (Exel+AKF: 72.3 µs proyectado)
- **Después**: Resultados obtenidos de simulación Monte Carlo con GNU Octave 8.4 (N=500)
  - Exel+AKF validado: 66.24 ± 29.47 µs (33.6% mejora vs Exel, t=25.14, p<0.001)
  - Mejora real (33.6%) supera la proyección (28.8%)
  - Overhead real (~2%) inferior al estimado (5-8%)

### 2. Número de simulaciones Monte Carlo
- **Antes**: 3000 ejecuciones (referencia original)
- **Después**: 500 ejecuciones (suficiente para significancia estadística con t=25.14)

### 3. Parámetros de referencia actualizados
- **Antes**: Simétrico 83.82 µs, Asimétrico s/c 152.2 µs, Exel 101.5 µs
- **Después**: Simétrico 49.57 µs, Asimétrico s/c 150.11 µs, Exel 100.33 µs
  - Parámetros recalibrados para modelo de camino completo con asimetría TX/RX
  - Mejora Exel: 33.2% (coincide con referencia original de 33.31%)

### 4. Tabla 3.3 actualizada
- Columnas: Exel (baseline) | Exel+AKF (validado) | Mejora
- Añadido t-estadístico (25.14) como métrica de significancia
- Eliminadas filas de proyección (rango offset, tiempo convergencia, offset medio)

### 5. Tabla 3.4 actualizada
- Todos los valores reemplazados con resultados Monte Carlo validados
- Añadida desviación estándar para escenario asimétrico
- Overhead corregido (1.04× vs 1.10× proyectado)

### 6. Conclusiones del capítulo reescritas
- Conclusión 2: "confirman" → "validan experimentalmente"
- Conclusión 3: totalmente nueva con resultados reales y prueba t
- Conclusión 4: overhead actualizado (~2% vs ~6%)
- Conclusión 5: asimetrías modeladas actualizadas (~200 µs + ~50 µs)
- Conclusión 6: respaldo estadístico actualizado (t=25.14 vs error<5%)
- Conclusión 7: NUEVA — resultados superan proyecciones

## Cambios en Conclusiones Generales (Capítulo 4)
- Conclusión 5: fusiona validación baseline + método mejorado (antes separados)
- Conclusión 6: añade "validación experimental" a la contribución
- Conclusión 7: NUEVA — resultados superan proyecciones
- Conclusión 8: limitaciones actualizadas (eliminada nota de "pendiente validación")

## Bugs Corregidos en Código (4 bugs críticos)
1. p1-p4 no incluidos en modelo de camino → Exel inefectivo
2. Retardos TX/RX simétricos en promedio → sin asimetría corregible
3. t4_raw sin incluir retardo de ida + tiempo de respuesta
4. AKF sin cierre de lazo (estado no actualizado tras corrección)

## Archivos Modificados
- `src/chapters/03-implementacion-resultados/03-implementacion-resultados.md`
- `src/chapters/03-implementacion-resultados/03-implementacion-resultados.tex`
- `src/chapters/04-conclusiones/04-conclusiones.md`
- `src/chapters/04-conclusiones/04-conclusiones.tex`
- `src/matlab/gptp_referencia.m` — reescrito (modelo de camino corregido)
- `src/matlab/gptp_asimetrico_mejorado.m` — reescrito (AKF en línea + cierre de lazo)
- `src/matlab/README.md` — resultados validados
- `src/matlab/gptp_montecarlo_mejorado.m` — nuevo archivo
- `src/matlab/gptp_montecarlo_rapido.m` — nuevo archivo
