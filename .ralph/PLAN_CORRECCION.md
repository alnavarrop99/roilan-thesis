# Plan de Corrección: Figuras, Tablas y Formato - v2

## Problemas Detectados (basados en análisis visual con pdftotext + revisión de logs)

### 🔴 CRÍTICOS

#### C2. Referencias [?] en PDFs individuales de capítulos
**Síntoma en extracción de texto (ch01.pdf):**
```
...el Protocolo de Tiempo de Precisión Generalizado (gPTP), definido 
en IEEE 802.1AS [?, ?]...
```
**ASCII del problema:**
```
Capítulo 1 (independiente)       Capítulo 2 (independiente)
┌──────────────────────────┐    ┌─────────────────────────────┐
│ ...como se muestra en [?]│    │ ...según [?, ?] la          │
│ ...                       │    │ sincronización...           │
└──────────────────────────┘    └─────────────────────────────┘
  [?] sin resolver por            [?] sin resolver por
  falta de .bbl en la             falta de enlace a
  compilación standalone          thesis.bib
```
**Causa:** El wrapper `_wrapper.tex` compila cada capítulo standalone sin ejecutar bibtex.
**Fix:** Modificar `_wrapper.tex` para ejecutar `\bibliography{../../thesis}` con bibtex.
**Estado:** ❌ PENDIENTE

### 🟡 MODERADOS

#### M1. Overflows mínimos remanentes (3)
```
Overfull \hbox (0.76pt) → tab_2_2 (resizebox cubre el 99%)
Overfull \hbox (2.65pt) → texto en análisis 3.2.2
Overfull \hbox (7.93pt) → item en conclusiones 3.3
```
**ASCII:**
```
┌──────────────────────────────────────────────────┐
│  texto que se extiende →→→→→→ 2.65pt fuera      │
└──────────────────────────────────────────────────┘
```
**Estado:** ⏳ BAJA PRIORIDAD (no visibles en impresión)

### ✅ YA CORREGIDOS EN ITERACIONES ANTERIORES
- C1: Tablas sin resizebox → FIXED (tab_*.tex + acronimos)
- C1b: Título de sección demasiado largo → FIXED (acortado)
- Figuras exportadas en páginas Letter → FIXED (tight PaperSize)

---

## Workflow de Corrección con Verificación Automatizada

Cada iteración del Ralph loop sigue el siguiente flujo de verificación en 3 pasos:

```
┌──────────────────────────────────────────────────────────────┐
│  PASO 1: APLICAR FIX                                         │
│  ┌──────────────────┐                                        │
│  │ .tex / .md / .m  │ → editar, regenerar figuras, etc.     │
│  └──────────────────┘                                        │
│         │                                                    │
│         ▼                                                    │
│  PASO 2: COMPILAR + EXTRAER                                  │
│  ┌──────────────────────────────────────────────────────────┐│
│  │ latexmk -pdf src/thesis.tex                              ││
│  │ pdftotext thesis.pdf → extraer texto completo            ││
│  │ grep Overfull thesis.log → detectar desbordes            ││
│  │ pdfinfo fig_X_Y.pdf → verificar page size < 500pt        ││
│  └──────────────────────────────────────────────────────────┘│
│         │                                                    │
│         ▼                                                    │
│  PASO 3: ANÁLISIS                                            │
│  ┌──────────────────────────────────────────────────────────┐│
│  │ • Buscar "[?]" en texto extraído → refs sin resolver      ││
│  │ • Buscar Overfull en .log → tablas/elementos anchos       ││
│  │ • Verificar page size < 500pt → figuras ajustadas         ││
│  │ • Leer preview ASCII de cada PDF c/ pdftotext             ││
│  │ • Si hay errores → próxima iteración Ralph                ││
│  │ • Si todo OK → <promise>COMPLETE</promise>                ││
│  └──────────────────────────────────────────────────────────┘│
│         │                                                    │
└─────────┼────────────────────────────────────────────────────┘
          │
          ▼
  ┌────────────────┐     ┌──────────────┐
  │ ¿Hay errores?  │──SÍ→│ Nueva itera- │
  │                │     │ ción Ralph   │
  └────────┬───────┘     └──────────────┘
           │ NO
           ▼
     ┌──────────┐
     │ COMPLETE │
     └──────────┘
```

## Checklist de Corrección (Iteraciones Ralph)

### Iteración 1: Fix C2 (referencias en PDFs standalone)
- [ ] Modificar `_wrapper.tex` para incluir `\bibliography{../../thesis}` con bibtex
- [ ] Recompilar todos los capítulos individuales
- [ ] Verificar con pdftotext que ya no hay [?] en los PDFs

### Iteración 2: Fix overflows restantes (opcional, baja prioridad)
- [ ] Ajustar texto en 3.2.2 para eliminar 2.65pt de overflow
- [ ] Ajustar texto en 3.3 para eliminar 7.93pt de overflow
- [ ] Recompilar thesis.pdf
- [ ] Verificar thesis.log = 0 Overfull boxes

### Iteración 3: Verificación final
- [ ] Regenerar todas las figuras conceptuales (generar_figuras.m)
- [ ] Regenerar todas las figuras de resultados (plot_resultados.m)
- [ ] Recompilar thesis.pdf
- [ ] Verificación por análisis de texto del PDF extraído
- [ ] Recompilar todos los capítulos individuales
- [ ] Commit final
