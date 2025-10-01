;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _EXTI_PORTB_IRQHandler
	.globl _delay_ms
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; Stack segment in internal ram
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)

; default segment ordering for linker
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area CONST
	.area INITIALIZER
	.area CODE

;--------------------------------------------------------
; interrupt vector
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ; reset
	int 0x000000 ; trap
	int 0x000000 ; int0
	int 0x000000 ; int1
	int 0x000000 ; int2
	int 0x000000 ; int3
	int _EXTI_PORTB_IRQHandler ; int4
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	src/main.c: 4: void delay_ms(uint16_t ms)
;	-----------------------------------------
;	 function delay_ms
;	-----------------------------------------
_delay_ms:
	sub	sp, #4
	ldw	(0x01, sp), x
;	src/main.c: 6: for (uint16_t i = 0; i < ms; i++)
	clrw	x
	ldw	(0x03, sp), x
00107$:
	ldw	x, (0x03, sp)
	cpw	x, (0x01, sp)
	jrnc	00109$
;	src/main.c: 8: for (uint16_t j = 0; j < 1600; j++)
	clrw	x
00104$:
	ldw	y, x
	cpw	y, #0x0640
	jrnc	00108$
;	src/main.c: 10: __asm__("nop"); // No operation - just wastes a clock cycle
	nop
;	src/main.c: 8: for (uint16_t j = 0; j < 1600; j++)
	incw	x
	jra	00104$
00108$:
;	src/main.c: 6: for (uint16_t i = 0; i < ms; i++)
	ldw	x, (0x03, sp)
	incw	x
	ldw	(0x03, sp), x
	jra	00107$
00109$:
;	src/main.c: 13: }
	addw	sp, #4
	ret
;	src/main.c: 14: void EXTI_PORTB_IRQHandler(void) __interrupt(4)
;	-----------------------------------------
;	 function EXTI_PORTB_IRQHandler
;	-----------------------------------------
_EXTI_PORTB_IRQHandler:
	clr	a
	div	x, a
;	src/main.c: 17: GPIOC->ODR ^= (1 << 5); 
	bcpl	0x500a, #5
;	src/main.c: 18: delay_ms(50);
	ldw	x, #0x0032
	call	_delay_ms
;	src/main.c: 19: }
	iret
;	src/main.c: 21: void main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	src/main.c: 23: __asm__("sim");
	sim
;	src/main.c: 26: GPIOC->DDR |= (1 << 5);   // Set PC5 as output
	bset	0x500c, #5
;	src/main.c: 27: GPIOC->CR1 |= (1 << 5);   // Set PC5 as push-pull
	bset	0x500d, #5
;	src/main.c: 28: GPIOC->ODR &= ~(1 << 5);  // Start with the LED off
	bres	0x500a, #5
;	src/main.c: 31: GPIOB->DDR &= ~(1 << 4);  // Set PB4 as input
	bres	0x5007, #4
;	src/main.c: 32: GPIOB->CR1 |= (1 << 4);   // Enable the internal pull-up resistor
	bset	0x5008, #4
;	src/main.c: 33: GPIOB->CR2 |= (1 << 4);   // **FIX:** Enable external interrupt for pin PB4
	ld	a, 0x5009
	or	a, #0x10
	ld	0x5009, a
;	src/main.c: 35: EXTI->CR1 = (2 << 2); 
	mov	0x50a0+0, #0x08
;	src/main.c: 36: EXTI->CR2 = 0;
	mov	0x50a1+0, #0x00
;	src/main.c: 38: __asm__("rim"); 
	rim
;	src/main.c: 41: while (1)
00102$:
;	src/main.c: 45: __asm__("wfi");
	wfi
	jra	00102$
;	src/main.c: 47: }
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
