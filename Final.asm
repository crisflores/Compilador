include macros2.asm
include number.asm

.MODEL LARGE
.STACK 200h
.386
.387

MAXTEXTSIZE equ 50

.DATA

_z                                  DD (?)
_r                                  DD (?)
_miString                           DB MAXTEXTSIZE dup (?)
_miInteger                          DD (?)
_miFloat                            DD (?)
_j                                  DD (?)
_i                                  DD (?)
_h                                  DD (?)
_g                                  DD (?)
_f                                  DD (?)
_e                                  DD (?)
_d                                  DD (?)
_c                                  DD (?)
_b                                  DD (?)
_a                                  DD (?)
__INLIST_RETURN                     DD (?)
_@aux4                              DD (?)
_@aux3                              DD (?)
_@aux2                              DD (?)
_@aux1                              DD (?)
_@aux0                              DD (?)
_9999                               DD 9999      
_99                                 DD 99        
_8                                  DD 8         
_7                                  DD 7         
_65535                              DD 65535     
_48                                 DD 48        
_45                                 DD 45        
_42949                              DD 42949     
_34                                 DD 34        
_2                                  DD 2         
_1237                               DD 1237      
_12345                              DD 12345     
_12                                 DD 12        
_10                                 DD 10        
_1                                  DD 1         

.CODE

START:
MOV AX, @DATA
MOV DS,AX
FINIT
FFREE

fild _8
fistp _b
fild _b
fistp _a
fild _10
fistp _c
fild _12345
fistp _d
fild _45
fistp _e
fild _42949
fistp _f
fild _99
fistp _g
fild _9999
fistp _h
fild _65535
fistp _i
fild _1237
fistp _j
fild _1
fistp _z
fild _0
fistp __INLIST_RETURN
fild _2
fild _b
fmul
fistp _@aux0
fild _@aux0
fild _7
fadd
fistp _@aux1
fild _a
fild _@aux1
fxch
fcom
fstsw ax
sahf
JE :=
fild _a
fild _12
fxch
fcom
fstsw ax
sahf
JE :=
fild _34
fild _d
fadd
fistp _@aux2
fild _b
fild _@aux2
fmul
fistp _@aux3
fild _34
fild _@aux3
fadd
fistp _@aux4
fild _a
fild _@aux4
fxch
fcom
fstsw ax
sahf
JE :=
fild _a
fild _48
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST_61
fild _1
fistp __INLIST_RETURN
ENDINLIST_61:

FINAL:
mov ah, 1
int 21h
MOV AX, 4C00h
INT 21h
END START