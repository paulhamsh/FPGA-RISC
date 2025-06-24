# FPGA-RISC
Simple RISC processor based on the fpga4students example

RISCv1 example from fpga4students web site   
RISCv2 removed alu_control_unit - stopped the use of both alu_op (2 bits) and opcode (4 bits) and replaced with new alu_op (3 bits) set in control_unit   
RISCv3 changed instruction_memory and datapath to use word aligned instruction memory, so PC now increments in units of 1 (now consistent with data memory which is word aligned)   

