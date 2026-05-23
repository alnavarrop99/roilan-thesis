# Work Plan — Thesis: Mejora del sincronismo en redes inalámbricas empleando el protocolo gPTP

## 1. Current Situation

### Base Thesis (Reference)
**Author:** Malcolm Daniel Eupierre Oquendo (UCLV, 2024)
**Title:** *Mejora del sincronismo en redes inalámbricas empleando el protocolo gPTP*
**Focus:** Mitigation of **asymmetric** delays in wireless networks using the Reinhard Exel correction method on gPTP.
**Key results of the original implementation:**
- Asymmetric link without correction: mean precision ≈ **152.2 µs**
- With Exel correction: mean precision ≈ **101.5 µs**
- **Error reduction: 50.7 µs (33.31% improvement)**
- Stabilized offset: between -2.554 µs and 6.675 µs (mean 1.265 µs)
- Implemented in **MATLAB** with software timestamping
- Monte Carlo simulation (3000 runs)

### Your Thesis (New Version)
- **Same title** — it is an evolution/improvement of the base thesis
- **Same chapter structure** as the reference
- **Chapter 1** — same structure and content (with minor updates and more recent references)
- **Chapters 2 and 3** — this is where the fundamental change lies
- **Focus:** Optimize and improve synchronization performance in **asymmetric wireless networks** using the gPTP protocol
  - Develop a **more optimal program** than the original
  - Incorporate **more novel techniques** (internet search, recent literature)
  - Surpass the reference results (reduce error below 50.7 µs / 33.31%)
  - Fundamentally based on the reference but expanded with new methods

---

## 2. Proposed Project Structure

```
src/
├── thesis.bib/
│   └── TD_Malcolm_Eupierre.pdf       # Reference base document
├── PLAN.md                            # This work plan
├── chapters/
│   ├── 00-introduccion/
│   │   ├── 00-introduccion.md
│   │   ├── diff.md                        # Differences vs original (see template in §4)
│   │   ├── 00-introduccion.tex
│   │   └── 00-introduccion.pdf
│   ├── 01-aplicaciones-desafios-sincronismo/
│   │   ├── 01-aplicaciones-desafios-sincronismo.md
│   │   ├── diff.md
│   │   ├── 01-aplicaciones-desafios-sincronismo.tex
│   │   └── 01-aplicaciones-desafios-sincronismo.pdf
│   ├── 02-analisis-metodos-herramientas/
│   │   ├── 02-analisis-metodos-herramientas.md
│   │   ├── diff.md
│   │   ├── 02-analisis-metodos-herramientas.tex
│   │   └── 02-analisis-metodos-herramientas.pdf
│   ├── 03-implementacion-resultados/
│   │   ├── 03-implementacion-resultados.md
│   │   ├── diff.md
│   │   ├── 03-implementacion-resultados.tex
│   │   └── 03-implementacion-resultados.pdf
│   ├── 04-conclusiones/
│   │   ├── 04-conclusiones.md
│   │   ├── diff.md
│   │   ├── 04-conclusiones.tex
│   │   └── 04-conclusiones.pdf
│   └── 05-recomendaciones/
│       ├── 05-recomendaciones.md
│       ├── diff.md
│       ├── 05-recomendaciones.tex
│       └── 05-recomendaciones.pdf
├── frontmatter/
│   ├── caratula.tex
│   ├── resumen.tex
│   ├── abstract.tex
│   └── agradecimientos.tex
├── backmatter/
│   ├── apendices.tex
│   └── acronimos.tex
├── figures/
├── tables/
├── matlab/
│   ├── gptp_asimetrico_mejorado.m    # Improved implementation (novel method)
│   ├── gptp_referencia.m             # Original Exel method replication as baseline
│   ├── gptp_montecarlo.m             # Monte Carlo simulation engine
│   ├── plot_resultados.m             # Visualization and comparative plots
│   └── README.md                     # Code documentation
├── thesis.bib                        # Consolidated bibliography
├── thesis.tex                        # Main LaTeX file
└── thesis.pdf                        # Complete compiled thesis
```

---

## 3. Core Methodology: Research → Execute → Validate → Test Cycle

Every technical component of this thesis follows a four-phase cycle:

| Phase | Description | Deliverable |
|-------|-------------|-------------|
| **Research** | Literature search, method analysis, theoretical foundation | Annotated bibliography, method comparison table, theoretical framework |
| **Execute** | Implementation of the selected method (MATLAB code, LaTeX writing) | Working code, chapter drafts, figures |
| **Validate** | Verification against reference baseline, correctness checks, Monte Carlo convergence | Validation plots, numerical comparison tables, sanity checks |
| **Test** | Systematic evaluation under multiple scenarios, stress tests, statistical significance | Final results, performance metrics, comparison with reference |

### Diff File Requirement

After each chapter's `.md` is finalized, a companion **`diff.md`** file must be created inside that chapter's directory documenting every difference between the original thesis and the new version. This diff follows a fixed template (see Section 4 for the template).

The diff file serves as:
- A traceability record for the advisor
- A justification for all changes made
- A self-review mechanism to ensure every modification is intentional

This R-E-V-T cycle is applied iteratively at three levels:
- **Micro-cycle**: Within each individual task (e.g., implementing a single filter algorithm)
- **Meso-cycle**: Within each phase (e.g., the full MATLAB implementation phase)
- **Macro-cycle**: Across the entire thesis (each chapter goes through R-E-V-T)

---

## 4. Diff File Template

Every `diff.md` file (one per chapter directory) must follow this exact structure:

```markdown
# Diff: [Chapter Name]

## Overview
[One-paragraph summary of the relationship between the original chapter and this new version]

---

## Changes by Section

### [Section Number and Name]

| # | Type | Original (Reference) | New Version | Justification |
|---|------|---------------------|-------------|---------------|
| 1 | [Added/Modified/Removed] | [Exact text or description from original] | [Exact text or description in new version] | [Why this change was made] |
| 2 | ... | ... | ... | ... |

**Change types:** `Added`, `Modified`, `Removed`, `Restructured`, `Expanded`

---

## New References Added

| # | Citation | Reason |
|---|----------|--------|
| 1 | [Author, year, title] | [Why this reference was added] |

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Sections unchanged | N |
| Sections modified | N |
| Sections added | N |
| Sections removed | N |
| New references added | N |
| References removed | N |

---

## Validation Notes
[Any cross-checking notes, discrepancies found, or decisions made during the diff process]
```

---

## 6. Development Phases

### Phase 0: Environment Setup (Day 1)

| Step | Action |
|------|--------|
| **Execute** | Create the full directory structure |
| **Execute** | Configure `thesis.tex` with complete LaTeX preamble (packages, document class, styles) |
| **Execute** | Set up `thesis.bib` with all references extracted from the base PDF |
| **Test** | Verify compilation with `latexmk`, fix any errors |

---

### Phase 1: Chapter 1 — Aplicaciones y desafíos del sincronismo (Highest Priority)

**Note:** Same structure and content as the base document. Priority deliverable for the advisor.

**Sections:**
1.1 Sincronismo en redes inalámbricas
1.2 Aplicaciones del sincronismo en IoT
1.3 Desafíos del sincronismo en redes inalámbricas
1.4 Asimetrías en los canales de comunicación
1.5 Protocolos de sincronismo (PTP, gPTP)
1.6 Conclusiones del capítulo

| Step | Action |
|------|--------|
| **Research** | Extract Chapter 1 content from the base PDF; identify sections needing updates |
| **Research** | Search for 2024-2026 references to add (new IoT sync challenges, recent gPTP developments) |
| **Execute** | Write `01-aplicaciones-desafios-sincronismo.md` (full markdown draft) |
| **Validate** | Cross-check content against base PDF for completeness and accuracy |
| **Execute** | Create `diff.md` following the Diff Template in §4 |
| **Validate** | Verify every diff entry is justified and accurate |
| **Execute** | Convert to `01-aplicaciones-desafios-sincronismo.tex` with full LaTeX formatting |
| **Test** | Compile to PDF; verify all citations resolve, no errors, formatting correct |

---

### Phase 2: Novel Methods Research — R-E-V-T

**Objective:** Find and select the most promising novel method to surpass Exel's results.

| Step | Action |
|------|--------|
| **Research** | Systematic internet search (2020-2026) covering: |
| | • Advanced synchronization for asymmetric wireless networks |
| | • Robust offset/skew estimation algorithms beyond Exel |
| | • Kalman filters applied to PTP/gPTP time synchronization |
| | • Machine learning for asymmetry detection and compensation |
| | • Statistical packet delay processing (robust regression, M-estimators) |
| | • Hybrid timestamping approaches (software + adaptive correction) |
| | • New gPTP/TSN extensions for wireless environments |
| **Research** | Create a comparison matrix: method vs. reported accuracy vs. complexity vs. compatibility |
| **Validate** | Critically evaluate each method's claims, reproducibility, and applicability to gPTP |
| **Execute** | Select the most promising method(s) and define the improvement proposal |
| **Execute** | Write the theoretical foundation for the selected method |
| **Test** | Verify the selected method is implementable in MATLAB/Octave with available resources |

**Deliverable:** Method selection document with comparison table and theoretical justification.

---

### Phase 3: Chapter 2 — Análisis de métodos y herramientas — R-E-V-T

**Modified sections:**
2.1 Sistemas de estampado por software
2.2 Análisis de modelos y metodologías existentes (expanded with novel methods found)
2.3 Descripción del método seleccionado para la mejora (new proposed method)
2.4 Herramientas de implementación (MATLAB)
2.5 Conclusiones del capítulo

| Step | Action |
|------|--------|
| **Research** | Compile all findings from Phase 2 into the chapter structure |
| **Research** | Review the original Chapter 2 structure to know what to keep vs. replace |
| **Execute** | Write `02-analisis-metodos-herramientas.md` (full markdown draft) |
| **Validate** | Cross-check all citations, verify method descriptions are accurate |
| **Execute** | Create `diff.md` following the Diff Template in §4 |
| **Validate** | Verify every diff entry is justified and accurate |
| **Execute** | Convert to `02-analisis-metodos-herramientas.tex` |
| **Test** | Compile to PDF; verify all sections, figures, tables, and citations |

---

### Phase 4: MATLAB Implementation — R-E-V-T

**Objective:** Build both the reference baseline and the novel improved implementation.

#### 4.1 Reference Baseline (Exel method replication)

| Step | Action |
|------|--------|
| **Research** | Study the original Exel method implementation details from the PDF (Section 3.1) |
| **Execute** | Code `gptp_referencia.m` — replicate gPTP + Exel correction in MATLAB |
| **Execute** | Code `gptp_montecarlo.m` — Monte Carlo simulation engine (3000 runs) |
| **Execute** | Code `plot_resultados.m` — plotting and visualization routines |
| **Validate** | Run baseline simulation and verify results match the reference PDF (≈101.5 µs precision) |
| **Validate** | Check: mean precision, std dev, offset range, convergence time |
| **Test** | Test with different random seeds to ensure statistical stability |
| **Test** | Document any deviations from the reference and their justification |

#### 4.2 Novel Improved Implementation

| Step | Action |
|------|--------|
| **Research** | Finalize the novel algorithm design based on Phase 2 findings |
| **Execute** | Code `gptp_asimetrico_mejorado.m` — implement the new method |
| **Execute** | Integrate with the Monte Carlo engine from 4.1 |
| **Validate** | Run initial tests: check for bugs, numerical stability, convergence |
| **Validate** | Compare against baseline under identical conditions |
| **Test** | Full Monte Carlo campaign (3000+ runs) |
| **Test** | Evaluate: mean precision, std dev, error reduction %, convergence time, overhead |
| **Test** | Stress test under varying asymmetry levels (mild, moderate, severe) |
| **Test** | Statistical significance test (t-test or similar) vs. baseline |

**Deliverable:** Working MATLAB code with documented results and comparative plots.

---

### Phase 5: Chapter 3 — Implementación y Resultados — R-E-V-T

3.1 Características de la implementación
3.2 Análisis de resultados (comparative: reference vs. proposed improvement)
3.3 Conclusiones del capítulo

| Step | Action |
|------|--------|
| **Research** | Organize all simulation results, plots, and numerical data from Phase 4 |
| **Execute** | Write `03-implementacion-resultados.md` describing: |
| | • Implementation architecture and key differences from Exel |
| | • Results presentation (tables, figures, comparative plots) |
| | • Quantitative analysis of improvements |
| **Validate** | Verify all figures are correctly referenced, tables are accurate |
| **Validate** | Double-check all numerical claims against raw simulation data |
| **Execute** | Create `diff.md` following the Diff Template in §4 |
| **Validate** | Verify every diff entry is justified and accurate |
| **Execute** | Convert to `03-implementacion-resultados.tex` |
| **Test** | Compile to PDF; check all cross-references, citations, figure placement |

---

### Phase 6: Conclusions and Recommendations — R-E-V-T

4. Conclusiones
5. Recomendaciones

| Step | Action |
|------|--------|
| **Research** | Review all results and extract key findings |
| **Execute** | Write conclusions (contributions, findings, limitations) |
| **Execute** | Write recommendations (future work, practical applications) |
| **Validate** | Ensure conclusions are directly supported by results |
| **Execute** | Create `diff.md` for both sections following the Diff Template in §4 |
| **Validate** | Verify every diff entry is justified and accurate |
| **Execute** | Create `.md` → `.tex` → `.pdf` for both sections |

---

### Phase 7: Frontmatter, Backmatter, and Final Compilation — R-E-V-T

| Step | Action |
|------|--------|
| **Research** | Check institutional formatting requirements |
| **Execute** | Create caratula.tex, resumen.tex, abstract.tex, agradecimientos.tex |
| **Execute** | Create apendices.tex, acronimos.tex |
| **Execute** | Compile complete thesis (`latexmk -pdf src/thesis.tex`) |
| **Validate** | Full review: spelling, grammar, formatting, citation consistency |
| **Test** | Check for LaTeX errors, overfull boxes, unresolved references |
| **Test** | Final PDF output verification |

---

## 7. Technical Strategy

### 5.1. Baseline (Reference)
| Metric | Value |
|---------|-------|
| Method | Reinhard Exel correction |
| Precision without correction (asymmetric) | 152.2 µs |
| Precision with Exel correction | 101.5 µs |
| Error reduction | 50.7 µs (33.31%) |
| Stabilized offset | [-2.554, 6.675] µs, mean 1.265 µs |
| Convergence time | ~4 s (2 gPTP periods) |
| Standard deviation (with correction) | 14.78 µs |

### 5.2. Improvement Directions (To Research)

| # | Technique | Description |
|---|-----------|-------------|
| 1 | **Extended Kalman Filter (EKF)** | Jointly estimate offset, skew, and channel asymmetry in real time, surpassing Exel's static estimation |
| 2 | **Particle Filter / SMC** | Handle non-Gaussian and multimodal delay distributions typical in NLoS environments |
| 3 | **Adaptive Sliding Window with Weighting** | Dynamically weight PDelay measurements based on estimated quality |
| 4 | **Robust Regression (M-estimation)** | Use Huber/Tukey estimators to reject outliers in delay measurements |
| 5 | **Lightweight Neural Network** | Predict asymmetry from signal features (RSSI, SNR, error rate) |
| 6 | **Fuzzy Logic Controller** | Adaptively tune correction parameters to channel conditions |
| 7 | **Hybrid Exel + Adaptive Filter** | Combine Exel's deterministic correction with stochastic filtering |

### 5.3. Evaluation Criteria
| Metric | Target |
|--------|--------|
| Mean synchronization precision | **< 101.5 µs** |
| Standard deviation | **< 14.78 µs** |
| Error reduction vs. baseline | **> 33.31%** |
| Convergence time | **< 4 s** |
| Computational overhead | Measured and documented |
| Robustness | Tested across mild / moderate / severe asymmetry |

---

## 8. Iterative R-E-V-T Workflow Diagram

```
For each component:

  ┌──────────┐
  │ RESEARCH │ → Literature, theory, method selection, data collection
  └────┬─────┘
       ↓
  ┌──────────┐
  │ EXECUTE  │ → Code, write, build, implement
  └────┬─────┘
       ↓
  ┌──────────┐
  │ VALIDATE │ → Correctness checks, baseline comparison, sanity tests
  └────┬─────┘
       ↓
  ┌──────────┐
  │   TEST   │ → Monte Carlo, stress scenarios, statistical significance
  └────┬─────┘
       ↓
  ┌─────────────────────────────────────────┐
  │ All criteria met? ──NO──→ Back to RESEARCH│
  └─────────────────────────────────────────┘
       ↓ YES
  ┌──────────┐
  │ DELIVER  │ → Chapter .md / .tex / .pdf or MATLAB code
  └──────────┘
```

---

## 9. Timeline

| Phase | Description | Research | Execute | Validate | Test | Duration |
|-------|-------------|----------|---------|----------|------|----------|
| 0 | Environment setup | — | ✓ | — | ✓ | 1 day |
| 1 | Chapter 1 | ✓ | ✓ | ✓ | ✓ | **Immediate priority** |
| 2 | Novel methods research | ✓ | ✓ | ✓ | ✓ | 2-3 days |
| 3 | Chapter 2 | ✓ | ✓ | ✓ | ✓ | 3-4 days |
| 4 | MATLAB implementation | ✓ | ✓ | ✓ | ✓ | 5-7 days |
| 5 | Chapter 3 | ✓ | ✓ | ✓ | ✓ | 3-4 days |
| 6 | Conclusions & recommendations | ✓ | ✓ | ✓ | ✓ | 1-2 days |
| 7 | Frontmatter & final compilation | ✓ | ✓ | ✓ | ✓ | 2-3 days |

**Estimated total:** ~17-24 business days

---

## 10. Next Steps

1. ✅ **Plan confirmed** — Asymmetric networks, more optimal and novel program, R-E-V-T methodology
2. ⬜ **Start with Chapter 1** — To send to the advisor as soon as possible
3. ⬜ **Define the novel method** — After Phase 2 internet research
4. ⬜ **MATLAB availability** — Confirm whether you have a license or we use Octave
