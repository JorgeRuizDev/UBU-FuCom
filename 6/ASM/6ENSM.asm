	;
	;	Pr�ctica 6 para el u8085	
	;	
	;Autor: Jorge Ruiz G�mez
	;Fecha:	14/05/2019
	;
	;Descrici�n: Utiliza las direcciones de memoria reservadas al
	;	programa monitor para leer e imprimir el acumulador.
	;
	;	El programa monitor ya tiene estas subrutinas programadas
	;	de serie, por lo que solo es necesario llamarlas.
	;	
	;	Algunas de estas subrutinas necesitan tener m�scaras 
	;	concretas y las interrupciones configuradas
	;
	;	Toda la informaci�n ha sido extraida del PDF Pr�ctica 7
	;	
	;
	;
	;	El programa no ha sido probado, y s�lo deber�a funcionar
	;	con el equipo u8085 de Alcop
	;
	;	El programa no imprime un n�mero como tal, sino que activa
	;	las distintas patillas del display de 7 segmentos, usando el
	;	acumulador como interfaz
	;
	;	Para imprimir n�meros ser�a necesario introducir una tabla de conv
	;	que carge al acumulador las patillas espec�ficas a mostrar dependiendo
	;	del n�mero, por ejemeplo, si introducimos 2 (32H) se encender�an
	;	00110010 s�lo 3 patillas. Tendr�amos que cambiar el acumulador a:
	;	3Eh: 00111110 para imprimir un 2, este valor equivale a ">" en ASCII		
	;
	;	
	;
	;---------------------------------------------------------

	
;	Inicio
	ORG 1000H	;(Direcci�n de inicio, quitar el punto para ensamblar)

;-------------------------------------------------------------------
;	Cuerpo

	;Primero activamos las interrupciones, y las desenmascaramos
	
	MVI A,8H	;Cargamos 8 decimal al acumulador para activar el bit 3
			;El bit 3 o bit MSE permite desenmascarar las interrupciones
			;de tipo hardware (RST x.5)	

	SIM		;Fijamos la nueva m�scara que desenmascara las de tipo HW
	
;--------------------------------------------------------------------
	;Programa principal
INIC:
	EI		;Enable Intrrupt, activa las interrupciones
	;RIM		;Carga el bit 3 al acumulador(Innecesario creo yo)

	CALL 044EH	;Este call llama a la subrutina del E.Entrenador que permite
			;leer una entrada de teclado
			;Tambi�n llamada RDKBD (Seg�n los apuntes)
			;Esta subrutina necesita tener la rutina RST 5.5 Desenmascarada

	STA 1201H	;Guardamos el acumulador antes de que se pierda al saltar a estas
			;subrutinas
;-------------------------------------------------------
	
	LDA 1201H	;Cargamos el dato intrdudo al acumulador
	CPI 30H		;Comparamos si es 0 en ASCII H
	JNZ Imprim	;No es 0: imprimimos el valor del acumulador
	JMP Fin		;Si es 0: Denemos la ejecuci�n

Imprim:
	LDA 1201	;Volvemos a cargar el acumulador por si este se ha borrado

	CALL 04D5H	;Saltamos a la siguiente dir del Equipo entrenador
			;Esta direcci�n permite imprimir el acumulador
			;seg�n los apuntes
			;Tambi�n conocida como UPDDT

	JMP INIC	;Volvemos al inicio del bucle porque no se ha introducido 0

;------Fin de la ejecuci�n al intrudicir 0-----------------
Fin:	

	RST 1
	END