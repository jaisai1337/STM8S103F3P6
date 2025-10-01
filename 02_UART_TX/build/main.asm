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
	.globl _USART1_Init
	.globl _delay
	.globl _puts
	.globl _putchar
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
;	src/main.c: 5: void delay(volatile uint32_t count) {
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #4
;	src/main.c: 6: while(count--) __asm__("nop");
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
	nop
	jra	00101$
00104$:
;	src/main.c: 7: }
	ldw	x, (5, sp)
	addw	sp, #10
	jp	(x)
;	src/main.c: 10: void USART1_Init(void) {
;	-----------------------------------------
;	 function USART1_Init
;	-----------------------------------------
_USART1_Init:
;	src/main.c: 15: GPIOD->DDR |= (1 << 5);  // Set PD5 as output
	bset	0x5011, #5
;	src/main.c: 16: GPIOD->CR1 |= (1 << 5);  // Push-pull
	bset	0x5012, #5
;	src/main.c: 17: GPIOD->CR2 &= ~(1 << 5); // No interrupt, no fast output
	bres	0x5013, #5
;	src/main.c: 24: USART1->BRR2 = 0x03;  // Example for 9600 bps @ 16 MHz
	mov	0x5233+0, #0x03
;	src/main.c: 25: USART1->BRR1 = 0x68;
	mov	0x5232+0, #0x68
;	src/main.c: 27: USART1->CR1 = 0x00;  
	mov	0x5234+0, #0x00
;	src/main.c: 28: USART1->CR2 |= (1 << 3);  // TEN: Enable TX
	bset	0x5235, #3
;	src/main.c: 29: }
	ret
;	src/main.c: 32: int putchar(int c) {
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	src/main.c: 33:     if (c == '\n') putchar('\r');  // Add carriage return for terminals
	cpw	x, #0x000a
	jrne	00103$
	pushw	x
	ldw	x, #0x000d
	callr	_putchar
	popw	x
;	src/main.c: 34:     while (!(USART1->SR & (1 << 7)));  // Wait until TXE (Transmit Data Register Empty)
00103$:
	ld	a, 0x5230
	jrpl	00103$
;	src/main.c: 35:     USART1->DR = c;
	ld	a, xl
	ld	0x5231, a
;	src/main.c: 36:     return c;
;	src/main.c: 37: }
	ret
;	src/main.c: 39: void main(void) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	src/main.c: 40: CLK->CKDIVR = 0x00; // for make it run on 16 MHz or else it will run on 2 MHz  brr2 = 0x00 ; brr1 = 0x0d; 
	mov	0x50c6+0, #0x00
;	src/main.c: 41: USART1_Init();
	call	_USART1_Init
;	src/main.c: 43: while (1) {
00102$:
;	src/main.c: 44: printf("Hello STM8!\n");
	ldw	x, #(___str_1+0)
	call	_puts
;	src/main.c: 45: delay(500000);
	push	#0x20
	push	#0xa1
	push	#0x07
	push	#0x00
	call	_delay
	jra	00102$
;	src/main.c: 47: }
	ret
	.area CODE
	.area CONST
	.area CONST
___str_1:
	.ascii "Hello STM8!"
	.db 0x00
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
