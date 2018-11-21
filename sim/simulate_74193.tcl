# Use 'work' as current library name
vlib work

# Exit current instance of simulator
quit -sim

# Add source code to library compilation sequence
vlog -sv -incr ../rtl/sn74xxxx.sv
vlog -sv -incr ../tb/sn74xxxx_tb.sv

# Recompile library
vlog -work work -refresh

# Set 'counter_74193_tb' as top module
vsim counter_74193_tb -novopt

# Add waves to visualize
add wave -noupdate -radix unsigned /counter_74193_tb/*
add wave -noupdate -divider {DUT}
add wave -noupdate -radix unsigned /counter_74193_tb/DUT/*

# Configure wave widget display params
configure wave -gridperiod {1 ns} -timelineunits ns -namecolwidth 200

# Start simulation
run -all

# Set wave display zoom level
wave zoom range {0ns} {50ns}