#include "stm8s103f3p6.h"


void delay_ms(uint16_t ms)
{
    for (uint16_t i = 0; i < ms; i++)
    {
        for (uint16_t j = 0; j < 1600; j++)
        {
            __asm__("nop"); // No operation - just wastes a clock cycle
        }
    }
}
void EXTI_PORTB_IRQHandler(void) __interrupt(4)
{
    // Toggle the LED on PC5
    GPIOC->ODR ^= (1 << 5); 
    delay_ms(50);
}

void main(void)
{
    __asm__("sim");

    // --- Configure LED on PC5 as output ---
    GPIOC->DDR |= (1 << 5);   // Set PC5 as output
    GPIOC->CR1 |= (1 << 5);   // Set PC5 as push-pull
    GPIOC->ODR &= ~(1 << 5);  // Start with the LED off

    // --- Configure Button on PB4 as input with interrupt ---
    GPIOB->DDR &= ~(1 << 4);  // Set PB4 as input
    GPIOB->CR1 |= (1 << 4);   // Enable the internal pull-up resistor
    GPIOB->CR2 |= (1 << 4);   // **FIX:** Enable external interrupt for pin PB4

    EXTI->CR1 = (2 << 2); 
    EXTI->CR2 = 0;
    // Enable interrupts globally now that setup is complete
    __asm__("rim"); 

    // --- Main Loop ---
    while (1)
    {
        // Put the MCU in a low-power "Wait For Interrupt" mode.
        // The program will halt here until the button is pressed.
        __asm__("wfi");
    }
}
