INCLUDE macros.asm
    
ORG 100H

.STACK
    DW   128  DUP(?)       

.DATA                                
    MSG DB 0DH,0AH,"GIVE THE NUMBERS: ",'$'
    SPACE DB " ",'$'
    ADDITION DB 0DH,0AH,"A=",'$' 
    MULTIPLICATION DB 0DH,0AH,"M=",'$'
    NEWLINE DB 0AH, 0DH, '$'
	
.CODE
	JMP START
	
START:      
    PRINT_STR MSG
    MOV CX, 05H				; 3 reps
DIGITS:
    CALL HEX_KEYB			; Read 3 digits
	PUSH AX					; add to stack
	LOOP DIGITS       
	         
	POP AX   
	MOV BX,AX 				; Put 1st in BX
	MOV BH,0      
	POP AX
    POP AX   
	MOV CX,AX     			; Put 2nd in CX
	MOV CH,0 
	POP AX	
	POP AX 
	MOV DX,AX 				; Put 3rd in DX
	MOV DH,0
	PUSH AX					; 3rd in stack
	
	MOV AX,CX
	ADD AX,BX
	ADD AX,DX 				; Calc sum at AX
	MOV DX,AX 				; put it in DX
     
	POP AX					; Take 3rd numb
	MOV BH,0				; 
	MUL BL 					; Mult in AX
	MOV CH,0				; 
	MUL CL
	MOV CX,AX				; Put in CX

WAIT_FOR_ENTER:
    READ					; wait to press ENTER
    CMP AL,'m'
    JE EXIT 
    SUB AL,30H
    CMP AL,221
    JE PRINTING
    JMP WAIT_FOR_ENTER     	; Loop till ENTER pressed
	
PRINTING:	
	PRINT_STR ADDITION      ; Print sum         
    CALL PRINT_HEX
    PRINT_STR MULTIPLICATION ; Print mul
    MOV DX,CX
    CALL PRINT_HEX 
    PRINT_STR NEWLINE		; New line and loop
    JMP START
TERMIN:
    RET   	
        
 ; Print a hex num
PRINT_HEX PROC
	PUSH AX				; Push registers
	MOV AX, DX
	PUSH DX
	MOV DX, AX
    
    PUSH CX
	MOV CX, 04H 		; 4times loop
HEXAL:
	SHR AX,12			; Take each bit separately from msb to lsb
	AND AX,0FH
	CALL CHECK_HEX 		; ascii for these 4 bits
	SHL DX,4			; Swap left
	MOV AX,DX
	LOOP HEXAL
         
    POP CX
	POP DX				; Popo registers
	POP AX
	RET
PRINT_HEX ENDP	
	     
        
; Print 4-bits binary in 16bit
CHECK_HEX PROC
	CMP AL,9
	JLE ADR1
	ADD AL,37H				; if Á-F
	JMP ADR2
ADR1:
	ADD AL,'0'				; if 0-9
ADR2:        
	PRINT AL    
	RET
CHECK_HEX ENDP        
        
        
HEX_KEYB PROC
READSTART:
    CMP CX,02H
    JE SPACE1
	CMP CX,04H
    JE SPACE1
    READ
	CMP AL,'M'				; If T pressed, end
	JE EXIT
	CMP AL,'0'				; IF AL<0
	JL READSTART 			; numbers 0-F
	CMP AL,'F'				; IF AL>F
	JG READSTART 
	PRINT AL				; Show digit on screen
	CMP AL,'9' 				; if Á-F
	JG NEXT2
	MOV AH,0
	SUB AX,'0'				; Convert from ASCII to 16bit digit
	RET          
NEXT2:    					; if 0-9
    MOV AH,0
	SUB AX,'A'				; Convert from ASCII to 16bit digit
	ADD AX,10
    RET
SPACE1:
    PRINT_STR SPACE
    RET
EXIT: EXIT
HEX_KEYB ENDP
	         