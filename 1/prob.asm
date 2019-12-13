	;Autor: Pablo Sagredo, Jorge Ruiz (203)	
	;Fecha: 13.02.19
	;Versión: 1.0
	;Pruebas y cambios: Variación de los valores en las instrucciónes MVI (MVI M,X) siendo x otro valor en decimal
	;Ensamblado y enlazado con las herramientas x8085 y link para el procesador intel 8085 (i8085)
	;	


	;Inicio/Cuerpo del programa
	ORG 1000H		;Instrucción de origen, indica que el programa comienza en la dirección de memoria 1000H	
	LXI H,1200H		;Instrucción de carga-inmediata, carga directamente en el par de registros especificado (H-L) una dirección de memoria o dato.
	MVI M,3			;Instrucción de movimiento inmediato, carga un número (3) en la memoria indicada en el par de registros (H-L).
				
				;Repetición del código para copiar un segundo valor en otra dirección
	LXI H,1201H		
	MVI M,5			

	;Fin para ensambaldor
	RST 1
	END
	
	;Fin para simulador
	;HLT