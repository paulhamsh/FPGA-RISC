// comment line
start:
another_label:
another:
// with comment
          ld  r0, r2(0)            
          ld  r1, r2(1)            
jump_point:
here:
          add r2, r0, r1           
          jmp here                 
          st  r2, r1(0)            
          sub r2, r0, r1           
          inv r2, r0               
          lsl r2, r0, r1           
          lsr r2, r0, r1           
          and r2, r0, r1           
          or  r2, r0, r1           
          slt r2, r0, r1           
          add r0, r0, r0           
          beq r0, r2, 1            // {jump 15}
          bne r0, r2, 0            // {jump 15}
          jmp another              
cont:
          ld  r1, r2(5)            // comment
          st  r3, r5(3)            // this is
          add r4, r2, r1           // a
interim:
          sub r7, r3, r0           // comment
          lsl r6, r4, r1           
          lsr r5, r5, r2           
          slt r4, r6, r3           
          and r3, r7, r4           
          or  r2, r5, r6           
          inv r1, r2               
          beq r1, r2, another      
          bne r1, r2, end          
          jmp interim              
end:
          jmp end                  
          jmp 1                    
