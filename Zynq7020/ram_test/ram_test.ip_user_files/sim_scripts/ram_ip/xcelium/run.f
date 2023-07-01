-makelib xcelium_lib/xpm -sv \
  "D:/Software/Vivado/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/Software/Vivado/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_4 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../ram_test.srcs/sources_1/ip/ram_ip/sim/ram_ip.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

