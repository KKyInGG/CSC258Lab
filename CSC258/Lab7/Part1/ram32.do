# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns ram32x4.v

# Load simulation using mux as the top level simulation module.
vsim -L altera_mf_ver ram32x4



# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets.
force {address} 0011
force {data} 0111
force {wren} 0
force {clock} 0 0, 1 20 -r 40
# Run simulation for a few ns.
run 160ns

force {address} 0011
force {data} 0111
force {wren} 1
force {clock} 0 0, 1 20 -r 40
# Run simulation for a few ns.
run 160ns

