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

READ_BIN MACRO
READZ:
    MOV AH,8
    INT 21H         ;DIAVASMA APO KEYBOARD, EPISTROFH TOU ASCII POU DIAVASTHKE SE AL 
    
    CMP AL, '0'
    JL READZ
    CMP AL, '1'
    JG READZ       
    
    PRINT AL 
     
    
    
ENDM


STACK_SEG SEGMENT STACK
DB 30 DUP(?)
STACK_SEG ENDS 

DATA SEGMENT
MSG1 DB "DECIMAL=$"
SPACE DB " $"
MSG2 DB "METRHTHS=$"
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
   
   
   MOV BL,00H       
   
   READ_BIN  ;AL EPISTREFEI 48 AN HTAN 0 H' 49 AN HTAN 1 H EISODOS
   SUB AL,48    ;ASCII SE DEC  , AL PERIEXEI TWRA 0 H' 1 ANALOGWS TI DO8HKE
   ROL AL,3
   ADD BL,AL
   
   READZ1:
    MOV AH,8
    INT 21H         ;DIAVASMA APO KEYBOARD, EPISTROFH TOU ASCII POU DIAVASTHKE SE AL 
    
    CMP AL, '0'
    JL READZ1
    CMP AL, '1'
    JG READZ1       
    
    PRINT AL 
   SUB AL,48    ;ASCII SE DEC  , AL PERIEXEI TWRA 0 H' 1 ANALOGWS TI DO8HKE
   ROL AL,2
   ADD BL,AL
   
   READZ2:
    MOV AH,8
    INT 21H         ;DIAVASMA APO KEYBOARD, EPISTROFH TOU ASCII POU DIAVASTHKE SE AL 
    
    CMP AL, '0'
    JL READZ2
    CMP AL, '1'
    JG READZ2       
    
    PRINT AL 
   SUB AL,48    ;ASCII SE DEC  , AL PERIEXEI TWRA 0 H' 1 ANALOGWS TI DO8HKE
   ROL AL,1
   ADD BL,AL   
   
   
   READZ3:
    MOV AH,8
    INT 21H         ;DIAVASMA APO KEYBOARD, EPISTROFH TOU ASCII POU DIAVASTHKE SE AL 
    
    CMP AL, '0'
    JL READZ3
    CMP AL, '1'
    JG READZ3       
    
    PRINT AL 
   SUB AL,48    ;ASCII SE DEC  , AL PERIEXEI TWRA 0 H' 1 ANALOGWS TI DO8HKE
   ADD BL,AL
   
   ;O BL PERIEXEI TON BINARY POU DO8HKE P.X. 0000 1011 AN DO8HKE 1011
   ;EDW PREPEI NA DIAVASEI "A" 'H "E"
   READ_UNTIL_A_OR_E:
   MOV AH,8
   INT 21H      ;DIABASMA "A" 'H "E"
   
   CMP AL,'A'
   JE ADD1
   CMP AL,'E'
   JE SUB1
   
   JMP READ_UNTIL_A_OR_E
   
   ADD1:
   ADD BL,1
   JMP CONTINUE                    
   
   SUB1:    
   CMP BL,0
   JNZ OK
   MOV BL,0FH
   JMP CONTINUE
   OK:
   SUB BL,1
   
   CONTINUE:
    MOV BH,0    ;DECADES
   
    BIN_TO_DEC_DIGITS:  ;DECADES STON BH, MONADES STON BL
       CMP BL,10
       JL FINISH
       SUB BL,10          ;MONADES=MONADES-10
       INC BH   ;DECADES++
    JMP BIN_TO_DEC_DIGITS
   
          

   
    
    FINISH: 
    
    
    PRINT_STR NEWLINE
    PRINT_STR MSG2  
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