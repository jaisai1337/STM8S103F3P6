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
;	src/main.c: 38: void USART1_Init(void) {
;	-----------------------------------------
;	 function USART1_Init
;	-----------------------------------------
_USART1_Init:
;	src/main.c: 39: GPIOD->DDR |= (1 << 5);  // Set PD5 as output
	bset	0x5011, #5
;	src/main.c: 40: GPIOD->CR1 |= (1 << 5);  // Push-pull
	bset	0x5012, #5
;	src/main.c: 43: USART1->BRR2 = 0x03;
	mov	0x5233+0, #0x03
;	src/main.c: 44: USART1->BRR1 = 0x68;
	mov	0x5232+0, #0x68
;	src/main.c: 46: USART1->CR2 |= (1 << 3);  // TEN: Enable TX
	bset	0x5235, #3
;	src/main.c: 47: }
	ret
;	src/main.c: 50: int putchar(int c) {
;	-----------------------------------------
;	 function putchar
;	-----------------------------------------
_putchar:
;	src/main.c: 51: if (c == '\n') putchar('\r');
	cpw	x, #0x000a
	jrne	00103$
	pushw	x
	ldw	x, #0x000d
	callr	_putchar
	popw	x
;	src/main.c: 52: while (!(USART1->SR & (1 << 7))); // Wait for TXE
00103$:
	ld	a, 0x5230
	jrpl	00103$
;	src/main.c: 53: USART1->DR = c;
	ld	a, xl
	ld	0x5231, a
;	src/main.c: 54: return c;
;	src/main.c: 55: }
	ret
;	src/main.c: 58: void TIM2_Init(void) {
;	-----------------------------------------
;	 function TIM2_Init
;	-----------------------------------------
_TIM2_Init:
;	src/main.c: 60: CLK->PCKENR1 |= (1 << 5);
	bset	0x50c7, #5
;	src/main.c: 63: TIM2->PSCR = 0x04; // 2^4 = 16
	mov	0x530e+0, #0x04
;	src/main.c: 66: TIM2->IER |= (1 << 0);
	bset	0x5303, #0
;	src/main.c: 67: }
	ret
;	src/main.c: 70: void IR_GPIO_Init(void) {
;	-----------------------------------------
;	 function IR_GPIO_Init
;	-----------------------------------------
_IR_GPIO_Init:
;	src/main.c: 72: GPIOD->DDR &= ~IR_PIN_MASK; // Input
	bres	0x5011, #3
;	src/main.c: 73: GPIOD->CR1 |= IR_PIN_MASK;  // Pull-up enabled
	bset	0x5012, #3
;	src/main.c: 74: GPIOD->CR2 |= IR_PIN_MASK;  // Interrupt enabled
	bset	0x5013, #3
;	src/main.c: 77: EXTI->CR1 = (2 << 6); // 10 = Falling edge only for Port D
	mov	0x50a0+0, #0x80
;	src/main.c: 78: }
	ret
;	src/main.c: 81: void EXTI_PORTD_IRQHandler(void) __interrupt(6) {
;	-----------------------------------------
;	 function EXTI_PORTD_IRQHandler
;	-----------------------------------------
_EXTI_PORTD_IRQHandler:
	sub	sp, #4
;	src/main.c: 84: uint16_t pulse_width = (TIM2->CNTRH << 8) | TIM2->CNTRL;
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
;	src/main.c: 85: TIM2->CNTRH = 0;
	mov	0x530c+0, #0x00
;	src/main.c: 86: TIM2->CNTRL = 0;
	mov	0x530d+0, #0x00
;	src/main.c: 88: switch (ir_state) {
	ld	a, _ir_state+0
	cp	a, #0x04
	jrule	00187$
	jp	00130$
00187$:
;	src/main.c: 99: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
	ldw	y, (0x03, sp)
;	src/main.c: 88: switch (ir_state) {
	clrw	x
	ld	xl, a
	sllw	x
	ldw	x, (#00188$, x)
	jp	(x)
00188$:
	.dw	#00101$
	.dw	#00102$
	.dw	#00107$
	.dw	#00112$
	.dw	#00117$
;	src/main.c: 89: case STATE_IDLE:
00101$:
;	src/main.c: 91: TIM2->CR1 |= (1 << 0); // Start timer
	bset	0x5300, #0
;	src/main.c: 92: ir_state = STATE_START_PULSE;
	mov	_ir_state+0, #0x01
;	src/main.c: 94: EXTI->CR1 = (3 << 6); // 11 = Rising and falling for Port D
	mov	0x50a0+0, #0xc0
;	src/main.c: 95: break;
	jp	00130$
;	src/main.c: 97: case STATE_START_PULSE:
00102$:
;	src/main.c: 99: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
	cpw	y, #0x1f40
	jrule	00104$
	cpw	y, #0x2710
	jrnc	00104$
;	src/main.c: 100: ir_state = STATE_START_SPACE;
	mov	_ir_state+0, #0x02
	jp	00130$
00104$:
;	src/main.c: 102: ir_state = STATE_IDLE; // Error, reset
	clr	_ir_state+0
;	src/main.c: 104: break;
	jp	00130$
;	src/main.c: 106: case STATE_START_SPACE:
00107$:
;	src/main.c: 108: if (pulse_width > NEC_START_SPACE_MIN && pulse_width < NEC_START_SPACE_MAX) {
	cpw	y, #0x0fa0
	jrule	00109$
	cpw	y, #0x1388
	jrnc	00109$
;	src/main.c: 109: ir_state = STATE_BIT_PULSE;
	mov	_ir_state+0, #0x03
;	src/main.c: 110: ir_bit_count = 0;
	clr	_ir_bit_count+0
;	src/main.c: 111: ir_data = 0;
	clrw	x
	ldw	_ir_data+2, x
	ldw	_ir_data+0, x
	jp	00130$
00109$:
;	src/main.c: 113: ir_state = STATE_IDLE; // Error, reset
	clr	_ir_state+0
;	src/main.c: 115: break;
	jra	00130$
;	src/main.c: 117: case STATE_BIT_PULSE:
00112$:
;	src/main.c: 119: if (pulse_width > NEC_BIT_PULSE_MIN && pulse_width < NEC_BIT_PULSE_MAX) {
	cpw	y, #0x0190
	jrule	00114$
	cpw	y, #0x02bc
	jrnc	00114$
;	src/main.c: 120: ir_state = STATE_BIT_SPACE;
	mov	_ir_state+0, #0x04
	jra	00130$
00114$:
;	src/main.c: 122: ir_state = STATE_IDLE; // Error, reset
	clr	_ir_state+0
;	src/main.c: 124: break;
	jra	00130$
;	src/main.c: 126: case STATE_BIT_SPACE:
00117$:
;	src/main.c: 128: ir_data >>= 1; // Shift right to make space for the new bit (MSB first)
	srl	_ir_data+0
	rrc	_ir_data+1
	rrc	_ir_data+2
	rrc	_ir_data+3
;	src/main.c: 130: if (pulse_width > NEC_LOGIC_1_SPACE_MIN && pulse_width < NEC_LOGIC_1_SPACE_MAX) {
	ldw	x, (0x03, sp)
	cpw	x, #0x05dc
	jrule	00123$
	cpw	x, #0x0708
	jrnc	00123$
;	src/main.c: 131: ir_data |= 0x80000000; // It's a '1'
	ldw	y, _ir_data+2
	ld	a, _ir_data+1
	ld	xl, a
	ld	a, _ir_data+0
	or	a, #0x80
	ld	xh, a
	ldw	_ir_data+2, y
	ldw	_ir_data+0, x
	jra	00124$
00123$:
;	src/main.c: 132: } else if (pulse_width > NEC_LOGIC_0_SPACE_MIN && pulse_width < NEC_LOGIC_0_SPACE_MAX) {
	cpw	x, #0x0190
	jrule	00119$
	cpw	x, #0x02bc
	jrc	00124$
00119$:
;	src/main.c: 135: ir_state = STATE_IDLE; // Pulse width error
	clr	_ir_state+0
;	src/main.c: 136: break;
	jra	00130$
00124$:
;	src/main.c: 139: ir_bit_count++;
	inc	_ir_bit_count+0
;	src/main.c: 140: if (ir_bit_count == 32) {
	ld	a, _ir_bit_count+0
	cp	a, #0x20
	jrne	00127$
;	src/main.c: 142: ir_data_ready = 1;
	mov	_ir_data_ready+0, #0x01
;	src/main.c: 143: ir_state = STATE_IDLE;
	clr	_ir_state+0
;	src/main.c: 144: TIM2->CR1 &= ~(1 << 0); // Stop timer
	bres	0x5300, #0
;	src/main.c: 145: EXTI->CR1 = (2 << 6);  // Reset EXTI back to falling edge only
	mov	0x50a0+0, #0x80
	jra	00130$
00127$:
;	src/main.c: 147: ir_state = STATE_BIT_PULSE; // Ready for the next bit pulse
	mov	_ir_state+0, #0x03
;	src/main.c: 150: }
00130$:
;	src/main.c: 151: }
	addw	sp, #4
	iret
;	src/main.c: 154: void TIM2_Update_IRQHandler(void) __interrupt(13) {
;	-----------------------------------------
;	 function TIM2_Update_IRQHandler
;	-----------------------------------------
_TIM2_Update_IRQHandler:
;	src/main.c: 155: if (TIM2->SR1 & (1 << 0)) { // Check if it's an update interrupt
	ld	a, 0x5304
	srl	a
	jrnc	00103$
;	src/main.c: 157: ir_state = STATE_IDLE;
	clr	_ir_state+0
;	src/main.c: 158: TIM2->CR1 &= ~(1 << 0); // Stop timer
	bres	0x5300, #0
;	src/main.c: 159: EXTI->CR1 = (2 << 6);  // Reset EXTI back to falling edge only
	mov	0x50a0+0, #0x80
;	src/main.c: 160: TIM2->SR1 &= ~(1 << 0); // Clear the interrupt flag
	bres	0x5304, #0
00103$:
;	src/main.c: 162: }
	iret
;	src/main.c: 165: void main(void) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #11
;	src/main.c: 167: CLK->CKDIVR = 0x00;
	mov	0x50c6+0, #0x00
;	src/main.c: 170: USART1_Init();
	call	_USART1_Init
;	src/main.c: 171: IR_GPIO_Init();
	call	_IR_GPIO_Init
;	src/main.c: 172: TIM2_Init();
	call	_TIM2_Init
;	src/main.c: 175: __asm__("rim");
	rim
;	src/main.c: 177: printf("\n\nSTM8S IR Receiver Ready\n");
	ldw	x, #(___str_1+0)
	call	_puts
;	src/main.c: 179: while (1) {
00111$:
;	src/main.c: 180: if (ir_data_ready) {
	ld	a, _ir_data_ready+0
	jreq	00111$
;	src/main.c: 184: uint32_t temp = ir_data;
	ldw	x, _ir_data+2
	ldw	(0x03, sp), x
	ldw	x, _ir_data+0
	ldw	(0x01, sp), x
;	src/main.c: 185: uint32_t reversed_data = 0;
	clrw	x
	ldw	(0x0a, sp), x
	ldw	(0x08, sp), x
;	src/main.c: 186: for(int i = 0; i < 32; i++) {
	clrw	x
	ldw	(0x06, sp), x
00114$:
	ldw	x, (0x06, sp)
	cpw	x, #0x0020
	jrsge	00103$
;	src/main.c: 187: if((temp >> i) & 1) {
	ldw	x, (0x03, sp)
	ldw	y, (0x01, sp)
	ld	a, (0x07, sp)
	jreq	00157$
00156$:
	srlw	y
	rrcw	x
	dec	a
	jrne	00156$
00157$:
	srlw	x
	jrnc	00115$
;	src/main.c: 188: reversed_data |= (1UL << (31-i));
	ld	a, (0x07, sp)
	ld	(0x05, sp), a
	ld	a, #0x1f
	sub	a, (0x05, sp)
	clrw	x
	incw	x
	clrw	y
	tnz	a
	jreq	00160$
00159$:
	sllw	x
	rlcw	y
	dec	a
	jrne	00159$
00160$:
	ld	a, xl
	or	a, (0x0b, sp)
	ld	(0x0b, sp), a
	ld	a, xh
	or	a, (0x0a, sp)
	ld	(0x0a, sp), a
	ld	a, yl
	or	a, (0x09, sp)
	ld	(0x09, sp), a
	ld	a, yh
	or	a, (0x08, sp)
	ld	(0x08, sp), a
00115$:
;	src/main.c: 186: for(int i = 0; i < 32; i++) {
	ldw	x, (0x06, sp)
	incw	x
	ldw	(0x06, sp), x
	jra	00114$
00103$:
;	src/main.c: 192: uint8_t address = (reversed_data >> 24) & 0xFF;
	ld	a, (0x08, sp)
	ld	(0x04, sp), a
;	src/main.c: 193: uint8_t not_address = (reversed_data >> 16) & 0xFF;
	ld	a, (0x09, sp)
	ld	(0x05, sp), a
;	src/main.c: 194: uint8_t command = (reversed_data >> 8) & 0xFF;
	ld	a, (0x0a, sp)
	ld	(0x06, sp), a
;	src/main.c: 195: uint8_t not_command = reversed_data & 0xFF;
	ld	a, (0x0b, sp)
	ld	(0x07, sp), a
;	src/main.c: 198: if ((uint8_t)~address == not_address && (uint8_t)~command == not_command) {
	ld	a, (0x04, sp)
	cpl	a
	cp	a, (0x05, sp)
	jrne	00105$
	ld	a, (0x06, sp)
	cpl	a
	cp	a, (0x07, sp)
	jrne	00105$
;	src/main.c: 199: printf("OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX\n", address, command, reversed_data);
	clrw	x
	ld	a, (0x06, sp)
	ld	xl, a
	ld	a, (0x04, sp)
	clr	(0x06, sp)
	ldw	y, (0x0a, sp)
	pushw	y
	ldw	y, (0x0a, sp)
	pushw	y
	pushw	x
	push	a
	ld	a, (0x0d, sp)
	push	a
	push	#<(___str_2+0)
	push	#((___str_2+0) >> 8)
	call	_printf
	addw	sp, #10
	jra	00106$
00105$:
;	src/main.c: 201: printf("Error -> Raw: 0x%08lX\n", reversed_data);
	ldw	x, (0x0a, sp)
	pushw	x
	ldw	x, (0x0a, sp)
	pushw	x
	push	#<(___str_3+0)
	push	#((___str_3+0) >> 8)
	call	_printf
	addw	sp, #6
00106$:
;	src/main.c: 204: ir_data_ready = 0; // Clear the flag
	clr	_ir_data_ready+0
;	src/main.c: 207: }
	jp	00111$
	.area CODE
	.area CONST
	.area CONST
___str_1:
	.db 0x0a
	.db 0x0a
	.ascii "STM8S IR Receiver Ready"
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
