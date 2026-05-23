# Plan de Implementación de Figuras, Infografías y Tablas

> **Ámbito:** `src/` — todo el contenido está en español  
> **Referencia base:** `src/base-doc/TD_Malcolm_Eupierre.pdf`  
> **Herramientas:** MATLAB/Octave, Python (matplotlib), TikZ (LaTeX), Mermaid, capturas de pantalla  
> **Formato de salida:** `.pdf` (vectorial preferente) o `.png` (≥300 DPI) para figuras; `.tex` para tablas LaTeX  

---

## 1. Resumen de Inventario

| Capítulo | Figuras base doc | Figuras nuevas/mejoradas | Tablas base doc | Tablas nuevas |
|----------|-----------------|-------------------------|-----------------|---------------|
| 00-Introducción | 0 | 2 (estructura tesis, ciclo R-E-V-T) | 0 | 0 |
| 01-Aplicaciones y desafíos | 4 (1.1–1.4) | 1 (comparativa protocolos) | 0 | 1 (Tabla 1.1) |
| 02-Análisis de métodos | 3 (2.1–2.3) | 3 (híbrido Exel+AKF, ciclo AKF, arquitectura) | 1 (Tabla 2.1) | 2 (Tabla 2.2, 2.3) |
| 03-Implementación y resultados | 7 (3.1–3.7) | 6 (nuevas gráficas AKF, boxplot, convergencia, estados AKF) | 0 | 4 (Tabla 3.1–3.4) |
| 04-Conclusiones | 0 | 0 | 0 | 0 |
| 05-Recomendaciones | 0 | 0 | 0 | 0 |
| Back/Front matter | 0 | 2 (glosario acrónimos, apéndice parámetros) | 0 | 2 (Tabla A.1, A.2) |
| **Total** | **14** | **14** | **1** | **10** |

---

## 2. Convenios de Nomenclatura y Ubicación

```
src/figures/
  ch01/               # Figuras del Capítulo 1
    fig_1_1_sync_uni_vs_bidi.{pdf,png}
    fig_1_2_fuentes_error.{pdf,png}
    fig_1_3_gptp_medicion_retardo.{pdf,png}
    fig_1_4_retardo_y_deriva.{pdf,png}
    fig_1_5_comparativa_protocolos.{pdf,png}   # NUEVA
  ch02/
    fig_2_1_ubicaciones_ts.{pdf,png}
    fig_2_2_latencias_sw.{pdf,png}
    fig_2_3_matlab_escritorio.{png}            # screenshot
    fig_2_4_metodo_hibrido.{pdf,png}           # NUEVA
    fig_2_5_ciclo_akf.{pdf,png}                # NUEVA
    fig_2_6_arquitectura_filtros.{pdf,png}     # NUEVA
  ch03/
    fig_3_1_esquema_implementacion.{pdf,png}
    fig_3_2_precision_tiempo.{pdf,png}
    fig_3_3_offset_tiempo.{pdf,png}
    fig_3_4_tiempo_ejecucion.{pdf,png}
    fig_3_5_overhead_porcentaje.{pdf,png}
    fig_3_6_retardos_asimetricos.{pdf,png}
    fig_3_7_estimacion_error.{pdf,png}
    fig_3_8_precision_4escenarios.{pdf,png}     # NUEVA (Exel+AKF)
    fig_3_9_offset_comparativo.{pdf,png}       # NUEVA
    fig_3_10_boxplot_metodos.{pdf,png}          # NUEVA
    fig_3_11_convergencia_montecarlo.{pdf,png}  # NUEVA
    fig_3_12_estados_akf.{pdf,png}             # NUEVA
    fig_3_13_overhead_akf.{pdf,png}            # NUEVA
  intro/
    fig_intro_estructura_tesis.{pdf,png}         # NUEVA
    fig_intro_ciclo_revt.{pdf,png}               # NUEVA
  backmatter/
    fig_apendice_matlab_cmds.{pdf,png}           # NUEVA (reemplaza Tabla 2.1)

src/tables/
  tab_1_1_comparativa_protocolos.tex           # NUEVA
  tab_2_1_matlab_especificadores.tex           # base doc → apéndice
  tab_2_2_comparacion_metodos.tex              # ya existe en .md
  tab_2_3_parametros_akf.tex                   # NUEVA
  tab_3_1_resultados_referencia.tex             # ya existe en .md
  tab_3_2_overhead_exel.tex                   # ya existe en .md
  tab_3_3_resultados_mejorado.tex             # ya existe en .md
  tab_3_4_comparacion_global.tex              # ya existe en .md
  tab_A_1_parametros_simulacion.tex             # NUEVA
  tab_A_2_acronimos_glosario.tex              # NUEVA
```

---

## 3. Figuras por Capítulo — Especificación y ASCII

### 3.1 Capítulo 0 — Introducción

#### `fig_intro_estructura_tesis` (NUEVA)
- **Ubicación:** Sección "Estructura de la tesis" (última sección de la introducción)
- **Descripción:** Diagrama de flujo que muestra la estructura lógica de los 3 capítulos, conclusiones y recomendaciones.
- **Herramienta:** TikZ o Mermaid → PDF
- **ASCII:**

```
┌─────────────────────────────────────────┐
│         ESTRUCTURA DE LA TESIS          │
└─────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
┌──────────────┐      ┌──────────────────┐
│  Capítulo 1  │      │   Capítulo 2     │
│  Fundamentos │      │  Métodos y       │
│  y Estado del│      │  herramientas    │
│     Arte     │      │                  │
└──────┬───────┘      └────────┬─────────┘
       │                         │
       │    ┌─────────────────┐   │
       └───►│  Capítulo 3     │◄──┘
            │ Implementación  │
            │   y Resultados  │
            └────────┬────────┘
                     │
         ┌───────────┴───────────┐
         ▼                       ▼
┌────────────────┐    ┌──────────────────┐
│ Conclusiones   │    │ Recomendaciones  │
│  (aportes)     │    │  (trabajo futuro)│
└────────────────┘    └──────────────────┘
```

#### `fig_intro_ciclo_revt` (NUEVA)
- **Ubicación:** Sección de metodología (mención del ciclo Research-Execute-Validate-Test)
- **Descripción:** Diagrama del ciclo iterativo R-E-V-T aplicado en la tesis.
- **Herramienta:** TikZ o Mermaid → PDF
- **ASCII:**

```
        ┌──────────┐
        │ RESEARCH │◄──────┐
        │ (litera- │       │
        │  tura)   │       │
        └────┬─────┘       │
             │              │
             ▼              │
        ┌──────────┐        │  NO cumple
        │ EXECUTE  │        │  criterios
        │(código/  │        │
        │  texto)  │        │
        └────┬─────┘        │
             │              │
             ▼              │
        ┌──────────┐        │
        │ VALIDATE │        │
        │(verifica-│        │
        │ ción)    │        │
        └────┬─────┘        │
             │              │
             ▼              │
        ┌──────────┐        │
        │   TEST   │────────┘
        │(Monte   │  SÍ cumple
        │ Carlo)  │
        └────┬─────┘
             │
             ▼
        ┌──────────┐
        │ DELIVER  │
        │(.md/.tex/│
        │  .pdf)   │
        └──────────┘
```

---

### 3.2 Capítulo 1 — Aplicaciones y desafíos del sincronismo

#### `fig_1_1_sync_uni_vs_bidi`
- **Origen:** Base doc, Figura 1.1 — Recrear con mejor calidad vectorial
- **Ubicación:** Sección 1.1, tras párrafo que introduce protocolos unidireccionales/bidireccionales
- **Descripción:** Dos diagramas lado a lado. Izquierda: maestro envía tiempo al esclavo (flecha simple). Derecha: intercambio bidireccional de mensajes con marcas de tiempo.
- **Herramienta:** TikZ (LaTeX) o Mermaid → PDF
- **ASCII:**

```
     UNIDIRECCIONAL                     BIDIRECCIONAL

   ┌─────────┐                         ┌─────────┐
   │ MAESTRO │───► t_master ───────► │ ESCLAVO │
   │  (GM)   │      (referencia)     │         │
   └─────────┘                         └─────────┘
   [sin medición de retardo]           [mide RTT y calcula offset]

        vs.

   ┌─────────┐    Sync(t1)           ┌─────────┐
   │ MAESTRO │ ───────────────►      │ ESCLAVO │
   │         │ ◄───────────────      │         │
   │         │    Follow_Up(t2)      │         │
   │         │    PdelayReq(t3)      │         │
   │         │ ◄───────────────      │         │
   └─────────┘    PdelayResp(t4)     └─────────┘
   [no puede calcular retardo]         [calcula offset y Pdelay]
```

#### `fig_1_2_fuentes_error`
- **Origen:** Base doc, Figura 1.2 — Recrear
- **Ubicación:** Sección 1.3, tras párrafo que menciona fuentes de error
- **Descripción:** Diagrama de bloques o timeline que descompone las fuentes de error en sincronización: tiempo de transmisión, acceso al medio, propagación y recepción.
- **Herramienta:** TikZ → PDF
- **ASCII:**

```
┌─────────────────────────────────────────────────────────────┐
│              FUENTES DE ERROR DE SINCRONIZACIÓN              │
└─────────────────────────────────────────────────────────────┘

  MAESTRO                                    ESCLAVO
     │                                          ▲
     │  ┌─────────────┐  ┌──────────────┐  ┌────┴────┐
     ├─►│  SEND TIME  │─►│ ACCESS TIME  │─►│ PROPAG. │───
     │  │  (pila SW)  │  │   (MAC)      │  │  (aire) │   │
     │  └─────────────┘  └──────────────┘  └─────────┘   │
     │         ↑                                  │      │
     │         └──────────────────────────────────┘      │
     │                    RECEIVE TIME                   │
     │                   (interrupción SO)               │
     │                                                   │
     └───────────────────────────────────────────────────┘

  Fuentes de incertidumbre:
  ├── Send time: generación del paquete en la pila de red
  ├── Access time: contención del medio, backoff
  ├── Propagation time: trayecto físico, reflexiones multitrayectoria
  └── Receive time: notificación de interrupción, lectura del reloj
```

#### `fig_1_3_gptp_medicion_retardo`
- **Origen:** Base doc, Figura 1.3 — Recrear con claridad
- **Ubicación:** Sección 1.5, descripción del mecanismo Pdelay de gPTP
- **Descripción:** Diagrama de secuencia del intercambio de mensajes peer delay con las 4 estampas de tiempo (t1, t2, t3, t4).
- **Herramienta:** Mermaid (sequence diagram) o TikZ → PDF
- **ASCII:**

```
  SOLICITANTE (Maestro)          RESPONDEDOR (Esclavo/Puente)
         │                                   │
    t1 ──┼──► PdelayReq ─────────────────►│
         │         (mensaje de evento)      │
         │                                   │
         │          ◄───────────────────   ├── t2
         │                                   │
         │          ◄─── PdelayResp ─────    ├── t3
         │              (mensaje de evento)   │
    t4 ──┼──────────────────────────────────┤
         │                                   │
         │◄── PdelayRespFollowUp(t3) ────────┤
         │         (mensaje general)          │
         │                                   │

  Cálculo del retardo de propagación:
  ┌──────────────────────────────────────────────────────┐
  │  Pdelay = [(t4 − t1) − r·(t3 − t2)] / 2              │
  │  donde r = rate ratio (relación de frecuencias)      │
  └──────────────────────────────────────────────────────┘
```

#### `fig_1_4_retardo_y_deriva`
- **Origen:** Base doc, Figura 1.4 — Recrear
- **Ubicación:** Sección 1.5, tras explicación de la Ecuación 1.2 y rate ratio
- **Descripción:** Dos subfiguras: (a) timeline del cálculo del retardo con los intervalos (t4-t1) y (t3-t2); (b) efecto de la deriva de reloj (skew) sobre los tiempos de arribo, mostrando que los relojes locales divergen.
- **Herramienta:** TikZ → PDF
- **ASCII:**

```
(a) PROCEDIMIENTO CÁLCULO RETARDO          (b) IMPACTO DERIVA RELOJ

   t1 ──►│←──── T_ms ────►│◄── t4              Reloj Maestro:  ━━━━━━━
         │                │                        (referencia)   ━━━━━━━
         │     Propagación │                                    │
         │     (ida+vuelta)│                                    │ skew
         │                │                                    ▼
   t2 ◄──│◄── T_sm ────│◄── t3              Reloj Esclavo:    ━━━━━━━
                                              (más lento)    ═══════

   Pdelay = [(t4−t1) − r·(t3−t2)] / 2
   r = f_esclavo / f_maestro

   Nota: sin corrección de deriva (r=1),
   el cálculo del Pdelay contiene error
   proporcional al skew acumulado.
```

#### `fig_1_5_comparativa_protocolos` (NUEVA)
- **Ubicación:** Sección 1.5, tras descripción de PTP y gPTP
- **Descripción:** Tabla-infografía comparativa entre NTP, PTP (IEEE 1588), gPTP (IEEE 802.1AS) y GPS.
- **Herramienta:** TikZ o Python (matplotlib table) → PDF
- **ASCII:**

```
┌────────────┬─────────────┬──────────────┬─────────────┬────────────┐
│  Caract.   │    NTP      │  PTP (1588)  │ gPTP (802.1AS│   GPS     │
├────────────┼─────────────┼──────────────┼─────────────┼────────────┤
│ Precisión  │  ~ms        │  ~ns–µs      │  ~ns        │  ~ns      │
│ Medio      │  IP genérico│  Ethernet    │  Ethernet/  │  Satelital│
│            │             │              │  Wireless   │           │
│ Hardware   │  Software   │  HW/SW       │  HW prefer. │  Receptor │
│ Mensajes   │  Cliente-   │  Multicast   │  Peer-to-   │  Unidirec.│
│            │  servidor   │  (Best       │  peer       │  (solo RX)│
│            │             │   Master)    │  (Pdelay)   │           │
│ Overhead   │  Bajo       │  Medio       │  Medio      │  Alto     │
│ Costo      │  Gratuito   │  Bajo        │  Bajo       │  Elevado  │
│ Uso en IoT │  Limitado   │  Factores    │  Recomend.  │  Impráct. │
│            │             │  de escala   │  para TSN   │  en sens. │
└────────────┴─────────────┴──────────────┴─────────────┴────────────┘

  ─────────────────────────────────────────────────────────────
  → gPTP destaca por: peer delay (no requiere switches PTP),
    perfil simplificado, y soporta topologías inalámbricas.
  ─────────────────────────────────────────────────────────────
```

#### `tab_1_1_comparativa_protocolos` (NUEVA)
- **Ubicación:** Sección 1.5
- **Descripción:** Tabla formal LaTeX con la misma información de arriba pero en formato tabular profesional. Ver `src/tables/tab_1_1_comparativa_protocolos.tex`.

---

### 3.3 Capítulo 2 — Análisis de métodos y herramientas

#### `fig_2_1_ubicaciones_ts`
- **Origen:** Base doc, Figura 2.1 — Recrear
- **Ubicación:** Sección 2.1, introducción al estampado de tiempo
- **Descripción:** Pila de protocolos vertical mostrando dónde se pueden tomar estampas de tiempo: PHY (SFD), MAC, Driver/Network, Application. Distingue hardware vs software.
- **Herramienta:** TikZ → PDF
- **ASCII:**

```
         UBICACIONES DE ESTAMPA DE TIEMPO (TS)

    ┌─────────────────────────────────────────┐
    │         APLICACIÓN (software)           │ ◄── TS por SW
    │           [t_clock()]                   │     (alta varianza)
    ├─────────────────────────────────────────┤
    │     PILA DE RED / DRIVER (software)     │ ◄── TS por SW
    │    [socket layer, OS scheduler]         │     (media varianza)
    ├─────────────────────────────────────────┤
    │        CAPA MAC (hardware/sw)           │ ◄── TS híbrido
    │     [frame detection, DMA]              │
    ├─────────────────────────────────────────┤
    │     CAPA FÍSICA - PHY (hardware)        │ ◄── TS por HW
    │   [Start-of-Frame Delimiter, SFD]       │     (ns precision)
    ├─────────────────────────────────────────┤
    │              MEDIO INALÁMBRICO          │
    │            (radio / antena)               │
    └─────────────────────────────────────────┘

    Leyenda: ████ = hardware  ░░░░ = software  ▓▓▓▓ = híbrido

    Precisión decreciente: PHY > MAC > Driver > App
```

#### `fig_2_2_latencias_sw`
- **Origen:** Base doc, Figura 2.2 — Recrear con mejor claridad
- **Ubicación:** Sección 2.1, explicación de latencias software
- **Descripción:** Diagrama temporal detallado mostrando las estampas software t̂1–t̂4, los retardos de procesamiento p1–p4, y los tiempos de propagación tms/tsm.
- **Herramienta:** TikZ → PDF
- **ASCII:**

```
  MAESTRO                                           ESCLAVO

  ┌────────┐                                        ┌────────┐
  │ t̂1     │──── p1 ────►│◄──── t_ms ────►│◄── p2 ─│ t̂2     │
  │ (emite │  TX stack     propagación         RX stack │(recibe │
  │  SW)   │  delay                         delay      │  SW)   │
  └────────┘                                        └────────┘

  ┌────────┐                                        ┌────────┐
  │ t̂4     │◄── p4 ────│◄──── t_sm ────│◄─── p3 ──│ t̂3     │
  │(recibe │  RX stack     propagación         TX stack │(emite  │
  │  SW)   │  delay                         delay      │  SW)   │
  └────────┘                                        └────────┘

  Estampas ideales (según IEEE 802.1AS §11.3.9):
  ┌────────────────────────────────────────────────────────────┐
  │  t1 = t̂1 + p1          t2 = t̂2 − p2                       │
  │  t3 = t̂3 + p3          t4 = t̂4 − p4                       │
  │                                                            │
  │  Offset estimado: θ̂ = [(t̂2−t̂1)−(t̂4−t̂3)]/2                │
  │  Error por asimetría: ε = [(p1+p2)−(p3+p4)]/2             │
  └────────────────────────────────────────────────────────────┘
```

#### `fig_2_3_matlab_escritorio`
- **Origen:** Base doc, Figura 2.3 — Actualizar
- **Ubicación:** Sección 2.4, presentación de herramientas
- **Descripción:** Captura de pantalla del entorno de desarrollo (MATLAB o GNU Octave) mostrando el editor de código, el workspace y la ventana de comandos con el simulador gPTP cargado.
- **Herramienta:** Screenshot real o mock con Python (matplotlib UI sketch)
- **ASCII:**

```
┌─────────────────────────────────────────────────────────────┐
│  MATLAB / GNU Octave — Entorno de Desarrollo                │
├──────────────┬──────────────────────────────┬───────────────┤
│  Current     │                              │  Workspace    │
│  Folder      │  gptp_asimetrico_mejorado.m  │  Name  Value  │
│  ├── matlab/ │  ─────────────────────────   │  dur    60    │
│  ├── resul/  │  1  function [sync, prec]    │  dist   30    │
│  └── ...     │  2     % Simulador gPTP      │  Nsim   500   │
│              │  3     rng(42);              │               │
│              │  4     ...                   │  Command      │
│              │                              │  History      │
│              │                              │  >> gptp_m... │
│              │                              │  Elapsed: ... │
│              │                              │  Prec: 66.24µs│
├──────────────┴──────────────────────────────┴───────────────┤
│  Figure 1: Precisión del sincronismo — 3 escenarios         │
│  [line plot showing symmetric vs asymmetric vs corrected]   │
└─────────────────────────────────────────────────────────────┘
```

#### `fig_2_4_metodo_hibrido` (NUEVA)
- **Ubicación:** Sección 2.3, descripción del método seleccionado (Exel + AKF)
- **Descripción:** Diagrama de bloques de dos etapas: Etapa 1 (Exel, corrección determinista) → Etapa 2 (AKF, filtrado adaptativo) → Corrección del reloj esclavo.
- **Herramienta:** TikZ → PDF
- **ASCII:**

```
┌──────────────────────────────────────────────────────────────────┐
│              MÉTODO HÍBRIDO: EXEL + AKF                          │
└──────────────────────────────────────────────────────────────────┘

  Mensajes gPTP (estampas t̂1..t̂4)
              │
              ▼
  ┌───────────────────────┐
  │   ETAPA 1: EXEL       │
  │  Corrección determi-  │
  │  nista de p1..p4      │
  │                       │
  │  θ̂_Exel = f(t̂1..t̂4,  │
  │            p1..p4)    │
  └───────────┬───────────┘
              │ z_k = θ̂_Exel
              ▼
  ┌───────────────────────┐
  │   ETAPA 2: AKF        │
  │  Filtro de Kalman     │
  │  Adaptativo (3 est.)  │
  │                       │
  │  x = [θ, skew, Δ]ᵀ   │
  │  R_k adaptativo       │
  │                       │
  │  θ̂_AKF = KF_update()  │
  └───────────┬───────────┘
              │
              ▼
  ┌───────────────────────┐
  │  CORRECCIÓN RELOJ     │
  │      ESCLAVO          │
  │  t_slave ← t_slave +  │
  │           θ̂_AKF       │
  └───────────────────────┘
```

#### `fig_2_5_ciclo_akf` (NUEVA)
- **Ubicación:** Sección 2.3.3, explicación del algoritmo AKF
- **Descripción:** Diagrama de flujo del ciclo de predicción-actualización del Filtro de Kalman Adaptativo con ventana deslizante para R_k.
- **Herramienta:** TikZ → PDF
- **ASCII:**

```
┌─────────────────────────────────────────────────────────────┐
│           CICLO DEL FILTRO DE KALMAN ADAPTATIVO              │
└─────────────────────────────────────────────────────────────┘

  Inicialización:
  ┌─────────────┐
  │ x₀, P₀, Q₀, │
  │ R₀, N=20    │
  └──────┬──────┘
         │
         ▼
  ┌──────────────────┐
  │  PREDICCIÓN      │
  │  x̂ₖ⁻ = F·x̂ₖ₋₁   │
  │  Pₖ⁻ = F·Pₖ₋₁·Fᵀ │
  │       + Q        │
  └────────┬─────────┘
           │
           ▼
  ┌──────────────────┐       ┌─────────────────────┐
  │ MEDICIÓN: zₖ =   │◄─────│ Ventana deslizante  │
  │ θ̂_Exel (offset   │       │ {zₖ₋ₙ₊₁..zₖ}        │
  │ corregido)       │       │                     │
  └────────┬─────────┘       │ Rₖ = var(innovac.) │
           │                  │ sobre N muestras    │
           ▼                  └─────────────────────┘
  ┌──────────────────┐
  │  ACTUALIZACIÓN   │
  │  yₖ = zₖ − H·x̂ₖ⁻ │  ← innovación
  │  Kₖ = Pₖ⁻·Hᵀ·    │
  │       (H·Pₖ⁻·Hᵀ+  │
  │        Rₖ)⁻¹      │
  │  x̂ₖ = x̂ₖ⁻ + Kₖ·yₖ│
  │  Pₖ = (I−Kₖ·H)·Pₖ⁻│
  └────────┬─────────┘
           │
           ▼
  ┌──────────────────┐
  │  SALIDA: θ̂_AKF   │─────► Corrección del
  │  = x̂ₖ[1] (offset)│       reloj esclavo
  └──────────────────┘
           │
           └──────────────────────┐
                                  │
         ┌────────────────────────┘
         │  k ← k+1
         └────────────────────────► [PREDICCIÓN]
```

#### `fig_2_6_arquitectura_filtros` (NUEVA)
- **Ubicación:** Sección 2.2.2, comparativa visual de métodos basados en Kalman
- **Descripción:** Diagrama comparativo mostrando 4 variantes de filtros (KF estándar, EKF, AKF, Particle Filter) con sus ventajas/limitaciones.
- **Herramienta:** TikZ → PDF
- **ASCII:**

```
┌────────────────────────────────────────────────────────────────┐
│         ESPECTRO DE MÉTODOS DE FILTRADO PARA gPTP             │
└────────────────────────────────────────────────────────────────┘

  Complejidad ◄──────────────────────────────────────► Precisión
       │                                               │
       │   ┌─────────┐                                 │
       ├──►│ KF std  │  Lineal, Gaussiano              │
       │   │ [θ,skew]│  R fijo                         │
       │   └─────────┘                                 │
       │       │                                       │
       │   ┌───┴───────┐                               │
       ├──►│    AKF    │  Lineal, Gaussiano            │
       │   │[θ,skew,Δ]│  R_k adaptativo ◄── SELECCIONADO
       │   │  ventana  │  Robustez a outliers          │
       │   │  N=20     │                                 │
       │   └───────────┘                                 │
       │       │                                         │
       │   ┌───┴─────────┐                               │
       ├──►│     EKF     │  No lineal                    │
       │   │  Jacobiano  │  Mayor costo computacional    │
       │   └─────────────┘                               │
       │       │                                         │
       │   ┌───┴───────────┐                             │
       └──►│ Particle Filter│  Multimodal, no Gaussiano   │
           │   (SMC)       │  Costo muy alto             │
           └───────────────┘                             │

  Criterio de selección: mejor relación precisión/complejidad
  para entornos inalámbricos con recursos limitados.
```

#### `tab_2_2_comparacion_metodos`
- **Origen:** Nueva — Ya existe en `02-analisis-metodos-herramientas.md`
- **Ubicación:** Sección 2.2
- **Descripción:** Tabla comparativa de 15 métodos en 7 categorías con 5 criterios de evaluación.
- **Herramienta:** LaTeX `tabularx` o `longtable` → `src/tables/tab_2_2_comparacion_metodos.tex`
- **Estado:** Pendiente conversión a `.tex`

#### `tab_2_3_parametros_akf`
- **Origen:** Nueva
- **Ubicación:** Sección 2.3.4
- **Descripción:** Tabla con los parámetros del AKF: matrices P₀, Q₀, R₀, ventana N, condiciones iniciales.
- **Herramienta:** LaTeX `tabular` → `src/tables/tab_2_3_parametros_akf.tex`
- **ASCII:**

```
┌─────────────────────┬────────────────────────────┬──────────────────┐
│ Parámetro           │ Valor / Matriz             │ Descripción      │
├─────────────────────┼────────────────────────────┼──────────────────┤
│ Vector estado x₀    │ [0, 0, 0]ᵀ                 │ [θ, skew, Δ]     │
│ P₀                  │ diag(10⁻¹⁰, 10⁻¹², 10⁻¹⁴) │ Cov. inicial     │
│ Q                   │ diag(10⁻¹⁴, 10⁻¹⁸, 10⁻¹⁶) │ Ruido de proceso │
│ R₀                  │ 10⁻¹²                      │ Ruido medición   │
│ Ventana N           │ 20                         │ Innovaciones     │
│ F (transición)      │ [[1,Δt,0],[0,1,0],[0,0,1]]│ Modelo dinámico  │
│ H (observación)     │ [1, 0, 0]                  │ Mide solo θ      │
└─────────────────────┴────────────────────────────┴──────────────────┘
```

---

### 3.4 Capítulo 3 — Implementación y resultados

#### `fig_3_1_esquema_implementacion`
- **Origen:** Base doc, Figura 3.1 — Recrear y ampliar
- **Ubicación:** Sección 3.1.1
- **Descripción:** Diagrama de bloques del escenario de simulación: dos dispositivos (maestro/esclavo), enlace inalámbrico, distancia d, velocidad c, retardos Tms/Tsm, componente asimétrico ta. Para la nueva tesis debe incluir el bloque AKF en el esclavo.
- **Herramienta:** TikZ → PDF
- **ASCII (versión ampliada):**

```
         VERSIÓN REFERENCIA (Exel)      VERSIÓN MEJORADA (Exel + AKF)

   ┌─────────┐    t_ms, t_sm      ┌─────────┐
   │ MAESTRO │◄───────┬──────────►│ ESCLAVO │
   │  (GM)   │   d=30m│           │ + AKF   │
   │         │   c=3e8│           │         │
   │  Sync   │        │           │  Sync   │
   │FollowUp │        ▼ ta         │FollowUp │
   │PdelayR..│◄──── asimetría ────►│Pdelay.. │
   └─────────┘     (aleatoria)     └────┬────┘
                                        │
                                   ┌────┴────┐
                                   │  ETAPA  │
                                   │  Exel   │──► θ̂_Exel
                                   │(p1..p4) │
                                   └────┬────┘
                                        │ z_k
                                   ┌────┴────┐
                                   │  ETAPA  │
                                   │   AKF   │──► θ̂_AKF
                                   │(3 est.) │──► corrección
                                   └─────────┘    reloj
```

#### `fig_3_2_precision_tiempo`
- **Origen:** Base doc, Figura 3.2 — Regenerar con datos actuales
- **Ubicación:** Sección 3.2.1
- **Descripción:** Gráfica de líneas con precisión (µs) vs tiempo (s) para 3 escenarios: simétrico (verde), asimétrico sin corrección (rojo), asimétrico con Exel (azul).
- **Herramienta:** MATLAB → `plot_resultados.m` modificado → PDF vectorial (`exportgraphics` con formato PDF)
- **ASCII:**

```
Precisión [µs]
    │
170 ┤                                          ╱───  asimétrico sin corr.
    │                                    ╱──────╱
150 ┤                              ╱────╱
    │                        ╱─────╱
130 ┤                  ╱────╱
    │            ╱─────╱
120 ┤      ╱────╱                              ·····  asimétrico + Exel
    │  ╱───╱                              ······
100 ┤─╱                              ·········
    │                           ·········
 90 ┤  ════════════════════════════════════  simétrico (referencia)
    │
 50 ┤
    └┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬──► t [s]
     0    5   10   15   20   25   30   35   40   45   50   55   60

  Leyenda: ─── asimétrico sin corrección  ····· asimétrico + Exel
            ═══ simétrico (ideal)
```

#### `fig_3_3_offset_tiempo`
- **Origen:** Base doc, Figura 3.3 — Regenerar y ampliar con AKF
- **Ubicación:** Sección 3.2.1 (análisis de offset)
- **Descripción:** Gráfica de líneas con offset (µs) vs tiempo (s). Debe mostrar: (a) comportamiento inicial con pico de 13.43 ms y convergencia a rango [-2.55, 6.68] µs para Exel; (b) línea adicional para AKF mostrando convergencia más estrecha.
- **Herramienta:** MATLAB → PDF
- **ASCII:**

```
Offset [µs]
    │
  7 ┤                              ·····························  Exel
    │                    ╱╲      ································  AKF
  5 ┤                  ╱    ╲  ··································· (más
    │                ╱        ╲···································  estable)
  2 ┤              ╱          ····································
    │    ╱╲      ╱           ·····································
  0 ┤───╱  ╲────╱────────········································
    │  ╱      ╲╱       ··········································
 -2 ┤╱              ·············································
    │           ·················································
 -5 ┤      ······················································
    │  ··························································
    └┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬──► t [s]
     0    5   10   15   20   25   30   35   40   45   50   55   60

     ╱╲  = transitorio inicial (13.43 ms → escala no mostrada)
     tras 4 s: estabilización en banda ±7 µs (Exel) vs ±4 µs (AKF)
```

#### `fig_3_4_tiempo_ejecucion` y `fig_3_5_overhead_porcentaje`
- **Origen:** Base doc, Figuras 3.4 y 3.5 — Regenerar con datos actuales
- **Ubicación:** Sección 3.2.1 (overhead computacional)
- **Descripción:** 3.4 = líneas/barras de tiempo de ejecución (s) vs N simulaciones (1, 10, 100, 500, 1000). 3.5 = porcentaje de overhead relativo.
- **Herramienta:** MATLAB → PDF
- **Nota:** Para la nueva tesis, añadir curva/barra para Exel+AKF.
- **ASCII (fig 3.4):**

```
Tiempo [s]
    │
400 ┤                                          ████  Estándar
    │                                          ████
350 ┤                              ████        ████  Exel
    │                              ████        ████
300 ┤                  ████        ████        ████
    │                  ████        ████        ████  Exel+AKF
200 ┤      ████        ████        ████        ████
    │      ████        ████        ████        ████
100 ┤      ████        ████        ████        ████
    │      ████        ████        ████        ████
  5 ┤ ████ ████        ████        ████        ████
    └┬────┬────────────┬────────────┬────────────┬──────────►
     1    10           100          500         1000   N_sim
```

#### `fig_3_6_retardos_asimetricos`
- **Origen:** Base doc, Figura 3.6 — Regenerar
- **Ubicación:** Sección 3.2.1
- **Descripción:** Dos líneas (t_ms maestro→esclavo, t_sm esclavo→maestro) mostrando que las asimetrías no se eliminan (~235 µs de diferencia media).
- **Herramienta:** MATLAB → PDF
- **ASCII:**

```
Retardo [µs]
    │
250 ┤ ═══════════════════════════════════════════════════════  t_ms
    │ ╭─╮ ╭─╮ ╭─╮ ╭─╮ ╭─╮ ╭─╮ ╭─╮ ╭─╮ ╭─╮ ╭─╮ ╭─╮ ╭─╮
240 ┤╭╯ ╰╮╰─╯╰─╯╰─╯╰─╯╰─╯╰─╯╰─╯╰─╯╰─╯╰─╯╰─╯╰─╯╰─╯╰─╯╰──  t_sm
    │╯    ╰╮                                                 ╭─╮
230 ┤      ╰────────────────────────────────────────────────╯ ╰─
    │
    └┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬──► t [s]
     0    5   10   15   20   25   30   35   40   45   50   55   60

  t_asym = |t_ms − t_sm| ≈ 235 µs (constante en media)
```

#### `fig_3_7_estimacion_error`
- **Origen:** Base doc, Figura 3.7 — Regenerar
- **Ubicación:** Sección 3.2.1
- **Descripción:** Gráfica de barras de error mostrando intervalos de confianza del 95% y 99% para las métricas principales (precisión, offset, asimetría).
- **Herramienta:** MATLAB → PDF
- **ASCII:**

```
Error estimado [%]
    │
  6 ┤                                        ┃
    │                                        ┃ IC 99%
  5 ┤      ┃                                 ┃
    │      ┃ IC 99%                           ┃
  4 ┤      ┃      ┃                          ┃
    │      ┃      ┃ IC 95%                   ┃
  3 ┤      ┃      ┃      ┃                   ┃
    │      ┃      ┃      ┃                   ┃
  2 ┤──────┃──────┃──────┃───────────────────┃──────
    │      ┃      ┃      ┃                   ┃
    └┬─────────────┬─────────────┬─────────────┬──────────────►
     Precisión    Offset      Asimetría    Overhead

     Media IC95%: 3.59%    Media IC99%: 4.66%
```

#### `fig_3_8_precision_4escenarios` (NUEVA)
- **Ubicación:** Sección 3.2.2
- **Descripción:** Extensión de Fig 3.2 con 4 líneas: simétrico, asimétrico sin corr., asimétrico + Exel, asimétrico + Exel + AKF. Debe resaltar que AKF se acerca al simétrico.
- **Herramienta:** MATLAB → PDF
- **ASCII:**

```
Precisión [µs]
    │
160 ┤                                          ·············  sin corr.
    │                                    ···················
140 ┤                              ·························
    │                        ·······························
120 ┤                  ·····································
    │            ···········································  Exel
100 ┤      ·················································
    │  ·····················································
 80 ┤·······················································
    │·······················································  AKF
 60 ┤·······················································
    │·······················································
 40 ┤════════════════════════════════════════════════════════  simétrico
    │
    └┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬──► t [s]
     0    5   10   15   20   25   30   35   40   45   50   60

  AKF reduce la precisión media a 66.24 µs (vs 101.5 µs de Exel)
```

#### `fig_3_9_offset_comparativo` (NUEVA)
- **Ubicación:** Sección 3.2.2
- **Descripción:** Dos subplots comparando la distribución del offset estabilizado: histograma de Exel vs histograma de Exel+AKF. El AKF debe mostrar una distribución más estrecha centrada en cero.
- **Herramienta:** MATLAB → PDF
- **ASCII:**

```
  EXEL (referencia)                EXEL + AKF (mejorado)

  frec. │                            frec. │
   80   │    ██                        100│       ██
   60   │   ████                        80│      ████
   40   │  ██████                       60│     ██████
   20   │ ████████                      40│    ████████
    0   └────────────► [µs]             20│   █████████
       -5   0   5   10                   0└────────────────► [µs]
       μ=1.27  σ=5.89                       -5  -2   0   2   5
                                           μ=0.15  σ=2.1
```

#### `fig_3_10_boxplot_metodos` (NUEVA)
- **Ubicación:** Sección 3.2.3
- **Descripción:** Diagrama de cajas comparando los 4 escenarios (ya parcialmente implementado en `plot_resultados.m` como `figura_boxplot.png`). Mejorar con formato publicación y añadir 4ª caja para AKF.
- **Herramienta:** MATLAB → PDF
- **ASCII:**

```
Precisión [µs]
    │
170 ┤                                    ○ outlier
    │
160 ┤           ┌─┐
    │           │ │
150 ┤           │ │      ┌─┐
    │           │ │      │ │
140 ┤           │ │      │ │
    │           │ │      │ │
130 ┤           │ │      │ │
    │           │ │      │ │
120 ┤           │ │      │ │     ┌─┐
    │           │ │      │ │     │ │
110 ┤           │ │      │ │     │ │
    │           │ │      │ │     │ │
100 ┤           │ │      │ │     │ │     ┌─┐
    │           │ │      │ │     │ │     │ │
 90 ┤           │ │      │ │     │ │     │ │
    │           │ │      │ │     │ │     │ │
 80 ┤  ┌─┐      │ │      │ │     │ │     │ │
    │  │ │      │ │      │ │     │ │     │ │
 70 ┤  │ │      │ │      │ │     │ │     │ │
    │  │ │      │ │      │ │     │ │     │ │
 60 ┤  │ │      │ │      │ │     │ │     │ │
    │  │ │      │ │      │ │     │ │     │ │
 50 ┤──┴─┴──────┴─┴──────┴─┴─────┴─┴─────┴─┴───────────────────
       Sim.    Asim.    Asim.    Asim.
      (ideal) sin cor.  + Exel   + AKF

  Medias:  49.6    150.1    100.3     66.2  µs
```

#### `fig_3_11_convergencia_montecarlo` (NUEVA)
- **Ubicación:** Sección 3.2.3 o Apéndice de validación estadística
- **Descripción:** Curvas de convergencia de Monte Carlo mostrando cómo la media acumulada se estabiliza con N (ya implementado parcialmente en `plot_resultados.m`).
- **Herramienta:** MATLAB → PDF
- **ASCII:**

```
Precisión media acumulada [µs]
    │
105 ┤  ······················································
    │·                                          (oscila al inicio)
100 ┤   ·····················································
    │    ····················································
 98 ┤     ···················································
    │      ··················································
 97 ┤       ···················································
    │        ·················································
 96 ┤         ·················································
    │          ···············································
 95 ┤           ···············································
    │            ···············································
    └┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬──►
     0  500 1000 1500 2000 2500 3000 3500 4000 4500 5000  N_sim

     Línea horizontal punteada: μ teórica = 101.5 µs (Exel)
     La curza se estabiliza tras ~1500 simulaciones.
```

#### `fig_3_12_estados_akf` (NUEVA)
- **Ubicación:** Sección 3.2.2, análisis de estabilidad
- **Descripción:** Tres subplots mostrando la evolución temporal de los 3 estados estimados por el AKF: offset θ(t), skew s(t), y asimetría residual Δ(t).
- **Herramienta:** MATLAB → PDF
- **ASCII:**

```
  θ(t) [µs]           s(t) [ppm]           Δ(t) [µs]
    │                   │                    │
  5 ┤ ╱╲                │ 30 ┤              │ 10 ┤
    │╱  ╲               │    │  ╱╲          │    │     ╱╲
  0 ┤────╲────          │  0 ┤─╱──╲──       │  5 ┤────╱──╲────
    │     ╲╱            │ -10┤     ╲╱       │  0 ┤   ╱    ╲
 -5 ┤                   │    │              │ -5 ┤──╱──────╲──
    └┬────┬──►          │    └┬────┬──►     │    └┬────┬──►
     0   30   60 [s]    │     0   30   60   │     0   30   60 [s]

     θ converge a ~1 µs    s converge a ~20 ppm   Δ estima residuo
```

#### `fig_3_13_overhead_akf` (NUEVA)
- **Ubicación:** Sección 3.2.2, análisis de overhead
- **Descripción:** Gráfica comparativa del tiempo de ejecución adicional introducido por Exel y por AKF, mostrando que AKF añade solo ~2%.
- **Herramienta:** MATLAB → PDF
- **ASCII:**

```
Overhead relativo [%]
    │
 70 ┤  ██
    │  ██   estándar → Exel (1 simulación)
 60 ┤  ██
    │
  5 ┤       ██
    │       ██   estándar → Exel (100 simulaciones)
  4 ┤       ██
    │
  2 ┤            ██
    │            ██   Exel → Exel+AKF (adicional)
  1 ┤            ██
    │
  0 ┤────────────────────────────────────────────────────►
         1 sim.        100 sim.       500 sim.

  Conclusión: el overhead del AKF es marginal (~2%) frente
  al beneficio en precisión (+33.6% de mejora).
```

#### `tab_3_1_resultados_referencia`
- **Origen:** Nueva — Ya existe en `03-implementacion-resultados.md`
- **Ubicación:** Sección 3.2.1
- **Estado:** Pendiente conversión a `.tex`

#### `tab_3_2_overhead_exel`
- **Origen:** Nueva — Ya existe en `03-implementacion-resultados.md`
- **Ubicación:** Sección 3.2.1
- **Estado:** Pendiente conversión a `.tex`

#### `tab_3_3_resultados_mejorado`
- **Origen:** Nueva — Ya existe en `03-implementacion-resultados.md`
- **Ubicación:** Sección 3.2.2
- **Estado:** Pendiente conversión a `.tex`

#### `tab_3_4_comparacion_global`
- **Origen:** Nueva — Ya existe en `03-implementacion-resultados.md`
- **Ubicación:** Sección 3.2.3
- **Estado:** Pendiente conversión a `.tex`

---

### 3.5 Backmatter / Frontmatter

#### `tab_A_1_parametros_simulacion`
- **Origen:** Nueva
- **Ubicación:** Apéndice A
- **Descripción:** Consolidación de todos los parámetros de simulación (distancia, duración, resolución de reloj, deriva, distribuciones de retardo, etc.).
- **Herramienta:** LaTeX `tabular` → `src/tables/tab_A_1_parametros_simulacion.tex`

#### `tab_A_2_acronimos_glosario`
- **Origen:** Nueva
- **Ubicación:** Apéndice de acrónimos (`src/backmatter/acronimos.tex`)
- **Descripción:** Tabla de acrónimos ordenada alfabéticamente: TSN, gPTP, PTP, AKF, EKF, RTT, Pdelay, SO, DMA, ISR, NLoS, IoT, WSN, etc.
- **Herramienta:** LaTeX `longtable` o `glossaries` package → `src/tables/tab_A_2_acronimos_glosario.tex`
- **ASCII:**

```
┌──────────┬────────────────────────────────────────────┐
│ Acrónimo │ Definición                                 │
├──────────┼────────────────────────────────────────────┤
│ AKF      │ Adaptive Kalman Filter                     │
│ BMCA     │ Best Master Clock Algorithm                │
│ DMA      │ Direct Memory Access                       │
│ EKF      │ Extended Kalman Filter                     │
│ gPTP     │ Generalized Precision Time Protocol        │
│ ISR      │ Interrupt Service Routine                  │
│ KF       │ Kalman Filter                              │
│ NLoS     │ Non-Line-of-Sight                          │
│ Pdelay   │ Peer-to-peer Path Delay                     │
│ PTP      │ Precision Time Protocol                    │
│ RTT      │ Round-Trip Time                            │
│ SFD      │ Start-of-Frame Delimiter                   │
│ SO       │ Sistema Operativo                          │
│ TSN      │ Time-Sensitive Networking                  │
│ WSN      │ Wireless Sensor Network                    │
└──────────┴────────────────────────────────────────────┘
```

---

## 4. Estrategia de Generación por Herramienta

### 4.1 TikZ / LaTeX (figuras conceptuales y diagramas de bloques)
- **Uso:** Todas las figuras conceptuales de Capítulos 0–2 (esquemas, arquitecturas, ciclos).
- **Ventaja:** Vectorial nativo, tipografía consistente con el documento, control total.
- **Plantilla:** Crear `src/figures/template_tikz.tex` con estilos predefinidos (colores institucionales, fuentes, anchos de línea).
- **Compilación individual:** `pdflatex fig_X_Y.tex` → `fig_X_Y.pdf`.

### 4.2 MATLAB / GNU Octave (figuras de resultados)
- **Uso:** Todas las figuras del Capítulo 3 que dependen de datos de simulación.
- **Formato de salida:** PDF vectorial vía `exportgraphics(gcf, 'nombre.pdf', 'ContentType', 'vector')`.
- **Scripts a modificar/crear:**
  - `src/matlab/plot_resultados.m` → añadir exportación a PDF, 4to escenario (AKF), y figuras nuevas 3.8–3.13.
  - `src/matlab/plot_mejorado.m` → nuevo script dedicado a las figuras del método mejorado.
- **Estilo:** Fuente Times New Roman o Computer Modern (para coincidir con LaTeX), líneas de 1.5 pt, marcadores rellenos, paleta colorblind-safe (verde `#2ca02c`, rojo `#d62728`, azul `#1f77b4`, naranja `#ff7f0e`).

### 4.3 Python / matplotlib (infografías complejas y tablas visuales)
- **Uso:** Figuras que requieran composición no estándar (comparativa de protocolos, arquitectura de filtros).
- **Script:** `src/figures/generar_figuras_ch01.py`, `src/figures/generar_figuras_ch02.py`.
- **Salida:** `.pdf` vía `plt.savefig('nombre.pdf', format='pdf', bbox_inches='tight')`.
- **Ventaja:** Mayor flexibilidad para layouts complejos y subplots irregulares.

### 4.4 Mermaid (bocetos rápidos y diagramas de secuencia)
- **Uso:** Bocetos iniciales de diagramas de secuencia (gPTP message exchange) y flujos de proceso.
- **Conversión:** Mermaid CLI → SVG → Inkscape → PDF, o reimplementar en TikZ para calidad final.
- **Archivos fuente:** `src/figures/mermaid/`.

### 4.5 Tablas LaTeX
- **Uso:** Todas las tablas del documento.
- **Formato:** `booktabs` (sin líneas verticales), alineación numérica con `siunitx`, títulos en negrita.
- **Ubicación:** `src/tables/tab_X_Y_*.tex`.
- **Inclusión en capítulos:** `\input{../tables/tab_X_Y_*.tex}`.

---

## 5. Orden de Implementación Recomendado

| Prioridad | Figura/Tabla | Cap. | Dependencia | Esfuerzo |
|-----------|-------------|------|-------------|----------|
| 1 | `tab_2_2_comparacion_metodos.tex` | 2 | Texto ya existe | Bajo |
| 2 | `fig_2_4_metodo_hibrido.tex` (TikZ) | 2 | Ninguna | Medio |
| 3 | `fig_2_5_ciclo_akf.tex` (TikZ) | 2 | Ninguna | Medio |
| 4 | `fig_1_3_gptp_medicion_retardo` (TikZ) | 1 | Ninguna | Medio |
| 5 | `fig_1_1_sync_uni_vs_bidi` (TikZ) | 1 | Ninguna | Bajo |
| 6 | `fig_1_2_fuentes_error` (TikZ) | 1 | Ninguna | Medio |
| 7 | `fig_1_4_retardo_y_deriva` (TikZ) | 1 | Ninguna | Medio |
| 8 | `fig_2_1_ubicaciones_ts` (TikZ) | 2 | Ninguna | Bajo |
| 9 | `fig_2_2_latencias_sw` (TikZ) | 2 | Ninguna | Medio |
| 10 | `fig_3_1_esquema_implementacion` (TikZ) | 3 | Ninguna | Medio |
| 11 | `tab_3_1` a `tab_3_4` (.tex) | 3 | Texto ya existe | Bajo |
| 12 | `plot_resultados.m` → PDFs Ch3 base | 3 | Simulación OK | Medio |
| 13 | `plot_mejorado.m` → PDFs Ch3 AKF | 3 | `gptp_montecarlo_mejorado` | Medio |
| 14 | `fig_3_8` a `fig_3_13` (MATLAB) | 3 | Datos AKF | Medio |
| 15 | `fig_1_5_comparativa_protocolos` | 1 | Ninguna | Bajo |
| 16 | `fig_2_6_arquitectura_filtros` | 2 | Ninguna | Bajo |
| 17 | `tab_A_1`, `tab_A_2` | Back | Ninguna | Bajo |
| 18 | `fig_intro_estructura_tesis`, `fig_intro_ciclo_revt` | 0 | Ninguna | Bajo |
| 19 | `fig_2_3_matlab_escritorio` | 2 | Screenshot | Bajo |
| 20 | `tab_2_3_parametros_akf` | 2 | Parámetros definidos | Bajo |

---

## 6. Notas de Calidad y Consistencia

1. **Todas las figuras vectoriales** deben usar la misma familia tipográfica que el documento LaTeX (Latin Modern Roman o equivalente).
2. **Paleta de colores unificada:**
   - Simétrico / Ideal: verde `#2ca02c`
   - Asimétrico sin corrección: rojo `#d62728`
   - Asimétrico + Exel: azul `#1f77b4`
   - Asimétrico + Exel + AKF: naranja `#ff7f0e`
   - Líneas de referencia / grid: gris claro `#cccccc`
3. **Tamaño de figura MATLAB:** `figure('Position', [100 100 900 500])` para gráficas de línea; `[100 100 700 500]` para boxplots; usar `exportgraphics(..., 'Resolution', 300)` para PNG de respaldo.
4. **Convención de etiquetas:** Todas las figuras deben tener `\label{fig:X.Y}` y ser referenciadas en el texto antes de su aparición con `\ref{fig:X.Y}`.
5. **Convención de tablas:** Usar `\caption{...}` descriptivo en tiempo pasivo (ej.: "Comparación de métodos..." no "La tabla muestra...").
6. **Numeración coherente:** Verificar que la numeración de figuras en los `.tex` finales sea secuencial y no colisione con la del documento base. Se recomienda mantener la misma numeración del base doc para figuras heredadas y continuar con nuevos números para las nuevas.

---

## 7. Archivos de Plantilla a Crear

- `src/figures/template_tikz.tex` — Plantilla TikZ con estilos comunes (nodos, flechas, colores).
- `src/figures/template_matlab.m` — Snippet MATLAB para configuración uniforme de figuras (fuente, tamaño, colores, export PDF).
- `src/tables/template_tabla.tex` — Plantilla LaTeX para tablas con `booktabs` y `siunitx`.
