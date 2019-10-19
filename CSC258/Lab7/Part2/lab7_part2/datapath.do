# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns datapath.v

# Load simulation using mux as the top level simulation module.
vsim datapath

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets.

# reset
force {r_set} 0
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns


# reset
force {r_set} 1
force {en_x} 1
force {loc_in} 0000000
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns


# reset
force {r_set} 1
force {en_y} 1
force {loc_in} 0000000
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns

# reset
force {r_set} 1
force {en_c} 1
force {colour} 111
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns

# reset
force {r_set} 1
force {en_ix} 1
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 360ns


