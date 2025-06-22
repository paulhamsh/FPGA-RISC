`timescale 1ns / 1ps

// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 
// Verilog testbench code to test the processor
module test_Risc_16_bit;

 // Inputs
 reg clk;

 // Instantiate the Unit Under Test (UUT)
 Risc_16_bit uut (
  .clk(clk)
 );

 initial 
   begin
     clk <=0;
     #160;  // duration of the simulation
     $finish;
   end

 always 
   begin
     #5 clk = ~clk;
   end

endmodule