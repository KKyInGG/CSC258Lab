# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns controller.v

# Load simulation using mux as the top level simulation module.
vsim controller

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets.

# reset
force {rset} 0
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns


# reset
force {rset} 1
force {go} 0
force {draw} 1
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns


# reset
force {rset} 1
force {go} 1
force {draw} 1
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns

# reset
force {rset} 1
force {go} 0
force {draw} 1
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns

# reset
force {rset} 1
force {go} 1
force {draw} 1
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns


# reset
force {rset} 1
force {draw} 0
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns

# reset
force {rset} 1
force {draw} 1
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns

# reset
force {rset} 1
force {go} 0
force {draw} 1
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns

# reset
force {rset} 1
force {go} 1
force {draw} 1
force {clk} 0 0, 1 10 -r 20
# Run simulation for a few ns.
run 40ns
