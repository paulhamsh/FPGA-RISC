`timescale 1ns / 1ps
// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 

module Risc16(
  input         clk,
  output [15:0] io_address,
  output [15:0] io_write_value,
  input  [15:0] io_read_value,
  output        io_write_en,
  output        io_read_en
  );
  
  wire jump, bne, beq; 
  wire data_read_en, data_write_en;
  wire alu_src, reg_dst, mem_to_reg, reg_write_en;
  wire [2:0] alu_op;
  wire [3:0] opcode;
  
  // Datapath
  DatapathUnit datapath
  (
    .clk(clk),
    .jump(jump),
    .beq(beq),
    .data_read_en(data_read_en),
    .data_write_en(data_write_en),
    .alu_src(alu_src),
    .reg_dst(reg_dst),
    .mem_to_reg(mem_to_reg),
    .reg_write_en(reg_write_en),
    .bne(bne),
    .alu_op(alu_op),
    .opcode(opcode),
    
    .io_address(io_address),
    .io_write_value(io_write_value),
    .io_read_value(io_read_value),
    .io_write_en(io_write_en),
    .io_read_en(io_read_en)
  );
 
  // control unit
  ControlUnit control
  (
    .opcode(opcode),
    .reg_dst(reg_dst),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .jump(jump),
    .bne(bne),
    .beq(beq),
    .data_read_en(data_read_en),
    .data_write_en(data_write_en),
    .alu_src(alu_src),
    .reg_write_en(reg_write_en)
  );

endmodule

