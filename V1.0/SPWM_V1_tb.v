`default_nettype none
`timescale 1ns / 1ns

module tb;
  reg CLK;
  wire outa,outb;
  
  top uut(CLK,outa,outb);
  
  always #500 CLK = ~CLK;
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,uut);
      CLK=1;
     
      
      #3778336
      
      $finish;
    end
endmodule
