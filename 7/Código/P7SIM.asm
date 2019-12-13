	;
	;	Práctica 7 | Comunicación
	;
	;Autor:	Jorge Ruiz Gómez
	;Fecha:	14/05/2019
	;
	;Descripción: El programa está pendiente a una interrupción
	;		Y dependiendo del status del 8251, envía un dato
	;		o recibe
	;
	;	El programa no ha sido probado en su totalidad, se ha intentado
	;	Simular una comunicación con el teclado y el display 
	;	pero no el status.
	;
	;
	;
	;--------------------------------------------------------------


;	Inicio

	.ORG 1000H

;----Cuerpo------------------------------------------------------------

;Control (Cargamos las palabras)
	;----------------
	;PALABRA DE MODO
	
	;Lo primero que tenemos que hacer es enviar la PALABRA DE MODO al puerto 29H

	;Cargamos la palabra de modo al acumulador
	;Tenemos en cuenta que la transmisión recepción es recíproca
	;8 bits de longitud de caracteres
	;2400 bps
	;2bits STOP
	;No hay generación, ni paridad
	;DX según los apuntes
	;D0 y D1: 1 (64x baudios, para la velocidad de 2400bps)
	;D2 y D3: 1 (8 bits de longitud)
	;D4 y D5: 0 (NO hay habilitacón ni generación/prueba de paridad)
	;D6 y D7: 1 (2 Bits de stop)
	
	;Quedaría tal que 11001111b
	;Es el equivalente a CFh

	MVI A,CFH	;Carga la palabra de modo al acumulador
	OUT 29H		;Envía la palabra al puerto


	;----------------
	;PALABRA DE MANDO
	
	;Lo primero que hacemos es configurar la palabra de modo
	;En nuestro caso será: 0010 0111 o 27H

	MVI A,27H
	OUT 29H		;Scamos la palabra por el mismo puerto.

;Interrupciones (Configuramos el sistema para permitir interrupciones de tipo RST 5.5)
PROG:	
	MVI A,3		;Activamos el bit MSE
	SIM		;Fijamos la máscara
	
INIC:	
	EI
	JMP INIC	;Bucle que mantiene el sistema a la espera de una interrupcion

Inter:	;Ejecución tran interrupción
	;1º Comprobamos el status
	IN 29H		;Cargamos el Status al acumulador
	STA 1201H	;Guardamos el valor en memoria
	
	;Comparamos el Status, si está listo para recibir enviamos el bit, y si está listo para enviar escuchamos
	;Como necesitamos justo los bits en cuestion, rotamos y comprobamos con el carry
	
	LDA 1201H	;Cargamos el status dek 8251
	;Comprobamos si el status tiene el bit TcRDY activo
	;Si es así, significa que podemos enviar, si no, escuchamos porque nosotros vamos a recibir algo
	
	RRC
	RRC
	JNC Recibir
	JMP Enviar

Recibir:	;Si escuchamos:
	;Borramos la dirrecón de memoria en la que está la última entrada de teclado
	MVI A,0
	STA 1200H
	

	IN 28H		;Cargamos al acumulador lo que estamos recibiendo
	OUT 00h		;Imprime lo que recibimos
	JMP INIC	;Volvemos a esperar una interrupción
	
Enviar:
	LDA 1200H	;carga nuestra entrada por teclado
	OUT 28H		;La envía al 8251



;Intrrupcion 8085
	;Siempre que hay una interrupción guarda el último bit del bus de teclado
	;Puede que cause algún error o algún bit indeseado en la comunicación
	
	
	.ORG 002ch	;Dirección de memoria que se ejecuta tras la interrupción
	IN 00H		
	STA 1200H	;Guardamos el valor de entrada en 1200H
	JMP Inter

;No hay fin, ya que en ningún momento se pide en el programa...
	;RST 1
	;END
	