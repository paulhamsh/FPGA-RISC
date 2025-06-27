# FPGA-RISC
Simple RISC processor based on the fpga4students example

| RISC Version | Comments |
|--------------|----------|
| RISCv1       | Example from fpga4students web site   |
| RISCv2       | removed alu_control_unit - stopped the use of both alu_op (2 bits) and opcode (4 bits) and replaced with new alu_op (3 bits) set in control_unit   |
|RISCv3 | changed instruction_memory and datapath to use word aligned instruction memory, so PC now increments in units of 1 (now consistent with data memory which is word aligned)   
The PC address width is 16 bits, but a jump can only be 12 bits, and a branch can be a 6 bit signed offset (+31, -32).     
The data bus address width is 16 bits, but is set at 3 bits in ```data_memory.v```   

```
wire [2:0] ram_addr=mem_access_addr[2:0];
```
|

