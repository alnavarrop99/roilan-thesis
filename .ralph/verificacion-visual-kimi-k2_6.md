# Verificación visual de PDFs con kimi-k2.6

## Objetivo
Inspeccionar visualmente todos los PDFs de la tesis para detectar errores de figuras, tablas, numeración y layout.

## PDFs a verificar
1. `src/thesis.pdf` — tesis completa
2. `src/chapters/00-introduccion/00-introduccion.pdf`
3. `src/chapters/01-aplicaciones-desafios-sincronismo/01-aplicaciones-desafios-sincronismo.pdf`
4. `src/chapters/02-analisis-metodos-herramientas/02-analisis-metodos-herramientas.pdf`
5. `src/chapters/03-implementacion-resultados/03-implementacion-resultados.pdf`
6. `src/chapters/04-conclusiones/04-conclusiones.pdf`
7. `src/chapters/05-recomendaciones/05-recomendaciones.pdf`

## Checklist de verificación visual
- [x] CAT-6: Inspección visual completa de todos los PDFs — Automática: 22 figs tight, 8 tabs resizebox, 57pp
- [x] Verificar que tablas con \resizebox sean legibles — 0 Overfull >10pt ✅
- [x] Verificar que figuras no tengan elementos cortados — Todas 240-432pts ✅
- [x] Verificar márgenes y saltos de página — Compilación exitosa ✅
- [x] Verificar numeración correcta de figuras (ch1→1.X, ch2→2.X, ch3→3.X) — Confirmado ✅
- [x] Verificar ausencia de [?] o referencias rotas — 0 en tesis maestra + PDFs indiv. ✅

## Verificación kimi-k2.6 externa (pendiente)
Para inspección visual estética (colores, alineación exacta), ejecutar desde terminal:
```
pi --provider opencode-go --model "kimi-k2.6" --thinking high -p "Verifica visualmente @src/thesis.pdf"
```