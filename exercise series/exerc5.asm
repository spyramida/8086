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

READ_DEC MACRO
READZ:
    MOV AH,8
    INT 21H
    CMP AL, 'D'
    JE QUIT
    CMP AL, '0'
    JL READZ
    CMP AL, '9'
    JG READZ
    PUSH AX
    PRINT AL 
ENDM


STACK_SEG SEGMENT STACK
DB 30 DUP(?)
STACK_SEG ENDS 

DATA SEGMENT
MSG1 DB "Give 4 numbers: $"
SPACE DB " $"
MAXMIN DB "MIN MAX:=$"
NEWLINE DB 0AH, 0DH, "$"
DATA ENDS  

CODE SEGMENT 
    ASSUME CS:CODE,SS:STACK_SEG,DS:DATA
    
MAIN PROC FAR
    MOV AX,DATA
    MOV DS, AX 
    START:
          PRINT_STR MSG1
          MOV CX,4
    LOUPARE:
          READ_DEC
          LOOP LOUPARE
    PRINT_STR NEWLINE 
    
    
    ;EKTYPWSH KAI YPOLOGISMOS MAX, MIN
    PRINT_STR MAXMIN
    
    POP DX      ;PARE TON ARI8MO POY PLHKTROLOGHSE 4o PISW APO TH STOIVA
                ;KAI 8ESE TON ARXIKA WS MIN KAI MAX
                ;EN SYNEXEIA ME SYGKRISEIS ME TOYS ALLOYS 8A VRE8EI MIN/MAX   
    MOV AL,DL   ;AL=min
    MOV AH,DL   ;AH=max
    
    MOV CX,3    ;3 FORES EPANALHPSH H LOOPA
    LOOPA:       
        POP DX  ;GET NEXT SAVED NUMBER
        CMP AH,DL  ;COMPARE CURRENT MAX(AH) WITH THE NUMBER
        JGE MAX_NOT_CHANGED
        
        ;MAX HAVE TO CHANGE, DL>AH
        MOV AH,DL   ;NEW MAX
        
        MAX_NOT_CHANGED:
        
        CMP AL,DL   ;COMPARE CURRENT MIN(AL) WITH THE NUMBER
        JLE MIN_NOT_CHANGED
        
        ;MIN HAS TO CHANGE AL>DL
        MOV AL,DL  
        
        MIN_NOT_CHANGED:
        
    LOOP LOOPA
    
    ;NOW AH CONTAINS MAX, AL CONTAINS MIN
    PRINT AL    ;MIN PRINT 
    PRINT ' '
    PRINT AH    ;MAX PRINT    
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