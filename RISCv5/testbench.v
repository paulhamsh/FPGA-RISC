`timescale 1ns / 1ps

// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 
// Verilog testbench code to test the processor

module test_RISC16;

  // Inputs
  reg clk;

  // Instantiate the Unit Under Test (UUT)
  Risc16 uut (
    .clk(clk)
  );

// `define PROG_BASIC 
`define PROG_STEPPED

`ifdef PROG_BASIC
  initial 
    begin
      clk <=0;
      #160;  // duration of the simulation
      $finish;
    end

  always 
    begin
      #5 clk = ~clk;
    end

`elsif PROG_STEPPED

  initial 
    begin
      clk <=0;
    end

  always 
    begin
      $display("RISC 16 instruction memory: %4d data memory %4d", `row_i, `row_d);
      #10;
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tr0:   %2h", uut.datapath.reg_file.reg_array[0]);
      if (uut.datapath.reg_file.reg_array[0] != 16'h0001) $error("LD failure");
      
      clk = 0;
      #5;        
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tr1:   %2h", uut.datapath.reg_file.reg_array[1]);
      if (uut.datapath.reg_file.reg_array[1] != 16'h0002) $error("LD failure");
 
      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tr2:   %2h", uut.datapath.reg_file.reg_array[2]);
      if (uut.datapath.reg_file.reg_array[2] != 16'h0003) $error("ADD failure");
      
      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tmem[2]:   %2h", uut.datapath.dm.memory[2]);
      if (uut.datapath.dm.memory[2] != 16'h0003) $error("ST failure");  
      
      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tr2:   %2h", uut.datapath.reg_file.reg_array[2]);
      if (uut.datapath.reg_file.reg_array[2] != 16'hffff) $error("SUB failure");     
      
      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tr2:   %2h", uut.datapath.reg_file.reg_array[2]);
      if (uut.datapath.reg_file.reg_array[2] != 16'hfffe) $error("INV failure");  
      
      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tr2:   %2h", uut.datapath.reg_file.reg_array[2]);
      if (uut.datapath.reg_file.reg_array[2] != 16'h0004) $error("LSL failure");        

      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tr2:   %2h", uut.datapath.reg_file.reg_array[2]);
      if (uut.datapath.reg_file.reg_array[2] != 16'h0000) $error("LSR failure");   
      
      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tr2:   %2h", uut.datapath.reg_file.reg_array[2]);
      if (uut.datapath.reg_file.reg_array[2] != 16'h0000) $error("AND failure");   
      
      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tr2:   %2h", uut.datapath.reg_file.reg_array[2]);
      if (uut.datapath.reg_file.reg_array[2] != 16'h0003) $error("OR failure");  
      
      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tr2:   %2h", uut.datapath.reg_file.reg_array[2]);
      if (uut.datapath.reg_file.reg_array[2] != 16'h0001) $error("SLT failure");                     

      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      clk = 1;
      #5;
      $display("\tr0:   %2h", uut.datapath.reg_file.reg_array[0]);
      if (uut.datapath.reg_file.reg_array[0] != 16'h0002) $error("ADD failure");  
      
      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      $display("\tbranch_control: %1b bne: %1b  beq: %1b  zero_flag: %1b", uut.datapath.branch_control, uut.datapath.bne, uut.datapath.beq, uut.datapath.zero_flag);
      $display("\tpc_next: %3d", uut.datapath.pc_next);
      if (uut.datapath.pc_next != 16'd13) $error("BEQ failure");  
      clk = 1;
      #5;
            
      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      $display("\tbranch_control: %1b bne: %1b  beq: %1b  zero_flag: %1b", uut.datapath.branch_control, uut.datapath.bne, uut.datapath.beq, uut.datapath.zero_flag);
      $display("\tpc_next: %3d", uut.datapath.pc_next);
      if (uut.datapath.pc_next != 16'd14) $error("BNE failure");  
      clk = 1;
      #5;
            
      clk = 0;
      #5;   
      $display("PC:  %3d  Instruction: %16b   Opcode: %4b", uut.datapath.pc_current, uut.datapath.instr, uut.datapath.opcode );
      $display("\tjump: %1b", uut.datapath.jump);
      $display("\tpc_next: %3d", uut.datapath.pc_next);
      if (uut.datapath.pc_next != 16'd0) $error("JMP failure");        
      clk = 1;
      #5;


      #20;
      $finish;
    end
`endif

endmodule