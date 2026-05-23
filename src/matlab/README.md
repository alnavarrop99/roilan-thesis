# Código MATLAB/Octave — Simulación del protocolo gPTP

## Archivos

| Archivo | Descripción |
|---------|-------------|
| `gptp_referencia.m` | Implementación de referencia: gPTP + corrección Exel (3 escenarios) |
| `gptp_montecarlo.m` | Motor de simulación Monte Carlo (3000 ejecuciones) |
| `plot_resultados.m` | Visualización de resultados (histogramas, boxplot, convergencia) |
| `gptp_asimetrico_mejorado.m` | Implementación mejorada: gPTP + Exel + AKF híbrido |
| `kalman_filter.m` | Filtro de Kalman Adaptativo con estimación de R_k |

## Requisitos

- **GNU Octave 8.x** o **MATLAB R2020b+**
- Toolboxes requeridos: ninguno (solo funciones básicas + estadística)

## Ejecución

### 1. Simulación de referencia (baseline Exel)

```matlab
>> gptp_montecarlo
```

Ejecuta 3000 simulaciones Monte Carlo para los 3 escenarios:
1. Enlace simétrico (gPTP estándar)
2. Enlace asimétrico sin corrección
3. Enlace asimétrico con corrección Exel

Resultados esperados (referencia de la tesis original):
- Precisión sin corrección (asimétrico): ~152.2 µs
- Precisión con corrección Exel: ~101.5 µs
- Reducción del error: 50.7 µs (33.31%)

### 2. Visualización

```matlab
>> plot_resultados
```

Genera 4 figuras en el directorio `resultados/`.

### 3. Método mejorado (Exel + AKF)

```matlab
>> [offset, prec, hist, diag] = gptp_asimetrico_mejorado(60, 1, 1, 30);
```

## Arquitectura

```
Etapa 1 (Exel): Corrección determinista de estampas (p1-p4)
     ↓ θ̂_Exel
Etapa 2 (AKF):  Filtro de Kalman Adaptativo de 3 estados
     ↓ θ̂_AKF
Corrección del reloj esclavo
```

## Estado

- [x] Código escrito (5 archivos, ~36 KB total)
- [ ] Pendiente de ejecución (requiere Octave/MATLAB instalado)
- [ ] Pendiente de validación contra resultados de referencia
