;**********************************************************************
;   This file is a basic code template for assembly code generation   *
;   on the PIC16F690. This file contains the basic code               *
;   building blocks to build upon.                                    *  
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     * 
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P16F690.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************


	list		p=16f690		; list directive to define processor
	#include	<P16F690.inc>		; processor specific variable definitions
	
	__CONFIG    _CP_OFF & _CPD_OFF & _BOR_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF


; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.






;***** VARIABLE DEFINITIONS
w_temp		EQU	0x7D			; variable used for context saving
status_temp	EQU	0x7E			; variable used for context saving
pclath_temp	EQU	0x7F			; variable used for context saving

A_reg		EQU 0x20
B_reg		EQU 0x21
C_reg		EQU 0x22
count		EQU 0x23
setinel		EQU 0x24

;**********************************************************************
	ORG			0x000			; processor reset vector
  	goto		main			; go to beginning of program


	ORG			0x004			; interrupt vector location
	movwf		w_temp			; save off current W register contents
	movf		STATUS,w		; move status register into W register
	movwf		status_temp		; save off contents of STATUS register
	movf		PCLATH,w		; move pclath register into W register
	movwf		pclath_temp		; save off contents of PCLATH register


; isr code can go here or be located as a call subroutine elsewhere
nop
	incf		count
	movlw		.10
	subwf		count,w
	btfss		STATUS,Z
	goto		skip1
	clrf		count
	bsf			setinel,0

skip1
	movlw		.61
	movwf		TMR0

	bcf			INTCON,T0IF

	movf		pclath_temp,w		; retrieve copy of PCLATH register
	movwf		PCLATH			; restore pre-isr PCLATH register contents	
	movf		status_temp,w		; retrieve copy of STATUS register
	movwf		STATUS			; restore pre-isr STATUS register contents
	swapf		w_temp,f
	swapf		w_temp,w		; restore pre-isr W register contents
	retfie					; return from interrupt


main

	banksel		TRISC
	clrf		TRISC

	clrf		ANSEL
	banksel		PORTC
	banksel		OPTION_REG
	movlw		0x07			;0b00000111
	movwf		OPTION_REG
	banksel		INTCON
	movlw		0xA0			;0b10100000
	movwf		INTCON
	banksel		PORTC
	movlw		.60
	movwf		TMR0
	bsf			PORTC,0


	

again
	bcf			STATUS,C
	btfss		setinel,0
	goto		again

	rlf			PORTC
	btfss		STATUS,C
	goto		skip2	
	bcf			STATUS,C
	bsf			PORTC,0

skip2
	bcf			setinel,0






	ORG	0x2100				; data EEPROM location
	DE	1,2,3,4				; define first four EEPROM locations as 1, 2, 3, and 4




	END                       ; directive 'end of program'