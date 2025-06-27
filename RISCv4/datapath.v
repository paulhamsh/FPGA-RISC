`timescale 1ns / 1ps
// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 
// Verilog code for Data Path of the processor
module DatapathUnit(
  input       clk,
  input       jump, beq, mem_read_en, mem_write_en, alu_src, reg_dst, mem_to_reg, reg_write_en, bne,
  input[2:0]  alu_op,
  output[3:0] opcode
  );
  reg  [15:0] pc_current;
  wire [15:0] pc_next;

  wire [15:0] pc_plus_1;
  wire [15:0] pc_jump;
  wire [15:0] pc_branch;
  wire [15:0] pc_temp;

  wire        branch_control;
      
  wire [15:0] instr;
  
  wire [2:0]  rd;
  wire [15:0] rd_value;
  wire [2:0]  rs1;
  wire [15:0] rs1_value;
  wire [2:0]  rs2;
  wire [15:0] rs2_value;
  
  wire [15:0] ext_imm;
  wire [15:0] alu_in;
  wire [15:0] alu_out;
  wire        zero_flag;

  wire [15:0] mem_out;
 
  // PC 
  initial begin
    pc_current <= 16'd0;
  end
 
  // PC clocked processing
  always @(posedge clk)
  begin 
    pc_current <= pc_next;
  end
  
  // Instruction memory
  InstructionMemory im(.pc(pc_current),.instruction(instr));

  // multiplexer MUX_REG_DEST
  assign rd = (reg_dst == 1'b1) ? instr[5:3] :instr[8:6];
 
  // Register allocations
  assign rs1 = instr[11:9];
  assign rs2 = instr[8:6];

  // Registers
  RegisterUnit reg_file
  (
    .clk(clk),
    .reg_write_en(reg_write_en),
    .rd(rd),
    .rd_value(rd_value),
    .rs1(rs1),
    .rs1_value(rs1_value),
    .rs2(rs2),
    .rs2_value(rs2_value)
   );
 
  // immediate extend
  assign ext_imm = {{10{instr[5]}},instr[5:0]};  
 
  // multiplexer alu_src
  assign alu_in = (alu_src == 1'b1) ? ext_imm : rs2_value;
 
  // ALU 
  ALU alu_unit(.a(rs1_value), .b(alu_in), .alu_control(alu_op), .result(alu_out), .zero(zero_flag));

  // PC MUX
  // Based on PC_beq, PC_bne (and zero flag), jump decide on next PC 
  // If nothing else, PC will increment by one 
 
  assign branch_control = (beq & zero_flag) | (bne & ~zero_flag);

  assign pc_plus_1 = pc_current + 16'd1;  
  assign pc_branch = pc_plus_1 + ext_imm;
  assign pc_temp = (branch_control == 1'b1) ? pc_branch : pc_plus_1;
  assign pc_jump = {pc_plus_1[15:12], instr[11:0]};
  assign pc_next = (jump == 1'b1) ? pc_jump :  pc_temp;

  // Data memory 
  DataMemory dm
  (
    .clk(clk),
    .mem_access_addr(alu_out),
    .mem_in(rs2_value),
    .mem_write_en(mem_write_en),
    .mem_read_en(mem_read_en),
    .mem_out(mem_out)
  );
 
   // write back
   assign rd_value = (mem_to_reg == 1'b1)?  mem_out: alu_out;
   // output to control unit
   assign opcode = instr[15:12];

endmodule
