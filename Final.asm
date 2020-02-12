include macros2.asm
include number.asm

.MODEL LARGE
.STACK 200h
.386
.387

MAXTEXTSIZE equ 50

.DATA

___IGUALES_RETURN                   DD (?)
_@aux7                              DD (?)
_@aux6                              DD (?)
_@aux5                              DD (?)
_@aux4                              DD (?)
_@aux3                              DD (?)
_@aux2                              DD (?)
_@aux1                              DD (?)
_@aux0                              DD (?)
_4                                  DD 4         
_2                                  DD 2         
_12                                 DD 12        
_1                                  DD 1         

.CODE

START:
MOV AX, @DATA
MOV DS,AX
FINIT
FFREE

fild _0
fistp ___IGUALES_RETURN
fild _2
fild _b
fmul
fistp _@aux0
fild _@aux0
fild _1
fadd
fistp _@aux1
fild _@aux1
fild _a
fxch
fcom
fstsw ax
sahf
JE COMPARACION_23
fild ___IGUALES_RETURN
fild _1
fadd
fistp _@aux2
fild _@aux2
fistp ___IGUALES_RETURN
COMPARACION_23:
fild _4
fild _c
fmul
fistp _@aux3
fild _@aux3
fild _a
fxch
fcom
fstsw ax
sahf
JE COMPARACION_31
fild ___IGUALES_RETURN
fild _1
fadd
fistp _@aux4
fild _@aux4
fistp ___IGUALES_RETURN
COMPARACION_31:
fild _12
fild _a
fxch
fcom
fstsw ax
sahf
JE COMPARACION_37
fild ___IGUALES_RETURN
fild _1
fadd
fistp _@aux5
fild _@aux5
fistp ___IGUALES_RETURN
COMPARACION_37:
fild _2
fild _d
fmul
fistp _@aux6
fild _@aux6
fild _a
fxch
fcom
fstsw ax
sahf
JE COMPARACION_45
fild ___IGUALES_RETURN
fild _1
fadd
fistp _@aux7
fild _@aux7
fistp ___IGUALES_RETURN
COMPARACION_45:

FINAL:
mov ah, 1
int 21h
MOV AX, 4C00h
INT 21h
END START