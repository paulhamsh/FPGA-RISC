`timescale 1ns / 1ps
// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 
// Verilog code for Control Unit 
module ControlUnit(
      input[3:0] opcode,
      output reg[2:0] alu_op,
      output reg jump ,beq, bne, data_read_en, data_write_en, alu_src, reg_dst, mem_to_reg, reg_write_en    
      );


  always @(*)
  begin
    case(opcode) 
      4'b0000:  // LW
        begin
          reg_dst = 1'b0;      
          alu_src = 1'b1;
          mem_to_reg = 1'b1;
          reg_write_en = 1'b1;
          data_read_en = 1'b1;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          //alu_op = 3'b010;
          alu_op = 3'b000;  // add
          jump = 1'b0;   
        end
      4'b0001:  // SW
        begin
          reg_dst = 1'b0;
          alu_src = 1'b1;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b0;
          data_read_en = 1'b0;      
          data_write_en = 1'b1;
          beq = 1'b0;
          bne = 1'b0;
          //alu_op = 3'b010;
          alu_op = 3'b000;  // add
          jump = 1'b0;   
        end
      4'b0010:  // data_processing - add
        begin
          reg_dst = 1'b1;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b1;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          //alu_op = 3'b000;
          alu_op = 3'b000;  // add
          jump = 1'b0;   
        end
      4'b0011:  // data_processing - sub
        begin
          reg_dst = 1'b1;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b1;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          //alu_op = 3'b000;
          alu_op = 3'b001;  // sub
          jump = 1'b0;   
        end
      4'b0100:  // data_processing - inv
        begin
          reg_dst = 1'b1;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b1;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          //alu_op = 3'b000;
          alu_op = 3'b010; // inv
          jump = 1'b0;   
        end
      4'b0101:  // data_processing - lsl
        begin
          reg_dst = 1'b1;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b1;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          //alu_op = 3'b000;
          alu_op = 3'b011; // lsl
          jump = 1'b0;   
         end
      4'b0110:  // data_processing - lsr
        begin
          reg_dst = 1'b1;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b1;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          //alu_op = 3'b000;
          alu_op = 3'b100; // lsr
          jump = 1'b0;   
        end
      4'b0111:  // data_processing - and
        begin
          reg_dst = 1'b1;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b1;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          //alu_op = 3'b000;
          alu_op = 3'b0101; // and
          jump = 1'b0;   
        end
      4'b1000:  // data_processing - or
        begin
          reg_dst = 1'b1;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b1;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          //alu_op = 3'b000;
          alu_op = 3'b110; // or
          jump = 1'b0;   
        end
      4'b1001:  // data_processing - slt
        begin
          reg_dst = 1'b1;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b1;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          alu_op = 3'b111; // slt
          jump = 1'b0;   
        end
      4'b1011:  // BEQ
        begin
          reg_dst = 1'b0;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b0;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b1;
          bne = 1'b0;
          //alu_op = 3'b001;
          alu_op = 3'b001; // sub
          jump = 1'b0;   
        end
      4'b1100:  // BNE
        begin
          reg_dst = 1'b0;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b0;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b1;
          //alu_op = 3'b001
          alu_op = 3'b001; // sub
          jump = 1'b0;   
        end
      4'b1101:  // JMP
        begin
          reg_dst = 1'b0;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b0;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          //alu_op = 3'b000;
          alu_op = 3'b000; // add
          jump = 1'b1;   
        end   
      default: begin
          reg_dst = 1'b1;
          alu_src = 1'b0;
          mem_to_reg = 1'b0;
          reg_write_en = 1'b1;
          data_read_en = 1'b0;
          data_write_en = 1'b0;
          beq = 1'b0;
          bne = 1'b0;
          alu_op = 3'b000;
          jump = 1'b0; 
        end
      endcase
  end

endmodule
