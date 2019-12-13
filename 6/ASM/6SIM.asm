	;Autor: Jorge Ruiz G�mez 203
	;Fecha: 11/05/2019
	;
	;Pr�ctica 6
	;Descripci�n: Muestra por pantalla el dato introducido por teclado (n�mero/tecla/...)
	;	
	;Versi�n: 1.0
	;	Pruebas: No imprime correctamente en el display de 7 segmentos
	;			Principalmente porque no tiene suficiente info
	;			Adem�s hay que usar una tabla de conversi�n para
	;	
	;	
	;	Para imprimir n�meros ser�a necesario introducir una tabla de conv
	;	que carge al acumulador las patillas espec�ficas a mostrar dependiendo
	;	del n�mero, por ejemeplo, si introducimos 2 (32H) se encender�an	
	;	00110010 s�lo 3 patillas. Tendr�amos que cambiar el acumulador a:	
	;	3Eh: 00111110 para imprimir un 2, este valor equivale a ">" en ASCII	
	;
	;	No ha sido probado en el equipo entrenador
	;
	;----------------------------------------------------------------------------------


;Inicio del programa------------------------

	.ORG 1000H		;Direcci�n de inicio (Quitar el punto para compilar)

;Cuerpo-------------------------------------
	;M�scaras		
	MVI A,8			;Bit 3 (MSE) -> Permite programar/modif m�scaras
	SIM			;Fija la m�scara con el bit del acumulador

Entrada:
	EI			;Enable Interruptions: Activa las interrupciones
	;RIM			;Carga de nuevo la m�scara al acumulador
	JMP Entrada		;Bucle de entrada durante el cual introducimos los datos

;---------------------------------------------
;Rutina RST 5.5
	.ORG 002Ch
	CALL 044EH

;044EH
	.ORG 044EH
	IN 00H		;Por defecto, el teclado incluido en el simulador realiza la entrada de un dato en el puerto 00H
				;Teniendo esto en cuenta, realizamos una instrucci�n IN en ese puerto
				;La instrucci�n IN permite cargar el dato de 00H al acumulador
	CPI 30H			;Si el dato es 30H (0 ASCII Hex) salta a FIN
	JNZ 04D5H
	JMP FIN


	.ORG 04D5H
	OUT 01H			;Imprime el acumulador a la direcci�n 01H
	JMP Entrada	

;----------------------------------------------
FIN:
	;Simulador
	HLT
	
	;ASM
	;RST 1
	;END
			