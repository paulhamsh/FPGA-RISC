`timescale 1ns / 1ps
// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 

module Risc16(
  input clk
  );
  
  wire jump, bne, beq, mem_read_en, mem_write_en, alu_src, reg_dst, mem_to_reg, reg_write_en;
  wire [2:0] alu_op;
  wire [3:0] opcode;
  
  // Datapath
  DatapathUnit datapath
  (
    .clk(clk),
    .jump(jump),
    .beq(beq),
    .mem_read_en(mem_read_en),
    .mem_write_en(mem_write_en),
    .alu_src(alu_src),
    .reg_dst(reg_dst),
    .mem_to_reg(mem_to_reg),
    .reg_write_en(reg_write_en),
    .bne(bne),
    .alu_op(alu_op),
    .opcode(opcode)
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
    .mem_read_en(mem_read_en),
    .mem_write_en(mem_write_en),
    .alu_src(alu_src),
    .reg_write_en(reg_write_en)
  );

endmodule

