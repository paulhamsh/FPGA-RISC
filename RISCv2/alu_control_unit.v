`timescale 1ns / 1ps
//fpga4student.com: FPGA projects, Verilog projects, VHDL projects
// Verilog code for 16-bit RISC processor
// ALU_Control Verilog code

module alu_control( ALU_Cnt, ALUOp);
//module alu_control( ALU_Cnt, ALUOp, Opcode);
  output reg[2:0] ALU_Cnt;
  input     [2:0] ALUOp;
  ///input     [3:0] Opcode;
  
  //wire [5:0] ALUControlIn;
  /*
  assign ALUControlIn = {ALUOp,Opcode};
  always @(ALUControlIn)
    casex (ALUControlIn)
      7'b010xxxx: ALU_Cnt = 3'b000;
      7'b001xxxx: ALU_Cnt = 3'b001;
      7'b0000010: ALU_Cnt = 3'b000;
      7'b0000011: ALU_Cnt = 3'b001;
      7'b0000100: ALU_Cnt = 3'b010;
      7'b0000101: ALU_Cnt = 3'b011;
      7'b0000110: ALU_Cnt = 3'b100;
      7'b0000111: ALU_Cnt = 3'b101;
      7'b0001000: ALU_Cnt = 3'b110;
      7'b0001001: ALU_Cnt = 3'b111;
      default:    ALU_Cnt = 3'b000;
    endcase
  */
  
  /*
  assign ALUControlIn = {ALUOp,Opcode};
  always @(ALUControlIn)
    casex (ALUControlIn)
      //6'b000xxxx: ALU_Cnt = 3'b000;
      //6'b001xxxx: ALU_Cnt = 3'b001;
      7'b000xxxx: ALU_Cnt = 3'b000;
      7'b001xxxx: ALU_Cnt = 3'b001;
      7'b001xxxx: ALU_Cnt = 3'b010;
      7'b001xxxx: ALU_Cnt = 3'b011;
      7'b100xxxx: ALU_Cnt = 3'b100;
      7'b101xxxx: ALU_Cnt = 3'b101;
      7'b110xxxx: ALU_Cnt = 3'b110;
      7'b111xxxx: ALU_Cnt = 3'b111;
      default:    ALU_Cnt = 3'b000;
    endcase
    */
    always @(ALUOp)
      ALU_Cnt = ALUOp;
  
    
endmodule