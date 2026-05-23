% ===========================================================================
% gptp_asimetrico_mejorado.m
% Implementación mejorada: gPTP + corrección Exel + Filtro de Kalman Adaptativo
% ===========================================================================
%
% Descripción:
%   Extiende la implementación de referencia (gptp_referencia.m) añadiendo
%   una segunda etapa de filtrado estadístico mediante un Filtro de Kalman
%   Adaptativo (AKF) de 3 estados. El AKF estima conjuntamente el offset (θ),
%   el skew (s) y la asimetría residual (Δ), filtrando el ruido de medición
%   y compensando las asimetrías desconocidas que el método de Exel no corrige.
%
%   Arquitectura de dos etapas:
%     Etapa 1: Corrección determinista de Exel (p1–p4) → θ̂_Exel
%     Etapa 2: Filtro de Kalman Adaptativo → θ̂_AKF (offset filtrado)
%
% Uso:
%   [offset_final, precision, offset_hist] = gptp_asimetrico_mejorado(...
%       duracion, freq_offset, freq_msg, distancia)
%
% Parámetros:
%   (mismos que gptp_referencia.m, sin parámetro 'escenario')
% ===========================================================================

function [offset_final, precision, offset_hist, diag] = ...
    gptp_asimetrico_mejorado(duracion, freq_offset, freq_msg, distancia)

    % === Constantes físicas ===============================================
    c = 3e8;
    tic_res = 1e-3;

    % === Parámetros del enlace ============================================
    t_prop_base = distancia / c;

    % === Relojes ==========================================================
    offset_inicial = (rand() - 0.5) * 2 * 1e-2;
    skew_maestro = 1.0 + (rand() - 0.5) * 2 * 30e-6;
    skew_esclavo = 1.0 + (rand() - 0.5) * 2 * 30e-6;
    rate_ratio = skew_esclavo / skew_maestro;

    % === Corrección Exel (Etapa 1) ========================================
    p_determinista = 50e-6;
    p_aleatorio    = 100e-6;
    p1 = p_determinista + rand() * p_aleatorio;
    p2 = p_determinista + rand() * p_aleatorio;
    p3 = p_determinista + rand() * p_aleatorio;
    p4 = p_determinista + rand() * p_aleatorio;

    % Asimetría desconocida (la que el AKF debe estimar y compensar)
    asim_desconocida = 120e-6 + rand() * 20e-6;

    % === Inicialización del AKF (Etapa 2) =================================
    tau = 1 / freq_offset;  % Intervalo entre correcciones de offset [s]
    N_ventana = 20;         % Tamaño de ventana para adaptación de R_k

    % Parámetros iniciales del AKF
    [Q0, R0, P0, x0] = akf_init_mejorado(offset_inicial, tau);

    % Buffers para el AKF
    z_buffer = [];           % Mediciones de offset (Exel) para el AKF
    t_buffer = [];           % Tiempos correspondientes

    % === Variables de estado ==============================================
    t_maestro = 0;
    t_esclavo = offset_inicial;
    t_global = 0;

    num_mediciones = floor(duracion * freq_offset);
    offset_raw_hist = zeros(1, num_mediciones);   % Offset sin filtrar (Exel)
    offset_akf_hist = zeros(1, num_mediciones);   % Offset filtrado (AKF)
    precision_hist  = zeros(1, num_mediciones);
    idx_hist = 0;

    offset_acumulado = offset_inicial;

    % === Eventos ==========================================================
    periodo_offset = 1 / freq_offset;
    periodo_msg   = 1 / freq_msg;

    t_next_offset = periodo_offset;
    t_next_msg    = periodo_msg;

    iter = 0;
    max_iter = duracion * 1000;

    % === Bucle principal ==================================================
    while t_global < duracion && iter < max_iter
        iter = iter + 1;

        t_maestro = t_maestro + skew_maestro * tic_res;
        t_esclavo = t_esclavo + skew_esclavo * tic_res;

        if t_next_offset <= t_next_msg
            % === EVENTO: Corrección de offset =============================
            t_global = t_next_offset;
            t_next_offset = t_next_offset + periodo_offset;

            offset_verdadero = t_esclavo - t_maestro;

            idx_hist = idx_hist + 1;
            if idx_hist <= num_mediciones
                offset_raw_hist(idx_hist) = offset_verdadero;

                % Si tenemos suficientes mediciones, aplicar AKF
                if length(z_buffer) >= N_ventana
                    % Ejecutar AKF sobre el buffer de mediciones Exel
                    [x_est, ~, ~] = kalman_filter_mejorado(...
                        z_buffer, tau, N_ventana, Q0, R0, P0, x0);

                    % El offset filtrado es el primer componente del estado
                    offset_filtrado = x_est(1, end);

                    % Corregir el reloj esclavo usando offset filtrado
                    t_esclavo = t_esclavo - offset_filtrado;

                    offset_akf_hist(idx_hist) = offset_filtrado;
                    precision_hist(idx_hist) = abs(offset_filtrado);
                else
                    % Sin suficientes datos, usar solo Exel
                    t_esclavo = t_esclavo - offset_acumulado;
                    offset_akf_hist(idx_hist) = offset_acumulado;
                    precision_hist(idx_hist) = abs(offset_acumulado);
                end
            end

        else
            % === EVENTO: Intercambio de mensajes gPTP =====================
            t_global = t_next_msg;
            t_next_msg = t_next_msg + periodo_msg;

            % --- Mensaje Pdelay_Req ---
            t1_raw = t_maestro;
            t1_corr = t1_raw + p1;

            t_ms = t_prop_base + asim_desconocida/2;
            t_proc_esclavo = rand() * 100e-6;

            t2_raw = t_esclavo + t_ms + t_proc_esclavo;
            t2_corr = t2_raw - p2;

            % --- Mensaje Pdelay_Resp ---
            t3_raw = t2_raw + rand() * 200e-6;
            t3_corr = t3_raw + p3;

            t_sm = t_prop_base - asim_desconocida/2;
            t_proc_maestro = rand() * 100e-6;

            t4_raw = t_maestro + t_sm + t_proc_maestro;
            t4_corr = t4_raw - p4;

            % --- Cálculo con corrección Exel ---
            Pdelay = ((t4_corr - t1_corr) - rate_ratio * (t3_corr - t2_corr)) / 2;
            offset_calculado = ((t2_corr - t1_corr) - (t4_corr - t3_corr)) / 2;

            offset_acumulado = offset_calculado;

            % Acumular medición para el AKF
            z_buffer = [z_buffer; offset_calculado];
            t_buffer = [t_buffer; t_global];

            % Limitar tamaño del buffer para eficiencia
            if length(z_buffer) > 500
                z_buffer = z_buffer(end-499:end);
                t_buffer = t_buffer(end-499:end);
            end
        end
    end

    % === Métricas finales =================================================
    idx_estable = max(1, floor(4 * freq_offset)) : idx_hist;

    if length(idx_estable) > 1
        precision = mean(precision_hist(idx_estable));
        offset_final = mean(offset_akf_hist(idx_estable));
    else
        precision = mean(precision_hist(1:idx_hist));
        offset_final = mean(offset_akf_hist(1:idx_hist));
    end

    offset_hist = offset_akf_hist;

    % Datos de diagnóstico
    diag.offset_raw = offset_raw_hist;
    diag.offset_akf = offset_akf_hist;
    diag.z_buffer = z_buffer;
    diag.params = struct('N_ventana', N_ventana, 'Q0', Q0, 'R0', R0);

end

% ===========================================================================
% Función auxiliar: versión simplificada del AKF para uso en línea
% ===========================================================================

function [x_est, P_est, innov_hist] = kalman_filter_mejorado(z, tau, ...
    N_ventana, Q0, R0, P0, x0)

    % Versión autocontenida del AKF (evita dependencia externa)
    n = length(z);

    F = [1, tau, 0; 0, 1, 0; 0, 0, 1];
    H = [1, 0, 0.5];
    I = eye(3);

    x_est = zeros(3, n);
    P_est = cell(n, 1);
    innov_hist = zeros(n, 1);

    x = x0;
    P = P0;
    R = R0;

    innov_buffer = zeros(N_ventana, 1);

    for k = 1:n
        % Predicción
        x_pred = F * x;
        P_pred = F * P * F' + Q0;

        % Innovación
        nu = z(k) - H * x_pred;
        idx_buf = mod(k-1, N_ventana) + 1;
        innov_buffer(idx_buf) = nu;
        innov_hist(k) = nu;

        % Adaptación de R
        if k >= N_ventana
            R = var(innov_buffer);
            R = max(R, 1e-20);
            R = min(R, 1e-6);
        end

        % Actualización
        S = H * P_pred * H' + R;
        K = P_pred * H' / S;
        x = x_pred + K * nu;
        P = (I - K * H) * P_pred;

        x_est(:, k) = x;
        P_est{k} = P;
    end
end

% ===========================================================================
% Inicialización de parámetros
% ===========================================================================

function [Q0, R0, P0, x0] = akf_init_mejorado(theta0, tau)
    x0 = [theta0; 0; 0];
    P0 = diag([1e-10, 1e-12, 1e-14]);
    Q0 = diag([1e-14, 1e-18, 1e-16]);
    R0 = 1e-12;
end
