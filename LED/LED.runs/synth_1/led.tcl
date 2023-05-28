# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param synth.incrementalSynthesisCache C:/Users/Noyie05/AppData/Roaming/Xilinx/Vivado/.Xil/Vivado-14676-404NOTFOUND/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xa7z020clg400-1Q

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir F:/FPGA/FPGA/LED/LED.cache/wt [current_project]
set_property parent.project_path F:/FPGA/FPGA/LED/LED.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo f:/FPGA/FPGA/LED/LED.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib F:/FPGA/FPGA/LED/LED.srcs/sources_1/new/led.v
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc F:/FPGA/FPGA/LED/LED.srcs/constrs_1/new/led.xdc
set_property used_in_implementation false [get_files F:/FPGA/FPGA/LED/LED.srcs/constrs_1/new/led.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top led -part xa7z020clg400-1Q


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef led.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file led_utilization_synth.rpt -pb led_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
