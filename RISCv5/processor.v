`timescale 1ns / 1ps
// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 

module Risc16(
  input         clk,
  input  [15:0] io_read_device,
  output [15:0] io_write_device
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
    .opcode(opcode),
    
    .io_read_device(io_read_device),
    .io_write_device(io_write_device)
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


module top(
  input CLK100MHZ,
  input [15:0] SW,
  output reg [15:0] LED
  );
  
  wire [15:0] io_led_value;
  
  Risc16 risc(
    .clk(CLK100MHZ),
    .io_read_device(SW),
    .io_write_device(io_led_value)
    );

always @(posedge CLK100MHZ)
  begin
    LED <= io_led_value;
  end

endmodule