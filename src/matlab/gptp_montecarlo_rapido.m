% ===========================================================================
% gptp_montecarlo_rapido.m
% Monte Carlo rápido (N=500) para los 3 escenarios de referencia
% ===========================================================================
clear; clc;

duracion = 60; freq_offset = 1; freq_msg = 1; distancia = 30;
N_sim = 500; semilla_base = 42;

fprintf('=== Monte Carlo: 3 escenarios de referencia (N=%d) ===\n\n', N_sim);

precision_media = cell(3, 1);
nombres = {'Simétrico', 'Asimétrico sin corr.', 'Asimétrico con Exel'};

tic_total = tic;

for esc = 1:3
    prec = zeros(N_sim, 1);
    fprintf('--- Escenario %d: %s ---\n', esc, nombres{esc});
    tic_esc = tic;
    for i = 1:N_sim
        rng(semilla_base + i * 100 + esc * 10000);
        [~, p, ~] = gptp_referencia(duracion, freq_offset, freq_msg, distancia, esc);
        prec(i) = p;
        if mod(i, 100) == 0
            fprintf('  %d/%d (%.0f%%)\n', i, N_sim, 100*i/N_sim);
        end
    end
    precision_media{esc} = prec;
    fprintf('  Media=%.2f µs, Std=%.2f µs (%.2f s)\n\n', mean(prec)*1e6, std(prec)*1e6, toc(tic_esc));
end

fprintf('Tiempo total: %.2f s\n\n', toc(tic_total));

% Resultados
for esc = 1:3
    mu = mean(precision_media{esc}) * 1e6;
    sd = std(precision_media{esc}) * 1e6;
    fprintf('Escenario %d (%s): %.2f ± %.2f µs\n', esc, nombres{esc}, mu, sd);
end

mejora_exel_abs = (mean(precision_media{2}) - mean(precision_media{3})) * 1e6;
mejora_exel_pct = mejora_exel_abs / (mean(precision_media{2})*1e6) * 100;
fprintf('\nMejora Exel vs. asimétrico sin corr.: %.2f µs (%.2f%%)\n', mejora_exel_abs, mejora_exel_pct);

% Guardar
if ~exist('resultados', 'dir'), mkdir('resultados'); end
save('resultados/resultados_baseline.mat', 'precision_media', 'nombres', 'N_sim');
fprintf('Guardado en resultados/resultados_baseline.mat\n');
