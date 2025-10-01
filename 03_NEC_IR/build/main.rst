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
      008020 82 00 81 23             73 	int _EXTI_PORTD_IRQHandler ; int6
      008024 82 00 00 00             74 	int 0x000000 ; int7
      008028 82 00 00 00             75 	int 0x000000 ; int8
      00802C 82 00 00 00             76 	int 0x000000 ; int9
      008030 82 00 00 00             77 	int 0x000000 ; int10
      008034 82 00 00 00             78 	int 0x000000 ; int11
      008038 82 00 00 00             79 	int 0x000000 ; int12
      00803C 82 00 82 29             80 	int _TIM2_Update_IRQHandler ; int13
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
      008054 D6 80 D2         [ 1]  100 	ld	a, (s_INITIALIZER - 1, x)
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
      008040 CC 82 40         [ 2]  114 	jp	_main
                                    115 ;	return from main will return to caller
                                    116 ;--------------------------------------------------------
                                    117 ; code
                                    118 ;--------------------------------------------------------
                                    119 	.area CODE
                                    120 ;	src/main.c: 31: void USART1_Init(void) {
                                    121 ;	-----------------------------------------
                                    122 ;	 function USART1_Init
                                    123 ;	-----------------------------------------
      0080DA                        124 _USART1_Init:
                                    125 ;	src/main.c: 32: GPIOD->DDR |= (1 << 5);
      0080DA 72 1A 50 11      [ 1]  126 	bset	0x5011, #5
                                    127 ;	src/main.c: 33: GPIOD->CR1 |= (1 << 5);
      0080DE 72 1A 50 12      [ 1]  128 	bset	0x5012, #5
                                    129 ;	src/main.c: 34: USART1->BRR2 = 0x03;
      0080E2 35 03 52 33      [ 1]  130 	mov	0x5233+0, #0x03
                                    131 ;	src/main.c: 35: USART1->BRR1 = 0x68;
      0080E6 35 68 52 32      [ 1]  132 	mov	0x5232+0, #0x68
                                    133 ;	src/main.c: 36: USART1->CR2 |= (1 << 3);
      0080EA 72 16 52 35      [ 1]  134 	bset	0x5235, #3
                                    135 ;	src/main.c: 37: }
      0080EE 81               [ 4]  136 	ret
                                    137 ;	src/main.c: 39: int putchar(int c) {
                                    138 ;	-----------------------------------------
                                    139 ;	 function putchar
                                    140 ;	-----------------------------------------
      0080EF                        141 _putchar:
                                    142 ;	src/main.c: 40: if (c == '\n') putchar('\r');
      0080EF A3 00 0A         [ 2]  143 	cpw	x, #0x000a
      0080F2 26 07            [ 1]  144 	jrne	00103$
      0080F4 89               [ 2]  145 	pushw	x
      0080F5 AE 00 0D         [ 2]  146 	ldw	x, #0x000d
      0080F8 AD F5            [ 4]  147 	callr	_putchar
      0080FA 85               [ 2]  148 	popw	x
                                    149 ;	src/main.c: 41: while (!(USART1->SR & (1 << 7)));
      0080FB                        150 00103$:
      0080FB C6 52 30         [ 1]  151 	ld	a, 0x5230
      0080FE 2A FB            [ 1]  152 	jrpl	00103$
                                    153 ;	src/main.c: 42: USART1->DR = c;
      008100 9F               [ 1]  154 	ld	a, xl
      008101 C7 52 31         [ 1]  155 	ld	0x5231, a
                                    156 ;	src/main.c: 43: return c;
                                    157 ;	src/main.c: 44: }
      008104 81               [ 4]  158 	ret
                                    159 ;	src/main.c: 46: void TIM2_Init(void) {
                                    160 ;	-----------------------------------------
                                    161 ;	 function TIM2_Init
                                    162 ;	-----------------------------------------
      008105                        163 _TIM2_Init:
                                    164 ;	src/main.c: 47: CLK->PCKENR1 |= (1 << 5);
      008105 72 1A 50 C7      [ 1]  165 	bset	0x50c7, #5
                                    166 ;	src/main.c: 48: TIM2->PSCR = 0x04;
      008109 35 04 53 0E      [ 1]  167 	mov	0x530e+0, #0x04
                                    168 ;	src/main.c: 49: TIM2->IER |= (1 << 0);
      00810D 72 10 53 03      [ 1]  169 	bset	0x5303, #0
                                    170 ;	src/main.c: 50: }
      008111 81               [ 4]  171 	ret
                                    172 ;	src/main.c: 52: void IR_GPIO_Init(void) {
                                    173 ;	-----------------------------------------
                                    174 ;	 function IR_GPIO_Init
                                    175 ;	-----------------------------------------
      008112                        176 _IR_GPIO_Init:
                                    177 ;	src/main.c: 53: GPIOD->DDR &= ~IR_PIN_MASK;
      008112 72 17 50 11      [ 1]  178 	bres	0x5011, #3
                                    179 ;	src/main.c: 54: GPIOD->CR1 |= IR_PIN_MASK;
      008116 72 16 50 12      [ 1]  180 	bset	0x5012, #3
                                    181 ;	src/main.c: 55: GPIOD->CR2 |= IR_PIN_MASK;
      00811A 72 16 50 13      [ 1]  182 	bset	0x5013, #3
                                    183 ;	src/main.c: 56: EXTI->CR1 = (2 << 6);
      00811E 35 80 50 A0      [ 1]  184 	mov	0x50a0+0, #0x80
                                    185 ;	src/main.c: 57: }
      008122 81               [ 4]  186 	ret
                                    187 ;	src/main.c: 60: void EXTI_PORTD_IRQHandler(void) __interrupt(6) {
                                    188 ;	-----------------------------------------
                                    189 ;	 function EXTI_PORTD_IRQHandler
                                    190 ;	-----------------------------------------
      008123                        191 _EXTI_PORTD_IRQHandler:
      008123 52 04            [ 2]  192 	sub	sp, #4
                                    193 ;	src/main.c: 61: uint16_t pulse_width = (TIM2->CNTRH << 8) | TIM2->CNTRL;
      008125 C6 53 0C         [ 1]  194 	ld	a, 0x530c
      008128 95               [ 1]  195 	ld	xh, a
      008129 0F 02            [ 1]  196 	clr	(0x02, sp)
      00812B C6 53 0D         [ 1]  197 	ld	a, 0x530d
      00812E 0F 03            [ 1]  198 	clr	(0x03, sp)
      008130 1A 02            [ 1]  199 	or	a, (0x02, sp)
      008132 02               [ 1]  200 	rlwa	x
      008133 1A 03            [ 1]  201 	or	a, (0x03, sp)
      008135 95               [ 1]  202 	ld	xh, a
      008136 1F 03            [ 2]  203 	ldw	(0x03, sp), x
                                    204 ;	src/main.c: 62: TIM2->CNTRH = 0;
      008138 35 00 53 0C      [ 1]  205 	mov	0x530c+0, #0x00
                                    206 ;	src/main.c: 63: TIM2->CNTRL = 0;
      00813C 35 00 53 0D      [ 1]  207 	mov	0x530d+0, #0x00
                                    208 ;	src/main.c: 65: switch (ir_state) {
      008140 C6 00 01         [ 1]  209 	ld	a, _ir_state+0
      008143 A1 04            [ 1]  210 	cp	a, #0x04
      008145 23 03            [ 2]  211 	jrule	00186$
      008147 CC 82 26         [ 2]  212 	jp	00129$
      00814A                        213 00186$:
                                    214 ;	src/main.c: 73: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
      00814A 16 03            [ 2]  215 	ldw	y, (0x03, sp)
                                    216 ;	src/main.c: 65: switch (ir_state) {
      00814C 5F               [ 1]  217 	clrw	x
      00814D 97               [ 1]  218 	ld	xl, a
      00814E 58               [ 2]  219 	sllw	x
      00814F DE 81 53         [ 2]  220 	ldw	x, (#00187$, x)
      008152 FC               [ 2]  221 	jp	(x)
      008153                        222 00187$:
      008153 81 5D                  223 	.dw	#00101$
      008155 81 6C                  224 	.dw	#00102$
      008157 81 86                  225 	.dw	#00107$
      008159 81 AA                  226 	.dw	#00112$
      00815B 81 C2                  227 	.dw	#00117$
                                    228 ;	src/main.c: 67: case STATE_IDLE:
      00815D                        229 00101$:
                                    230 ;	src/main.c: 68: TIM2->CR1 |= (1 << 0);
      00815D 72 10 53 00      [ 1]  231 	bset	0x5300, #0
                                    232 ;	src/main.c: 69: ir_state = STATE_START_PULSE;
      008161 35 01 00 01      [ 1]  233 	mov	_ir_state+0, #0x01
                                    234 ;	src/main.c: 70: EXTI->CR1 = (3 << 6);
      008165 35 C0 50 A0      [ 1]  235 	mov	0x50a0+0, #0xc0
                                    236 ;	src/main.c: 71: break;
      008169 CC 82 26         [ 2]  237 	jp	00129$
                                    238 ;	src/main.c: 72: case STATE_START_PULSE:
      00816C                        239 00102$:
                                    240 ;	src/main.c: 73: if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
      00816C 90 A3 1F 40      [ 2]  241 	cpw	y, #0x1f40
      008170 23 0D            [ 2]  242 	jrule	00104$
      008172 90 A3 27 10      [ 2]  243 	cpw	y, #0x2710
      008176 24 07            [ 1]  244 	jrnc	00104$
                                    245 ;	src/main.c: 74: ir_state = STATE_START_SPACE;
      008178 35 02 00 01      [ 1]  246 	mov	_ir_state+0, #0x02
      00817C CC 82 26         [ 2]  247 	jp	00129$
      00817F                        248 00104$:
                                    249 ;	src/main.c: 75: } else { ir_state = STATE_IDLE; }
      00817F 72 5F 00 01      [ 1]  250 	clr	_ir_state+0
                                    251 ;	src/main.c: 76: break;
      008183 CC 82 26         [ 2]  252 	jp	00129$
                                    253 ;	src/main.c: 77: case STATE_START_SPACE:
      008186                        254 00107$:
                                    255 ;	src/main.c: 78: if (pulse_width > NEC_START_SPACE_MIN && pulse_width < NEC_START_SPACE_MAX) {
      008186 90 A3 0F A0      [ 2]  256 	cpw	y, #0x0fa0
      00818A 23 18            [ 2]  257 	jrule	00109$
      00818C 90 A3 13 88      [ 2]  258 	cpw	y, #0x1388
      008190 24 12            [ 1]  259 	jrnc	00109$
                                    260 ;	src/main.c: 79: ir_state = STATE_BIT_PULSE;
      008192 35 03 00 01      [ 1]  261 	mov	_ir_state+0, #0x03
                                    262 ;	src/main.c: 80: ir_bit_count = 0;
      008196 72 5F 00 06      [ 1]  263 	clr	_ir_bit_count+0
                                    264 ;	src/main.c: 81: ir_data = 0;
      00819A 5F               [ 1]  265 	clrw	x
      00819B CF 00 04         [ 2]  266 	ldw	_ir_data+2, x
      00819E CF 00 02         [ 2]  267 	ldw	_ir_data+0, x
      0081A1 CC 82 26         [ 2]  268 	jp	00129$
      0081A4                        269 00109$:
                                    270 ;	src/main.c: 82: } else { ir_state = STATE_IDLE; }
      0081A4 72 5F 00 01      [ 1]  271 	clr	_ir_state+0
                                    272 ;	src/main.c: 83: break;
      0081A8 20 7C            [ 2]  273 	jra	00129$
                                    274 ;	src/main.c: 84: case STATE_BIT_PULSE:
      0081AA                        275 00112$:
                                    276 ;	src/main.c: 85: if (pulse_width > NEC_BIT_PULSE_MIN && pulse_width < NEC_BIT_PULSE_MAX) {
      0081AA 90 A3 01 90      [ 2]  277 	cpw	y, #0x0190
      0081AE 23 0C            [ 2]  278 	jrule	00114$
      0081B0 90 A3 02 BC      [ 2]  279 	cpw	y, #0x02bc
      0081B4 24 06            [ 1]  280 	jrnc	00114$
                                    281 ;	src/main.c: 86: ir_state = STATE_BIT_SPACE;
      0081B6 35 04 00 01      [ 1]  282 	mov	_ir_state+0, #0x04
      0081BA 20 6A            [ 2]  283 	jra	00129$
      0081BC                        284 00114$:
                                    285 ;	src/main.c: 87: } else { ir_state = STATE_IDLE; }
      0081BC 72 5F 00 01      [ 1]  286 	clr	_ir_state+0
                                    287 ;	src/main.c: 88: break;
      0081C0 20 64            [ 2]  288 	jra	00129$
                                    289 ;	src/main.c: 90: case STATE_BIT_SPACE:
      0081C2                        290 00117$:
                                    291 ;	src/main.c: 95: ir_data <<= 1;
      0081C2 72 58 00 05      [ 1]  292 	sll	_ir_data+3
      0081C6 72 59 00 04      [ 1]  293 	rlc	_ir_data+2
      0081CA 72 59 00 03      [ 1]  294 	rlc	_ir_data+1
      0081CE 72 59 00 02      [ 1]  295 	rlc	_ir_data+0
                                    296 ;	src/main.c: 97: if (pulse_width > NEC_LOGIC_1_SPACE_MIN && pulse_width < NEC_LOGIC_1_SPACE_MAX) {
      0081D2 1E 03            [ 2]  297 	ldw	x, (0x03, sp)
      0081D4 A3 05 DC         [ 2]  298 	cpw	x, #0x05dc
      0081D7 23 1C            [ 2]  299 	jrule	00122$
      0081D9 A3 07 08         [ 2]  300 	cpw	x, #0x0708
      0081DC 24 17            [ 1]  301 	jrnc	00122$
                                    302 ;	src/main.c: 98: ir_data |= 1; // It's a '1', so set the new LSB
      0081DE C6 00 05         [ 1]  303 	ld	a, _ir_data+3
      0081E1 AA 01            [ 1]  304 	or	a, #0x01
      0081E3 97               [ 1]  305 	ld	xl, a
      0081E4 C6 00 04         [ 1]  306 	ld	a, _ir_data+2
      0081E7 95               [ 1]  307 	ld	xh, a
      0081E8 90 CE 00 02      [ 2]  308 	ldw	y, _ir_data+0
      0081EC CF 00 04         [ 2]  309 	ldw	_ir_data+2, x
      0081EF 90 CF 00 02      [ 2]  310 	ldw	_ir_data+0, y
      0081F3 20 10            [ 2]  311 	jra	00123$
      0081F5                        312 00122$:
                                    313 ;	src/main.c: 100: else if (!(pulse_width > NEC_LOGIC_0_SPACE_MIN && pulse_width < NEC_LOGIC_0_SPACE_MAX)) {
      0081F5 A3 01 90         [ 2]  314 	cpw	x, #0x0190
      0081F8 23 05            [ 2]  315 	jrule	00118$
      0081FA A3 02 BC         [ 2]  316 	cpw	x, #0x02bc
      0081FD 25 06            [ 1]  317 	jrc	00123$
      0081FF                        318 00118$:
                                    319 ;	src/main.c: 101: ir_state = STATE_IDLE; // Pulse width error
      0081FF 72 5F 00 01      [ 1]  320 	clr	_ir_state+0
                                    321 ;	src/main.c: 102: break;
      008203 20 21            [ 2]  322 	jra	00129$
      008205                        323 00123$:
                                    324 ;	src/main.c: 105: ir_bit_count++;
      008205 72 5C 00 06      [ 1]  325 	inc	_ir_bit_count+0
                                    326 ;	src/main.c: 106: if (ir_bit_count == 32) {
      008209 C6 00 06         [ 1]  327 	ld	a, _ir_bit_count+0
      00820C A1 20            [ 1]  328 	cp	a, #0x20
      00820E 26 12            [ 1]  329 	jrne	00126$
                                    330 ;	src/main.c: 107: ir_data_ready = 1;
      008210 35 01 00 07      [ 1]  331 	mov	_ir_data_ready+0, #0x01
                                    332 ;	src/main.c: 108: ir_state = STATE_IDLE;
      008214 72 5F 00 01      [ 1]  333 	clr	_ir_state+0
                                    334 ;	src/main.c: 109: TIM2->CR1 &= ~(1 << 0);
      008218 72 11 53 00      [ 1]  335 	bres	0x5300, #0
                                    336 ;	src/main.c: 110: EXTI->CR1 = (2 << 6);
      00821C 35 80 50 A0      [ 1]  337 	mov	0x50a0+0, #0x80
      008220 20 04            [ 2]  338 	jra	00129$
      008222                        339 00126$:
                                    340 ;	src/main.c: 112: ir_state = STATE_BIT_PULSE;
      008222 35 03 00 01      [ 1]  341 	mov	_ir_state+0, #0x03
                                    342 ;	src/main.c: 115: }
      008226                        343 00129$:
                                    344 ;	src/main.c: 116: }
      008226 5B 04            [ 2]  345 	addw	sp, #4
      008228 80               [11]  346 	iret
                                    347 ;	src/main.c: 118: void TIM2_Update_IRQHandler(void) __interrupt(13) {
                                    348 ;	-----------------------------------------
                                    349 ;	 function TIM2_Update_IRQHandler
                                    350 ;	-----------------------------------------
      008229                        351 _TIM2_Update_IRQHandler:
                                    352 ;	src/main.c: 119: if (TIM2->SR1 & (1 << 0)) {
      008229 C6 53 04         [ 1]  353 	ld	a, 0x5304
      00822C 44               [ 1]  354 	srl	a
      00822D 24 10            [ 1]  355 	jrnc	00103$
                                    356 ;	src/main.c: 120: ir_state = STATE_IDLE;
      00822F 72 5F 00 01      [ 1]  357 	clr	_ir_state+0
                                    358 ;	src/main.c: 121: TIM2->CR1 &= ~(1 << 0);
      008233 72 11 53 00      [ 1]  359 	bres	0x5300, #0
                                    360 ;	src/main.c: 122: EXTI->CR1 = (2 << 6);
      008237 35 80 50 A0      [ 1]  361 	mov	0x50a0+0, #0x80
                                    362 ;	src/main.c: 123: TIM2->SR1 &= ~(1 << 0);
      00823B 72 11 53 04      [ 1]  363 	bres	0x5304, #0
      00823F                        364 00103$:
                                    365 ;	src/main.c: 125: }
      00823F 80               [11]  366 	iret
                                    367 ;	src/main.c: 128: void main(void) {
                                    368 ;	-----------------------------------------
                                    369 ;	 function main
                                    370 ;	-----------------------------------------
      008240                        371 _main:
      008240 52 02            [ 2]  372 	sub	sp, #2
                                    373 ;	src/main.c: 129: CLK->CKDIVR = 0x00;
      008242 35 00 50 C6      [ 1]  374 	mov	0x50c6+0, #0x00
                                    375 ;	src/main.c: 130: USART1_Init();
      008246 CD 80 DA         [ 4]  376 	call	_USART1_Init
                                    377 ;	src/main.c: 131: IR_GPIO_Init();
      008249 CD 81 12         [ 4]  378 	call	_IR_GPIO_Init
                                    379 ;	src/main.c: 132: TIM2_Init();
      00824C CD 81 05         [ 4]  380 	call	_TIM2_Init
                                    381 ;	src/main.c: 133: __asm__("rim");
      00824F 9A               [ 1]  382 	rim
                                    383 ;	src/main.c: 135: printf("\n\nSTM8S IR Receiver Ready (Fixed)\n");
      008250 AE 80 60         [ 2]  384 	ldw	x, #(___str_1+0)
      008253 CD 82 B8         [ 4]  385 	call	_puts
                                    386 ;	src/main.c: 137: while (1) {
      008256                        387 00108$:
                                    388 ;	src/main.c: 138: if (ir_data_ready) {
      008256 C6 00 07         [ 1]  389 	ld	a, _ir_data_ready+0
      008259 27 FB            [ 1]  390 	jreq	00108$
                                    391 ;	src/main.c: 143: uint8_t address = (ir_data >> 24) & 0xFF;
      00825B C6 00 02         [ 1]  392 	ld	a, _ir_data+0
      00825E 97               [ 1]  393 	ld	xl, a
                                    394 ;	src/main.c: 144: uint8_t not_address = (ir_data >> 16) & 0xFF;
      00825F C6 00 03         [ 1]  395 	ld	a, _ir_data+1
      008262 6B 01            [ 1]  396 	ld	(0x01, sp), a
                                    397 ;	src/main.c: 145: uint8_t command = (ir_data >> 8) & 0xFF;
      008264 C6 00 04         [ 1]  398 	ld	a, _ir_data+2
      008267 95               [ 1]  399 	ld	xh, a
                                    400 ;	src/main.c: 146: uint8_t not_command = ir_data & 0xFF;
      008268 C6 00 05         [ 1]  401 	ld	a, _ir_data+3
      00826B 6B 02            [ 1]  402 	ld	(0x02, sp), a
                                    403 ;	src/main.c: 148: if ((uint8_t)~address == not_address && (uint8_t)~command == not_command) {
      00826D 9F               [ 1]  404 	ld	a, xl
      00826E 43               [ 1]  405 	cpl	a
      00826F 11 01            [ 1]  406 	cp	a, (0x01, sp)
      008271 26 27            [ 1]  407 	jrne	00102$
      008273 9E               [ 1]  408 	ld	a, xh
      008274 43               [ 1]  409 	cpl	a
      008275 11 02            [ 1]  410 	cp	a, (0x02, sp)
      008277 26 21            [ 1]  411 	jrne	00102$
                                    412 ;	src/main.c: 149: printf("OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX\n", address, command, ir_data);
      008279 90 5F            [ 1]  413 	clrw	y
      00827B 61               [ 1]  414 	exg	a, yl
      00827C 9E               [ 1]  415 	ld	a, xh
      00827D 61               [ 1]  416 	exg	a, yl
      00827E 4F               [ 1]  417 	clr	a
      00827F 95               [ 1]  418 	ld	xh, a
      008280 3B 00 05         [ 1]  419 	push	_ir_data+3
      008283 3B 00 04         [ 1]  420 	push	_ir_data+2
      008286 3B 00 03         [ 1]  421 	push	_ir_data+1
      008289 3B 00 02         [ 1]  422 	push	_ir_data+0
      00828C 90 89            [ 2]  423 	pushw	y
      00828E 89               [ 2]  424 	pushw	x
      00828F 4B 82            [ 1]  425 	push	#<(___str_2+0)
      008291 4B 80            [ 1]  426 	push	#((___str_2+0) >> 8)
      008293 CD 82 EC         [ 4]  427 	call	_printf
      008296 5B 0A            [ 2]  428 	addw	sp, #10
      008298 20 15            [ 2]  429 	jra	00103$
      00829A                        430 00102$:
                                    431 ;	src/main.c: 151: printf("Error -> Raw: 0x%08lX\n", ir_data);
      00829A AE 80 B1         [ 2]  432 	ldw	x, #(___str_3+0)
      00829D 3B 00 05         [ 1]  433 	push	_ir_data+3
      0082A0 3B 00 04         [ 1]  434 	push	_ir_data+2
      0082A3 3B 00 03         [ 1]  435 	push	_ir_data+1
      0082A6 3B 00 02         [ 1]  436 	push	_ir_data+0
      0082A9 89               [ 2]  437 	pushw	x
      0082AA CD 82 EC         [ 4]  438 	call	_printf
      0082AD 5B 06            [ 2]  439 	addw	sp, #6
      0082AF                        440 00103$:
                                    441 ;	src/main.c: 154: ir_data_ready = 0; // Clear the flag
      0082AF 72 5F 00 07      [ 1]  442 	clr	_ir_data_ready+0
      0082B3 20 A1            [ 2]  443 	jra	00108$
                                    444 ;	src/main.c: 157: }
      0082B5 5B 02            [ 2]  445 	addw	sp, #2
      0082B7 81               [ 4]  446 	ret
                                    447 	.area CODE
                                    448 	.area CONST
                                    449 	.area CONST
      008060                        450 ___str_1:
      008060 0A                     451 	.db 0x0a
      008061 0A                     452 	.db 0x0a
      008062 53 54 4D 38 53 20 49   453 	.ascii "STM8S IR Receiver Ready (Fixed)"
             52 20 52 65 63 65 69
             76 65 72 20 52 65 61
             64 79 20 28 46 69 78
             65 64 29
      008081 00                     454 	.db 0x00
                                    455 	.area CODE
                                    456 	.area CONST
      008082                        457 ___str_2:
      008082 4F 4B 20 2D 3E 20 41   458 	.ascii "OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX"
             64 64 72 3A 20 30 78
             25 30 32 58 2C 20 43
             6D 64 3A 20 30 78 25
             30 32 58 2C 20 52 61
             77 3A 20 30 78 25 30
             38 6C 58
      0080AF 0A                     459 	.db 0x0a
      0080B0 00                     460 	.db 0x00
                                    461 	.area CODE
                                    462 	.area CONST
      0080B1                        463 ___str_3:
      0080B1 45 72 72 6F 72 20 2D   464 	.ascii "Error -> Raw: 0x%08lX"
             3E 20 52 61 77 3A 20
             30 78 25 30 38 6C 58
      0080C6 0A                     465 	.db 0x0a
      0080C7 00                     466 	.db 0x00
                                    467 	.area CODE
                                    468 	.area INITIALIZER
      0080D3                        469 __xinit__ir_state:
      0080D3 00                     470 	.db #0x00	; 0
      0080D4                        471 __xinit__ir_data:
      0080D4 00 00 00 00            472 	.byte #0x00, #0x00, #0x00, #0x00	; 0
      0080D8                        473 __xinit__ir_bit_count:
      0080D8 00                     474 	.db #0x00	; 0
      0080D9                        475 __xinit__ir_data_ready:
      0080D9 00                     476 	.db #0x00	; 0
                                    477 	.area CABS (ABS)
