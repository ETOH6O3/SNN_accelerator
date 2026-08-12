create_clock -period 3.000 -name clk1 -waveform {0.000 2.500} -add [get_ports clk1]
create_clock -period 3.000 -name clk2 -waveform {0.000 2.500} -add [get_ports clk2]

# set_false_path -from [get_clocks clk1] -to [get_clocks clk2]
# set_false_path -from [get_clocks clk2] -to [get_clocks clk1]

set_property ASYNC_REG TRUE [get_cells {aer_rx_inst/cdc_sync_inst/gen_cdc_sync.sync_chain_reg[0][0]}]
set_property ASYNC_REG TRUE [get_cells {aer_tx_inst/cdc_sync_inst/gen_cdc_sync.sync_chain_reg[0][0]}]