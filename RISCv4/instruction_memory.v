`include "parameter.v"
// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 
// Verilog code for Instruction Memory


module InstructionMemory(
  input  [15:0] pc,
  output [15:0] instruction
  );

  reg [`col - 1:0] memory [`row_i - 1:0];
  //wire [3 : 0] rom_addr = pc[4 : 1];
  wire [3 : 0] rom_addr = pc[3 : 0];
  
  initial
    begin
      $readmemb("test_prog.mem", memory, 0, 14);
    end
  
  assign instruction =  memory[rom_addr]; 

endmodule