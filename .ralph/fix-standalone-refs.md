# Fix: Referencias [?] en PDFs individuales + Overflows restantes

## Problemas detectados (ver .ralph/PLAN_CORRECCION.md)

### C2: Capítulos individuales compilados con wrapper muestran "[?]" 
Causa: _wrapper.tex no ejecuta bibtex, por lo que las citas quedan sin resolver.
Fix: Modificar _wrapper.tex y recompilar todos los capítulos.

### M1: 3 Overfull \hbox remanentes (0.76pt, 2.65pt, 7.93pt)
Muy menores, barely visibles. Opcional corregir.

## Checklist

### Iter 1: Fix C2
- [ ] Modificar `_wrapper.tex` para incluir `\bibliography{../../thesis}` en el preámbulo
- [ ] Recompilar wrapper para cada capítulo (00-05) con pdflatex+bibtex+pdflatex+pdflatex
- [ ] Verificar con pdftotext en cada capítulo que NO aparezca "[?]"
- [ ] Si quedan [?], iterar

### Iter 2: Overflows menores (opcional)
- [ ] Ajustar texto en ch03 3.2.2 (2.65pt overflow)
- [ ] Ajustar texto en ch03 3.3 (7.93pt overflow)  
- [ ] Recompilar thesis.pdf y verificar 0 Overfull

### Iter 3: Regeneración final
- [ ] Regenerar figuras conceptuales (generar_figuras.m)
- [ ] Regenerar figuras resultados (plot_resultados.m)
- [ ] Recompilar thesis.pdf
- [ ] Recompilar todos los capítulos individuales
- [ ] Commit