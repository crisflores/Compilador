%{
	#include <stdio.h>
	#include <stdbool.h>
	#include <string.h>
	#include "y.tab.h"

	// funciones de Flex y Bison
	// --------------------------------------------------------
	extern void yyerror(const char *mensaje);
	extern int yylex(void);

	// variables de Flex y Bison
	// --------------------------------------------------------
	extern char * yytext;
	FILE *yyin;
%}

%locations
%start start
%token REPEAT
%token IF
%token PRINT
%token READ
%token VAR
%token ENDVAR
%token INTEGER
%token FLOAT
%token ID
%token CONSTANTE_ENTERA
%token CONSTANTE_REAL
%token CONSTANTE_STRING
%token COMA
%token OP_ASIGNACION
%token DOS_PUNTOS
%token PARENTESIS_ABRE
%token PARENTESIS_CIERRA
%token CORCHETE_ABRE
%token CORCHETE_CIERRA

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
		tipo_id CORCHETE_CIERRA DOS_PUNTOS CORCHETE_ABRE ID		
		;

	declaracion:
		tipo_id COMA declaracion COMA ID
		;

	tipo_id:
		INTEGER {
			printf("tipo_id-%s\n", yytext);
		} 
		;

	tipo_id:
		FLOAT {
			printf("tipo_id-%s\n", yytext);
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
	
	asignacion:
		{
			printf("asignacion\n");
		} ID OP_ASIGNACION operando_asignable
		;

	operando_asignable:
		ID {
			printf("operando_asignable-%s\n", yytext);
		}
		;

	operando_asignable:
		CONSTANTE_STRING {
			printf("operando_asignable-%s\n", yytext);
		}
		;

	operando_asignable:
		CONSTANTE_REAL {
			printf("operando_asignable-%s\n", yytext);
		}
		;

	operando_asignable:
		CONSTANTE_ENTERA {
			printf("operando_asignable-%s\n", yytext);
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