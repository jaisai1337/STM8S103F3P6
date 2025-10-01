#include "stm8s103f3p6.h"
#include "nec.h"
#include <stdio.h> // For putchar debugging

// -- Pin Configuration --
#define IR_PORT GPIOD
#define IR_PIN_MASK (1 << 3) // IR sensor connected to PD3

// -- NEC Protocol Timings (in microseconds) with WIDER tolerance --
#define NEC_START_PULSE_MIN 7500  // Was 8000
#define NEC_START_PULSE_MAX 10500 // Was 10000
#define NEC_START_SPACE_MIN 3500  // Was 4000
#define NEC_START_SPACE_MAX 5500  // Was 5000

#define NEC_BIT_PULSE_MIN 350   // Was 400
#define NEC_BIT_PULSE_MAX 800   // Was 700

#define NEC_LOGIC_0_SPACE_MIN 350   // Was 400
#define NEC_LOGIC_0_SPACE_MAX 800   // Was 700
#define NEC_LOGIC_1_SPACE_MIN 1400  // Was 1500
#define NEC_LOGIC_1_SPACE_MAX 1900  // Was 1800

// Internal state machine for decoding
typedef enum {
    STATE_IDLE,
    STATE_START_PULSE,
    STATE_START_SPACE,
    STATE_BIT_PULSE,
    STATE_BIT_SPACE
} ir_state_t;

// Module-level variables, hidden from other files (static)
static volatile ir_state_t ir_state = STATE_IDLE;
static volatile uint32_t ir_data = 0;
static volatile uint8_t ir_bit_count = 0;
static volatile uint8_t ir_data_ready_flag = 0;

// -- Prototypes for private functions --
static void tim2_init(void);
static void ir_gpio_init(void);

// -- Public Functions --

void nec_init(void) {
    ir_gpio_init();
    tim2_init();
}

uint8_t nec_data_ready(void) {
    return ir_data_ready_flag;
}

uint8_t nec_get_data(nec_decoded_data_t *data) {
    if (!ir_data_ready_flag) {
        return 0; // No new data available
    }
    
    __asm__("sim"); // Disable interrupts to safely copy data
    data->raw_data = ir_data;
    ir_data_ready_flag = 0; // Clear the flag
    __asm__("rim"); // Re-enable interrupts

    // Extract address and command from the raw data
    data->address = (data->raw_data >> 24) & 0xFF;
    data->command = (data->raw_data >> 8) & 0xFF;

    return 1; // Indicate success
}

// -- Private Initialization Functions --

static void tim2_init(void) {
    CLK->PCKENR1 |= (1 << 5); // Enable TIM2 clock
    TIM2->PSCR = 0x04;        // Prescaler = 16 (16MHz/16 -> 1us tick)
    TIM2->IER |= (1 << 0);    // Enable Update Interrupt for timeouts
}

static void ir_gpio_init(void) {
    IR_PORT->DDR &= ~IR_PIN_MASK; // Set as input
    IR_PORT->CR1 |= IR_PIN_MASK;  // Enable pull-up resistor
    IR_PORT->CR2 |= IR_PIN_MASK;  // Enable external interrupt for the pin

    // Configure EXTI to trigger on falling edge only to start
    EXTI->CR1 &= ~(3 << 6); // Clear bits 7 and 6
    EXTI->CR1 |= (2 << 6);  // Set bits for falling edge
}

// -- Interrupt Service Routines --

void EXTI_PORTD_IRQHandler(void) __interrupt(6) {
    uint16_t pulse_width = (TIM2->CNTRH << 8) | TIM2->CNTRL;
    TIM2->CNTRH = 0;
    TIM2->CNTRL = 0;

    switch (ir_state) {
        case STATE_IDLE:
            TIM2->CR1 |= (1 << 0);      // Start timer
            ir_state = STATE_START_PULSE;
            EXTI->CR1 &= ~(3 << 6);       // Clear bits
            EXTI->CR1 |= (3 << 6);        // Reconfigure to trigger on both edges
            break;

        case STATE_START_PULSE:
            if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
                ir_state = STATE_START_SPACE;
            } else {
                ir_state = STATE_IDLE;
                printf("E1 "); // Error: Bad start pulse timing
            }
            break;

        case STATE_START_SPACE:
            if (pulse_width > NEC_START_SPACE_MIN && pulse_width < NEC_START_SPACE_MAX) {
                ir_state = STATE_BIT_PULSE;
                ir_bit_count = 0;
                ir_data = 0;
            } else {
                ir_state = STATE_IDLE;
                printf("E2 "); // Error: Bad start space timing
            }
            break;

        case STATE_BIT_PULSE:
            if (pulse_width > NEC_BIT_PULSE_MIN && pulse_width < NEC_BIT_PULSE_MAX) {
                ir_state = STATE_BIT_SPACE;
            } else {
                ir_state = STATE_IDLE;
                printf("E3 "); // Error: Bad bit pulse timing
            }
            break;

        case STATE_BIT_SPACE:
            ir_data <<= 1; // Shift left to make room for the new bit (LSB first)
            if (pulse_width > NEC_LOGIC_1_SPACE_MIN && pulse_width < NEC_LOGIC_1_SPACE_MAX) {
                ir_data |= 1; // It's a '1'
            } else if (!(pulse_width > NEC_LOGIC_0_SPACE_MIN && pulse_width < NEC_LOGIC_0_SPACE_MAX)) {
                ir_state = STATE_IDLE; // Pulse width error
                printf("E4 "); // Error: Bad bit space timing
                break;
            }
            ir_bit_count++;
            if (ir_bit_count == 32) {
                ir_data_ready_flag = 1; // Set flag for main loop
                ir_state = STATE_IDLE;
                TIM2->CR1 &= ~(1 << 0); // Stop timer
                EXTI->CR1 &= ~(3 << 6);   // Clear bits
                EXTI->CR1 |= (2 << 6);    // Reset EXTI to falling edge only
            } else {
                ir_state = STATE_BIT_PULSE;
            }
            break;
    }
}

void TIM2_Update_IRQHandler(void) __interrupt(13) {
    if (TIM2->SR1 & (1 << 0)) { // Check for update interrupt flag
        if(ir_state != STATE_IDLE) {
            // Only reset if we were in the middle of a transmission
            ir_state = STATE_IDLE;
            printf("T "); // Timed out
        }
        TIM2->CR1 &= ~(1 << 0); // Stop timer
        EXTI->CR1 &= ~(3 << 6);   // Clear bits
        EXTI->CR1 |= (2 << 6);    // Reset EXTI to falling edge only
        TIM2->SR1 &= ~(1 << 0); // Clear the interrupt flag
    }
}


