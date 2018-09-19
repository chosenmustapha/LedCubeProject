
;******************************************************************************

;   This file is a basic template for creating relocatable assembly code for  *

;   a PIC18F1330. Copy this file into your project directory and modify or    *

;   add to it as needed.                                                      *

;                                                                             *

;   The PIC18FXXXX architecture allows two interrupt configurations. This     *

;   template code is written for priority interrupt levels and the IPEN bit   *

;   in the RCON register must be set to enable priority levels. If IPEN is    *

;   left in its default zero state, only the interrupt vector at 0x008 will   *

;   be used and the WREG_TEMP, BSR_TEMP and STATUS_TEMP variables will not    *

;   be needed.                                                                *

;                                                                             *

;   Refer to the MPASM User's Guide for additional information on the         *

;   features of the assembler and linker.                                     *

;                                                                             *

;******************************************************************************

;                                                                             *

;    Filename:                                                                *

;    Date:                                                                    *

;    File Version:                                                            *

;                                                                             *

;    Author:                                                                  *

;    Company:                                                                 *

;                                                                             * 

;******************************************************************************

;                                                                             *

;    Files required: P18F1330.INC                                             *

;                                                                             *

;******************************************************************************




	LIST P=18F1330, F=INHX32 ;directive to define processor and file format

	#include <P18F1330.INC>	 ;processor specific variable definitions




;******************************************************************************

;Configuration bits

;Microchip has changed the format for defining the configuration bits, please 

;see the .inc file for futher details on notation.  Below are a few examples.










;   Oscillator Selection:

  ;  CONFIG	OSC = LP             ;LP

    

    CONFIG OSC = INTIO1

    CONFIG WDT = OFF













;******************************************************************************

;Variable definitions

; These variables are only needed if low priority interrupts are used. 

; More variables may be needed to store other special function registers used

; in the interrupt routines.




		UDATA




WREG_TEMP	RES	1	;variable in RAM for context saving 

STATUS_TEMP	RES	1	;variable in RAM for context saving

BSR_TEMP	RES	1	;variable in RAM for context saving




		UDATA_ACS




EXAMPLE		RES	1	;example of a variable in access RAM
				

COUNT_LEFT_1	RES	1

COUNT_LEFT_2    RES	1
    
DELAY_SIZE	EQU	0FF



;******************************************************************************

;EEPROM data

; Data to be programmed into the Data EEPROM is defined here


DATA_EEPROM	CODE	0xf00000




		DE	"Test Data",0,1,2,3,4,5




;******************************************************************************

;Reset vector

; This code will start executing when a reset occurs.




RESET_VECTOR	CODE	0x0000




		goto	Main		;go to start of main code




;******************************************************************************

;High priority interrupt vector

; This code will start executing when a high priority interrupt occurs or

; when any interrupt occurs if interrupt priorities are not enabled.




HI_INT_VECTOR	CODE	0x0008

		bra	HighInt		;go to high priority interrupt routine




;******************************************************************************




;Low priority interrupt vector

; This code will start executing when a low priority interrupt occurs.

; This code can be removed if low priority interrupts are not used.




LOW_INT_VECTOR	CODE	0x0018




		bra	LowInt		;go to low priority interrupt routine




;******************************************************************************

;High priority interrupt routine

; The high priority interrupt code is placed here.




		CODE




HighInt:




;	*** high priority interrupt code goes here ***







		retfie	FAST




;******************************************************************************

;Low priority interrupt routine

; The low priority interrupt code is placed here.

; This code can be removed if low priority interrupts are not used.




LowInt:

		movff	STATUS,STATUS_TEMP	;save STATUS register

		movff	WREG,WREG_TEMP		;save working register

		movff	BSR,BSR_TEMP		;save BSR register




;	*** low priority interrupt code goes here ***







		movff	BSR_TEMP,BSR		;restore BSR register

		movff	WREG_TEMP,WREG		;restore working register

		movff	STATUS_TEMP,STATUS	;restore STATUS register

		retfie




;******************************************************************************

;Start of main program

; The main program code is placed here.




Main:




	MOVLW 7C

	MOVWF OSCCON 


	BSF TRISB, 4	;Set PORTB4 as an input Port.

	BCF TRISB, 0	;Set PORTB0 as an outpout Port.

	BCF TRISB, 1	;Set PORTB1 as an outpout Port.

	BCF TRISB, 5	;Set PORTB5 as an outpout Port.

	BCF TRISA, 2	;Set PORTA2 as an outpout Port.

	BCF TRISA, 3	;Set PORTA3 as an outpout Port.


CONDITION_CHECK	BTFSC	PORTB,	    0
    
    BRA	SW_PUSH
    BRA	SW_NOT_PUSH
    
SW_NOT_PUSH
    
	BCF	PORTB,	1
	BCF	PORTB,	4
	BCF	PORTB,	5
	BCF	PORTA,	2
	BCF	PORTA,	3
	BRA	CONDITION_CHECK
	MOVLW   33
    
SW_PUSH
	BRA	LOOP_1
	BRA	CONDITION_CHECK
	MOVLW   33
    
    LOOP_1
	MOVLW   DELAY_SIZE
	MOVWF   COUNT_LEFT_1
	MOVWF   COUNT_LEFT_2
    
	A_1
	    BSF	PORTB,	0
	    DECF    COUNT_LEFT_1,	F
	    BNZ	    A_1
	    DECF    COUNT_LEFT_2,	F
	    BNZ	    A_1
	    BRA	    A_2
    
	A_2
	     BSF	PORTB,	1
	     DECF    COUNT_LEFT_1,	F
	     BNZ	    A_2
	     DECF    COUNT_LEFT_2,	F
	     BNZ	    A_2
	     BRA	    A_3
    
	A_3
	     BSF PORTB,	5
	     DECF    COUNT_LEFT_1,	F
	     BNZ	    A_3
	     DECF    COUNT_LEFT_2,	F
	     BNZ	    A_3
	     BRA	    A_4
	A_4
 
	    BSF	PORTA,	2
	    DECF    COUNT_LEFT_1,	F
	    BNZ	    A_4
	    DECF    COUNT_LEFT_2,	F
	    BNZ	    A_4
	    BRA	    A_5
	A_5
	    BSF	PORTA,	3
	    DECF    COUNT_LEFT_1,	F   
	    BNZ	    A_5
	    DECF    COUNT_LEFT_2,	F
	    BNZ	    A_5
	    BRA	    LOOP_1
	    
	    
	    END
    
    
   
    
    
    

	    
	    
	    
	




    

	

	