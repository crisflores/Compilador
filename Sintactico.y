%{
	#include <stdio.h>
	#include <stdbool.h>
	#include <string.h>
	#include <stdarg.h>
	#include <math.h>
	#include <stdlib.h>
	#include <errno.h>
	#include "y.tab.h"

	#define SIN_MEMORIA 0
	#define DATO_DUPLICADO 0
	#define TODO_BIEN 1
	#define PILA_VACIA 0
	#define COLA_VACIA 0
	#define TAM 35
	#define NUMERO_INICIAL_TERCETO 10

	// funciones de Flex y Bison
	// --------------------------------------------------------
	extern void yyerror(const char *mensaje);
	extern char error_mensaje[1000];
	extern int yylex(void);
	extern char * yytext;
	extern long int yylineno;
	FILE *yyin;

	typedef struct
	{
			char clave[TAM];
			char tipodato[TAM];
			char valor[TAM];
			char longitud[TAM];
	} info_t;

	typedef struct sNodo
	{
			info_t info;
			struct sNodo *sig;
	} nodo_t;

	typedef nodo_t *lista_t;

	typedef struct
	{
		char descripcion[TAM];
	} info_pila_t;

	typedef struct sNodoPila
	{
		info_pila_t info;
		struct sNodoPila *sig;
	} nodo_pila_t;
	
	typedef nodo_pila_t *pila_t;

	typedef struct
	{
		char descripcion[TAM];
		char posicion_a[TAM];
		char posicion_b[TAM];
		char posicion_c[TAM];
	} info_cola_t;

	typedef struct sNodoCola
	{
		info_cola_t info;
		struct sNodoCola *sig;
	} nodo_cola_t;

	typedef struct
	{
		nodo_cola_t *pri, *ult;
	} cola_t;

	void crear_cola(cola_t *c);
	int poner_en_cola(cola_t *c, info_cola_t *d);
	int sacar_de_cola(cola_t *c, info_cola_t *d);
	void crear_pila(pila_t *p);
	int poner_en_pila(pila_t *p, info_pila_t *d);
	int sacar_de_pila(pila_t*p, info_pila_t *d);
	void crear_lista(lista_t *p);
	int insertar_en_orden(lista_t *p, info_t *d);
	int sacar_repetidos(lista_t *p, info_t *d, int (*cmp)(info_t*d1, info_t*d2), int elimtodos);
	void guardar_lista(lista_t *p, FILE *arch);
	int comparar(info_t*d1, info_t*d2);
	void clear_ts();
	void crear_ts(lista_t *l_ts);
	int insertar_en_ts(lista_t *l_ts, info_t *d);
	void validar_id(char *id);
	char *guion_cadena(char cad[TAM]);
	int crearTerceto(info_cola_t *info_terceto);
	// le agrega los corchetes al número de terceto, osea entra 10 y sale [10]
	char *normalizarPunteroTerceto(int terceto_puntero);
	void clear_intermedia();
	void crear_intermedia(cola_t *cola_intermedia);
	void guardar_intermedia(cola_t *p, FILE *arch);

	lista_t l_ts;
	info_t d;
	cola_t cola_tipo_id;
	info_cola_t info_tipo_id;
	char cadena[TAM+1];
 	extern const int MAX_STRING_LENGTH;

	// forma del terceto
	// [numero_terceto] = crearTerceto(terceto_a, terceto_b, terceto_c)
	char char_puntero_terceto[TAM];
	int numero_terceto = NUMERO_INICIAL_TERCETO;
	cola_t cola_terceto;
	info_cola_t terceto_info_asignacion;
	info_cola_t terceto_info_expresion;
	info_cola_t terceto_info_termino;
	info_cola_t terceto_info_factor;
	int terceto_asignacion;
	int terceto_expresion;
	int terceto_termino;
	int terceto_factor;
%}

%locations
%start start
%token INLIST
%token FILTER
%token OPERANDO_FILTER
%token REPEAT
%token ENDREPEAT
%token IF
%token ELSE
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
		declaraciones programa 
		;

	declaraciones:	
		VAR setencias_de_declaraciones ENDVAR
		;

	declaraciones:
		;

	setencias_de_declaraciones:
		setencia_declaracion
		;

	setencias_de_declaraciones:
		setencias_de_declaraciones setencia_declaracion
		;

	setencia_declaracion:
		CORCHETE_ABRE declaracion CORCHETE_CIERRA
		;

	declaracion:
		tipo_id CORCHETE_CIERRA DOS_PUNTOS CORCHETE_ABRE ID	{
			validar_id(yytext);
			sacar_de_cola(&cola_tipo_id, &info_tipo_id);
			strcpy(d.clave, yytext);
			strcpy(d.tipodato, info_tipo_id.descripcion);
			insertar_en_ts(&l_ts, &d);
		} 	
		;

	declaracion:
		tipo_id COMA declaracion COMA ID {
			validar_id(yytext);
			sacar_de_cola(&cola_tipo_id, &info_tipo_id);
			strcpy(d.clave, yytext);
			strcpy(d.tipodato, info_tipo_id.descripcion);
			insertar_en_ts(&l_ts, &d);
		}
		;

	tipo_id:
		INTEGER {
			strcpy(info_tipo_id.descripcion, yytext);
			poner_en_cola(&cola_tipo_id, &info_tipo_id);
		} 
		;

	tipo_id:
		FLOAT {
			strcpy(info_tipo_id.descripcion, yytext);
			poner_en_cola(&cola_tipo_id, &info_tipo_id);
		} 
		;

	tipo_id:
		STRING {
			strcpy(info_tipo_id.descripcion, yytext);
			poner_en_cola(&cola_tipo_id, &info_tipo_id);
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
		asignacion
		;

	sentencia:
		seleccion
		;

	sentencia:
		entrada
		;

	sentencia:
		salida
		;

	sentencia:
		ciclo
		;

	sentencia:
		filtro
		;

	sentencia:
		en_lista
		;

	en_lista:
		INLIST PARENTESIS_ABRE ID PUNTO_Y_COMA CORCHETE_ABRE lista_expresiones_inlist CORCHETE_CIERRA PARENTESIS_CIERRA
		;

	filtro:
		FILTER PARENTESIS_ABRE condicion_filter COMA CORCHETE_ABRE lista_variables_filter CORCHETE_CIERRA PARENTESIS_CIERRA
		;

	ciclo:
		REPEAT PARENTESIS_ABRE condicion PARENTESIS_CIERRA programa ENDREPEAT
		;

	salida:
		PRINT ID 
		;

	salida:
		PRINT CONSTANTE_STRING
		;

	entrada:
		READ ID
		;

	seleccion:
		IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA programa seleccion_con_else
		;

	seleccion_con_else:
		ENDIF { /* es un if sin else */ }
		;

	seleccion_con_else:
		ELSE programa ENDIF
		;

	condicion:
		comparacion
		;

	condicion:
		comparacion AND comparacion
		;

	condicion:
		comparacion OR comparacion
		;

	condicion:
		NOT comparacion
		;

	comparacion: 
		en_lista
		;

	comparacion:
		expresion IGUAL_A expresion
		;

	comparacion:
		expresion MENOR_A expresion
		;

	comparacion:
		expresion MENOR_IGUAL_A expresion
		;

	comparacion:
		expresion MAYOR_A expresion
		;

	comparacion:
		expresion MAYOR_IGUAL_A expresion
		;

	comparacion:
		expresion DISTINTA_A expresion
		;

	condicion_filter:
		comparacion_filter
		;

	condicion_filter:
		comparacion_filter AND comparacion_filter
		;

	condicion_filter:
		comparacion_filter OR comparacion_filter
		;

	condicion_filter:
		NOT comparacion_filter
		;

	comparacion_filter:
		OPERANDO_FILTER IGUAL_A expresion
		;

	comparacion_filter:
		OPERANDO_FILTER MENOR_A expresion
		;

	comparacion_filter:
		OPERANDO_FILTER MENOR_IGUAL_A expresion
		;

	comparacion_filter:
		OPERANDO_FILTER MAYOR_A expresion
		;

	comparacion_filter:
		OPERANDO_FILTER MAYOR_IGUAL_A expresion
		;

	comparacion_filter:
		OPERANDO_FILTER DISTINTA_A expresion
		;

	lista_variables_filter:
		variable_filter
		;

	lista_variables_filter:
		variable_filter COMA lista_variables_filter
		;

	variable_filter:
		ID
		;

	lista_expresiones_inlist:
		expresion
		;

	lista_expresiones_inlist:
		expresion PUNTO_Y_COMA lista_expresiones_inlist
		;

	asignacion:
		ID {
			strcpy(terceto_info_asignacion.posicion_b, yytext);
		} OP_ASIGNACION {
			strcpy(terceto_info_asignacion.posicion_a, yytext);
		} expresion {
			strcpy(terceto_info_asignacion.posicion_c, normalizarPunteroTerceto(terceto_expresion));
			// crea un terceto con la forma (":=", ID, [10])
			// donde [10] es un ejemplo de terceto_expresion
			crearTerceto(&terceto_info_asignacion);
		}
		;

	expresion:
		expresion {
			strcpy(terceto_info_expresion.posicion_b, normalizarPunteroTerceto(terceto_expresion));
		} SUMA {			
			strcpy(terceto_info_expresion.posicion_a, yytext);
		} termino {
			strcpy(terceto_info_expresion.posicion_c, normalizarPunteroTerceto(terceto_termino));
			terceto_expresion = crearTerceto(&terceto_info_expresion);
		}
		;

	expresion:
		termino {
			terceto_expresion = terceto_termino;
		}
		;
	
	termino:
		termino {
			strcpy(terceto_info_termino.posicion_b, normalizarPunteroTerceto(terceto_termino));
		} MULTIPLICACION {
			strcpy(terceto_info_termino.posicion_a, yytext);
		} factor {
			strcpy(terceto_info_termino.posicion_c, normalizarPunteroTerceto(terceto_factor));
			terceto_termino = crearTerceto(&terceto_info_termino); 
		}
		;
	
	termino:
		factor {
			terceto_termino = terceto_factor;
		}
		;

	factor:
		PARENTESIS_ABRE expresion PARENTESIS_CIERRA {
			terceto_factor = terceto_expresion;
		}
		;

	factor:
		ID {
			strcpy(terceto_info_factor.posicion_a, yytext);
			strcpy(terceto_info_factor.posicion_b, "_");
			strcpy(terceto_info_factor.posicion_c, "_");
			terceto_factor = crearTerceto(&terceto_info_factor);
		}
		;

	factor:
		CONSTANTE_STRING {
			strcpy(terceto_info_factor.posicion_a, yytext);
			strcpy(terceto_info_factor.posicion_b, "_");
			strcpy(terceto_info_factor.posicion_c, "_");
			terceto_factor = crearTerceto(&terceto_info_factor);

			strcpy(d.clave, guion_cadena(yytext));
			strcpy(d.valor, yytext);
			strcpy(d.tipodato, "const String");
			sprintf(d.longitud, "%d", strlen(yytext)-2);
			insertar_en_ts(&l_ts, &d);
		}
		;

	factor:
		CONSTANTE_REAL {
			strcpy(terceto_info_factor.posicion_a, yytext);
			strcpy(terceto_info_factor.posicion_b, "_");
			strcpy(terceto_info_factor.posicion_c, "_");
			terceto_factor = crearTerceto(&terceto_info_factor);

			strcpy(d.clave, guion_cadena(yytext));
			strcpy(d.valor, yytext);
			strcpy(d.tipodato, "const Float");
			insertar_en_ts(&l_ts, &d);
		}
		;

	factor:
		CONSTANTE_ENTERA {
			strcpy(terceto_info_factor.posicion_a, yytext);
			strcpy(terceto_info_factor.posicion_b, "_");
			strcpy(terceto_info_factor.posicion_c, "_");
			terceto_factor = crearTerceto(&terceto_info_factor);

			strcpy(d.clave, guion_cadena(yytext));
			strcpy(d.valor, yytext);
			strcpy(d.tipodato, "const Integer");
			insertar_en_ts(&l_ts, &d);
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
		clear_ts();
		clear_intermedia();
		crear_lista(&l_ts);
		crear_cola(&cola_tipo_id);
		crear_cola(&cola_terceto);
		yyparse();
		fclose(yyin);
		crear_ts(&l_ts);
		crear_intermedia(&cola_terceto);
	}
	printf("==============================================================\n");
	printf("analisis-finaliza\n");
	printf("==============================================================\n");
	return 0;
}

void validar_id(char *id) {
	int length = 0;
	while(id[length] != '\0') {			
		length++;
	}
	// mayor a 32 se pone porque las comillas de la constante no cuentan para su tamaño
	if(length > MAX_STRING_LENGTH) {
		sprintf(error_mensaje, "el identificador %s supera los [%d] caracteres permitidos\n", id, MAX_STRING_LENGTH);
		yyerror(error_mensaje);
	}
}

void crear_lista(lista_t *p) {
    *p=NULL;
}

int sacar_repetidos(lista_t *p, info_t *d, int (*cmp)(info_t*d1, info_t*d2), int elimtodos) {
	nodo_t*aux;
	lista_t*q;

	while(*p) {
		q=&(*p)->sig;
		while(*p && *q) {
			if(cmp(&(*p)->info,&(*q)->info)==0) {
				aux=*q;
				*q=aux->sig;
				free(aux);
			} else
				q=&(*q)->sig;
		}
		p=&(*p)->sig;
	}

	return TODO_BIEN;
}

int insertar_en_orden(lista_t *p, info_t *d) {
	nodo_t*nue;
	while(*p && comparar(&(*p)->info,d)>0)
			p=&(*p)->sig;

	if(*p && (((*p)->info.clave)-(d->clave))==0) {
		(*p)->info=(*d);
		return DATO_DUPLICADO;
	}

	nue=(nodo_t*)malloc(sizeof(nodo_t));
	if(nue==NULL)
			return SIN_MEMORIA;

	nue->info=*d;
	nue->sig=*p;
	*p=nue;

	return TODO_BIEN;
}

int comparar(info_t *d1, info_t *d2) {
	return strcmp(d1->clave,d2->clave);
}

char *guion_cadena(char cad[TAM]) {
	char guion[TAM+1]="_" ;
	strcat(guion,cad);
	strcpy(cadena,guion);
	return cadena;
}

void crear_pila(pila_t *p) {
	*p=NULL;
}

int poner_en_pila(pila_t *p, info_pila_t *d) {
	nodo_pila_t *nue=(nodo_pila_t*)malloc(sizeof(nodo_pila_t));

	if(nue==NULL)
		return SIN_MEMORIA;

	nue->info=*d;
	nue->sig=*p;
	*p=nue;

	return TODO_BIEN;
}


int sacar_de_pila(pila_t *p, info_pila_t *d) {
	nodo_pila_t *aux;

	if(*p==NULL)
		return PILA_VACIA;

	aux=*p;
	*d=aux->info;
	*p=aux->sig;
	free(aux);

	return TODO_BIEN;
}

void crear_cola(cola_t *c) {
	c->pri=NULL;
	c->ult=NULL;
}

int poner_en_cola(cola_t *c, info_cola_t *d) {
	nodo_cola_t *nue=(nodo_cola_t*)malloc(sizeof(nodo_cola_t));

	if(nue==NULL)
		return SIN_MEMORIA;

	nue->info=*d;
	nue->sig=NULL;
	if(c->ult==NULL)
		c->pri=nue;
	else
		c->ult->sig=nue;

	c->ult=nue;

	return TODO_BIEN;
}

int sacar_de_cola(cola_t *c, info_cola_t *d) {
	nodo_cola_t *aux;

	if(c->pri==NULL)
		return COLA_VACIA;

	aux=c->pri;
	*d=aux->info;
	c->pri=aux->sig;
	free(aux);

	if(c->pri==NULL)
		c->ult=NULL;

	return TODO_BIEN;
}

void guardar_lista(lista_t *p, FILE *arch) {
	// titulos
	fprintf(arch,"%-35s %-16s %-35s %-35s", "NOMBRE", "TIPO DE DATO", "VALOR", "LONGITUD");
	// datos
	while(*p) {
		fprintf(arch,"\n%-35s %-16s %-35s %-35s", (*p)->info.clave, (*p)->info.tipodato, (*p)->info.valor, (*p)->info.longitud);
		p=&(*p)->sig;
	}
}

// limpiar una ts de una ejecución anterior
void clear_ts() {
	FILE *arch=fopen("ts.txt","w");
	fclose(arch);
}

void crear_ts(lista_t *l_ts) {
	info_t aux;
	FILE *arch=fopen("ts.txt","w");
	printf("\n");
	printf("creando tabla de simbolos...\n");
	guardar_lista(l_ts, arch);
	fclose(arch);
	printf("tabla de simbolos creada\n");
}

int insertar_en_ts(lista_t *l_ts, info_t *d) {
	insertar_en_orden(l_ts,d);
	sacar_repetidos(l_ts,d,comparar,0);
	strcpy(d->clave,"\0");
	strcpy(d->tipodato,"\0");
	strcpy(d->valor,"\0");
	strcpy(d->longitud,"\0");
}

int crearTerceto(info_cola_t *info_terceto) {
	printf(
		"[%d] crearTerceto(%s, %s, %s)\n",
		numero_terceto,
		info_terceto->posicion_a, 
		info_terceto->posicion_b, 
		info_terceto->posicion_c);
	poner_en_cola(&cola_terceto, info_terceto);
	return numero_terceto++;
}

char *normalizarPunteroTerceto(int terceto_puntero) {
	char_puntero_terceto[0] = '\0';
	sprintf(char_puntero_terceto, "[%d]", terceto_puntero);
	return char_puntero_terceto;
}

// limpiar una intermedia de una ejecución anterior
void clear_intermedia() {
	FILE *arch=fopen("intermedia.txt","w");
	fclose(arch);
}

void crear_intermedia(cola_t *cola_intermedia) {
	info_t aux;
	FILE *arch=fopen("intermedia.txt","w");
	printf("\n");
	printf("creando intermedia...\n");
	guardar_intermedia(cola_intermedia, arch);
	fclose(arch);
	printf("intermedia creada\n");
}

void guardar_intermedia(cola_t *p, FILE *arch) {
	int numero = NUMERO_INICIAL_TERCETO;
	info_cola_t info_terceto;
	while(sacar_de_cola(&cola_terceto, &info_terceto) != COLA_VACIA) {
		if(numero > NUMERO_INICIAL_TERCETO) {
			fprintf(arch, "\n");
		}
		fprintf(arch,"[%d] (%s, %s, %s)", 
			numero++, 
			info_terceto.posicion_a,
			info_terceto.posicion_b,
			info_terceto.posicion_c
		);
	}
}