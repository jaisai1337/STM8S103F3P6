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
                                     12 	.globl _EXTI_PORTB_IRQHandler
                                     13 	.globl _delay_ms
                                     14 ;--------------------------------------------------------
                                     15 ; ram data
                                     16 ;--------------------------------------------------------
                                     17 	.area DATA
                                     18 ;--------------------------------------------------------
                                     19 ; ram data
                                     20 ;--------------------------------------------------------
                                     21 	.area INITIALIZED
                                     22 ;--------------------------------------------------------
                                     23 ; Stack segment in internal ram
                                     24 ;--------------------------------------------------------
                                     25 	.area	SSEG
      000001                         26 __start__stack:
      000001                         27 	.ds	1
                                     28 
                                     29 ;--------------------------------------------------------
                                     30 ; absolute external ram data
                                     31 ;--------------------------------------------------------
                                     32 	.area DABS (ABS)
                                     33 
                                     34 ; default segment ordering for linker
                                     35 	.area HOME
                                     36 	.area GSINIT
                                     37 	.area GSFINAL
                                     38 	.area CONST
                                     39 	.area INITIALIZER
                                     40 	.area CODE
                                     41 
                                     42 ;--------------------------------------------------------
                                     43 ; interrupt vector
                                     44 ;--------------------------------------------------------
                                     45 	.area HOME
      008000                         46 __interrupt_vect:
      008000 82 00 80 1F             47 	int s_GSINIT ; reset
      008004 82 00 00 00             48 	int 0x000000 ; trap
      008008 82 00 00 00             49 	int 0x000000 ; int0
      00800C 82 00 00 00             50 	int 0x000000 ; int1
      008010 82 00 00 00             51 	int 0x000000 ; int2
      008014 82 00 00 00             52 	int 0x000000 ; int3
      008018 82 00 80 60             53 	int _EXTI_PORTB_IRQHandler ; int4
                                     54 ;--------------------------------------------------------
                                     55 ; global & static initialisations
                                     56 ;--------------------------------------------------------
                                     57 	.area HOME
                                     58 	.area GSINIT
                                     59 	.area GSFINAL
                                     60 	.area GSINIT
      00801F                         61 __sdcc_init_data:
                                     62 ; stm8_genXINIT() start
      00801F AE 00 00         [ 2]   63 	ldw x, #l_DATA
      008022 27 07            [ 1]   64 	jreq	00002$
      008024                         65 00001$:
      008024 72 4F 00 00      [ 1]   66 	clr (s_DATA - 1, x)
      008028 5A               [ 2]   67 	decw x
      008029 26 F9            [ 1]   68 	jrne	00001$
      00802B                         69 00002$:
      00802B AE 00 00         [ 2]   70 	ldw	x, #l_INITIALIZER
      00802E 27 09            [ 1]   71 	jreq	00004$
      008030                         72 00003$:
      008030 D6 80 3B         [ 1]   73 	ld	a, (s_INITIALIZER - 1, x)
      008033 D7 00 00         [ 1]   74 	ld	(s_INITIALIZED - 1, x), a
      008036 5A               [ 2]   75 	decw	x
      008037 26 F7            [ 1]   76 	jrne	00003$
      008039                         77 00004$:
                                     78 ; stm8_genXINIT() end
                                     79 	.area GSFINAL
      008039 CC 80 1C         [ 2]   80 	jp	__sdcc_program_startup
                                     81 ;--------------------------------------------------------
                                     82 ; Home
                                     83 ;--------------------------------------------------------
                                     84 	.area HOME
                                     85 	.area HOME
      00801C                         86 __sdcc_program_startup:
      00801C CC 80 6D         [ 2]   87 	jp	_main
                                     88 ;	return from main will return to caller
                                     89 ;--------------------------------------------------------
                                     90 ; code
                                     91 ;--------------------------------------------------------
                                     92 	.area CODE
                                     93 ;	src/main.c: 4: void delay_ms(uint16_t ms)
                                     94 ;	-----------------------------------------
                                     95 ;	 function delay_ms
                                     96 ;	-----------------------------------------
      00803C                         97 _delay_ms:
      00803C 52 04            [ 2]   98 	sub	sp, #4
      00803E 1F 01            [ 2]   99 	ldw	(0x01, sp), x
                                    100 ;	src/main.c: 6: for (uint16_t i = 0; i < ms; i++)
      008040 5F               [ 1]  101 	clrw	x
      008041 1F 03            [ 2]  102 	ldw	(0x03, sp), x
      008043                        103 00107$:
      008043 1E 03            [ 2]  104 	ldw	x, (0x03, sp)
      008045 13 01            [ 2]  105 	cpw	x, (0x01, sp)
      008047 24 14            [ 1]  106 	jrnc	00109$
                                    107 ;	src/main.c: 8: for (uint16_t j = 0; j < 1600; j++)
      008049 5F               [ 1]  108 	clrw	x
      00804A                        109 00104$:
      00804A 90 93            [ 1]  110 	ldw	y, x
      00804C 90 A3 06 40      [ 2]  111 	cpw	y, #0x0640
      008050 24 04            [ 1]  112 	jrnc	00108$
                                    113 ;	src/main.c: 10: __asm__("nop"); // No operation - just wastes a clock cycle
      008052 9D               [ 1]  114 	nop
                                    115 ;	src/main.c: 8: for (uint16_t j = 0; j < 1600; j++)
      008053 5C               [ 1]  116 	incw	x
      008054 20 F4            [ 2]  117 	jra	00104$
      008056                        118 00108$:
                                    119 ;	src/main.c: 6: for (uint16_t i = 0; i < ms; i++)
      008056 1E 03            [ 2]  120 	ldw	x, (0x03, sp)
      008058 5C               [ 1]  121 	incw	x
      008059 1F 03            [ 2]  122 	ldw	(0x03, sp), x
      00805B 20 E6            [ 2]  123 	jra	00107$
      00805D                        124 00109$:
                                    125 ;	src/main.c: 13: }
      00805D 5B 04            [ 2]  126 	addw	sp, #4
      00805F 81               [ 4]  127 	ret
                                    128 ;	src/main.c: 14: void EXTI_PORTB_IRQHandler(void) __interrupt(4)
                                    129 ;	-----------------------------------------
                                    130 ;	 function EXTI_PORTB_IRQHandler
                                    131 ;	-----------------------------------------
      008060                        132 _EXTI_PORTB_IRQHandler:
      008060 4F               [ 1]  133 	clr	a
      008061 62               [ 2]  134 	div	x, a
                                    135 ;	src/main.c: 17: GPIOC->ODR ^= (1 << 5); 
      008062 90 1A 50 0A      [ 1]  136 	bcpl	0x500a, #5
                                    137 ;	src/main.c: 18: delay_ms(50);
      008066 AE 00 32         [ 2]  138 	ldw	x, #0x0032
      008069 CD 80 3C         [ 4]  139 	call	_delay_ms
                                    140 ;	src/main.c: 19: }
      00806C 80               [11]  141 	iret
                                    142 ;	src/main.c: 21: void main(void)
                                    143 ;	-----------------------------------------
                                    144 ;	 function main
                                    145 ;	-----------------------------------------
      00806D                        146 _main:
                                    147 ;	src/main.c: 23: __asm__("sim");
      00806D 9B               [ 1]  148 	sim
                                    149 ;	src/main.c: 26: GPIOC->DDR |= (1 << 5);   // Set PC5 as output
      00806E 72 1A 50 0C      [ 1]  150 	bset	0x500c, #5
                                    151 ;	src/main.c: 27: GPIOC->CR1 |= (1 << 5);   // Set PC5 as push-pull
      008072 72 1A 50 0D      [ 1]  152 	bset	0x500d, #5
                                    153 ;	src/main.c: 28: GPIOC->ODR &= ~(1 << 5);  // Start with the LED off
      008076 72 1B 50 0A      [ 1]  154 	bres	0x500a, #5
                                    155 ;	src/main.c: 31: GPIOB->DDR &= ~(1 << 4);  // Set PB4 as input
      00807A 72 19 50 07      [ 1]  156 	bres	0x5007, #4
                                    157 ;	src/main.c: 32: GPIOB->CR1 |= (1 << 4);   // Enable the internal pull-up resistor
      00807E 72 18 50 08      [ 1]  158 	bset	0x5008, #4
                                    159 ;	src/main.c: 33: GPIOB->CR2 |= (1 << 4);   // **FIX:** Enable external interrupt for pin PB4
      008082 C6 50 09         [ 1]  160 	ld	a, 0x5009
      008085 AA 10            [ 1]  161 	or	a, #0x10
      008087 C7 50 09         [ 1]  162 	ld	0x5009, a
                                    163 ;	src/main.c: 35: EXTI->CR1 = (2 << 2); 
      00808A 35 08 50 A0      [ 1]  164 	mov	0x50a0+0, #0x08
                                    165 ;	src/main.c: 36: EXTI->CR2 = 0;
      00808E 35 00 50 A1      [ 1]  166 	mov	0x50a1+0, #0x00
                                    167 ;	src/main.c: 38: __asm__("rim"); 
      008092 9A               [ 1]  168 	rim
                                    169 ;	src/main.c: 41: while (1)
      008093                        170 00102$:
                                    171 ;	src/main.c: 45: __asm__("wfi");
      008093 8F               [10]  172 	wfi
      008094 20 FD            [ 2]  173 	jra	00102$
                                    174 ;	src/main.c: 47: }
      008096 81               [ 4]  175 	ret
                                    176 	.area CODE
                                    177 	.area CONST
                                    178 	.area INITIALIZER
                                    179 	.area CABS (ABS)
