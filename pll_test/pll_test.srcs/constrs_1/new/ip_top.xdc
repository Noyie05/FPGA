set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk_o]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN N15 [get_ports rst_n]
set_property PACKAGE_PIN U18 [get_ports clk]
set_property PACKAGE_PIN F17 [get_ports clk_o]

create_clock -period 20 [get_ports clk]