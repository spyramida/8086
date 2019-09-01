
;Spyros Pappas
;1081443 
		.model small
		.stack 256
		
		.data                
welcome db 'Spyros Pappas :  - project #1',10,13,'$'
line db '-------------------------------------',10,13,'$'
message1 db 'Please enter the first number in decimal (from 00 to 99): ','$'
message2 db 10,13,'Pleae enter the second number in decimal (from 00 to 99): ','$'
result1   db 10,13,'The sum is ','$'
result2  db 10,13,'The product is ','$'
num1        dw  ?
num2        dw  ?


		.code
start:
		mov ax, @data 
		mov ds, ax
  
  	mov ah,09h
	lea dx,welcome 
	mov dx, offset welcome 
	int 21h   
	
	  	mov ah,09h
	lea dx,line 
	mov dx, offset line 
	int 21h   
	
	mov ah,09h
	lea dx,message1 
	mov dx, offset message1
	int 21h             

	
		call    getn                ; read first number
		mov num1, ax

	mov ah,09h
	lea dx,message2 
	mov dx, offset message2
	int 21h   
           
		call    getn                ; read second number
		mov num2, ax
		
	mov ah,09h
	lea dx,result1
	mov dx, offset result1 ; display result of sum 
	int 21h            

		mov ax, num1            ; ax = num1
		add ax, num2            ; ax = ax + num2
		call    putn            ; display sum
		
	mov ah,09h
	lea dx,result2
	mov dx, offset result2
	int 21h            ; display result of product

		mov ax, num1      ; ax = num1
		mul num2          ; ax = ax * num2
		call    putn      ; display product 


		
		mov ax, 4c00h
		int     21h             ; finished, back to the cmd


		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	


getn:                  


		push bx         ; save registers on stack
		push cx
		push dx

		mov  dx, 1      ; record sign, 1 for positive
		mov  bx, 0      ; initialise digit to 0
		mov  cx, 0      ; initialise number to 0

		call getc       ; read first character
		cmp  al, '-'    ; is it negative
		jne  newline    ; if not goto newline
		mov  dx, -1     ; else record sign 
	
		call getc       ; get next digit
newline:
		push dx         ; save sign on stack
		cmp  al, 13     ; (al == CR) ?
		je   fin_read   ; if yes, goto fin_read
				; otherwise
		sub  al, '0'    ; convert to digit
		mov  cl, al     ; cl = first digit 
		call getc       ; get next character

read_loop:
		cmp  al, 13     ; if (al == CR) 
		je  fin_read    ; then goto fin_read

		  sub  al, '0'  ; otherwise, convert to digit
		  mov  bl, al   ; bl = digit
		  mov  ax, 10   ; ax = 10
		  mul  cx       ; ax = cx * 10      
		  mov  cx, ax   ; cx = ax   (n = n * 10)
		  add  cx, bx   ; cx = cx + digit   (n = n + digit)
		  call getc     ; read next digit
		jmp read_loop

fin_read:
		mov  ax, cx     ; number returned in ax
		pop  dx         ; retrieve sign from stack
		cmp  dx, 1      ; ax = ax * dx
		je   fin_getn
		neg  ax         ; ax = -ax
fin_getn:
		pop  dx
		pop  cx
		pop  bx
		ret


putn:                                   ; display number in ax
		; ax contains number  
		; dx contains remainder 
		; cx contains 10 for division

	push    bx
	push    cx
	push    dx
	
	mov dx, 0                       ; dx = 0
	push dx                         ; push 0 as sentinel
	mov cx, 10                      ; cx = 10
	
	cmp ax, 0
	jge calc_digits                 ; number is negative
	neg ax                          ; ax = -ax; ax is now positive
	push  ax                        ; save ax
	mov al, '-'                     ; display - sign
	call putc
	pop ax                          ; restore ax

calc_digits:
	div cx                          ; dx:ax = ax / cx
					; ax = result, dx = remainder 
	add dx, '0'                     ; convert dx to digit
	push dx                         ; save digit on stack
	mov dx, 0                       ; dx = 0
	cmp ax, 0                       ; finished ?
	jne calc_digits                 ; no, repeat process
					; all digits now on stack, display 
					; them in reverse

disp_loop:
	pop ax                          ; get last digit from stack
	cmp ax, 0                       ; is it sentinel
	je  end_disp_loop               ; if yes, we are finished 
	call putc                       ; otherwise display digit
	jmp disp_loop
end_disp_loop:

	pop dx                          ; restore registers
	pop cx
	pop bx

	ret


putc:               ; display character in al
	push    ax  ; save ax
	push    bx  ; save bx 
	push    cx  ; save cx
	push    dx  ; save dx

	mov dl, al
	mov ah, 2h
	int 21h

	pop dx  ; restore dx
	pop cx  ; restore cx
	pop bx  ; restore bx
	pop ax  ; restore ax

	ret

getc:               ; read character into al
	push    bx  ; save bx 
	push    cx  ; save cx
	push    dx  ; save dx

	mov ah, 1h
	int 21h

	pop dx  ; restore dx
	pop cx  ; restore cx
	pop bx  ; restore bx

	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	end start
