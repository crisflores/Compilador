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
	#define __FILTER_INDEX "__FILTER_INDEX"
	#define __FILTER_OPERANDO "__FILTER_OPERANDO"
	#define __INLIST_RETURN "__INLIST_RETURN"

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
		int numero_terceto;
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
	void leerTerceto(int numero_terceto, info_cola_t *info_terceto_output);
	void modificarTerceto(int numero_terceto, info_cola_t *info_terceto_input);
	char *invertirOperadorLogico(char *operador_logico);
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
	info_cola_t terceto_asignacion;
	info_cola_t terceto_expresion;
	info_cola_t terceto_termino;
	info_cola_t terceto_factor;
	info_cola_t terceto_if;
	info_cola_t terceto_cmp;
	info_cola_t	terceto_operador_logico;
	info_cola_t	terceto_repeat;
	info_cola_t	terceto_filter;
	info_cola_t	terceto_inlist;
	info_cola_t	terceto_print;
	info_cola_t	terceto_read;
	int p_terceto_expresion;
	int p_terceto_termino;
	int p_terceto_factor;
	int p_terceto_fin_then;
	int p_terceto_if_then;
	int p_terceto_endif;
	int p_terceto_repeat;
	int p_terceto_repeat_then;
	int p_terceto_endrepeat;
	int p_terceto_filter_salto_lista;
	int p_terceto_filter_index;
	int p_terceto_filter_operando;
	int p_terceto_filter_then;
	int p_terceto_filter_lista;
	int p_terceto_filter_cmp;
	int p_terceto_filter_salto_id_siguiente;
	int p_terceto_filter_fin;
	int p_terceto_inlist_id;
	int p_terceto_inlist_salto_a_fin;
	int p_terceto_inlist_fin;
	int p_terceto_inlist_iguales;
	pila_t comparaciones;
	info_pila_t comparador;
	pila_t comparaciones_or;
	info_pila_t comparacion_or;
	pila_t comparaciones_and;
	info_pila_t comparacion_and;
	pila_t saltos_incondicionales;
	info_pila_t salto_incondicional;
	pila_t repeats;
	info_pila_t inicio_repeat;
	pila_t inlist_comparaciones;
	info_pila_t inlist_comparacion;
	int _filter_index; 
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
		VAR ENDVAR
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
		INLIST {
			strcpy(terceto_inlist.posicion_a, yytext);
			strcpy(terceto_inlist.posicion_b, "_");
			strcpy(terceto_inlist.posicion_c, "_");
			crearTerceto(&terceto_inlist);

			// si el ID está en las lista "__INLIST_RETURN" vale 1, si no vale 0
			strcpy(d.clave, __INLIST_RETURN);
			strcpy(d.tipodato, "Integer");
			strcpy(d.valor, "0");
			insertar_en_ts(&l_ts, &d);

			// inicializar __INLIST_RETURN en cero
			strcpy(terceto_inlist.posicion_a, ":=");
			strcpy(terceto_inlist.posicion_b, __INLIST_RETURN);
			strcpy(terceto_inlist.posicion_c, "0");
			crearTerceto(&terceto_inlist);
		} PARENTESIS_ABRE ID {
			strcpy(terceto_inlist.posicion_a, yytext);
			strcpy(terceto_inlist.posicion_b, "_");
			strcpy(terceto_inlist.posicion_c, "_");
			p_terceto_inlist_id = crearTerceto(&terceto_inlist);
		} PUNTO_Y_COMA CORCHETE_ABRE lista_expresiones_inlist CORCHETE_CIERRA PARENTESIS_CIERRA {
			info_cola_t terceto;

			// terminó todas las comparaciones, salta al fin del INLIST
			strcpy(terceto_inlist.posicion_a, "BRA");
			strcpy(terceto_inlist.posicion_b, "_");
			strcpy(terceto_inlist.posicion_c, "_");
			p_terceto_inlist_salto_a_fin = crearTerceto(&terceto_inlist);

			// acá salta si una comparación dió que son iguales
			strcpy(terceto_inlist.posicion_a, ":=");
			strcpy(terceto_inlist.posicion_b, __INLIST_RETURN);
			strcpy(terceto_inlist.posicion_c, "1");
			p_terceto_inlist_iguales = crearTerceto(&terceto_inlist);
			while(sacar_de_pila(&inlist_comparaciones, &inlist_comparacion) != PILA_VACIA) {
				leerTerceto(inlist_comparacion.numero_terceto, &terceto);
				strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_inlist_iguales));
				modificarTerceto(inlist_comparacion.numero_terceto, &terceto);
			}

			strcpy(terceto_inlist.posicion_a, "ENDINLIST");
			strcpy(terceto_inlist.posicion_b, "_");
			strcpy(terceto_inlist.posicion_c, "_");
			p_terceto_inlist_fin = crearTerceto(&terceto_inlist);
			leerTerceto(p_terceto_inlist_salto_a_fin, &terceto);
			strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_inlist_fin));
			modificarTerceto(p_terceto_inlist_salto_a_fin, &terceto);
		}
		;

	filtro:
		FILTER {
			strcpy(terceto_filter.posicion_a, yytext);
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			crearTerceto(&terceto_filter);
			
			// variable de compilador __FILTER_INDEX
			// la agregamos a la ts y al código intermedio
			strcpy(d.clave, __FILTER_INDEX);
			strcpy(d.tipodato, "Integer");
			strcpy(d.valor, "0");
			insertar_en_ts(&l_ts, &d);
			// inicializar __FILTER_INDEX en cero
			strcpy(terceto_filter.posicion_a, ":=");
			strcpy(terceto_filter.posicion_b, __FILTER_INDEX);
			strcpy(terceto_filter.posicion_c, "0");
			crearTerceto(&terceto_filter);
			// este branch salta a la primer variable del listado (apilamos la posición del terceto)
			// y luego seteamos al terceto la posición a la que debe saltar
			strcpy(terceto_filter.posicion_a, "BRA");
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_salto_lista = crearTerceto(&terceto_filter);

			strcpy(terceto_filter.posicion_a, "THEN");
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_then = crearTerceto(&terceto_filter);

			// cada vez que entra al THEN, aumentamos el indice en uno
			strcpy(terceto_filter.posicion_a, "+");
			strcpy(terceto_filter.posicion_b, __FILTER_INDEX);
			strcpy(terceto_filter.posicion_c, "1");
			p_terceto_filter_index = crearTerceto(&terceto_filter);
			strcpy(terceto_filter.posicion_a, ":=");
			strcpy(terceto_filter.posicion_b, __FILTER_INDEX);
			strcpy(terceto_filter.posicion_c, normalizarPunteroTerceto(p_terceto_filter_index));
			crearTerceto(&terceto_filter);

		} PARENTESIS_ABRE condicion_filter COMA CORCHETE_ABRE {
			info_cola_t terceto;

			// agregar terceto inicio de lista de variables
			strcpy(terceto_filter.posicion_a, "LISTA");
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_lista = crearTerceto(&terceto_filter);	

			// la primera condición de un AND, salta directo a la LISTA del FILTER, si es falsa
			// leer terceto con el salto de la comparacion del AND
			if(sacar_de_pila(&comparaciones_and, &comparacion_and) != PILA_VACIA) {
				leerTerceto(comparacion_and.numero_terceto, &terceto);
				// asignar al operador lógico el terceto al que debe saltar
				strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_filter_lista));
				modificarTerceto(comparacion_and.numero_terceto, &terceto);
			}

			// modificar el terceto que salta a la lista de variables
			// ya que ahora sabemos la posición que empieza la lista
			leerTerceto(p_terceto_filter_salto_lista, &terceto);
			strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_filter_lista));
			modificarTerceto(p_terceto_filter_salto_lista, &terceto);

			// empezamos a agregar ID al código intermedio
			// desde el listado de variables de la sentencia filter 
			_filter_index = 0;
			// inicializar puntero a comparación de variables
			p_terceto_filter_salto_id_siguiente = -1;
		} lista_variables_filter CORCHETE_CIERRA PARENTESIS_CIERRA {
			info_cola_t terceto;

			strcpy(terceto_filter.posicion_a, "ENDFILTER");
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_fin = crearTerceto(&terceto_filter);

			// acá salta si ya evaluamos todas las variables y ninguna cumple la condición
			leerTerceto(p_terceto_filter_salto_id_siguiente, &terceto);
			strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_filter_fin));
			modificarTerceto(p_terceto_filter_salto_id_siguiente, &terceto);

			// acá se salta si evaluamos una variable y cumple la condición
			// por cada comparación que se haga en la condición
			int compraciones_condicion = 1;
			while(compraciones_condicion) {
				compraciones_condicion--;
				// desapilar y escribir la posición a la que se debe saltar 
				// si no se cumple la condición del if
				sacar_de_pila(&comparaciones, &comparador);
				leerTerceto(comparador.numero_terceto, &terceto);
				if (strcmp(terceto.posicion_b, "OR") == 0) {
					// si es una condición OR tiene más comparaciones para desapilar
					compraciones_condicion++;
				}
				// asignar al operador (por ejemplo un "BNE") el terceto al que debe saltar
				strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_filter_fin));
				modificarTerceto(comparador.numero_terceto, &terceto);				
			}
		}
		;

	ciclo:
		REPEAT {
			// apilar el inicio repeat para poder saltar a esta posición
			// cuando termina el bucle
			// se apila porque pueden haber REPEAT anidados
			strcpy(terceto_repeat.posicion_a, yytext);
			strcpy(terceto_repeat.posicion_b, "_");
			strcpy(terceto_repeat.posicion_c, "_");
			inicio_repeat.numero_terceto = crearTerceto(&terceto_repeat);
			poner_en_pila(&repeats, &inicio_repeat);
		} PARENTESIS_ABRE condicion PARENTESIS_CIERRA {
			// acá salta si se cumple la primer condición de un OR
			info_cola_t terceto;

			// inicio del programa del IF
			strcpy(terceto_repeat.posicion_a, "THEN");
			strcpy(terceto_repeat.posicion_b, "_");
			strcpy(terceto_repeat.posicion_c, "_");
			p_terceto_repeat_then = crearTerceto(&terceto_repeat);
			// la primera condición de un OR, salta directo al THEN del IF, si es verdadera
			// leer terceto con el salto de la comparacion del OR
			if(sacar_de_pila(&comparaciones_or, &comparacion_or) != PILA_VACIA) {
				leerTerceto(comparacion_or.numero_terceto, &terceto);
				// asignar al operador lógico el terceto al que debe saltar
				strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_repeat_then));
				modificarTerceto(comparacion_or.numero_terceto, &terceto);
			}
		} programa ENDREPEAT {
			info_cola_t terceto;

			// el ciclo vuelve a chekear la condición siempre que termina el programa del REPEAT
			strcpy(terceto_repeat.posicion_a, "BRA");
			sacar_de_pila(&repeats, &inicio_repeat);
			strcpy(terceto_repeat.posicion_b, normalizarPunteroTerceto(inicio_repeat.numero_terceto));
			strcpy(terceto_repeat.posicion_c, "_");
			crearTerceto(&terceto_repeat);

			// acá salta si no se cumple cualquier condición de un AND
			// o si no se cumple la segunda condición de un OR
			// o si no se cumple una comparación simple (con o sin NOT)
			strcpy(terceto_repeat.posicion_a, yytext);
			strcpy(terceto_repeat.posicion_b, "_");
			strcpy(terceto_repeat.posicion_c, "_");
			p_terceto_endrepeat = crearTerceto(&terceto_repeat);

			// por cada comparación que se haga en la condición
			int compraciones_condicion = 1;
			while(compraciones_condicion) {
				compraciones_condicion--;
				// desapilar y escribir la posición a la que se debe saltar 
				// si no se cumple la condición del if
				sacar_de_pila(&comparaciones, &comparador);
				leerTerceto(comparador.numero_terceto, &terceto);
				if (strcmp(terceto.posicion_b, "AND") == 0) {
					// si es una condición AND tiene más comparaciones para desapilar
					compraciones_condicion++;
				}
				// asignar al operador (por ejemplo un "BNE") el terceto al que debe saltar
				strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_endrepeat));
				modificarTerceto(comparador.numero_terceto, &terceto);				
			}
		}
		;

	salida:
		PRINT ID {
			strcpy(terceto_print.posicion_a, "PRINT");
			strcpy(terceto_print.posicion_b, yytext);
			strcpy(terceto_print.posicion_c, "_");
			crearTerceto(&terceto_print);
		}
		;

	salida:
		PRINT CONSTANTE_STRING {
			strcpy(terceto_print.posicion_a, "PRINT");
			strcpy(terceto_print.posicion_b, yytext);
			strcpy(terceto_print.posicion_c, "_");
			crearTerceto(&terceto_print);
		}
		;

	entrada:
		READ ID {
			strcpy(terceto_print.posicion_a, "READ");
			strcpy(terceto_print.posicion_b, yytext);
			strcpy(terceto_print.posicion_c, "_");
			crearTerceto(&terceto_print);
		}
		;

	seleccion:
		IF {
			strcpy(terceto_if.posicion_a, yytext);
			strcpy(terceto_if.posicion_b, "_");
			strcpy(terceto_if.posicion_c, "_");
			crearTerceto(&terceto_if);
		} PARENTESIS_ABRE condicion PARENTESIS_CIERRA {
			info_cola_t terceto;

			// inicio del programa del IF
			strcpy(terceto_if.posicion_a, "THEN");
			strcpy(terceto_if.posicion_b, "_");
			strcpy(terceto_if.posicion_c, "_");
			p_terceto_if_then = crearTerceto(&terceto_if);
			// la primera condición de un OR, salta directo al THEN del IF, si es verdadera
			// leer terceto con el salto de la comparacion del OR
			if(sacar_de_pila(&comparaciones_or, &comparacion_or) != PILA_VACIA) {
				leerTerceto(comparacion_or.numero_terceto, &terceto);
				// asignar al operador lógico el terceto al que debe saltar
				strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_if_then));
				modificarTerceto(comparacion_or.numero_terceto, &terceto);
			}
		} programa seleccion_fin_then
		;

	seleccion_fin_then:
		ENDIF {
			info_cola_t terceto;

			strcpy(terceto_if.posicion_a, yytext);
			strcpy(terceto_if.posicion_b, "_");
			strcpy(terceto_if.posicion_c, "_");
			p_terceto_fin_then = crearTerceto(&terceto_if);

			// por cada comparación que se haga en la condición
			int compraciones_condicion = 1;
			while(compraciones_condicion) {
				compraciones_condicion--;
				// desapilar y escribir la posición a la que se debe saltar 
				// si no se cumple la condición del if
				if(sacar_de_pila(&comparaciones, &comparador) != PILA_VACIA) {
					leerTerceto(comparador.numero_terceto, &terceto);
					if (strcmp(terceto.posicion_b, "AND") == 0) {
						// si es una condición AND tiene más comparaciones para desapilar
						compraciones_condicion++;
					}
					// asignar al operador (por ejemplo un "BNE") el terceto al que debe saltar
					strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_fin_then));
					modificarTerceto(comparador.numero_terceto, &terceto);
				}				
			}
		}
		;

	seleccion_fin_then:
		ELSE {
			info_cola_t terceto;

			// al finalizar el "THEN" se salta incondicionalmente al ENDIF
			strcpy(terceto_if.posicion_a, "BRA");
			strcpy(terceto_if.posicion_b, "_");
			strcpy(terceto_if.posicion_c, "_");
			salto_incondicional.numero_terceto = crearTerceto(&terceto_if);
			poner_en_pila(&saltos_incondicionales, &salto_incondicional);

			// agregar terceto con el "ELSE"
			strcpy(terceto_if.posicion_a, yytext);
			strcpy(terceto_if.posicion_b, "_");
			strcpy(terceto_if.posicion_c, "_");
			p_terceto_fin_then = crearTerceto(&terceto_if);

			// por cada comparación que se haga en la condición
			int compraciones_condicion = 1;
			while(compraciones_condicion) {
				compraciones_condicion--;
				// desapilar y escribir la posición a la que se debe saltar 
				// si no se cumple la condición del if
				sacar_de_pila(&comparaciones, &comparador);
				leerTerceto(comparador.numero_terceto, &terceto);
				if (strcmp(terceto.posicion_b, "AND") == 0) {
					// si es una condición AND tiene más comparaciones para desapilar
					compraciones_condicion++;
				}
				// asignar al operador (por ejemplo un "BNE") el terceto al que debe saltar
				strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_fin_then));
				modificarTerceto(comparador.numero_terceto, &terceto);				
			}
		} programa ENDIF {
			info_cola_t terceto;

			strcpy(terceto_if.posicion_a, yytext);
			strcpy(terceto_if.posicion_b, "_");
			strcpy(terceto_if.posicion_c, "_");
		  p_terceto_endif =	crearTerceto(&terceto_if);

			sacar_de_pila(&saltos_incondicionales, &salto_incondicional);
			leerTerceto(salto_incondicional.numero_terceto, &terceto);
			strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_endif));
			modificarTerceto(salto_incondicional.numero_terceto, &terceto);
		}
		;

	condicion:
		comparacion {			
			// crear terceto con el "CMP"			
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			strcpy(terceto_operador_logico.posicion_b, "_"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar el terceto por false
			comparador.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones, &comparador);
		}
		;

	condicion:
		comparacion {			
			// crear terceto con el "CMP"
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			strcpy(terceto_operador_logico.posicion_b, "_"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar por false
			comparador.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones, &comparador);
		} AND comparacion {
			// crear terceto con el "CMP"
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			// si es un AND lo indicamos para saber que la condición tiene doble comparación
			strcpy(terceto_operador_logico.posicion_b, "AND"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar por false
			comparador.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones, &comparador);
		}
		;

	condicion: 
		comparacion {			
			// crear terceto con el "CMP"
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			// como es un OR debemos invertir el operador ya que por true, va directo al "THEN" del "IF"
			// sin evaluar la segunda condición
			strcpy(terceto_operador_logico.posicion_a, invertirOperadorLogico(terceto_operador_logico.posicion_a));
			strcpy(terceto_operador_logico.posicion_b, "_"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar por false
			comparacion_or.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones_or, &comparacion_or);
		} OR comparacion {			
			// crear terceto con el "CMP"
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			strcpy(terceto_operador_logico.posicion_b, "_"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar por false
			comparador.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones, &comparador);
		}
		;

	condicion:
		NOT comparacion {
			// es igual que la comparación sin el NOT
			// pero llamando a "invertirOperadorLogico"

			// crear terceto con el "CMP"			
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			strcpy(terceto_operador_logico.posicion_a, invertirOperadorLogico(terceto_operador_logico.posicion_a));
			strcpy(terceto_operador_logico.posicion_b, "_"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar el terceto por false
			comparador.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones, &comparador);
		}
		;

	comparacion: 
		en_lista {
			// al finalizar la lista, tiene que comprar la variable de compilador con el 
			// return del INLIST osea __INLIST_RETURN con 1, si son distintos sale del IF
			strcpy(terceto_cmp.posicion_a, "CMP");
			strcpy(terceto_cmp.posicion_b, __INLIST_RETURN);
			strcpy(terceto_cmp.posicion_c, "1");
			strcpy(terceto_operador_logico.posicion_a, "BNE");
		}
		;

	comparacion:
		expresion {
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_expresion));
		} IGUAL_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BNE");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	comparacion:
		expresion {
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_expresion));
		} MENOR_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BGE");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	comparacion:
		expresion {
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_expresion));
		} MENOR_IGUAL_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BGT");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	comparacion:
		expresion {
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_expresion));
		} MAYOR_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BLE");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	comparacion:
		expresion {
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_expresion));
		} MAYOR_IGUAL_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BLT");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	comparacion:
		expresion {
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_expresion));
		} DISTINTA_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BEQ");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	condicion_filter:
		comparacion_filter {			
			// agregar el operador filter a la ts
			strcpy(d.clave, __FILTER_OPERANDO);
			insertar_en_ts(&l_ts, &d);					
			// crear terceto con el "CMP"			
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			strcpy(terceto_operador_logico.posicion_a, invertirOperadorLogico(terceto_operador_logico.posicion_a));
			strcpy(terceto_operador_logico.posicion_b, "_"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar el terceto por false
			comparador.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones, &comparador);
		}
		;

	condicion_filter:
		comparacion_filter {
			// agregar el operador filter a la ts
			strcpy(d.clave, __FILTER_OPERANDO);
			insertar_en_ts(&l_ts, &d);
			
			// crear terceto con el "CMP"
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			strcpy(terceto_operador_logico.posicion_b, "_"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar por false
			comparacion_and.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones_and, &comparacion_and);
		} AND comparacion_filter {
			// crear terceto con el "CMP"
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			// si es un AND lo indicamos para saber que la condición tiene doble comparación
			strcpy(terceto_operador_logico.posicion_a, invertirOperadorLogico(terceto_operador_logico.posicion_a));
			strcpy(terceto_operador_logico.posicion_b, "AND"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar por false
			comparador.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones, &comparador);
		}
		;

	condicion_filter:
		comparacion_filter {			
			// agregar el operador filter a la ts
			strcpy(d.clave, __FILTER_OPERANDO);
			insertar_en_ts(&l_ts, &d);

			// crear terceto con el "CMP"
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			strcpy(terceto_operador_logico.posicion_a, invertirOperadorLogico(terceto_operador_logico.posicion_a));
			strcpy(terceto_operador_logico.posicion_b, "_"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar por false
			comparador.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones, &comparador);
		} OR comparacion_filter {
			// crear terceto con el "CMP"
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			strcpy(terceto_operador_logico.posicion_a, invertirOperadorLogico(terceto_operador_logico.posicion_a));
			strcpy(terceto_operador_logico.posicion_b, "OR"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar por false
			comparador.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones, &comparador);
		}
		;

	condicion_filter:
		NOT comparacion_filter {
			// es igual que la comparación sin el NOT
			// pero sin llamar a "invertirOperadorLogico"

			// agregar el operador filter a la ts
			strcpy(d.clave, __FILTER_OPERANDO);
			insertar_en_ts(&l_ts, &d);					
			// crear terceto con el "CMP"			
			crearTerceto(&terceto_cmp);
			// crear terceto del operador de la comparación
			strcpy(terceto_operador_logico.posicion_a, terceto_operador_logico.posicion_a);
			strcpy(terceto_operador_logico.posicion_b, "_"); 
			strcpy(terceto_operador_logico.posicion_c, "_");
			// apilamos la posición del operador, para luego escribir a donde debe saltar el terceto por false
			comparador.numero_terceto = crearTerceto(&terceto_operador_logico);
			poner_en_pila(&comparaciones, &comparador);
		}
		;

	comparacion_filter:
		OPERANDO_FILTER {
			// reemplazar el "_" de la sentencia filter, por una variable del compilador
			strcpy(terceto_filter.posicion_a, __FILTER_OPERANDO);
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_operando = crearTerceto(&terceto_filter);
			// agregar operando al código intermedio
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_filter_operando));
		} IGUAL_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BNE");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	comparacion_filter:
		OPERANDO_FILTER {
			// reemplazar el "_" de la sentencia filter, por una variable del compilador
			strcpy(terceto_filter.posicion_a, __FILTER_OPERANDO);
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_operando = crearTerceto(&terceto_filter);
			// agregar operando al código intermedio
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_filter_operando));
		} MENOR_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BGE");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	comparacion_filter:
		OPERANDO_FILTER {
			// reemplazar el "_" de la sentencia filter, por una variable del compilador
			strcpy(terceto_filter.posicion_a, __FILTER_OPERANDO);
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_operando = crearTerceto(&terceto_filter);
			// agregar operando al código intermedio
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_filter_operando));
		} MENOR_IGUAL_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BGT");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	comparacion_filter:
		OPERANDO_FILTER {
			// reemplazar el "_" de la sentencia filter, por una variable del compilador
			strcpy(terceto_filter.posicion_a, __FILTER_OPERANDO);
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_operando = crearTerceto(&terceto_filter);
			// agregar operando al código intermedio
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_filter_operando));
		} MAYOR_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BLE");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	comparacion_filter:
		OPERANDO_FILTER {
			// reemplazar el "_" de la sentencia filter, por una variable del compilador
			strcpy(terceto_filter.posicion_a, __FILTER_OPERANDO);
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_operando = crearTerceto(&terceto_filter);
			// agregar operando al código intermedio
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_filter_operando));
		} MAYOR_IGUAL_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BLT");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	comparacion_filter:
		OPERANDO_FILTER {
			// reemplazar el "_" de la sentencia filter, por una variable del compilador
			strcpy(terceto_filter.posicion_a, __FILTER_OPERANDO);
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_operando = crearTerceto(&terceto_filter);
			// agregar operando al código intermedio
			strcpy(terceto_cmp.posicion_b, normalizarPunteroTerceto(p_terceto_filter_operando));
		} DISTINTA_A {
			// guardamos el operador para incertarlo luego de crear el terceto del "CMP"
			strcpy(terceto_operador_logico.posicion_a, "BEQ");
			strcpy(terceto_cmp.posicion_a, "CMP");
		} expresion {
			// terceto del "CMP"
			strcpy(terceto_cmp.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
		}
		;

	lista_variables_filter:
		variable_filter {
			info_cola_t terceto;
			char str_filter_index[12];
			sprintf(str_filter_index, "%d", 	_filter_index++);

			// la última variable salta al FIN del FILTER por falso
			strcpy(terceto_filter.posicion_a, "CMP");
			strcpy(terceto_filter.posicion_b, __FILTER_INDEX);
			strcpy(terceto_filter.posicion_c, str_filter_index);
			p_terceto_filter_cmp = crearTerceto(&terceto_filter);
			if(p_terceto_filter_salto_id_siguiente != -1) {
				leerTerceto(p_terceto_filter_salto_id_siguiente, &terceto);
				strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_filter_cmp));
				modificarTerceto(p_terceto_filter_salto_id_siguiente, &terceto);
			}
			strcpy(terceto_filter.posicion_a, "BNE");
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_salto_id_siguiente = crearTerceto(&terceto_filter);
			// asignamos al operando del filter (osea el "_") el valor de 
			// la variable que vamos a evalular con la condición del filter
			strcpy(terceto_filter.posicion_a, ":=");
			strcpy(terceto_filter.posicion_b, __FILTER_OPERANDO);
			strcpy(terceto_filter.posicion_c, yytext);
			crearTerceto(&terceto_filter);
			// vamos a la sentencia de la condición para evaluarla
			strcpy(terceto_filter.posicion_a, "BRA");
			strcpy(terceto_filter.posicion_b, normalizarPunteroTerceto(p_terceto_filter_then));
			strcpy(terceto_filter.posicion_c, "_");
			crearTerceto(&terceto_filter);
		}
		;

	lista_variables_filter:
		lista_variables_filter COMA	variable_filter {
			info_cola_t terceto;
			char str_filter_index[12];
			sprintf(str_filter_index, "%d", 	_filter_index++);

			// preguntamos si hay que evaluar esta variable en la condición del filter
			// para esto nos valemos del valor que tiene el "_filter_index"
			strcpy(terceto_filter.posicion_a, "CMP");
			strcpy(terceto_filter.posicion_b, __FILTER_INDEX);
			strcpy(terceto_filter.posicion_c, str_filter_index);
			p_terceto_filter_cmp = crearTerceto(&terceto_filter);
			if(p_terceto_filter_salto_id_siguiente != -1) {
				// si la comparación falsa, quiere decir que tengo que analizar el siguiente ID
				leerTerceto(p_terceto_filter_salto_id_siguiente, &terceto);
				strcpy(terceto.posicion_b, normalizarPunteroTerceto(p_terceto_filter_cmp));
				modificarTerceto(p_terceto_filter_salto_id_siguiente, &terceto);
			}
			strcpy(terceto_filter.posicion_a, "BNE");
			strcpy(terceto_filter.posicion_b, "_");
			strcpy(terceto_filter.posicion_c, "_");
			p_terceto_filter_salto_id_siguiente = crearTerceto(&terceto_filter);
			// asignamos al operando del filter (osea el "_") el valor de 
			// la variable que vamos a evalular con la condición del filter
			strcpy(terceto_filter.posicion_a, ":=");
			strcpy(terceto_filter.posicion_b, __FILTER_OPERANDO);
			strcpy(terceto_filter.posicion_c, yytext);
			crearTerceto(&terceto_filter);
			// vamos a la sentencia de la condición para evaluarla
			strcpy(terceto_filter.posicion_a, "BRA");
			strcpy(terceto_filter.posicion_b, normalizarPunteroTerceto(p_terceto_filter_then));
			strcpy(terceto_filter.posicion_c, "_");
			crearTerceto(&terceto_filter);
		}
		;

	variable_filter:
		ID
		;

	lista_expresiones_inlist:
		expresion {
			// comprar el puntero a expresión con el del ID
			strcpy(terceto_inlist.posicion_a, "CMP");
			strcpy(terceto_inlist.posicion_b, normalizarPunteroTerceto(p_terceto_inlist_id));
			strcpy(terceto_inlist.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
			crearTerceto(&terceto_inlist);
			strcpy(terceto_inlist.posicion_a, "BEQ");
			strcpy(terceto_inlist.posicion_b, "_");
			strcpy(terceto_inlist.posicion_c, "_");
			// apilar posición, cuando se a donde salta por iguales, desapilo todas
			inlist_comparacion.numero_terceto = crearTerceto(&terceto_inlist);
			poner_en_pila(&inlist_comparaciones, &inlist_comparacion);
		}
		;

	lista_expresiones_inlist:
		lista_expresiones_inlist PUNTO_Y_COMA expresion {
			// comprar el puntero a expresión con el del ID
			strcpy(terceto_inlist.posicion_a, "CMP");
			strcpy(terceto_inlist.posicion_b, normalizarPunteroTerceto(p_terceto_inlist_id));
			strcpy(terceto_inlist.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
			crearTerceto(&terceto_inlist);
			strcpy(terceto_inlist.posicion_a, "BEQ");
			strcpy(terceto_inlist.posicion_b, "_");
			strcpy(terceto_inlist.posicion_c, "_");
			// apilar posición, cuando se a donde salta por iguales, desapilo todas
			inlist_comparacion.numero_terceto = crearTerceto(&terceto_inlist);
			poner_en_pila(&inlist_comparaciones, &inlist_comparacion);
		}
		;

	asignacion:
		ID {
			strcpy(terceto_asignacion.posicion_b, yytext);
		} OP_ASIGNACION {
			strcpy(terceto_asignacion.posicion_a, yytext);
		} expresion {
			strcpy(terceto_asignacion.posicion_c, normalizarPunteroTerceto(p_terceto_expresion));
			// crea un terceto con la forma (":=", ID, [10])
			// donde [10] es un ejemplo de p_terceto_expresion
			crearTerceto(&terceto_asignacion);
		}
		;

	expresion:
		expresion {
			strcpy(terceto_expresion.posicion_b, normalizarPunteroTerceto(p_terceto_expresion));
		} SUMA {			
			strcpy(terceto_expresion.posicion_a, yytext);
		} termino {
			strcpy(terceto_expresion.posicion_c, normalizarPunteroTerceto(p_terceto_termino));
			p_terceto_expresion = crearTerceto(&terceto_expresion);
		}
		;

	expresion:
		termino {
			p_terceto_expresion = p_terceto_termino;
		}
		;
	
	termino:
		termino {
			strcpy(terceto_termino.posicion_b, normalizarPunteroTerceto(p_terceto_termino));
		} MULTIPLICACION {
			strcpy(terceto_termino.posicion_a, yytext);
		} factor {
			strcpy(terceto_termino.posicion_c, normalizarPunteroTerceto(p_terceto_factor));
			p_terceto_termino = crearTerceto(&terceto_termino); 
		}
		;
	
	termino:
		factor {
			p_terceto_termino = p_terceto_factor;
		}
		;

	factor:
		PARENTESIS_ABRE expresion PARENTESIS_CIERRA {
			p_terceto_factor = p_terceto_expresion;
		}
		;

	factor:
		ID {
			strcpy(terceto_factor.posicion_a, yytext);
			strcpy(terceto_factor.posicion_b, "_");
			strcpy(terceto_factor.posicion_c, "_");
			p_terceto_factor = crearTerceto(&terceto_factor);
		}
		;

	factor:
		CONSTANTE_STRING {
			strcpy(terceto_factor.posicion_a, yytext);
			strcpy(terceto_factor.posicion_b, "_");
			strcpy(terceto_factor.posicion_c, "_");
			p_terceto_factor = crearTerceto(&terceto_factor);

			strcpy(d.clave, guion_cadena(yytext));
			strcpy(d.valor, yytext);
			strcpy(d.tipodato, "const String");
			sprintf(d.longitud, "%d", strlen(yytext)-2);
			insertar_en_ts(&l_ts, &d);
		}
		;

	factor:
		CONSTANTE_REAL {
			strcpy(terceto_factor.posicion_a, yytext);
			strcpy(terceto_factor.posicion_b, "_");
			strcpy(terceto_factor.posicion_c, "_");
			p_terceto_factor = crearTerceto(&terceto_factor);

			strcpy(d.clave, guion_cadena(yytext));
			strcpy(d.valor, yytext);
			strcpy(d.tipodato, "const Float");
			insertar_en_ts(&l_ts, &d);
		}
		;

	factor:
		CONSTANTE_ENTERA {
			strcpy(terceto_factor.posicion_a, yytext);
			strcpy(terceto_factor.posicion_b, "_");
			strcpy(terceto_factor.posicion_c, "_");
			p_terceto_factor = crearTerceto(&terceto_factor);

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
		crear_pila(&comparaciones);
		crear_pila(&comparaciones_or);
		crear_pila(&comparaciones_and);
		crear_pila(&saltos_incondicionales);
		crear_pila(&repeats);
		crear_pila(&inlist_comparaciones);
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
		printf("[%d] (%s, %s, %s)\n",
			numero, 
			info_terceto.posicion_a,
			info_terceto.posicion_b,
			info_terceto.posicion_c
		);
		fprintf(arch,"[%d] (%s, %s, %s)", 
			numero++, 
			info_terceto.posicion_a,
			info_terceto.posicion_b,
			info_terceto.posicion_c
		);
	}
}

// recibe un número de terceto y devuelve la info
void leerTerceto(int numero_terceto, info_cola_t *info_terceto_output) {
	int index = NUMERO_INICIAL_TERCETO;
	cola_t aux;
	info_cola_t info_aux;
	
	crear_cola(&aux);
	while(sacar_de_cola(&cola_terceto, &info_aux) != COLA_VACIA) {
		poner_en_cola(&aux, &info_aux);
		if(index == numero_terceto) {
			// encontramos el terceto buscado
			strcpy(info_terceto_output->posicion_a, info_aux.posicion_a);
			strcpy(info_terceto_output->posicion_b, info_aux.posicion_b);
			strcpy(info_terceto_output->posicion_c, info_aux.posicion_c);
		}
		index++;
	}
	while(sacar_de_cola(&aux, &info_aux) != COLA_VACIA) {
		poner_en_cola(&cola_terceto, &info_aux);
	}
}

void modificarTerceto(int numero_terceto, info_cola_t *info_terceto_input) {
	int index = NUMERO_INICIAL_TERCETO;
	cola_t aux;
	info_cola_t info_aux;
	
	crear_cola(&aux);
	while(sacar_de_cola(&cola_terceto, &info_aux) != COLA_VACIA) {
		if(index == numero_terceto) {
			poner_en_cola(&aux, info_terceto_input);
		} else {
			poner_en_cola(&aux, &info_aux);
		}
		index++;
	}
	while(sacar_de_cola(&aux, &info_aux) != COLA_VACIA) {
		poner_en_cola(&cola_terceto, &info_aux);
	}
}

char *invertirOperadorLogico(char *operador_logico) {
	if(strcmp(operador_logico, "BLT") == 0)  {
		return "BGE";
	}
	if(strcmp(operador_logico, "BLE") == 0)  {
		return "BGT";
	}
	if(strcmp(operador_logico, "BGT") == 0)  {
		return "BLE";
	}
	if(strcmp(operador_logico, "BGE") == 0)  {
		return "BLT";
	}
	if(strcmp(operador_logico, "BNE") == 0)  {
		return "BEQ";
	}
	if(strcmp(operador_logico, "BEQ") == 0)  {
		return "BNE";
	}
}