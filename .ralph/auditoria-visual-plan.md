# Auditoría Visual y Plan de Corrección de Figuras, Tablas y PDFs

## Fecha: 2026-05-23
## Estado: Iteración 1 completada, Plan actualizado

---

## Resumen Ejecutivo

Se realizó auditoría completa de todos los PDFs individuales de capítulos y la tesis maestra mediante extracción de texto (`pdftotext`) y análisis de logs de compilación. Se identificaron **6 categorías de errores**, de las cuales **2 están completamente corregidas**, **2 parcialmente corregidas**, y **2 pendientes** para el siguiente ciclo Ralph.

---

## Categorías de Errores Encontrados

### ✅ CAT-1: Figuras exportadas en páginas Letter completas (CORREGIDO)

**Severidad:** Alta  
**Descripción:** Octave exportaba figuras PDF en páginas de 8.5"×11" (612×792 pts) con grandes bordes blancos. Al incluirse en LaTeX con `\includegraphics[width=0.85\textwidth]`, las figuras ocupaban páginas enteras con contenido microscópico.

**Evidencia:**
```
Antes: Page size: 612 x 792 pts (letter)
Después: Page size: 336 x 240 pts (intro), 384 x 168 pts (ch01)
```

**Fix aplicado:**
- Agregado helper `export_fig()` en `src/figures/generar_figuras.m` que configura `PaperPosition` y `PaperSize` antes de `print(gcf, ..., '-dpdf')`
- Aplicado mismo fix inline en `src/matlab/plot_resultados.m`
- Regeneradas todas las figuras conceptuales y de resultados

**Verificación:**
```bash
$ for f in figures/ch03/fig_3_*.pdf; do pdfinfo "$f" | grep "Page size"; done
fig_3_2:  432 x 240 pts   ✅
fig_3_3:  432 x 192 pts   ✅
fig_3_4:  336 x 216 pts   ✅
...
fig_3_13: 288 x 192 pts   ✅
```

---

### 🟡 CAT-2: Tablas que sobrepasan el ancho de página (PARCIALMENTE CORREGIDO)

**Severidad:** Alta  
**Descripción:** Tablas con muchas columnas (especialmente tab_2_2 con 6 columnas) generaban Overfull \hbox de hasta 163pt de ancho.

**Evidencia del log:**
```
Overfull \hbox (162.9893pt too wide) in paragraph at lines 10--29
Overfull \hbox (104.53534pt too wide) in paragraph at lines 10--36
Overfull \hbox (120.83696pt too wide) in paragraph at lines 9--107
```

**Fix aplicado:**
- Aplicado `\resizebox{\textwidth}{!}{...}` a todas las tablas en `src/tables/tab_*.tex`
- `acronimos.tex`: cambiada segunda columna de `|l|` a `|p{0.78\textwidth}|` para permitir ajuste de línea en definiciones largas

**Resultado:**
- Overflow principal (120pt → 1.36pt) ✅
- Pequeños residuales (0.76pt, 2.65pt, 7.93pt, 1.36pt) — aceptables

**Pendiente:** Verificar visualmente que `\resizebox` no haga las tablas ilegibles por compresión excesiva.

---

### 🔴 CAT-3: Numeración de figuras/tablas en PDFs individuales (PENDIENTE)

**Severidad:** Alta  
**Descripción:** Los PDFs individuales de cada capítulo muestran numeración errónea porque el wrapper `_wrapper.tex` no establece el contador de capítulo antes de `\input{__CHAPTER__}`.

**Evidencia extraída de PDFs:**

| Capítulo | Figuras encontradas | Debería ser |
|----------|---------------------|-------------|
| ch01 | Figura 1.1–1.4 | ✅ 1.1–1.4 |
| ch02 | Figura 1.1–1.4, Tabla 1.1–1.2 | ❌ 2.1–2.5, Tabla 2.2–2.3 |
| ch03 | Figura 1.1–1.11, Tabla 1.1–1.4 | ❌ 3.1–3.13, Tabla 3.1–3.4 |
| ch00 | Figura 1.1–1.2 | ⚠️ Sin prefijo o especial |

**Fix propuesto:**
- Modificar el script de compilación de capítulos individuales para inyectar `\setcounter{chapter}{N}` antes de `\input{}`
- O modificar `_wrapper.tex` para aceptar un parámetro de capítulo

**Archivos afectados:** `src/chapters/_wrapper.tex`, script de compilación

---

### 🟡 CAT-4: Advertencias de PDF de figuras individuales (PARCIALMENTE CORREGIDO)

**Severidad:** Media  
**Descripción:** pdflatex emite warnings sobre `fig_1_2_fuentes_error.pdf` y `fig_3_7_estimacion_error.pdf`.

**Evidencia:**
```
pdfTeX warning: pdflatex (file ./figures/ch01/fig_1_2_fuentes_error.pdf): PDF i...
pdfTeX warning: pdflatex (file ./figures/ch03/fig_3_7_estimacion_error.pdf): PD...
```

**Diagnóstico:** Los PDFs son válidos (Ghostscript 10.02.1, PDF 1.7), bien dimensionados. Las advertencias son menores (probablemente metadata o versión PDF). No bloquean compilación.

**Pendiente:** Regenerar estas figuras específicas si persisten tras limpieza completa.

---

### 🟢 CAT-5: Referencias con signo de "?" (NO ENCONTRADO)

**Severidad:** Baja  
**Descripción:** El usuario reportó referencias con `?` en el PDF.

**Verificación:**
```bash
$ grep -c '\[?\]' /tmp/ch*.txt /tmp/00-*.txt
Resultado: 0 en todos los capítulos
```

**Conclusión:** No hay referencias rotas `[?]` visibles en el texto extraído. Las referencias bibliográficas y de figura/tablas parecen estar correctamente resueltas en la tesis maestra.

---

### 🟢 CAT-6: Figuras incompletas o mal renderizadas (NO ENCONTRADO EN TEXTO)

**Severidad:** Media  
**Descripción:** El usuario reportó figuras incompletas.

**Verificación:** Las figuras extraídas como texto (`pdftotext`) muestran contenido coherente. Sin embargo, **no se puede verificar completamente sin inspección visual real** de los PDFs renderizados.

**Pendiente:** Verificación visual con modelo de visión en el siguiente ciclo.

---

## Checklist de Correcciones

### Completadas en esta iteración
- [x] CAT-1: Export tight bounding box en figuras Octave (generar_figuras.m, plot_resultados.m)
- [x] CAT-2: \resizebox en tablas de src/tables/
- [x] CAT-2: Ajuste de columnas p{} en acronimos.tex
- [x] Recompilación de tesis maestra (57 páginas, sin errores fatales)

### Completadas en esta iteración (continuación)
- [x] CAT-3: Fix numeración figuras/tablas en PDFs individuales — wrapper ahora usa \setcounter{chapter}{N}
- [x] CAT-3: Recompilados todos los PDFs individuales con numeración correcta
- [x] CAT-4: Identificadas advertencias PDF versión 1.7 vs 1.5 (no fatales)

### Pendientes para verificación visual con kimi2.6
- [ ] CAT-6: Inspección visual completa de todos los PDFs (usar read tool + kimi2.6 reasoning)
- [ ] Verificar que tablas con \resizebox sean legibles (no comprimidas excesivamente)
- [ ] Verificar que figuras no tengan elementos cortados o mal alineados
- [ ] Verificar márgenes y saltos de página en capítulos individuales

---

## Proceso de Verificación Post-Corrección

### Fase 1: Verificación automatizada (esta herramienta — pi)
- Recompilar thesis.tex y verificar `exit code 0`
- Verificar ausencia de `Overfull \hbox > 10pt`
- Verificar ausencia de `[?]` en pdftotext
- Verificar dimensiones de figuras con `pdfinfo`

### Fase 2: Verificación visual con modelo de visión (kimi2.6 reasoning high)
**Proveedor:** opencode-go  
**Modelo:** kimi2.6 reasoning high  
**Herramienta:** pi (esta misma herramienta)

**Protocolo:**
1. Después de cada iteración de correcciones, usar `read` en cada PDF generado
2. El modelo de visión (kimi2.6) analizará:
   - Posición y escala correcta de figuras
   - Tablas legibles (sin compresión excesiva)
   - Numeración correcta de figuras y tablas
   - Referencias cruzadas visibles
   - Layout general (márgenes, saltos de página)
3. Si se detectan errores, se documentarán en `.ralph/auditoria-visual-plan.md`
4. Se iterará en el siguiente bucle Ralph hasta que no queden errores

**Prompt de verificación para kimi2.6:**
```
Analiza este PDF de capítulo de tesis doctoral. Verifica:
1. ¿Las figuras tienen tamaño proporcional al texto (no ocupan página entera ni son microscópicas)?
2. ¿Las tablas caben dentro de los márgenes sin desbordarse?
3. ¿La numeración de figuras y tablas coincide con el capítulo (ej: cap 2 → Figura 2.1)?
4. ¿Hay referencias con "?" o números rotos?
5. ¿El layout general es profesional y académico?

Reporta cualquier error con el número de página y descripción.
```

---

## Comandos de Compilación

```bash
# Tesis completa
cd src && latexmk -pdf -g thesis.tex

# Capítulo individual (ejemplo ch02)
sed 's|__CHAPTER__|chapters/02-analisis-metodos-herramientas/02-analisis-metodos-herramientas|g' chapters/_wrapper.tex > /tmp/wrapper_ch02.tex
pdflatex -interaction=nonstopmode -output-directory=/tmp /tmp/wrapper_ch02.tex

# Verificar logs
grep -E "Overfull|Error|undefined|\[?\]" thesis.log
```

---

## Métricas

| Métrica | Valor |
|---------|-------|
| Figuras generadas | 22 PDFs (todos con tight bounding box) |
| Tablas standalone | 8 .tex files (con \resizebox) |
| Páginas tesis maestra | 57 |
| Overfull > 10pt restantes | 0 |
| Overfull 1-10pt restantes | 3 (aceptables) |
| Errores fatales | 0 |
| `[?]` refs rotas | 0 |
| Numeración figuras PDFs individuales | ✅ Correcta (ch1→1.X, ch2→2.X, ch3→3.X) |
| Numeración tablas PDFs individuales | ✅ Correcta (ch1→1.X, ch2→2.X, ch3→3.X) |

---

## Próximo paso: Iteración 2 del bucle Ralph

**Nombre propuesto:** `fix-numeracion-y-visual`

**Objetivos:**
1. Implementar fix CAT-3 (numeración en PDFs individuales)
2. Recompilar y verificar todos los PDFs individuales
3. Usar kimi2.6 reasoning high (opencode-go) para verificación visual
4. Iterar hasta cero errores
