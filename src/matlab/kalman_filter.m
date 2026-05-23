% ===========================================================================
% kalman_filter.m
% Filtro de Kalman Adaptativo (AKF) para estimación de offset en gPTP
% ===========================================================================
%
% Descripción:
%   Implementa un Filtro de Kalman Adaptativo de 3 estados para la estimación
%   conjunta de offset (θ), skew (s) y asimetría residual (Δ) en el protocolo
%   gPTP. La adaptación de la varianza del ruido de medición (R_k) se realiza
%   mediante una ventana deslizante sobre las innovaciones recientes.
%
%   Modelo de espacio de estados:
%     x_k = [θ_k; s_k; Δ_k]
%     x_{k+1} = F x_k + w_k,   w_k ~ N(0, Q)
%     z_k     = H x_k + v_k,   v_k ~ N(0, R_k)
%
% Referencias:
%   [hollosi2024] Hollósi & Ficzere, "Adaptive Kalman filtering in offset
%                 estimation for PTP", IEEE Trans. Ind. Inform., 2024.
%   [li2024]      Li et al., "Enhanced time sync based on Kalman filtering",
%                 Scientific Reports, 2024.
%
% Uso:
%   [x_est, P_est, innov_hist] = kalman_filter(z, tau, N_ventana, ...
%                                             Q0, R0, P0, x0)
%
% Parámetros de entrada:
%   z         - Vector de mediciones de offset [s] (salidas de la etapa Exel)
%   tau       - Intervalo entre mediciones [s] (período de gPTP, típico: 2)
%   N_ventana - Tamaño de ventana para adaptación de R_k (típico: 20)
%   Q0        - Covarianza inicial del ruido de proceso (3×3)
%   R0        - Varianza inicial del ruido de medición (escalar)
%   P0        - Covarianza inicial del error de estimación (3×3)
%   x0        - Estado inicial [θ0; s0; Δ0] (3×1)
%
% Parámetros de salida:
%   x_est      - Matriz de estados estimados (3 × n_mediciones)
%   P_est      - Celda con matrices de covarianza del error
%   innov_hist - Vector de innovaciones (útil para diagnóstico)
% ===========================================================================

function [x_est, P_est, innov_hist] = kalman_filter(z, tau, N_ventana, ...
    Q0, R0, P0, x0)

    n = length(z);          % Número de mediciones
    if n < 3
        error('Se requieren al menos 3 mediciones para el AKF.');
    end

    % === Matriz de transición de estado ===================================
    F = [1, tau, 0;
         0,   1, 0;
         0,   0, 1];

    % === Matriz de observación ============================================
    H = [1, 0, 0.5];       % La asimetría contribuye con Δ/2 al offset

    % === Inicialización ===================================================
    I = eye(3);             % Matriz identidad 3×3

    x_est = zeros(3, n);    % Historial de estados estimados
    P_celda = cell(n, 1);   % Historial de covarianzas
    innov_hist = zeros(n, 1);

    % Estado inicial
    x = x0;                 % Estado actual
    P = P0;                 % Covarianza actual
    Q = Q0;
    R = R0;

    % Buffer circular para innovaciones (adaptación de R)
    innov_buffer = zeros(N_ventana, 1);
    idx_buffer = 0;

    % === Bucle principal del filtro =======================================
    for k = 1:n
        % --- Fase de predicción ---
        x_pred = F * x;                    % Estado predicho
        P_pred = F * P * F' + Q;           % Covarianza predicha

        % --- Cálculo de innovación ---
        z_pred = H * x_pred;               % Medición predicha
        nu = z(k) - z_pred;                % Innovación

        % Almacenar innovación en buffer circular
        idx_buffer = mod(k-1, N_ventana) + 1;
        innov_buffer(idx_buffer) = nu;
        innov_hist(k) = nu;

        % --- Adaptación de R_k ---
        % Solo comenzar después de llenar la ventana
        if k >= N_ventana
            R = var(innov_buffer);
            % Protección contra valores extremos
            R = max(R, 1e-20);
            R = min(R, 1e-6);
        end

        % --- Fase de actualización ---
        S = H * P_pred * H' + R;           % Covarianza de la innovación
        K = P_pred * H' / S;               % Ganancia de Kalman

        x = x_pred + K * nu;               % Estado actualizado
        P = (I - K * H) * P_pred;          % Covarianza actualizada

        % --- Almacenar resultados ---
        x_est(:, k) = x;
        P_celda{k} = P;
    end

    P_est = P_celda;

end

% ===========================================================================
% Función auxiliar: inicialización de parámetros del AKF
% ===========================================================================

function [Q0, R0, P0, x0] = akf_init(theta0, tau)
    % Inicializa los parámetros del AKF con valores por defecto razonables.
    %
    % Entrada:
    %   theta0 - Primera estimación de offset [s] (de la etapa Exel)
    %   tau    - Intervalo entre mediciones [s]
    %
    % Salida:
    %   Q0, R0, P0, x0 - Parámetros iniciales del AKF

    % Estado inicial: offset conocido, skew y asimetría desconocidos
    x0 = [theta0; 0; 0];

    % Covarianza inicial del error: alta incertidumbre en skew y asimetría
    P0 = diag([1e-10, 1e-12, 1e-14]);  % [θ_var, s_var, Δ_var]

    % Covarianza del ruido de proceso
    % Q refleja cuánto esperamos que cambien los estados entre mediciones
    % El offset cambia con τ·skew, el skew hace random walk, Δ casi constante
    q_theta = 1e-14;    % Varianza de proceso del offset [(s)²]
    q_skew  = 1e-18;    % Varianza de proceso del skew [adimensional]
    q_delta = 1e-16;    % Varianza de proceso de la asimetría [(s)²]

    Q0 = diag([q_theta, q_skew, q_delta]);

    % Varianza inicial del ruido de medición
    R0 = 1e-12;         % [(s)²] — se adaptará automáticamente
end
