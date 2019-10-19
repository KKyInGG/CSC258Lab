# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns Part2.v

# Load simulation using adder as the top level simulation module.
vsim Part2

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}
# force <signal_name> <initial_value> <initial_time>, <new_value> <new time> -repeat <repeat_time> cancel <cancel_time>
# Clear first
force {SW[9]} 0
run 5 ns

force {SW[9]} 1
# disable clear
force {SW[0]} 1
#enable toggling of values
force {SW[1]} 1
run 5 ns
# alternates clock every 10 seconds
force {CLOCK_50} 0 0, 1 5 -repeat 10
run 1300 ns
