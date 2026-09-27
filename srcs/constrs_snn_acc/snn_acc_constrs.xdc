# =========================================================
# System clock
# =========================================================
create_clock -period 10.000 -name clk -waveform {0.000 5.000} -add [get_ports clk]

# =========================================================
# FPGA pin mapping
# =========================================================
set_property PACKAGE_PIN P16 [get_ports {aer_r\.ack}]
set_property PACKAGE_PIN R22 [get_ports {aer_r\.req}]
set_property PACKAGE_PIN T19 [get_ports {aer_t\.req}]
set_property PACKAGE_PIN N21 [get_ports rst_n]
set_property PACKAGE_PIN R21 [get_ports enable_learn]
set_property PACKAGE_PIN P21 [get_ports {aer_t\.ack}]
set_property PACKAGE_PIN P23 [get_ports clk]
set_property PACKAGE_PIN N22 [get_ports learn_mode]
set_property PACKAGE_PIN T24 [get_ports {aer_r\.addr[8]}]
set_property PACKAGE_PIN R23 [get_ports {aer_r\.addr[9]}]
set_property PACKAGE_PIN T25 [get_ports {aer_r\.addr[7]}]
set_property PACKAGE_PIN T20 [get_ports {aer_r\.addr[6]}]
set_property PACKAGE_PIN M19 [get_ports {aer_t\.addr[5]}]
set_property PACKAGE_PIN R20 [get_ports {aer_r\.addr[5]}]
set_property PACKAGE_PIN T22 [get_ports {aer_r\.addr[4]}]
set_property PACKAGE_PIN T17 [get_ports {aer_t\.addr[3]}]
set_property PACKAGE_PIN R16 [get_ports {aer_t\.addr[8]}]
set_property PACKAGE_PIN T23 [get_ports {aer_r\.addr[3]}]
set_property PACKAGE_PIN P18 [get_ports {aer_t\.addr[1]}]
set_property PACKAGE_PIN R17 [get_ports {aer_t\.addr[7]}]
set_property PACKAGE_PIN R18 [get_ports {aer_t\.addr[2]}]
set_property PACKAGE_PIN U16 [get_ports {aer_t\.addr[0]}]
set_property PACKAGE_PIN U19 [get_ports {aer_r\.addr[2]}]
set_property PACKAGE_PIN U17 [get_ports {aer_t\.addr[4]}]
set_property PACKAGE_PIN N17 [get_ports {aer_t\.addr[9]}]
set_property PACKAGE_PIN N18 [get_ports {aer_t\.addr[6]}]
set_property PACKAGE_PIN U20 [get_ports {aer_r\.addr[1]}]
set_property PACKAGE_PIN T18 [get_ports {aer_r\.addr[0]}]

# =========================================================
# AER TX: external output interface
# =========================================================
create_clock -period 10.000 -name vclk_aer_tx -waveform {0.000 5.000}

set_output_delay -clock [get_clocks vclk_aer_tx] -min 0.500 -add_delay [get_ports {aer_t\.addr[*]}]
set_output_delay -clock [get_clocks vclk_aer_tx] -max 1.000 -add_delay [get_ports {aer_t\.addr[*]}]
set_output_delay -clock [get_clocks vclk_aer_tx] -min 0.500 -add_delay [get_ports {aer_t\.req}]
set_output_delay -clock [get_clocks vclk_aer_tx] -max 1.000 -add_delay [get_ports {aer_t\.req}]

set_input_delay -clock [get_clocks vclk_aer_tx] -min 1.200 -add_delay [get_ports {aer_t\.ack}]
set_input_delay -clock [get_clocks vclk_aer_tx] -max 1.500 -add_delay [get_ports {aer_t\.ack}]

# =========================================================
# AER RX: external input interface
# =========================================================
create_clock -period 10.000 -name vclk_aer_rx -waveform {0.000 5.000}

set_input_delay -clock [get_clocks vclk_aer_rx] -min 1.200 -add_delay [get_ports {aer_r\.addr[*]}]
set_input_delay -clock [get_clocks vclk_aer_rx] -max 1.500 -add_delay [get_ports {aer_r\.addr[*]}]
set_input_delay -clock [get_clocks vclk_aer_rx] -min 1.200 -add_delay [get_ports {aer_r\.req}]
set_input_delay -clock [get_clocks vclk_aer_rx] -max 1.500 -add_delay [get_ports {aer_r\.req}]

set_output_delay -clock [get_clocks vclk_aer_rx] -min 0.500 -add_delay [get_ports {aer_r\.ack}]
set_output_delay -clock [get_clocks vclk_aer_rx] -max 1.200 -add_delay [get_ports {aer_r\.ack}]

# =========================================================
# Control inputs sampled by internal system clock
# =========================================================
set_input_delay -clock [get_clocks clk] -min 1.200 -add_delay [get_ports rst_n]
set_input_delay -clock [get_clocks clk] -max 1.500 -add_delay [get_ports rst_n]
set_input_delay -clock [get_clocks clk] -min 1.200 -add_delay [get_ports enable_learn]
set_input_delay -clock [get_clocks clk] -max 1.500 -add_delay [get_ports enable_learn]
set_input_delay -clock [get_clocks clk] -min 1.200 -add_delay [get_ports learn_mode]
set_input_delay -clock [get_clocks clk] -max 1.500 -add_delay [get_ports learn_mode]

# AER I/O is intentionally treated as an independent external interface domain.
set_clock_groups -asynchronous -group [get_clocks clk] -group [get_clocks vclk_aer_tx]
set_clock_groups -asynchronous -group [get_clocks clk] -group [get_clocks vclk_aer_rx]

# =========================================================
# I/O standards
# =========================================================
set_property IOSTANDARD LVCMOS18 [get_ports rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.addr[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.addr[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.addr[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.addr[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.addr[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.addr[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.addr[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.addr[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.addr[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.addr[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.addr[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.addr[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.addr[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.addr[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.addr[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.addr[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.addr[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.addr[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.addr[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.addr[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.ack}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_r\.req}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.ack}]
set_property IOSTANDARD LVCMOS18 [get_ports {aer_t\.req}]
set_property IOSTANDARD LVCMOS18 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports enable_learn]
set_property IOSTANDARD LVCMOS18 [get_ports learn_mode]
