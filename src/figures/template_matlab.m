% ===========================================================================
% Plantilla MATLAB/Octave para figuras de resultados de la tesis
% Uso: ejecutar al inicio de cada script plot_*.m para estilo uniforme
% ===========================================================================

function setup_thesis_figure(varargin)
%SETUP_THESIS_FIGURE Configura una figura con estilo uniforme para la tesis.
%
%   Uso:
%       setup_thesis_figure('Size', [900 500]);
%       setup_thesis_figure('Size', [700 500], 'Subplot', [1 2]);
%
%   Parámetros opcionales (Name-Value):
%       'Size'      — [ancho alto] en píxeles (default: [900 500])
%       'Subplot'   — [filas cols] para crear subplots (default: none)
%       'Title'     — título de la figura (string)

    p = inputParser;
    addParameter(p, 'Size', [900 500], @(x) isnumeric(x) && numel(x)==2);
    addParameter(p, 'Subplot', [], @(x) isnumeric(x) && numel(x)==2);
    addParameter(p, 'Title', '', @ischar);
    parse(p, varargin{:});

    % Colores colorblind-safe
    colors.sym = [0.173, 0.627, 0.173];   % #2ca02c verde
    colors.asy = [0.839, 0.153, 0.157];  % #d62728 rojo
    colors.exl = [0.122, 0.467, 0.706];  % #1f77b4 azul
    colors.akf = [1.000, 0.498, 0.055];  % #ff7f0e naranja
    colors.ref = [0.800, 0.800, 0.800];  % #cccccc gris

    % Configuración de la figura
    fig = figure('Color', 'w', ...
                 'Position', [100 100 p.Results.Size(1) p.Results.Size(2)], ...
                 'PaperPositionMode', 'auto');

    if ~isempty(p.Results.Subplot)
        for sp = 1:prod(p.Results.Subplot)
            subplot(p.Results.Subplot(1), p.Results.Subplot(2), sp);
            hold on; grid on; box on;
            set(gca, 'FontSize', 11, 'FontName', 'Latin Modern Roman', ...
                     'GridColor', colors.ref, 'MinorGridColor', colors.ref);
        end
    else
        hold on; grid on; box on;
        set(gca, 'FontSize', 11, 'FontName', 'Latin Modern Roman', ...
                 'GridColor', colors.ref, 'MinorGridColor', colors.ref);
    end

    if ~isempty(p.Results.Title)
        sgtitle(p.Results.Title, 'FontSize', 14, 'FontWeight', 'bold');
    end

    % Guardar colores en UserData para acceso posterior
    set(fig, 'UserData', colors);
end

% ===========================================================================
% Ejemplo de uso:
% ===========================================================================
% setup_thesis_figure('Size', [900 500]);
% plot(1:10, rand(1,10), 'Color', get(gcf,'UserData').exl, 'LineWidth', 1.5);
% xlabel('Tiempo [s]'); ylabel('Precisión [µs]');
% legend('Exel', 'Location', 'best');
% exportgraphics(gcf, 'fig_3_2_ejemplo.pdf', 'ContentType', 'vector');
