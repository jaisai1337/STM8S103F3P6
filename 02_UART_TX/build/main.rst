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
                                     12 	.globl _USART1_Init
                                     13 	.globl _delay
                                     14 	.globl _puts
                                     15 	.globl _putchar
                                     16 ;--------------------------------------------------------
                                     17 ; ram data
                                     18 ;--------------------------------------------------------
                                     19 	.area DATA
                                     20 ;--------------------------------------------------------
                                     21 ; ram data
                                     22 ;--------------------------------------------------------
                                     23 	.area INITIALIZED
                                     24 ;--------------------------------------------------------
                                     25 ; Stack segment in internal ram
                                     26 ;--------------------------------------------------------
                                     27 	.area	SSEG
      000001                         28 __start__stack:
      000001                         29 	.ds	1
                                     30 
                                     31 ;--------------------------------------------------------
                                     32 ; absolute external ram data
                                     33 ;--------------------------------------------------------
                                     34 	.area DABS (ABS)
                                     35 
                                     36 ; default segment ordering for linker
                                     37 	.area HOME
                                     38 	.area GSINIT
                                     39 	.area GSFINAL
                                     40 	.area CONST
                                     41 	.area INITIALIZER
                                     42 	.area CODE
                                     43 
                                     44 ;--------------------------------------------------------
                                     45 ; interrupt vector
                                     46 ;--------------------------------------------------------
                                     47 	.area HOME
      008000                         48 __interrupt_vect:
      008000 82 00 80 07             49 	int s_GSINIT ; reset
                                     50 ;--------------------------------------------------------
                                     51 ; global & static initialisations
                                     52 ;--------------------------------------------------------
                                     53 	.area HOME
                                     54 	.area GSINIT
                                     55 	.area GSFINAL
                                     56 	.area GSINIT
      008007                         57 __sdcc_init_data:
                                     58 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   59 	ldw x, #l_DATA
      00800A 27 07            [ 1]   60 	jreq	00002$
      00800C                         61 00001$:
      00800C 72 4F 00 00      [ 1]   62 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   63 	decw x
      008011 26 F9            [ 1]   64 	jrne	00001$
      008013                         65 00002$:
      008013 AE 00 00         [ 2]   66 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   67 	jreq	00004$
      008018                         68 00003$:
      008018 D6 80 2F         [ 1]   69 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   70 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   71 	decw	x
      00801F 26 F7            [ 1]   72 	jrne	00003$
      008021                         73 00004$:
                                     74 ; stm8_genXINIT() end
                                     75 	.area GSFINAL
      008021 CC 80 04         [ 2]   76 	jp	__sdcc_program_startup
                                     77 ;--------------------------------------------------------
                                     78 ; Home
                                     79 ;--------------------------------------------------------
                                     80 	.area HOME
                                     81 	.area HOME
      008004                         82 __sdcc_program_startup:
      008004 CC 80 8C         [ 2]   83 	jp	_main
                                     84 ;	return from main will return to caller
                                     85 ;--------------------------------------------------------
                                     86 ; code
                                     87 ;--------------------------------------------------------
                                     88 	.area CODE
                                     89 ;	src/main.c: 5: void delay(volatile uint32_t count) {
                                     90 ;	-----------------------------------------
                                     91 ;	 function delay
                                     92 ;	-----------------------------------------
      008030                         93 _delay:
      008030 52 04            [ 2]   94 	sub	sp, #4
                                     95 ;	src/main.c: 6: while(count--) __asm__("nop");
      008032                         96 00101$:
      008032 16 09            [ 2]   97 	ldw	y, (0x09, sp)
      008034 17 03            [ 2]   98 	ldw	(0x03, sp), y
      008036 16 07            [ 2]   99 	ldw	y, (0x07, sp)
      008038 17 01            [ 2]  100 	ldw	(0x01, sp), y
      00803A 1E 03            [ 2]  101 	ldw	x, (0x03, sp)
      00803C 1D 00 01         [ 2]  102 	subw	x, #0x0001
      00803F 16 01            [ 2]  103 	ldw	y, (0x01, sp)
      008041 24 02            [ 1]  104 	jrnc	00116$
      008043 90 5A            [ 2]  105 	decw	y
      008045                        106 00116$:
      008045 1F 09            [ 2]  107 	ldw	(0x09, sp), x
      008047 17 07            [ 2]  108 	ldw	(0x07, sp), y
      008049 1E 03            [ 2]  109 	ldw	x, (0x03, sp)
      00804B 26 04            [ 1]  110 	jrne	00117$
      00804D 1E 01            [ 2]  111 	ldw	x, (0x01, sp)
      00804F 27 03            [ 1]  112 	jreq	00104$
      008051                        113 00117$:
      008051 9D               [ 1]  114 	nop
      008052 20 DE            [ 2]  115 	jra	00101$
      008054                        116 00104$:
                                    117 ;	src/main.c: 7: }
      008054 1E 05            [ 2]  118 	ldw	x, (5, sp)
      008056 5B 0A            [ 2]  119 	addw	sp, #10
      008058 FC               [ 2]  120 	jp	(x)
                                    121 ;	src/main.c: 10: void USART1_Init(void) {
                                    122 ;	-----------------------------------------
                                    123 ;	 function USART1_Init
                                    124 ;	-----------------------------------------
      008059                        125 _USART1_Init:
                                    126 ;	src/main.c: 15: GPIOD->DDR |= (1 << 5);  // Set PD5 as output
      008059 72 1A 50 11      [ 1]  127 	bset	0x5011, #5
                                    128 ;	src/main.c: 16: GPIOD->CR1 |= (1 << 5);  // Push-pull
      00805D 72 1A 50 12      [ 1]  129 	bset	0x5012, #5
                                    130 ;	src/main.c: 17: GPIOD->CR2 &= ~(1 << 5); // No interrupt, no fast output
      008061 72 1B 50 13      [ 1]  131 	bres	0x5013, #5
                                    132 ;	src/main.c: 24: USART1->BRR2 = 0x03;  // Example for 9600 bps @ 16 MHz
      008065 35 03 52 33      [ 1]  133 	mov	0x5233+0, #0x03
                                    134 ;	src/main.c: 25: USART1->BRR1 = 0x68;
      008069 35 68 52 32      [ 1]  135 	mov	0x5232+0, #0x68
                                    136 ;	src/main.c: 27: USART1->CR1 = 0x00;  
      00806D 35 00 52 34      [ 1]  137 	mov	0x5234+0, #0x00
                                    138 ;	src/main.c: 28: USART1->CR2 |= (1 << 3);  // TEN: Enable TX
      008071 72 16 52 35      [ 1]  139 	bset	0x5235, #3
                                    140 ;	src/main.c: 29: }
      008075 81               [ 4]  141 	ret
                                    142 ;	src/main.c: 32: int putchar(int c) {
                                    143 ;	-----------------------------------------
                                    144 ;	 function putchar
                                    145 ;	-----------------------------------------
      008076                        146 _putchar:
                                    147 ;	src/main.c: 33:     if (c == '\n') putchar('\r');  // Add carriage return for terminals
      008076 A3 00 0A         [ 2]  148 	cpw	x, #0x000a
      008079 26 07            [ 1]  149 	jrne	00103$
      00807B 89               [ 2]  150 	pushw	x
      00807C AE 00 0D         [ 2]  151 	ldw	x, #0x000d
      00807F AD F5            [ 4]  152 	callr	_putchar
      008081 85               [ 2]  153 	popw	x
                                    154 ;	src/main.c: 34:     while (!(USART1->SR & (1 << 7)));  // Wait until TXE (Transmit Data Register Empty)
      008082                        155 00103$:
      008082 C6 52 30         [ 1]  156 	ld	a, 0x5230
      008085 2A FB            [ 1]  157 	jrpl	00103$
                                    158 ;	src/main.c: 35:     USART1->DR = c;
      008087 9F               [ 1]  159 	ld	a, xl
      008088 C7 52 31         [ 1]  160 	ld	0x5231, a
                                    161 ;	src/main.c: 36:     return c;
                                    162 ;	src/main.c: 37: }
      00808B 81               [ 4]  163 	ret
                                    164 ;	src/main.c: 39: void main(void) {
                                    165 ;	-----------------------------------------
                                    166 ;	 function main
                                    167 ;	-----------------------------------------
      00808C                        168 _main:
                                    169 ;	src/main.c: 40: CLK->CKDIVR = 0x00; // for make it run on 16 MHz or else it will run on 2 MHz  brr2 = 0x00 ; brr1 = 0x0d; 
      00808C 35 00 50 C6      [ 1]  170 	mov	0x50c6+0, #0x00
                                    171 ;	src/main.c: 41: USART1_Init();
      008090 CD 80 59         [ 4]  172 	call	_USART1_Init
                                    173 ;	src/main.c: 43: while (1) {
      008093                        174 00102$:
                                    175 ;	src/main.c: 44: printf("Hello STM8!\n");
      008093 AE 80 24         [ 2]  176 	ldw	x, #(___str_1+0)
      008096 CD 80 A7         [ 4]  177 	call	_puts
                                    178 ;	src/main.c: 45: delay(500000);
      008099 4B 20            [ 1]  179 	push	#0x20
      00809B 4B A1            [ 1]  180 	push	#0xa1
      00809D 4B 07            [ 1]  181 	push	#0x07
      00809F 4B 00            [ 1]  182 	push	#0x00
      0080A1 CD 80 30         [ 4]  183 	call	_delay
      0080A4 20 ED            [ 2]  184 	jra	00102$
                                    185 ;	src/main.c: 47: }
      0080A6 81               [ 4]  186 	ret
                                    187 	.area CODE
                                    188 	.area CONST
                                    189 	.area CONST
      008024                        190 ___str_1:
      008024 48 65 6C 6C 6F 20 53   191 	.ascii "Hello STM8!"
             54 4D 38 21
      00802F 00                     192 	.db 0x00
                                    193 	.area CODE
                                    194 	.area INITIALIZER
                                    195 	.area CABS (ABS)
