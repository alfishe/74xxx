# Use 'work' as current library name
vlib work

# Exit current instance of simulator
quit -sim

# Add source code to library compilation sequence
vlog -sv -incr ../rtl/sn74xxxx.sv
vlog -sv -incr ../tb/sn74xxxx_tb.sv

# Recompile library
vlog -work work -refresh

# Set 'dff_7474_tb' as top module
vsim dff_7474_tb -novopt

# Add waves to visualize
add wave -noupdate -radix unsigned /dff_7474_tb/*
add wave -noupdate -divider {DUT}
add wave -noupdate -radix unsigned /dff_7474_tb/DUT/*

# Configure wave widget display params
configure wave -gridperiod {1 ns} -timelineunits ns -namecolwidth 200

# Start simulation
run -all

# Set wave display zoom level (whole test timeline fits Wave widget)
wave zoom range {0ns} {26ns}