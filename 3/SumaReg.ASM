	;Autores: Pablo Sagredo, Jorge Ruiz (203)
	;Date: 13/03/19
	;
	;Versión 1.0
	.ORG 1000H;Dirección de memoria inicial
	LXI H,1200H
	MVI M,14;Carga un número en el acumulador
	LDA 1200H
	LXI H,1201H
	MVI M,4;Carga un número en 1201H
	ADD M;Añade LA MEMORIA 1201H  en el acumulador
	STA 1203H;Vuelca el acumulador a la dirección 1200h
	HLT;Para el programa
