# RTL-to-GDSII Design of a Programmable PWM Generator

An 8-bit programmable PWM generator written in Verilog and taken through the
RTL-to-GDSII flow on Compcarta EDAcloud with the Nangate45 library.
Authors: Sahana Mitra, Liya Gautam (MIT World Peace University)

## What it does
An 8-bit counter free-runs (period = 256 clocks). The output is high while
counter < duty, so the duty cycle is programmable in 256 steps.
duty = 64 / 128 / 192 gives 25% / 50% / 75%.

## Ports
clk, rst (sync, active high), en, duty[7:0] -> pwm_out

## Simulate (Icarus Verilog + GTKWave)
    iverilog -o sim rtl/pwm_gen.v tb/tb_pwm_gen.v
    vvp sim
    gtkwave pwm_gen.vcd

The self-checking testbench prints PASS for duty 0, 64, 128, 192, 255 and
for the en = 0 check, then ALL TESTS PASSED.

## Flow results (10 ns clock, Nangate45)
| Stage | Result |
|---|---|
| Lint | 0 errors, 1 warning (naming and style) |
| CDC | 0 violations, 1 clock domain, 9 flip-flops |
| Synthesis | 60 cells, 90 um^2 (41 um^2 sequential) |
| Timing | setup slack 9.61 ns, hold slack 0.1 ns, no negative slack |
| Floorplan to routing | completed |
| GDS | pwm_gen.gds generated |

## Limitations
Learning project, not fabricated. No gate-level simulation, post-layout
parasitic timing, power analysis or physical signoff was done. Changing duty
in the middle of a period can change that period's pulse width.

## Future work
Double-buffered duty register, programmable prescaler, dead-time insertion,
gate-level simulation, post-layout STA and signoff checks.
