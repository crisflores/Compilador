include macros2.asm
include number.asm

include numbers.asm

.MODEL LARGE
.STACK 200h
.386
.387

.DATA

MAXTEXTSIZE equ 50

miString                            DB , MAXTEXTSIZE dup (?)
miInteger                           DT  
miFloat                             DD  
hola_este_mi_insuperable_float      DD  
d                                   DB , MAXTEXTSIZE dup (?)
c                                   DT  
b                                   DD  
a                                   DT  
__INLIST_RETURN                     DT  
__FILTER_OPERANDO                   DD  (?)
__FILTER_INDEX                      DT  
_99.                                DB  99.       
_7                                  DD  7         
_65535                              DD  65535     
_6.5                                DB  6.5       
_48                                 DD  48        
_4294967295.0                       DB  4294967295.0
_4                                  DD  4         
_34                                 DD  34        
_2.3                                DB  2.3       
_2                                  DD  2         
_1237                               DD  1237      
_12                                 DD  12        
_100                                DD  100       
_1.22                               DB  1.22      
_0                                  DD  0         
_.9999                              DB  .9999     
_"asldkfhsjf"                       DB  "asldkfhsjf", 10 dup (?)
_"as ldkf hsjf"                     DB  "as ldkf hsjf", 12 dup (?)
_"@sdADaSjfla%dfg"                  DB  "@sdADaSjfla%dfg", 15 dup (?)
_"123456789012345678901234567890"   DB  "123456789012345678901234567890", 30 dup (?)
@aux9                               DD  
@aux8                               DD  
@aux7                               DD  
@aux6                               DD  
@aux5                               DD  
@aux4                               DD  
@aux3                               DD  
@aux24                              DD  
@aux23                              DD  
@aux22                              DD  
@aux21                              DD  
@aux20                              DD  
@aux2                               DD  
@aux19                              DD  
@aux18                              DD  
@aux17                              DD  
@aux16                              DD  
@aux15                              DD  
@aux14                              DD  
@aux13                              DD  
@aux12                              DD  
@aux11                              DD  
@aux10                              DD  
@aux1                               DD  
@aux0                               DD  

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
JNE ENDIF
THEN:
DisplayString _"if simple"
ENDIF:
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JL ENDIF
THEN:
DisplayString _"if con not"
ENDIF:
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JG ENDIF
fild _a
fild _c
fxch
fcom
fstsw ax
sahf
JLE ENDIF
THEN:
DisplayString _"if con and"
ENDIF:
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JGE THEN
fild _a
fild _c
fxch
fcom
fstsw ax
sahf
JE ENDIF
THEN:
DisplayString _"if con or"
ENDIF:
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JE ELSE
THEN:
DisplayString _"if con else"
JMP ENDIF
ELSE:
DisplayString _"este es el else"
ENDIF:
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JNE ELSE
THEN:
fild _a
fild _b
fxch
fcom
fstsw ax
sahf
JL ELSE
THEN:
DisplayString _"if con else anidado"
JMP ENDIF
ELSE:
DisplayString _"parte else"
ENDIF:
JMP ENDIF
ELSE:
DisplayString _"else del primer if"
ENDIF:
GetInteger _a
DisplayString _a
DisplayString _"hola mundo"
REPEAT:
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
JGE ENDREPEAT
THEN:
DisplayString _"repeat sentencia 1"
DisplayString _"repeat sentencia 2"
DisplayString _"repeat sentencia 3"
JMP REPEAT
ENDREPEAT:
fild _0
fistp ___FILTER_INDEX
JMP LISTA
THEN:
fild ___FILTER_INDEX
fild _1
fadd
fistp _@aux4
fild _@aux4
fistp ___FILTER_INDEX
fild ___FILTER_OPERANDO
fild _a
fxch
fcom
fstsw ax
sahf
JL ENDFILTER
LISTA:
fild ___FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER
fild _a
fistp ___FILTER_OPERANDO
JMP THEN
ENDFILTER:
fild _0
fistp ___FILTER_INDEX
JMP LISTA
THEN:
fild ___FILTER_INDEX
fild _1
fadd
fistp _@aux5
fild _@aux5
fistp ___FILTER_INDEX
fild _4
fild _r
fadd
fistp _@aux6
fild ___FILTER_OPERANDO
fild _@aux6
fxch
fcom
fstsw ax
sahf
JLE LISTA
fild ___FILTER_OPERANDO
fild _6.5
fxch
fcom
fstsw ax
sahf
JLE ENDFILTER
LISTA:
fild ___FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER
fild _b
fistp ___FILTER_OPERANDO
JMP THEN
ENDFILTER:
fild _0
fistp ___FILTER_INDEX
JMP LISTA
THEN:
fild ___FILTER_INDEX
fild _1
fadd
fistp _@aux7
fild _@aux7
fistp ___FILTER_INDEX
fild _4
fild _r
fadd
fistp _@aux8
fild ___FILTER_OPERANDO
fild _@aux8
fxch
fcom
fstsw ax
sahf
JG ENDFILTER
fild ___FILTER_OPERANDO
fild _6.5
fxch
fcom
fstsw ax
sahf
JLE ENDFILTER
LISTA:
fild ___FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE CMP
fild _a
fistp ___FILTER_OPERANDO
JMP THEN
fild ___FILTER_INDEX
fild _1
fxch
fcom
fstsw ax
sahf
JNE CMP
fild _b
fistp ___FILTER_OPERANDO
JMP THEN
fild ___FILTER_INDEX
fild _2
fxch
fcom
fstsw ax
sahf
JNE CMP
fild _c
fistp ___FILTER_OPERANDO
JMP THEN
fild ___FILTER_INDEX
fild _3
fxch
fcom
fstsw ax
sahf
JNE CMP
fild _d
fistp ___FILTER_OPERANDO
JMP THEN
fild ___FILTER_INDEX
fild _4
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER
fild _mi_variable
fistp ___FILTER_OPERANDO
JMP THEN
ENDFILTER:
fild _0
fistp ___FILTER_INDEX
JMP LISTA
THEN:
fild ___FILTER_INDEX
fild _1
fadd
fistp _@aux9
fild _@aux9
fistp ___FILTER_INDEX
fild ___FILTER_OPERANDO
fild _100
fxch
fcom
fstsw ax
sahf
JLE ENDFILTER
LISTA:
fild ___FILTER_INDEX
fild _0
fxch
fcom
fstsw ax
sahf
JNE CMP
fild _a
fistp ___FILTER_OPERANDO
JMP THEN
fild ___FILTER_INDEX
fild _1
fxch
fcom
fstsw ax
sahf
JNE ENDFILTER
fild _b
fistp ___FILTER_OPERANDO
JMP THEN
ENDFILTER:
fild _0
fistp ___INLIST_RETURN
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
JMP ENDINLIST
fild _1
fistp ___INLIST_RETURN
ENDINLIST:
fild _0
fistp ___INLIST_RETURN
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
JMP ENDINLIST
fild _1
fistp ___INLIST_RETURN
ENDINLIST:
fild _0
fistp ___INLIST_RETURN
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
JMP ENDINLIST
fild _1
fistp ___INLIST_RETURN
ENDINLIST:
fild ___INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JNE ENDIF
THEN:
DisplayString _"if con inlist"
ENDIF:
fild _0
fistp ___INLIST_RETURN
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
JMP ENDINLIST
fild _1
fistp ___INLIST_RETURN
ENDINLIST:
fild ___INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JE THEN
fild _0
fistp ___INLIST_RETURN
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
JMP ENDINLIST
fild _1
fistp ___INLIST_RETURN
ENDINLIST:
fild ___INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JNE ENDIF
THEN:
DisplayString _"if con inlist y or"
ENDIF:
fild _0
fistp ___INLIST_RETURN
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
JMP ENDINLIST
fild _1
fistp ___INLIST_RETURN
ENDINLIST:
fild ___INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JE ENDIF
THEN:
DisplayString _"if con not inlist"
ENDIF:
REPEAT:
fild _0
fistp ___INLIST_RETURN
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
JMP ENDINLIST
fild _1
fistp ___INLIST_RETURN
ENDINLIST:
fild ___INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JNE ENDREPEAT
THEN:
DisplayString _"repeat con inlist"
JMP REPEAT
ENDREPEAT:
REPEAT:
fild _0
fistp ___INLIST_RETURN
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
JMP ENDINLIST
fild _1
fistp ___INLIST_RETURN
ENDINLIST:
fild ___INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JE THEN
fild _0
fistp ___INLIST_RETURN
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
JMP ENDINLIST
fild _1
fistp ___INLIST_RETURN
ENDINLIST:
fild ___INLIST_RETURN
fild _1
fxch
fcom
fstsw ax
sahf
JNE ENDREPEAT
THEN:
DisplayString _"repeat con inlist y or"
JMP REPEAT
ENDREPEAT:

FINAL:
mov ah, 1
int 21h
MOV AX, 4C00h
INT 21h
END START