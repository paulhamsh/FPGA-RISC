`include "parameter.v"
// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 
// Verilog code for Instruction Memory


module InstructionMemory(
  input  [15:0] pc,
  output [15:0] instruction
  );

  // create the memory
  reg [`col - 1:0] memory [`row_i - 1:0];
  
  // memory access will wrap at the limit of the number of words
  wire [`bits_size_i - 1 : 0] rom_addr = pc[`bits_size_i - 1 : 0];
  
  initial
    begin
      //$readmemb("test_prog.mem", memory, 0, 14);
      $readmemb("test_prog3.mem", memory);
    end
  
  assign instruction = memory[rom_addr]; 

endmodule