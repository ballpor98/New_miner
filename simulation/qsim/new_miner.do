onerror {exit -code 1}
vlib work
vlog -work work new_miner.vo
vlog -work work Waveform_block.vwf.vt
vsim -novopt -c -t 1ps -L fiftyfivenm_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.new_miner_vlg_vec_tst -voptargs="+acc"
vcd file -direction new_miner.msim.vcd
vcd add -internal new_miner_vlg_vec_tst/*
vcd add -internal new_miner_vlg_vec_tst/i1/*
run -all
quit -f
