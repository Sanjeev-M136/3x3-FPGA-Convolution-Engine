# 100 MHz target clock (10.000 ns period)
create_clock -name clk -period 10.000 [get_ports clk]

# Derive clock uncertainty
derive_clock_uncertainty
