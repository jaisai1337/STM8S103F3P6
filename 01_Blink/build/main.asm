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
	.globl _delay
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
;	src/main.c: 4: void delay(volatile uint32_t count) {
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #4
;	src/main.c: 5: while(count--) {
00101$:
	ldw	y, (0x09, sp)
	ldw	(0x03, sp), y
	ldw	y, (0x07, sp)
	ldw	(0x01, sp), y
	ldw	x, (0x03, sp)
	subw	x, #0x0001
	ldw	y, (0x01, sp)
	jrnc	00116$
	decw	y
00116$:
	ldw	(0x09, sp), x
	ldw	(0x07, sp), y
	ldw	x, (0x03, sp)
	jrne	00117$
	ldw	x, (0x01, sp)
	jreq	00104$
00117$:
;	src/main.c: 6: __asm__("nop");
	nop
	jra	00101$
00104$:
;	src/main.c: 8: }
	ldw	x, (5, sp)
	addw	sp, #10
	jp	(x)
;	src/main.c: 10: int main(void) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	src/main.c: 12: GPIOB->DDR |= (1 << 5);   // Set PB5 as output
	bset	0x5007, #5
;	src/main.c: 13: GPIOB->CR1 |= (1 << 5);   // Push-pull
	bset	0x5008, #5
;	src/main.c: 14: GPIOB->CR2 &= ~(1 << 5);  // No fast output
	bres	0x5009, #5
;	src/main.c: 16: while (1) {
00102$:
;	src/main.c: 17: GPIOB->ODR ^= (1 << 5);  // Toggle PB5
	bcpl	0x5005, #5
;	src/main.c: 18: delay(50000);            // Simple software delay
	push	#0x50
	push	#0xc3
	clrw	x
	pushw	x
	call	_delay
	jra	00102$
;	src/main.c: 21: }
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
