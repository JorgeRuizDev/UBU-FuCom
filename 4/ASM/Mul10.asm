	;Autores: Jorge Ruiz G�mez & Pablo Sagredo Abad | (203)
	;Fecha:	09/04/19
	;Versi�n:
	;	1.0: Multiplicaci�n funcional con 13 y 3, dando el resultado en hexadecimal en la posici�n 1203H
	;		Funciona con valores de 7 bits, si el n�mero de ciclos del bucle es 8 y el resultado
	;			no es mayor a 8 bits
	;
	;
	;
	;
	;------------------------------------------------------------------------------------------------------
	;
	;	Instrucciones: Introduzca los valores a multiplicar en las instrucciones MVI M,X del bloque de entrada, 
	;			sustituyendo por un n�mero.
	;			
	;			Anule la instrucci�n MVI con un ; antes del compilado (O tras este modificando los valores de memoria)
	;			para introducir los datos mediante teclado en las posiciones 1200H y 1201H
	;
	;
	;------------------------------------------------------------------------------------------------------
	;	
	;	Direcciones:
	;	1200H y 1201H:	Operandos
	;	
	;	1202H:		Direcci�n temporal de almacenamiento del desplazamiento a la derecha del Operando 2 para saber el carry/tipo de salto a ejecutar
	;
	;	1203H:		Resultado + almacenamiento temporal del resultado
	;
	;	1204H:		Ciclos del bucle
	;
	;	1205H:		Direcci�n temporal para almacenar el desplazamiento del Operando 1 (1200H)
	;
	;------------------------------------------------------------------------------------------------------
	;Programa

	.ORG 1000H		;Direcci�n de memoria inicial (.ORG para simulador y ORG ensamblador)

;entrada---------------------------------------------------------------------------------

	LXI H,1200H	;Direcci�n de memoria donde se encuentra el primer n�mero
	MVI M,13     	;N�mero a introducir en la direcci�n anterior en BCD

	LXI H,1201H 	;Direcci�n de memoria donde se encuentra el segundo n�mero
	MVI M,3    	;N�mero a introducir en la direcci�n anterior en BCD

;FinEntrada------------------------------------------------------------------------------

	LXI H,1204H		;Carga el n�mero de ciclos al acumulador
	MVI M,5H		;Direcci�n de almacenamiento del contador de ciclo/bucle 

	LXI H,1203H 		;Elimina valores basura en 1203 para poder sumar correctamente los valores
	MVI M,0  

;Copias de datos para mantener los originales
	LDA 1201H 
	STA 1202H		;Crea una copia de 1200H y la guarda en 1203H. 
				;Aqu� vamos a almacenar el n�mero cada vez que lo dividimos entre 2/desplazamos derecha

	LDA 1200H		;Crea una copia del primer valor
	STA 1205H		;Esta la vamos a usar para sumarla al valor original (1200h), pero esta va a ser multiplicada x2 cada ciclo de all


;-----------------------------------------------------------------------------------
;ALL: Desplazamiento lateral del operando 2, y sentencia alternativa si el bit de acarreo es 1 o 0

ALL:	LDA 1202H 	;Carga el primer n�mero al acumulador
	RRC		;Rota el programa para cargar el bit de la derecha del acumulador en el acarreo
	STA 1202H 	;Guarda el acumulador una vez rotado

	JNC CONT	;Si el bit en Carry es 0 ejecutamos el c�digo de CERO
	JMP CUNO	;Si el bit en el Carry es 1, el programa salta a CUNO

;-----------------------------------------------------------------------------------
;CUNO: Si el flag del acarreo est� encendido, suma al valor de 1203H uno de los desplazamientos del Operando 1

CUNO:	LDA 1203H 	;Carga de nuevo el n�mero a operar en el acumulador.
	LXI H,1205H
	ADD M
	STA 1203H 	;Guarda en 1203H el resultado actual
	JMP CONT

;-----------------------------------------------------------------------------------
;Funci�n Contador, repite el proceso x veces (X = 1204H) + Desplazamiento lateral del operando 2

CONT:	LDA 1205H	;
	RLC		;Desplazamiento lateral a la derecha del operando 2, valor temporal en 1205H
	STA 1205H	;

	LDA 1204H
	DCR A		;Decrementa en 1 el n�mero
	CPI 00		;Compara el resultado del acumulador con un n�mero X (CPI XX)
	STA 1204H	

	JNZ ALL		;Hasta que el n�mero de ciclos final no sea 0, el programa no para (Vuelve a ALL)



	;Fin de ejecuci�n (Simulador)
	HLT

	;Fin de ejecuci�n (Ensamblador)
	;RST 1
	;END