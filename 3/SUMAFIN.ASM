	;Autores: Pablo Sagredo, Jorge Ruiz (203)
	;Date: 13/03/19
	;----------------------------------------------------------------------------------------------------------------------------------------------
	;Versión 1.1
	;Suma funcional de dos números de 8 bits previa carga en memoria
	;Pruebas y Cambios:
	;	Versión 1.0a
	;	Se comprueba que se pueden sumar dos números, cargándolos previamente a un registro.
	;	
	;	Problemas:
	;		-Únicamente probado su funcionamiento en el Simulador x8085
	;		-No cargan valores desde memoria
	;		-No hay ajuste a BCD
	;		-El código no está ajustado al compilador, por lo que si intentamos ensamblarlo nos dará error
	;	Versión 1.0
	;	Se introducen los datos en memoria y luego se cargan a los registros.
	;	
	;	Otros cambios:
	;		-Añadido ajuste en BCD antes del volcado del acumulador en una dirección de memoria
	;		-Probado y modificado en el equipo entrenador en modo local y remoto
	;
	;	Versión 1.1
	;		-Añadidas instrucciones de uso en la cabecera
	;				
	;	
	;Ensamblado y enlazado con las herramientas x8085 del procesador i8085
	;---------------------------------------------------------------------------------------------------------------------------------------------
	;
	;								[Instrucciones]
	;						Direcciones de entrada: 1200H y 1201H
	;	Introduzca las cifas en modo Hexadecimal sin conversión, es decir, si quiere sumar 15 + 15, introduzca 15H+15H, no F+F
	;					
	;					Direcciones de salida: 1202H y 1203H, la cifra es contínua
	;					
	;
	;		Nota: Intente sumar números cuyo resultado sea menor a 99, ya que con nuestros conocimientos actuales no podemos introducir un 1 en 1202H sin saltos
	;						(Si el carry = 1, añadir 1 a 1202H)
	;
	;----------------------------------------------------------------------------------------------------------------------------------------------

	;Inicio/Cuerpo
	ORG 1000H		;Dirección de memoria inicial (Añadir un . delante de ORG [.ORG] para su correcto funcionamiento en el simulador x8085)

	LXI H,1200H		;Carga inmediatamente la direccón 1200H al par de registros H-L
	MVI M,4			;Carga un número a la dirección de memoria que se encuentra actualmente en el par de registros H-L
	LDA 1200H		;Carga el acumulador con el un valor que se encuentra en una dirección de memoria
	
	LXI H,1201H		;Carga inmediatamente la direccón 1201H al par de registros H-L
	MVI M,4			;Carga un número a la dirección de memoria que se encuentra actualmente en el par de registros H-L
	ADD M			;Suma el valor que se encuentra en la dirección de memoria guardada en el par de registros HL al acumulador

	DAA			;Ajusta el contenido del acumulador a BCD
	STA 1203H		;Vuelca el contenido del acumulador a la dirección 1203h
	
	;Fin para el simulador
	;HLT			;Para el programa

	;Fin para el equipo ensamblador
	RST 1
	END