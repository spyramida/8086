.MODEL small
.STACK 100 
.DATA    
 num1 db 0 
 num2 db 0
 msg1 db "please enter the first num(in decimal)",'$'
 msg2 db "please enter the second num(in decimal)",'$' 
 msg3 db "The result of addition =",'$'
 msg4 db "The result of multiplication =",'$'  
 msg db 10,13,'$'
.CODE 
MOV AX,@DATA 
MOV DS,AX 


mov dx,offset msg1
mov ah,9
int 21h
mov dx,offset msg
mov ah,9
int 21h

call enter2digit
mov [num1],cl   
mov dx,offset msg
mov ah,9
int 21h

mov dx,offset msg2
mov ah,9
int 21h
mov dx,offset msg
mov ah,9
int 21h

call enter2digit
mov [num2],cl
mov dx,offset msg
mov ah,9
int 21h


mov dx,offset msg3
mov ah,9
int 21h

mov al,[num1]
add al,[num2] 
mov ah,0
mov dx ,0
call dis4digit 
mov dx,offset msg
mov ah,9
int 21h

mov dx,offset msg4
mov ah,9
int 21h

                
mov al,[num1]
mov cl,[num2] 
mul cl 
mov dx ,0
call dis4digit                


mov ah,4ch
int 21h



 
dis4digit proc 
            
mov cx,1000
div cx
mov cx,dx
mov dl,al
add dl,030h
Mov Ah,2
INT 21h 
mov ax,cx 
mov cl,100
div cl
mov ch,ah
mov dl,al
add dl,030h
Mov Ah,2
INT 21h
mov al,ch
mov ah,0 
mov cl,10
div cl
mov ch,ah
mov dl,al
add dl,030h
Mov Ah,2
INT 21h
mov dl,ch
add dl,030h
Mov Ah,2
INT 21h   
ret
dis4digit endp
                                              
                
enter2digit proc 
            
mov ah,1
int 21h
sub al,48
mov cl,10
mul cl
mov cx,ax
mov ah,1
int 21h
sub al,48
mov ah,0
add cx,ax  
ret

enter2digit endp
  
end
