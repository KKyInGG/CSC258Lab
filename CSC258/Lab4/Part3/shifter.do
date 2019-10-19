# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns shifter.v

# Load simulation using mux as the top level simulation module.
vsim shifter

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets


# normal loading
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 0
# reset_n
force {SW[9]} 0
# clk
force {KEY[0]} 0 0, 1 10 -r 20
# Load_n
force {KEY[1]} 0
# ShiftRight
force {KEY[2]} 0
# ASR
force {KEY[3]} 0
run 40ns


# normal right shift
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 0
# reset_n
force {SW[9]} 0
# clk
force {KEY[0]} 0 0, 1 10 -r 20
# Load_n
force {KEY[1]} 1
# ShiftRight
force {KEY[2]} 1
# ASR
force {KEY[3]} 0
run 40ns

# normal loading
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1
# reset_n
force {SW[9]} 0
# clk
force {KEY[0]} 0 0, 1 10 -r 20
# Load_n
force {KEY[1]} 0
# ShiftRight
force {KEY[2]} 0
# ASR
force {KEY[3]} 0
run 40ns

# normal right shift case 2
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1
# reset_n
force {SW[9]} 0
# clk
force {KEY[0]} 0 0, 1 10 -r 20
# Load_n
force {KEY[1]} 1
# ShiftRight
force {KEY[2]} 1
# ASR
force {KEY[3]} 0
run 40ns

# normal loading
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 0
# reset_n
force {SW[9]} 0
# clk
force {KEY[0]} 0 0, 1 10 -r 20
# Load_n
force {KEY[1]} 0
# ShiftRight
force {KEY[2]} 0
# ASR
force {KEY[3]} 0
run 40ns

# ASR right shift case 1
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 0
# reset_n
force {SW[9]} 0
# clk
force {KEY[0]} 0 0, 1 10 -r 20
# Load_n
force {KEY[1]} 1
# ShiftRight
force {KEY[2]} 1
# ASR
force {KEY[3]} 1
run 40ns

# normal loading
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1
# reset_n
force {SW[9]} 0
# clk
force {KEY[0]} 0 0, 1 10 -r 20
# Load_n
force {KEY[1]} 0
# ShiftRight
force {KEY[2]} 0
# ASR
force {KEY[3]} 0
run 40ns

# ASR right shift case 2
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1
# reset_n
force {SW[9]} 0
# clk
force {KEY[0]} 0 0, 1 10 -r 20
# Load_n
force {KEY[1]} 1
# ShiftRight
force {KEY[2]} 1
# ASR
force {KEY[3]} 1
run 40ns

# normal loading
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
# reset_n
force {SW[9]} 0
# clk
force {KEY[0]} 0 0, 1 10 -r 20
# Load_n
force {KEY[1]} 0
# ShiftRight
force {KEY[2]} 0
# ASR
force {KEY[3]} 0
run 40ns

# no shift
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
# reset_n
force {SW[9]} 0
# clk
force {KEY[0]} 0 0, 1 10 -r 20
# Load_n
force {KEY[1]} 1
# ShiftRight
force {KEY[2]} 0
# ASR
force {KEY[3]} 0
run 40ns



