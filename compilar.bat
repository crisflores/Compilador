flex Lexico.l
pause
bison -dyv Sintactico.y
pause
gcc lex.yy.c y.tab.c -o Segunda.exe
pause
Segunda.exe prueba.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del Segunda.exe
pause