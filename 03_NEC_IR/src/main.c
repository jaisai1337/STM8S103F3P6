#include "stm8s103f3p6.h"
#include <stdio.h>
//Working _v1
// -- Configuration --
#define IR_PIN_MASK (1 << 3) // IR sensor connected to PD3

// -- NEC Protocol Timings (in microseconds) --
// These values have tolerances built-in.
#define NEC_START_PULSE_MIN 8000
#define NEC_START_PULSE_MAX 10000
#define NEC_START_SPACE_MIN 4000
#define NEC_START_SPACE_MAX 5000

#define NEC_BIT_PULSE_MIN 400
#define NEC_BIT_PULSE_MAX 700

#define NEC_LOGIC_0_SPACE_MIN 400
#define NEC_LOGIC_0_SPACE_MAX 700
#define NEC_LOGIC_1_SPACE_MIN 1500
#define NEC_LOGIC_1_SPACE_MAX 1800

// -- State machine for IR decoding --
typedef enum {
    STATE_IDLE,
    STATE_START_PULSE,
    STATE_START_SPACE,
    STATE_BIT_PULSE,
    STATE_BIT_SPACE
} IR_State;

// -- Volatile global variables for ISR --
volatile IR_State ir_state = STATE_IDLE;
volatile uint32_t ir_data = 0;
volatile uint8_t ir_bit_count = 0;
volatile uint8_t ir_data_ready = 0;

/* ---------------- USART1 Initialization (from your code) ---------------- */
void USART1_Init(void) {
    GPIOD->DDR |= (1 << 5);  // Set PD5 as output
    GPIOD->CR1 |= (1 << 5);  // Push-pull

    // Baudrate 9600 @ 16MHz CPU
    USART1->BRR2 = 0x03;
    USART1->BRR1 = 0x68;

    USART1->CR2 |= (1 << 3);  // TEN: Enable TX
}

/* ---------------- Redirect printf (from your code) ---------------- */
int putchar(int c) {
    if (c == '\n') putchar('\r');
    while (!(USART1->SR & (1 << 7))); // Wait for TXE
    USART1->DR = c;
    return c;
}

/* ---------------- Timer 2 Initialization for 1us ticks ---------------- */
void TIM2_Init(void) {
    // Enable TIM2 clock
    CLK->PCKENR1 |= (1 << 5);

    // Set prescaler to 16 (16MHz / 16 = 1MHz timer clock -> 1us tick)
    TIM2->PSCR = 0x04; // 2^4 = 16

    // Enable Update Interrupt for detecting timeouts
    TIM2->IER |= (1 << 0);
}

/* ---------------- GPIO & EXTI Initialization for IR Pin ---------------- */
void IR_GPIO_Init(void) {
    // Configure PD3 as input with pull-up and interrupt
    GPIOD->DDR &= ~IR_PIN_MASK; // Input
    GPIOD->CR1 |= IR_PIN_MASK;  // Pull-up enabled
    GPIOD->CR2 |= IR_PIN_MASK;  // Interrupt enabled

    // Set EXTI for Port D to falling edge only to start
    EXTI->CR1 = (2 << 6); // 10 = Falling edge only for Port D
}

/* ---------------- Interrupt Handler for Port D (PD3) ---------------- */
void EXTI_PORTD_IRQHandler(void) __interrupt(6) {
    
    // Read timer value and reset it immediately for accuracy
    uint16_t pulse_width = (TIM2->CNTRH << 8) | TIM2->CNTRL;
    TIM2->CNTRH = 0;
    TIM2->CNTRL = 0;

    switch (ir_state) {
        case STATE_IDLE:
            // This is the first falling edge. Start the process.
            TIM2->CR1 |= (1 << 0); // Start timer
            ir_state = STATE_START_PULSE;
            // Set EXTI to trigger on both rising and falling edges now
            EXTI->CR1 = (3 << 6); // 11 = Rising and falling for Port D
            break;

        case STATE_START_PULSE:
            // We just finished the ~9ms low start pulse.
            if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
                ir_state = STATE_START_SPACE;
            } else {
                ir_state = STATE_IDLE; // Error, reset
            }
            break;

        case STATE_START_SPACE:
            // We just finished the ~4.5ms high start space.
            if (pulse_width > NEC_START_SPACE_MIN && pulse_width < NEC_START_SPACE_MAX) {
                ir_state = STATE_BIT_PULSE;
                ir_bit_count = 0;
                ir_data = 0;
            } else {
                ir_state = STATE_IDLE; // Error, reset
            }
            break;

        case STATE_BIT_PULSE:
            // We just finished a ~562.5us low bit pulse.
            if (pulse_width > NEC_BIT_PULSE_MIN && pulse_width < NEC_BIT_PULSE_MAX) {
                ir_state = STATE_BIT_SPACE;
            } else {
                ir_state = STATE_IDLE; // Error, reset
            }
            break;

        case STATE_BIT_SPACE:
            // This is where we decode the bit based on the high pulse width
            ir_data >>= 1; // Shift right to make space for the new bit (MSB first)
            
            if (pulse_width > NEC_LOGIC_1_SPACE_MIN && pulse_width < NEC_LOGIC_1_SPACE_MAX) {
                ir_data |= 0x80000000; // It's a '1'
            } else if (pulse_width > NEC_LOGIC_0_SPACE_MIN && pulse_width < NEC_LOGIC_0_SPACE_MAX) {
                // It's a '0', do nothing as the bit is already 0
            } else {
                ir_state = STATE_IDLE; // Pulse width error
                break;
            }

            ir_bit_count++;
            if (ir_bit_count == 32) {
                // We have a full code!
                ir_data_ready = 1;
                ir_state = STATE_IDLE;
                TIM2->CR1 &= ~(1 << 0); // Stop timer
                EXTI->CR1 = (2 << 6);  // Reset EXTI back to falling edge only
            } else {
                ir_state = STATE_BIT_PULSE; // Ready for the next bit pulse
            }
            break;
    }
}

/* ---------------- Interrupt Handler for TIM2 Update/Overflow ---------------- */
void TIM2_Update_IRQHandler(void) __interrupt(13) {
    if (TIM2->SR1 & (1 << 0)) { // Check if it's an update interrupt
        // This acts as a timeout. If it fires, the IR signal was interrupted.
        ir_state = STATE_IDLE;
        TIM2->CR1 &= ~(1 << 0); // Stop timer
        EXTI->CR1 = (2 << 6);  // Reset EXTI back to falling edge only
        TIM2->SR1 &= ~(1 << 0); // Clear the interrupt flag
    }
}

/* ---------------- Main Program ---------------- */
void main(void) {
    // Set clock to 16MHz internal HSI
    CLK->CKDIVR = 0x00;

    // Initialize peripherals
    USART1_Init();
    IR_GPIO_Init();
    TIM2_Init();

    // Enable interrupts globally
    __asm__("rim");

    printf("\n\nSTM8S IR Receiver Ready\n");

    while (1) {
        if (ir_data_ready) {
            
            // The received data is LSB first, but we shifted in MSB first.
            // Let's reverse the final 32-bit value.
            uint32_t temp = ir_data;
            uint32_t reversed_data = 0;
            for(int i = 0; i < 32; i++) {
                if((temp >> i) & 1) {
                    reversed_data |= (1UL << (31-i));
                }
            }

            uint8_t address = (reversed_data >> 24) & 0xFF;
            uint8_t not_address = (reversed_data >> 16) & 0xFF;
            uint8_t command = (reversed_data >> 8) & 0xFF;
            uint8_t not_command = reversed_data & 0xFF;

            // Check if the inverted bytes match, a simple error check
            if ((uint8_t)~address == not_address && (uint8_t)~command == not_command) {
                 printf("OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX\n", address, command, reversed_data);
            } else {
                 printf("Error -> Raw: 0x%08lX\n", reversed_data);
            }
           
            ir_data_ready = 0; // Clear the flag
        }
    }
}
