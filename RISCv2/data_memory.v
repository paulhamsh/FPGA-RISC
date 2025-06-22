`include "parameter.v"
// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 
// Verilog code for data Memory


module Data_Memory(
  input clk,
  // address input, shared by read and write port
  input [15:0]   mem_access_addr,
 
  // write port
  input [15:0]   mem_write_data,
  input          mem_write_en,
  input          mem_read,
  // read port
  output [15:0]  mem_read_data
  );

  reg [`col - 1:0] memory [`row_d - 1:0];
  integer f;
  
  wire [2:0] ram_addr = mem_access_addr[2:0];
  
  initial
    begin
      $readmemb("test_data.mem", memory);

      $monitor("time: %0t memory[0] = %b", $time, memory[0]);  
      $monitor("time: %0t memory[1] = %b", $time, memory[1]);      
      $monitor("time: %0t memory[2] = %b", $time, memory[2]);  
      $monitor("time: %0t memory[3] = %b", $time, memory[3]);  
      $monitor("time: %0t memory[4] = %b", $time, memory[4]);  
      $monitor("time: %0t memory[5] = %b", $time, memory[5]);  
      $monitor("time; %0t memory[6] = %b", $time, memory[6]);  
      $monitor("time; %0t memory[7] = %b", $time, memory[7]);        
      `simulation_time;
    end
 
  always @(posedge clk) begin
    if (mem_write_en)
      begin  
        memory[ram_addr] <= mem_write_data;
        
        $display("Writing to RAM: memory[%d] = %b", ram_addr, mem_write_data);
      end
  end
  assign mem_read_data = (mem_read == 1'b1) ? memory[ram_addr]: 16'd0; 

endmodule