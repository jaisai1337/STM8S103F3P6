#ifndef NEC_H
#define NEC_H

#include <stdint.h> // For uint8_t, uint32_t

/**
 * @brief Structure to hold the decoded NEC data.
 */
typedef struct {
    uint8_t address;
    uint8_t command;
    uint32_t raw_data;
} nec_decoded_data_t;

/**
 * @brief Initializes GPIO (PD3), Timer2, and External Interrupts for NEC decoding.
 */
void nec_init(void);

/**
 * @brief Checks if a new NEC code has been successfully decoded.
 * @return 1 if new data is ready, 0 otherwise.
 */
uint8_t nec_data_ready(void);

/**
 * @brief Gets the decoded data and clears the data ready flag.
 * @param data Pointer to a struct where the decoded data will be stored.
 * @return 1 on success (if data was ready), 0 otherwise.
 */
uint8_t nec_get_data(nec_decoded_data_t *data);

#endif // NEC_H


