; How to access virtual ports (0 to 65535).


#start=led_display.exe#


#make_bin#

name "led"

mov ax, 1234
out 199, ax

mov ax, -5678
out 199, ax

; Eternal loop to write
; values to port:
mov ax, 0
x1:
  out 199, ax  
  inc ax
jmp x1

hlt


