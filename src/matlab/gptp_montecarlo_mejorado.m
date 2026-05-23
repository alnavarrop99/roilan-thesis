% ===========================================================================
% gptp_montecarlo_mejorado.m
% Monte Carlo para el método mejorado (gPTP + Exel + AKF)
% ===========================================================================
%
% Descripción:
%   Ejecuta N simulaciones independientes del método mejorado y las compara
%   estadísticamente con la referencia Exel.
%
% Uso:
%   >> gptp_montecarlo_mejorado
% ===========================================================================

clear; clc;

% Parámetros
duracion = 60;
freq_offset = 1;
freq_msg = 1;
distancia = 30;
N_sim = 500;          % Reducido para velocidad
semilla_base = 42;

fprintf('=== Monte Carlo: Método Mejorado (Exel + AKF) ===\n');
fprintf('N = %d simulaciones\n\n', N_sim);

% Almacenamiento
precision_exel     = zeros(N_sim, 1);
precision_mejorado = zeros(N_sim, 1);

tic_total = tic;

for i = 1:N_sim
    rng(semilla_base + i * 100);
    
    % Ejecutar referencia Exel (asimétrico con corrección)
    [~, prec_exel, ~] = gptp_referencia(duracion, freq_offset, freq_msg, distancia, 3);
    precision_exel(i) = prec_exel;
    
    % Ejecutar método mejorado
    rng(semilla_base + i * 100);  % Misma semilla para comparación justa
    [~, prec_mej, ~, ~] = gptp_asimetrico_mejorado(duracion, freq_offset, freq_msg, distancia);
    precision_mejorado(i) = prec_mej;
    
    if mod(i, 50) == 0
        fprintf('  Progreso: %d/%d (%.1f%%)\n', i, N_sim, 100*i/N_sim);
    end
end

tiempo_total = toc(tic_total);
fprintf('\nCompletado en %.2f s\n\n', tiempo_total);

% Estadísticas
mu_exel = mean(precision_exel);
mu_mej  = mean(precision_mejorado);
std_exel = std(precision_exel);
std_mej  = std(precision_mejorado);

fprintf('=== RESULTADOS COMPARATIVOS ===\n\n');
fprintf('%-35s %15s %15s\n', 'Métrica', 'Exel', 'Exel+AKF');
fprintf('%-35s %15s %15s\n', '----------------------------------', '---------------', '---------------');
fprintf('%-35s %14.2f µs %14.2f µs\n', 'Precisión media', mu_exel*1e6, mu_mej*1e6);
fprintf('%-35s %14.2f µs %14.2f µs\n', 'Desviación estándar', std_exel*1e6, std_mej*1e6);

z95 = 1.96;
ic_exel = z95 * std_exel / sqrt(N_sim);
ic_mej  = z95 * std_mej  / sqrt(N_sim);
fprintf('%-35s %13.2f µs %14.2f µs\n', 'IC 95%% (±)', ic_exel*1e6, ic_mej*1e6);

% Mejora
mejora_abs = mu_exel - mu_mej;
mejora_pct = (mejora_abs / mu_exel) * 100;
fprintf('\n');
fprintf('Mejora del AKF sobre Exel:\n');
fprintf('  Reducción absoluta: %.2f µs\n', mejora_abs * 1e6);
fprintf('  Reducción porcentual: %.2f%%\n', mejora_pct);

% Test t pareado para significancia estadística
d = mean(precision_exel - precision_mejorado);
d_std = std(precision_exel - precision_mejorado);
t_stat = d / (d_std / sqrt(N_sim));
fprintf('  t-estadístico (pareado): %.2f\n', t_stat);
if abs(t_stat) > 3.29
    fprintf('  Diferencia significativa (p < 0.001): SI ✓\n');
else
    fprintf('  Diferencia significativa (p < 0.001): NO\n');
end

fprintf('\n');

% Guardar
if ~exist('resultados', 'dir')
    mkdir('resultados');
end
save('resultados/resultados_mejorado.mat', ...
    'precision_exel', 'precision_mejorado', 'mu_exel', 'mu_mej', ...
    'mejora_abs', 'mejora_pct', 't_stat', 'N_sim');
fprintf('Resultados guardados en: resultados/resultados_mejorado.mat\n');
