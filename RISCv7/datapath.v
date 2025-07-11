`timescale 1ns / 1ps
// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 
// Verilog code for Data Path of the processor

module DatapathUnit(
  input         clk,
  input         jump, beq, bne, 
  input         data_read_en, data_write_en, 
  input         reg_write_en, alu_src, reg_dst, mem_to_reg, 
  input  [2:0]  alu_op,
  output [3:0]  opcode,
 
  output [15:0] io_address,
  output [15:0] io_write_value,
  input  [15:0] io_read_value,
  output        io_write_en,
  output        io_read_en
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

  wire [15:0] data_read_value;

  wire        is_io;

  wire [15:0] mem_address;
  wire [15:0] mem_read_value;
  wire [15:0] mem_write_value;
  wire        mem_read_en;
  wire        mem_write_en;

  // Note that io_address is part of the interface
  // Note that io_read_value is part of the interface
  // Note that io_write_value is part of the interface
  // Note that io_read_en is part of the interface
  // Not that  io_write_en are part of the interface
  
  ////
  //// Program counter
  ////
  
  initial begin
    pc_current <= 16'd0;
  end
 
  // Update to next PC on rising clock
  always @(posedge clk)
  begin 
    pc_current <= pc_next;
  end

  //// 
  //// Instruction memory
  //// 
    
  // Instruction memory
  InstructionMemory im
  (
    .pc(pc_current),
    .instruction(instr)
  );
   
  // Output the opcode for control unit 
  assign opcode = instr[15:12];
 
  //// 
  //// Registers
  ////
  
  // Source register allocations
  assign rs1 = instr[11:9];
  assign rs2 = instr[8:6];
  
  // RD_MUX    
  // Destination register selection
  assign rd = reg_dst ? instr[5:3] :instr[8:6];
  
  // Write back the destination register value - either ALU output
  // MEM_READ_MUX   
  assign data_read_value = is_io ? io_read_value : mem_read_value;
  // RD_VALUE_MUX   
  assign rd_value = mem_to_reg?  data_read_value : alu_out;

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
   
  ////
  //// ALU
  ////
 
  // extend the 6 bit immediate to 16 bits (copy bit 5 to all higher bits)
  assign ext_imm = {{10{instr[5]}},instr[5:0]};  
 
  // ALU_IN_MUX
  // determine input for alu - either the rs2 value or extended immediate value
  assign alu_in = (alu_src == 1'b1) ? ext_imm : rs2_value;
 
  // set up the ALU with rs1 and alu_in as inputs - exposes zero flag for branching
  ALU alu_unit
  (
    .a(rs1_value), 
    .b(alu_in), 
    .alu_control(alu_op), 
    .result(alu_out), 
    .zero(zero_flag)
  );

  ////
  //// Branch control
  ////
  
  // BRANCH_MUX
  // The PC increments by 1
  // If a branch is needed, branch_control is true, and the destination is set a PC+1 + ext_imm
  // If a jump is needed, the jump destination is calculated
  // Then pc_next set to the correct value - PC + 1, branch destination or jump destination
  
  assign branch_control = (beq && zero_flag) || (bne && ~zero_flag);
  assign pc_plus_1 = pc_current + 16'd1;  
  assign pc_branch = pc_plus_1 + ext_imm;
  assign pc_temp = branch_control? pc_branch : pc_plus_1;
  assign pc_jump = {pc_plus_1[15:12], instr[11:0]};
  assign pc_next = jump ? pc_jump :  pc_temp;

  ////
  //// Address decoder
  ////

  AddressDecoder ad
  (
    .data_address(alu_out),
    .data_read_en(data_read_en),
    .data_write_en(data_write_en),
    .data_write_value(rs2_value),
    .mem_address(mem_address),
    .mem_read_en(mem_read_en),
    .mem_write_en(mem_write_en),
    .mem_write_value(mem_write_value),
    .io_address(io_address),
    .io_read_en(io_read_en),
    .io_write_en(io_write_en),
    .io_write_value(io_write_value),
    .is_io(is_io)
  
  );
 

  // Data memory 
  DataMemory dm
  (
    .clk(clk),
    .mem_access_addr(mem_address),
    //.mem_in(rs2_value),
    .mem_in(mem_write_value),
    .mem_write_en(mem_write_en),
    .mem_read_en(mem_read_en),
    .mem_out(mem_read_value)
  );
 
  // IO 
  // io_address, io_read_en and io_write_en set above
  // io_read_value is an input set in the other side of the IO interface
  // so only io_write_value to assign here
  ///assign io_write_value = rs2_value;
 
endmodule
