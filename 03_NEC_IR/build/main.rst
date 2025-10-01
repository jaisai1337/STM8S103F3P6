                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.2.0 #13081 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module main
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _main
                                     12 	.globl _TIM2_Update_IRQHandler
                                     13 	.globl _EXTI_PORTD_IRQHandler
                                     14 	.globl _IR_GPIO_Init
                                     15 	.globl _TIM2_Init
                                     16 	.globl _USART1_Init
                                     17 	.globl _puts
                                     18 	.globl _printf
                                     19 	.globl _ir_data_ready
                                     20 	.globl _ir_bit_count
                                     21 	.globl _ir_data
                                     22 	.globl _ir_state
                                     23 	.globl _putchar
                                     24 ;--------------------------------------------------------
                                     25 ; ram data
                                     26 ;--------------------------------------------------------
                                     27 	.area DATA
                                     28 ;--------------------------------------------------------
                                     29 ; ram data
                                     30 ;--------------------------------------------------------
                                     31 	.area INITIALIZED
      000001                         32 _ir_state::
      000001                         33 	.ds 1
      000002                         34 _ir_data::
      000002                         35 	.ds 4
      000006                         36 _ir_bit_count::
      000006                         37 	.ds 1
      000007                         38 _ir_data_ready::
      000007                         39 	.ds 1
                                     40 ;--------------------------------------------------------
                                     41 ; Stack segment in internal ram
                                     42 ;--------------------------------------------------------
                                     43 	.area	SSEG
      000008                         44 __start__stack:
      000008                         45 	.ds	1
                                     46 
                                     47 ;--------------------------------------------------------
                                     48 ; absolute external ram data
                                     49 ;--------------------------------------------------------
                                     50 	.area DABS (ABS)
                                     51 
                                     52 ; default segment ordering for linker
                                     53 	.area HOME
                                     54 	.area GSINIT
                                     55 	.area GSFINAL
                                     56 	.area CONST
                                     57 	.area INITIALIZER
                                     58 	.area CODE
                                     59 
                                     60 ;--------------------------------------------------------
                                     61 ; interrupt vector
                                     62 ;--------------------------------------------------------
                                     63 	.area HOME
      008000                         64 __interrupt_vect:
      008000 82 00 80 43             65 	int s_GSINIT ; reset
      008004 82 00 00 00             66 	int 0x000000 ; trap
      008008 82 00 00 00             67 	int 0x000000 ; int0
      00800C 82 00 00 00             68 	int 0x000000 ; int1
      008010 82 00 00 00             69 	int 0x000000 ; int2
      008014 82 00 00 00             70 	int 0x000000 ; int3
      008018 82 00 00 00             71 	int 0x000000 ; int4
      00801C 82 00 00 00             72 	int 0x000000 ; int5
      008020 82 00 81 1B             73 	int _EXTI_PORTD_IRQHandler ; int6
      008024 82 00 00 00             74 	int 0x000000 ; int7
      008028 82 00 00 00             75 	int 0x000000 ; int8
      00802C 82 00 00 00             76 	int 0x000000 ; int9
      008030 82 00 00 00             77 	int 0x000000 ; int10
      008034 82 00 00 00             78 	int 0x000000 ; int11
      008038 82 00 00 00             79 	int 0x000000 ; int12
      00803C 82 00 82 21             80 	int _TIM2_Update_IRQHandler ; int13
                                     81 ;--------------------------------------------------------
                                     82 ; global & static initialisations
                                     83 ;--------------------------------------------------------
                                     84 	.area HOME
                                     85 	.area GSINIT
                                     86 	.area GSFINAL
                                     87 	.area GSINIT
      008043                         88 __sdcc_init_data:
                                     89 ; stm8_genXINIT() start
      008043 AE 00 00         [ 2]   90 	ldw x, #l_DATA
      008046 27 07            [ 1]   91 	jreq	00002$
      008048                         92 00001$:
      008048 72 4F 00 00      [ 1]   93 	clr (s_DATA - 1, x)
      00804C 5A               [ 2]   94 	decw x
      00804D 26 F9            [ 1]   95 	jrne	00001$
      00804F                         96 00002$:
      00804F AE 00 07         [ 2]   97 	ldw	x, #l_INITIALIZER
      008052 27 09            [ 1]   98 	jreq	00004$
      008054                         99 00003$:
      008054 D6 80 CA         [ 1]  100 	ld	a, (s_INITIALIZER - 1, x)
      008057 D7 00 00         [ 1]  101 	ld	(s_INITIALIZED - 1, x), a
      00805A 5A               [ 2]  102 	decw	x
      00805B 26 F7            [ 1]  103 	jrne	00003$
      00805D                        104 00004$:
                                    105 ; stm8_genXINIT() end
                                    106 	.area GSFINAL
      00805D CC 80 40         [ 2]  107 	jp	__sdcc_program_startup
                                    108 ;--------------------------------------------------------
                                    109 ; Home
                                    110 ;--------------------------------------------------------
                                    111 	.area HOME
                                    112 	.area HOME
      008040                        113 __sdcc_program_startup:
      008040 CC 82 38         [ 2]  114 	jp	_main
                                    115 ;	return from main will return to caller
                                    116 ;--------------------------------------------------------
                                    117 ; code
                                    118 ;--------------------------------------------------------
                                    119 	.area CODE
                                    120 ;	src/main.c: 38: void USART1_Init(void) {
                                    121 ;	-----------------------------------------
                                    122 ;	 function USART1_Init
                                    123 ;	-----------------------------------------
      0080D2                        124 _USART1_Init:
                                    125 ;	src/main.c: 39: GPIOD->DDR |= (1 << 5);  // Set PD5 as output
      0080D2 72 1A 50 11      [ 1]  126 	bset	0x5011, #5
                                    127 ;	src/main.c: 40: GPIOD->CR1 |= (1 << 5);  // Push-pull
      0080D6 72 1A 50 12      [ 1]  128 	bset	0x5012, #5
                                    129 ;	src/main.c: 43: USART1->BRR2 = 0x03;
      0080DA 35 03 52 33      [ 1]  130 	mov	0x5233+0, #0x03
                                    131 ;	src/main.c: 44: USART1->BRR1 = 0x68;
      0080DE 35 68 52 32      [ 1]  132 	mov	0x5232+0, #0x68
                                    133 ;	src/main.c: 46: USART1->CR2 |= (1 << 3);  // TEN: Enable TX
      0080E2 72 16 52 35      [ 1]  134 	bset	0x5235, #3
                                    135 ;	src/main.c: 47: }
      0080E6 81               [ 4]  136 	ret
                                    137 ;	src/main.c: 50: int putchar(int c) {
                                    138 ;	-----------------------------------------
                                    139 ;	 function putchar
                                    140 ;	-----------------------------------------
      0080E7                        141 _putchar:
                                    142 ;	src/main.c: 51: if (c == '\n') putchar('\r');
      0080E7 A3 00 0A         [ 2]  143 	cpw	x, #0x000a
      0080EA 26 07            [ 1]  144 	jrne	00103$
      0080EC 89               [ 2]  145 	pushw	x
      0080ED AE 00 0D         [ 2]  146 	ldw	x, #0x000d
      0080F0 AD F5            [ 4]  147 	callr	_putchar
      0080F2 85               [ 2]  148 	popw	x
                                    149 ;	src/main.c: 52: while (!(USART1->SR & (1 << 7))); // Wait for TXE
      0080F3                        150 00103$:
      0080F3 C6 52 30         [ 1]  151 	ld	a, 0x5230
      0080F6 2A FB            [ 1]  152 	jrpl	00103$
                                    153 ;	src/main.c: 53: USART1->DR = c;
      0080F8 9F               [ 1]  154 	ld	a, xl
      0080F9 C7 52 31         [ 1]  155 	ld	0x5231, a
                                    156 ;	src/main.c: 54: return c;
                                    157 ;	src/main.c: 55: }
      0080FC 81               [ 4]  158 	ret
                                    159 ;	src/main.c: 58: void TIM2_Init(void) {
                                    160 ;	-----------------------------------------
                                    161 ;	 function TIM2_Init
                                    162 ;	-----------------------------------------
      0080FD                        163 _TIM2_Init:
                                    164 ;	src/main.c: 60: CLK->PCKENR1 |= (1 << 5);
      0080FD 72 1A 50 C7      [ 1]  165 	bset	0x50c7, #5
                                    166 ;	src/main.c: 63: TIM2->PSCR = 0x04; // 2^4 = 16
      008101 35 04 53 0E      [ 1]  167 	mov	0x530e+0, #0x04
                                    168 ;	src/main.c: 66: TIM2->IER |= (1 << 0);
      008105 72 10 53 03      [ 1]  169 	bset	0x5303, #0
                                    170 ;	src/main.c: 67: }
      008109 81               [ 4]  171 	ret
                                    172 ;	src/main.c: 70: void IR_GPIO_Init(void) {
                                    173 ;	-----------------------------------------
                                    174 ;	 function IR_GPIO_Init
                                    175 ;	-----------------------------------------
      00810A                        176 _IR_GPIO_Init:
                                    177 ;	src/main.c: 72: GPIOD->DDR &= ~IR_PIN_MASK; // Input
      00810A 72 17 50 11      [ 1]  178 	bres	0x5011, #3
                                    179 ;	src/main.c: 73: GPIOD->CR1 |= IR_PIN_MASK;  // Pull-up enabled
      00810E 72 16 50 12      [ 1]  180 	bset	0x5012, #3
                                    181 ;	src/main.c: 74: GPIOD->CR2 |= IR_PIN_MASK;  // Interrupt enabled
      008112 72 16 50 13      [ 1]  182 	bset	0x5013, #3
                                    183 ;	src/main.c: 77: EXTI->CR1 = (2 << 6); // 10 = Falling edge only for Port D
      008116 35 80 50 A0      [ 1]  184 	mov	0x50a0+0, #0x80
                                    185 ;	src/main.c: 78: }
      00811A 81               [ 4]  186 	ret
                                    187 ;	src/main.c: 81: void EXTI_PORTD_IRQHandler(void) __interrupt(6) {
                                    188 ;	-----------------------------------------
                                    189 ;	 function EXTI_PORTD_IRQHandler
                                    190 ;	-----------------------------------------
      00811B                        191 _EXTI_PORTD_IRQHandler:
      00811B 52 04            [ 2]  192 	sub	sp, #4
                                    193 ;	src/main.c: 84: uint16_t pulse_width = (TIM2->CNTRH << 8) | TIM2->CNTRL;
      00811D C6 53 0C         [ 1]  194 	ld	a, 0x530c
      008120 95               [ 1]  195 	ld	xh, a
      008121 0F 02            [ 1]  196 	clr	(0x02, sp)
      008123 C6 53 0D         [ 1]  197 	ld	a, 0x530d
      008126 0F 03            [ 1]  198 	clr	(0x03, sp)
      008128 1A 02            [ 1]  199 	or	a, (0x02, sp)
      00812A 02               [ 1]  200 	rlwa	x
      00812B 1A 03            [ 1]  201 	or	a, (0x03, sp)
      00812D 95               [ 1]  202 	ld	xh, a
      00812E 1F 03            [ 2]  203 	ldw	(0x03, sp), x
                                    204 ;	src/main.c: 85: TIM2->CNTRH = 0;
      008130 35 00 53 0C      [ 1]  205 	mov	0x530c+0, #0x00
                                    206 ;	src/main.c: 86: TIM2->CNTRL = 0;
      008134 35 00 53 0D      [ 1]  207 	mov	0x530d+0, #0x00
                                    208 ;	src/main.c: 88: switch (ir_state) {
      008138 C6 00 01         [ 1]  209 	ld	a, _ir_state+0
      00813B A1 04            [ 1]  210 	cp	a, #0x04
      00813D 23 03            [ 2]  211 	jrule	00187$
      00813F CC 82 1E         [ 2]  212 	jp	00130$
      008142                        213 00187$:
                                    214 ;	src/main.c: 99: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
      008142 16 03            [ 2]  215 	ldw	y, (0x03, sp)
                                    216 ;	src/main.c: 88: switch (ir_state) {
      008144 5F               [ 1]  217 	clrw	x
      008145 97               [ 1]  218 	ld	xl, a
      008146 58               [ 2]  219 	sllw	x
      008147 DE 81 4B         [ 2]  220 	ldw	x, (#00188$, x)
      00814A FC               [ 2]  221 	jp	(x)
      00814B                        222 00188$:
      00814B 81 55                  223 	.dw	#00101$
      00814D 81 64                  224 	.dw	#00102$
      00814F 81 7E                  225 	.dw	#00107$
      008151 81 A2                  226 	.dw	#00112$
      008153 81 BA                  227 	.dw	#00117$
                                    228 ;	src/main.c: 89: case STATE_IDLE:
      008155                        229 00101$:
                                    230 ;	src/main.c: 91: TIM2->CR1 |= (1 << 0); // Start timer
      008155 72 10 53 00      [ 1]  231 	bset	0x5300, #0
                                    232 ;	src/main.c: 92: ir_state = STATE_START_PULSE;
      008159 35 01 00 01      [ 1]  233 	mov	_ir_state+0, #0x01
                                    234 ;	src/main.c: 94: EXTI->CR1 = (3 << 6); // 11 = Rising and falling for Port D
      00815D 35 C0 50 A0      [ 1]  235 	mov	0x50a0+0, #0xc0
                                    236 ;	src/main.c: 95: break;
      008161 CC 82 1E         [ 2]  237 	jp	00130$
                                    238 ;	src/main.c: 97: case STATE_START_PULSE:
      008164                        239 00102$:
                                    240 ;	src/main.c: 99: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
      008164 90 A3 1F 40      [ 2]  241 	cpw	y, #0x1f40
      008168 23 0D            [ 2]  242 	jrule	00104$
      00816A 90 A3 27 10      [ 2]  243 	cpw	y, #0x2710
      00816E 24 07            [ 1]  244 	jrnc	00104$
                                    245 ;	src/main.c: 100: ir_state = STATE_START_SPACE;
      008170 35 02 00 01      [ 1]  246 	mov	_ir_state+0, #0x02
      008174 CC 82 1E         [ 2]  247 	jp	00130$
      008177                        248 00104$:
                                    249 ;	src/main.c: 102: ir_state = STATE_IDLE; // Error, reset
      008177 72 5F 00 01      [ 1]  250 	clr	_ir_state+0
                                    251 ;	src/main.c: 104: break;
      00817B CC 82 1E         [ 2]  252 	jp	00130$
                                    253 ;	src/main.c: 106: case STATE_START_SPACE:
      00817E                        254 00107$:
                                    255 ;	src/main.c: 108: if (pulse_width > NEC_START_SPACE_MIN && pulse_width < NEC_START_SPACE_MAX) {
      00817E 90 A3 0F A0      [ 2]  256 	cpw	y, #0x0fa0
      008182 23 18            [ 2]  257 	jrule	00109$
      008184 90 A3 13 88      [ 2]  258 	cpw	y, #0x1388
      008188 24 12            [ 1]  259 	jrnc	00109$
                                    260 ;	src/main.c: 109: ir_state = STATE_BIT_PULSE;
      00818A 35 03 00 01      [ 1]  261 	mov	_ir_state+0, #0x03
                                    262 ;	src/main.c: 110: ir_bit_count = 0;
      00818E 72 5F 00 06      [ 1]  263 	clr	_ir_bit_count+0
                                    264 ;	src/main.c: 111: ir_data = 0;
      008192 5F               [ 1]  265 	clrw	x
      008193 CF 00 04         [ 2]  266 	ldw	_ir_data+2, x
      008196 CF 00 02         [ 2]  267 	ldw	_ir_data+0, x
      008199 CC 82 1E         [ 2]  268 	jp	00130$
      00819C                        269 00109$:
                                    270 ;	src/main.c: 113: ir_state = STATE_IDLE; // Error, reset
      00819C 72 5F 00 01      [ 1]  271 	clr	_ir_state+0
                                    272 ;	src/main.c: 115: break;
      0081A0 20 7C            [ 2]  273 	jra	00130$
                                    274 ;	src/main.c: 117: case STATE_BIT_PULSE:
      0081A2                        275 00112$:
                                    276 ;	src/main.c: 119: if (pulse_width > NEC_BIT_PULSE_MIN && pulse_width < NEC_BIT_PULSE_MAX) {
      0081A2 90 A3 01 90      [ 2]  277 	cpw	y, #0x0190
      0081A6 23 0C            [ 2]  278 	jrule	00114$
      0081A8 90 A3 02 BC      [ 2]  279 	cpw	y, #0x02bc
      0081AC 24 06            [ 1]  280 	jrnc	00114$
                                    281 ;	src/main.c: 120: ir_state = STATE_BIT_SPACE;
      0081AE 35 04 00 01      [ 1]  282 	mov	_ir_state+0, #0x04
      0081B2 20 6A            [ 2]  283 	jra	00130$
      0081B4                        284 00114$:
                                    285 ;	src/main.c: 122: ir_state = STATE_IDLE; // Error, reset
      0081B4 72 5F 00 01      [ 1]  286 	clr	_ir_state+0
                                    287 ;	src/main.c: 124: break;
      0081B8 20 64            [ 2]  288 	jra	00130$
                                    289 ;	src/main.c: 126: case STATE_BIT_SPACE:
      0081BA                        290 00117$:
                                    291 ;	src/main.c: 128: ir_data >>= 1; // Shift right to make space for the new bit (MSB first)
      0081BA 72 54 00 02      [ 1]  292 	srl	_ir_data+0
      0081BE 72 56 00 03      [ 1]  293 	rrc	_ir_data+1
      0081C2 72 56 00 04      [ 1]  294 	rrc	_ir_data+2
      0081C6 72 56 00 05      [ 1]  295 	rrc	_ir_data+3
                                    296 ;	src/main.c: 130: if (pulse_width > NEC_LOGIC_1_SPACE_MIN && pulse_width < NEC_LOGIC_1_SPACE_MAX) {
      0081CA 1E 03            [ 2]  297 	ldw	x, (0x03, sp)
      0081CC A3 05 DC         [ 2]  298 	cpw	x, #0x05dc
      0081CF 23 1C            [ 2]  299 	jrule	00123$
      0081D1 A3 07 08         [ 2]  300 	cpw	x, #0x0708
      0081D4 24 17            [ 1]  301 	jrnc	00123$
                                    302 ;	src/main.c: 131: ir_data |= 0x80000000; // It's a '1'
      0081D6 90 CE 00 04      [ 2]  303 	ldw	y, _ir_data+2
      0081DA C6 00 03         [ 1]  304 	ld	a, _ir_data+1
      0081DD 97               [ 1]  305 	ld	xl, a
      0081DE C6 00 02         [ 1]  306 	ld	a, _ir_data+0
      0081E1 AA 80            [ 1]  307 	or	a, #0x80
      0081E3 95               [ 1]  308 	ld	xh, a
      0081E4 90 CF 00 04      [ 2]  309 	ldw	_ir_data+2, y
      0081E8 CF 00 02         [ 2]  310 	ldw	_ir_data+0, x
      0081EB 20 10            [ 2]  311 	jra	00124$
      0081ED                        312 00123$:
                                    313 ;	src/main.c: 132: } else if (pulse_width > NEC_LOGIC_0_SPACE_MIN && pulse_width < NEC_LOGIC_0_SPACE_MAX) {
      0081ED A3 01 90         [ 2]  314 	cpw	x, #0x0190
      0081F0 23 05            [ 2]  315 	jrule	00119$
      0081F2 A3 02 BC         [ 2]  316 	cpw	x, #0x02bc
      0081F5 25 06            [ 1]  317 	jrc	00124$
      0081F7                        318 00119$:
                                    319 ;	src/main.c: 135: ir_state = STATE_IDLE; // Pulse width error
      0081F7 72 5F 00 01      [ 1]  320 	clr	_ir_state+0
                                    321 ;	src/main.c: 136: break;
      0081FB 20 21            [ 2]  322 	jra	00130$
      0081FD                        323 00124$:
                                    324 ;	src/main.c: 139: ir_bit_count++;
      0081FD 72 5C 00 06      [ 1]  325 	inc	_ir_bit_count+0
                                    326 ;	src/main.c: 140: if (ir_bit_count == 32) {
      008201 C6 00 06         [ 1]  327 	ld	a, _ir_bit_count+0
      008204 A1 20            [ 1]  328 	cp	a, #0x20
      008206 26 12            [ 1]  329 	jrne	00127$
                                    330 ;	src/main.c: 142: ir_data_ready = 1;
      008208 35 01 00 07      [ 1]  331 	mov	_ir_data_ready+0, #0x01
                                    332 ;	src/main.c: 143: ir_state = STATE_IDLE;
      00820C 72 5F 00 01      [ 1]  333 	clr	_ir_state+0
                                    334 ;	src/main.c: 144: TIM2->CR1 &= ~(1 << 0); // Stop timer
      008210 72 11 53 00      [ 1]  335 	bres	0x5300, #0
                                    336 ;	src/main.c: 145: EXTI->CR1 = (2 << 6);  // Reset EXTI back to falling edge only
      008214 35 80 50 A0      [ 1]  337 	mov	0x50a0+0, #0x80
      008218 20 04            [ 2]  338 	jra	00130$
      00821A                        339 00127$:
                                    340 ;	src/main.c: 147: ir_state = STATE_BIT_PULSE; // Ready for the next bit pulse
      00821A 35 03 00 01      [ 1]  341 	mov	_ir_state+0, #0x03
                                    342 ;	src/main.c: 150: }
      00821E                        343 00130$:
                                    344 ;	src/main.c: 151: }
      00821E 5B 04            [ 2]  345 	addw	sp, #4
      008220 80               [11]  346 	iret
                                    347 ;	src/main.c: 154: void TIM2_Update_IRQHandler(void) __interrupt(13) {
                                    348 ;	-----------------------------------------
                                    349 ;	 function TIM2_Update_IRQHandler
                                    350 ;	-----------------------------------------
      008221                        351 _TIM2_Update_IRQHandler:
                                    352 ;	src/main.c: 155: if (TIM2->SR1 & (1 << 0)) { // Check if it's an update interrupt
      008221 C6 53 04         [ 1]  353 	ld	a, 0x5304
      008224 44               [ 1]  354 	srl	a
      008225 24 10            [ 1]  355 	jrnc	00103$
                                    356 ;	src/main.c: 157: ir_state = STATE_IDLE;
      008227 72 5F 00 01      [ 1]  357 	clr	_ir_state+0
                                    358 ;	src/main.c: 158: TIM2->CR1 &= ~(1 << 0); // Stop timer
      00822B 72 11 53 00      [ 1]  359 	bres	0x5300, #0
                                    360 ;	src/main.c: 159: EXTI->CR1 = (2 << 6);  // Reset EXTI back to falling edge only
      00822F 35 80 50 A0      [ 1]  361 	mov	0x50a0+0, #0x80
                                    362 ;	src/main.c: 160: TIM2->SR1 &= ~(1 << 0); // Clear the interrupt flag
      008233 72 11 53 04      [ 1]  363 	bres	0x5304, #0
      008237                        364 00103$:
                                    365 ;	src/main.c: 162: }
      008237 80               [11]  366 	iret
                                    367 ;	src/main.c: 165: void main(void) {
                                    368 ;	-----------------------------------------
                                    369 ;	 function main
                                    370 ;	-----------------------------------------
      008238                        371 _main:
      008238 52 0B            [ 2]  372 	sub	sp, #11
                                    373 ;	src/main.c: 167: CLK->CKDIVR = 0x00;
      00823A 35 00 50 C6      [ 1]  374 	mov	0x50c6+0, #0x00
                                    375 ;	src/main.c: 170: USART1_Init();
      00823E CD 80 D2         [ 4]  376 	call	_USART1_Init
                                    377 ;	src/main.c: 171: IR_GPIO_Init();
      008241 CD 81 0A         [ 4]  378 	call	_IR_GPIO_Init
                                    379 ;	src/main.c: 172: TIM2_Init();
      008244 CD 80 FD         [ 4]  380 	call	_TIM2_Init
                                    381 ;	src/main.c: 175: __asm__("rim");
      008247 9A               [ 1]  382 	rim
                                    383 ;	src/main.c: 177: printf("\n\nSTM8S IR Receiver Ready\n");
      008248 AE 80 60         [ 2]  384 	ldw	x, #(___str_1+0)
      00824B CD 83 03         [ 4]  385 	call	_puts
                                    386 ;	src/main.c: 179: while (1) {
      00824E                        387 00111$:
                                    388 ;	src/main.c: 180: if (ir_data_ready) {
      00824E C6 00 07         [ 1]  389 	ld	a, _ir_data_ready+0
      008251 27 FB            [ 1]  390 	jreq	00111$
                                    391 ;	src/main.c: 184: uint32_t temp = ir_data;
      008253 CE 00 04         [ 2]  392 	ldw	x, _ir_data+2
      008256 1F 03            [ 2]  393 	ldw	(0x03, sp), x
      008258 CE 00 02         [ 2]  394 	ldw	x, _ir_data+0
      00825B 1F 01            [ 2]  395 	ldw	(0x01, sp), x
                                    396 ;	src/main.c: 185: uint32_t reversed_data = 0;
      00825D 5F               [ 1]  397 	clrw	x
      00825E 1F 0A            [ 2]  398 	ldw	(0x0a, sp), x
      008260 1F 08            [ 2]  399 	ldw	(0x08, sp), x
                                    400 ;	src/main.c: 186: for(int i = 0; i < 32; i++) {
      008262 5F               [ 1]  401 	clrw	x
      008263 1F 06            [ 2]  402 	ldw	(0x06, sp), x
      008265                        403 00114$:
      008265 1E 06            [ 2]  404 	ldw	x, (0x06, sp)
      008267 A3 00 20         [ 2]  405 	cpw	x, #0x0020
      00826A 2E 43            [ 1]  406 	jrsge	00103$
                                    407 ;	src/main.c: 187: if((temp >> i) & 1) {
      00826C 1E 03            [ 2]  408 	ldw	x, (0x03, sp)
      00826E 16 01            [ 2]  409 	ldw	y, (0x01, sp)
      008270 7B 07            [ 1]  410 	ld	a, (0x07, sp)
      008272 27 06            [ 1]  411 	jreq	00157$
      008274                        412 00156$:
      008274 90 54            [ 2]  413 	srlw	y
      008276 56               [ 2]  414 	rrcw	x
      008277 4A               [ 1]  415 	dec	a
      008278 26 FA            [ 1]  416 	jrne	00156$
      00827A                        417 00157$:
      00827A 54               [ 2]  418 	srlw	x
      00827B 24 2B            [ 1]  419 	jrnc	00115$
                                    420 ;	src/main.c: 188: reversed_data |= (1UL << (31-i));
      00827D 7B 07            [ 1]  421 	ld	a, (0x07, sp)
      00827F 6B 05            [ 1]  422 	ld	(0x05, sp), a
      008281 A6 1F            [ 1]  423 	ld	a, #0x1f
      008283 10 05            [ 1]  424 	sub	a, (0x05, sp)
      008285 5F               [ 1]  425 	clrw	x
      008286 5C               [ 1]  426 	incw	x
      008287 90 5F            [ 1]  427 	clrw	y
      008289 4D               [ 1]  428 	tnz	a
      00828A 27 06            [ 1]  429 	jreq	00160$
      00828C                        430 00159$:
      00828C 58               [ 2]  431 	sllw	x
      00828D 90 59            [ 2]  432 	rlcw	y
      00828F 4A               [ 1]  433 	dec	a
      008290 26 FA            [ 1]  434 	jrne	00159$
      008292                        435 00160$:
      008292 9F               [ 1]  436 	ld	a, xl
      008293 1A 0B            [ 1]  437 	or	a, (0x0b, sp)
      008295 6B 0B            [ 1]  438 	ld	(0x0b, sp), a
      008297 9E               [ 1]  439 	ld	a, xh
      008298 1A 0A            [ 1]  440 	or	a, (0x0a, sp)
      00829A 6B 0A            [ 1]  441 	ld	(0x0a, sp), a
      00829C 90 9F            [ 1]  442 	ld	a, yl
      00829E 1A 09            [ 1]  443 	or	a, (0x09, sp)
      0082A0 6B 09            [ 1]  444 	ld	(0x09, sp), a
      0082A2 90 9E            [ 1]  445 	ld	a, yh
      0082A4 1A 08            [ 1]  446 	or	a, (0x08, sp)
      0082A6 6B 08            [ 1]  447 	ld	(0x08, sp), a
      0082A8                        448 00115$:
                                    449 ;	src/main.c: 186: for(int i = 0; i < 32; i++) {
      0082A8 1E 06            [ 2]  450 	ldw	x, (0x06, sp)
      0082AA 5C               [ 1]  451 	incw	x
      0082AB 1F 06            [ 2]  452 	ldw	(0x06, sp), x
      0082AD 20 B6            [ 2]  453 	jra	00114$
      0082AF                        454 00103$:
                                    455 ;	src/main.c: 192: uint8_t address = (reversed_data >> 24) & 0xFF;
      0082AF 7B 08            [ 1]  456 	ld	a, (0x08, sp)
      0082B1 6B 04            [ 1]  457 	ld	(0x04, sp), a
                                    458 ;	src/main.c: 193: uint8_t not_address = (reversed_data >> 16) & 0xFF;
      0082B3 7B 09            [ 1]  459 	ld	a, (0x09, sp)
      0082B5 6B 05            [ 1]  460 	ld	(0x05, sp), a
                                    461 ;	src/main.c: 194: uint8_t command = (reversed_data >> 8) & 0xFF;
      0082B7 7B 0A            [ 1]  462 	ld	a, (0x0a, sp)
      0082B9 6B 06            [ 1]  463 	ld	(0x06, sp), a
                                    464 ;	src/main.c: 195: uint8_t not_command = reversed_data & 0xFF;
      0082BB 7B 0B            [ 1]  465 	ld	a, (0x0b, sp)
      0082BD 6B 07            [ 1]  466 	ld	(0x07, sp), a
                                    467 ;	src/main.c: 198: if ((uint8_t)~address == not_address && (uint8_t)~command == not_command) {
      0082BF 7B 04            [ 1]  468 	ld	a, (0x04, sp)
      0082C1 43               [ 1]  469 	cpl	a
      0082C2 11 05            [ 1]  470 	cp	a, (0x05, sp)
      0082C4 26 27            [ 1]  471 	jrne	00105$
      0082C6 7B 06            [ 1]  472 	ld	a, (0x06, sp)
      0082C8 43               [ 1]  473 	cpl	a
      0082C9 11 07            [ 1]  474 	cp	a, (0x07, sp)
      0082CB 26 20            [ 1]  475 	jrne	00105$
                                    476 ;	src/main.c: 199: printf("OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX\n", address, command, reversed_data);
      0082CD 5F               [ 1]  477 	clrw	x
      0082CE 7B 06            [ 1]  478 	ld	a, (0x06, sp)
      0082D0 97               [ 1]  479 	ld	xl, a
      0082D1 7B 04            [ 1]  480 	ld	a, (0x04, sp)
      0082D3 0F 06            [ 1]  481 	clr	(0x06, sp)
      0082D5 16 0A            [ 2]  482 	ldw	y, (0x0a, sp)
      0082D7 90 89            [ 2]  483 	pushw	y
      0082D9 16 0A            [ 2]  484 	ldw	y, (0x0a, sp)
      0082DB 90 89            [ 2]  485 	pushw	y
      0082DD 89               [ 2]  486 	pushw	x
      0082DE 88               [ 1]  487 	push	a
      0082DF 7B 0D            [ 1]  488 	ld	a, (0x0d, sp)
      0082E1 88               [ 1]  489 	push	a
      0082E2 4B 7A            [ 1]  490 	push	#<(___str_2+0)
      0082E4 4B 80            [ 1]  491 	push	#((___str_2+0) >> 8)
      0082E6 CD 83 37         [ 4]  492 	call	_printf
      0082E9 5B 0A            [ 2]  493 	addw	sp, #10
      0082EB 20 0F            [ 2]  494 	jra	00106$
      0082ED                        495 00105$:
                                    496 ;	src/main.c: 201: printf("Error -> Raw: 0x%08lX\n", reversed_data);
      0082ED 1E 0A            [ 2]  497 	ldw	x, (0x0a, sp)
      0082EF 89               [ 2]  498 	pushw	x
      0082F0 1E 0A            [ 2]  499 	ldw	x, (0x0a, sp)
      0082F2 89               [ 2]  500 	pushw	x
      0082F3 4B A9            [ 1]  501 	push	#<(___str_3+0)
      0082F5 4B 80            [ 1]  502 	push	#((___str_3+0) >> 8)
      0082F7 CD 83 37         [ 4]  503 	call	_printf
      0082FA 5B 06            [ 2]  504 	addw	sp, #6
      0082FC                        505 00106$:
                                    506 ;	src/main.c: 204: ir_data_ready = 0; // Clear the flag
      0082FC 72 5F 00 07      [ 1]  507 	clr	_ir_data_ready+0
                                    508 ;	src/main.c: 207: }
      008300 CC 82 4E         [ 2]  509 	jp	00111$
                                    510 	.area CODE
                                    511 	.area CONST
                                    512 	.area CONST
      008060                        513 ___str_1:
      008060 0A                     514 	.db 0x0a
      008061 0A                     515 	.db 0x0a
      008062 53 54 4D 38 53 20 49   516 	.ascii "STM8S IR Receiver Ready"
             52 20 52 65 63 65 69
             76 65 72 20 52 65 61
             64 79
      008079 00                     517 	.db 0x00
                                    518 	.area CODE
                                    519 	.area CONST
      00807A                        520 ___str_2:
      00807A 4F 4B 20 2D 3E 20 41   521 	.ascii "OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX"
             64 64 72 3A 20 30 78
             25 30 32 58 2C 20 43
             6D 64 3A 20 30 78 25
             30 32 58 2C 20 52 61
             77 3A 20 30 78 25 30
             38 6C 58
      0080A7 0A                     522 	.db 0x0a
      0080A8 00                     523 	.db 0x00
                                    524 	.area CODE
                                    525 	.area CONST
      0080A9                        526 ___str_3:
      0080A9 45 72 72 6F 72 20 2D   527 	.ascii "Error -> Raw: 0x%08lX"
             3E 20 52 61 77 3A 20
             30 78 25 30 38 6C 58
      0080BE 0A                     528 	.db 0x0a
      0080BF 00                     529 	.db 0x00
                                    530 	.area CODE
                                    531 	.area INITIALIZER
      0080CB                        532 __xinit__ir_state:
      0080CB 00                     533 	.db #0x00	; 0
      0080CC                        534 __xinit__ir_data:
      0080CC 00 00 00 00            535 	.byte #0x00, #0x00, #0x00, #0x00	; 0
      0080D0                        536 __xinit__ir_bit_count:
      0080D0 00                     537 	.db #0x00	; 0
      0080D1                        538 __xinit__ir_data_ready:
      0080D1 00                     539 	.db #0x00	; 0
                                    540 	.area CABS (ABS)
