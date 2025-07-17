# My RISC simple assembler
# Creates machine code from My RISC

import re


# Check for leading negative sign - no need to check for plus sign as that is removed as whitespace
def is_int(s):
    return s.isnumeric() or (s[0] == "-" and s[1:].isnumeric())

# pretty print the machine code binary, add a line number if not None
def machine_code_to_str(val):
    v1 = (val & 0b1111_000_000_000_000) >> 12
    v2 = (val & 0b0000_111_000_000_000) >> 9
    v3 = (val & 0b0000_000_111_000_000) >> 6
    v4 = (val & 0b0000_000_000_111_000) >> 3
    v5 = (val & 0b0000_000_000_000_111)
    return ("{:04b}_{:03b}_{:03b}_{:03b}_{:03b}".format(v1, v2, v3, v4, v5))
          
def tokenise(txt) :	
    txt = txt.replace("[", " ")
    txt = txt.replace("]","")
    txt = txt.replace("(", " ")
    txt = txt.replace(")","")
    txt = txt.lower()

    comment = ""
    comment_location = txt.find("//")
    if comment_location != -1:
        comment = "//" + txt[comment_location + 2:]
        txt = txt[:comment_location]
    
    # as a byproduct of the split
    # this will remove any + sign preceding a number
    sp = re.split("[,\s\+]+", txt)

    label = None	
    cmd   = None	
    regA  = None	
    regB  = None	
    regC  = None	
    value = None
    jmp_label = None

    for c in sp:
        if len(c) > 0:             # don't process an empty cell
            if c[-1] == ":":
                label = c[:-1]
            elif cmd == None:
                cmd = c
            elif regA == None and c[0] == "r" and c[1].isdigit():
                regA = int(c[1])
            elif regB == None and c[0] == "r" and c[1].isdigit():
                regB = int(c[1])
            elif regC == None and c[0] == "r" and c[1].isdigit():
                regC = int(c[1])
            elif value == None  and is_int(c):
                value = int(c)
            else:
                jmp_label = c
          
    return label, cmd, regA, regB, regC, value, jmp_label, comment

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
	

def assemble(code):
    result = []
    label_to_line = {}
    line_to_label = {}
    
    arith_cmds = {"add": 2, "sub": 3, "lsl": 5,
                  "lsr": 6, "and": 7, "or" : 8,
                  "slt": 9}
    
    # Pass 1 - for labels
    line_number = 0
    for line in code:
        (label, cmd, regA, regB, regC, value, jmp_label, comment) = tokenise(line)
        if label:
            label_to_line[label] = line_number
            line_to_label[line_number] = label
        if cmd:
            line_number += 1

    # Pass 2 - assembly
    line_number = 0
    for line in code:
        (label, cmd, regA, regB, regC, value, jmp_label, comment) = tokenise(line)
        machine_code = None
        mc = ""
        
        # Calculate a jump offset
        if jmp_label:
            if cmd == "jmp":
                value = label_to_line[jmp_label]
            else:
                # only do this if we are bne or beq
                value = label_to_line[jmp_label] - (line_number + 1)

        # adjust the offset if negative
        if value:
            if value < 0:
                value = 64 + value

        if cmd:
            if   cmd == "ld":
                machine_code = 0b0000 << 12
                machine_code |= regB << 9
                machine_code |= regA << 6
                machine_code |= value & 0b111111 # 6 bits

                mc =  "0000_"
                mc += "{:03b}".format(regB) + "_"
                mc += "{:03b}".format(regA) + "_"
                mc += "{:06b}".format(value)             

            elif cmd == "st":
                machine_code = 0b0001 << 12
                machine_code |= regB << 9
                machine_code |= regA << 6
                machine_code |= value & 0b111111 # 6 bits

                mc =  "0001_"
                mc += "{:03b}".format(regB) + "_"
                mc += "{:03b}".format(regA) + "_"
                mc += "{:06b}".format(value)
                
            elif cmd == "beq":
                machine_code = 0b1011 << 12
                machine_code |= regA << 9
                machine_code |= regB << 6
                machine_code |= value & 0b111111 # 6 bits

                mc =  "1011_"
                mc += "{:03b}".format(regA) + "_"
                mc += "{:03b}".format(regB) + "_"
                mc += "{:06b}".format(value) 

                
            elif cmd == "bne":
                machine_code = 0b1100 << 12	
                machine_code |= regA << 9	
                machine_code |= regB << 6	
                machine_code |= value & 0b111111 # 6 bits

                
                mc =  "1100_"
                mc += "{:03b}".format(regA) + "_"
                mc += "{:03b}".format(regB) + "_"
                mc += "{:06b}".format(value) 

            elif cmd == "jmp":		
                machine_code = 0b1101 << 12
                machine_code |= value & 0b111111111111 # 12 bits
                
                mc =  "1101_"
                mc += "{:012b}".format(value)

            elif cmd == "inv":		
                machine_code = 0b0100 << 12
                machine_code |= regB << 9
                machine_code |= regA << 3

                mc =  "0100_"
                mc += "{:03b}".format(regB) + "_"
                mc += "000_"
                mc += "{:03b}".format(regA) + "_"
                mc += "000"

                
            elif cmd == "lui":		
                machine_code = 0b1110 << 12
                machine_code |= regA << 9	
                machine_code |= value

                mc =  "1110_"
                mc += "{:03b}".format(regA) + "_"
                mc += "{:08b}".format(value)
                
            elif cmd == "lli":		
                machine_code = 0b1111 << 12
                machine_code |= regA << 9	
                machine_code |= value

                mc =  "1111_"
                mc += "{:03b}".format(regA) + "_"
                mc += "{:08b}".format(value)
                
            elif cmd in arith_cmds:		
                machine_code = arith_cmds[cmd] << 12
                machine_code |= regB << 9	
                machine_code |= regC << 6	
                machine_code |= regA << 3

                mc =  "{:04b}_".format(arith_cmds[cmd])
                mc += "{:03b}".format(regB) + "_"
                mc += "{:03b}".format(regC) + "_"
                mc += "{:03b}".format(regA) + "_"
                mc += "000"
                
        if line_to_label.get(line_number) and machine_code:
            label = line_to_label[line_number]
        else:
            label = None
            
        if machine_code or comment:
            # don't add if just a label, that will still be there for the line with a command
            result.append((line_number, label, machine_code, mc, comment))
            
        if machine_code:
            line_number += 1
    return result

##############################################################


import sys, os

if len(sys.argv) > 1:
    filename = sys.argv[1]
    splitname = re.split("\.", filename)
    outname = splitname[0] +".mc"
else:
    filename = "test1.rsc"
    outname = None

f = open(filename, mode='r')
code = f.readlines()
code_clean =[l.strip() for l in code]
f.close()

fmc = assemble(code_clean)

# Print out the result
for l in code_clean:
    print(l)
print()


def create_line(do_line_numbers, line_no, label, code, comment):
    s = ""
    if code:
        if label:
            s += ("// [{:s}:{:d}] \n".format(label, line_no)) + s
        if do_line_numbers:
            s += "{:4d} : ".format(line_no)
        s += machine_code_to_str(code) + " "
    if comment:
        s += comment
    return s
    
# Print machine code with line numbers
for line_no, label, code, mc, comment in fmc:
    s = create_line(True, line_no, label, code, comment)
    if s != "":
        print(s)

# Print machine code to a file
if outname:
    f = open(outname, mode='w')
    for line_no, label, code, mc, comment in fmc:
        s = create_line(False, line_no, label, code, comment)
        if s != "":
            print(s, file = f)
    f.close()
