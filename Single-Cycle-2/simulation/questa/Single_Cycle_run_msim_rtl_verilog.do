transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2 {C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2/main.v}
vlog -vlog01compat -work work +incdir+C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2 {C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2 {C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2/alu_decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2 {C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2/control_unit.v}
vlog -vlog01compat -work work +incdir+C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2 {C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2/data_memory.v}
vlog -vlog01compat -work work +incdir+C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2 {C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2/extend.v}
vlog -vlog01compat -work work +incdir+C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2 {C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2/main_decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2 {C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2/register_file.v}
vlog -vlog01compat -work work +incdir+C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2 {C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2/instruction_memory.v}

vlog -vlog01compat -work work +incdir+C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2 {C:/Users/eliza/TE2003B.501-_A01253381/Single-Cycle-2/main_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  main_tb

add wave *
view structure
view signals
run -all
