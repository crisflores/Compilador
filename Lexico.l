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
SIMBOLO [@|%]
ID {LETRA}({LETRA}|{DIGITO}|_)*
CONSTANTE_ENTERA ({DIGITO})+
CONSTANTE_REAL (({DIGITO})+("."{1})({DIGITO})*)|(({DIGITO})*("."{1})({DIGITO})+)
CONSTANTE_STRING (["])(({LETRA}|{DIGITO}|{SIMBOLO}|[ ]){0,30})(["])
CARACTER ({DIGITO}|{LETRA}|{SIMBOLO}|.|_)+
COMENTARIO_I "--/"
COMENTARIO_F "/--"
COMENTARIO_SIMPLE {COMENTARIO_I}({CARACTER}|[\r\n])*{COMENTARIO_F}
COMENTARIO {COMENTARIO_I}({CARACTER}|{COMENTARIO_SIMPLE})*{COMENTARIO_F}

%%

"INLIST" {
	return INLIST;
}
"FILTER" {
	return FILTER;
}
"_" {
	return OPERANDO_FILTER;
}
"REPEAT" {
	return REPEAT;
}
"ENDREPEAT" {
	return ENDREPEAT;
}
"IF" {
	return IF;
}
"ENDIF" {
	return ENDIF;
}
"AND" {
	return AND;
}
"OR" {
	return OR;
}
"NOT" {
	return NOT;
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
"Integer" {
	return INTEGER;
}
"Float" {
	return FLOAT;
}
"String" {
	return STRING;
}
"READ" {
return READ;
}
"PRINT" {
return PRINT;
}
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
"," {
	return COMA;
}
":=" {
	return OP_ASIGNACION;
}
":" {
	return DOS_PUNTOS;
}
";" {
	return PUNTO_Y_COMA;
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
"+" {
	return SUMA;
}
"*" {
	return MULTIPLICACION;
}
"==" {
return IGUAL_A;
}
"<" {
return MENOR_A;
}
"<=" {
return MENOR_IGUAL_A;
}
">" {
return MAYOR_A;
}
">=" {
return MAYOR_IGUAL_A;
}
"!=" {
return DISTINTA_A;
}
[" "\t\r\n] { 
	/* ignorar espaciado */ 
}
. {
	sprintf(error_mensaje, "no se esperaba encontrar la expresion [%s]", yytext);
	yyerror(error_mensaje);
}
{COMENTARIO} {
	/* Ignoramos comentarios */
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