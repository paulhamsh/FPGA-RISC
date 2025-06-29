// https://www.fpga4student.com/2017/04/verilog-code-for-16-bit-risc-processor.html

`timescale 1ns / 1ps

`ifndef PARAMETER_H_
`define PARAMETER_H_
// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 
// Parameter file


`define col 16    // 16 bits instruction memory, data memory

`define bits_size_i 5
`define row_i (1 << `bits_size_i)

`define bits_size_d 5
`define row_d (1 << `bits_size_d)

`endif