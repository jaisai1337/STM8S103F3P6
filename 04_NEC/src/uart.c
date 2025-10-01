#include "stm8s103f3p6.h"
#include "uart.h"
#include <stdio.h>

void uart_init(void) {
    // Configure PD5 (TX) as output push-pull
    GPIOD->DDR |= (1 << 5);
    GPIOD->CR1 |= (1 << 5);

    // Set baud rate for 9600 bps @ 16MHz clock
    // Formula: BRR = f_master / baud_rate
    // 16,000,000 / 9600 = 1666.66 -> 1667
    // In hex, 1667 is 0x0683
    USART1->BRR2 = 0x03;
    USART1->BRR1 = 0x68;

    // Enable the transmitter
    USART1->CR2 |= (1 << 3); // TEN: Transmitter Enable
}

// Redirects standard output to the UART1 peripheral
int putchar(int c) {
    // For compatibility with serial terminals, send a carriage return
    // before every newline character.
    if (c == '\n') {
        putchar('\r');
    }

    // Wait until the transmit data register is empty (TXE bit is set)
    while (!(USART1->SR & (1 << 7)));
    
    // Send the character
    USART1->DR = c;
    
    return c;
}

