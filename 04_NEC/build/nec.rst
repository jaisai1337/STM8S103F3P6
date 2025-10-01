                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.2.0 #13081 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module nec
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _TIM2_Update_IRQHandler
                                     12 	.globl _EXTI_PORTD_IRQHandler
                                     13 	.globl _printf
                                     14 	.globl _nec_init
                                     15 	.globl _nec_data_ready
                                     16 	.globl _nec_get_data
                                     17 ;--------------------------------------------------------
                                     18 ; ram data
                                     19 ;--------------------------------------------------------
                                     20 	.area DATA
                                     21 ;--------------------------------------------------------
                                     22 ; ram data
                                     23 ;--------------------------------------------------------
                                     24 	.area INITIALIZED
      000001                         25 _ir_state:
      000001                         26 	.ds 1
      000002                         27 _ir_data:
      000002                         28 	.ds 4
      000006                         29 _ir_bit_count:
      000006                         30 	.ds 1
      000007                         31 _ir_data_ready_flag:
      000007                         32 	.ds 1
                                     33 ;--------------------------------------------------------
                                     34 ; absolute external ram data
                                     35 ;--------------------------------------------------------
                                     36 	.area DABS (ABS)
                                     37 
                                     38 ; default segment ordering for linker
                                     39 	.area HOME
                                     40 	.area GSINIT
                                     41 	.area GSFINAL
                                     42 	.area CONST
                                     43 	.area INITIALIZER
                                     44 	.area CODE
                                     45 
                                     46 ;--------------------------------------------------------
                                     47 ; global & static initialisations
                                     48 ;--------------------------------------------------------
                                     49 	.area HOME
                                     50 	.area GSINIT
                                     51 	.area GSFINAL
                                     52 	.area GSINIT
                                     53 ;--------------------------------------------------------
                                     54 ; Home
                                     55 ;--------------------------------------------------------
                                     56 	.area HOME
                                     57 	.area HOME
                                     58 ;--------------------------------------------------------
                                     59 ; code
                                     60 ;--------------------------------------------------------
                                     61 	.area CODE
                                     62 ;	src/nec.c: 44: void nec_init(void) {
                                     63 ;	-----------------------------------------
                                     64 ;	 function nec_init
                                     65 ;	-----------------------------------------
      008174                         66 _nec_init:
                                     67 ;	src/nec.c: 45: ir_gpio_init();
      008174 CD 81 CD         [ 4]   68 	call	_ir_gpio_init
                                     69 ;	src/nec.c: 46: tim2_init();
                                     70 ;	src/nec.c: 47: }
      008177 CC 81 C0         [ 2]   71 	jp	_tim2_init
                                     72 ;	src/nec.c: 49: uint8_t nec_data_ready(void) {
                                     73 ;	-----------------------------------------
                                     74 ;	 function nec_data_ready
                                     75 ;	-----------------------------------------
      00817A                         76 _nec_data_ready:
                                     77 ;	src/nec.c: 50: return ir_data_ready_flag;
      00817A C6 00 07         [ 1]   78 	ld	a, _ir_data_ready_flag+0
                                     79 ;	src/nec.c: 51: }
      00817D 81               [ 4]   80 	ret
                                     81 ;	src/nec.c: 53: uint8_t nec_get_data(nec_decoded_data_t *data) {
                                     82 ;	-----------------------------------------
                                     83 ;	 function nec_get_data
                                     84 ;	-----------------------------------------
      00817E                         85 _nec_get_data:
      00817E 52 06            [ 2]   86 	sub	sp, #6
      008180 1F 05            [ 2]   87 	ldw	(0x05, sp), x
                                     88 ;	src/nec.c: 54: if (!ir_data_ready_flag) {
      008182 72 5D 00 07      [ 1]   89 	tnz	_ir_data_ready_flag+0
      008186 26 03            [ 1]   90 	jrne	00102$
                                     91 ;	src/nec.c: 55: return 0; // No new data available
      008188 4F               [ 1]   92 	clr	a
      008189 20 32            [ 2]   93 	jra	00103$
      00818B                         94 00102$:
                                     95 ;	src/nec.c: 58: __asm__("sim"); // Disable interrupts to safely copy data
      00818B 9B               [ 1]   96 	sim
                                     97 ;	src/nec.c: 59: data->raw_data = ir_data;
      00818C 1E 05            [ 2]   98 	ldw	x, (0x05, sp)
      00818E 5C               [ 1]   99 	incw	x
      00818F 5C               [ 1]  100 	incw	x
      008190 90 CE 00 04      [ 2]  101 	ldw	y, _ir_data+2
      008194 EF 02            [ 2]  102 	ldw	(0x2, x), y
      008196 90 CE 00 02      [ 2]  103 	ldw	y, _ir_data+0
      00819A FF               [ 2]  104 	ldw	(x), y
                                    105 ;	src/nec.c: 60: ir_data_ready_flag = 0; // Clear the flag
      00819B 72 5F 00 07      [ 1]  106 	clr	_ir_data_ready_flag+0
                                    107 ;	src/nec.c: 61: __asm__("rim"); // Re-enable interrupts
      00819F 9A               [ 1]  108 	rim
                                    109 ;	src/nec.c: 64: data->address = (data->raw_data >> 24) & 0xFF;
      0081A0 90 93            [ 1]  110 	ldw	y, x
      0081A2 90 EE 02         [ 2]  111 	ldw	y, (0x2, y)
      0081A5 E6 01            [ 1]  112 	ld	a, (0x1, x)
      0081A7 6B 02            [ 1]  113 	ld	(0x02, sp), a
      0081A9 F6               [ 1]  114 	ld	a, (x)
      0081AA 16 05            [ 2]  115 	ldw	y, (0x05, sp)
      0081AC 90 F7            [ 1]  116 	ld	(y), a
                                    117 ;	src/nec.c: 65: data->command = (data->raw_data >> 8) & 0xFF;
      0081AE 16 05            [ 2]  118 	ldw	y, (0x05, sp)
      0081B0 90 5C            [ 1]  119 	incw	y
      0081B2 E6 03            [ 1]  120 	ld	a, (0x3, x)
      0081B4 6B 04            [ 1]  121 	ld	(0x04, sp), a
      0081B6 E6 02            [ 1]  122 	ld	a, (0x2, x)
      0081B8 FE               [ 2]  123 	ldw	x, (x)
      0081B9 90 F7            [ 1]  124 	ld	(y), a
                                    125 ;	src/nec.c: 67: return 1; // Indicate success
      0081BB A6 01            [ 1]  126 	ld	a, #0x01
      0081BD                        127 00103$:
                                    128 ;	src/nec.c: 68: }
      0081BD 5B 06            [ 2]  129 	addw	sp, #6
      0081BF 81               [ 4]  130 	ret
                                    131 ;	src/nec.c: 72: static void tim2_init(void) {
                                    132 ;	-----------------------------------------
                                    133 ;	 function tim2_init
                                    134 ;	-----------------------------------------
      0081C0                        135 _tim2_init:
                                    136 ;	src/nec.c: 73: CLK->PCKENR1 |= (1 << 5); // Enable TIM2 clock
      0081C0 72 1A 50 C7      [ 1]  137 	bset	0x50c7, #5
                                    138 ;	src/nec.c: 74: TIM2->PSCR = 0x04;        // Prescaler = 16 (16MHz/16 -> 1us tick)
      0081C4 35 04 53 0E      [ 1]  139 	mov	0x530e+0, #0x04
                                    140 ;	src/nec.c: 75: TIM2->IER |= (1 << 0);    // Enable Update Interrupt for timeouts
      0081C8 72 10 53 03      [ 1]  141 	bset	0x5303, #0
                                    142 ;	src/nec.c: 76: }
      0081CC 81               [ 4]  143 	ret
                                    144 ;	src/nec.c: 78: static void ir_gpio_init(void) {
                                    145 ;	-----------------------------------------
                                    146 ;	 function ir_gpio_init
                                    147 ;	-----------------------------------------
      0081CD                        148 _ir_gpio_init:
                                    149 ;	src/nec.c: 79: IR_PORT->DDR &= ~IR_PIN_MASK; // Set as input
      0081CD 72 17 50 11      [ 1]  150 	bres	0x5011, #3
                                    151 ;	src/nec.c: 80: IR_PORT->CR1 |= IR_PIN_MASK;  // Enable pull-up resistor
      0081D1 72 16 50 12      [ 1]  152 	bset	0x5012, #3
                                    153 ;	src/nec.c: 81: IR_PORT->CR2 |= IR_PIN_MASK;  // Enable external interrupt for the pin
      0081D5 C6 50 13         [ 1]  154 	ld	a, 0x5013
      0081D8 AA 08            [ 1]  155 	or	a, #0x08
      0081DA C7 50 13         [ 1]  156 	ld	0x5013, a
                                    157 ;	src/nec.c: 84: EXTI->CR1 &= ~(3 << 6); // Clear bits 7 and 6
      0081DD C6 50 A0         [ 1]  158 	ld	a, 0x50a0
      0081E0 A4 3F            [ 1]  159 	and	a, #0x3f
      0081E2 C7 50 A0         [ 1]  160 	ld	0x50a0, a
                                    161 ;	src/nec.c: 85: EXTI->CR1 |= (2 << 6);  // Set bits for falling edge
      0081E5 72 1E 50 A0      [ 1]  162 	bset	0x50a0, #7
                                    163 ;	src/nec.c: 86: }
      0081E9 81               [ 4]  164 	ret
                                    165 ;	src/nec.c: 90: void EXTI_PORTD_IRQHandler(void) __interrupt(6) {
                                    166 ;	-----------------------------------------
                                    167 ;	 function EXTI_PORTD_IRQHandler
                                    168 ;	-----------------------------------------
      0081EA                        169 _EXTI_PORTD_IRQHandler:
      0081EA 4F               [ 1]  170 	clr	a
      0081EB 62               [ 2]  171 	div	x, a
      0081EC 52 04            [ 2]  172 	sub	sp, #4
                                    173 ;	src/nec.c: 91: uint16_t pulse_width = (TIM2->CNTRH << 8) | TIM2->CNTRL;
      0081EE C6 53 0C         [ 1]  174 	ld	a, 0x530c
      0081F1 95               [ 1]  175 	ld	xh, a
      0081F2 0F 02            [ 1]  176 	clr	(0x02, sp)
      0081F4 C6 53 0D         [ 1]  177 	ld	a, 0x530d
      0081F7 0F 03            [ 1]  178 	clr	(0x03, sp)
      0081F9 1A 02            [ 1]  179 	or	a, (0x02, sp)
      0081FB 02               [ 1]  180 	rlwa	x
      0081FC 1A 03            [ 1]  181 	or	a, (0x03, sp)
      0081FE 95               [ 1]  182 	ld	xh, a
      0081FF 1F 03            [ 2]  183 	ldw	(0x03, sp), x
                                    184 ;	src/nec.c: 92: TIM2->CNTRH = 0;
      008201 35 00 53 0C      [ 1]  185 	mov	0x530c+0, #0x00
                                    186 ;	src/nec.c: 93: TIM2->CNTRL = 0;
      008205 35 00 53 0D      [ 1]  187 	mov	0x530d+0, #0x00
                                    188 ;	src/nec.c: 95: switch (ir_state) {
      008209 C6 00 01         [ 1]  189 	ld	a, _ir_state+0
      00820C A1 04            [ 1]  190 	cp	a, #0x04
      00820E 23 03            [ 2]  191 	jrule	00186$
      008210 CC 83 31         [ 2]  192 	jp	00129$
      008213                        193 00186$:
                                    194 ;	src/nec.c: 104: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
      008213 16 03            [ 2]  195 	ldw	y, (0x03, sp)
                                    196 ;	src/nec.c: 95: switch (ir_state) {
      008215 5F               [ 1]  197 	clrw	x
      008216 97               [ 1]  198 	ld	xl, a
      008217 58               [ 2]  199 	sllw	x
      008218 DE 82 1C         [ 2]  200 	ldw	x, (#00187$, x)
      00821B FC               [ 2]  201 	jp	(x)
      00821C                        202 00187$:
      00821C 82 26                  203 	.dw	#00101$
      00821E 82 45                  204 	.dw	#00102$
      008220 82 68                  205 	.dw	#00107$
      008222 82 96                  206 	.dw	#00112$
      008224 82 B8                  207 	.dw	#00117$
                                    208 ;	src/nec.c: 96: case STATE_IDLE:
      008226                        209 00101$:
                                    210 ;	src/nec.c: 97: TIM2->CR1 |= (1 << 0);      // Start timer
      008226 C6 53 00         [ 1]  211 	ld	a, 0x5300
      008229 AA 01            [ 1]  212 	or	a, #0x01
      00822B C7 53 00         [ 1]  213 	ld	0x5300, a
                                    214 ;	src/nec.c: 98: ir_state = STATE_START_PULSE;
      00822E 35 01 00 01      [ 1]  215 	mov	_ir_state+0, #0x01
                                    216 ;	src/nec.c: 99: EXTI->CR1 &= ~(3 << 6);       // Clear bits
      008232 C6 50 A0         [ 1]  217 	ld	a, 0x50a0
      008235 A4 3F            [ 1]  218 	and	a, #0x3f
      008237 C7 50 A0         [ 1]  219 	ld	0x50a0, a
                                    220 ;	src/nec.c: 100: EXTI->CR1 |= (3 << 6);        // Reconfigure to trigger on both edges
      00823A C6 50 A0         [ 1]  221 	ld	a, 0x50a0
      00823D AA C0            [ 1]  222 	or	a, #0xc0
      00823F C7 50 A0         [ 1]  223 	ld	0x50a0, a
                                    224 ;	src/nec.c: 101: break;
      008242 CC 83 31         [ 2]  225 	jp	00129$
                                    226 ;	src/nec.c: 103: case STATE_START_PULSE:
      008245                        227 00102$:
                                    228 ;	src/nec.c: 104: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
      008245 90 A3 1D 4C      [ 2]  229 	cpw	y, #0x1d4c
      008249 23 0D            [ 2]  230 	jrule	00104$
      00824B 90 A3 29 04      [ 2]  231 	cpw	y, #0x2904
      00824F 24 07            [ 1]  232 	jrnc	00104$
                                    233 ;	src/nec.c: 105: ir_state = STATE_START_SPACE;
      008251 35 02 00 01      [ 1]  234 	mov	_ir_state+0, #0x02
      008255 CC 83 31         [ 2]  235 	jp	00129$
      008258                        236 00104$:
                                    237 ;	src/nec.c: 107: ir_state = STATE_IDLE;
      008258 72 5F 00 01      [ 1]  238 	clr	_ir_state+0
                                    239 ;	src/nec.c: 108: printf("E1 "); // Error: Bad start pulse timing
      00825C 4B DC            [ 1]  240 	push	#<(___str_0+0)
      00825E 4B 80            [ 1]  241 	push	#((___str_0+0) >> 8)
      008260 CD 83 C6         [ 4]  242 	call	_printf
      008263 5B 02            [ 2]  243 	addw	sp, #2
                                    244 ;	src/nec.c: 110: break;
      008265 CC 83 31         [ 2]  245 	jp	00129$
                                    246 ;	src/nec.c: 112: case STATE_START_SPACE:
      008268                        247 00107$:
                                    248 ;	src/nec.c: 113: if (pulse_width > NEC_START_SPACE_MIN && pulse_width < NEC_START_SPACE_MAX) {
      008268 90 A3 0D AC      [ 2]  249 	cpw	y, #0x0dac
      00826C 23 18            [ 2]  250 	jrule	00109$
      00826E 90 A3 15 7C      [ 2]  251 	cpw	y, #0x157c
      008272 24 12            [ 1]  252 	jrnc	00109$
                                    253 ;	src/nec.c: 114: ir_state = STATE_BIT_PULSE;
      008274 35 03 00 01      [ 1]  254 	mov	_ir_state+0, #0x03
                                    255 ;	src/nec.c: 115: ir_bit_count = 0;
      008278 72 5F 00 06      [ 1]  256 	clr	_ir_bit_count+0
                                    257 ;	src/nec.c: 116: ir_data = 0;
      00827C 5F               [ 1]  258 	clrw	x
      00827D CF 00 04         [ 2]  259 	ldw	_ir_data+2, x
      008280 CF 00 02         [ 2]  260 	ldw	_ir_data+0, x
      008283 CC 83 31         [ 2]  261 	jp	00129$
      008286                        262 00109$:
                                    263 ;	src/nec.c: 118: ir_state = STATE_IDLE;
      008286 72 5F 00 01      [ 1]  264 	clr	_ir_state+0
                                    265 ;	src/nec.c: 119: printf("E2 "); // Error: Bad start space timing
      00828A 4B E0            [ 1]  266 	push	#<(___str_1+0)
      00828C 4B 80            [ 1]  267 	push	#((___str_1+0) >> 8)
      00828E CD 83 C6         [ 4]  268 	call	_printf
      008291 5B 02            [ 2]  269 	addw	sp, #2
                                    270 ;	src/nec.c: 121: break;
      008293 CC 83 31         [ 2]  271 	jp	00129$
                                    272 ;	src/nec.c: 123: case STATE_BIT_PULSE:
      008296                        273 00112$:
                                    274 ;	src/nec.c: 124: if (pulse_width > NEC_BIT_PULSE_MIN && pulse_width < NEC_BIT_PULSE_MAX) {
      008296 90 A3 01 5E      [ 2]  275 	cpw	y, #0x015e
      00829A 23 0D            [ 2]  276 	jrule	00114$
      00829C 90 A3 03 20      [ 2]  277 	cpw	y, #0x0320
      0082A0 24 07            [ 1]  278 	jrnc	00114$
                                    279 ;	src/nec.c: 125: ir_state = STATE_BIT_SPACE;
      0082A2 35 04 00 01      [ 1]  280 	mov	_ir_state+0, #0x04
      0082A6 CC 83 31         [ 2]  281 	jp	00129$
      0082A9                        282 00114$:
                                    283 ;	src/nec.c: 127: ir_state = STATE_IDLE;
      0082A9 72 5F 00 01      [ 1]  284 	clr	_ir_state+0
                                    285 ;	src/nec.c: 128: printf("E3 "); // Error: Bad bit pulse timing
      0082AD 4B E4            [ 1]  286 	push	#<(___str_2+0)
      0082AF 4B 80            [ 1]  287 	push	#((___str_2+0) >> 8)
      0082B1 CD 83 C6         [ 4]  288 	call	_printf
      0082B4 5B 02            [ 2]  289 	addw	sp, #2
                                    290 ;	src/nec.c: 130: break;
      0082B6 20 79            [ 2]  291 	jra	00129$
                                    292 ;	src/nec.c: 132: case STATE_BIT_SPACE:
      0082B8                        293 00117$:
                                    294 ;	src/nec.c: 133: ir_data <<= 1; // Shift left to make room for the new bit (LSB first)
      0082B8 72 58 00 05      [ 1]  295 	sll	_ir_data+3
      0082BC 72 59 00 04      [ 1]  296 	rlc	_ir_data+2
      0082C0 72 59 00 03      [ 1]  297 	rlc	_ir_data+1
      0082C4 72 59 00 02      [ 1]  298 	rlc	_ir_data+0
                                    299 ;	src/nec.c: 134: if (pulse_width > NEC_LOGIC_1_SPACE_MIN && pulse_width < NEC_LOGIC_1_SPACE_MAX) {
      0082C8 1E 03            [ 2]  300 	ldw	x, (0x03, sp)
      0082CA A3 05 78         [ 2]  301 	cpw	x, #0x0578
      0082CD 23 1C            [ 2]  302 	jrule	00122$
      0082CF A3 07 6C         [ 2]  303 	cpw	x, #0x076c
      0082D2 24 17            [ 1]  304 	jrnc	00122$
                                    305 ;	src/nec.c: 135: ir_data |= 1; // It's a '1'
      0082D4 C6 00 05         [ 1]  306 	ld	a, _ir_data+3
      0082D7 AA 01            [ 1]  307 	or	a, #0x01
      0082D9 97               [ 1]  308 	ld	xl, a
      0082DA C6 00 04         [ 1]  309 	ld	a, _ir_data+2
      0082DD 95               [ 1]  310 	ld	xh, a
      0082DE 90 CE 00 02      [ 2]  311 	ldw	y, _ir_data+0
      0082E2 CF 00 04         [ 2]  312 	ldw	_ir_data+2, x
      0082E5 90 CF 00 02      [ 2]  313 	ldw	_ir_data+0, y
      0082E9 20 19            [ 2]  314 	jra	00123$
      0082EB                        315 00122$:
                                    316 ;	src/nec.c: 136: } else if (!(pulse_width > NEC_LOGIC_0_SPACE_MIN && pulse_width < NEC_LOGIC_0_SPACE_MAX)) {
      0082EB A3 01 5E         [ 2]  317 	cpw	x, #0x015e
      0082EE 23 05            [ 2]  318 	jrule	00118$
      0082F0 A3 03 20         [ 2]  319 	cpw	x, #0x0320
      0082F3 25 0F            [ 1]  320 	jrc	00123$
      0082F5                        321 00118$:
                                    322 ;	src/nec.c: 137: ir_state = STATE_IDLE; // Pulse width error
      0082F5 72 5F 00 01      [ 1]  323 	clr	_ir_state+0
                                    324 ;	src/nec.c: 138: printf("E4 "); // Error: Bad bit space timing
      0082F9 4B E8            [ 1]  325 	push	#<(___str_3+0)
      0082FB 4B 80            [ 1]  326 	push	#((___str_3+0) >> 8)
      0082FD CD 83 C6         [ 4]  327 	call	_printf
      008300 5B 02            [ 2]  328 	addw	sp, #2
                                    329 ;	src/nec.c: 139: break;
      008302 20 2D            [ 2]  330 	jra	00129$
      008304                        331 00123$:
                                    332 ;	src/nec.c: 141: ir_bit_count++;
      008304 72 5C 00 06      [ 1]  333 	inc	_ir_bit_count+0
                                    334 ;	src/nec.c: 142: if (ir_bit_count == 32) {
      008308 C6 00 06         [ 1]  335 	ld	a, _ir_bit_count+0
      00830B A1 20            [ 1]  336 	cp	a, #0x20
      00830D 26 1E            [ 1]  337 	jrne	00126$
                                    338 ;	src/nec.c: 143: ir_data_ready_flag = 1; // Set flag for main loop
      00830F 35 01 00 07      [ 1]  339 	mov	_ir_data_ready_flag+0, #0x01
                                    340 ;	src/nec.c: 144: ir_state = STATE_IDLE;
      008313 72 5F 00 01      [ 1]  341 	clr	_ir_state+0
                                    342 ;	src/nec.c: 145: TIM2->CR1 &= ~(1 << 0); // Stop timer
      008317 C6 53 00         [ 1]  343 	ld	a, 0x5300
      00831A A4 FE            [ 1]  344 	and	a, #0xfe
      00831C C7 53 00         [ 1]  345 	ld	0x5300, a
                                    346 ;	src/nec.c: 146: EXTI->CR1 &= ~(3 << 6);   // Clear bits
      00831F C6 50 A0         [ 1]  347 	ld	a, 0x50a0
      008322 A4 3F            [ 1]  348 	and	a, #0x3f
      008324 C7 50 A0         [ 1]  349 	ld	0x50a0, a
                                    350 ;	src/nec.c: 147: EXTI->CR1 |= (2 << 6);    // Reset EXTI to falling edge only
      008327 72 1E 50 A0      [ 1]  351 	bset	0x50a0, #7
      00832B 20 04            [ 2]  352 	jra	00129$
      00832D                        353 00126$:
                                    354 ;	src/nec.c: 149: ir_state = STATE_BIT_PULSE;
      00832D 35 03 00 01      [ 1]  355 	mov	_ir_state+0, #0x03
                                    356 ;	src/nec.c: 152: }
      008331                        357 00129$:
                                    358 ;	src/nec.c: 153: }
      008331 5B 04            [ 2]  359 	addw	sp, #4
      008333 80               [11]  360 	iret
                                    361 ;	src/nec.c: 155: void TIM2_Update_IRQHandler(void) __interrupt(13) {
                                    362 ;	-----------------------------------------
                                    363 ;	 function TIM2_Update_IRQHandler
                                    364 ;	-----------------------------------------
      008334                        365 _TIM2_Update_IRQHandler:
      008334 4F               [ 1]  366 	clr	a
      008335 62               [ 2]  367 	div	x, a
                                    368 ;	src/nec.c: 156: if (TIM2->SR1 & (1 << 0)) { // Check for update interrupt flag
      008336 C6 53 04         [ 1]  369 	ld	a, 0x5304
      008339 44               [ 1]  370 	srl	a
      00833A 24 2A            [ 1]  371 	jrnc	00105$
                                    372 ;	src/nec.c: 157: if(ir_state != STATE_IDLE) {
      00833C C6 00 01         [ 1]  373 	ld	a, _ir_state+0
      00833F 27 0D            [ 1]  374 	jreq	00102$
                                    375 ;	src/nec.c: 159: ir_state = STATE_IDLE;
      008341 72 5F 00 01      [ 1]  376 	clr	_ir_state+0
                                    377 ;	src/nec.c: 160: printf("T "); // Timed out
      008345 4B EC            [ 1]  378 	push	#<(___str_4+0)
      008347 4B 80            [ 1]  379 	push	#((___str_4+0) >> 8)
      008349 CD 83 C6         [ 4]  380 	call	_printf
      00834C 5B 02            [ 2]  381 	addw	sp, #2
      00834E                        382 00102$:
                                    383 ;	src/nec.c: 162: TIM2->CR1 &= ~(1 << 0); // Stop timer
      00834E C6 53 00         [ 1]  384 	ld	a, 0x5300
      008351 A4 FE            [ 1]  385 	and	a, #0xfe
      008353 C7 53 00         [ 1]  386 	ld	0x5300, a
                                    387 ;	src/nec.c: 163: EXTI->CR1 &= ~(3 << 6);   // Clear bits
      008356 C6 50 A0         [ 1]  388 	ld	a, 0x50a0
      008359 A4 3F            [ 1]  389 	and	a, #0x3f
      00835B C7 50 A0         [ 1]  390 	ld	0x50a0, a
                                    391 ;	src/nec.c: 164: EXTI->CR1 |= (2 << 6);    // Reset EXTI to falling edge only
      00835E 72 1E 50 A0      [ 1]  392 	bset	0x50a0, #7
                                    393 ;	src/nec.c: 165: TIM2->SR1 &= ~(1 << 0); // Clear the interrupt flag
      008362 72 11 53 04      [ 1]  394 	bres	0x5304, #0
      008366                        395 00105$:
                                    396 ;	src/nec.c: 167: }
      008366 80               [11]  397 	iret
                                    398 	.area CODE
                                    399 	.area CONST
                                    400 	.area CONST
      0080DC                        401 ___str_0:
      0080DC 45 31 20               402 	.ascii "E1 "
      0080DF 00                     403 	.db 0x00
                                    404 	.area CODE
                                    405 	.area CONST
      0080E0                        406 ___str_1:
      0080E0 45 32 20               407 	.ascii "E2 "
      0080E3 00                     408 	.db 0x00
                                    409 	.area CODE
                                    410 	.area CONST
      0080E4                        411 ___str_2:
      0080E4 45 33 20               412 	.ascii "E3 "
      0080E7 00                     413 	.db 0x00
                                    414 	.area CODE
                                    415 	.area CONST
      0080E8                        416 ___str_3:
      0080E8 45 34 20               417 	.ascii "E4 "
      0080EB 00                     418 	.db 0x00
                                    419 	.area CODE
                                    420 	.area CONST
      0080EC                        421 ___str_4:
      0080EC 54 20                  422 	.ascii "T "
      0080EE 00                     423 	.db 0x00
                                    424 	.area CODE
                                    425 	.area INITIALIZER
      0080FA                        426 __xinit__ir_state:
      0080FA 00                     427 	.db #0x00	; 0
      0080FB                        428 __xinit__ir_data:
      0080FB 00 00 00 00            429 	.byte #0x00, #0x00, #0x00, #0x00	; 0
      0080FF                        430 __xinit__ir_bit_count:
      0080FF 00                     431 	.db #0x00	; 0
      008100                        432 __xinit__ir_data_ready_flag:
      008100 00                     433 	.db #0x00	; 0
                                    434 	.area CABS (ABS)
