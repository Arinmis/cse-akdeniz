TITLE   8086 Code Template (for EXE file)

;       AUTHOR          emu8086
;       DATE            ?
;       VERSION         1.00
;       FILE            ?.ASM

; 8086 Code Template

; Directive to make EXE output:
       #MAKE_EXE#

DSEG    SEGMENT 'DATA'

Dots    DB 01111111b, 00000110b, 00001100b, 00000110b, 01111111b  ; M 
	    DB 01111111b, 01000000b, 01000000b, 01000000b, 01111111b  ; U  
        DB 01001111b, 01001001b, 01001001b, 01001001b, 01111001b  ; S 
	    DB 00000001b, 00000001b, 01111111b, 00000001b, 00000001b  ; T
	    DB 01111111b, 00001001b, 00001001b, 00001001b, 01111111b  ; A
	    DB 01111111b, 00001001b, 00001001b, 00001001b, 00001001b  ; F
	    DB 01111111b, 00001001b, 00001001b, 00001001b, 01111111b  ; A
	    DB 00000000b, 00000000b, 00000000b, 00000000b, 00000000b  ; white space



DSEG    ENDS

SSEG    SEGMENT STACK   'STACK'
        DW      100h    DUP(?)
SSEG    ENDS

CSEG    SEGMENT 'CODE'

;*******************************************

START   PROC    FAR

; Store return address to OS:
    PUSH    DS
    MOV     AX, 0
    PUSH    AX

; set segment registers:
	MOV AX, DSEG
    MOV DS, AX
    MOV ES, AX


	MOV DX,2000h	; first DOT MATRIX digit
	MOV BX, 0

INFINITELOOP:

    MAINLOOP:
	    MOV SI, 0
	    MOV CX, 5

        NEXT: 
            MOV AL, 0
            OUT DX, AL; clear screen
	        MOV AL,Dots[BX][SI]
	        OUT DX,AL
	        INC SI
	        INC DX

	        CMP SI, 5
	        LOOPNE NEXT

	 ADD BX, 5
	 CMP BX, 40
	 JL MAINLOOP    
	
	; shift array elements to the right
    MOV CX, 5
    MOV BX, 0
    SHIFTLOOP:
	    MOV SI, 0h
        ; backup first element 
        MOV DL, Dots[SI][BX]  
        INC SI
        NEXT1: 
	        MOV AL,Dots[SI][BX]
	        INC SI
	        MOV Dots[SI][BX], AL
	    CMP SI, 7
	    JNE NEXT1
        ; assign first element to last 
        MOV Dots[SI][BX], DL
        INC BX
	 LOOP SHIFTLOOP

    ;MOV CX , 003FH   
    MOV CX, 1
    WAIT: LOOP WAIT ; to delay

JMP INFINITELOOP

; return to operating system:
    RET
START   ENDP

;*******************************************

CSEG    ENDS 

        END    START    ; set entry point.

