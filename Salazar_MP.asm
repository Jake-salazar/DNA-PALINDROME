; Salazar ,Jacob Israel
; x86 Machine Project
%include "io.inc"
; check null
; check the length
; check the dot
; check the letters
section .data
OGstring times 13 db 0x00 ; Holds the string inputed by user
var1 times 13 db 0x00     ; holds the string without " . "
var3 times 13 db 0x00     ; holds the string complemented
var4 times 13 db 0x00
KOUNT dd 0x00000000
        ; 0x41 = A
        ; 0x54 = T
        ; 0X43 = C
        ; 0x47 = G
section .text
global CMAIN
CMAIN:
    ;write your code here
    mov eax, 0x00000000
    mov esi, 0x00000000
    GET_STRING var1, 13

    cmp byte[var1],0x00
    JE ErrorNull

getLength:    ; checks the length until dot
    cmp byte[var1 + esi],0x00
    JE checkLength
    mov cl, [var1+esi]
    mov byte[OGstring+esi], cl
    inc al
    inc esi
    JMP getLength
 
checkLength: mov [KOUNT],al
             cmp byte[KOUNT],11
             JG ErrorLength
             
mov esi, 0x00
mov bl, 0x00
checkValid: cmp eax,0
            JE PcheckTerminator
            cmp byte[var1+esi],0x41
            JE setbit
            cmp byte[var1+esi],0x54
            JE setbit
            cmp byte[var1+esi],0x43
            JE setbit
            cmp byte[var1+esi],0x47
            JE setbit
            cmp byte[var1+esi],0x2E
            JE setbit
return:     
            cmp ebx, 0x00000000
            JE ErrorInvalid
            mov ebx, 0x00000000
            dec eax
            inc esi
            
            JMP checkValid   
            
setbit: mov bl,0x01
        JMP return     
             
PcheckTerminator:
                 mov esi, [KOUNT] 
checkTerminator: cmp byte[var1+esi-1], 0x2E
                 JNE ErrorTerminator
                 mov byte [var1+esi-1],0x00
                 dec esi
                 mov [KOUNT],esi
    

mov edi, esi
mov esi, 0x00000000
FirstComplement: 
               cmp esi,edi
               JE Preverse
               cmp byte[var1+esi],0x41
               JE compA
               cmp byte[var1+esi],0x54
               JE compT
               cmp byte[var1+esi],0x43
               JE compC
               cmp byte[var1+esi],0x47
               JE compG
return2:      
               inc esi
               JMP FirstComplement
               
compT: mov byte[var3+ebx], 0x41
       inc ebx
       JMP return2                     
compA: mov byte[var3+ebx], 0x54
       inc ebx
       JMP return2
compG: mov byte[var3+ebx], 0x43
       inc ebx
       JMP return2

compC: mov byte[var3+ebx], 0x47
       inc ebx
       JMP return2
       
       
Preverse: 
          dec edi
          mov esi, 0x0000
          
Reverse:  cmp byte[var3+edi], 0x00
          JE cont
          mov al, [var3+edi]
          mov byte [var4+esi],al
          inc esi
          dec edi
          JMP Reverse                 
               
cont: ;PRINT_STRING "Inputed: "
      ;PRINT_STRING var1
      ;NEWLINE
      ;PRINT_STRING "Reversed:"
      ;PRINT_STRING var3
      ;NEWLINE
      mov esi, 0x00000000
      mov ebx, 0x00000000
      mov eax,[KOUNT]
      mov bl, [var4+esi]
      PRINT_STRING "Reversed Compliment: " 
      PRINT_STRING var4 
      NEWLINE
      NEWLINE
      PRINT_STRING "Reverse palindrome? "     
      jmp FinalCheck
     
FinalCheck: cmp eax, 0
            JE check
            cmp byte[var1+esi],bl
            JNE NotPanlimdrome
            inc esi
            mov bl, [var4+esi]
            dec eax
            jmp FinalCheck
check:          
            PRINT_STRING "YES"
            jmp end
              
NotPanlimdrome: PRINT_STRING "NO" 
                jmp end
   
         
ErrorNull: PRINT_STRING "Error: null input"
           jmp end

ErrorTerminator: PRINT_STRING "Error: Invalid Input or No terminator"
                 jmp end

ErrorInvalid: PRINT_STRING "Error: Invalid Input"
              jmp end    


      
ErrorLength:PRINT_STRING "Error: Beyond maximum length" 
            jmp end  
    
    
    
end: 
    xor eax, eax
    ret