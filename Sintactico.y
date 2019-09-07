%{
	#include <stdio.h>
	#include <stdbool.h>
	#include <string.h>
	#include <stdarg.h>
	#include "y.tab.h"

	// funciones de Flex y Bison
	// --------------------------------------------------------
	extern void yyerror(const char *mensaje);
	extern char error_mensaje[1000];
	extern int yylex(void);
	extern char * yytext;
	extern long int yylineno;
	FILE *yyin;
	void validar_constante_string(char *constante_string);
	const int MAX_STRING_LENGTH = 30;
%}

%locations
%start start
%token INLIST
%token FILTER
%token OPERANDO_FILTER
%token REPEAT
%token ENDREPEAT
%token IF
%token ENDIF
%token AND
%token OR
%token NOT
%token PRINT
%token READ
%token VAR
%token ENDVAR
%token INTEGER
%token FLOAT
%token STRING
%token ID
%token CONSTANTE_ENTERA
%token CONSTANTE_REAL
%token CONSTANTE_STRING
%token COMA
%token OP_ASIGNACION
%token DOS_PUNTOS
%token PUNTO_Y_COMA
%token PARENTESIS_ABRE
%token PARENTESIS_CIERRA
%token CORCHETE_ABRE
%token CORCHETE_CIERRA
%token SUMA
%token MULTIPLICACION
%token IGUAL_A
%token MENOR_A
%token MENOR_IGUAL_A
%token MAYOR_A
%token MAYOR_IGUAL_A
%token DISTINTA_A

%%

	start:
		{
			printf("start\n");
		} declaraciones programa 
		;

	declaraciones:	
		{
			printf("declaraciones\n");
		} VAR sentencia_declaraciones ENDVAR
		;

	declaraciones:
		{
			printf("declaraciones\n");
		}
		;

	sentencia_declaraciones:
		{
			printf("sentencia_declaraciones\n");
		} CORCHETE_ABRE declaracion CORCHETE_CIERRA
		;

	sentencia_declaraciones:
		{
			printf("sentencia_declaraciones\n");
		}
		;

	declaracion:
		tipo_id CORCHETE_CIERRA DOS_PUNTOS CORCHETE_ABRE ID	{
			printf("declaracion %s\n", yytext);
		} 	
		;

	declaracion:
		tipo_id COMA declaracion COMA ID {
			printf("declaracion %s\n", yytext);
		}
		;

	tipo_id:
		INTEGER {
			printf("tipo_id %s\n", yytext);
		} 
		;

	tipo_id:
		FLOAT {
			printf("tipo_id %s\n", yytext);
		} 
		;

	tipo_id:
		STRING {
			printf("tipo_id %s\n", yytext);
		} 
		;

	programa:
		sentencia
		;

	programa:
		programa sentencia
		;

	programa:
		;

	sentencia:
		{
			printf("sentencia\n");
		} asignacion
		;

	sentencia:
		{
			printf("sentencia\n");
		} seleccion
		;

	sentencia:
		{
			printf("sentencia\n");
		} entrada
		;

	sentencia:
		{
			printf("sentencia\n");
		} salida
		;

	sentencia:
		{
			printf("sentencia\n");
		} ciclo
		;

	sentencia:
		{
			printf("sentencia\n");
		} filtro
		;

	sentencia:
		{
			printf("sentencia\n");
		} en_lista
		;

	en_lista:
		INLIST {
			printf("inlist\n");
		} PARENTESIS_ABRE ID {
			printf("ID %s\n", yytext);
		} PUNTO_Y_COMA CORCHETE_ABRE {
			printf("lista_expresiones_inlist\n");
		} lista_expresiones_inlist CORCHETE_CIERRA PARENTESIS_CIERRA
		;

	filtro:
		FILTER {
			printf("filter\n");
		} PARENTESIS_ABRE condicion_filter COMA CORCHETE_ABRE {
			printf("lista_variables_filter\n");
		} lista_variables_filter CORCHETE_CIERRA PARENTESIS_CIERRA
		;

	ciclo:
		{
			printf("repeat\n");
		} REPEAT PARENTESIS_ABRE condicion PARENTESIS_CIERRA programa ENDREPEAT
		;

	salida:
		PRINT ID {
			printf("print ID %s\n", yytext);
		} 
		;

	salida:
		PRINT CONSTANTE_STRING {
			printf("print %s\n", yytext);
		} 
		;

	entrada:
		{
			printf("read ");
		} READ ID {
			printf("ID %s\n", yytext);
		} 
		;

	seleccion:
		IF {
			printf("seleccion\n");
		} PARENTESIS_ABRE condicion PARENTESIS_CIERRA programa ENDIF
		;

	condicion:
		comparacion
		;

	condicion:
		comparacion AND {
			printf("condicion AND\n");
		} comparacion
		;

	condicion:
		comparacion OR {
			printf("condicion OR\n");
		} comparacion
		;

	condicion:
		NOT {
			printf("condicion NOT\n");
		} comparacion
		;

	comparacion: 
		en_lista
		;

	comparacion:
		expresion IGUAL_A
		{
			printf("comparacion ==\n");
		} expresion
		;

	comparacion:
		expresion MENOR_A
		{
			printf("comparacion <\n");
		} expresion
		;

	comparacion:
		expresion MENOR_IGUAL_A
		{
			printf("comparacion <=\n");
		} expresion
		;

	comparacion:
		expresion MAYOR_A
		{
			printf("comparacion <\n");
		} expresion
		;

	comparacion:
		expresion MAYOR_IGUAL_A
		{
			printf("comparacion >=\n");
		} expresion
		;

	comparacion:
		expresion DISTINTA_A
		{
			printf("comparacion !=\n");
		} expresion
		;

	condicion_filter:
		comparacion_filter
		;

	condicion_filter:
		comparacion_filter AND {
			printf("condicion_filter AND\n");
		} comparacion_filter
		;

	condicion_filter:
		comparacion_filter OR {
			printf("condicion_filter OR\n");
		} comparacion_filter
		;

	condicion_filter:
		NOT {
			printf("condicion_filter NOT\n");
		} comparacion_filter
		;

	comparacion_filter:
		OPERANDO_FILTER {
			printf("operando_filter\n");
		} IGUAL_A
		{
			printf("comparacion_filter ==\n");
		} expresion
		;

	comparacion_filter:
		OPERANDO_FILTER {
			printf("operando_filter\n");
		}  MENOR_A
		{
			printf("comparacion_filter <\n");
		} expresion
		;

	comparacion_filter:
		OPERANDO_FILTER {
			printf("operando_filter\n");
		}  MENOR_IGUAL_A
		{
			printf("comparacion_filter <=\n");
		} expresion
		;

	comparacion_filter:
		OPERANDO_FILTER {
			printf("operando_filter\n");
		}  MAYOR_A
		{
			printf("comparacion_filter <\n");
		} expresion
		;

	comparacion_filter:
		OPERANDO_FILTER {
			printf("operando_filter\n");
		}  MAYOR_IGUAL_A
		{
			printf("comparacion_filter >=\n");
		} expresion
		;

	comparacion_filter:
		OPERANDO_FILTER {
			printf("operando_filter\n");
		}  DISTINTA_A
		{
			printf("comparacion_filter !=\n");
		} expresion
		;

	lista_variables_filter:
		variable_filter
		;

	lista_variables_filter:
		variable_filter COMA lista_variables_filter
		;

	variable_filter:
		ID { 
			printf("ID %s\n", yytext);
		} 
		;

	lista_expresiones_inlist:
		expresion
		;

	lista_expresiones_inlist:
		expresion PUNTO_Y_COMA lista_expresiones_inlist
		;

	asignacion:
		{
			printf("asignacion");
		} ID {
			printf(" ID %s\n", yytext);
		} OP_ASIGNACION expresion
		;

	expresion:
		expresion SUMA {
			printf("expresion +\n");
		} termino
		;

	expresion:
		termino
		;
	
	termino:
		termino MULTIPLICACION {
			printf("termino *\n");
		} factor
		;
	
	termino:
		factor
		;

	factor:
		PARENTESIS_ABRE {
			printf("factor (\n");
		} expresion PARENTESIS_CIERRA {
			printf("factor )\n");
		}
		;

	factor:
		ID {
			printf("factor %s\n", yytext);
		}
		;

	factor:
		CONSTANTE_STRING {
			printf("factor %s\n", yytext);
			validar_constante_string(yytext);
		}
		;

	factor:
		CONSTANTE_REAL {
			printf("factor %s\n", yytext);
		}
		;

	factor:
		CONSTANTE_ENTERA {
			printf("factor %s\n", yytext);
		}
		;
	
%%

int main(int argc, char *argv[]) {
	printf("\n");
	printf("==============================================================\n");
	printf("analisis-comienza\n");
	printf("==============================================================\n");
	if ((yyin = fopen(argv[1], "rt")) == NULL) {
		printf("ERROR: abriendo archivo [%s]\n", argv[1]);
	} else {
		yyparse();
		fclose(yyin);
	}
	printf("==============================================================\n");
	printf("analisis-finaliza\n");
	printf("==============================================================\n");
	return 0;
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