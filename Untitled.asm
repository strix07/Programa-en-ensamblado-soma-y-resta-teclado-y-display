;===========================================================
; Suma de 3 bits
list p=16f873a 
include <p16f873a.inc> 
__CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

;===========================================================
;Librerias 
		CBLOCK 0Ch
		endc 
;===========================================================
;variables 
		N1 equ 20h
		N2 equ 21h
;===========================================================
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
;Programa principal
INICIO
		BTFSS PORTC,7
		GOTO SUMA
		GOTO RESTA
		
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
;Subrutina BCD a 7 segmentos 

NEGATIVO 	movlw B'10111111'
			movwf PORTB
			goto INICIO

CERO 		movlw B'11000000'
			movwf PORTB
			goto INICIO

UNO	 		movlw B'11111001'
			movwf PORTB
			goto INICIO

DOS			movlw B'10100100'
			movwf PORTB
			goto INICIO

TRES		movlw B'10110000'
			movwf PORTB
			goto INICIO
	
CUATRO		movlw B'10011001'
			movwf PORTB
			goto INICIO

CINCO		movlw B'10010010'
			movwf PORTB
			goto INICIO

SEIS 		movlw B'10000010'
			movwf PORTB
			goto INICIO

SIETE		movlw B'11111000'
			movwf PORTB
			goto INICIO

OCHO		movlw B'00000000'
			movwf PORTB
			goto INICIO

NUEVE		movlw B'00010000'
			movwf PORTB
			goto INICIO

DIEZ 		movlw B'11000000'
			movwf PORTB
			goto INICIO

ONCE		movlw B'11111001'
			movwf PORTB
			goto INICIO

DOCE		movlw B'10100100'
			movwf PORTB
			goto INICIO

TRECE		movlw B'10110000'
			movwf PORTB
			goto INICIO

CATORCE		movlw B'10011001'
			movwf PORTB
			goto INICIO





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
		goto COMP
	
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


	include <Retardos.inc>
END











