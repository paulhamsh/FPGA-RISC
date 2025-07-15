# line  0
ld  r0, r2(0)
ld  r1, r2(1)
add r2, r0, r1
st  r2, r1(0)
sub r2, r0, r1
inv r2, r0
lsl r2, r0, r1
lsr r2, r0, r1
and r2, r0, r1
or  r2, r0, r1
slt r2, r0, r1
add r0, r0, r0
beq r0, r2, 1         # 14
bne r0, r2, 0         # 14
# line  14
jmp 0
ld  r1, r2(5)
st  r3, r5(3)
add r4, r2, r1
# line  18
sub r7, r3, r0
lsl r6, r4, r1
lsr r5, r5, r2
slt r4, r6, r3
and r3, r7, r4
or  r2, r5, r6
inv r1, r2
beq r1, r2, -26       # 0
bne r1, r2, 1         # 28
jmp 18
# line  28
lui r1, 85      
lli r2, 170     
