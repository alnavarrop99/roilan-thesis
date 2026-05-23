% ===========================================================================
% plot_resultados.m
% Visualización de resultados de la simulación Monte Carlo del protocolo gPTP
% ===========================================================================
%
% Descripción:
%   Genera las figuras comparativas de los tres escenarios de simulación:
%     1. Precisión del sincronismo en el tiempo (Figura 3.2 del documento)
%     2. Variación del offset con corrección Exel (Figura 3.3)
%     3. Comparación de overhead computacional (Figura 3.4)
%     4. Histograma de precisiones por escenario
%     5. Diagrama de cajas (boxplot) comparativo
%
% Uso:
%   >> plot_resultados
%   (requiere resultados_montecarlo.mat en el directorio 'resultados/')
% ===========================================================================

clear; clc;

% =========================================================================
% CARGA DE RESULTADOS
% =========================================================================

if exist('resultados/resultados_montecarlo.mat', 'file')
    load('resultados/resultados_montecarlo.mat');
    fprintf('Resultados cargados: %d simulaciones por escenario.\n', ...
        resultados.params.N_sim);
else
    error('No se encuentran los resultados. Ejecute gptp_montecarlo primero.');
end

prec = resultados.precision_media;
offs = resultados.offset_estable;
params = resultados.params;
nombres = resultados.nombres;

% Convertir a µs para visualización
for esc = 1:3
    prec{esc} = prec{esc} * 1e6;  % s → µs
    offs{esc} = offs{esc} * 1e6;  % s → µs
end

% Colores para cada escenario
colores = {[0.2 0.6 0.2], [0.9 0.3 0.3], [0.2 0.3 0.8]};  % verde, rojo, azul

% =========================================================================
% FIGURA 1: Histograma de precisiones por escenario
% =========================================================================

figure('Position', [100, 100, 900, 500]);

hold on;
for esc = 1:3
    histogram(prec{esc}, 40, 'FaceColor', colores{esc}, ...
        'FaceAlpha', 0.5, 'EdgeColor', 'none', ...
        'DisplayName', nombres{esc});
end
hold off;

xlabel('Precisión [µs]', 'FontSize', 12);
ylabel('Frecuencia', 'FontSize', 12);
title('Distribución de la precisión del sincronismo por escenario', 'FontSize', 14);
legend('Location', 'northeast');
grid on;

saveas(gcf, 'resultados/figura_histograma.png');

% =========================================================================
% FIGURA 2: Diagrama de cajas (boxplot) comparativo
% =========================================================================

figure('Position', [100, 100, 700, 500]);

% Preparar datos para boxplot
datos_box = [prec{1}, prec{2}, prec{3}];
etiquetas = {'Simétrico', 'Asimétrico\nsin corr.', 'Asimétrico\ncon Exel'};

boxplot(datos_box, 'Labels', etiquetas);

ylabel('Precisión [µs]', 'FontSize', 12);
title('Comparación de precisión del sincronismo entre escenarios', 'FontSize', 14);
grid on;

% Añadir valores medios como texto
medias = [mean(prec{1}), mean(prec{2}), mean(prec{3})];
hold on;
for i = 1:3
    text(i, medias(i) + 2, sprintf('%.1f µs', medias(i)), ...
        'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold');
end
hold off;

saveas(gcf, 'resultados/figura_boxplot.png');

% =========================================================================
% FIGURA 3: Curva de convergencia de Monte Carlo
% =========================================================================

figure('Position', [100, 100, 900, 500]);

hold on;
for esc = 1:3
    media_acumulada = cumsum(prec{esc}) ./ (1:params.N_sim)';
    plot(1:params.N_sim, media_acumulada, 'Color', colores{esc}, ...
        'LineWidth', 1.5, 'DisplayName', nombres{esc});
end
hold off;

xlabel('Número de simulaciones', 'FontSize', 12);
ylabel('Precisión media acumulada [µs]', 'FontSize', 12);
title('Convergencia de Monte Carlo — Precisión media acumulada', 'FontSize', 14);
legend('Location', 'best');
grid on;

% Línea vertical en N=3000
xlim([1, params.N_sim]);

saveas(gcf, 'resultados/figura_convergencia.png');

% =========================================================================
% FIGURA 4: Offset estabilizado — histograma
% =========================================================================

figure('Position', [100, 100, 900, 500]);

% Solo mostrar escenarios 2 y 3 (asimétrico sin/con corrección)
subplot(1,2,1);
histogram(offs{2}, 40, 'FaceColor', colores{2}, 'EdgeColor', 'none');
xlabel('Offset medio [µs]', 'FontSize', 11);
ylabel('Frecuencia', 'FontSize', 11);
title('Asimétrico sin corrección', 'FontSize', 12);
grid on;

subplot(1,2,2);
histogram(offs{3}, 40, 'FaceColor', colores{3}, 'EdgeColor', 'none');
xlabel('Offset medio [µs]', 'FontSize', 11);
ylabel('Frecuencia', 'FontSize', 11);
title('Asimétrico con corrección Exel', 'FontSize', 12);
grid on;

sgtitle('Distribución del offset estabilizado', 'FontSize', 14);

saveas(gcf, 'resultados/figura_offset.png');

% =========================================================================
% RESUMEN EN CONSOLA
% =========================================================================

fprintf('\n=== RESUMEN DE RESULTADOS ===\n\n');
fprintf('%-45s %12s %12s\n', 'Escenario', 'Media [µs]', 'Std [µs]');
fprintf('%-45s %12s %12s\n', '-----------------------------------------', ...
    '------------', '------------');

for esc = 1:3
    fprintf('%-45s %12.2f %12.2f\n', nombres{esc}, mean(prec{esc}), std(prec{esc}));
end

fprintf('\n');
mejora_abs = mean(prec{2}) - mean(prec{3});
mejora_pct = (mejora_abs / mean(prec{2})) * 100;
fprintf('Mejora con corrección Exel:\n');
fprintf('  Reducción absoluta: %.2f µs\n', mejora_abs);
fprintf('  Reducción porcentual: %.2f%%\n', mejora_pct);

fprintf('\nFiguras guardadas en: resultados/\n');
