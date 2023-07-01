onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ram_ip_opt

do {wave.do}

view wave
view structure
view signals

do {ram_ip.udo}

run -all

quit -force
