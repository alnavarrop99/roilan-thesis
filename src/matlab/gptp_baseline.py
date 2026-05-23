#!/usr/bin/env python3
"""
gptp_baseline.py
Pure Python implementation of gPTP + Exel correction simulation.
Validates the reference baseline results using only Python stdlib.
No numpy/scipy/matplotlib required.

Reference results (Eupierre Oquendo, 2024):
  - Symmetric link:         83.82 µs mean precision
  - Asymmetric without corr: 152.2 µs mean precision
  - Asymmetric with Exel:   101.5 µs mean precision
  - Error reduction:         50.7 µs (33.31%)
"""

import random
import math
import statistics
import time
import sys

# ===========================================================================
# CONSTANTS
# ===========================================================================

C = 3e8                # Speed of light [m/s]
TIC_RES = 1e-3         # Clock tick resolution [s] = 1 ms

# ===========================================================================
# SIMULATION PARAMETERS
# ===========================================================================

DURATION = 60          # Simulation duration [s]
FREQ_OFFSET = 1        # Offset correction frequency [Hz]
FREQ_MSG = 1           # Message exchange frequency [Hz]
DISTANCE = 30          # Distance between devices [m]
N_SIM = 3000           # Monte Carlo simulations
SEED_BASE = 42         # Base random seed


def run_single_simulation(scenario, seed=None):
    """
    Run a single gPTP simulation.
    
    Args:
        scenario: 1=symmetric, 2=asymmetric uncorrected, 3=asymmetric with Exel
        seed: random seed for reproducibility
    
    Returns:
        (precision_mean, offset_stable_mean, offset_history, precision_history)
    """
    if seed is not None:
        random.seed(seed)
    
    # Propagation delay
    t_prop_base = DISTANCE / C
    
    # Clock parameters
    offset_initial = (random.random() - 0.5) * 2 * 1e-2   # ±10 ms
    skew_master = 1.0 + (random.random() - 0.5) * 2 * 30e-6  # ±30 ppm
    skew_slave  = 1.0 + (random.random() - 0.5) * 2 * 30e-6  # ±30 ppm
    rate_ratio = skew_slave / skew_master
    
    # Exel correction parameters — ASYMMETRIC between directions
    # These represent real-world processing delays in software timestamping:
    # p1: output delay on master (between app timestamp and PHY transmission)
    # p2: input delay on slave (between PHY reception and app timestamp)
    # p3: output delay on slave
    # p4: input delay on master
    p_base_ms = 80e-6  + random.random() * 40e-6    # 80-120 µs (master→slave side)
    p_base_sm = 120e-6 + random.random() * 40e-6    # 120-160 µs (slave→master side)
    
    p1 = p_base_ms + random.random() * 10e-6
    p2 = p_base_ms + random.random() * 10e-6
    p3 = p_base_sm + random.random() * 10e-6
    p4 = p_base_sm + random.random() * 10e-6
    
    # Unknown asymmetry
    asym_unknown = 0
    if scenario >= 2:
        asym_unknown = 120e-6 + random.random() * 20e-6  # 120-140 µs
    
    # State variables
    t_master = 0.0
    t_slave = offset_initial
    t_global = 0.0
    
    num_measurements = int(DURATION * FREQ_OFFSET)
    offset_history = []
    precision_history = []
    
    offset_accumulated = offset_initial
    
    # Event scheduling
    period_offset = 1.0 / FREQ_OFFSET
    period_msg = 1.0 / FREQ_MSG
    
    t_next_offset = period_offset
    t_next_msg = period_msg
    
    max_iter = int(DURATION * 1000)
    
    for _ in range(max_iter):
        if t_global >= DURATION:
            break
        
        # Advance clocks
        t_master += skew_master * TIC_RES
        t_slave += skew_slave * TIC_RES
        
        if t_next_offset <= t_next_msg:
            # OFFSET CORRECTION EVENT
            t_global = t_next_offset
            t_next_offset += period_offset
            
            offset_true = t_slave - t_master
            offset_history.append(offset_true)
            precision_history.append(abs(offset_true))
            
            # Apply correction
            t_slave -= offset_accumulated
            
        else:
            # MESSAGE EXCHANGE EVENT
            t_global = t_next_msg
            t_next_msg += period_msg
            
            # Pdelay_Req: master -> slave
            # IDEAL timestamps = what gPTP expects (at PHY layer)
            # RAW software timestamps:
            #   - Output (t1,t3): recorded BEFORE hitting PHY → EARLY by p1,p3
            #   - Input (t2,t4): recorded AFTER leaving PHY → LATE by p2,p4
            t1_ideal = t_master                          # PHY tx time
            t1_raw = t1_ideal - p1                       # Software: recorded p1 BEFORE tx
            
            t_ms = t_prop_base + asym_unknown / 2
            
            t2_ideal = t_slave + t_ms                 # PHY rx time (ideal)
            t2_raw = t2_ideal + p2                       # Software: recorded p2 AFTER rx
            
            # Pdelay_Resp: slave -> master
            think_time = random.random() * 200e-6
            t3_ideal = t2_ideal + think_time             # PHY tx time
            t3_raw = t3_ideal - p3                       # Software: recorded p3 BEFORE tx
            
            t_sm = t_prop_base - asym_unknown / 2
            
            t4_ideal = t_master + t_sm                 # PHY rx time (ideal)
            t4_raw = t4_ideal + p4                       # Software: recorded p4 AFTER rx
            
            # For scenario 3: Exel correction reconstructs ideal timestamps
            #   t1_ideal = t1_raw + p1,  t2_ideal = t2_raw - p2, etc.
            # For scenarios 1-2: use raw software timestamps (biased)
            if scenario == 3:
                T1 = t1_raw + p1    # = t1_ideal
                T2 = t2_raw - p2    # = t2_ideal
                T3 = t3_raw + p3    # = t3_ideal
                T4 = t4_raw - p4    # = t4_ideal
            else:
                T1, T2, T3, T4 = t1_raw, t2_raw, t3_raw, t4_raw
            
            # Calculate offset
            offset_calculated = ((T2 - T1) - (T4 - T3)) / 2.0
            offset_accumulated = offset_calculated
    
    # Calculate metrics (discard first 4s convergence period)
    idx_stable = max(0, int(4 * FREQ_OFFSET))
    if len(precision_history) > idx_stable + 1:
        precision_mean = statistics.mean(precision_history[idx_stable:])
        offset_stable = statistics.mean(offset_history[idx_stable:])
    else:
        precision_mean = statistics.mean(precision_history) if precision_history else 0
        offset_stable = statistics.mean(offset_history) if offset_history else 0
    
    return precision_mean, offset_stable, offset_history, precision_history


def run_monte_carlo():
    """Run full Monte Carlo simulation for all 3 scenarios."""
    
    scenario_names = [
        "Symmetric (gPTP standard)",
        "Asymmetric without correction",
        "Asymmetric with Exel correction"
    ]
    
    results = {sc: {"precision": [], "offset": []} for sc in range(1, 4)}
    
    print(f"{'='*60}")
    print(f"gPTP Monte Carlo Simulation — {N_SIM} runs per scenario")
    print(f"Duration: {DURATION}s, Distance: {DISTANCE}m")
    print(f"{'='*60}\n")
    
    t_start = time.time()
    
    for scenario in range(1, 4):
        print(f"Scenario {scenario}: {scenario_names[scenario-1]}")
        t_sc_start = time.time()
        
        for i in range(N_SIM):
            seed = SEED_BASE + i * 100 + scenario * 10000
            prec, offs, _, _ = run_single_simulation(scenario, seed)
            
            results[scenario]["precision"].append(prec)
            results[scenario]["offset"].append(offs)
            
            if (i + 1) % 500 == 0:
                elapsed = time.time() - t_sc_start
                eta = (elapsed / (i + 1)) * (N_SIM - i - 1)
                print(f"  {i+1}/{N_SIM} ({100*(i+1)/N_SIM:.1f}%) — "
                      f"elapsed: {elapsed:.1f}s, ETA: {eta:.1f}s")
        
        t_sc_elapsed = time.time() - t_sc_start
        print(f"  Completed in {t_sc_elapsed:.1f}s\n")
    
    t_total = time.time() - t_start
    print(f"{'='*60}")
    print(f"Total simulation time: {t_total:.1f}s ({t_total/60:.1f} min)")
    print(f"{'='*60}\n")
    
    # =========================================================================
    # STATISTICAL ANALYSIS
    # =========================================================================
    
    print("RESULTS\n" + "="*60)
    
    for scenario in range(1, 4):
        prec = results[scenario]["precision"]
        offs = results[scenario]["offset"]
        
        mean_prec = statistics.mean(prec) * 1e6   # Convert to µs
        std_prec  = statistics.stdev(prec) * 1e6
        mean_offs = statistics.mean(offs) * 1e6
        std_offs  = statistics.stdev(offs) * 1e6
        
        # 95% confidence interval
        z95 = 1.96
        ci95 = z95 * std_prec / math.sqrt(N_SIM)
        error_est = (ci95 / mean_prec) * 100 if mean_prec > 0 else 0
        
        print(f"\nScenario {scenario}: {scenario_names[scenario-1]}")
        print(f"  Mean precision:           {mean_prec:.2f} µs")
        print(f"  Std deviation:            {std_prec:.2f} µs")
        print(f"  Mean offset (stable):     {mean_offs:.3f} µs")
        print(f"  Offset std:               {std_offs:.3f} µs")
        print(f"  95% CI:                   ±{ci95:.2f} µs")
        print(f"  Estimated error:          {error_est:.2f}%")
        print(f"  Precision range:          [{min(prec)*1e6:.1f}, {max(prec)*1e6:.1f}] µs")
        print(f"  Offset range:             [{min(offs)*1e6:.3f}, {max(offs)*1e6:.3f}] µs")
    
    # Improvement calculations
    if len(results[2]["precision"]) > 0 and len(results[3]["precision"]) > 0:
        mean_asym = statistics.mean(results[2]["precision"])
        mean_exel = statistics.mean(results[3]["precision"])
        improvement_abs = mean_asym - mean_exel
        improvement_pct = (improvement_abs / mean_asym) * 100
        
        print(f"\n{'='*60}")
        print(f"EXEL CORRECTION IMPROVEMENT:")
        print(f"  Absolute reduction:  {improvement_abs*1e6:.2f} µs")
        print(f"  Percentage:          {improvement_pct:.2f}%")
        print(f"{'='*60}")
        
        # Validate against reference
        ref_abs = 50.7   # µs
        ref_pct = 33.31  # %
        print(f"\nVALIDATION (reference: {ref_abs} µs / {ref_pct}%):")
        print(f"  Absolute match: {'✓' if abs(improvement_abs*1e6 - ref_abs) < 10 else '✗'}")
        print(f"  Percentage match: {'✓' if abs(improvement_pct - ref_pct) < 5 else '✗'}")
    
    return results


if __name__ == "__main__":
    # Quick validation with fewer runs if requested
    if "--quick" in sys.argv:
        N_SIM = 100
        print(f"QUICK MODE: {N_SIM} simulations (use without --quick for full 3000)\n")
    
    results = run_monte_carlo()
