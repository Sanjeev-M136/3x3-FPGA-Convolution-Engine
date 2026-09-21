project_open conv
create_timing_netlist
read_sdc
update_timing_netlist
report_timing -setup -npaths 3 -detail full_path -file output_files/setup_paths.txt
project_close
