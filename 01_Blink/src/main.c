#include "stm8s103f3p6.h"

/* Simple delay */
void delay(volatile uint32_t count) {
    while(count--) {
        __asm__("nop");
    }
}

int main(void) {
    /* Configure PB5 as output push-pull */
    GPIOB->DDR |= (1 << 5);   // Set PB5 as output
    GPIOB->CR1 |= (1 << 5);   // Push-pull
    GPIOB->CR2 &= ~(1 << 5);  // No fast output

    while (1) {
        GPIOB->ODR ^= (1 << 5);  // Toggle PB5
        delay(50000);            // Simple software delay
    }

}

