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
    label_names = {}


    # Pass 1
    for line in code:
        find_label = line.find("// [")
        find_colon = line.find(":")
        find_end   = line.find("]")
        if find_label > -1 and find_colon > -1 and find_end > -1:    
            label = line[find_label + 4: find_colon]
            value = line[find_colon + 1: find_end]
            label_names[int(value)] = label
  

    # Pass 2
    for line in code:
        comment = ""
        assembly = ""
        jump_dest = None

        # remove anything after a left brace { (to allow for auto-label comments added)
        brace_location = line.find("{")
        if brace_location > -1:
            line = line[:brace_location]
        
        comment_location = line.find("//")
        if comment_location > -1:
            comment = line[comment_location + 2:]
            line = line[:comment_location]
            
        # check if only a comment or a label in a comment // [xxx:yy]
        if comment_location == 0:
            label_start = comment.find("[")
            label_end = comment.find(":")
            if label_start > -1 and label_end > -1:
                output = comment[label_start + 1 : label_end + 1]
            else:
                output = "//" + comment
            full_assembly.append((None, output))
        else:
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
                jump_dest = off12
                if label_names.get(jump_dest):
                    assembly += label_names[jump_dest]
                    jump_dest = None
                else:
                    assembly += " {:9d}      ".format(off12)
            elif opcode == 0b1100 or opcode == 0b1011:
                regA = r1
                regB = r2
                assembly += "r" + str(regA) + ", r" + str(regB) + ", "
                jump_dest = line_number + 1 + signed_offset
                if label_names.get(jump_dest):
                    assembly += label_names[jump_dest]
                    jump_dest = None
                else:
                    assembly += "{:8s}".format(str(signed_offset))
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

            output = "{:25s}".format(assembly)
            if comment != "":
                output += "//" + comment
            
            if jump_dest != None:
                jump_str = str(jump_dest)
                if label_names.get(jump_dest):
                    jump_str = label_names[jump_dest]
                else:
                    jump_str = str(jump_dest)
                   
                if comment == "":
                    output += "// "
                output += "{jump to " + jump_str +  "}"
            full_assembly.append((line_number, output))
            line_number += 1
            
    return full_assembly

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

ass= disassemble(code_clean)

# Print out the result
line_no = 0
for l, line in ass:
    if l != None:
        print("{:4d} : {:s}".format(l, line))
    else:
        print(line)
print()

line_no = 0

if outname:
    f = open(outname, mode='w')
    for l, line in ass:
        print(line, file=f)
    f.close()

