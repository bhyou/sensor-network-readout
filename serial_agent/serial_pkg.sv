`timescale 1ns/100ps

package serial_pkg;
  int TRACE_LOW = 0;
  int TRACE_HIGH = 1;
  int INFO_LOW = 0;
  int INFO_MEDIUM = 1;
  int REPORT_LOW = 1;
  int run_for_n_packets = 10;

  `include  "serial_define.sv"

  `include  "serial_pkt.sv"
  `include  "serial_generator.sv"
  `include  "serial_driver.sv"
  `include  "serial_monitor.sv"
  `include  "serial_agent.sv"
endpackage
