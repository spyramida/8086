INCLUDE macros.asm
    
ORG 100H

.STACK
    DW   128  DUP(?)       

.DATA                                
    MSG DB 0DH,0AH,"GIMME 2 NUMBERS:",'$'
    ADDITION DB 0DH,0AH,"SUM= ",'$' 
    SUBI DB 0DH,0AH,"DIFF=",'$' 
    SUBINEG DB 0DH,0AH,"DIFF=-",'$'
    NEWLINE DB 0AH, 0DH, '$'
	
.CODE
	JMP START
	
START:      
    PRINT_STR MSG
    MOV CX, 02H				; 3 �����������
DIGITS:
    CALL DEC_KEYB			; �������� ��� 3 ������
	PUSH AX				; ��� ���������� ���� ��� ������
	LOOP DIGITS       
	         
	POP AX   
	MOV BX,AX 			; ���������� ��� ������ ���� BX
	MOV BH,0        
    POP AX   
	MOV CX,AX     			; ���������� ��� �������� ���� CX
	MOV CH,0           
	POP AX 
	MOV DX,AX 				; ���������� ��� ������ ���� DX 
	MOV DH,0
	PUSH AX					; ���� ��� ������ � ������ (����� �����������)
	
	MOV AX,CX
	ADD AX,BX
	ADD AX,DX 				; ����������� ����������� ���� AX
	MOV DX,AX 				; ��� ���� ���������� ���� DX
     
	POP AX					; �������� ��� 3�� �������
	;MOV BH,0
	;MUL BL 					; ����������� ��������������� ���� AX
	;MOV CH,0
	;MUL CL
	MOV AX,DX
	SUB AX,BX
	CMP AX,BX
    JL ARNHTIKOS
	SUB AX,BX
	
	MOV CX,AX
	JMP WAIT_FOR_ENTER			; ��� ���� ���������� ���� CX
ARNHTIKOS:
    SUB BX,AX
    MOV CX,BX

WAIT_FOR_ENTER:
    READ					; ������� ��� �� ������ ��� ENTER
    CMP AL,'M'
    JE EXIT 
    SUB AL,30H
    CMP AL,221
    JE PRINTING
    JMP WAIT_FOR_ENTER     	; ��������� ��� ��� ��� ������� ENTER       
	
PRINTING:	
	PRINT_STR ADDITION      ; �������� ���������         
    CALL PRINT_HEX
    CMP CX,BX
    JE  NEGATIVE_PRINT
    PRINT_STR SUBI ; �������� ���������������  
    MOV DX,CX
    CALL PRINT_HEX 
    PRINT_STR NEWLINE		; ��� ������ �� ���������
    JMP START
TERMIN:
    RET

NEGATIVE_PRINT:
    PRINT_STR SUBINEG ; �������� ���������������  
    MOV DX,CX
    CALL PRINT_HEX 
    PRINT_STR NEWLINE		; ��� ������ �� ���������
    JMP START
TERMIN1:
    RET   	
        
 ; ������� ��� ��������� ���� ������ �� ����������� �������       
PRINT_HEX PROC
	PUSH AX				; ���������� ��� �����������
	MOV AX, DX
	PUSH DX
	MOV DX, AX
    
    PUSH CX
	MOV CX, 04H 		; �� loop �� ����������� 4 �����
HEXAL:
	SHR AX,12			; ��������� ��� bit ��� ������� (��'�� msb ��� lsb)
	AND AX,0FH
	CALL CHECK_HEX 		; ��������� � ascii ��� ���� 4 bit 
	SHL DX,4			; �������� ��� �������
	MOV AX,DX
	LOOP HEXAL
         
    POP CX
	POP DX				; ��������� ��� �����������
	POP AX
	RET	
PRINT_HEX ENDP	
	     
        
; ������� ��� ������� 4bit �������� ��� ���������� 16����
CHECK_HEX PROC 
    CMP AL,0
    JNE CONTINUE_
	RET
CONTINUE_:
    CMP AL,9
	JLE ADR1
	ADD AL,37H				; �� ����� �-F
	JMP ADR2
ADR1:
	ADD AL,'0'				; �� ����� 0-9
ADR2:        
	PRINT AL    
	RET
CHECK_HEX ENDP        
        
        
DEC_KEYB PROC
READSTART: READ
	CMP AL,'M'				; �� ������� �� �, ������������
	JE EXIT
	CMP AL,30H
	JL READSTART 			; ������� ������� ��� 0-F
	CMP AL,39H
	JG READSTART 
	PRINT AL				; �������� ��� ������ ��� ���������� ���� �����
	CMP AL,'9' 				; �� ����� �-F
	JG NEXT2
	MOV AH,0
	SUB AX,30H				; ��������� ��� ASCII ��������� �� ����������� �����
	RET          
NEXT2:    					; �� ����� 0-9
    MOV AH,0
	SUB AX,'A'				; ��������� ��� ASCII ��������� �� ����������� �����
	ADD AX,10
    RET
EXIT: EXIT
DEC_KEYB ENDP
	         