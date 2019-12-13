	;Autores: Jorge Ruiz G�mez & Pablo Sagredo Abad | (203)
	;Fecha:	08/05/19	- Versi�n 2.0
	;Versi�n:
	;	1.0: Multiplicaci�n funcional con el resultado en la posici�n 1203H
	;	2.0 Bucle tabla multiplicaci�n
	;	
	;		Cambios: sustituido cualquier otro uso del par HL que no fuese para incrementar la direcci�n de memoria donde se guarda el resultado
	;				Todo el programa trabaja sobre las direcciones de memoria 1300H+ para poder guardar los datos en la 1201H+
	;				El programa ahora se ejecuta en 1300H+
	;
	;
	;		A�adido: Un nuevo bucle que controla la tabla
	;				Incremento del PAR HL para poder almacenar los datos
	;				Incremento del operando 2 para calcular la tabla
	;
	;		*Funcional en el equipo entrenador*
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
	;	1200H 		Operando1/Entrada
	;
	;	1201-12xxh 	Resultado de la tabla
	;
	;	1301H		Operando 2 (Por defecto 1, es el n�mero inicial con el que comienza la tabla)
	;	
	;	1302H:		Direcci�n temporal de almacenamiento del desplazamiento a la derecha del Operando 2 para saber el carry/tipo de salto a ejecutar
	;
	;	1303H:		Resultado + almacenamiento temporal del resultado
	;
	;	1304H:		Ciclos del bucle multriplicaci�n
	;
	;	1305H:		Direcci�n temporal para almacenar el desplazamiento del Operando 1 a la izquierda (1200H)
	;
	;	1306h		Contador tabla
	;	
	;	1307		Par de registros con la posici�n del resultado de la tabla
	;
	;------------------------------------------------------------------------------------------------------
	;Programa

	.ORG 1000H		;Direcci�n de memoria inicial (.ORG para simulador y ORG ensamblador)

;entrada---------------------------------------------------------------------------------

	LXI H,1200H		;Direcci�n de entrada del n�mero del que queremos la tabla.
	MVI M,1H     	;N�mero a introducir en la direcci�n anterior en BCD

	LXI H,1301H 	;Multiplicando con el que queremos iniciar la tabla
	MVI M,1H    	;N�mero a introducir en la direcci�n anterior en BCD
	
;FinEntrada------------------------------------------------------------------------------
;Ejecuci�n inicial------

	LXI H,1200H		;Direcci�n de memoria -1 en la que queremos guardar los resultados (1200H los guardar� a partir de 1201H)
				;Cargamos el par de registros HL con la direcci�n que vamos a usar para aumentar 1 cada vez y se guarda el resultado

	;	n� Ciclos de la TABLA		
	MVI A,9			;Carga el n�mero de ciclos DE LA TABLA al acumulador 
	STA 1306H		;Direcci�n de almacenamiento del contador de ciclo/bucle

INIC:
	;LDA 1304H		;Carga el n�mero de ciclos de multiplicaci�n al acumulador
	MVI A,5H		;Direcci�n de almacenamiento del contador de ciclo/bucle 
	STA 1304H
		
	MVI A,0  
	STA 1303H		;Elimina valores basura en 1203 para poder sumar correctamente los valores

;Como estamos reutilizando la P5, los valores se introducen en otras posiciones de memoria, y luego se copian y pegan para
;	mantener los originales dureante el desplazamiento

	LDA 1301H 
	STA 1302H		;Crea una copia de 1200H y la guarda en 1203H. 
				;Aqu� vamos a almacenar el n�mero cada vez que lo dividimos entre 2/desplazamos derecha

	LDA 1200H		;Crea una copia del primer valor
	STA 1305H		;Esta la vamos a usar para sumarla al valor original (1200h), pero esta va a ser multiplicada x2 cada ciclo de all

;-----------------------------------------------------------------------------------

;ALL: Desplazamiento lateral del operando 2, y sentencia alternativa si el bit de acarreo es 1 o 0
ALL:	LDA 1302H 	;Carga el primer n�mero al acumulador
	RRC		;Rota el programa para cargar el bit de la derecha del acumulador en el acarreo
	STA 1302H 	;Guarda el acumulador una vez rotado

	JNC CONT	;Si el bit en Carry es 0 ejecutamos el c�digo de CERO
	JMP CUNO	;Si el bit en el Carry es 1, el programa salta a CUNO

;-----------------------------------------------------------------------------------
;CUNO: Si el flag del acarreo est� encendido, suma al valor de 1203H uno de los desplazamientos del Operando 1

CUNO:
	LDA 1303H 	;Carga de nuevo el n�mero a operar en el acumulador.
	MOV B,A		
	LDA 1305H
	ADD B
	STA 1303H 	;Guarda en 1203H el resultado actual
	JMP CONT

;-----------------------------------------------------------------------------------
;Funci�n Contador, repite el proceso x veces (X = 1204H) + Desplazamiento lateral del operando 2

CONT:
	LDA 1305H	;
	RLC		;Desplazamiento lateral a la derecha del operando 2, valor temporal en 1205H
	STA 1305H	;

	LDA 1304H
	DCR A		;Decrementa en 1 el n�mero
	CPI 00		;Compara el resultado del acumulador con un n�mero X (CPI XX)
	STA 1304H	

	JNZ ALL
			;Hasta que el n�mero de ciclos final no sea 0, el programa no para (Vuelve a ALL)


;----------------------------------------------------------------------------------------
;	Tabla, bucle que repite la multiplicaci�n:
		;Una vez que obtenemos el resultado de la operaci�n, realizamos los siguientes pasos
		

TABLA:
	;AUMENTO DEL OPERANDO 2
		;Aumentamos el operando 2 en una unidad para poder multiplicarlo de nuevo en la tabla
	LDA 1301H 	;Direcci�n de memoria donde se encuentra el segundo n�mero
	INR A		;Incremento del operando
	STA 1301H   ;Guardamos el incremento

;-------------------	
	;Posiciones de los resultados individuales de la multiplicaci�n
	;Esta funci�n incrementa en 1 la direcci�n donde guardamos el resultado para mostrar la tabla de forma consecutiva
	
	LDA 1303H	;Cargamos el resultado obtenido en la multiplicaci�n
	INX H
	MOV M,A		;Lo guardamos en la direcci�n que tiene el par HL

	;-----------Control de flujo de la tabla (BUCLE)
	;Como cualquier otro bucle, aqu� comparamos que una vez se ejecute la funci�n TABLA dir1306H veces, se detenga la ejecuci�n
	
	LDA 1306H	;Carga de la direcci�n 1306H el n�mero de ciclos
	DCR A		;Decrementa en 1 el n�mero de ciclos
	CPI 00		;Compara el resultado del acumulador con un n�mero X (CPI XX)
	STA 1306H	;Guarda el n�mero de ciclos actual
	JNZ INIC	;Si el n�mero de ciclos = 0 (Bit A activado), continua la ejecuci�n a FIN, si no salta a INIC:

	;-----------FIN BUCLE TABLA
	
;----Fin programa:
	;Fin de ejecuci�n (Simulador)
	HLT

	;Fin de ejecuci�n (Ensamblador)
	;RST 1
	;END