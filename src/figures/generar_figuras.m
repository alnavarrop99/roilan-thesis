% ===========================================================================
% generar_figuras.m
% Genera todas las figuras conceptuales de la tesis
% Ejecutar desde Octave/MATLAB dentro de src/figures/
% ===========================================================================
%
% Uso:  >> generar_figuras('ch01')  % solo cap. 1
%       >> generar_figuras('ch02')  % solo cap. 2
%       >> generar_figuras('ch03')  % solo cap. 3
%       >> generar_figuras('intro') % solo intro
%       >> generar_figuras('all')   % todos
% ===========================================================================

function generar_figuras(opt)
  if nargin < 1; opt = 'all'; end
  fprintf('=== Generador de figuras de la tesis ===\n');
  switch opt
    case 'all'
      fig_intro_estructura(); fig_intro_ciclo_revt();
      fig_1_1(); fig_1_2(); fig_1_3(); fig_1_4();
      fig_2_1(); fig_2_2(); fig_2_4(); fig_2_5();
      fig_3_1();
    case 'intro'
      fig_intro_estructura(); fig_intro_ciclo_revt();
    case 'ch01'
      fig_1_1(); fig_1_2(); fig_1_3(); fig_1_4();
    case 'ch02'
      fig_2_1(); fig_2_2(); fig_2_4(); fig_2_5();
    case 'ch03'
      fig_3_1();
  end
  fprintf('=== Hecho ===\n');
end

% Helper: exportar figura como PDF con tamaño ajustado
function export_fig(hf, filename)
  pos = get(hf, 'Position');
  w_in = pos(3) / 150;  % convertir píxeles a pulgadas (150 DPI)
  h_in = pos(4) / 150;
  set(hf, 'PaperUnits', 'inches');
  set(hf, 'PaperSize', [w_in h_in]);
  set(hf, 'PaperPosition', [0 0 w_in h_in]);
  print(hf, filename, '-dpdf');
end

% =========================================================================
% INTRODUCCIÓN
% =========================================================================

function fig_intro_estructura()
  fprintf('  fig_intro_estructura...');
  figure('Position', [100 100 700 500], 'Color', 'w');
  clf; hold on; axis off;

  text(0.5, 0.95, 'ESTRUCTURA DE LA TESIS', 'FontSize', 14, ...
    'FontWeight', 'bold', 'HorizontalAlignment', 'center');

  x0=0.3; y0=0.78; w=0.35; h=0.08;
  % Ch1
  rectangle('Position',[x0 y0 w h], 'FaceColor',[0.2 0.6 0.2], ...
    'EdgeColor',[0.2 0.6 0.2], 'LineWidth',2, 'Curvature',0.1);
  text(x0+w/2, y0+h/2, 'Cap.1: Fundamentos y estado del arte', ...
    'FontSize',10, 'HorizontalAlignment','center');
  % Ch2
  rectangle('Position',[x0 y0-0.12 w h], 'FaceColor',[0.2 0.3 0.8], ...
    'EdgeColor',[0.2 0.3 0.8], 'LineWidth',2, 'Curvature',0.1);
  text(x0+w/2, y0-0.12+h/2, 'Cap.2: Metodos y herramientas', ...
    'FontSize',10, 'HorizontalAlignment','center');
  % Ch3
  rectangle('Position',[x0 y0-0.24 w h], 'FaceColor',[1 0.5 0.05], ...
    'EdgeColor',[1 0.5 0.05], 'LineWidth',2, 'Curvature',0.1);
  text(x0+w/2, y0-0.24+h/2, 'Cap.3: Implementacion y resultados', ...
    'FontSize',10, 'HorizontalAlignment','center');
  % Concl
  rectangle('Position',[x0+0.1 y0-0.36 w-0.2 h], ...
    'FaceColor',[0.5 0.5 0.5], 'EdgeColor',[0.5 0.5 0.5], ...
    'LineWidth',1.5, 'Curvature',0.1);
  text(x0+(w-0.2)/2+0.1, y0-0.36+h/2, 'Conclusiones y Recomendaciones', ...
    'FontSize',10, 'HorizontalAlignment','center');
  % Flechas
  annotation('arrow',[0.65 0.76],[0.82 0.76],'LineWidth',1.5);
  annotation('arrow',[0.65 0.76],[0.7 0.64],'LineWidth',1.5);
  annotation('arrow',[0.65 0.76],[0.58 0.52],'LineWidth',1.5);

  export_fig(gcf, 'intro/fig_intro_estructura.pdf');
  close(gcf); fprintf(' OK\n');
end

function fig_intro_ciclo_revt()
  fprintf('  fig_intro_ciclo_revt...');
  figure('Position',[100 100 500 550],'Color','w');
  clf; hold on; axis off;

  cent = [0.5 0.82; 0.5 0.62; 0.5 0.42; 0.5 0.22];
  txts = {'RESEARCH','EXECUTE','VALIDATE','TEST'};
  cols = [0.2 0.6 0.2; 0.2 0.3 0.8; 1 0.5 0.05; 0.8 0.2 0.2];
  for i=1:4
    rectangle('Position',[cent(i,1)-0.15 cent(i,2)-0.05 0.3 0.1], ...
      'FaceColor',cols(i,:),'EdgeColor',cols(i,:)*0.7,'LineWidth',2,'Curvature',0.2);
    text(cent(i,1),cent(i,2),txts{i},'FontSize',12,'FontWeight','bold',...
      'HorizontalAlignment','center');
  end
  % Flechas
  for i=1:3
    annotation('arrow',[0.5 0.5],[cent(i,2)-0.05 cent(i+1,2)+0.05],'LineWidth',2);
  end
  annotation('textarrow',[0.75 0.7],[0.25 0.75],'String','NO','FontSize',10,'Color','r');

  rect = [0.5-0.12 0.04 0.24 0.08];
  rectangle('Position',rect,'FaceColor',[0.1 0.1 0.1],...
    'EdgeColor',[0 0 0],'LineWidth',1.5,'Curvature',0.2);
  text(0.5,0.08,'DELIVER (.md/.tex/.pdf)','FontSize',10,'FontWeight','bold',...
    'HorizontalAlignment','center');
  title('Ciclo R-E-V-T (Research-Execute-Validate-Test)','FontSize',13);

  export_fig(gcf, 'intro/fig_intro_ciclo_revt.pdf');
  close(gcf); fprintf(' OK\n');
end

% =========================================================================
% CAPÍTULO 1
% =========================================================================

function fig_1_1()
  fprintf('  fig_1_1_sync_uni_vs_bidi...');
  figure('Position',[100 100 800 350],'Color','w');
  clf; hold on; axis off;

  % Unidirectional
  text(0.2,0.85,'UNIDIRECCIONAL','FontSize',12,'FontWeight','bold');
  rectangle('Position',[0.05 0.4 0.15 0.15],'FaceColor',[0.2 0.3 0.8],...
    'EdgeColor',[0.2 0.3 0.8],'LineWidth',2,'Curvature',0.1);
  text(0.125,0.475,'MAESTRO','FontSize',10,'HorizontalAlignment','center');
  annotation('arrow',[0.2 0.4],[0.475 0.475],'LineWidth',2);
  rectangle('Position',[0.4 0.4 0.15 0.15],'FaceColor',[0.2 0.6 0.2],...
    'EdgeColor',[0.2 0.6 0.2],'LineWidth',2,'Curvature',0.1);
  text(0.475,0.475,'ESCLAVO','FontSize',10,'HorizontalAlignment','center');
  text(0.3,0.35,'Sync (solo tiempo)','FontSize',8,'HorizontalAlignment','center');
  text(0.56,0.45,'No mide retardo','FontSize',9,'Color','r');

  % Bidirectional
  text(0.7,0.85,'BIDIRECCIONAL','FontSize',12,'FontWeight','bold');
  rectangle('Position',[0.55 0.4 0.15 0.15],'FaceColor',[0.2 0.3 0.8],...
    'EdgeColor',[0.2 0.3 0.8],'LineWidth',2,'Curvature',0.1);
  text(0.625,0.475,'MAESTRO','FontSize',10,'HorizontalAlignment','center');
  rectangle('Position',[0.9 0.4 0.15 0.15],'FaceColor',[0.2 0.6 0.2],...
    'EdgeColor',[0.2 0.6 0.2],'LineWidth',2,'Curvature',0.1);
  text(0.975,0.475,'ESCLAVO','FontSize',10,'HorizontalAlignment','center');
  annotation('arrow',[0.7 0.9],[0.55 0.55],'LineWidth',2);
  annotation('arrow',[0.9 0.7],[0.4 0.4],'LineWidth',2);
  text(0.8,0.6,'Sync/FollowUp','FontSize',8,'HorizontalAlignment','center');
  text(0.8,0.3,'DelayReq/Resp','FontSize',8,'HorizontalAlignment','center');
  text(0.56,0.3,'Mide RTT y calcula offset','FontSize',9,'Color','b');

  text(0.5,0.1,'Fuente: Adaptado de [7].','FontSize',9,'Color',[0.5 0.5 0.5],'HorizontalAlignment','center');
  export_fig(gcf, 'ch01/fig_1_1_sync_uni_vs_bidi.pdf');
  close(gcf); fprintf(' OK\n');
end

function fig_1_2()
  fprintf('  fig_1_2_fuentes_error...');
  figure('Position',[100 100 900 400],'Color','w');
  clf; hold on; axis off;

  text(0.5,0.95,'FUENTES DE ERROR DE SINCRONIZACION','FontSize',13,'FontWeight','bold','HorizontalAlignment','center');
  xi = 0.08; y=0.5; w=0.18; h=0.15;
  etiq={'Send Time','Access Time','Propagation Time','Receive Time'};
  col=[1 1 0; 1 0.6 0; 1 0 0; 0.6 0 0.8];
  note={'Pila de red','Contencion MAC','Multitrayecto','Interrupcion SO'};
  for i=1:4
    xi2=xi+(i-1)*0.22;
    rectangle('Position',[xi2 y w h],'FaceColor',col(i,:),'EdgeColor',col(i,:)*0.7,'LineWidth',2,'Curvature',0.1);
    text(xi2+w/2,y+h/2,etiq{i},'FontSize',10,'HorizontalAlignment','center','FontWeight','bold');
    text(xi2+w/2,y-0.03,note{i},'FontSize',8,'HorizontalAlignment','center','Color',[0.3 0.3 0.3]);
    if i<4; annotation('arrow',[xi2+w xi2+w+0.04],[0.575 0.575],'LineWidth',2); end
  end
  rectangle('Position',[0.01 0.45 0.06 0.15],'FaceColor',[0.2 0.3 0.8],...
    'EdgeColor',[0.2 0.3 0.8],'LineWidth',2,'Curvature',0.1);
  text(0.04,0.525,'M','FontSize',12,'HorizontalAlignment','center','FontWeight','bold');
  rectangle('Position',[0.93 0.45 0.06 0.15],'FaceColor',[0.2 0.6 0.2],...
    'EdgeColor',[0.2 0.6 0.2],'LineWidth',2,'Curvature',0.1);
  text(0.96,0.525,'S','FontSize',12,'HorizontalAlignment','center','FontWeight','bold');
  annotation('arrow',[0.07 0.93],[0.525 0.525],'LineWidth',1,'LineStyle','--');
  text(0.5,0.12,'Fuente: Adaptado de [15].','FontSize',9,'Color',[0.5 0.5 0.5],'HorizontalAlignment','center');
  export_fig(gcf, 'ch01/fig_1_2_fuentes_error.pdf');
  close(gcf); fprintf(' OK\n');
end

function fig_1_3()
  fprintf('  fig_1_3_gptp_medicion...');
  figure('Position',[100 100 800 500],'Color','w');
  clf; hold on; axis off;

  text(0.5,0.95,'Medicion del retardo en gPTP (Peer Delay Mechanism)','FontSize',13,'FontWeight','bold','HorizontalAlignment','center');
  rectangle('Position',[0.05 0.35 0.2 0.12],'FaceColor',[0.2 0.3 0.8],...
    'EdgeColor',[0.2 0.3 0.8],'LineWidth',2,'Curvature',0.1);
  text(0.15,0.41,'SOLICITANTE','FontSize',9,'HorizontalAlignment','center','FontWeight','bold');
  text(0.15,0.45,'(Maestro)','FontSize',8,'HorizontalAlignment','center');
  rectangle('Position',[0.75 0.35 0.2 0.12],'FaceColor',[0.2 0.6 0.2],...
    'EdgeColor',[0.2 0.6 0.2],'LineWidth',2,'Curvature',0.1);
  text(0.85,0.41,'RESPONDEDOR','FontSize',9,'HorizontalAlignment','center','FontWeight','bold');
  text(0.85,0.45,'(Esclavo)','FontSize',8,'HorizontalAlignment','center');
  annotation('arrow',[0.25 0.75],[0.7 0.7],'LineWidth',2);
  text(0.5,0.75,'Pdelay\_Req','FontSize',10,'HorizontalAlignment','center');
  text(0.2,0.72,'t1','FontSize',10,'FontWeight','bold','Color','b');
  text(0.8,0.72,'t2','FontSize',10,'FontWeight','bold','Color','r');
  annotation('arrow',[0.75 0.25],[0.15 0.15],'LineWidth',2);
  text(0.5,0.1,'Pdelay\_Resp','FontSize',10,'HorizontalAlignment','center');
  text(0.8,0.12,'t3','FontSize',10,'FontWeight','bold','Color','r');
  text(0.2,0.12,'t4','FontSize',10,'FontWeight','bold','Color','b');
  annotation('arrow',[0.75 0.25],[0.02 0.02],'LineWidth',1.5,'LineStyle',':');
  text(0.5,-0.02,'PdelayRespFollowUp (t3)','FontSize',9,'HorizontalAlignment','center');
  rectangle('Position',[0.2 -0.18 0.6 0.08],'FaceColor',[1 1 1],...
    'EdgeColor',[0.5 0.5 0.5],'LineWidth',1,'Curvature',0.1);
  text(0.5,-0.14,'Pdelay = [(t4 - t1) - r(t3 - t2)] / 2','FontSize',12,'HorizontalAlignment','center');
  text(0.5,-0.3,'Fuente: Adaptado de [48].','FontSize',9,'Color',[0.5 0.5 0.5],'HorizontalAlignment','center');
  export_fig(gcf, 'ch01/fig_1_3_gptp_medicion_retardo.pdf');
  close(gcf); fprintf(' OK\n');
end

function fig_1_4()
  fprintf('  fig_1_4_retardo_y_deriva...');
  figure('Position',[100 100 900 500],'Color','w');
  subplot(1,2,1); hold on; box on; grid on;
  title('(a) Calculo del retardo de propagacion','FontSize',10);
  xlabel('Tiempo [s]'); axis([0 10 -0.8 1.2]);
  plot([1 1],[0 0.3],'b-','LineWidth',2); text(1,0.4,'t1','FontSize',9,'Color','b','HorizontalAlignment','center');
  plot([3 3],[0 0.3],'b-','LineWidth',2); text(3,0.4,'t4','FontSize',9,'Color','b','HorizontalAlignment','center');
  plot([6 6],[0 -0.3],'r-','LineWidth',2); text(6,-0.4,'t2','FontSize',9,'Color','r','HorizontalAlignment','center');
  plot([8 8],[0 -0.3],'r-','LineWidth',2); text(8,-0.4,'t3','FontSize',9,'Color','r','HorizontalAlignment','center');
  plot([0 10],[0 0],'k-','LineWidth',1.5);

  subplot(1,2,2); hold on; box on; grid on;
  title('(b) Impacto de la deriva de los relojes','FontSize',10);
  xlabel('Tiempo [s]'); ylabel('Offset [s]'); axis([0 10 -1 1]);
  t=linspace(0,10,100);
  plot(t,0.3*cos(t/3),'b-','LineWidth',2,'DisplayName','Maestro (ref)');
  plot(t,0.5*cos(t/2.7)+0.2,'r--','LineWidth',2,'DisplayName','Esclavo (deriva)');
  legend('Location','southoutside','FontSize',9);
  text(5,-0.85,'El offset crece con el tiempo debido al skew','FontSize',9,'HorizontalAlignment','center');
  % sgtitle('Figura 1.4','FontSize',11); (use suptitle in Octave)
  export_fig(gcf, 'ch01/fig_1_4_retardo_y_deriva.pdf');
  close(gcf); fprintf(' OK\n');
end

% =========================================================================
% CAPÍTULO 2
% =========================================================================

function fig_2_1()
  fprintf('  fig_2_1_ubicaciones_ts...');
  figure('Position',[100 100 450 500],'Color','w');
  clf; hold on; axis off;
  y0=0.75; w=0.5; h=0.07; xc=0.5;
  capas={'APLICACION (t\_clock())','PILA DE RED / DRIVER','CAPA MAC','CAPA FISICA - PHY','MEDIO INALAMBRICO'};
  cols=[0.8 0.2 0.2; 0.8 0.4 0.2; 0.8 0.8 0.2; 0.2 0.8 0.2; 0.2 0.2 0.8];
  for i=1:5
    yi=y0-(i-1)*0.1;
    rectangle('Position',[xc-w/2 yi w h],'FaceColor',cols(i,:),'EdgeColor',cols(i,:)*0.7,'LineWidth',2,'Curvature',0.05);
    text(xc,yi+h/2,capas{i},'FontSize',10,'HorizontalAlignment','center','FontWeight','bold');
  end
  annotation('textarrow',[0.78 0.85],[0.7 0.35],'String','Precision creciente','FontSize',9,'LineWidth',1.5);
  text(0.5,0.2,'TS por SW: alta varianza','FontSize',8,'Color',[0.8 0.2 0.2],'HorizontalAlignment','center');
  text(0.5,0.15,'TS por HW: precision ns', 'FontSize',8,'Color',[0.2 0.8 0.2],'HorizontalAlignment','center');
  text(0.5,0.05,'Fuente: Adaptado de [56].','FontSize',9,'Color',[0.5 0.5 0.5],'HorizontalAlignment','center');
  export_fig(gcf, 'ch02/fig_2_1_ubicaciones_ts.pdf');
  close(gcf); fprintf(' OK\n');
end

function fig_2_2()
  fprintf('  fig_2_2_latencias_sw...');
  figure('Position',[100 100 900 400],'Color','w');
  clf; hold on; axis off;
  text(0.5,0.95,'Latencias de estampa de tiempo de software','FontSize',12,'FontWeight','bold','HorizontalAlignment','center');

  rect = [0.05 0.5 0.12 0.1];
  rectangle('Position',rect,'FaceColor',[0.2 0.3 0.8],'EdgeColor',[0.2 0.3 0.8],'LineWidth',2,'Curvature',0.1);
  text(0.11,0.55,'Software TX','FontSize',8,'HorizontalAlignment','center');

  rect = [0.17 0.5 0.1 0.1];
  rectangle('Position',rect,'FaceColor',[1 1 0],'EdgeColor',[1 1 0],'LineWidth',2,'Curvature',0.1);
  text(0.22,0.55,'p1','FontSize',8,'HorizontalAlignment','center');

  annotation('arrow',[0.27 0.73],[0.7 0.7],'LineWidth',2);
  text(0.5,0.75,'tms (propagacion M->S)','FontSize',8,'HorizontalAlignment','center');

  rect = [0.73 0.5 0.1 0.1];
  rectangle('Position',rect,'FaceColor',[1 1 0],'EdgeColor',[1 1 0],'LineWidth',2,'Curvature',0.1);
  text(0.78,0.55,'p2','FontSize',8,'HorizontalAlignment','center');

  rect = [0.83 0.5 0.12 0.1];
  rectangle('Position',rect,'FaceColor',[0.2 0.6 0.2],'EdgeColor',[0.2 0.6 0.2],'LineWidth',2,'Curvature',0.1);
  text(0.89,0.55,'Software RX','FontSize',8,'HorizontalAlignment','center');

  annotation('arrow',[0.73 0.27],[0.3 0.3],'LineWidth',2);
  text(0.5,0.25,'tsm (propagacion S->M)','FontSize',8,'HorizontalAlignment','center');

  % Timestamps
  text(0.1,0.63,'^t1','FontSize',10,'FontWeight','bold','Color','b');
  text(0.9,0.63,'^t2','FontSize',10,'FontWeight','bold','Color','r');
  text(0.9,0.38,'^t3','FontSize',10,'FontWeight','bold','Color','r');
  text(0.1,0.38,'^t4','FontSize',10,'FontWeight','bold','Color','b');

  rect = [0.15 0.02 0.7 0.08];
  rectangle('Position',rect,'FaceColor',[1 1 1],'EdgeColor',[0.5 0.5 0.5],'LineWidth',1,'Curvature',0.1);
  text(0.5,0.06,'t1 = ^t1 + p1  |  t2 = ^t2 - p2  |  t3 = ^t3 + p3  |  t4 = ^t4 - p4','FontSize',10,'HorizontalAlignment','center');
  text(0.5,-0.05,'Fuente: Adaptado de [11].','FontSize',9,'Color',[0.5 0.5 0.5],'HorizontalAlignment','center');
  export_fig(gcf, 'ch02/fig_2_2_latencias_sw.pdf');
  close(gcf); fprintf(' OK\n');
end

function fig_2_4()
  fprintf('  fig_2_4_metodo_hibrido...');
  figure('Position',[100 100 700 500],'Color','w');
  clf; hold on; axis off;

  text(0.5,0.95,'METODO HIBRIDO: EXEL + AKF','FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

  rectangle('Position',[0.15 0.55 0.3 0.18],'FaceColor',[0.2 0.3 0.8],...
    'EdgeColor',[0.2 0.3 0.8],'LineWidth',2,'Curvature',0.1);
  text(0.3,0.67,'ETAPA 1: EXEL','FontSize',11,'FontWeight','bold','HorizontalAlignment','center');
  text(0.3,0.6,'Correccion determinista','FontSize',9,'HorizontalAlignment','center');
  text(0.3,0.57,'p1-p4 en estampas','FontSize',9,'HorizontalAlignment','center');

  annotation('arrow',[0.3 0.5],[0.48 0.48],'LineWidth',2);
  text(0.4,0.5,'zk = theta\_Exel','FontSize',9,'HorizontalAlignment','center');

  rectangle('Position',[0.55 0.35 0.3 0.25],'FaceColor',[1 0.5 0.05],...
    'EdgeColor',[1 0.5 0.05],'LineWidth',2,'Curvature',0.1);
  text(0.7,0.54,'ETAPA 2: AKF','FontSize',11,'FontWeight','bold','HorizontalAlignment','center');
  text(0.7,0.47,'Filtro de Kalman Adaptativo','FontSize',9,'HorizontalAlignment','center');
  text(0.7,0.41,'3 estados: [theta, skew, Delta]','FontSize',8,'HorizontalAlignment','center');
  text(0.7,0.37,'Rk adaptativo (N=20)','FontSize',8,'HorizontalAlignment','center');

  annotation('arrow',[0.7 0.7],[0.3 0.18],'LineWidth',2);
  text(0.72,0.24,'theta\_AKF','FontSize',9,'HorizontalAlignment','center');

  rectangle('Position',[0.45 0.05 0.5 0.12],'FaceColor',[0.2 0.6 0.2],...
    'EdgeColor',[0.2 0.6 0.2],'LineWidth',2,'Curvature',0.1);
  text(0.7,0.11,'CORRECCION RELOJ ESCLAVO','FontSize',11,'FontWeight','bold','HorizontalAlignment','center');

  annotation('arrow',[0.1 0.15],[0.64 0.64],'LineWidth',2);
  text(0.05,0.66,'Mensajes gPTP','FontSize',8,'HorizontalAlignment','center');
  text(0.05,0.62,'(t1..t4)','FontSize',8,'HorizontalAlignment','center');

  export_fig(gcf, 'ch02/fig_2_4_metodo_hibrido.pdf');
  close(gcf); fprintf(' OK\n');
end

function fig_2_5()
  fprintf('  fig_2_5_ciclo_akf...');
  figure('Position',[100 100 700 600],'Color','w');
  clf; hold on; axis off;

  text(0.5,0.97,'Ciclo del Filtro de Kalman Adaptativo','FontSize',13,'FontWeight','bold','HorizontalAlignment','center');

  rect = [0.15 0.82 0.3 0.08];
  rectangle('Position',rect,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.3 0.3 0.3],'LineWidth',2,'Curvature',0.1);
  text(0.3,0.86,'Inicializacion: x0, P0, Q, R0, N=20','FontSize',9,'HorizontalAlignment','center');

  rect = [0.15 0.62 0.3 0.12];
  rectangle('Position',rect,'FaceColor',[0.4 0.6 0.8],'EdgeColor',[0.2 0.3 0.8],'LineWidth',2,'Curvature',0.1);
  text(0.3,0.7,'PREDICCION','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
  text(0.3,0.65,'x^- = F*x  |  P^- = F*P*F''+Q','FontSize',8,'HorizontalAlignment','center');

  rect = [0.55 0.65 0.3 0.12];
  rectangle('Position',rect,'FaceColor',[0.8 0.8 0.2],'EdgeColor',[0.6 0.6 0],'LineWidth',2,'Curvature',0.1);
  text(0.7,0.73,'MEDICION zk','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
  text(0.7,0.68,'zk = theta\_Exel','FontSize',9,'HorizontalAlignment','center');

  rect = [0.55 0.5 0.3 0.08];
  rectangle('Position',rect,'FaceColor',[0.8 0.4 0.2],'EdgeColor',[0.8 0.4 0.2],'LineWidth',1.5,'Curvature',0.1);
  text(0.7,0.54,'Rk = var(innovaciones, N=20)','FontSize',8,'HorizontalAlignment','center');

  rect = [0.15 0.42 0.3 0.12];
  rectangle('Position',rect,'FaceColor',[0.2 0.6 0.2],'EdgeColor',[0.2 0.6 0.2],'LineWidth',2,'Curvature',0.1);
  text(0.3,0.5,'ACTUALIZACION','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
  text(0.3,0.45,'K = P^-*H''/(H*P^-*H''+Rk)','FontSize',8,'HorizontalAlignment','center');
  text(0.3,0.425,'x = x^- + K*(zk - H*x^-)','FontSize',8,'HorizontalAlignment','center');

  annotation('arrow',[0.3 0.3],[0.78 0.74],'LineWidth',2);
  annotation('arrow',[0.3 0.55],[0.68 0.68],'LineWidth',2);
  annotation('arrow',[0.85 0.85],[0.65 0.58],'LineWidth',1.5);
  annotation('arrow',[0.7 0.45],[0.54 0.48],'LineWidth',2);
  annotation('arrow',[0.3 0.3],[0.38 0.18],'LineWidth',2);

  rect = [0.15 0.08 0.3 0.08];
  rectangle('Position',rect,'FaceColor',[0.2 0.8 0.2],'EdgeColor',[0.2 0.8 0.2],'LineWidth',2,'Curvature',0.1);
  text(0.3,0.12,'SALIDA: theta\_AKF','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');

  annotation('arrow',[0.45 0.6],[0.12 0.86],'LineWidth',1.5,'LineStyle',':','Color',[0.5 0.5 0.5]);
  export_fig(gcf, 'ch02/fig_2_5_ciclo_akf.pdf');
  close(gcf); fprintf(' OK\n');
end

% =========================================================================
% CAPÍTULO 3
% =========================================================================

function fig_3_1()
  fprintf('  fig_3_1_esquema_implementacion...');
  figure('Position',[100 100 800 400],'Color','w');
  clf; hold on; axis off;

  text(0.5,0.95,'Esquema de la implementacion desarrollada','FontSize',13,'FontWeight','bold','HorizontalAlignment','center');

  rect = [0.03 0.35 0.15 0.15];
  rectangle('Position',rect,'FaceColor',[0.2 0.3 0.8],'EdgeColor',[0.2 0.3 0.8],'LineWidth',2,'Curvature',0.1);
  text(0.105,0.43,'MAESTRO','FontSize',11,'FontWeight','bold','HorizontalAlignment','center');
  text(0.105,0.37,'(GM)','FontSize',8,'HorizontalAlignment','center');

  rect = [0.55 0.3 0.25 0.25];
  rectangle('Position',rect,'FaceColor',[0.2 0.6 0.2],'EdgeColor',[0.2 0.6 0.2],'LineWidth',2,'Curvature',0.1);
  text(0.675,0.48,'ESCLAVO','FontSize',11,'FontWeight','bold','HorizontalAlignment','center');
  text(0.675,0.42,'Etapa 1: Exel','FontSize',8,'HorizontalAlignment','center');
  text(0.675,0.36,'Etapa 2: AKF','FontSize',8,'HorizontalAlignment','center');

  annotation('arrow',[0.18 0.55],[0.5 0.5],'LineWidth',2);
  text(0.365,0.53,'Tms = d/c + ta','FontSize',10,'HorizontalAlignment','center');
  annotation('arrow',[0.55 0.18],[0.35 0.35],'LineWidth',2);
  text(0.365,0.3,'Tsm = d/c - ta','FontSize',10,'HorizontalAlignment','center');

  annotation('textarrow',[0.18 0.55],[0.6 0.6],'String','d = 30 m','FontSize',9,'LineWidth',1);
  text(0.5,0.12,'d=30m | c=3e8 m/s | ta=asimetria desconocida','FontSize',9,'HorizontalAlignment','center');
  text(0.5,0.03,'Fuente: Elaboracion propia.','FontSize',9,'Color',[0.5 0.5 0.5],'HorizontalAlignment','center');

  export_fig(gcf, 'ch03/fig_3_1_esquema_implementacion.pdf');
  close(gcf); fprintf(' OK\n');
end
