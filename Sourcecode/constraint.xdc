## Clock signal 100 MHz
set_property -dict { PACKAGE_PIN H4 IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];
#HDMI clk_25MHz
#set_property -dict {PACKAGE_PIN F4 IOSTANDARD TMDS_33} [get_ports { clk_25M }];
#set_property -dict {PACKAGE_PIN G4 IOSTANDARD TMDS33} [get_ports { clk }];
#rst_n
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports { rst_n }];
#button
set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS33} [get_ports { k_up }];
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS33} [get_ports { k_down }];
set_property -dict {PACKAGE_PIN K3 IOSTANDARD LVCMOS33} [get_ports { k_right }];
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports { k_left }];
#led
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports { led }];
#VGA DATA
set_property -dict { PACKAGE_PIN F4   IOSTANDARD TMDS_33  } [get_ports { TMDS_Tx_Clk_N }]; #IO_L11N_T1_SRCC_35 Sch=hdmi_tx_clk_n
set_property -dict { PACKAGE_PIN G4   IOSTANDARD TMDS_33  } [get_ports { TMDS_Tx_Clk_P }]; #IO_L11P_T1_SRCC_35 Sch=hdmi_tx_clk_p
set_property -dict { PACKAGE_PIN F1   IOSTANDARD TMDS_33  } [get_ports { TMDS_Tx_Data_N[0] }]; #IO_L12N_T1_MRCC_35 Sch=hdmi_tx_d_n[0]
set_property -dict { PACKAGE_PIN G1   IOSTANDARD TMDS_33  } [get_ports { TMDS_Tx_Data_P[0] }]; #IO_L12P_T1_MRCC_35 Sch=hdmi_tx_d_p[0]
set_property -dict { PACKAGE_PIN D2   IOSTANDARD TMDS_33  } [get_ports { TMDS_Tx_Data_N[1] }]; #IO_L10N_T1_AD11N_35 Sch=hdmi_tx_d_n[1]
set_property -dict { PACKAGE_PIN E2   IOSTANDARD TMDS_33  } [get_ports { TMDS_Tx_Data_P[1] }]; #IO_L10P_T1_AD11P_35 Sch=hdmi_tx_d_p[1]
set_property -dict { PACKAGE_PIN C1   IOSTANDARD TMDS_33  } [get_ports { TMDS_Tx_Data_N[2] }]; #IO_L14N_T2_AD4N_SRCC_35 Sch=hdmi_tx_d_n[2]
set_property -dict { PACKAGE_PIN D1   IOSTANDARD TMDS_33  } [get_ports { TMDS_Tx_Data_P[2] }]; #IO_L14P_T2_AD4P_SRCC_35 Sch=hdmi_tx_d_p[2]


#set_property CONFIG_VOLTAGE 3.3 [current_design];
#set_property CFGBVS VCCO [current_design];
#set_property BITSTREAM CONFIG CONFIGRATE [current_design];