% ===========================================================================
% gptp_asimetrico_mejorado.m — v3 (fixed t4_raw timing + online AKF)
% ===========================================================================

function [offset_final, precision, offset_hist, diag] = ...
    gptp_asimetrico_mejorado(duracion, freq_offset, freq_msg, distancia)

    c = 3e8;  tic_res = 1e-3;
    t_prop_base = distancia / c;

    offset_inicial = (rand() - 0.5) * 2 * 1e-2;
    skew_maestro = 1.0 + (rand() - 0.5) * 2 * 30e-6;
    skew_esclavo = 1.0 + (rand() - 0.5) * 2 * 30e-6;
    rate_ratio = skew_esclavo / skew_maestro;

    p1 = 120e-6 + (rand() - 0.5) * 2 * 30e-6;
    p2 = 30e-6  + (rand() - 0.5) * 2 * 10e-6;
    p3 = 40e-6  + (rand() - 0.5) * 2 * 15e-6;
    p4 = 10e-6  + (rand() - 0.5) * 2 * 5e-6;
    asim_desconocida = 200e-6 + (rand() - 0.5) * 2 * 20e-6;

    % AKF initialization
    tau = 1 / freq_msg;  N_ventana = 15;
    F = [1, tau, 0; 0, 1, 0; 0, 0, 1];
    H = [1, 0, 0.5];  I = eye(3);
    x_akf = [offset_inicial; 0; 0];
    P_akf = diag([1e-10, 1e-12, 1e-14]);
    Q = diag([1e-14, 1e-18, 1e-16]);  R = 1e-12;
    innov_buffer = zeros(N_ventana, 1);  n_innov = 0;

    t_maestro = 0;  t_esclavo = offset_inicial;  t_global = 0;
    num_mediciones = floor(duracion * freq_offset);
    offset_hist = zeros(1, num_mediciones);
    precision_hist = zeros(1, num_mediciones);
    akf_corr_hist = zeros(1, num_mediciones);
    idx_hist = 0;
    offset_acumulado = offset_inicial;
    akf_ready = false;

    periodo_offset = 1 / freq_offset;  periodo_msg = 1 / freq_msg;
    t_next_offset = periodo_offset;  t_next_msg = periodo_msg;
    iter = 0;  max_iter = duracion * 1000;

    while t_global < duracion && iter < max_iter
        iter = iter + 1;
        t_maestro = t_maestro + skew_maestro * tic_res;
        t_esclavo = t_esclavo + skew_esclavo * tic_res;

        if t_next_offset <= t_next_msg
            t_global = t_next_offset;
            t_next_offset = t_next_offset + periodo_offset;

            offset_verdadero = t_esclavo - t_maestro;
            idx_hist = idx_hist + 1;
            if idx_hist <= num_mediciones
                offset_hist(idx_hist) = offset_verdadero;
                precision_hist(idx_hist) = abs(offset_verdadero);

                if akf_ready
                    offset_correction = x_akf(1);
                else
                    offset_correction = offset_acumulado;
                end
                akf_corr_hist(idx_hist) = offset_correction;
                t_esclavo = t_esclavo - offset_correction;
                if akf_ready
                    x_akf(1) = x_akf(1) - offset_correction;
                end
            end
        else
            t_global = t_next_msg;
            t_next_msg = t_next_msg + periodo_msg;

            % Forward path
            t1_raw = t_maestro;
            d_ms = p1 + t_prop_base + asim_desconocida + p2;
            t2_raw = t_esclavo + d_ms;
            t1_corr = t1_raw + p1;  t2_corr = t2_raw - p2;

            % Slave response
            t_resp = rand() * 200e-6;
            t3_raw = t2_raw + t_resp;
            t3_corr = t3_raw + p3;

            % Return path
            d_sm = p3 + t_prop_base + p4;
            total_physical = d_ms + t_resp + d_sm;
            t4_raw = t_maestro + total_physical;
            t4_corr = t4_raw - p4;

            % Exel-corrected offset
            z_k = ((t2_corr - t1_corr) - (t4_corr - t3_corr)) / 2;
            offset_acumulado = z_k;

            % Online AKF update
            x_pred = F * x_akf;
            P_pred = F * P_akf * F' + Q;
            nu = z_k - H * x_pred;
            n_innov = n_innov + 1;
            idx_buf = mod(n_innov - 1, N_ventana) + 1;
            innov_buffer(idx_buf) = nu;

            if n_innov >= N_ventana
                R = var(innov_buffer);
                R = max(R, 1e-20);  R = min(R, 1e-6);
                akf_ready = true;
            end

            S = H * P_pred * H' + R;
            K = P_pred * H' / S;
            x_akf = x_pred + K * nu;
            P_akf = (I - K * H) * P_pred;
        end
    end

    idx_start = max(1, floor((4 + N_ventana) * freq_offset));
    idx_estable = idx_start : idx_hist;
    if length(idx_estable) > 1
        precision = mean(precision_hist(idx_estable));
        offset_final = mean(offset_hist(idx_estable));
    else
        precision = mean(precision_hist(1:idx_hist));
        offset_final = mean(offset_hist(1:idx_hist));
    end

    diag.offset_raw = offset_hist;
    diag.precision_hist = precision_hist;
    diag.akf_corrections = akf_corr_hist;
    diag.akf_final_state = x_akf;
    diag.akf_ready = akf_ready;
    diag.params = struct('N_ventana', N_ventana, 'Q', Q, 'R', R);
end
