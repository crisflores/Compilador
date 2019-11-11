include macros2.asm
include number.asm

include numbers.asm

.MODEL LARGE
.STACK 200h
.386
.387

.DATA

MAXTEXTSIZE equ 50

_miString                           DB MAXTEXTSIZE dup (?)
_miInteger                          DD (?)
_miFloat                            DD (?)
_hola_este_mi_insuperable_float     DD (?)
_d                                  DB MAXTEXTSIZE dup (?)
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
_@aux24                             DD (?)
_@aux23                             DD (?)
_@aux22                             DD (?)
_@aux21                             DD (?)
_@aux20                             DD (?)
_@aux2                              DD (?)
_@aux19                             DD (?)
_@aux18                             DD (?)
_@aux17                             DD (?)
_@aux16                             DD (?)
_@aux15                             DD (?)
_@aux14                             DD (?)
_@aux13                             DD (?)
_@aux12                             DD (?)
_@aux11                             DD (?)
_@aux10                             DD (?)
_@aux1                              DD (?)
_@aux0                              DD (?)
_99.                                DD 99.       
_7                                  DD 7         
_65535                              DD 65535     
_6.5                                DD 6.5       
_48                                 DD 48        
_4294967295.0                       DD 4294967295.0
_4                                  DD 4         
_34                                 DD 34        
_2.3                                DD 2.3       
_2                                  DD 2         
_1237                               DD 1237      
_12                                 DD 12        
_100                                DD 100       
_1.22                               DD 1.22      
_0                                  DD 0         
_.9999                              DD .9999     
_asldkfhsjf                         DB "asldkfhsjf", 10 dup (?)
_as ldkf hsjf                       DB "as ldkf hsjf", 12 dup (?)
_@sdADaSjfla%dfg                    DB "@sdADaSjfla%dfg", 15 dup (?)
_123456789012345678901234567890     DB "123456789012345678901234567890", 30 dup (?)

.CODE

START:
MOV AX, @DATA
MOV DS,AX
FINIT
FFREE

fild _b
fistp _a
fild _"asldkfhsjf"
fistp _b
fild _"as ldkf hsjf"
fistp _c
fild _"123456789012345678901234567890"
fistp _d
fild _"@sdADaSjfla%dfg"
fistp _e
fild _4294967295.0
fistp _f
fild _99.
fistp _g
fild _.9999
fistp _h
fild _65535
fistp _i
fild _1237
fistp _j
fild _0
fistp _miInteger
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
JNE ENDIF_47
DisplayString _"if simple"
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JL ENDIF_55
DisplayString _"if con not"
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JG ENDIF_67
fild _a
fild _c
fxch
fcom
fstsw ax
sahf
JLE ENDIF_67
DisplayString _"if con and"
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JGE THEN_77
fild _a
fild _c
fxch
fcom
fstsw ax
sahf
JE ENDIF_79
DisplayString _"if con or"
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JE ELSE_88
DisplayString _"if con else"
JMP ENDIF_90
DisplayString _"este es el else"
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JNE ELSE_109
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JL ELSE_105
DisplayString _"if con else anidado"
JMP ENDIF_107
DisplayString _"parte else"
JMP ENDIF_111
DisplayString _"else del primer if"
GetInteger _a
DisplayString _a
DisplayString _"hola mundo"
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
JGE ENDREPEAT_127
DisplayString _"repeat sentencia 1"
DisplayString _"repeat sentencia 2"
DisplayString _"repeat sentencia 3"
JMP _REPEAT_115
fild _0
fistp __FILTER_INDEX
JMP LISTA_138
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
JL ENDFILTER_143
fild __FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER_143
fild _a
fistp __FILTER_OPERANDO
JMP _THEN_131
fild _0
fistp __FILTER_INDEX
JMP LISTA_160
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
JLE LISTA_160
fild __FILTER_OPERANDO
fild _6.5
fxch
fcom
fstsw ax
sahf
JLE ENDFILTER_165
fild __FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER_165
fild _b
fistp __FILTER_OPERANDO
JMP _THEN_147
fild _0
fistp __FILTER_INDEX
JMP LISTA_182
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
JG ENDFILTER_203
fild __FILTER_OPERANDO
fild _6.5
fxch
fcom
fstsw ax
sahf
JLE ENDFILTER_203
fild __FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE CMP
fild _a
fistp __FILTER_OPERANDO
JMP _THEN_169
fild __FILTER_INDEX
fild _1
fxch
fcom
fstsw ax
sahf
JNE CMP
fild _b
fistp __FILTER_OPERANDO
JMP _THEN_169
fild __FILTER_INDEX
fild _2
fxch
fcom
fstsw ax
sahf
JNE CMP
fild _c
fistp __FILTER_OPERANDO
JMP _THEN_169
fild __FILTER_INDEX
fild _3
fxch
fcom
fstsw ax
sahf
JNE CMP
fild _d
fistp __FILTER_OPERANDO
JMP _THEN_169
fild __FILTER_INDEX
fild _4
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER_203
fild _mi_variable
fistp __FILTER_OPERANDO
JMP _THEN_169
fild _0
fistp __FILTER_INDEX
JMP LISTA_214
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
JLE ENDFILTER_223
fild __FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE CMP
fild _a
fistp __FILTER_OPERANDO
JMP _THEN_207
fild __FILTER_INDEX
fild _1
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER_223
fild _b
fistp __FILTER_OPERANDO
JMP _THEN_207
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
fistp _@aux12
fild _b
fild _@aux12
fmul
fistp _@aux13
fild _34
fild _@aux13
fadd
fistp _@aux14
fild _a
fild _@aux14
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
JMP ENDINLIST_251
fild _1
fistp __INLIST_RETURN
fild _0
fistp __INLIST_RETURN
fild _z
fild _2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild _z
fild _1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST_263
fild _1
fistp __INLIST_RETURN
fild _0
fistp __INLIST_RETURN
fild _z
fild _2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild _z
fild _1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST_276
fild _1
fistp __INLIST_RETURN
fild __INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JNE ENDIF_281
DisplayString _"if con inlist"
fild _0
fistp __INLIST_RETURN
fild _z
fild _2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild _z
fild _1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST_294
fild _1
fistp __INLIST_RETURN
fild __INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JE THEN_327
fild _0
fistp __INLIST_RETURN
fild _2
fild _b
fmul
fistp _@aux15
fild _@aux15
fild _7
fadd
fistp _@aux16
fild _a
fild _@aux16
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
fistp _@aux17
fild _b
fild _@aux17
fmul
fistp _@aux18
fild _34
fild _@aux18
fadd
fistp _@aux19
fild _a
fild _@aux19
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
JMP ENDINLIST_324
fild _1
fistp __INLIST_RETURN
fild __INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JNE ENDIF_329
DisplayString _"if con inlist y or"
fild _0
fistp __INLIST_RETURN
fild _z
fild _2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild _z
fild _1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST_342
fild _1
fistp __INLIST_RETURN
fild __INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JE ENDIF_347
DisplayString _"if con not inlist"
fild _0
fistp __INLIST_RETURN
fild _z
fild _2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild _z
fild _1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST_360
fild _1
fistp __INLIST_RETURN
fild __INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JNE ENDREPEAT_366
DisplayString _"repeat con inlist"
JMP _REPEAT_348
fild _0
fistp __INLIST_RETURN
fild _z
fild _2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild _z
fild _1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST_379
fild _1
fistp __INLIST_RETURN
fild __INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JE THEN_412
fild _0
fistp __INLIST_RETURN
fild _2
fild _b
fmul
fistp _@aux20
fild _@aux20
fild _7
fadd
fistp _@aux21
fild _a
fild _@aux21
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
fistp _@aux22
fild _b
fild _@aux22
fmul
fistp _@aux23
fild _34
fild _@aux23
fadd
fistp _@aux24
fild _a
fild _@aux24
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
JMP ENDINLIST_409
fild _1
fistp __INLIST_RETURN
fild __INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JNE ENDREPEAT_415
DisplayString _"repeat con inlist y or"
JMP _REPEAT_367

FINAL:
mov ah, 1
int 21h
MOV AX, 4C00h
INT 21h
END START