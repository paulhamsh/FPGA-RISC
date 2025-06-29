`include "parameter.v"

module IOPorts(
  input clk,
  // address input, shared by read and write port
  input [15:0]   io_access_addr,
  // write port
  input [15:0]   io_in,
  input          io_write_en,
  input          io_read_en,
  // read port
  output [15:0]  io_out,
  
  input [15:0]   io_read_device,
  output reg [15:0]  io_write_device
  );
  
  wire is_port_access;
  reg [15:0] io_read_store;
  
  assign is_port_access = io_access_addr[15];

  always @(posedge clk) begin
    if (io_write_en && is_port_access)// && is_port_access)
      begin  
        io_write_device <= io_read_device;
        io_read_store <= io_read_device;
      end
  end
  
  assign io_out = (io_read_en == 1'b1) ? io_read_device : 16'd0;
endmodule