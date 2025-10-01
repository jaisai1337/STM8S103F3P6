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
                                     12 	.globl _nec_get_data
                                     13 	.globl _nec_data_ready
                                     14 	.globl _nec_init
                                     15 	.globl _uart_init
                                     16 	.globl _puts
                                     17 	.globl _printf
                                     18 ;--------------------------------------------------------
                                     19 ; ram data
                                     20 ;--------------------------------------------------------
                                     21 	.area DATA
                                     22 ;--------------------------------------------------------
                                     23 ; ram data
                                     24 ;--------------------------------------------------------
                                     25 	.area INITIALIZED
                                     26 ;--------------------------------------------------------
                                     27 ; Stack segment in internal ram
                                     28 ;--------------------------------------------------------
                                     29 	.area	SSEG
      000008                         30 __start__stack:
      000008                         31 	.ds	1
                                     32 
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
                                     47 ; interrupt vector
                                     48 ;--------------------------------------------------------
                                     49 	.area HOME
      008000                         50 __interrupt_vect:
      008000 82 00 80 43             51 	int s_GSINIT ; reset
      008004 82 00 00 00             52 	int 0x000000 ; trap
      008008 82 00 00 00             53 	int 0x000000 ; int0
      00800C 82 00 00 00             54 	int 0x000000 ; int1
      008010 82 00 00 00             55 	int 0x000000 ; int2
      008014 82 00 00 00             56 	int 0x000000 ; int3
      008018 82 00 00 00             57 	int 0x000000 ; int4
      00801C 82 00 00 00             58 	int 0x000000 ; int5
      008020 82 00 81 EA             59 	int _EXTI_PORTD_IRQHandler ; int6
      008024 82 00 00 00             60 	int 0x000000 ; int7
      008028 82 00 00 00             61 	int 0x000000 ; int8
      00802C 82 00 00 00             62 	int 0x000000 ; int9
      008030 82 00 00 00             63 	int 0x000000 ; int10
      008034 82 00 00 00             64 	int 0x000000 ; int11
      008038 82 00 00 00             65 	int 0x000000 ; int12
      00803C 82 00 83 34             66 	int _TIM2_Update_IRQHandler ; int13
                                     67 ;--------------------------------------------------------
                                     68 ; global & static initialisations
                                     69 ;--------------------------------------------------------
                                     70 	.area HOME
                                     71 	.area GSINIT
                                     72 	.area GSFINAL
                                     73 	.area GSINIT
      008043                         74 __sdcc_init_data:
                                     75 ; stm8_genXINIT() start
      008043 AE 00 00         [ 2]   76 	ldw x, #l_DATA
      008046 27 07            [ 1]   77 	jreq	00002$
      008048                         78 00001$:
      008048 72 4F 00 00      [ 1]   79 	clr (s_DATA - 1, x)
      00804C 5A               [ 2]   80 	decw x
      00804D 26 F9            [ 1]   81 	jrne	00001$
      00804F                         82 00002$:
      00804F AE 00 07         [ 2]   83 	ldw	x, #l_INITIALIZER
      008052 27 09            [ 1]   84 	jreq	00004$
      008054                         85 00003$:
      008054 D6 80 F9         [ 1]   86 	ld	a, (s_INITIALIZER - 1, x)
      008057 D7 00 00         [ 1]   87 	ld	(s_INITIALIZED - 1, x), a
      00805A 5A               [ 2]   88 	decw	x
      00805B 26 F7            [ 1]   89 	jrne	00003$
      00805D                         90 00004$:
                                     91 ; stm8_genXINIT() end
                                     92 	.area GSFINAL
      00805D CC 80 40         [ 2]   93 	jp	__sdcc_program_startup
                                     94 ;--------------------------------------------------------
                                     95 ; Home
                                     96 ;--------------------------------------------------------
                                     97 	.area HOME
                                     98 	.area HOME
      008040                         99 __sdcc_program_startup:
      008040 CC 81 01         [ 2]  100 	jp	_main
                                    101 ;	return from main will return to caller
                                    102 ;--------------------------------------------------------
                                    103 ; code
                                    104 ;--------------------------------------------------------
                                    105 	.area CODE
                                    106 ;	src/main.c: 6: void main(void) {
                                    107 ;	-----------------------------------------
                                    108 ;	 function main
                                    109 ;	-----------------------------------------
      008101                        110 _main:
      008101 52 0C            [ 2]  111 	sub	sp, #12
                                    112 ;	src/main.c: 8: CLK->CKDIVR = 0x00;
      008103 35 00 50 C6      [ 1]  113 	mov	0x50c6+0, #0x00
                                    114 ;	src/main.c: 11: uart_init();
      008107 CD 83 67         [ 4]  115 	call	_uart_init
                                    116 ;	src/main.c: 12: nec_init();
      00810A CD 81 74         [ 4]  117 	call	_nec_init
                                    118 ;	src/main.c: 15: __asm__("rim");
      00810D 9A               [ 1]  119 	rim
                                    120 ;	src/main.c: 18: printf("-------------------------\n");
      00810E AE 80 A6         [ 2]  121 	ldw	x, #(___str_6+0)
      008111 CD 83 92         [ 4]  122 	call	_puts
                                    123 ;	src/main.c: 24: while (1) {
      008114                        124 00110$:
                                    125 ;	src/main.c: 26: if (nec_data_ready()) {
      008114 CD 81 7A         [ 4]  126 	call	_nec_data_ready
      008117 4D               [ 1]  127 	tnz	a
      008118 27 FA            [ 1]  128 	jreq	00110$
                                    129 ;	src/main.c: 29: if (nec_get_data(&ir_code)) {
      00811A 96               [ 1]  130 	ldw	x, sp
      00811B 5C               [ 1]  131 	incw	x
      00811C CD 81 7E         [ 4]  132 	call	_nec_get_data
      00811F 4D               [ 1]  133 	tnz	a
      008120 27 F2            [ 1]  134 	jreq	00110$
                                    135 ;	src/main.c: 32: uint8_t not_address = (ir_code.raw_data >> 16) & 0xFF;
      008122 16 05            [ 2]  136 	ldw	y, (0x05, sp)
      008124 17 09            [ 2]  137 	ldw	(0x09, sp), y
      008126 16 03            [ 2]  138 	ldw	y, (0x03, sp)
      008128 17 07            [ 2]  139 	ldw	(0x07, sp), y
      00812A 7B 08            [ 1]  140 	ld	a, (0x08, sp)
      00812C 6B 0B            [ 1]  141 	ld	(0x0b, sp), a
                                    142 ;	src/main.c: 33: uint8_t not_command = ir_code.raw_data & 0xFF;
      00812E 7B 0A            [ 1]  143 	ld	a, (0x0a, sp)
      008130 6B 0C            [ 1]  144 	ld	(0x0c, sp), a
                                    145 ;	src/main.c: 35: if ((uint8_t)~ir_code.address == not_address && (uint8_t)~ir_code.command == not_command) {
      008132 7B 01            [ 1]  146 	ld	a, (0x01, sp)
      008134 97               [ 1]  147 	ld	xl, a
      008135 43               [ 1]  148 	cpl	a
      008136 11 0B            [ 1]  149 	cp	a, (0x0b, sp)
      008138 26 26            [ 1]  150 	jrne	00102$
      00813A 7B 02            [ 1]  151 	ld	a, (0x02, sp)
      00813C 95               [ 1]  152 	ld	xh, a
      00813D 43               [ 1]  153 	cpl	a
      00813E 11 0C            [ 1]  154 	cp	a, (0x0c, sp)
      008140 26 1E            [ 1]  155 	jrne	00102$
                                    156 ;	src/main.c: 37: ir_code.address, ir_code.command, ir_code.raw_data);
      008142 9E               [ 1]  157 	ld	a, xh
      008143 0F 0B            [ 1]  158 	clr	(0x0b, sp)
      008145 02               [ 1]  159 	rlwa	x
      008146 4F               [ 1]  160 	clr	a
      008147 01               [ 1]  161 	rrwa	x
                                    162 ;	src/main.c: 36: printf("OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX\n", 
      008148 16 09            [ 2]  163 	ldw	y, (0x09, sp)
      00814A 90 89            [ 2]  164 	pushw	y
      00814C 16 09            [ 2]  165 	ldw	y, (0x09, sp)
      00814E 90 89            [ 2]  166 	pushw	y
      008150 88               [ 1]  167 	push	a
      008151 7B 10            [ 1]  168 	ld	a, (0x10, sp)
      008153 88               [ 1]  169 	push	a
      008154 89               [ 2]  170 	pushw	x
      008155 4B 60            [ 1]  171 	push	#<(___str_4+0)
      008157 4B 80            [ 1]  172 	push	#((___str_4+0) >> 8)
      008159 CD 83 C6         [ 4]  173 	call	_printf
      00815C 5B 0A            [ 2]  174 	addw	sp, #10
      00815E 20 B4            [ 2]  175 	jra	00110$
      008160                        176 00102$:
                                    177 ;	src/main.c: 39: printf("Error -> Raw: 0x%08lX\n", ir_code.raw_data);
      008160 1E 09            [ 2]  178 	ldw	x, (0x09, sp)
      008162 89               [ 2]  179 	pushw	x
      008163 1E 09            [ 2]  180 	ldw	x, (0x09, sp)
      008165 89               [ 2]  181 	pushw	x
      008166 4B 8F            [ 1]  182 	push	#<(___str_5+0)
      008168 4B 80            [ 1]  183 	push	#((___str_5+0) >> 8)
      00816A CD 83 C6         [ 4]  184 	call	_printf
      00816D 5B 06            [ 2]  185 	addw	sp, #6
      00816F 20 A3            [ 2]  186 	jra	00110$
                                    187 ;	src/main.c: 44: }
      008171 5B 0C            [ 2]  188 	addw	sp, #12
      008173 81               [ 4]  189 	ret
                                    190 	.area CODE
                                    191 	.area CONST
                                    192 	.area CONST
      008060                        193 ___str_4:
      008060 4F 4B 20 2D 3E 20 41   194 	.ascii "OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX"
             64 64 72 3A 20 30 78
             25 30 32 58 2C 20 43
             6D 64 3A 20 30 78 25
             30 32 58 2C 20 52 61
             77 3A 20 30 78 25 30
             38 6C 58
      00808D 0A                     195 	.db 0x0a
      00808E 00                     196 	.db 0x00
                                    197 	.area CODE
                                    198 	.area CONST
      00808F                        199 ___str_5:
      00808F 45 72 72 6F 72 20 2D   200 	.ascii "Error -> Raw: 0x%08lX"
             3E 20 52 61 77 3A 20
             30 78 25 30 38 6C 58
      0080A4 0A                     201 	.db 0x0a
      0080A5 00                     202 	.db 0x00
                                    203 	.area CODE
                                    204 	.area CONST
      0080A6                        205 ___str_6:
      0080A6 0A                     206 	.db 0x0a
      0080A7 0A                     207 	.db 0x0a
      0080A8 53 54 4D 38 53 20 4D   208 	.ascii "STM8S Modular IR Receiver"
             6F 64 75 6C 61 72 20
             49 52 20 52 65 63 65
             69 76 65 72
      0080C1 0A                     209 	.db 0x0a
      0080C2 2D 2D 2D 2D 2D 2D 2D   210 	.ascii "-------------------------"
             2D 2D 2D 2D 2D 2D 2D
             2D 2D 2D 2D 2D 2D 2D
             2D 2D 2D 2D
      0080DB 00                     211 	.db 0x00
                                    212 	.area CODE
                                    213 	.area INITIALIZER
                                    214 	.area CABS (ABS)
