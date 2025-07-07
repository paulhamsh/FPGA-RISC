// fpga4student.com 
// FPGA projects, VHDL projects, Verilog projects 
// Verilog code for RISC Processor 
// Verilog code for data Memory

`define data_bits 16    // 16 bits instruction memory, data memory

`define size_data 5
`define row_d (1 << `size_data)

module DataMemory(
  input clk,
  // address input, shared by read and write port
  input [15:0]   mem_access_addr,
 
  // write port
  input [15:0]   mem_in,
  input          mem_write_en,
  input          mem_read_en,
  // read port
  output [15:0]  mem_out
  );

  // create the memory
  reg [`data_bits-1:0] memory [`row_d-1:0];
  
  // memory access will wrap at the limit of the number of words
  wire [`size_data-1:0] ram_addr = mem_access_addr[`size_data-1:0];
  
  // check to see if memory access or io port access
  //assign is_mem_access = ~mem_access_addr[15];
    
  initial
    begin
      $readmemb("test_data.mem", memory);
    end
 
  always @(posedge clk) begin
    if (mem_write_en)
      begin  
        memory[ram_addr] <= mem_in;
        
        $display("Writing to RAM: memory[%d] = %b", ram_addr, mem_in);
      end
  end
  assign mem_out = (mem_read_en == 1'b1) ? memory[ram_addr]: 16'd0; 

endmodule