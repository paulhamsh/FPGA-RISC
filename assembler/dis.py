# My RISC simple assembler
# Creates assembler from My RISC machine code

# Disassemble a My RISC machine code file
#


# Format is:
# {label_in_comment}
# {binary} {comment}
#
# comments start with //
# label_in_comment is formatted: // [label:line]
#
# Example:
# 
# // comment
# // [start:0]
# 0000_010_000_000000
# 0000_010_000_000000  // with comment

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

        # remove anything after a left brace { - to allow for auto-label comments added
        brace_location = line.find("{")
        if brace_location > -1:
            line = line[:brace_location]

        line = line.strip()        
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
        elif line != "":
            value = int(line, 2)
            opcode = (value & 0b1111_000_000_000_000) >> 12
            r1     = (value & 0b0000_111_000_000_000) >> 9
            r2     = (value & 0b0000_000_111_000_000) >> 6
            r3     = (value & 0b0000_000_000_111_000) >> 3
            off6   = (value & 0b0000_000_000_111_111)
            off12  = (value & 0b0000_111_111_111_111)
            imm8   = (value & 0b0000_0000_1111_1111)
        
            if off6 > 31:
                signed_offset = off6 - 64
            else:
                signed_offset = off6

            assembly = f"{opcodes[opcode]:3s} "
        
            if   opcode <= 0b0001:
                regA = r2
                regB = r1
                assembly += f"r{regA:0d}, r{regB:0d}({signed_offset:0d})"
            elif opcode == 0b1101:
                jump_dest = off12
                if label_names.get(jump_dest):
                    assembly += label_names[jump_dest]
                else:
                    assembly += f"{jump_dest:0d}"
            elif opcode == 0b1100 or opcode == 0b1011:
                regA = r1
                regB = r2
                assembly += f"r{regA:0d}, r{regB:0d}, "
                jump_dest = line_number + 1 + signed_offset
                if label_names.get(jump_dest):
                    assembly += label_names[jump_dest]
                else:
                    assembly += f"{signed_offset:0d}"
                    comment += f" {{jump {jump_dest:0d}}}"
            elif opcode == 0b0100:
                regA = r3
                regB = r1
                assembly += f"r{regA:0d}, r{regB:0d}"
            elif opcode == 0b1110 or opcode == 0b1111:
                regA = r1
                assembly += f"r{regA:0d}, {imm8:0d}"
            else:
                regA = r3
                regB = r1
                regC = r2
                assembly += f"r{regA:0d}, r{regB:0d}, r{regC:0d}"

            output = f"{assembly:25s}"
            
            if comment != "":
                output += "//" + comment
 
            full_assembly.append((line_number, output))
            line_number += 1
            
    return full_assembly

##############################################################

import sys, os

if len(sys.argv) > 1:
    filename = sys.argv[1]
    splitname = filename.split(".")
    outname1 = splitname[0] +".rsc"
    outname2 = splitname[0] +".lrs"
else:
    filename = "test1.mc"
    outname1 = None

f = open(filename, mode='r')
code = f.readlines()
code_clean =[l.strip() for l in code]
f.close()

ass= disassemble(code_clean)

# Print out the result
line_no = 0
for line_no, line in ass:
    if line_no != None:
        print(f"{line_no:<4d}      {line:s}")
    else:
        print(f"     {line:s}")
print()

line_no = 0

if outname1:
    f1 = open(outname1, mode='w')
    f2 = open(outname2, mode='w')
    for line_no, line in ass:
        if line_no != None:
            print(f"          {line:s}", file = f1)
            print(f"{line_no:<4d}      {line:s}", file = f2)
        else:
            print(line, file = f1)
            print(line, file = f2)
    f1.close()
    f2.close()

