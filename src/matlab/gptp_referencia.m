% ===========================================================================
% gptp_referencia.m — v3 (fixed t4_raw timing)
% ===========================================================================

function [offset_final, precision, offset_hist] = gptp_referencia(...
    duracion, freq_offset, freq_msg, distancia, escenario)

    c = 3e8;  tic_res = 1e-3;
    t_prop_base = distancia / c;

    offset_inicial = (rand() - 0.5) * 2 * 1e-2;
    skew_maestro = 1.0 + (rand() - 0.5) * 2 * 30e-6;
    skew_esclavo = 1.0 + (rand() - 0.5) * 2 * 30e-6;
    rate_ratio = skew_esclavo / skew_maestro;

    % Retardos p1-p4 (maestro chip antiguo, esclavo chip moderno)
    p1 = 120e-6 + (rand() - 0.5) * 2 * 30e-6;
    p2 = 30e-6  + (rand() - 0.5) * 2 * 10e-6;
    p3 = 40e-6  + (rand() - 0.5) * 2 * 15e-6;
    p4 = 10e-6  + (rand() - 0.5) * 2 * 5e-6;

    % Asimetría desconocida (solo en camino de ida)
    asim_desconocida = 0;
    if escenario == 2 || escenario == 3
        asim_desconocida = 200e-6 + (rand() - 0.5) * 2 * 20e-6;
    end

    t_maestro = 0;  t_esclavo = offset_inicial;  t_global = 0;
    num_mediciones = floor(duracion * freq_offset);
    offset_hist = zeros(1, num_mediciones);
    precision_hist = zeros(1, num_mediciones);
    idx_hist = 0;
    offset_acumulado = offset_inicial;

    periodo_offset = 1 / freq_offset;
    periodo_msg   = 1 / freq_msg;
    t_next_offset = periodo_offset;
    t_next_msg    = periodo_msg;
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
            end
            t_esclavo = t_esclavo - offset_acumulado;

        else
            t_global = t_next_msg;
            t_next_msg = t_next_msg + periodo_msg;

            % --- Camino de ida: maestro → esclavo ---
            t1_raw = t_maestro;
            d_ms = p1 + t_prop_base + asim_desconocida + p2;
            % t2_raw: slave clock at arrival time
            % Arrival = now + d_ms (in physical time)
            % Slave clock at arrival = slave_clock_now + skew_s * d_ms ≈ slave_clock_now + d_ms
            t2_raw = t_esclavo + d_ms;

            t1_corr = t1_raw + p1;
            t2_corr = t2_raw - p2;

            % --- Respuesta del esclavo ---
            t_resp = rand() * 200e-6;  % processing time at slave
            % t3_raw: slave clock at response send time
            % Response time = arrival + t_resp (physical)
            % Slave clock at response = slave_clock_at_arrival + skew_s * t_resp 
            %                        ≈ t2_raw + t_resp
            t3_raw = t2_raw + t_resp;
            t3_corr = t3_raw + p3;

            % --- Camino de vuelta: esclavo → maestro ---
            d_sm = p3 + t_prop_base + p4;
            % t4_raw: master clock at arrival
            % Total physical time from event start to master arrival:
            %   d_ms (forward) + t_resp (slave processing) + d_sm (return)
            % Master clock advance during this time: skew_m * (d_ms + t_resp + d_sm)
            % t4_raw = master_clock_now + master_advance
            total_physical = d_ms + t_resp + d_sm;
            t4_raw = t_maestro + total_physical;  % ≈ skew_m * total_physical
            t4_corr = t4_raw - p4;

            if escenario == 3
                T1 = t1_corr; T2 = t2_corr; T3 = t3_corr; T4 = t4_corr;
            else
                T1 = t1_raw; T2 = t2_raw; T3 = t3_raw; T4 = t4_raw;
            end

            offset_calculado = ((T2 - T1) - (T4 - T3)) / 2;
            offset_acumulado = offset_calculado;
        end
    end

    idx_estable = max(1, floor(4 * freq_offset)) : idx_hist;
    if length(idx_estable) > 1
        precision = mean(precision_hist(idx_estable));
        offset_final = mean(offset_hist(idx_estable));
    else
        precision = mean(precision_hist(1:idx_hist));
        offset_final = mean(offset_hist(1:idx_hist));
    end
end
