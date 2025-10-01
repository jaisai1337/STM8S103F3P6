;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.module uart
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _uart_init
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
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	src/uart.c: 5: void uart_init(void) {
;	-----------------------------------------
;	 function uart_init
;	-----------------------------------------
_uart_init:
;	src/uart.c: 7: GPIOD->DDR |= (1 << 5);
	bset	0x5011, #5
;	src/uart.c: 8: GPIOD->CR1 |= (1 << 5);
	bset	0x5012, #5
;	src/uart.c: 14: USART1->BRR2 = 0x03;
	mov	0x5233+0, #0x03
;	src/uart.c: 15: USART1->BRR1 = 0x68;
	mov	0x5232+0, #0x68
;	src/uart.c: 18: USART1->CR2 |= (1 << 3); // TEN: Transmitter Enable
	bset	0x5235, #3
;	src/uart.c: 19: }
	ret
;	src/uart.c: 22: int putchar(int c) {
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	src/uart.c: 25: if (c == '\n') {
	cpw	x, #0x000a
	jrne	00103$
;	src/uart.c: 26: putchar('\r');
	pushw	x
	ldw	x, #0x000d
	callr	_putchar
	popw	x
;	src/uart.c: 30: while (!(USART1->SR & (1 << 7)));
00103$:
	ld	a, 0x5230
	jrpl	00103$
;	src/uart.c: 33: USART1->DR = c;
	ld	a, xl
	ld	0x5231, a
;	src/uart.c: 35: return c;
;	src/uart.c: 36: }
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
