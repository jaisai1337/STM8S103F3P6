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
                                     12 	.globl _delay
                                     13 ;--------------------------------------------------------
                                     14 ; ram data
                                     15 ;--------------------------------------------------------
                                     16 	.area DATA
                                     17 ;--------------------------------------------------------
                                     18 ; ram data
                                     19 ;--------------------------------------------------------
                                     20 	.area INITIALIZED
                                     21 ;--------------------------------------------------------
                                     22 ; Stack segment in internal ram
                                     23 ;--------------------------------------------------------
                                     24 	.area	SSEG
      000001                         25 __start__stack:
      000001                         26 	.ds	1
                                     27 
                                     28 ;--------------------------------------------------------
                                     29 ; absolute external ram data
                                     30 ;--------------------------------------------------------
                                     31 	.area DABS (ABS)
                                     32 
                                     33 ; default segment ordering for linker
                                     34 	.area HOME
                                     35 	.area GSINIT
                                     36 	.area GSFINAL
                                     37 	.area CONST
                                     38 	.area INITIALIZER
                                     39 	.area CODE
                                     40 
                                     41 ;--------------------------------------------------------
                                     42 ; interrupt vector
                                     43 ;--------------------------------------------------------
                                     44 	.area HOME
      008000                         45 __interrupt_vect:
      008000 82 00 80 07             46 	int s_GSINIT ; reset
                                     47 ;--------------------------------------------------------
                                     48 ; global & static initialisations
                                     49 ;--------------------------------------------------------
                                     50 	.area HOME
                                     51 	.area GSINIT
                                     52 	.area GSFINAL
                                     53 	.area GSINIT
      008007                         54 __sdcc_init_data:
                                     55 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   56 	ldw x, #l_DATA
      00800A 27 07            [ 1]   57 	jreq	00002$
      00800C                         58 00001$:
      00800C 72 4F 00 00      [ 1]   59 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   60 	decw x
      008011 26 F9            [ 1]   61 	jrne	00001$
      008013                         62 00002$:
      008013 AE 00 00         [ 2]   63 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   64 	jreq	00004$
      008018                         65 00003$:
      008018 D6 80 23         [ 1]   66 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   67 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   68 	decw	x
      00801F 26 F7            [ 1]   69 	jrne	00003$
      008021                         70 00004$:
                                     71 ; stm8_genXINIT() end
                                     72 	.area GSFINAL
      008021 CC 80 04         [ 2]   73 	jp	__sdcc_program_startup
                                     74 ;--------------------------------------------------------
                                     75 ; Home
                                     76 ;--------------------------------------------------------
                                     77 	.area HOME
                                     78 	.area HOME
      008004                         79 __sdcc_program_startup:
      008004 CC 80 4D         [ 2]   80 	jp	_main
                                     81 ;	return from main will return to caller
                                     82 ;--------------------------------------------------------
                                     83 ; code
                                     84 ;--------------------------------------------------------
                                     85 	.area CODE
                                     86 ;	src/main.c: 4: void delay(volatile uint32_t count) {
                                     87 ;	-----------------------------------------
                                     88 ;	 function delay
                                     89 ;	-----------------------------------------
      008024                         90 _delay:
      008024 52 04            [ 2]   91 	sub	sp, #4
                                     92 ;	src/main.c: 5: while(count--) {
      008026                         93 00101$:
      008026 16 09            [ 2]   94 	ldw	y, (0x09, sp)
      008028 17 03            [ 2]   95 	ldw	(0x03, sp), y
      00802A 16 07            [ 2]   96 	ldw	y, (0x07, sp)
      00802C 17 01            [ 2]   97 	ldw	(0x01, sp), y
      00802E 1E 03            [ 2]   98 	ldw	x, (0x03, sp)
      008030 1D 00 01         [ 2]   99 	subw	x, #0x0001
      008033 16 01            [ 2]  100 	ldw	y, (0x01, sp)
      008035 24 02            [ 1]  101 	jrnc	00116$
      008037 90 5A            [ 2]  102 	decw	y
      008039                        103 00116$:
      008039 1F 09            [ 2]  104 	ldw	(0x09, sp), x
      00803B 17 07            [ 2]  105 	ldw	(0x07, sp), y
      00803D 1E 03            [ 2]  106 	ldw	x, (0x03, sp)
      00803F 26 04            [ 1]  107 	jrne	00117$
      008041 1E 01            [ 2]  108 	ldw	x, (0x01, sp)
      008043 27 03            [ 1]  109 	jreq	00104$
      008045                        110 00117$:
                                    111 ;	src/main.c: 6: __asm__("nop");
      008045 9D               [ 1]  112 	nop
      008046 20 DE            [ 2]  113 	jra	00101$
      008048                        114 00104$:
                                    115 ;	src/main.c: 8: }
      008048 1E 05            [ 2]  116 	ldw	x, (5, sp)
      00804A 5B 0A            [ 2]  117 	addw	sp, #10
      00804C FC               [ 2]  118 	jp	(x)
                                    119 ;	src/main.c: 10: int main(void) {
                                    120 ;	-----------------------------------------
                                    121 ;	 function main
                                    122 ;	-----------------------------------------
      00804D                        123 _main:
                                    124 ;	src/main.c: 12: GPIOB->DDR |= (1 << 5);   // Set PB5 as output
      00804D 72 1A 50 07      [ 1]  125 	bset	0x5007, #5
                                    126 ;	src/main.c: 13: GPIOB->CR1 |= (1 << 5);   // Push-pull
      008051 72 1A 50 08      [ 1]  127 	bset	0x5008, #5
                                    128 ;	src/main.c: 14: GPIOB->CR2 &= ~(1 << 5);  // No fast output
      008055 72 1B 50 09      [ 1]  129 	bres	0x5009, #5
                                    130 ;	src/main.c: 16: while (1) {
      008059                        131 00102$:
                                    132 ;	src/main.c: 17: GPIOB->ODR ^= (1 << 5);  // Toggle PB5
      008059 90 1A 50 05      [ 1]  133 	bcpl	0x5005, #5
                                    134 ;	src/main.c: 18: delay(50000);            // Simple software delay
      00805D 4B 50            [ 1]  135 	push	#0x50
      00805F 4B C3            [ 1]  136 	push	#0xc3
      008061 5F               [ 1]  137 	clrw	x
      008062 89               [ 2]  138 	pushw	x
      008063 CD 80 24         [ 4]  139 	call	_delay
      008066 20 F1            [ 2]  140 	jra	00102$
                                    141 ;	src/main.c: 21: }
      008068 81               [ 4]  142 	ret
                                    143 	.area CODE
                                    144 	.area CONST
                                    145 	.area INITIALIZER
                                    146 	.area CABS (ABS)
