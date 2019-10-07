%{
	#include <stdio.h>
	#include <stdbool.h>
	#include <stdlib.h>
	#include <string.h>
	#include <math.h>
	#include <errno.h>
	#include "y.tab.h"

	void yyerror(const char *mensaje);
	char error_mensaje[1000];

	void validar_constante_string(char *constante_string);
	void validar_constante_entera(char *constante_entera);
	void validar_constante_real(char *constante_real);

	const int MAX_STRING_LENGTH = 30;
	const int INTMAX = 65535;
	const int INTMIN = 0;
	const double FLOATMAX = 4294967295;
	const double FLOATMIN = 0;
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
COMENTARIO {COMENTARIO_I}({CARACTER}|{COMENTARIO_SIMPLE}|[\r\n])*{COMENTARIO_F}

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
"ELSE" {
	return ELSE;
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
	validar_constante_entera(yytext);
	return CONSTANTE_ENTERA;
}
{CONSTANTE_REAL} {
	validar_constante_real(yytext);
	return CONSTANTE_REAL;
}
{CONSTANTE_STRING} {
	validar_constante_string(yytext);
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

void validar_constante_string(char *constante_string) {
	int length = 0;
	while(constante_string[length] != '\0') {			
		length++;
	}
	// mayor a 32 se pone porque las comillas de la constante no cuentan para su tamaño
	if(length > MAX_STRING_LENGTH + 2) {
		sprintf(error_mensaje, "la constante string %s supera los [%d] caracteres permitidos\n", constante_string, MAX_STRING_LENGTH);
		yyerror(error_mensaje);
	}
}

void validar_constante_entera(char *constante_entera) {
	long entero = atoi(constante_entera);
	if(entero > INTMAX || entero < INTMIN) {		
		sprintf(error_mensaje, "constante entera %s fuera de rango [%d, %d]\n", constante_entera, INTMIN, INTMAX);
		yyerror(error_mensaje);
	}
}

void validar_constante_real(char *constante_real) {
	double flotante = atof(constante_real);

	// no más de 30 números
	int length = 0;
	while(constante_real[length] != '\0') {			
		length++;
	}
	if(length > MAX_STRING_LENGTH) {
		sprintf(error_mensaje, "la constante real %s supera los [%d] caracteres permitidos\n", constante_real, MAX_STRING_LENGTH);
		yyerror(error_mensaje);
	}
	if(flotante > FLOATMAX || flotante < FLOATMIN) {		
		sprintf(error_mensaje, "constante real %s fuera de rango\n", constante_real);
		yyerror(error_mensaje);
	}
}