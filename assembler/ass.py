# My RISC simple assembler
# Creates machine code from My RISC assembler


# Assemble a My RISC machine code file
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
#


import re


# Check for leading negative sign - no need to check for plus sign as that is removed as whitespace
def is_int(s):
    return s.isnumeric() or (s[0] == "-" and s[1:].isnumeric())

        
def tokenise(txt) :
    # remove () and [] that might surround an integer
    txt = txt.replace("[", " ")
    txt = txt.replace("]","")
    txt = txt.replace("(", " ")
    txt = txt.replace(")","")
    txt = txt.lower()

    # process comments
    comment = ""
    comment_location = txt.find("//")
    if comment_location != -1:
        comment = "//" + txt[comment_location + 2:]
        txt = txt[:comment_location].strip()

    # remove anything after a left brace { (to allow for auto-label comments added)
    brace_location = comment.find("{")
    if brace_location > -1:
        comment = comment[:brace_location].strip()
        if comment == "//":
            comment = ""
    
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
            if c[0] == "#":
                # ignore line numbers
                pass
            elif c[-1] == ":":
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
        code = ""
        
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
                code = f"0000_{regB:03b}_{regA:03b}_{value:06b}"
            elif cmd == "st":
                code = f"0001_{regB:03b}_{regA:03b}_{value:06b}"
            elif cmd == "beq":
                code = f"1011_{regA:03b}_{regB:03b}_{value:06b}"
            elif cmd == "bne":
                code = f"1100_{regA:03b}_{regB:03b}_{value:06b}"
            elif cmd == "jmp":		
                code = f"1101_{value:012b}"
            elif cmd == "inv":		
                code = f"0100_{regB:03b}_000_{regA:03b}_000"
            elif cmd == "lui":		
                code = f"1110_{regA:03b}_0_{value:08b}"
            elif cmd == "lli":		
                code = f"1111_{regA:03b}_0_{value:08b}"
            elif cmd in arith_cmds:		
                code = f"{arith_cmds[cmd]:04b}_{regB:03b}_{regC:03b}_{regA:03b}_000"
                
        result.append((line_number, label, code, comment))
        if code:
            line_number += 1
            
    return result

##############################################################


import sys, os
do_line_numbers = False
filename = ""

if len(sys.argv) == 3:
    filename = sys.argv[2]
    if sys.argv[1] == "-lineno":
        do_line_numbers = True
elif len(sys.argv) == 2:
    filename = sys.argv[1]


if filename != "":
    splitname = re.split("\.", filename)
    outname = splitname[0] +".mc"
else:
    filename = "test4.rscin"
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

    
# Print machine code with line numbers
for line_no, label, code, comment in fmc:
    # if a label, put on a line by itself without a line number
    if label:
        print(f"// [{label:s}:{line_no:d}]")
    # if just a comment, print without a line number
    if comment and not code:    
        print(f"         {comment:s}")
    # if code (with optional comment) print with a line number
    if code:
        if do_line_numbers:
            print(f"#{line_no:<4d}    {code:22s} {comment:s}")
        else:
            print(f"         {code:22s} {comment:s}")

# Print machine code to a file
if outname:
    f = open(outname, mode='w')
    for line_no, label, code, comment in fmc:
        if label:
            print(f"// [{label:s}:{line_no:d}]", file = f)
        if comment and not code:    
            print(f"         {comment:s}", file = f)
        if code:
            if do_line_numbers:
                print(f"#{line_no:<4d}    {code:22s} {comment:s}", file = f)
            else:
                print(f"         {code:22s} {comment:s}", file = f)
    f.close()
