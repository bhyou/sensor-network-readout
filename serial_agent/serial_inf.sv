interface serial_inf (input logic clk);

   logic             serial_rx;   // serial transmission ports 
   logic             serial_tx;   // serial receiving ports 

   clocking mcb @(posedge clk);
     default input #1 output #1;
     output  serial_tx ;
     input   serial_rx ;
   endclocking

   clocking scb @(posedge clk);
     default input #1 output #1;
     input    serial_tx ;
     output   serial_rx ;
   endclocking

  modport master (input clk, clocking mcb);
  modport slaver (input clk, clocking scb);
  modport monitor (input clk, serial_tx, serial_rx);

endinterface

