% ===========================================================================
% gptp_montecarlo.m
% Motor de simulación Monte Carlo para el protocolo gPTP
% ===========================================================================
%
% Descripción:
%   Ejecuta N simulaciones independientes del protocolo gPTP para cada
%   escenario, variando las semillas aleatorias en cada ejecución. Calcula
%   las métricas estadísticas agregadas (media, desviación estándar,
%   intervalo de confianza) y prepara los datos para visualización.
%
%   Escenarios:
%     1: Enlace simétrico (gPTP estándar)
%     2: Enlace asimétrico sin corrección
%     3: Enlace asimétrico con corrección Exel
%
% Uso:
%   >> gptp_montecarlo
%   (configurar parámetros dentro del script)
%
% Dependencias:
%   gptp_referencia.m — función de simulación del protocolo
% ===========================================================================

clear; clc; close all;

% =========================================================================
% PARÁMETROS DE SIMULACIÓN
% =========================================================================

% Parámetros del protocolo gPTP
duracion    = 60;       % Duración de cada simulación [s]
freq_offset = 1;        % Frecuencia de corrección de offset [Hz]
freq_msg    = 1;        % Frecuencia de intercambio de mensajes [Hz]
distancia   = 30;       % Distancia entre dispositivos [m]

% Parámetros de Monte Carlo
N_sim = 3000;           % Número de simulaciones de Monte Carlo
semilla_base = 42;      % Semilla base para reproducibilidad

% =========================================================================
% INICIALIZACIÓN DE ARRAYS DE RESULTADOS
% =========================================================================

% Para cada escenario, almacenamos:
%   - precision_media(i): precisión media de la i-ésima simulación [s]
%   - offset_estable(i):  offset medio estabilizado [s]

precision_media = cell(3, 1);
offset_estable  = cell(3, 1);

for esc = 1:3
    precision_media{esc} = zeros(N_sim, 1);
    offset_estable{esc}  = zeros(N_sim, 1);
end

nombres_escenarios = {
    'Enlace simétrico (gPTP estándar)';
    'Enlace asimétrico sin corrección';
    'Enlace asimétrico con corrección Exel'
};

% =========================================================================
% BUCLE PRINCIPAL DE MONTE CARLO
% =========================================================================

fprintf('=== Simulación Monte Carlo: Protocolo gPTP ===\n');
fprintf('Número de simulaciones: %d\n', N_sim);
fprintf('Duración por simulación: %d s\n', duracion);
fprintf('Distancia entre dispositivos: %d m\n\n', distancia);

tic_total = tic;

for esc = 1:3
    fprintf('--- Escenario %d: %s ---\n', esc, nombres_escenarios{esc});
    tic_esc = tic;

    for i = 1:N_sim
        % Configurar semilla aleatoria (reproducible pero diferente por iteración)
        rng(semilla_base + i * 100 + esc * 10000);

        % Ejecutar simulación
        [offset_fin, prec, ~] = gptp_referencia(...
            duracion, freq_offset, freq_msg, distancia, esc);

        precision_media{esc}(i) = prec;
        offset_estable{esc}(i)  = offset_fin;

        % Barra de progreso cada 500 iteraciones
        if mod(i, 500) == 0
            fprintf('  Progreso: %d/%d (%.1f%%)\n', i, N_sim, 100*i/N_sim);
        end
    end

    tiempo_esc = toc(tic_esc);
    fprintf('  Completado en %.2f s\n\n', tiempo_esc);
end

tiempo_total = toc(tic_total);
fprintf('=== Simulación completada en %.2f s (%.2f min) ===\n\n', ...
    tiempo_total, tiempo_total/60);

% =========================================================================
% CÁLCULO DE MÉTRICAS ESTADÍSTICAS
% =========================================================================

fprintf('=== RESULTADOS ESTADÍSTICOS ===\n\n');

for esc = 1:3
    prec = precision_media{esc};
    offs = offset_estable{esc};

    % Estadísticos básicos
    media_prec  = mean(prec);
    std_prec    = std(prec);
    media_offs  = mean(offs);
    std_offs    = std(offs);

    % Intervalo de confianza 95% para la precisión media
    z_95 = 1.96;  % Valor Z para 95% de confianza
    ic_95 = z_95 * std_prec / sqrt(N_sim);

    % Error estimado de la simulación (%)
    error_est = (ic_95 / media_prec) * 100;

    fprintf('Escenario %d: %s\n', esc, nombres_escenarios{esc});
    fprintf('  Precisión media:            %.2f µs\n', media_prec * 1e6);
    fprintf('  Desviación estándar:        %.2f µs\n', std_prec * 1e6);
    fprintf('  Offset medio estabilizado:  %.3f µs\n', media_offs * 1e6);
    fprintf('  IC 95%%:                     ±%.2f µs\n', ic_95 * 1e6);
    fprintf('  Error estimado:             %.2f%%\n', error_est);
    fprintf('  Rango offset:               [%.3f, %.3f] µs\n', ...
        min(offs)*1e6, max(offs)*1e6);

    if esc >= 2
        % Mejora respecto al escenario asimétrico sin corrección
        if esc == 3
            mejora_abs = mean(precision_media{2}) - mean(precision_media{3});
            mejora_pct = (mejora_abs / mean(precision_media{2})) * 100;
            fprintf('  Reducción del error vs. asimétrico: %.2f µs (%.2f%%)\n', ...
                mejora_abs * 1e6, mejora_pct);
        end
    end
    fprintf('\n');
end

% =========================================================================
% GUARDAR RESULTADOS
% =========================================================================

resultados.precision_media = precision_media;
resultados.offset_estable  = offset_estable;
resultados.params = struct('N_sim', N_sim, 'duracion', duracion, ...
    'freq_offset', freq_offset, 'freq_msg', freq_msg, 'distancia', distancia);
resultados.nombres = nombres_escenarios;
resultados.tiempo_total = tiempo_total;

% Crear directorio si no existe
if ~exist('resultados', 'dir')
    mkdir('resultados');
end

save('resultados/resultados_montecarlo.mat', 'resultados');
fprintf('Resultados guardados en: resultados/resultados_montecarlo.mat\n');
