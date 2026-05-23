% ===========================================================================
% gptp_referencia.m
% Implementación de referencia: protocolo gPTP + corrección Exel
% Basado en: Eupierre Oquendo (2024), Sección 3.1
% ===========================================================================
%
% Descripción:
%   Simulador de eventos discretos del protocolo gPTP (IEEE 802.1AS) para un
%   enlace inalámbrico punto a punto (maestro-esclavo). Implementa la
%   corrección de estampas de tiempo de Reinhard Exel [exel2014] para mitigar
%   el efecto de los retardos asimétricos.
%
%   Tres escenarios de simulación:
%     escenario = 1: Enlace simétrico (gPTP estándar, sin asimetrías)
%     escenario = 2: Enlace asimétrico sin corrección
%     escenario = 3: Enlace asimétrico con corrección Exel
%
% Uso:
%   [offset_final, precision, offset_hist] = gptp_referencia(...
%       duracion, freq_offset, freq_msg, distancia, escenario)
%
% Parámetros de entrada:
%   duracion    - Duración total de la simulación [s] (típico: 60)
%   freq_offset - Frecuencia de medición/corrección del offset [Hz] (típico: 1)
%   freq_msg    - Frecuencia de intercambio de mensajes gPTP [Hz] (típico: 1)
%   distancia   - Distancia entre dispositivos [m] (típico: 30)
%   escenario   - 1=simétrico, 2=asimétrico sin corr., 3=asimétrico con Exel
%
% Parámetros de salida:
%   offset_final - Offset medio estabilizado [s]
%   precision    - Precisión media del sincronismo [s]
%   offset_hist  - Vector con el historial de valores de offset [s]
% ===========================================================================

function [offset_final, precision, offset_hist] = gptp_referencia(...
    duracion, freq_offset, freq_msg, distancia, escenario)

    % === Constantes físicas ===============================================
    c = 3e8;                % Velocidad de la luz [m/s]
    tic_res = 1e-3;         % Resolución del reloj (tic) [s] = 1 ms

    % === Parámetros del enlace ============================================
    t_prop_base = distancia / c;   % Retardo de propagación nominal [s]

    % === Parámetros de los relojes ========================================
    % Cada dispositivo tiene un offset inicial aleatorio y una deriva (skew)
    % diferente, simulando las imperfecciones de relojes reales.

    % Offset inicial del reloj esclavo respecto al maestro [s]
    offset_inicial = (rand() - 0.5) * 2 * 1e-2;  % ±10 ms

    % Deriva (skew) de cada reloj [adimensional, ~1.0]
    % Osciladores típicos: ±20-50 ppm → skew entre 0.999950 y 1.000050
    skew_maestro = 1.0 + (rand() - 0.5) * 2 * 30e-6;   % ±30 ppm
    skew_esclavo = 1.0 + (rand() - 0.5) * 2 * 30e-6;   % ±30 ppm

    % Rate ratio: relación de frecuencias esclavo/maestro
    rate_ratio = skew_esclavo / skew_maestro;

    % === Parámetros de la corrección Exel =================================
    % Los retardos de procesamiento asimétricos p1-p4 incluyen:
    %   - Componente determinista (conocida, corregible)
    %   - Componentes por: velocidad de datos, tamaño de encabezado,
    %     modulación, tamaño de transferencia DMA, velocidad de interfaz DMA

    % p1: retardo de procesamiento de salida en maestro [s]
    % p2: retardo de procesamiento de entrada en esclavo [s]
    % p3: retardo de procesamiento de salida en esclavo [s]
    % p4: retardo de procesamiento de entrada en maestro [s]

    p_determinista = 50e-6;          % Componente base determinista [s] = 50 µs
    p_aleatorio    = 100e-6;         % Amplitud de variación aleatoria [s]

    p1 = p_determinista + rand() * p_aleatorio;
    p2 = p_determinista + rand() * p_aleatorio;
    p3 = p_determinista + rand() * p_aleatorio;
    p4 = p_determinista + rand() * p_aleatorio;

    % === Asimetría desconocida =============================================
    % Término no determinista que representa asimetrías que no pueden ser
    % predichas ni corregidas por el método Exel
    asim_desconocida = 0;            % [s] — varía según escenario
    if escenario == 2 || escenario == 3
        asim_desconocida = 120e-6 + rand() * 20e-6;  % 120-140 µs (media ~130 µs)
    end

    % === Inicialización de variables de estado =============================
    % Tiempos locales de cada dispositivo (afectados por skew)
    t_maestro = 0;                   % Reloj maestro (referencia)
    t_esclavo = offset_inicial;      % Reloj esclavo (con offset inicial)

    % Tiempo global de simulación
    t_global = 0;

    % Vector para almacenar historial de offset
    num_mediciones = floor(duracion * freq_offset);
    offset_hist = zeros(1, num_mediciones);
    precision_hist = zeros(1, num_mediciones);
    idx_hist = 0;

    % === Variables para el intercambio de mensajes gPTP ====================
    % Marcas de tiempo del intercambio Pdelay (medición de retardo)
    t1 = 0; t2 = 0; t3 = 0; t4 = 0;

    % Offset calculado acumulado
    offset_acumulado = offset_inicial;

    % === Bucle principal de simulación (eventos discretos) =================
    % Períodos de los eventos
    periodo_offset = 1 / freq_offset;   % Período de corrección [s] (típico: 1 s)
    periodo_msg   = 1 / freq_msg;       % Período de mensajes [s] (típico: 1 s)

    % Tiempos de los próximos eventos
    t_next_offset = periodo_offset;
    t_next_msg    = periodo_msg;

    iter = 0;
    max_iter = duracion * 1000;  % Límite de seguridad

    while t_global < duracion && iter < max_iter
        iter = iter + 1;

        % Avanzar los relojes al tiempo global actual
        % (los relojes avanzan según su propio skew)
        t_maestro = t_maestro + skew_maestro * tic_res;
        t_esclavo = t_esclavo + skew_esclavo * tic_res;

        % Determinar el próximo evento (offset o mensaje)
        if t_next_offset <= t_next_msg
            % === EVENTO: Corrección de offset =============================
            t_global = t_next_offset;
            t_next_offset = t_next_offset + periodo_offset;

            % Calcular offset verdadero entre maestro y esclavo
            offset_verdadero = t_esclavo - t_maestro;

            % Almacenar en historial
            idx_hist = idx_hist + 1;
            if idx_hist <= num_mediciones
                offset_hist(idx_hist) = offset_verdadero;
                precision_hist(idx_hist) = abs(offset_verdadero);
            end

            % Aplicar corrección al reloj esclavo (cada segundo)
            % El offset calculado por gPTP se usa para ajustar el esclavo
            t_esclavo = t_esclavo - offset_acumulado;

        else
            % === EVENTO: Intercambio de mensajes gPTP =====================
            t_global = t_next_msg;
            t_next_msg = t_next_msg + periodo_msg;

            % --- Mensaje Pdelay_Req (solicitante → respondedor) ---
            % Maestro envía Pdelay_Req
            t1_raw = t_maestro;                        % Estampa software (salida)
            t1_corr = t1_raw + p1;                     % Corrección Exel (Ec. 2.3)

            % Retardo de propagación maestro → esclavo
            t_ms = t_prop_base + asim_desconocida/2;

            % Retardo de procesamiento en esclavo (recepción)
            t_proc_esclavo = rand() * 100e-6;          % 0-100 µs aleatorio

            % Esclavo recibe Pdelay_Req
            t2_raw = t_esclavo + t_ms + t_proc_esclavo;  % Estampa software
            t2_corr = t2_raw - p2;                        % Corrección Exel (Ec. 2.4)

            % --- Mensaje Pdelay_Resp (respondedor → solicitante) ---
            % Esclavo envía Pdelay_Resp (después de procesar)
            t3_raw = t2_raw + rand() * 200e-6;         % Estampa software (salida)
            t3_corr = t3_raw + p3;                     % Corrección Exel (Ec. 2.5)

            % Retardo de propagación esclavo → maestro
            t_sm = t_prop_base - asim_desconocida/2;

            % Retardo de procesamiento en maestro (recepción)
            t_proc_maestro = rand() * 100e-6;          % 0-100 µs aleatorio

            % Maestro recibe Pdelay_Resp
            t4_raw = t_maestro + t_sm + t_proc_maestro;  % Estampa software
            t4_corr = t4_raw - p4;                        % Corrección Exel (Ec. 2.6)

            % Seleccionar marcas según escenario
            if escenario == 3
                % Escenario 3: con corrección Exel
                T1 = t1_corr; T2 = t2_corr; T3 = t3_corr; T4 = t4_corr;
            else
                % Escenarios 1 y 2: sin corrección (marcas crudas)
                T1 = t1_raw; T2 = t2_raw; T3 = t3_raw; T4 = t4_raw;
            end

            % --- Cálculo del retardo de propagación (Pdelay) ---
            % Ecuación 1.2 del estándar: Pdelay = ((t4-t1) - r*(t3-t2))/2
            Pdelay = ((T4 - T1) - rate_ratio * (T3 - T2)) / 2;

            % --- Cálculo del offset (Ecuación 2.7 con corrección Exel) ---
            % offset = ((t2-t1) - (t4-t3)) / 2
            offset_calculado = ((T2 - T1) - (T4 - T3)) / 2;

            % Actualizar offset acumulado para la próxima corrección
            offset_acumulado = offset_calculado;
        end
    end

    % === Cálculo de métricas finales ======================================
    % Descartar período de convergencia inicial (primeros 4 segundos ≈ 2 períodos gPTP)
    idx_estable = max(1, floor(4 * freq_offset)) : idx_hist;

    if length(idx_estable) > 1
        precision = mean(precision_hist(idx_estable));
        offset_final = mean(offset_hist(idx_estable));
    else
        precision = mean(precision_hist(1:idx_hist));
        offset_final = mean(offset_hist(1:idx_hist));
    end

end
