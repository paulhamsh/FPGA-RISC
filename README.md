# FPGA-RISC
Simple RISC processor based on the fpga4students example

# Versions

| Version      | Comments                                                                                                                                                                      |
|--------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| RISCv1       | Example from fpga4students web site                                                                                                                                           |
| RISCv2       | Removed alu_control_unit - stopped the use of both alu_op (2 bits) and opcode (4 bits) and replaced with new alu_op (3 bits) set in control_unit                              |
| RISCv3       | Changed instruction_memory and datapath to use word aligned instruction memory, so PC now increments in units of 1 (now consistent with data memory which is word aligned)    |
| RISCv4       | Changed many names of modules and wires, added full test bench to single step each instruction and check outputs                                                              |
| RISCv5       | Memory mapped IO (LED and switches tested on Digilent Nexys 4 DDR)                                                                                                            |
| RISCv6       | Introduced an Address Decoder unit to make the IO / memory decoder more modular                                                                                               |


# Instructions

A description of each instruction and the machine code format associated with it.

**Note**     
offset6 is signed 6 bits (twos complement)    
offset12 is unsigned    

## Instructions  

```
opcode regA, regB, regC

ld     rd,   rs1(offset6)                      rs  := mem[rs1 + offset6]
st     rs2,  rs1(offset6)                      mem[rs1 + offset6] := rs2
add    rd,   rs1,  rs2                         rd  := rs1 + rs2
sub    rd,   rs1,  rs2                         rd  := rs1 - rs2   
inv    rd,   rs1                               rd  := !rs1
lsl    rd,   rs1,  rs2                         rd  := rs1 << rs2
lsr    rd,   rs1,  rs2                         rd  := rs1 >> rs2
and    rd,   rs1,  rs2                         rd  := rs1 & rs2
or     rd,   rs1,  rs2                         rd  := rs1 | rs2
slt    rd,   rs1,  rs2                         rd  := 1 if rs1 < rs2 else 0  
beq    rs1,  rs2,  offset6                     pc  := pc + 1 + offset6 if rs1 == rs2  # next instruction + offset6
bne    rs1,  rs2,  offset6                     pc  := pc + 1 + offset6 if rs1 != rs2  # next instruction + offset6
jmp    offset12                                pc  := offset12
```

## Machine code format     

```
       xxxx   xxx   xxx   xxx   xxx
ld     0000   rs1   rd    -offset6-
st     0001   rs1   rs2   -offset6-
add    0010   rs1   rs2   rd    000
sub    0011   rs1   rs2   rd    000
inv    0100   rs1   000   rd    000
lsl    0101   rs1   rs2   rd    000
lsr    0110   rs1   rs2   rd    000
and    0111   rs1   rs2   rd    000
or     1000   rs1   rs2   rd    000
slt    1001   rs1   rs2   rd    000
beq    1011   rs1   rs2   -offset6-
bne    1100   rs1   rs2   -offset6-
jmp    1101   -------offset12------
```

## Layout mapped to instruction register order   

```
       xxxx   xxx   xxx   xxx   xxx
ld     0000   regB  regA  -offset6-
st     0001   regB  regA  -offset6-
add    0010   regB  regC  regA  000
sub    0011   regB  regC  regA  000	
inv    0100   regB  000   regA  000
lsl    0101   regB  regC  regA  000
lsr    0110   regB  regC  regA  000
and    0111   regB  regC  regA  000
or     1000   regB  regC  regA  000
slt    1001   regB  regC  regA  000
beq    1011   regA  regB  --value--
bne    1100   regA  regB  --value--
jmp    1101   ------offset 12------
```


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
  <img src="https://github.com/paulhamsh/FPGA-RISC/blob/main/RISCv4.jpg" width="800">
</p>

# Datapath for RISCv6

<p align="center">
  <img src="https://github.com/paulhamsh/FPGA-RISC/blob/main/RISCv6.jpg" width="800">
</p>
