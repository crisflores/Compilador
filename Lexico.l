%{
	#include <stdio.h>
	#include <stdbool.h>
	#include <string.h>
  #include <math.h>
	#include "y.tab.h"

	void yyerror(const char *mensaje);
	char error_mensaje[1000];
%}

%option noyywrap
%option yylineno

DIGITO ([0-9])+
LETRA [a-zA-Z]
ID {LETRA}({LETRA}|{DIGITO}|_)*
CONSTANTE_ENTERA ({DIGITO})+
CONSTANTE_REAL (({DIGITO})+("."{1})({DIGITO})*)|(({DIGITO})*("."{1})({DIGITO})+)
CONSTANTE_STRING ((")(({DIGITO}|{LETRA}| ){0,30})("))

%%

{ID} {
	return ID;
}
{CONSTANTE_ENTERA} {
	return CONSTANTE_ENTERA;
}
{CONSTANTE_REAL} {
	return CONSTANTE_REAL;
}
{CONSTANTE_STRING} {
	return CONSTANTE_STRING;
}
"REPEAT" {
	return REPEAT;
}
"IF" {
	return IF;
}
"PRINT" {
	return PRINT;
}
"READ" {
	return READ;
}
"VAR" {
	return VAR;
}
"ENDVAR" {
	return ENDVAR;
}
":=" {
	return OP_ASIGNACION;
}
":" {
	return DOS_PUNTOS;
}
"(" {
	return PARENTESIS_ABRE;
}
")" {
	return PARENTESIS_CIERRA;
}
"[" {
	return CORCHETE_ABRE;
}
"]" {
	return CORCHETE_CIERRA;
}
[" "\t\r\n] { 
	/* ignorar espaciado */ 
}
. {
	sprintf(error_mensaje, "no se esperaba encontrar la expresion [%s]", yytext);
	yyerror(error_mensaje);
}

%%

void yyerror(const char *mensaje) {
	char error[1001];
	char aux_msj[1000];
	if(strcmp(mensaje, "syntax error") == 0)
		strcpy(aux_msj, "sintaxis incorrecta");
	else 
		strcpy(aux_msj, mensaje);
	sprintf(error, "\n\n>>>> FIN INESPERADO: linea [%d] del programa <<<<\nERROR: %s\n", yylineno, aux_msj);
	printf(error);
	exit(1);
}

// tabla de símbolos
// --------------------------------------------------------


// declaraciones
// --------------------------------------------------------
