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
  
  wire jump, bne, beq, data_read_en, data_write_en, alu_src, reg_dst, mem_to_reg, reg_write_en;
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


module top(
  input         CLK100MHZ,
  input  [15:0] SW,
  output [15:0] LED
  );
  
  wire [15:0] io_address;
  wire [15:0] io_write_value;
  wire [15:0] io_read_value;
  wire        io_write_en;
  wire        io_read_en;   
  
  reg  [15:0] io_store;
  
  Risc16 risc(
    .clk(CLK100MHZ),
    .io_address(io_address),
    .io_write_value(io_write_value),
    .io_read_value(io_read_value),
    .io_write_en(io_write_en),
    .io_read_en(io_read_en)
    );

initial
  begin
    io_store <= 16'd0;
  end

assign io_read_value = SW;

always @(posedge CLK100MHZ)
  begin
  /*
    if (io_read_en)
      begin
        io_read_value <= SW;
        io_store <= SW;
      end
  */ 
    if (io_write_en)
      begin  
        io_store <= io_write_value;
      end

   end
  
  assign LED = io_store;

endmodule