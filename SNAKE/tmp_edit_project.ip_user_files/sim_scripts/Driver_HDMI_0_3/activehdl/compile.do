vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../../tmp_edit_project.srcs/sources_1/ip/Driver_HDMI_0_3/sim/Driver_HDMI.v" \
"../../../../tmp_edit_project.srcs/sources_1/ip/Driver_HDMI_0_3/sim/Driver_HDMI_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

