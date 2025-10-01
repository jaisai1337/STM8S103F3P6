;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.2.0 #13081 (Linux)
;--------------------------------------------------------
	.module nec
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _TIM2_Update_IRQHandler
	.globl _EXTI_PORTD_IRQHandler
	.globl _printf
	.globl _nec_init
	.globl _nec_data_ready
	.globl _nec_get_data
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_ir_state:
	.ds 1
_ir_data:
	.ds 4
_ir_bit_count:
	.ds 1
_ir_data_ready_flag:
	.ds 1
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
;	src/nec.c: 44: void nec_init(void) {
;	-----------------------------------------
;	 function nec_init
;	-----------------------------------------
_nec_init:
;	src/nec.c: 45: ir_gpio_init();
	call	_ir_gpio_init
;	src/nec.c: 46: tim2_init();
;	src/nec.c: 47: }
	jp	_tim2_init
;	src/nec.c: 49: uint8_t nec_data_ready(void) {
;	-----------------------------------------
;	 function nec_data_ready
;	-----------------------------------------
_nec_data_ready:
;	src/nec.c: 50: return ir_data_ready_flag;
	ld	a, _ir_data_ready_flag+0
;	src/nec.c: 51: }
	ret
;	src/nec.c: 53: uint8_t nec_get_data(nec_decoded_data_t *data) {
;	-----------------------------------------
;	 function nec_get_data
;	-----------------------------------------
_nec_get_data:
	sub	sp, #6
	ldw	(0x05, sp), x
;	src/nec.c: 54: if (!ir_data_ready_flag) {
	tnz	_ir_data_ready_flag+0
	jrne	00102$
;	src/nec.c: 55: return 0; // No new data available
	clr	a
	jra	00103$
00102$:
;	src/nec.c: 58: __asm__("sim"); // Disable interrupts to safely copy data
	sim
;	src/nec.c: 59: data->raw_data = ir_data;
	ldw	x, (0x05, sp)
	incw	x
	incw	x
	ldw	y, _ir_data+2
	ldw	(0x2, x), y
	ldw	y, _ir_data+0
	ldw	(x), y
;	src/nec.c: 60: ir_data_ready_flag = 0; // Clear the flag
	clr	_ir_data_ready_flag+0
;	src/nec.c: 61: __asm__("rim"); // Re-enable interrupts
	rim
;	src/nec.c: 64: data->address = (data->raw_data >> 24) & 0xFF;
	ldw	y, x
	ldw	y, (0x2, y)
	ld	a, (0x1, x)
	ld	(0x02, sp), a
	ld	a, (x)
	ldw	y, (0x05, sp)
	ld	(y), a
;	src/nec.c: 65: data->command = (data->raw_data >> 8) & 0xFF;
	ldw	y, (0x05, sp)
	incw	y
	ld	a, (0x3, x)
	ld	(0x04, sp), a
	ld	a, (0x2, x)
	ldw	x, (x)
	ld	(y), a
;	src/nec.c: 67: return 1; // Indicate success
	ld	a, #0x01
00103$:
;	src/nec.c: 68: }
	addw	sp, #6
	ret
;	src/nec.c: 72: static void tim2_init(void) {
;	-----------------------------------------
;	 function tim2_init
;	-----------------------------------------
_tim2_init:
;	src/nec.c: 73: CLK->PCKENR1 |= (1 << 5); // Enable TIM2 clock
	bset	0x50c7, #5
;	src/nec.c: 74: TIM2->PSCR = 0x04;        // Prescaler = 16 (16MHz/16 -> 1us tick)
	mov	0x530e+0, #0x04
;	src/nec.c: 75: TIM2->IER |= (1 << 0);    // Enable Update Interrupt for timeouts
	bset	0x5303, #0
;	src/nec.c: 76: }
	ret
;	src/nec.c: 78: static void ir_gpio_init(void) {
;	-----------------------------------------
;	 function ir_gpio_init
;	-----------------------------------------
_ir_gpio_init:
;	src/nec.c: 79: IR_PORT->DDR &= ~IR_PIN_MASK; // Set as input
	bres	0x5011, #3
;	src/nec.c: 80: IR_PORT->CR1 |= IR_PIN_MASK;  // Enable pull-up resistor
	bset	0x5012, #3
;	src/nec.c: 81: IR_PORT->CR2 |= IR_PIN_MASK;  // Enable external interrupt for the pin
	ld	a, 0x5013
	or	a, #0x08
	ld	0x5013, a
;	src/nec.c: 84: EXTI->CR1 &= ~(3 << 6); // Clear bits 7 and 6
	ld	a, 0x50a0
	and	a, #0x3f
	ld	0x50a0, a
;	src/nec.c: 85: EXTI->CR1 |= (2 << 6);  // Set bits for falling edge
	bset	0x50a0, #7
;	src/nec.c: 86: }
	ret
;	src/nec.c: 90: void EXTI_PORTD_IRQHandler(void) __interrupt(6) {
;	-----------------------------------------
;	 function EXTI_PORTD_IRQHandler
;	-----------------------------------------
_EXTI_PORTD_IRQHandler:
	clr	a
	div	x, a
	sub	sp, #4
;	src/nec.c: 91: uint16_t pulse_width = (TIM2->CNTRH << 8) | TIM2->CNTRL;
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
;	src/nec.c: 92: TIM2->CNTRH = 0;
	mov	0x530c+0, #0x00
;	src/nec.c: 93: TIM2->CNTRL = 0;
	mov	0x530d+0, #0x00
;	src/nec.c: 95: switch (ir_state) {
	ld	a, _ir_state+0
	cp	a, #0x04
	jrule	00186$
	jp	00129$
00186$:
;	src/nec.c: 104: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
	ldw	y, (0x03, sp)
;	src/nec.c: 95: switch (ir_state) {
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
;	src/nec.c: 96: case STATE_IDLE:
00101$:
;	src/nec.c: 97: TIM2->CR1 |= (1 << 0);      // Start timer
	ld	a, 0x5300
	or	a, #0x01
	ld	0x5300, a
;	src/nec.c: 98: ir_state = STATE_START_PULSE;
	mov	_ir_state+0, #0x01
;	src/nec.c: 99: EXTI->CR1 &= ~(3 << 6);       // Clear bits
	ld	a, 0x50a0
	and	a, #0x3f
	ld	0x50a0, a
;	src/nec.c: 100: EXTI->CR1 |= (3 << 6);        // Reconfigure to trigger on both edges
	ld	a, 0x50a0
	or	a, #0xc0
	ld	0x50a0, a
;	src/nec.c: 101: break;
	jp	00129$
;	src/nec.c: 103: case STATE_START_PULSE:
00102$:
;	src/nec.c: 104: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
	cpw	y, #0x1d4c
	jrule	00104$
	cpw	y, #0x2904
	jrnc	00104$
;	src/nec.c: 105: ir_state = STATE_START_SPACE;
	mov	_ir_state+0, #0x02
	jp	00129$
00104$:
;	src/nec.c: 107: ir_state = STATE_IDLE;
	clr	_ir_state+0
;	src/nec.c: 108: printf("E1 "); // Error: Bad start pulse timing
	push	#<(___str_0+0)
	push	#((___str_0+0) >> 8)
	call	_printf
	addw	sp, #2
;	src/nec.c: 110: break;
	jp	00129$
;	src/nec.c: 112: case STATE_START_SPACE:
00107$:
;	src/nec.c: 113: if (pulse_width > NEC_START_SPACE_MIN && pulse_width < NEC_START_SPACE_MAX) {
	cpw	y, #0x0dac
	jrule	00109$
	cpw	y, #0x157c
	jrnc	00109$
;	src/nec.c: 114: ir_state = STATE_BIT_PULSE;
	mov	_ir_state+0, #0x03
;	src/nec.c: 115: ir_bit_count = 0;
	clr	_ir_bit_count+0
;	src/nec.c: 116: ir_data = 0;
	clrw	x
	ldw	_ir_data+2, x
	ldw	_ir_data+0, x
	jp	00129$
00109$:
;	src/nec.c: 118: ir_state = STATE_IDLE;
	clr	_ir_state+0
;	src/nec.c: 119: printf("E2 "); // Error: Bad start space timing
	push	#<(___str_1+0)
	push	#((___str_1+0) >> 8)
	call	_printf
	addw	sp, #2
;	src/nec.c: 121: break;
	jp	00129$
;	src/nec.c: 123: case STATE_BIT_PULSE:
00112$:
;	src/nec.c: 124: if (pulse_width > NEC_BIT_PULSE_MIN && pulse_width < NEC_BIT_PULSE_MAX) {
	cpw	y, #0x015e
	jrule	00114$
	cpw	y, #0x0320
	jrnc	00114$
;	src/nec.c: 125: ir_state = STATE_BIT_SPACE;
	mov	_ir_state+0, #0x04
	jp	00129$
00114$:
;	src/nec.c: 127: ir_state = STATE_IDLE;
	clr	_ir_state+0
;	src/nec.c: 128: printf("E3 "); // Error: Bad bit pulse timing
	push	#<(___str_2+0)
	push	#((___str_2+0) >> 8)
	call	_printf
	addw	sp, #2
;	src/nec.c: 130: break;
	jra	00129$
;	src/nec.c: 132: case STATE_BIT_SPACE:
00117$:
;	src/nec.c: 133: ir_data <<= 1; // Shift left to make room for the new bit (LSB first)
	sll	_ir_data+3
	rlc	_ir_data+2
	rlc	_ir_data+1
	rlc	_ir_data+0
;	src/nec.c: 134: if (pulse_width > NEC_LOGIC_1_SPACE_MIN && pulse_width < NEC_LOGIC_1_SPACE_MAX) {
	ldw	x, (0x03, sp)
	cpw	x, #0x0578
	jrule	00122$
	cpw	x, #0x076c
	jrnc	00122$
;	src/nec.c: 135: ir_data |= 1; // It's a '1'
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
;	src/nec.c: 136: } else if (!(pulse_width > NEC_LOGIC_0_SPACE_MIN && pulse_width < NEC_LOGIC_0_SPACE_MAX)) {
	cpw	x, #0x015e
	jrule	00118$
	cpw	x, #0x0320
	jrc	00123$
00118$:
;	src/nec.c: 137: ir_state = STATE_IDLE; // Pulse width error
	clr	_ir_state+0
;	src/nec.c: 138: printf("E4 "); // Error: Bad bit space timing
	push	#<(___str_3+0)
	push	#((___str_3+0) >> 8)
	call	_printf
	addw	sp, #2
;	src/nec.c: 139: break;
	jra	00129$
00123$:
;	src/nec.c: 141: ir_bit_count++;
	inc	_ir_bit_count+0
;	src/nec.c: 142: if (ir_bit_count == 32) {
	ld	a, _ir_bit_count+0
	cp	a, #0x20
	jrne	00126$
;	src/nec.c: 143: ir_data_ready_flag = 1; // Set flag for main loop
	mov	_ir_data_ready_flag+0, #0x01
;	src/nec.c: 144: ir_state = STATE_IDLE;
	clr	_ir_state+0
;	src/nec.c: 145: TIM2->CR1 &= ~(1 << 0); // Stop timer
	ld	a, 0x5300
	and	a, #0xfe
	ld	0x5300, a
;	src/nec.c: 146: EXTI->CR1 &= ~(3 << 6);   // Clear bits
	ld	a, 0x50a0
	and	a, #0x3f
	ld	0x50a0, a
;	src/nec.c: 147: EXTI->CR1 |= (2 << 6);    // Reset EXTI to falling edge only
	bset	0x50a0, #7
	jra	00129$
00126$:
;	src/nec.c: 149: ir_state = STATE_BIT_PULSE;
	mov	_ir_state+0, #0x03
;	src/nec.c: 152: }
00129$:
;	src/nec.c: 153: }
	addw	sp, #4
	iret
;	src/nec.c: 155: void TIM2_Update_IRQHandler(void) __interrupt(13) {
;	-----------------------------------------
;	 function TIM2_Update_IRQHandler
;	-----------------------------------------
_TIM2_Update_IRQHandler:
	clr	a
	div	x, a
;	src/nec.c: 156: if (TIM2->SR1 & (1 << 0)) { // Check for update interrupt flag
	ld	a, 0x5304
	srl	a
	jrnc	00105$
;	src/nec.c: 157: if(ir_state != STATE_IDLE) {
	ld	a, _ir_state+0
	jreq	00102$
;	src/nec.c: 159: ir_state = STATE_IDLE;
	clr	_ir_state+0
;	src/nec.c: 160: printf("T "); // Timed out
	push	#<(___str_4+0)
	push	#((___str_4+0) >> 8)
	call	_printf
	addw	sp, #2
00102$:
;	src/nec.c: 162: TIM2->CR1 &= ~(1 << 0); // Stop timer
	ld	a, 0x5300
	and	a, #0xfe
	ld	0x5300, a
;	src/nec.c: 163: EXTI->CR1 &= ~(3 << 6);   // Clear bits
	ld	a, 0x50a0
	and	a, #0x3f
	ld	0x50a0, a
;	src/nec.c: 164: EXTI->CR1 |= (2 << 6);    // Reset EXTI to falling edge only
	bset	0x50a0, #7
;	src/nec.c: 165: TIM2->SR1 &= ~(1 << 0); // Clear the interrupt flag
	bres	0x5304, #0
00105$:
;	src/nec.c: 167: }
	iret
	.area CODE
	.area CONST
	.area CONST
___str_0:
	.ascii "E1 "
	.db 0x00
	.area CODE
	.area CONST
___str_1:
	.ascii "E2 "
	.db 0x00
	.area CODE
	.area CONST
___str_2:
	.ascii "E3 "
	.db 0x00
	.area CODE
	.area CONST
___str_3:
	.ascii "E4 "
	.db 0x00
	.area CODE
	.area CONST
___str_4:
	.ascii "T "
	.db 0x00
	.area CODE
	.area INITIALIZER
__xinit__ir_state:
	.db #0x00	; 0
__xinit__ir_data:
	.byte #0x00, #0x00, #0x00, #0x00	; 0
__xinit__ir_bit_count:
	.db #0x00	; 0
__xinit__ir_data_ready_flag:
	.db #0x00	; 0
	.area CABS (ABS)
