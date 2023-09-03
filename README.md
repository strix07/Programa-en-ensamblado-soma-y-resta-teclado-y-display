# **Diseño de un programa capaz de sumar y restar el contenido de 2 números introducidos en los puertos del microcontralador pic16f873a**

## **INSTRUCCIONES**
 
  El laboratorio consiste en compilar con MPLAB dos programas para simular en un mismo circuito utilizando Proteus.


![image](https://github.com/strix07/Programa-en-ensamblado-soma-y-resta-teclado-y-display/assets/142692042/97e17143-0354-4c06-b123-0b38ce48202b)


Figura 1.  Montaje del circuito dado 

Parte 1 – Suma

  El número en el display será el resultado de la suma de los números de tres bits, si el resultado es mayor de 910 solo se mostrará el dígito menos significativo. El orden de lectura de los bits en ambas entradas es de abajo hacia arriba, en el caso mostrado para la suma el valor del display debería ser 5 + 3 = 8.

Parte 2 – Diferencia

 El número en el display será el resultado de la resta de los números de tres bits. Para evitar números negativos el Primer Número siempre será mayor o igual al segundo. En el caso mostrado 5 – 3 = 2.

En ambos casos seguiremos los siguientes pasos:

•	Desarrolle el programa en assembly para la Parte 1 usando MPLAB y/o MPLABx. Microchip también suministra un IDE (Integrated Development Environment)
•	Simular ambos circuitos tal como se muestra en la gráfica con Proteus y verificar su funcionamiento.
•	Adaptar los programas y el circuitos al PIC16F873A, simúlenlos con Proteus y verifique su funcionamiento.

## ANÁLISIS DEL CIRCUITO

  Como vimos en la figura 1, lo primero que podemos notar es que circuito consta de un pic16F84a, el cual como vemos en la figura de abajo, solo tiene 2 puertos A y B;



![image](https://github.com/strix07/Programa-en-ensamblado-soma-y-resta-teclado-y-display/assets/142692042/f06c4e48-fe31-429e-9795-a4f6fcac1aa9)


Figura 2.  PIC16F84A - Imagen sacada de alldatasheet.com

En la practica no utilizaremos  el pic anterior, sino el pic16F873a, mostrado abajo:


![image](https://github.com/strix07/Programa-en-ensamblado-soma-y-resta-teclado-y-display/assets/142692042/e2bc9db8-1101-4c80-892b-c16144f7f2b5)



Figura 3.  PIC16F84A - sacada de alldatasheet.com
   Este pic, como vemos tiene 3 puertos A, B y C, esto nos da una ventaja a la hora realizar nuestro programa, ya que necesitamos sumar 2 números de 3 bits obtenidos desde el exterior, con el pic 16f84a necesitábamos utilizar un solo puerto para obtener dichos números y realizar un realizar un ajuste para poder sumarlos, ya que solo contamos con 2 puertos, con el pic16F873a no es necesario realizar este ajuste, ya que los numero se sumarán y restaran directamente, como veremos más adelante.


 Otra cosa interesante que podemos notar del diagrama suministrado, es la utilización un decodificador de BCD para el display 7 segmentos.




![image](https://github.com/strix07/Programa-en-ensamblado-soma-y-resta-teclado-y-display/assets/142692042/34ea6ff5-5400-4e56-bf31-eb35f033032a)




Figura 4.  Configuración del display 

  Este decodificador es necesario para el 16F84A ya que el puerto A es de tan solo 6 Bits, como vemos en la figura anterior, sin embargo, el 16F873A tiene la ventaja de tener 2 puertos de 8 Bits por lo cual podemos mostrar el resultado en el display sin necesidad de usar un decodificador, como veremos más adelante, al realizar el programa.


CIRCUITO REDISEÑADO


  Ya sabiendo los puntos anteriores podemos rediseñar el circuito para el PIC16F873A, tal como se muestra en la figura de abajo:



![image](https://github.com/strix07/Programa-en-ensamblado-soma-y-resta-teclado-y-display/assets/142692042/9fa10cc8-3b0c-4d00-aa24-caf10abbe21b)




Figura 5.  Montaje del circuito rediseñado – Imagen de autoría propia hecha con el software proteus

Como vemos en la imagen anterior, se hicieron los cambios antes mencionados:
1.	Se cambio el PIC16F84A por el PIC16F73A.
2.	Se utilizaron 2 puertos en vez de 1.
3.	No se utilizó un decodificador, sino que directamente se conecto el display a la salida de los puertos.


DISEÑO DEL PROGRAMA 

```
;Configuracion de puertos

reset	org 0

	bcf STATUS,RP1			;
	bsf STATUS,RP0			;Coloco en 1 el bit RP0 (seleccion banco 1)
		
	CLRF PORTB				;Borro el pueto B
					;(si borro el puerto B significa que lo coloco como salida)

	movlw 0FFh				;configuro el puerto c como entrada
	movwf PORTC				;

			
	movlw 07h				;configuro el puerto a como entrada digital
	movwf ADCON1			;

	movlw 07h				;configuro el puerto a como entrada
	movwf TRISA				;
		
	bcf STATUS,RP0			;Coloco en 0 el bit RP0 (seleccion banco 0)
	movlw 00h 				;se carga w con 00h 
	movwf PORTB				;se descarga w en el puerto b (para indicar  encedido o reseteo)
	call Retardo_20s		;creo un retardo par que se vea por mas tiempo el encedido de los leds


;===========================================================
;Programa SUMA o RESTA?

INICIO
	BTFSS PORTC,7
	GOTO SUMA
	GOTO RESTA

;===========================================================
;Programa de suma
		
SUMA
	movf PORTA,W			;leo el puerto A
	ANDLW 07h
	movwf N1				;guardo los datos que esten en el puerto A
	movf PORTC,W			;leo el puerto C
	ANDLW 07h
	movwf N2				;guardo los datos que esten en el puerto C

 	goto comp1				;Compruebo si el reultado es un numero entre 0 y 14
LISTO	movlw B'10111111'		;si no es un numero entre 0 y 14 
	movwf PORTB				;muestro un guion indicando un desbordamiento
		goto INICIO				;vuelvo a iniciar el prgrama

;===========================================================
;Subrutina para comprobar cual es el número

comp1	movf N1,0
	Addwf N2,0
	sublw b'00000000'		
	btfsc STATUS,Z			;Compuebo si el resultado es cero
	goto CERO				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0				

	sublw b'00000001'
	btfsc STATUS,Z			;Compuebo si el resultado es uno
	goto UNO				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0

	sublw b'00000010'
	btfsc STATUS,Z			;Compuebo si el resultado es dos
	goto DOS				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0	
	
	sublw b'00000011'
	btfsc STATUS,Z			;Compuebo si el resultado es tres
	goto TRES				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0

	sublw b'00000100'
	btfsc STATUS,Z			;Compuebo si el resultado es cuatro
	goto CUATRO				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma
	Addwf N2,0	

	sublw b'00000101'
	btfsc STATUS,Z			;Compuebo si el resultado es cinco
	goto CINCO				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0

	sublw b'00000110'
	btfsc STATUS,Z			;Compuebo si el resultado es seis
	goto SEIS				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0

	sublw b'00000111'
	btfsc STATUS,Z			;Compuebo si el resultado es siete
	goto SIETE				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0	

  sublw b'00001000'
	btfsc STATUS,Z			;Compuebo si el resultado es ocho
	goto OCHO				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0

	sublw b'00001001'
	btfsc STATUS,Z			;Compuebo si el resultado es nueve
	goto NUEVE				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0	

	sublw b'00001010'
	btfsc STATUS,Z			;Compuebo si el resultado es diez
	goto DIEZ				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;vuelvo hacer la suma 
	Addwf N2,0

	sublw b'00001011'
	btfsc STATUS,Z			;Compuebo si el resultado es once
	goto ONCE				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0	
		
	sublw b'00001100'
	btfsc STATUS,Z			;Compuebo si el resultado es doce
	goto DOCE				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0

	sublw b'00001101'
	btfsc STATUS,Z			;Compuebo si el resultado es trece
	goto TRECE				;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0	

	sublw b'00001110'
	btfsc STATUS,Z			;Compuebo si el resultado es catorce
	goto CATORCE			;si es asi combierto a su equivalente 7 segmentos
	movf N1,0				;sino vuelvo hacer la suma 
	Addwf N2,0
		
	goto LISTO				;sino es nunguno de los anteiores ir al programa principal


;===========================================================
;Programa de resta


RESTA	movf PORTA,W			;leo el puerto A
	ANDLW 07h
	movwf N1				;guardo los datos que esten en el puerto A
	movf PORTC,W			;leo el puerto c
	ANDLW 07h
	movwf N2				;guardo el puerto C
 	movf N1,0				;recupero los datos del puerto A
	subwf N2,0				;resto los datos  guardados del puerto A con los del C
	btfss STATUS,C			;salta un espacio si resultado es NO es negativo
	goto NEGATIVO			;en caso de ser negativo muestro en el display un signo menos

;===========================================================
;Subrutina para comprobar cual es el número

COMP	sublw b'00000000'		
	btfsc STATUS,Z			;salta un espacio si el resultado no es 0
	goto CERO				;si es 0 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0				

	sublw b'00000001'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 1
	goto UNO				;si es 1 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0

	sublw b'00000010'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 2
	goto DOS				;si es 2 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0		

	sublw b'00000011'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 3
	goto TRES				;si es 3 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0

	sublw b'00000100'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 4
	goto CUATRO				;si es 4 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0	

	sublw b'00000101'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 5
	goto CINCO				;si es 5 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0

	sublw b'00000110'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 6
	goto SEIS				;si es 6 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0

	sublw b'00000111'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 7
	goto SIETE				;si es 7 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0	
		
	
sublw b'00001000'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 8
	goto OCHO				;si es 8 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0

	sublw b'00001001'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 9
	goto NUEVE				;si es 9 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0	

	sublw b'00001010'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 10
	goto DIEZ				;si es 10 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	Addwf N2,0

	sublw b'00001011'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 11
	goto ONCE				;si es 11 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0	
		
	sublw b'00001100'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 12
	goto DOCE				;si es 12 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0

	sublw b'00001101'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 13
	goto TRECE				;si es 13 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0	

	sublw b'00001110'
	btfsc STATUS,Z			;salta un espacio si el rehistro NO es 14
	goto CATORCE			;si es 14 convierto a su equivalente 7 segmentos y lo muesto en el display
	movf N1,0				;velvo a hacer la resta de los datos guardados
	subwf N2,0
	movwf PORTB				;muestro el resultado del display
	goto INICIO			;vuelvo al inicio

;===========================================================
;Subrutina BCD a 7 segmentos 

NEGATIVO 	movlw B'10111111'
	movwf PORTB
	goto INICIO

CERO 	movlw B'11000000'
	movwf PORTB
	goto INICIO

UNO	movlw B'11111001'
	movwf PORTB
	goto INICIO

DOS	movlw B'10100100'
	movwf PORTB
	goto INICIO

TRES	movlw B'10110000'
	movwf PORTB
	goto INICIO
	
CUATRO	movlw B'10011001'
	movwf PORTB
	goto INICIO

CINCO	movlw B'10010010'
	movwf PORTB
	goto INICIO

SEIS 	movlw B'10000010'
	movwf PORTB
	goto INICIO

SIETE	movlw B'11111000'
	movwf PORTB
	goto INICIO

OCHO	movlw B'00000000'
	movwf PORTB
	goto INICIO

NUEVE	movlw B'00010000'
	movwf PORTB
	goto INICIO

DIEZ 	movlw B'11000000'
	movwf PORTB
	goto INICIO

ONCE	movlw B'11111001'
	movwf PORTB
	goto INICIO

DOCE	movlw B'10100100'
	movwf PORTB
	goto INICIO

TRECE	movlw B'10110000'
	movwf PORTB
	goto INICIO

CATORCE	movlw B'10011001'
	movwf PORTB
	goto INICIO

	include <Retardos.inc>
END	
	
		
	



