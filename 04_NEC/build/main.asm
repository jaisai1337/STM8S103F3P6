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
	.globl _nec_get_data
	.globl _nec_data_ready
	.globl _nec_init
	.globl _uart_init
	.globl _puts
	.globl _printf
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
	int 0x000000 ; int4
	int 0x000000 ; int5
	int _EXTI_PORTD_IRQHandler ; int6
	int 0x000000 ; int7
	int 0x000000 ; int8
	int 0x000000 ; int9
	int 0x000000 ; int10
	int 0x000000 ; int11
	int 0x000000 ; int12
	int _TIM2_Update_IRQHandler ; int13
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
;	src/main.c: 6: void main(void) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #12
;	src/main.c: 8: CLK->CKDIVR = 0x00;
	mov	0x50c6+0, #0x00
;	src/main.c: 11: uart_init();
	call	_uart_init
;	src/main.c: 12: nec_init();
	call	_nec_init
;	src/main.c: 15: __asm__("rim");
	rim
;	src/main.c: 18: printf("-------------------------\n");
	ldw	x, #(___str_6+0)
	call	_puts
;	src/main.c: 24: while (1) {
00110$:
;	src/main.c: 26: if (nec_data_ready()) {
	call	_nec_data_ready
	tnz	a
	jreq	00110$
;	src/main.c: 29: if (nec_get_data(&ir_code)) {
	ldw	x, sp
	incw	x
	call	_nec_get_data
	tnz	a
	jreq	00110$
;	src/main.c: 32: uint8_t not_address = (ir_code.raw_data >> 16) & 0xFF;
	ldw	y, (0x05, sp)
	ldw	(0x09, sp), y
	ldw	y, (0x03, sp)
	ldw	(0x07, sp), y
	ld	a, (0x08, sp)
	ld	(0x0b, sp), a
;	src/main.c: 33: uint8_t not_command = ir_code.raw_data & 0xFF;
	ld	a, (0x0a, sp)
	ld	(0x0c, sp), a
;	src/main.c: 35: if ((uint8_t)~ir_code.address == not_address && (uint8_t)~ir_code.command == not_command) {
	ld	a, (0x01, sp)
	ld	xl, a
	cpl	a
	cp	a, (0x0b, sp)
	jrne	00102$
	ld	a, (0x02, sp)
	ld	xh, a
	cpl	a
	cp	a, (0x0c, sp)
	jrne	00102$
;	src/main.c: 37: ir_code.address, ir_code.command, ir_code.raw_data);
	ld	a, xh
	clr	(0x0b, sp)
	rlwa	x
	clr	a
	rrwa	x
;	src/main.c: 36: printf("OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX\n", 
	ldw	y, (0x09, sp)
	pushw	y
	ldw	y, (0x09, sp)
	pushw	y
	push	a
	ld	a, (0x10, sp)
	push	a
	pushw	x
	push	#<(___str_4+0)
	push	#((___str_4+0) >> 8)
	call	_printf
	addw	sp, #10
	jra	00110$
00102$:
;	src/main.c: 39: printf("Error -> Raw: 0x%08lX\n", ir_code.raw_data);
	ldw	x, (0x09, sp)
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	push	#<(___str_5+0)
	push	#((___str_5+0) >> 8)
	call	_printf
	addw	sp, #6
	jra	00110$
;	src/main.c: 44: }
	addw	sp, #12
	ret
	.area CODE
	.area CONST
	.area CONST
___str_4:
	.ascii "OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX"
	.db 0x0a
	.db 0x00
	.area CODE
	.area CONST
___str_5:
	.ascii "Error -> Raw: 0x%08lX"
	.db 0x0a
	.db 0x00
	.area CODE
	.area CONST
___str_6:
	.db 0x0a
	.db 0x0a
	.ascii "STM8S Modular IR Receiver"
	.db 0x0a
	.ascii "-------------------------"
	.db 0x00
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)
