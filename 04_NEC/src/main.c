#include "stm8s103f3p6.h"
#include <stdio.h>
#include "uart.h"
#include "nec.h"

void main(void) {
    // Set the system clock to the 16MHz internal HSI
    CLK->CKDIVR = 0x00;

    // Initialize peripherals using our new modules
    uart_init();
    nec_init();

    // Enable interrupts globally now that setup is complete
    __asm__("rim");

    printf("\n\nSTM8S Modular IR Receiver\n");
    printf("-------------------------\n");

    // Create a struct to hold the decoded data
    nec_decoded_data_t ir_code;

    // Main application loop
    while (1) {
        // Check if the NEC module has decoded new data
        if (nec_data_ready()) {
            
            // Get the data from the module. This also clears the 'ready' flag.
            if (nec_get_data(&ir_code)) {
                
                // Perform the NEC protocol check (address vs inverted address, command vs inverted command)
                uint8_t not_address = (ir_code.raw_data >> 16) & 0xFF;
                uint8_t not_command = ir_code.raw_data & 0xFF;

                if ((uint8_t)~ir_code.address == not_address && (uint8_t)~ir_code.command == not_command) {
                    printf("OK -> Addr: 0x%02X, Cmd: 0x%02X, Raw: 0x%08lX\n", 
                           ir_code.address, ir_code.command, ir_code.raw_data);
                } else {
                    printf("Error -> Raw: 0x%08lX\n", ir_code.raw_data);
                }
            }
        }
    }
}

