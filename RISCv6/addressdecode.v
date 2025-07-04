`timescale 1ns / 1ps

module AddressDecoder(
  input  [15:0] data_address,
  input         data_read_en,
  input         data_write_en,
  input  [15:0] data_write_value,
  
  output [15:0] mem_address,
  output        mem_read_en,
  output        mem_write_en,
  output [15:0] mem_write_value,
  
  output [15:0] io_address,
  output        io_read_en,
  output        io_write_en,
  output [15:0] io_write_value,
  
  output        is_io
);
    
  wire        is_mem;

  assign io_address = {1'b0, data_address[14:0]};      // just set top bit to 0
  assign mem_address = data_address;                   // top bit already 0
    
  // Is this a memory or IO address?
  assign is_mem = ~data_address[15];                   // top bit is 0
  assign is_io =   data_address[15];                   // top bit is 1
    
  // Memory and IO enable read and write flags
  assign mem_read_en =  data_read_en  && is_mem; 
  assign mem_write_en = data_write_en && is_mem;
  assign io_read_en =   data_read_en  && is_io;
  assign io_write_en =  data_write_en && is_io;
  
  assign mem_write_value = data_write_value;
  assign io_write_value =  data_write_value;
endmodule
