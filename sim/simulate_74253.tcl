# Use 'work' as current library name
vlib work

# Exit current instance of simulator
quit -sim

# Add source code to library compilation sequence
vlog -sv -incr ../rtl/sn74xxxx.sv
vlog -sv -incr ../tb/sn74xxxx_tb.sv

# Recompile library
vlog -work work -refresh

# Set 'selector_74254_tb' as top module
vsim selector_74253_tb -novopt

# Add waves to visualize
add wave -noupdate -radix unsigned /selector_74253_tb/*
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix unsigned /selector_74253_tb/DUT/*

# Start simulation
run -all
