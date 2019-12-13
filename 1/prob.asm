	;Autor: Pablo Sagredo, Jorge Ruiz (203)	
	;Fecha: 13.02.19
	;Versi�n: 1.0
	;Pruebas y cambios: Variaci�n de los valores en las instrucci�nes MVI (MVI M,X) siendo x otro valor en decimal
	;Ensamblado y enlazado con las herramientas x8085 y link para el procesador intel 8085 (i8085)
	;	


	;Inicio/Cuerpo del programa
	ORG 1000H		;Instrucci�n de origen, indica que el programa comienza en la direcci�n de memoria 1000H	
	LXI H,1200H		;Instrucci�n de carga-inmediata, carga directamente en el par de registros especificado (H-L) una direcci�n de memoria o dato.
	MVI M,3			;Instrucci�n de movimiento inmediato, carga un n�mero (3) en la memoria indicada en el par de registros (H-L).
				
				;Repetici�n del c�digo para copiar un segundo valor en otra direcci�n
	LXI H,1201H		
	MVI M,5			

	;Fin para ensambaldor
	RST 1
	END
	
	;Fin para simulador
	;HLT