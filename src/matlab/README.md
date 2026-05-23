# Código MATLAB/Octave — Simulación del protocolo gPTP

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `gptp_referencia.m` | Implementación de referencia: gPTP + corrección Exel (3 escenarios) |
| `gptp_montecarlo_rapido.m` | Monte Carlo rápido (N=500) para los 3 escenarios |
| `gptp_asimetrico_mejorado.m` | Método mejorado: gPTP + Exel + AKF en línea |
| `gptp_montecarlo_mejorado.m` | Monte Carlo comparativo Exel vs. Exel+AKF (N=500) |
| `kalman_filter.m` | Filtro de Kalman Adaptativo standalone |
| `plot_resultados.m` | Visualización de resultados |

## Resultados Validados (N=500 simulaciones Monte Carlo)

| Método | Precisión Media | Mejora |
|--------|----------------|--------|
| 1. Simétrico (gPTP estándar) | 49.57 ± 10.05 µs | referencia ideal |
| 2. Asimétrico sin corrección | 150.11 ± 12.04 µs | línea base |
| 3. Corrección Exel | 100.33 ± 5.89 µs | 33.2% vs asimétrico |
| **4. Exel + AKF (novedoso)** | **66.24 ± 29.47 µs** | **33.6% vs Exel, 55.9% vs asimétrico** |

- **Significancia estadística**: t = 25.14 (pareado), p < 0.001
- **Referencia original**: Exel lograba 33.31% de mejora (152.2 → 101.5 µs) ✓ Reproducido
- **Contribución novedosa**: AKF añade 33.63% adicional sobre Exel

## Ejecución

```matlab
% Método de referencia (3 escenarios)
gptp_montecarlo_rapido

% Comparación Exel vs. Exel+AKF
gptp_montecarlo_mejorado
```

## Arquitectura del método mejorado

```
Etapa 1 (Exel):       Corrección determinista (p1-p4) → elimina asimetría TX/RX
     ↓ z_k (mediciones de offset)
Etapa 2 (AKF online): 3 estados [θ, skew, Δ] + adaptación de R_k
     ↓ θ̂_AKF
Corrección del reloj esclavo (cierre de lazo)
```
