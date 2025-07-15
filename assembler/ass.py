# My RISC simple assembler
# Creates machine code from My RISC

import re


# Check for leading negative sign - no need to check for plus sign as that is removed as whitespace
def is_int(s):
    return s.isnumeric() or (s[0] == "-" and s[1:].isnumeric())

# pretty print the machine code binary, add a line number if not None
def show_machine_code(line_no, val):
    v1 = (val & 0b1111_000_000_000_000) >> 12
    v2 = (val & 0b0000_111_000_000_000) >> 9
    v3 = (val & 0b0000_000_111_000_000) >> 6
    v4 = (val & 0b0000_000_000_111_000) >> 3
    v5 = (val & 0b0000_000_000_000_111)
    if line_no != None:
        print("{:4d} : ".format(line_no), end="") 
    print("{:04b}_{:03b}_{:03b}_{:03b}_{:03b}".format(v1, v2, v3, v4, v5))
          
def tokenise(txt) :	
    txt = txt.replace("[", " ")
    txt = txt.replace("]","")
    txt = txt.replace("(", " ")
    txt = txt.replace(")","")
    txt = txt.lower()

    comment_location = txt.find("#")
    if comment_location != -1:
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
          
    return label, cmd, regA, regB, regC, value, jmp_label

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
    full_machine_code = []
    labels = {}
    arith_cmds = {"add": 2, "sub": 3, "lsl": 5,
                  "lsr": 6, "and": 7, "or" : 8,
                  "slt": 9}
    
    # Pass 1 - for labels
    line_number = 0
    for line in code:
        (label, cmd, regA, regB, regC, value, jmp_label) = tokenise(line)
        if label:
            labels[label] = line_number
        if cmd:
            line_number += 1

    # Pass 2 - assembly
    line_number = 0
    for line in code:
        (label, cmd, regA, regB, regC, value, jmp_label) = tokenise(line)
        #print(">>", label, cmd, regA, regB, regC, value, jmp_label)
        machine_code = 0
    
        # Calculate a jump offset
        if jmp_label:
            if cmd == "jmp":
                value = labels[jmp_label]
            else:           # only do this if we are bne or beq
                value = labels[jmp_label] - (line_number + 1)

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
            elif cmd == "st":
                machine_code = 0b0001 << 12
                machine_code |= regB << 9
                machine_code |= regA << 6
                machine_code |= value & 0b111111 # 6 bits
            elif cmd == "beq":
                machine_code = 0b1011 << 12
                machine_code |= regA << 9
                machine_code |= regB << 6
                machine_code |= value & 0b111111 # 6 bits
            elif cmd == "bne":
                machine_code = 0b1100 << 12	
                machine_code |= regA << 9	
                machine_code |= regB << 6	
                machine_code |= value & 0b111111 # 6 bits
            elif cmd == "jmp":		
                machine_code = 0b1101 << 12
                machine_code |= value & 0b111111111111 # 12 bits
            elif cmd == "inv":		
                machine_code = 0b0100 << 12
                machine_code |= regA << 3	
                machine_code |= regB << 9
            elif cmd == "lui":		
                machine_code = 0b1110 << 12
                machine_code |= regA << 9	
                machine_code |= value
            elif cmd == "lli":		
                machine_code = 0b1111 << 12
                machine_code |= regA << 9	
                machine_code |= value
            elif cmd in arith_cmds:		
                machine_code = arith_cmds[cmd] << 12
                machine_code |= regB << 9	
                machine_code |= regC << 6	
                machine_code |= regA << 3

            line_number += 1
            full_machine_code.append(machine_code)

    return full_machine_code

##############################################################


import sys, os

if len(sys.argv) > 1:
    filename = sys.argv[1]
    splitname = re.split("\.", filename)
    outname = splitname[0] +".mc"
else:
    filename = "test1.txt"
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

line_no = 0
for v in fmc:
    show_machine_code(line_no, v)
    line_no += 1

if outname:
    f = open(outname, mode='w')
    for v in fmc:
        print("{:016b}".format(v), file=f)
    f.close()

##############################################################

"""

code2 = ("# Comment line",                
         "",                              
         "start:",                        # =0
         "ld  r1, r2[5] # comment",       #0
         "st  r3, r5[3] # this is",       #1
         "add r4, r2, r1 # a ",           #2
         "interim:",                      # =3
         "sub r7, r3, r0 # comment",      #3
         "lsl r6, r4, r1 ",               #4
         "lsr r5, r5, r2",                #5
         "slt r4, r6, r3",                #6
         "and r3, r7, r4",                #7
         "or  r2, r5, r6",                #8
         "inv r1, r2",                    #9
         "beq r1, r2, start",             #10
         "bne r1, r2, end",               #11
         "jmp interim",                   #12
         "end:"                           # =13
         )
         
code = ("# Comment line",
        "first_label:",
        "label: LD r1, r2, r3[-1]",
        "lab_me:\n\tLD r1, r2, (r3+-1) # weird to have +- but it has to be that way",
        "ADD r1, r2, r3",	
        "INV r1, r2, r3",	
        "BNE r1, r0, -1",	
        "lab2: LD r1, r2, r3[31]",
        "lab3: jmp lab3",	
        "lab4: jmp 20",	
	"BNE r1, r2, label",
        "BNE r1, r2, +5"
       )	

code = ("# Comment line",                
        "",                              
        "start:",                        # =0
        "ld  r1, r2[5] # comment",       #0
        "st  r3, r5[3] # this is",       #1
        "add r4, r2, r1 # a ",           #2
        "interim:",                      # =3
        "sub r7, r3, r0 # comment",      #3
        "lsl r6, r4, r1 ",               #4
        "lsr r5, r5, r2",                #5
        "slt r4, r6, r3",                #6
        "and r3, r7, r4",                #7
        "or  r2, r5, r6",                #8
        "inv r1, r2",                    #9
        "beq r1, r2, start",             #10
        "bne r1, r2, end",               #11
        "jmp interim",                   #12
        "end:"                           # =13
        )


for val in range (-32, 32):
    if val < 0:
        new_val = 64 + val
    else:
        new_val = val
    print ("{:4d} {:08b}". format(val, new_val))
"""
