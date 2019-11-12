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
__FILTER_OPERANDO                   DD (?)
__FILTER_INDEX                      DD (?)
_@aux9                              DD (?)
_@aux8                              DD (?)
_@aux7                              DD (?)
_@aux6                              DD (?)
_@aux5                              DD (?)
_@aux4                              DD (?)
_@aux3                              DD (?)
_@aux2                              DD (?)
_@aux13                             DD (?)
_@aux12                             DD (?)
_@aux11                             DD (?)
_@aux10                             DD (?)
_@aux1                              DD (?)
_@aux0                              DD (?)
_9999                               DD 9999      
_99                                 DD 99        
_8                                  DD 8         
_7                                  DD 7         
_6_5                                DD 6.5       
_65535                              DD 65535     
_48                                 DD 48        
_45                                 DD 45        
_42949                              DD 42949     
_4                                  DD 4         
_34                                 DD 34        
_2_3                                DD 2.3       
_2                                  DD 2         
_1_22                               DD 1.22      
_1237                               DD 1237      
_12345                              DD 12345     
_12                                 DD 12        
_100                                DD 100       
_10                                 DD 10        
_1                                  DD 1         
_0                                  DD 0         

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
fistp _z
fild _a
fild _b
fadd
fistp _@aux0
fild _c
fild _4
fmul
fistp _@aux1
fild _@aux0
fild _@aux1
fadd
fistp _@aux2
fild _@aux2
fistp _a
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JNE ELSE_50
THEN_47:
DisplayString _a
JMP ENDIF_52
ELSE_50:
DisplayString _b
ENDIF_52:
GetInteger _a
DisplayString _a
REPEAT_55:
fild _b
fild _100
fadd
fistp _@aux3
fild _a
fild _@aux3
fxch
fcom
fstsw ax
sahf
JGE ENDREPEAT_65
THEN_62:
DisplayString _z
JMP REPEAT_55
ENDREPEAT_65:
fild _0
fistp __FILTER_INDEX
JMP LISTA_76
THEN_69:
fild __FILTER_INDEX
fild _1
fadd
fistp _@aux4
fild _@aux4
fistp __FILTER_INDEX
fild __FILTER_OPERANDO
fild _a
fxch
fcom
fstsw ax
sahf
JL ENDFILTER_82
LISTA_76:
COMPARACION_77:
fild __FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER_82
fild _a
fistp __FILTER_OPERANDO
JMP THEN_69
ENDFILTER_82:
fild _0
fistp __FILTER_INDEX
JMP LISTA_99
THEN_86:
fild __FILTER_INDEX
fild _1
fadd
fistp _@aux5
fild _@aux5
fistp __FILTER_INDEX
fild _4
fild _r
fadd
fistp _@aux6
fild __FILTER_OPERANDO
fild _@aux6
fxch
fcom
fstsw ax
sahf
JLE LISTA_99
fild __FILTER_OPERANDO
fild _6_5
fxch
fcom
fstsw ax
sahf
JLE ENDFILTER_105
LISTA_99:
COMPARACION_100:
fild __FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER_105
fild _b
fistp __FILTER_OPERANDO
JMP THEN_86
ENDFILTER_105:
fild _0
fistp __FILTER_INDEX
JMP LISTA_122
THEN_109:
fild __FILTER_INDEX
fild _1
fadd
fistp _@aux7
fild _@aux7
fistp __FILTER_INDEX
fild _4
fild _r
fadd
fistp _@aux8
fild __FILTER_OPERANDO
fild _@aux8
fxch
fcom
fstsw ax
sahf
JG ENDFILTER_138
fild __FILTER_OPERANDO
fild _6_5
fxch
fcom
fstsw ax
sahf
JLE ENDFILTER_138
LISTA_122:
COMPARACION_123:
fild __FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE COMPARACION_128
fild _a
fistp __FILTER_OPERANDO
JMP THEN_109
COMPARACION_128:
fild __FILTER_INDEX
fild _1
fxch
fcom
fstsw ax
sahf
JNE COMPARACION_133
fild _b
fistp __FILTER_OPERANDO
JMP THEN_109
COMPARACION_133:
fild __FILTER_INDEX
fild _2
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER_138
fild _c
fistp __FILTER_OPERANDO
JMP THEN_109
ENDFILTER_138:
fild _0
fistp __FILTER_INDEX
JMP LISTA_149
THEN_142:
fild __FILTER_INDEX
fild _1
fadd
fistp _@aux9
fild _@aux9
fistp __FILTER_INDEX
fild __FILTER_OPERANDO
fild _100
fxch
fcom
fstsw ax
sahf
JLE ENDFILTER_160
LISTA_149:
COMPARACION_150:
fild __FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE COMPARACION_155
fild _a
fistp __FILTER_OPERANDO
JMP THEN_142
COMPARACION_155:
fild __FILTER_INDEX
fild _1
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER_160
fild _b
fistp __FILTER_OPERANDO
JMP THEN_142
ENDFILTER_160:
fild __FILTER_OPERANDO
fild _100
fxch
fcom
fstsw ax
sahf
fild _0
fistp __INLIST_RETURN
fild _2
fild _b
fmul
fistp _@aux10
fild _@aux10
fild _7
fadd
fistp _@aux11
fild _a
fild _@aux11
fxch
fcom
fstsw ax
sahf
JE RETURN_TRUE_186
fild _a
fild _12
fxch
fcom
fstsw ax
sahf
JE RETURN_TRUE_186
fild _34
fild _d
fadd
fistp _@aux12
fild _b
fild _@aux12
fmul
fistp _@aux13
fild _a
fild _@aux13
fxch
fcom
fstsw ax
sahf
JE RETURN_TRUE_186
fild _a
fild _48
fxch
fcom
fstsw ax
sahf
JE RETURN_TRUE_186
JMP ENDINLIST_188
RETURN_TRUE_186:
fild _1
fistp __INLIST_RETURN
ENDINLIST_188:
RETURN_TRUE_190:
fild _0
fistp __INLIST_RETURN
fild _z
fild _2_3
fxch
fcom
fstsw ax
sahf
JE RETURN_TRUE_200
fild _z
fild _1_22
fxch
fcom
fstsw ax
sahf
JE RETURN_TRUE_200
JMP ENDINLIST_202
RETURN_TRUE_200:
fild _1
fistp __INLIST_RETURN
ENDINLIST_202:

FINAL:
mov ah, 1
int 21h
MOV AX, 4C00h
INT 21h
END START