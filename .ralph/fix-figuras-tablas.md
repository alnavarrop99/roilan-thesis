# Fix Figuras, Tablas y Referencias

## Problemas Identificados

1. **Figuras exportadas en páginas Letter completas**: Octave exporta en 8.5"x11" con bordes blancos.
2. **Tablas que sobrepasan el ancho de página**: Múltiples Overfull \hbox en los logs (hasta 163pt).
3. **Referencias con "?"**: Posibles labels/refs desajustados entre .tex y figuras.
4. **Figuras conceptuales incompletas**: Algunas cajas/etiquetas mal posicionadas.

## Fix Plan

### Fix 1: Octave figure export — tight bounding boxes
- Add `set(gcf, 'PaperPosition', [0 0 W H]); set(gcf, 'PaperSize', [W H]);` before each `print()`.
- Convert figure pixel dimensions to inches at 150 DPI for proper sizing.
- Files: `src/figures/generar_figuras.m`, `src/matlab/plot_resultados.m`

### Fix 2: Table overflows
- Add `\usepackage{tabularx}` or use `\resizebox{\textwidth}{!}{...}` for wide tables.
- Or simplify column content to reduce width.
- Files: All `src/tables/tab_*.tex`

### Fix 3: Reference cross-checks
- Check all `\label{fig:...}` vs `\ref{fig:...}` match in .tex files
- Files: All chapter .tex files

### Fix 4: Figure content completeness
- Review each generated PDF visually via pdftotext
- Fix missing elements in Octave scripts

## Checklist
- [x] Fix 1: generar_figuras.m — tight PaperPosition/PaperSize for all figures ✓
- [x] Fix 1: plot_resultados.m — tight PaperPosition/PaperSize for all result figures ✓
- [x] Regenerate all figures and verify size is correct ✓
- [x] Fix 2: tab_2_2_comparacion_metodos.tex — resizebox applied ✓
- [x] Fix 2: tab_1_1, tab_2_3, tab_3_1-3.4, tab_A_1 — all wrapped with resizebox ✓
- [x] Fix 2: acronimos.tex — resizebox applied ✓
- [x] Fix 2: Sección título 2.4.3 acortado (48pt overflow eliminated) ✓
- [x] Fix 3: All \label{fig:} match \ref{fig:} in chapter .tex files ✓
- [x] Fix 3: _wrapper.tex — fixed bib path, all chapter PDFs have 0 [?] ✓
- [x] Fix 4: Review all figure content — all have legible labels ✓
- [x] Recompile thesis.pdf — 57pp, only 3 Overfull < 8pt (barely visible) ✓
- [x] Recompile all individual chapter PDFs — 0 [?] refs each ✓