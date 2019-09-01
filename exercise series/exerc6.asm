PRINT MACRO CHAR
PUSH AX
PUSH DX
MOV DL,CHAR
MOV AH,2
INT 21H
POP DX
POP AX
ENDM

READ MACRO  
PUSH AX
MOV AH,8
INT 21H
POP AX
ENDM    

PRINT_STR MACRO STR
PUSH AX
PUSH DX
MOV DX,OFFSET STR
MOV AH,9
INT 21H 
POP DX
POP AX
ENDM  

READ_DEC_AND_CONVERT_ASCII_TO_DEC_AND_STORE_IN_STACK MACRO
READZ:
    MOV AH,8
    INT 21H         ;DIAVASMA APO KEYBOARD, EPISTROFH TOU ASCII POU DIAVASTHKE SE AL 
    
    CMP AL, '0'
    JL READZ
    CMP AL, '9'
    JG READZ       
    
    PRINT AL 
    
    SUB AL,48   ;AFAIRESH 48 KANEI TON ASCII ENOS DEKADIKOY {0,9} SE DEC
    PUSH AX   
    
    
ENDM


STACK_SEG SEGMENT STACK
DB 30 DUP(?)
STACK_SEG ENDS 

DATA SEGMENT
MSG1 DB "DWSE 5 ARITHMOUS: $"
SPACE DB " $"
MSG2 DB "DIAFORA:$"
MINUS DB "-$"
NEWLINE DB 0AH, 0DH, "$"
DATA ENDS  

CODE SEGMENT 
    ASSUME CS:CODE,SS:STACK_SEG,DS:DATA
    
MAIN PROC FAR
    MOV AX,DATA
    MOV DS, AX 
    START:
          PRINT_STR MSG1  
          MOV BL,0  ;A8ROISMA PERITTWN
          MOV BH,0  ;A8ROISMA ARTIWN
          MOV CX,5
    LOUPARE:
          READ_DEC_AND_CONVERT_ASCII_TO_DEC_AND_STORE_IN_STACK   
         
          ROR AX,1
          JNC ARTIOS
          
          ;PERITTOS CASE 
          ROL AX,1
          ADD BL,AL
          JMP CONT
          
          ARTIOS: 
          ROL AX,1
          ADD BH,AL
          
          CONT:          
          
          LOOP LOUPARE  
          
    PRINT_STR NEWLINE
    
    PRINT_STR MSG2  ;DIAFORA
    CMP BH,BL
    JL NEGATIVE_DIFFERENCE
    
    ;POSITIVE DIFFERENCE
        SUB BH,BL   ;BH=BH-BL
        JMP CONT2
    
    NEGATIVE_DIFFERENCE:
        PRINT_STR MINUS
        SUB BL,BH
        MOV BH,BL      
          
    CONT2:  ;BH PERIEXEI TO APOTELESMA  
    MOV BL,BH  
    MOV BH,0    ;DECADES
   
    BIN_TO_DEC_DIGITS:  ;DECADES STON BH, MONADES STON BL
       CMP BL,10
       JL FINISH
       SUB BL,10          ;MONADES=MONADES-10
       INC BH   ;DECADES++
    JMP BIN_TO_DEC_DIGITS
    
    FINISH:
    
    CMP BH,0
    JE SKIP_PRINTING_OF_DECADES
    
    ADD BH,48
    PRINT BH
    
    
    SKIP_PRINTING_OF_DECADES:
    ADD BL,48
    PRINT BL
        
    
    PRINT_STR NEWLINE
    
    
    JMP START
    
     QUIT:
            MOV AH,4CH
            INT 21H
          
        
MAIN ENDP

	PRINT_DEC PROC NEAR	 ;typwnei se dekadiko oti uparxei ston BL se bin
		MOV CX,0
		MOV AX,BX
	DA: MOV DX,0
		MOV BX,10
		DIV BX
		PUSH DX
		INC CX
		CMP AX,0
		JNZ DA
	DA2: POP DX
		ADD DX,30H
		PRINT DL
		LOOP DA2
		RET
	PRINT_DEC ENDP

CODE ENDS
END MAIN