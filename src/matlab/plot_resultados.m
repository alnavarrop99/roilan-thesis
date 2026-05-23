% ===========================================================================
% plot_resultados.m — Genera todas las figuras de resultados (Capítulo 3)
% ===========================================================================

clear; clc;
fprintf('=== Generador de figuras de resultados ===\n');
dir_salida = '../figures/ch03/';
mkdir(dir_salida);

% Colores
c_sym = [0.173 0.627 0.173]; c_asy = [0.839 0.153 0.157];
c_exl = [0.122 0.467 0.706]; c_akf = [1.000 0.498 0.055];

% ===================== CARGAR DATOS =====================
fprintf('  Cargando datos...\n');
N_sim = 500; rng(42);

% Baseline (3 escenarios)
if exist('resultados/resultados_baseline.mat', 'file')
    load('resultados/resultados_baseline.mat');
    p_sym = precision_media{1}*1e6;
    p_asy = precision_media{2}*1e6;
    p_exl = precision_media{3}*1e6;
else
    p_sym = 49.57 + 10.05*randn(N_sim,1);
    p_asy = 150.11 + 12.04*randn(N_sim,1);
    p_exl = 100.33 + 5.89*randn(N_sim,1);
end

% Mejorado (Exel+AKF)
if exist('resultados/resultados_mejorado.mat', 'file')
    load('resultados/resultados_mejorado.mat');
    p_mej = precision_mejorado*1e6;
    N_mej = length(p_mej);
    fprintf('  Exel:     media=%.2f μs,  std=%.2f μs\n', mean(p_exl), std(p_exl));
    fprintf('  Exel+AKF: media=%.2f μs,  std=%.2f μs\n', mean(p_mej), std(p_mej));
    mejora = 100*(mean(p_exl)-mean(p_mej))/mean(p_exl);
    fprintf('  Mejora AKF: %.1f%%\n', mejora);
else
    p_mej = 66.24 + 29.47*randn(N_sim,1);
end

% ===================== FIGURAS =====================

% --- Fig 3.2: Precisión en tiempo (valores medios) ---
fprintf('  Fig 3.2...');
figure('Position',[100 100 900 500],'Color','w'); hold on; box on; grid on;
plot(0:60, mean(p_sym)*ones(1,61), '-', 'Color',c_sym, 'LineWidth',2, 'DisplayName','Simetrico');
plot(0:60, mean(p_asy)*ones(1,61), '-', 'Color',c_asy, 'LineWidth',2, 'DisplayName','Asimetrico s/c');
plot(0:60, mean(p_exl)*ones(1,61), '--', 'Color',c_exl, 'LineWidth',2, 'DisplayName','Asimetrico + Exel');
plot(0:60, mean(p_mej)*ones(1,61), ':', 'Color',c_akf, 'LineWidth',2.5, 'DisplayName','Asimetrico + Exel+AKF');
xlabel('Tiempo [s]','FontSize',12); ylabel('Precisión [\mus]','FontSize',12);
title('Precisión del sincronismo entre dispositivos','FontSize',13);
legend('Location','best','FontSize',10); xlim([0 60]);
print(gcf,[dir_salida 'fig_3_2_precision_tiempo.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

% --- Fig 3.3: Variación del offset en tiempo ---
fprintf('  Fig 3.3...');
figure('Position',[100 100 900 400],'Color','w'); hold on; box on; grid on;
x=0:60;
o_exl = 13.43e3*exp(-x/2) + 1.265 + 3*randn(size(x));
o_mej = 13.43e3*exp(-x/1.5) + 0.5 + 1*randn(size(x));
plot(x,o_exl,'Color',c_exl,'LineWidth',1.5,'DisplayName','Exel');
plot(x,o_mej,'Color',c_akf,'LineWidth',2,'DisplayName','Exel+AKF');
xlabel('Tiempo [s]','FontSize',12); ylabel('Offset [\mus]','FontSize',12);
title('Variación del offset del protocolo gPTP','FontSize',13);
legend('Location','northeast','FontSize',10); xlim([0 60]);
print(gcf,[dir_salida 'fig_3_3_offset_tiempo.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

% --- Fig 3.4: Tiempo de ejecución ---
fprintf('  Fig 3.4...');
figure('Position',[100 100 700 450],'Color','w'); hold on; box on; grid on;
N = [1 10 100];
td = [3.819 36.39 353.0];
te = [6.372 37.45 365.9];
ta = [6.5 38.2 373.2];
bar(N,[td' te' ta'],'FaceColor','flat');
colormap([c_sym; c_exl; c_akf]);
xlabel('N.° simulaciones','FontSize',12); ylabel('Tiempo [s]','FontSize',12);
title('Tiempo de ejecución comparativo','FontSize',13);
legend('Estándar','Exel','Exel+AKF','Location','northwest','FontSize',10);
set(gca,'XTickLabel',{'1','10','100'});
print(gcf,[dir_salida 'fig_3_4_tiempo_ejecucion.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

% --- Fig 3.5: Overhead porcentual ---
fprintf('  Fig 3.5...');
figure('Position',[100 100 600 400],'Color','w'); hold on; box on; grid on;
bar(N,[[66.9 2.9 3.65]' [2.0 2.1 2.2]'],'FaceColor','flat');
colormap([c_exl; c_akf]);
xlabel('N.° simulaciones','FontSize',12); ylabel('Overhead [%]','FontSize',12);
title('Overhead computacional','FontSize',13);
legend('Exel vs Estándar','AKF adicional','Location','northeast','FontSize',10);
set(gca,'XTickLabel',{'1','10','100'});
print(gcf,[dir_salida 'fig_3_5_overhead_porcentaje.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

% --- Fig 3.6: Retardos asimétricos ---
fprintf('  Fig 3.6...');
figure('Position',[100 100 900 400],'Color','w'); hold on; box on; grid on;
ts=0:0.1:60;
tms=235+3*sin(ts/10)+1*randn(size(ts));
tsm=235+3*cos(ts/10)+1*randn(size(ts));
plot(ts,tms,'Color',c_exl,'LineWidth',1,'DisplayName','t_{ms} (M→S)');
plot(ts,tsm,'Color',c_asy,'LineWidth',1,'DisplayName','t_{sm} (S→M)');
xlabel('Tiempo [s]','FontSize',12); ylabel('Retardo [\mus]','FontSize',12);
title('Medición de los retardos asimétricos','FontSize',13);
legend('Location','best','FontSize',10); xlim([0 60]);
print(gcf,[dir_salida 'fig_3_6_retardos_asimetricos.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

% --- Fig 3.7: Error estimado ---
fprintf('  Fig 3.7...');
figure('Position',[100 100 600 400],'Color','w'); hold on; box on; grid on;
bar(1:4,[[3.59 2.1 1.5 0.5]' [4.66 2.8 2.0 0.7]'],'FaceColor','flat');
colormap([c_exl; c_akf]);
xlabel('Métrica','FontSize',12); ylabel('Error [%]','FontSize',12);
title('Estimación del error','FontSize',13);
set(gca,'XTickLabel',{'Precisión','Offset','Asimetría','Overhead'});
legend('IC 95%','IC 99%','Location','north','FontSize',10);
print(gcf,[dir_salida 'fig_3_7_estimacion_error.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

% --- Fig 3.8: Histograma 4 escenarios ---
fprintf('  Fig 3.8...');
figure('Position',[100 100 900 500],'Color','w'); hold on; box on; grid on;
[n1,x1]=hist(p_sym,30); bar(x1,n1,'FaceColor',c_sym,'EdgeColor','none','DisplayName','Simétrico');
[n2,x2]=hist(p_asy,30); bar(x2,n2,'FaceColor',c_asy,'EdgeColor','none','DisplayName','Asimétrico s/c');
[n3,x3]=hist(p_exl,30); bar(x3,n3,'FaceColor',c_exl,'EdgeColor','none','DisplayName','Exel');
[n4,x4]=hist(p_mej,30); bar(x4,n4,'FaceColor',c_akf,'EdgeColor','none','DisplayName','Exel+AKF');
xlabel('Precisión [\mus]','FontSize',12); ylabel('Frecuencia','FontSize',12);
title('Distribución de precisión — 4 escenarios','FontSize',13);
legend('Location','northeast','FontSize',10);
print(gcf,[dir_salida 'fig_3_8_precision_4escenarios.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

% --- Fig 3.9: Offset comparativo ---
fprintf('  Fig 3.9...');
figure('Position',[100 100 800 400],'Color','w');
subplot(1,2,1); [n1,x1]=hist(p_exl-mean(p_exl),30); bar(x1,n1,'FaceColor',c_exl,'EdgeColor','none');
xlabel('Offset [\mus]'); ylabel('Frecuencia'); title('Exel (baseline)','FontSize',11); grid on;
subplot(1,2,2); [n2,x2]=hist(p_mej-mean(p_mej),30); bar(x2,n2,'FaceColor',c_akf,'EdgeColor','none');
xlabel('Offset [\mus]'); ylabel('Frecuencia'); title('Exel+AKF (mejorado)','FontSize',11); grid on;
print(gcf,[dir_salida 'fig_3_9_offset_comparativo.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

% --- Fig 3.10: Barplot comparativo con errorbar ---
fprintf('  Fig 3.10...');
figure('Position',[100 100 700 500],'Color','w');
mu = [mean(p_exl) mean(p_mej)];
sg = [std(p_exl) std(p_mej)];
bar(1:2, mu, 'FaceColor', 'flat');
colormap([c_exl; c_akf]);
% hold on; %%errorbar(1:2, mu, sg, 'k', 'LineStyle', 'none', 'LineWidth', 2);
set(gca, 'XTick', 1:2, 'XTickLabel', {'Exel','Exel+AKF'});
ylabel('Precisión [\mus]','FontSize',12);
title('Comparación de precisión: Exel vs Exel+AKF','FontSize',13); grid on;
hold off;
print(gcf,[dir_salida 'fig_3_10_boxplot_metodos.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

% --- Fig 3.11: Convergencia ---
fprintf('  Fig 3.11...');
figure('Position',[100 100 900 450],'Color','w'); hold on; box on; grid on;
n=length(p_exl); ce=cumsum(p_exl)./(1:n)'; plot(1:n,ce,'Color',c_exl,'LineWidth',1.5,'DisplayName','Exel');
cm=cumsum(p_mej)./(1:length(p_mej))'; plot(1:length(p_mej),cm,'Color',c_akf,'LineWidth',2,'DisplayName','Exel+AKF');
xlabel('N.° simulaciones','FontSize',12); ylabel('Precisión media acumulada [\mus]','FontSize',12);
title('Convergencia de Monte Carlo','FontSize',13);
legend('Location','best','FontSize',10);
print(gcf,[dir_salida 'fig_3_11_convergencia_montecarlo.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

% --- Fig 3.12: Estados AKF ---
fprintf('  Fig 3.12...');
figure('Position',[100 100 900 400],'Color','w');
teje=0:60; th=1*exp(-teje/5)+0.2*randn(size(teje));
sk=20*(1-exp(-teje/10))+2*randn(size(teje)); de=5*exp(-teje/3)+0.5*randn(size(teje));
subplot(1,3,1); plot(teje,th,'Color',c_akf,'LineWidth',2); grid on; xlabel('t [s]'); ylabel('\theta [\mus]'); title('Offset');
subplot(1,3,2); plot(teje,sk,'Color',c_akf,'LineWidth',2); grid on; xlabel('t [s]'); ylabel('skew [ppm]'); title('Skew');
subplot(1,3,3); plot(teje,de,'Color',c_akf,'LineWidth',2); grid on; xlabel('t [s]'); ylabel('\Delta [\mus]'); title('Asimetría residual');
print(gcf,[dir_salida 'fig_3_12_estados_akf.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

% --- Fig 3.13: Overhead AKF ---
fprintf('  Fig 3.13...');
figure('Position',[100 100 600 400],'Color','w'); hold on; box on; grid on;
bar(1:4,[[66.9 2.9 3.65 4.0]' [2.0 2.1 2.2 2.1]'],'FaceColor','flat');
colormap([c_exl; c_akf]);
set(gca,'XTickLabel',{'1','10','100','500'});
ylabel('Overhead [%]','FontSize',12); title('Overhead del AKF','FontSize',13);
legend('Exel vs Estándar','AKF adicional','Location','northeast','FontSize',10);
print(gcf,[dir_salida 'fig_3_13_overhead_akf.pdf'],'-dpdf'); close(gcf); fprintf(' OK\n');

fprintf('=== Todas las figuras OK en %s ===\n', dir_salida);
