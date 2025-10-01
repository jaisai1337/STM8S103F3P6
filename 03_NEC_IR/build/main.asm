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
	.globl _TIM2_Update_IRQHandler
	.globl _EXTI_PORTD_IRQHandler
	.globl _IR_GPIO_Init
	.globl _TIM2_Init
	.globl _USART1_Init
	.globl _puts
	.globl _printf
	.globl _ir_data_ready
	.globl _ir_bit_count
	.globl _ir_data
	.globl _ir_state
	.globl _putchar
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_ir_state::
	.ds 1
_ir_data::
	.ds 4
_ir_bit_count::
	.ds 1
_ir_data_ready::
	.ds 1
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
;	src/main.c: 31: void USART1_Init(void) {
;	-----------------------------------------
;	 function USART1_Init
;	-----------------------------------------
_USART1_Init:
;	src/main.c: 32: GPIOD->DDR |= (1 << 5);
	bset	0x5011, #5
;	src/main.c: 33: GPIOD->CR1 |= (1 << 5);
	bset	0x5012, #5
;	src/main.c: 34: USART1->BRR2 = 0x03;
	mov	0x5233+0, #0x03
;	src/main.c: 35: USART1->BRR1 = 0x68;
	mov	0x5232+0, #0x68
;	src/main.c: 36: USART1->CR2 |= (1 << 3);
	bset	0x5235, #3
;	src/main.c: 37: }
	ret
;	src/main.c: 39: int putchar(int c) {
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	src/main.c: 40: if (c == '\n') putchar('\r');
	cpw	x, #0x000a
	jrne	00103$
	pushw	x
	ldw	x, #0x000d
	callr	_putchar
	popw	x
;	src/main.c: 41: while (!(USART1->SR & (1 << 7)));
00103$:
	ld	a, 0x5230
	jrpl	00103$
;	src/main.c: 42: USART1->DR = c;
	ld	a, xl
	ld	0x5231, a
;	src/main.c: 43: return c;
;	src/main.c: 44: }
	ret
;	src/main.c: 46: void TIM2_Init(void) {
;	-----------------------------------------
;	 function TIM2_Init
;	-----------------------------------------
_TIM2_Init:
;	src/main.c: 47: CLK->PCKENR1 |= (1 << 5);
	bset	0x50c7, #5
;	src/main.c: 48: TIM2->PSCR = 0x04;
	mov	0x530e+0, #0x04
;	src/main.c: 49: TIM2->IER |= (1 << 0);
	bset	0x5303, #0
;	src/main.c: 50: }
	ret
;	src/main.c: 52: void IR_GPIO_Init(void) {
;	-----------------------------------------
;	 function IR_GPIO_Init
;	-----------------------------------------
_IR_GPIO_Init:
;	src/main.c: 53: GPIOD->DDR &= ~IR_PIN_MASK;
	bres	0x5011, #3
;	src/main.c: 54: GPIOD->CR1 |= IR_PIN_MASK;
	bset	0x5012, #3
;	src/main.c: 55: GPIOD->CR2 |= IR_PIN_MASK;
	bset	0x5013, #3
;	src/main.c: 56: EXTI->CR1 = (2 << 6);
	mov	0x50a0+0, #0x80
;	src/main.c: 57: }
	ret
;	src/main.c: 60: void EXTI_PORTD_IRQHandler(void) __interrupt(6) {
;	-----------------------------------------
;	 function EXTI_PORTD_IRQHandler
;	-----------------------------------------
_EXTI_PORTD_IRQHandler:
	sub	sp, #4
;	src/main.c: 61: uint16_t pulse_width = (TIM2->CNTRH << 8) | TIM2->CNTRL;
	ld	a, 0x530c
	ld	xh, a
	clr	(0x02, sp)
	ld	a, 0x530d
	clr	(0x03, sp)
	or	a, (0x02, sp)
	rlwa	x
	or	a, (0x03, sp)
	ld	xh, a
	ldw	(0x03, sp), x
;	src/main.c: 62: TIM2->CNTRH = 0;
	mov	0x530c+0, #0x00
;	src/main.c: 63: TIM2->CNTRL = 0;
	mov	0x530d+0, #0x00
;	src/main.c: 65: switch (ir_state) {
	ld	a, _ir_state+0
	cp	a, #0x04
	jrule	00186$
	jp	00129$
00186$:
;	src/main.c: 73: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
	ldw	y, (0x03, sp)
;	src/main.c: 65: switch (ir_state) {
	clrw	x
	ld	xl, a
	sllw	x
	ldw	x, (#00187$, x)
	jp	(x)
00187$:
	.dw	#00101$
	.dw	#00102$
	.dw	#00107$
	.dw	#00112$
	.dw	#00117$
;	src/main.c: 67: case STATE_IDLE:
00101$:
;	src/main.c: 68: TIM2->CR1 |= (1 << 0);
	bset	0x5300, #0
;	src/main.c: 69: ir_state = STATE_START_PULSE;
	mov	_ir_state+0, #0x01
;	src/main.c: 70: EXTI->CR1 = (3 << 6);
	mov	0x50a0+0, #0xc0
;	src/main.c: 71: break;
	jp	00129$
;	src/main.c: 72: case STATE_START_PULSE:
00102$:
;	src/main.c: 73: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
	cpw	y, #0x1f40
	jrule	00104$
	cpw	y, #0x2710
	jrnc	00104$
;	src/main.c: 74: ir_state = STATE_START_SPACE;
	mov	_ir_state+0, #0x02
	jp	00129$
00104$:
;	src/main.c: 75: } else { ir_state = STATE_IDLE; }
	clr	_ir_state+0
;	src/main.c: 76: break;
	jp	00129$
;	src/main.c: 77: case STATE_START_SPACE:
00107$:
;	src/main.c: 78: if (pulse_width > NEC_START_SPACE_MIN && pulse_width < NEC_START_SPACE_MAX) {
	cpw	y, #0x0fa0
	jrule	00109$
	cpw	y, #0x1388
	jrnc	00109$
;	src/main.c: 79: ir_state = STATE_BIT_PULSE;
	mov	_ir_state+0, #0x03
;	src/main.c: 80: ir_bit_count = 0;
	clr	_ir_bit_count+0
;	src/main.c: 81: ir_data = 0;
	clrw	x
	ldw	_ir_data+2, x
	ldw	_ir_data+0, x
	jp	00129$
00109$:
;	src/main.c: 82: } else { ir_state = STATE_IDLE; }
	clr	_ir_state+0
;	src/main.c: 83: break;
	jra	00129$
;	src/main.c: 84: case STATE_BIT_PULSE:
00112$:
;	src/main.c: 85: if (pulse_width > NEC_BIT_PULSE_MIN && pulse_width < NEC_BIT_PULSE_MAX) {
	cpw	y, #0x0190
	jrule	00114$
	cpw	y, #0x02bc
	jrnc	00114$
;	src/main.c: 86: ir_state = STATE_BIT_SPACE;
	mov	_ir_state+0, #0x04
	jra	00129$
00114$:
;	src/main.c: 87: } else { ir_state = STATE_IDLE; }
	clr	_ir_state+0
;	src/main.c: 88: break;
	jra	00129$
;	src/main.c: 90: case STATE_BIT_SPACE:
00117$:
;	src/main.c: 95: ir_data <<= 1;
	sll	_ir_data+3
	rlc	_ir_data+2
	rlc	_ir_data+1
	rlc	_ir_data+0
;	src/main.c: 97: if (pulse_width > NEC_LOGIC_1_SPACE_MIN && pulse_width < NEC_LOGIC_1_SPACE_MAX) {
	ldw	x, (0x03, sp)
	cpw	x, #0x05dc
	jrule	00122$
	cpw	x, #0x0708
	jrnc	00122$
;	src/main.c: 98: ir_data |= 1; // It's a '1', so set the new LSB
	ld	a, _ir_data+3
	or	a, #0x01
	ld	xl, a
	ld	a, _ir_data+2
	ld	xh, a
	ldw	y, _ir_data+0
	ldw	_ir_data+2, x
	ldw	_ir_data+0, y
	jra	00123$
00122$:
;	src/main.c: 100: else if (!(pulse_width > NEC_LOGIC_0_SPACE_MIN && pulse_width < NEC_LOGIC_0_SPACE_MAX)) {
	cpw	x, #0x0190
	jrule	00118$
	cpw	x, #0x02bc
	jrc	00123$
00118$:
;	src/main.c: 101: ir_state = STATE_IDLE; // Pulse width error
	clr	_ir_state+0
;	src/main.c: 102: break;
	jra	00129$
00123$:
;	src/main.c: 105: ir_bit_count++;
	inc	_ir_bit_count+0
;	src/main.c: 106: if (ir_bit_count == 32) {
	ld	a, _ir_bit_count+0
	cp	a, #0x20
	jrne	00126$
;	src/main.c: 107: ir_data_ready = 1;
	mov	_ir_data_ready+0, #0x01
;	src/main.c: 108: ir_state = STATE_IDLE;
	clr	_ir_state+0
;	src/main.c: 109: TIM2->CR1 &= ~(1 << 0);
	bres	0x5300, #0
;	src/main.c: 110: EXTI->CR1 = (2 << 6);
	mov	0x50a0+0, #0x80
	jra	00129$
00126$:
;	src/main.c: 112: ir_state = STATE_BIT_PULSE;
	mov	_ir_state+0, #0x03
;	src/main.c: 115: }
00129$:
;	src/main.c: 116: }
	addw	sp, #4
	iret
;	src/main.c: 118: void TIM2_Update_IRQHandler(void) __interrupt(13) {
;	-----------------------------------------
;	 function TIM2_Update_IRQHandler
;	-----------------------------------------
_TIM2_Update_IRQHandler:
;	src/main.c: 119: if (TIM2->SR1 & (1 << 0)) {
	ld	a, 0x5304
	srl	a
	jrnc	00103$
;	src/main.c: 120: ir_state = STATE_IDLE;
	clr	_ir_state+0
;	src/main.c: 121: TIM2->CR1 &= ~(1 << 0);
	bres	0x5300, #0
;	src/main.c: 122: EXTI->CR1 = (2 << 6);
	mov	0x50a0+0, #0x80
;	src/main.c: 123: TIM2->SR1 &= ~(1 << 0);
	bres	0x5304, #0
00103$:
;	src/main.c: 125: }
	iret
;	src/main.c: 128: void main(void) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #2
;	src/main.c: 129: CLK->CKDIVR = 0x00;
	mov	0x50c6+0, #0x00
;	src/main.c: 130: USART1_Init();
	call	_USART1_Init
;	src/main.c: 131: IR_GPIO_Init();
	call	_IR_GPIO_Init
;	src/main.c: 132: TIM2_Init();
	call	_TIM2_Init
;	src/main.c: 133: __asm__("rim");
	rim
;	src/main.c: 135: printf("\n\nSTM8S IR Receiver Ready (Fixed)\n");
	ldw	x, #(___str_1+0)
	call	_puts
;	src/main.c: 137: while (1) {
00108$:
;	src/main.c: 138: if (ir_data_ready) {
	ld	a, _ir_data_ready+0
	jreq	00108$
;	src/main.c: 143: uint8_t address = (ir_data >> 24) & 0xFF;
	ld	a, _ir_data+0
	ld	xl, a
;	src/main.c: 144: uint8_t not_address = (ir_data >> 16) & 0xFF;
	ld	a, _ir_data+1
	ld	(0x01, sp), a
;	src/main.c: 145: uint8_t command = (ir_data >> 8) & 0xFF;
	ld	a, _ir_data+2
	ld	xh, a
;	src/main.c: 146: uint8_t not_command = ir_data & 0xFF;
	ld	a, _ir_data+3
	ld	(0x02, sp), a
;	src/main.c: 148: if ((uint8_t)~address == not_address && (uint8_t)~command == not_command) {
	ld	a, xl
	cpl	a
	cp	a, (0x01, sp)
	jrne	00102$
	ld	a, xh
	cpl	a
	cp	a, (0x02, sp)
	jrne	00102$
;	src/main.c: 149: printf("OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX\n", address, command, ir_data);
	clrw	y
	exg	a, yl
	ld	a, xh
	exg	a, yl
	clr	a
	ld	xh, a
	push	_ir_data+3
	push	_ir_data+2
	push	_ir_data+1
	push	_ir_data+0
	pushw	y
	pushw	x
	push	#<(___str_2+0)
	push	#((___str_2+0) >> 8)
	call	_printf
	addw	sp, #10
	jra	00103$
00102$:
;	src/main.c: 151: printf("Error -> Raw: 0x%08lX\n", ir_data);
	ldw	x, #(___str_3+0)
	push	_ir_data+3
	push	_ir_data+2
	push	_ir_data+1
	push	_ir_data+0
	pushw	x
	call	_printf
	addw	sp, #6
00103$:
;	src/main.c: 154: ir_data_ready = 0; // Clear the flag
	clr	_ir_data_ready+0
	jra	00108$
;	src/main.c: 157: }
	addw	sp, #2
	ret
	.area CODE
	.area CONST
	.area CONST
___str_1:
	.db 0x0a
	.db 0x0a
	.ascii "STM8S IR Receiver Ready (Fixed)"
	.db 0x00
	.area CODE
	.area CONST
___str_2:
	.ascii "OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX"
	.db 0x0a
	.db 0x00
	.area CODE
	.area CONST
___str_3:
	.ascii "Error -> Raw: 0x%08lX"
	.db 0x0a
	.db 0x00
	.area CODE
	.area INITIALIZER
__xinit__ir_state:
	.db #0x00	; 0
__xinit__ir_data:
	.byte #0x00, #0x00, #0x00, #0x00	; 0
__xinit__ir_bit_count:
	.db #0x00	; 0
__xinit__ir_data_ready:
	.db #0x00	; 0
	.area CABS (ABS)
