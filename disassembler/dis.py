# My RISC simple assembler
# Creates machine code from My RISC

# Instruction formats

# ld     rd,  rs1(offset6)
# st     rs2, rs1(offset6)
# add    rd,  rs1, rs2
# inv    rd,  rs1	
# beq    rs1, rs2, offset6
# bne    rs1, rs2, offset6
# jmp    offset12
# lui    rd,  imm8
# lli    rd,  imm8

# ld   0000  rs1  rd   -offset6-
# st   0001  rs1  rs2  -offset6-
# add  0010  rs1  rs2  rd    000
# inv  0100  rs1  000  rd    000
# beq  1011  rs1  rs2  -offset6-
# bne  1100  rs1  rs2  -offset6-
# jmp  1101  ------offset12-----
# lui  1110  rd   0 ----imm8----
# lli  1111  rd   0 ----imm8----

# ld   0000  regB regA --value--
# st   0001  regB regA --value--
# add  0010  regB regC regA  000	
# inv  0100  regB  000 regA  000
# beq  1011  regA regB --value--
# bne  1100  regA regB --value--
# jmp  1101  -----offset 12-----
# lui  1110  regA  0 ---imm8----	
# lli  1111  regA  0 ---imm8----

def disassemble(code):
    full_assembly = []
    opcodes = ["ld ", "st ", "add", "sub", "inv", "lsl", "lsr", "and", "or ", "slt", "", "beq", "bne", "jmp", "lui", "lli"]

    line_number = 0
    labels =[]
    
    for line in code:
        comment = ""
        comment_location = line.find("//")
        if comment_location > -1:
            comment = " # "+ line[comment_location + 2:]
            line = line[:comment_location]
        
        value = int(line, 2)
        opcode = (value & 0b1111_000_000_000_000) >> 12
        r1     = (value & 0b0000_111_000_000_000) >> 9
        r2     = (value & 0b0000_000_111_000_000) >> 6
        r3     = (value & 0b0000_000_000_111_000) >> 3
        off6   = (value & 0b0000_000_000_111_111)
        off12  = (value & 0b0000_111_111_111_111)
        imm8   = (value & 0b0000_0000_1111_1111)
        
        assembly = ""

        if off6 > 31:
            signed_offset = off6 - 64
        else:
            signed_offset = off6

        assembly = opcodes[opcode] + " "
        
        if   opcode <= 0b0001:
            regA = r2
            regB = r1
            assembly += "r" + str(regA) + ", r" + str(regB) + "(" + str(signed_offset)+ ")"
        elif opcode == 0b1101:
            assembly += str(off12)
            labels.append(off12)
        elif opcode == 0b1100 or opcode == 0b1011:
            regA = r1
            regB = r2
            assembly += "r" + str(regA) + ", r" + str(regB) + ", " + "{:8s}".format(str(signed_offset)) + "  # "+ str(line_number + 1 + signed_offset)
            labels.append(line_number + 1 + signed_offset)
        elif opcode == 0b0100:
            regA = r3
            regB = r1
            assembly += "r" + str(regA) + ", r" + str(regB)
        elif opcode == 0b1110 or opcode == 0b1111:
            regA = r1
            assembly += "r" + str(regA) + ", " + "{:8s}".format(str(imm8))
        else:
            regA = r3
            regB = r1
            regC = r2
            assembly += "r" + str(regA) + ", r" + str(regB) + ", r" + str(regC)
            
        line_number += 1
        full_assembly.append(assembly + comment)

    return full_assembly, labels

##############################################################

import sys, os

if len(sys.argv) > 1:
    filename = sys.argv[1]
    splitname = filename.split(".")
    outname = splitname[0] +".rsc"
else:
    filename = "test1.mc"
    outname = None

f = open(filename, mode='r')
code = f.readlines()
code_clean =[l.strip() for l in code]
f.close()

ass, labels = disassemble(code_clean)

# Print out the result
line_no = 0
for l in ass:
    if line_no in labels:
        print("# line ", line_no)
        
    print("{:4d} : {:s}".format(line_no, l))
    line_no += 1
print()

line_no = 0

if outname:
    f = open(outname, mode='w')

    for v in ass:
        if line_no in labels:
            print("# line ", line_no, file = f)
            
        print(v, file=f)
        line_no += 1        
    f.close()

