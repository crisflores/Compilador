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

fild b
fistp a
fild "asldkfhsjf"
fistp b
fild "as ldkf hsjf"
fistp c
fild "123456789012345678901234567890"
fistp d
fild "@sdADaSjfla%dfg"
fistp e
fild 4294967295.0
fistp f
fild 99.
fistp g
fild .9999
fistp h
fild 65535
fistp i
fild 1237
fistp j
fild 0
fistp miInteger
fild a
fild b
fadd
fistp _@aux0
fild c
fild 4
fmul
fistp _@aux1
fild _@aux0
fild _@aux1
fadd
fistp _@aux2
fild _@aux2
fistp a
fild a
fild b
fxch
fcom
fstsw ax
sahf
JNE ENDIF
THEN:
DisplayString "if simple"
ENDIF:
fild a
fild b
fxch
fcom
fstsw ax
sahf
JL ENDIF
THEN:
DisplayString "if con not"
ENDIF:
fild a
fild b
fxch
fcom
fstsw ax
sahf
JG ENDIF
fild a
fild c
fxch
fcom
fstsw ax
sahf
JLE ENDIF
THEN:
DisplayString "if con and"
ENDIF:
fild a
fild b
fxch
fcom
fstsw ax
sahf
JGE THEN
fild a
fild c
fxch
fcom
fstsw ax
sahf
JE ENDIF
THEN:
DisplayString "if con or"
ENDIF:
fild a
fild b
fxch
fcom
fstsw ax
sahf
JE ELSE
THEN:
DisplayString "if con else"
JMP ENDIF
ELSE:
DisplayString "este es el else"
ENDIF:
fild a
fild b
fxch
fcom
fstsw ax
sahf
JNE ELSE
THEN:
fild a
fild b
fxch
fcom
fstsw ax
sahf
JL ELSE
THEN:
DisplayString "if con else anidado"
JMP ENDIF
ELSE:
DisplayString "parte else"
ENDIF:
JMP ENDIF
ELSE:
DisplayString "else del primer if"
ENDIF:
GetInteger a
DisplayString a
DisplayString "hola mundo"
REPEAT:
fild b
fild 100
fadd
fistp _@aux3
fild a
fild _@aux3
fxch
fcom
fstsw ax
sahf
JGE ENDREPEAT
THEN:
DisplayString "repeat sentencia 1"
DisplayString "repeat sentencia 2"
DisplayString "repeat sentencia 3"
JMP REPEAT
ENDREPEAT:
fild 0
fistp __FILTER_INDEX
JMP LISTA
THEN:
fild __FILTER_INDEX
fild 1
fadd
fistp _@aux4
fild _@aux4
fistp __FILTER_INDEX
fild __FILTER_OPERANDO
fild a
fxch
fcom
fstsw ax
sahf
JL ENDFILTER
LISTA:
fild __FILTER_INDEX
fild 0
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER
fild a
fistp __FILTER_OPERANDO
JMP THEN
ENDFILTER:
fild 0
fistp __FILTER_INDEX
JMP LISTA
THEN:
fild __FILTER_INDEX
fild 1
fadd
fistp _@aux5
fild _@aux5
fistp __FILTER_INDEX
fild 4
fild r
fadd
fistp _@aux6
fild __FILTER_OPERANDO
fild _@aux6
fxch
fcom
fstsw ax
sahf
JLE LISTA
fild __FILTER_OPERANDO
fild 6.5
fxch
fcom
fstsw ax
sahf
JLE ENDFILTER
LISTA:
fild __FILTER_INDEX
fild 0
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER
fild b
fistp __FILTER_OPERANDO
JMP THEN
ENDFILTER:
fild 0
fistp __FILTER_INDEX
JMP LISTA
THEN:
fild __FILTER_INDEX
fild 1
fadd
fistp _@aux7
fild _@aux7
fistp __FILTER_INDEX
fild 4
fild r
fadd
fistp _@aux8
fild __FILTER_OPERANDO
fild _@aux8
fxch
fcom
fstsw ax
sahf
JG ENDFILTER
fild __FILTER_OPERANDO
fild 6.5
fxch
fcom
fstsw ax
sahf
JLE ENDFILTER
LISTA:
fild __FILTER_INDEX
fild 0
fxch
fcom
fstsw ax
sahf
JNE CMP
fild a
fistp __FILTER_OPERANDO
JMP THEN
fild __FILTER_INDEX
fild 1
fxch
fcom
fstsw ax
sahf
JNE CMP
fild b
fistp __FILTER_OPERANDO
JMP THEN
fild __FILTER_INDEX
fild 2
fxch
fcom
fstsw ax
sahf
JNE CMP
fild c
fistp __FILTER_OPERANDO
JMP THEN
fild __FILTER_INDEX
fild 3
fxch
fcom
fstsw ax
sahf
JNE CMP
fild d
fistp __FILTER_OPERANDO
JMP THEN
fild __FILTER_INDEX
fild 4
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER
fild mi_variable
fistp __FILTER_OPERANDO
JMP THEN
ENDFILTER:
fild 0
fistp __FILTER_INDEX
JMP LISTA
THEN:
fild __FILTER_INDEX
fild 1
fadd
fistp _@aux9
fild _@aux9
fistp __FILTER_INDEX
fild __FILTER_OPERANDO
fild 100
fxch
fcom
fstsw ax
sahf
JLE ENDFILTER
LISTA:
fild __FILTER_INDEX
fild 0
fxch
fcom
fstsw ax
sahf
JNE CMP
fild a
fistp __FILTER_OPERANDO
JMP THEN
fild __FILTER_INDEX
fild 1
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER
fild b
fistp __FILTER_OPERANDO
JMP THEN
ENDFILTER:
fild 0
fistp __INLIST_RETURN
fild 2
fild b
fmul
fistp _@aux10
fild _@aux10
fild 7
fadd
fistp _@aux11
fild a
fild _@aux11
fxch
fcom
fstsw ax
sahf
JE :=
fild a
fild 12
fxch
fcom
fstsw ax
sahf
JE :=
fild 34
fild d
fadd
fistp _@aux12
fild b
fild _@aux12
fmul
fistp _@aux13
fild 34
fild _@aux13
fadd
fistp _@aux14
fild a
fild _@aux14
fxch
fcom
fstsw ax
sahf
JE :=
fild a
fild 48
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST
fild 1
fistp __INLIST_RETURN
ENDINLIST:
fild 0
fistp __INLIST_RETURN
fild z
fild 2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild z
fild 1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST
fild 1
fistp __INLIST_RETURN
ENDINLIST:
fild 0
fistp __INLIST_RETURN
fild z
fild 2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild z
fild 1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST
fild 1
fistp __INLIST_RETURN
ENDINLIST:
fild __INLIST_RETURN
fild 1
fxch
fcom
fstsw ax
sahf
JNE ENDIF
THEN:
DisplayString "if con inlist"
ENDIF:
fild 0
fistp __INLIST_RETURN
fild z
fild 2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild z
fild 1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST
fild 1
fistp __INLIST_RETURN
ENDINLIST:
fild __INLIST_RETURN
fild 1
fxch
fcom
fstsw ax
sahf
JE THEN
fild 0
fistp __INLIST_RETURN
fild 2
fild b
fmul
fistp _@aux15
fild _@aux15
fild 7
fadd
fistp _@aux16
fild a
fild _@aux16
fxch
fcom
fstsw ax
sahf
JE :=
fild a
fild 12
fxch
fcom
fstsw ax
sahf
JE :=
fild 34
fild d
fadd
fistp _@aux17
fild b
fild _@aux17
fmul
fistp _@aux18
fild 34
fild _@aux18
fadd
fistp _@aux19
fild a
fild _@aux19
fxch
fcom
fstsw ax
sahf
JE :=
fild a
fild 48
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST
fild 1
fistp __INLIST_RETURN
ENDINLIST:
fild __INLIST_RETURN
fild 1
fxch
fcom
fstsw ax
sahf
JNE ENDIF
THEN:
DisplayString "if con inlist y or"
ENDIF:
fild 0
fistp __INLIST_RETURN
fild z
fild 2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild z
fild 1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST
fild 1
fistp __INLIST_RETURN
ENDINLIST:
fild __INLIST_RETURN
fild 1
fxch
fcom
fstsw ax
sahf
JE ENDIF
THEN:
DisplayString "if con not inlist"
ENDIF:
REPEAT:
fild 0
fistp __INLIST_RETURN
fild z
fild 2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild z
fild 1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST
fild 1
fistp __INLIST_RETURN
ENDINLIST:
fild __INLIST_RETURN
fild 1
fxch
fcom
fstsw ax
sahf
JNE ENDREPEAT
THEN:
DisplayString "repeat con inlist"
JMP REPEAT
ENDREPEAT:
REPEAT:
fild 0
fistp __INLIST_RETURN
fild z
fild 2.3
fxch
fcom
fstsw ax
sahf
JE :=
fild z
fild 1.22
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST
fild 1
fistp __INLIST_RETURN
ENDINLIST:
fild __INLIST_RETURN
fild 1
fxch
fcom
fstsw ax
sahf
JE THEN
fild 0
fistp __INLIST_RETURN
fild 2
fild b
fmul
fistp _@aux20
fild _@aux20
fild 7
fadd
fistp _@aux21
fild a
fild _@aux21
fxch
fcom
fstsw ax
sahf
JE :=
fild a
fild 12
fxch
fcom
fstsw ax
sahf
JE :=
fild 34
fild d
fadd
fistp _@aux22
fild b
fild _@aux22
fmul
fistp _@aux23
fild 34
fild _@aux23
fadd
fistp _@aux24
fild a
fild _@aux24
fxch
fcom
fstsw ax
sahf
JE :=
fild a
fild 48
fxch
fcom
fstsw ax
sahf
JE :=
JMP ENDINLIST
fild 1
fistp __INLIST_RETURN
ENDINLIST:
fild __INLIST_RETURN
fild 1
fxch
fcom
fstsw ax
sahf
JNE ENDREPEAT
THEN:
DisplayString "repeat con inlist y or"
JMP REPEAT
ENDREPEAT:

FINAL:
mov ah, 1
int 21h
MOV AX, 4C00h
INT 21h
END START