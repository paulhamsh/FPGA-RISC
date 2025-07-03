# FPGA-RISC
Simple RISC processor based on the fpga4students example

# Versions

| Version      | Comments                                                                                                                                                                      |
|--------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| RISCv1       | Example from fpga4students web site                                                                                                                                           |
| RISCv2       | Removed alu_control_unit - stopped the use of both alu_op (2 bits) and opcode (4 bits) and replaced with new alu_op (3 bits) set in control_unit                              |
| RISCv3       | Changed instruction_memory and datapath to use word aligned instruction memory, so PC now increments in units of 1 (now consistent with data memory which is word aligned)    |
| RISCv4       | Changed many names of modules and wires, added full test bench to single step each instruction and check outputs                                                              |
| RISCv5       | Memory mapped IO (LED and switches tested on Digilent Nexys 4 DDR)                                                                                                             |

# Data and address bus widths 
The PC address width is 16 bits, but a jump can only be 12 bits, and a branch can be a 6 bit signed offset (+31, -32).     
The data bus address width is 16 bits, but is set at 3 bits in ```data_memory.v```   

```
wire [2:0] ram_addr=mem_access_addr[2:0];
```

Changed in RISCv4 to be driven by parameters in ```parameter.v```    
A ```bits_size_i``` of 5 will be 1 << 5 words, which is 32 words    

```
`define bits_size_i 5
`define row_i (1 << `bits_size_i)

`define bits_size_d 5
`define row_d (1 << `bits_size_d)

```

# Datapath for RISCv4

<p align="center">
  <img src="https://github.com/paulhamsh/FPGA-RISC/blob/main/RISCv5.jpg" width="800">
</p>

# Datapath for RISCv5

<p align="center">
  <img src="https://github.com/paulhamsh/FPGA-RISC/blob/main/RISCv6.jpg" width="800">
</p>
