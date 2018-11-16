# Use 'work' as current library name
vlib work

# Exit current instance of simulator
quit -sim

# Add source code to library compilation sequence
vlog -sv -incr ../rtl/sn74xxxx.sv
vlog -sv -incr ../tb/sn74xxxx_tb.sv

# Recompile library
vlog -work work -refresh

# Set 'selector_4_to_1_tb' as top module
vsim selector_4_to_1_tb -novopt

# Add waves to visualize
add wave -noupdate -radix unsigned /selector_4_to_1_tb/*
add wave -noupdate -divider {DUT}
add wave -noupdate -radix unsigned /selector_4_to_1_tb/DUT/*

# Start simulation
run -all
