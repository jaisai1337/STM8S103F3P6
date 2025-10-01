#ifndef UART_H
#define UART_H

/**
 * @brief Initializes UART1 for a 9600 baud rate at a 16MHz CPU clock.
 * Configures PD5 as the TX pin.
 */
void uart_init(void);

/**
 * @brief Redirects character output to UART1. Required for printf.
 * @param c The character to send.
 * @return The character that was sent.
 */
int putchar(int c);

#endif // UART_H

