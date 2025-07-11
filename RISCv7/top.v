`timescale 1ns / 1ps

module top(
  input      CLK100MHZ,
  input      [15:0] SW,
  input      [4:0]  BTN,
  output reg [15:0] LED
  ); 
  
  wire [15:0] io_address;
  wire [15:0] io_write_value;
  reg  [15:0] io_read_value;
  wire        io_write_en;
  wire        io_read_en;   
  

  Risc16 risc(
    .clk(CLK100MHZ),
    .io_address(io_address),
    .io_write_value(io_write_value),
    .io_read_value(io_read_value),
    .io_write_en(io_write_en),
    .io_read_en(io_read_en)
    );
  
  always @(posedge CLK100MHZ)
    begin

      if (io_read_en)
        case (io_address)
          16'b01:  io_read_value <= SW;
          16'b10:  io_read_value <= {BTN, 11'b0};
          default: io_read_value <= 16'b0;
        endcase
      
      /*
      if (io_read_en && io_address[1])
        io_read_value <= {BTN, 11'b0};
     
      if (io_read_en && io_address[0])
        io_read_value <= SW;
      */
      
      if (io_write_en && io_address[2])   // bit 2 is set in the write address
        LED <= io_write_value;
   end
    
endmodule