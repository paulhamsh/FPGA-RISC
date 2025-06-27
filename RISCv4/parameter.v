// https://www.fpga4student.com/2017/04/verilog-code-for-16-bit-risc-processor.html

`timescale 1ns / 1ps

`ifndef PARAMETER_H_
`define PARAMETER_H_
// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 
// Parameter file


`define col 16    // 16 bits instruction memory, data memory
`define row_i 32  // instruction memory, instructions number, this number can be changed. Adding more instructions to verify your design is a good idea.
`define row_d 16  // The number of data in data memory.  

`endif