`timescale 1ns / 1ps

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

  initial begin
    io_store <= 16'd0;
  end

  assign io_read_value = SW;
  assign LED = io_store;
  
  always @(posedge CLK100MHZ)
    begin
      if (io_write_en)
        begin  
          io_store <= io_write_value;
        end
    end
    
endmodule