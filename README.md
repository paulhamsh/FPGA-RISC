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
| RISCv7       | Added MUX modules to give more code clarity, introduced LUI and LLI instructions and widened alu_op (4 bits), alu_src (2 bits) and reg_dst (2 bits)                           |

# Instructions

A description of each instruction and the machine code format associated with it.

**Note**     
offset6 is signed 6 bits offset (twos complement)    
addr12 is unsigned 12 bit address   
imm8 is unsigned 8 bit immediate value   

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
beq    rs1,  rs2,  offset6                     pc  := pc + 1 + offset6 if rs1 == rs2     # next instruction + offset6
bne    rs1,  rs2,  offset6                     pc  := pc + 1 + offset6 if rs1 != rs2     # next instruction + offset6
jmp    addr12                                  pc  := addr12
lui    rd,   imm8                              rd  := {imm8, rd[7:0]}                    # load upper 8 bits with immediate
lli    rd,   imm8                              rd  := {rd[7:0], imm8}                    # load lower 8 bits with immediate
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
jmp    1101   --------addr12-------
lui    1110   rd    0  ----imm8----
lli    1111   rd    0  ----imm8----
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
beq    1011   regA  regB  -offset6-
bne    1100   regA  regB  -offset6-
jmp    1101   -------addr12--------
lui    1110   regA  0  ----imm8----	
lli    1111   regA  0  ----imm8----
```

# Assembler

To assemble from file ```test3.rsc``` and create `test3.mc``` output   

```
python ass.py test3.rsc

sub   r0, r0, r0       #        r0 = 0000000000000000
ld    r3, r0[0]        #        r3 = Mem[0] = 1000_0000_0000_0001
ld    r4, r0[1]        #        r4 = Mem[1] = 1000_0000_0000_0010
ld    r5, r0[2]        #        r5 = Mem[2] = 1000_0000_0000_0100
ld    r1, r3[0]        #        r1 = IO[1]
ld    r2, r4[0]        #        r2 = IO[2]
or    r6, r1, r2       #        r6 = r1 | r2
st    r6, r5[0]        #        IO[4] = r6
jmp   0

   0 : 0011_000_000_000_000
   1 : 0000_000_011_000_000
   2 : 0000_000_100_000_001
   3 : 0000_000_101_000_010
   4 : 0000_011_001_000_000
   5 : 0000_100_010_000_000
   6 : 1000_001_010_110_000
   7 : 0001_101_110_000_000
   8 : 1101_000_000_000_000
```

# Disassembler

To disassemble from file ```test3.mc``` and create `test3.rsc``` output   

```
python dis.py test3.mc

# line  0
   0 : sub r0, r0, r0
   1 : ld  r3, r0(0)
   2 : ld  r4, r0(1)
   3 : ld  r5, r0(2)
   4 : ld  r1, r3(0)
   5 : ld  r2, r4(0)
   6 : or  r6, r1, r2
   7 : st  r6, r5(0)
   8 : jmp 0
```

# Data and address bus widths 
The PC address width is 16 bits, but a jump can only be 12 bits, and a branch can be a 6 bit signed offset (+31, -32).     
The data bus address width is 16 bits.  

Since RISCv4 the size of data and instruction memory are defined in the relevant verilog file, using ```bits_size_i``` and ```bits_size_d```    

A ```bits_size_i``` of 5 will be 1 << 5 words, which is 32 words    

```
`define bits_size_i 5
`define row_i (1 << `bits_size_i)

`define bits_size_d 5
`define row_d (1 << `bits_size_d)

```

# Datapath for RISCv7

<p align="center">
  <img src="https://github.com/paulhamsh/FPGA-RISC/blob/main/RISCv7.jpg" width="800">
</p>


# Datapath for RISCv6

<p align="center">
  <img src="https://github.com/paulhamsh/FPGA-RISC/blob/main/RISCv6.jpg" width="800">
</p>

# Datapath for RISCv4

<p align="center">
  <img src="https://github.com/paulhamsh/FPGA-RISC/blob/main/RISCv4.jpg" width="800">
</p>

