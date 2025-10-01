#include "stm8s103f3p6.h"
#include <stdio.h>

/* ---------------- Simple delay ---------------- */
void delay(volatile uint32_t count) {
        while(count--) __asm__("nop");
}

/* ---------------- USART1 Initialization ---------------- */
void USART1_Init(void) {

    // Enable USART1 clock if needed (STM8S103S runs USART1 always)
    
    /* Configure PD5 as TX output push-pull */
    GPIOD->DDR |= (1 << 5);  // Set PD5 as output
    GPIOD->CR1 |= (1 << 5);  // Push-pull
    GPIOD->CR2 &= ~(1 << 5); // No interrupt, no fast output

    /* Configure USART1 */
    //USART1->BRR2 = 0x00;  // Example for 9600 bps @ 2 MHz
    //USART1->BRR1 = 0x0D;  // Adjust according to clock
   

    USART1->BRR2 = 0x03;  // Example for 9600 bps @ 16 MHz
    USART1->BRR1 = 0x68;

    USART1->CR1 = 0x00;  
    USART1->CR2 |= (1 << 3);  // TEN: Enable TX
}

/* ---------------- Redirect printf ---------------- */
int putchar(int c) {
    if (c == '\n') putchar('\r');  // Add carriage return for terminals
    while (!(USART1->SR & (1 << 7)));  // Wait until TXE (Transmit Data Register Empty)
    USART1->DR = c;
    return c;
}
/* ---------------- Main ---------------- */
void main(void) {
    CLK->CKDIVR = 0x00; // for make it run on 16 MHz or else it will run on 2 MHz  brr2 = 0x00 ; brr1 = 0x0d; 
    USART1_Init();

    while (1) {
        printf("Hello STM8!\n");
        delay(500000);
    }
}

