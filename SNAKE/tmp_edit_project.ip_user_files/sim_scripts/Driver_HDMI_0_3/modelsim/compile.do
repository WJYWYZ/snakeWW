vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../tmp_edit_project.srcs/sources_1/ip/Driver_HDMI_0_3/sim/Driver_HDMI.v" \
"../../../../tmp_edit_project.srcs/sources_1/ip/Driver_HDMI_0_3/sim/Driver_HDMI_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

