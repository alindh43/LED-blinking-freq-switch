set_property IOSTANDARD LVCMOS33 [get_ports {switches[0]}] 
set_property PACKAGE_PIN G15 [get_ports {switches[0]}] 

set_property IOSTANDARD LVCMOS33 [get_ports {switches[1]}] 
set_property PACKAGE_PIN P15 [get_ports {switches[1]}] 

set_property IOSTANDARD LVCMOS33 [get_ports {switches[2]}]
set_property PACKAGE_PIN W13 [get_ports {switches[2]}]
 
set_property IOSTANDARD LVCMOS33 [get_ports {switches[3]}] 
set_property PACKAGE_PIN T16 [get_ports {switches[3]}] 

set_property IOSTANDARD LVCMOS33 [get_ports rst_n] 
set_property PACKAGE_PIN R18 [get_ports rst_n] 

set_property IOSTANDARD LVCMOS33 [get_ports led0] 
set_property PACKAGE_PIN M14 [get_ports led0] 

set_property IOSTANDARD LVCMOS33 [get_ports clock]
set_property PACKAGE_PIN L16 [get_ports clock] 

## 125 MHz system clock
create_clock -name sys_clk -period 8.000 [get_ports clock]

# Asynchronous inputs (switches and reset)
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports switches[*]]

# Asynchronous output (LED)
set_false_path -to [get_ports led0]


