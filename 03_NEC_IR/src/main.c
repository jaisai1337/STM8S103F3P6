#include "stm8s103f3p6.h"
#include <stdio.h>

// -- Configuration and Timings (No changes here) --
#define IR_PIN_MASK (1 << 3)
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

typedef enum {
    STATE_IDLE,
    STATE_START_PULSE,
    STATE_START_SPACE,
    STATE_BIT_PULSE,
    STATE_BIT_SPACE
} IR_State;

volatile IR_State ir_state = STATE_IDLE;
volatile uint32_t ir_data = 0;
volatile uint8_t ir_bit_count = 0;
volatile uint8_t ir_data_ready = 0;

// -- Peripheral Inits (No changes here) --
void USART1_Init(void) {
    GPIOD->DDR |= (1 << 5);
    GPIOD->CR1 |= (1 << 5);
    USART1->BRR2 = 0x03;
    USART1->BRR1 = 0x68;
    USART1->CR2 |= (1 << 3);
}

int putchar(int c) {
    if (c == '\n') putchar('\r');
    while (!(USART1->SR & (1 << 7)));
    USART1->DR = c;
    return c;
}

void TIM2_Init(void) {
    CLK->PCKENR1 |= (1 << 5);
    TIM2->PSCR = 0x04;
    TIM2->IER |= (1 << 0);
}

void IR_GPIO_Init(void) {
    GPIOD->DDR &= ~IR_PIN_MASK;
    GPIOD->CR1 |= IR_PIN_MASK;
    GPIOD->CR2 |= IR_PIN_MASK;
    EXTI->CR1 = (2 << 6);
}

// -- Interrupt Handlers --
void EXTI_PORTD_IRQHandler(void) __interrupt(6) {
    uint16_t pulse_width = (TIM2->CNTRH << 8) | TIM2->CNTRL;
    TIM2->CNTRH = 0;
    TIM2->CNTRL = 0;

    switch (ir_state) {
        // ... (No changes in the first few states)
        case STATE_IDLE:
            TIM2->CR1 |= (1 << 0);
            ir_state = STATE_START_PULSE;
            EXTI->CR1 = (3 << 6);
            break;
        case STATE_START_PULSE:
            if (pulse_width > NEC_START_PULSE_MIN && pulse_width < NEC_START_PULSE_MAX) {
                ir_state = STATE_START_SPACE;
            } else { ir_state = STATE_IDLE; }
            break;
        case STATE_START_SPACE:
            if (pulse_width > NEC_START_SPACE_MIN && pulse_width < NEC_START_SPACE_MAX) {
                ir_state = STATE_BIT_PULSE;
                ir_bit_count = 0;
                ir_data = 0;
            } else { ir_state = STATE_IDLE; }
            break;
        case STATE_BIT_PULSE:
            if (pulse_width > NEC_BIT_PULSE_MIN && pulse_width < NEC_BIT_PULSE_MAX) {
                ir_state = STATE_BIT_SPACE;
            } else { ir_state = STATE_IDLE; }
            break;

        case STATE_BIT_SPACE:
            // This is where we decode the bit based on the high pulse width
            
            // #################### CHANGE #1: FIX BIT ORDER ####################
            // Shift LEFT. This treats the first bit received as the LSB.
            ir_data <<= 1;
            
            if (pulse_width > NEC_LOGIC_1_SPACE_MIN && pulse_width < NEC_LOGIC_1_SPACE_MAX) {
                ir_data |= 1; // It's a '1', so set the new LSB
            } // No need for an else, the bit is already 0 from the shift
            else if (!(pulse_width > NEC_LOGIC_0_SPACE_MIN && pulse_width < NEC_LOGIC_0_SPACE_MAX)) {
                ir_state = STATE_IDLE; // Pulse width error
                break;
            }

            ir_bit_count++;
            if (ir_bit_count == 32) {
                ir_data_ready = 1;
                ir_state = STATE_IDLE;
                TIM2->CR1 &= ~(1 << 0);
                EXTI->CR1 = (2 << 6);
            } else {
                ir_state = STATE_BIT_PULSE;
            }
            break;
    }
}

void TIM2_Update_IRQHandler(void) __interrupt(13) {
    if (TIM2->SR1 & (1 << 0)) {
        ir_state = STATE_IDLE;
        TIM2->CR1 &= ~(1 << 0);
        EXTI->CR1 = (2 << 6);
        TIM2->SR1 &= ~(1 << 0);
    }
}

/* ---------------- Main Program ---------------- */
void main(void) {
    CLK->CKDIVR = 0x00;
    USART1_Init();
    IR_GPIO_Init();
    TIM2_Init();
    __asm__("rim");

    printf("\n\nSTM8S IR Receiver Ready (Fixed)\n");

    while (1) {
        if (ir_data_ready) {
            
            // #################### CHANGE #2: REMOVE REVERSING LOOP ####################
            // The data is now in the correct order, so we can use it directly.

            uint8_t address = (ir_data >> 24) & 0xFF;
            uint8_t not_address = (ir_data >> 16) & 0xFF;
            uint8_t command = (ir_data >> 8) & 0xFF;
            uint8_t not_command = ir_data & 0xFF;

            if ((uint8_t)~address == not_address && (uint8_t)~command == not_command) {
                 printf("OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX\n", address, command, ir_data);
            } else {
                 printf("Error -> Raw: 0x%08lX\n", ir_data);
            }
            
            ir_data_ready = 0; // Clear the flag
        }
    }
}
