set PATH=C:\Compilador\
set LEXICO=Lexico.l
set SINTACTICO=Sintactico.y
set TEST_TXT=prueba.txt
set TABLA_DE_SIMBOLOS=ts.txt
set PUNTO_EXE=Segunda.exe
set INTERMEDIA=intermedia.txt
cd c:\GnuWin32\bin\
flex %PATH%%LEXICO%
bison -dyv %PATH%%SINTACTICO%
cd c:\MinGW\bin\
gcc.exe c:\GnuWin32\bin\lex.yy.c c:\GnuWin32\bin\y.tab.c -o c:\GnuWin32\bin\%PUNTO_EXE%
c:\GnuWin32\bin\%PUNTO_EXE% %PATH%%TEST_TXT%
del c:\GnuWin32\bin\lex.yy.c
del c:\GnuWin32\bin\y.tab.c
del c:\GnuWin32\bin\y.output
del c:\GnuWin32\bin\y.tab.h
move c:\GnuWin32\bin\%PUNTO_EXE% %PATH%%PUNTO_EXE% 
move %TABLA_DE_SIMBOLOS% %PATH%%TABLA_DE_SIMBOLOS%
move %INTERMEDIA% %PATH%%INTERMEDIA%
cd %PATH%