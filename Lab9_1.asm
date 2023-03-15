        segment     .data
a       dq          1
b       dq          1
c       dq          1
print_f:dd          "(%ld, %ld, %ld)", 0x0a, 0  ; String format 
                
        segment     .text
        global      main                        ; Establish main
        global      check_pyth                  ; Establish check_pyth
        extern      printf                      ; Import printf
        
main:
        push        rbp                         ; Establish stack frame
        mov         rbp, rsp                    ; Back up the stack into rsp
        frame       0, 0, 3                     ; Frame macro: 
        sub         rsp, frame_size             ; Create space in the stack       
        
for_C:
        cmp         qword [c], 500              ; While c < 500
        jge         end_for_C                   ; When c is 500, jump to end of C
        mov         rcx, [a]                    ; Parameter 1 for check_pyth
        mov         rdx, [b]                    ; Parameter 2 for check_pyth
        mov         r8, [c]                     ; Parameter 3 for check_pyth  
        call        check_pyth                  ; Call the check for pythagorean function
        inc         qword [c]                   ; Increment the c variable
        jmp         for_C                       ; Jump to the top of the for loop

for_B:
        cmp         qword [b], 500              ; While b < 500
        jge         end_for_B                   ; When b is 500, jump to end of B 
        inc         qword [b]                   ; Increment the b variable   
        jmp         for_C                       ; Jump to the inner c for loop with new b value
                                      
for_A:
        cmp         qword [a], 500              ; While a < 500
        jge         end_for_A                   ; When a is 500, jump to end of A
        inc         qword [a]                   ; Increment the a variable
        jmp         for_C                       ; Jump to the inner c for loop with new a value
          
end_for_C:
        mov         qword [c], 1                ; Reset the value of C
        jmp         for_B                       ; Jump to the outer b loop
        
end_for_B:
        mov         qword [b], 1                ; Reset the value of B
        jmp         for_A                       ; Jump to the outer a loop
        
end_for_A:        
        leave                                   ; End of the program
        ret 
        
check_pyth:
la      equ         local1                      ; Create a local variable with the a variable
lb      equ         local2                      ; Create a local variable with the b variable
lc      equ         local3                      ; Create a local variable with the c variable
        
        push        rbp                         ; Establish stack frame
        mov         rbp, rsp                    ; Back up the stack into rsp
        frame       3, 3, 4                     ; Frame macro: 3 parameters are passed to the function, 3 local variables are created, functions inside this function use at most 4 parameters
        sub         rsp, frame_size
        
        mov         [rbp+la], rcx               ; Move the value of parameter 1 into la
        mov         [rbp+lb], rdx               ; Move the value of parameter 2 into lb
        mov         [rbp+lc], r8                ; Move the value of parameter 3 into lc
        
        imul        rcx, rcx                    ; Multiply the value in rcx by itself
        imul        rdx, rdx                    ; Multiply the value in rdx by itself
        imul        r8, r8                      ; Multiply the value in r8 by itself
        add         rcx, rdx                    ; Add rcx and rdx (a^2 + b^2)
        
        cmp         rcx, r8                     ; Check if a^2 + b^2 = c^2
        je          print                       ; If equal, jump to print out the values
        
        xor         eax, eax                    ; Clear the return value
        leave                                   ; End of the function
        ret
 
print:  
        lea         rcx, [print_f]              ; Parameter 1 is the print format
        mov         rdx, [rbp+la]               ; Parameter 2 is a
        mov         r8, [rbp+lb]                ; Parameter 3 is b
        mov         r9, [rbp+lc]                ; Parameter 4 is c
        call        printf                      ; Call the print function
        
        leave                                   ; End of printing
        ret
