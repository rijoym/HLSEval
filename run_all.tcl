####################################################################
# TCL script to automate Vitis HLS from .cpp files
# See: https://docs.amd.com/r/2021.2-English/ug1399-vitis-hls/Running-Vitis-HLS-from-the-Command-Line
# Author: Rajat Subhra Chakraborty
#          Dept. of CSE, IIT Kharagpur
#          Kharagpur, West Bengal, India 721302
#          Email: rschakraborty@cse.iitkgp.ac.in
#          Last modified: 30th April 2024  
####################################################################

# There are two ways to run this script:
####################################################################
# Option-1: from inside Vitis
# To bring up Vitis in non-interactive (non-GUI) mode,
# at Linux/MS-DOS/Powershell command-prompt, type:
# vitis_hls -i
# Then, to run this script, from Vitis TCL prompt, type:
# source run_all.tcl
####################################################################
####################################################################
# Option-2: from Linux/MS-DOS/Powershell command-prompt:
# At Linux/MS-DOS/Powershell command-prompt, type:
# vitis_hls -f tcl_script.tcl
####################################################################

# Assume all .cpp files are under the "testdir" directory inside 
# the current directory 
# All Verilog output will be generated under the "verilog_from_vitis"
# directory
# Files for which HLS failed would be reported in "HLS_failed_files.txt"

# Try to create the "verilog_from_vitis" directory
# file mkdir does nothing if the directory already exists

file mkdir "verilog_from_vitis"

set failed_files_list {}

# Iterate over .cpp files
foreach f [glob ./cpp_from_LLM/*.cpp] {
    set fname [file tail $f]
    set projname [file rootname $fname]
    open_project $projname
    regsub {_[0-9]+$} $projname "" topmodule
    set_top $topmodule
    add_files $f
    open_solution "solution1" -flow_target vivado
    set_part {xcvu11p-flga2577-1-e}
    create_clock -period 10 -name default
#source "./countbcd_623/solution1/directives.tcl"
#csim_design
    if {[catch csynth_design]} {
    	puts "\tINFO: File \"$fname\" could not be processed"
    	close_solution
    	close_project
        lappend failed_files_list $fname 
        continue;
    }
#cosim_design
#export_design -format ip_catalog
    set fnewname1 "./$projname"
    append fnewname1 "/solution1/syn/verilog/"
    append fnewname1 $topmodule
    append fnewname1 ".v" 
    set fnewname2 "./verilog_from_vitis/"
    append fnewname2 $projname
    append fnewname2 ".v"
    file copy -force $fnewname1 $fnewname2
    close_solution
    close_project
}

# Save the list of files for which HLS failed (if any)
set fail_count [llength $failed_files_list]

if {!$fail_count} {
    puts "INFO: ALL FILES PASSED HLS"
    puts $fout "INFO: ALL FILES PASSED HLS"
} else {
    puts "INFO: Total $fail_count files failed HLS"
    puts "INFO: List of files failing HLS can be found in the file \"HLS_failed_files.txt\""
    set fout [open "HLS_failed_files.txt" "w"]
    puts $fout "INFO: Total $fail_count file(s) failed HLS"
    puts $fout "INFO: The following file(s) failed HLS:"
    for {set i 0} {$i < [llength $failed_files_list]} {incr i} {
        puts $fout "$i. [lindex $failed_files_list $i]"
    }
    close $fout
}
# Exit Vitis_HLS 
exit
