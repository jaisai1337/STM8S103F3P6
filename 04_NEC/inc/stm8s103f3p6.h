#ifndef __STM8S103F3P6_H
#define __STM8S103F3P6_H

#include <stdint.h>

#ifndef __IO
#define __IO volatile
#endif

/* ========================================================= */
/* ================ PERIPHERAL MEMORY MAP ================== */
/* ========================================================= */
#define GPIOA_BASE     0x5000
#define GPIOB_BASE     0x5005
#define GPIOC_BASE     0x500A
#define GPIOD_BASE     0x500F
#define GPIOE_BASE     0x5014
#define GPIOF_BASE     0x5019

#define FLASH_BASE     0x505A
#define EXTI_BASE      0x50A0
#define RST_BASE       0x50B3
#define CLK_BASE       0x50C0
#define WWDG_BASE      0x50D1
#define IWDG_BASE      0x50E0
#define AWU_BASE       0x50F0
#define BEEP_BASE      0x50F3


#define SPI_BASE       0x5200
#define I2C_BASE       0x5210
#define USART1_BASE    0x5230

#define TIM1_BASE      0x5250
#define TIM2_BASE      0x5300
#define TIM4_BASE      0x5340

#define ADC1_BASE      0x53E0
#define CPU_BASE       0x7F00
#define ITC_BASE       0x7F70


/* ========================================================= */
/* ============ PERIPHERAL STRUCTURE DEFINITIONS =========== */
/* ========================================================= */

/* ---------------- GPIO ---------------- */
typedef struct {
  __IO uint8_t ODR; /*!< 0x00: Output Data Register */
  __IO uint8_t IDR; /*!< 0x01: Input Data Register */
  __IO uint8_t DDR; /*!< 0x02: Data Direction Register (1=output, 0=input) */
  __IO uint8_t CR1; /*!< 0x03: Control Register 1 (push-pull/open-drain, pull-up) */
  __IO uint8_t CR2; /*!< 0x04: Control Register 2 (interrupt/trig speed for output) */
} GPIO_TypeDef;

/* ---------------- FLASH ---------------- */
typedef struct {
  __IO uint8_t CR1;   /*!< 0x00: FLASH control register 1 (program/erase) */
  __IO uint8_t CR2;   /*!< 0x01: FLASH control register 2 (wait states, flags) */
  __IO uint8_t NCR2;  /*!< 0x02: Non-volatile control 2 */
  __IO uint8_t FPR;   /*!< 0x03: FLASH protection register */
  __IO uint8_t NFPR;  /*!< 0x04: Non-volatile FLASH protection register */
  __IO uint8_t IAPSR; /*!< 0x05: In-application programming status register */
  uint8_t RESERVED1[2]; /*!< 0x06-0x07: Reserved */
  __IO uint8_t PUKR;  /*!< 0x08: FLASH program memory unprotect key register */
  uint8_t RESERVED2[1]; /*!< 0x09: Reserved */
  __IO uint8_t DUKR;  /*!< 0x010: Data EEPROM unprotect key register */
} FLASH_TypeDef;

/* ---------------- EXTI ---------------- */
typedef struct {
  __IO uint8_t CR1; /*!< 0x00: EXTI control register 1 (enable/disable interrupts) */
  __IO uint8_t CR2; /*!< 0x01: EXTI control register 2 (edge trigger) */
} EXTI_TypeDef;

/* ---------------- RST ---------------- */
typedef struct {
  __IO uint8_t SR; /*!< 0x00: Reset status register (POR, IWDG, SW reset flags) */
} RST_TypeDef;

/* ---------------- CLK ---------------- */
typedef struct {
  __IO uint8_t ICKR;      /*!< 0x00: Internal clock control register */
  __IO uint8_t ECKR;      /*!< 0x01: External clock control register */
  uint8_t RESERVED[1];       /*!< 0x02: Reserved */
  __IO uint8_t CMSR;      /*!< 0x03: Clock master status register */
  __IO uint8_t SWR;       /*!< 0x04: Clock switch register */
  __IO uint8_t SWCR;      /*!< 0x05: Clock switch control register */
  __IO uint8_t CKDIVR;    /*!< 0x06: Clock divider register */
  __IO uint8_t PCKENR1;   /*!< 0x07: Peripheral clock gating register 1 */
  __IO uint8_t CSSR;      /*!< 0x08: Clock security system register */
  __IO uint8_t CCOR;      /*!< 0x09: Configurable clock control register */
  __IO uint8_t PCKENR2;   /*!< 0x0A: Peripheral clock gating register 2 */
  uint8_t RESERVED2[1];   /*!< 0x0B: Reserved */
  __IO uint8_t HSITRIMR;  /*!< 0x0C: HSI trimming register */
  __IO uint8_t SWIMCCR;   /*!< 0x0D: SWIM clock control register */
} CLK_TypeDef;

/* ---------------- WWDG ---------------- */
typedef struct {
  __IO uint8_t CR; /*!< 0x00: Window watchdog control register */
  __IO uint8_t WR; /*!< 0x01: Window register */
} WWDG_TypeDef;

/* ---------------- IWDG ---------------- */
typedef struct {
  __IO uint8_t KR;  /*!< 0x00: Key register */
  __IO uint8_t PR;  /*!< 0x01: Prescaler register */
  __IO uint8_t RLR; /*!< 0x02: Reload register */
} IWDG_TypeDef;

/* ---------------- AWU (Auto Wake-Up) ---------------- */
typedef struct {
    __IO uint8_t CSR1;  /*!< 0x00: AWU control/status register 1 */
    __IO uint8_t APR;   /*!< 0x01: AWU asynchronous prescaler buffer register */
    __IO uint8_t TBR;   /*!< 0x02: AWU timebase selection register */
} AWU_TypeDef;

/* ---------------- BEEP ---------------- */
typedef struct {
    __IO uint8_t CSR;   /*!< 0x00: BEEP control/status register */
} BEEP_TypeDef;

/* ---------------- SPI ---------------- */
typedef struct {
  __IO uint8_t CR1;    /*!< 0x00: Control register 1 */
  __IO uint8_t CR2;    /*!< 0x01: Control register 2 */
  __IO uint8_t ICR;    /*!< 0x02: Interrupt control register */
  __IO uint8_t SR;     /*!< 0x03: Status register */
  __IO uint8_t DR;     /*!< 0x04: Data register */
  __IO uint8_t CRCPR;  /*!< 0x05: CRC polynomial register */
  __IO uint8_t RXCRCR; /*!< 0x06: RX CRC register */
  __IO uint8_t TXCRCR; /*!< 0x07: TX CRC register */
} SPI_TypeDef;

/* ---------------- I2C ---------------- */
typedef struct {
  __IO uint8_t CR1;    /*!< 0x00: Control register 1 */
  __IO uint8_t CR2;    /*!< 0x01: Control register 2 */
  __IO uint8_t FREQR;  /*!< 0x02: Frequency register */
  __IO uint8_t OARL;   /*!< 0x03: Own address low */
  __IO uint8_t OARH;   /*!< 0x04: Own address high */
  __IO uint8_t DR;     /*!< 0x06: Data register */
  __IO uint8_t SR1;    /*!< 0x07: Status register 1 */
  __IO uint8_t SR2;    /*!< 0x08: Status register 2 */
  __IO uint8_t SR3;    /*!< 0x09: Status register 3 */
  __IO uint8_t ITR;    /*!< 0x0A: Interrupt register */
  __IO uint8_t CCRL;   /*!< 0x0B: Clock control low */
  __IO uint8_t CCRH;   /*!< 0x0C: Clock control high */
  __IO uint8_t TRISER; /*!< 0x0D: TRISE register */
  __IO uint8_t PECR;   /*!< 0x0E: I2C packet error checking resister */ 
} I2C_TypeDef;

/* ---------------- UART1 ---------------- */
typedef struct {
  __IO uint8_t SR;    /*!< 0x00: Status register */
  __IO uint8_t DR;    /*!< 0x01: Data register */
  __IO uint8_t BRR1;  /*!< 0x02: Baud rate register 1 */
  __IO uint8_t BRR2;  /*!< 0x03: Baud rate register 2 */
  __IO uint8_t CR1;   /*!< 0x04: Control register 1 */
  __IO uint8_t CR2;   /*!< 0x05: Control register 2 */
  __IO uint8_t CR3;   /*!< 0x06: Control register 3 */
  __IO uint8_t CR4;   /*!< 0x07: Control register 4 */
  __IO uint8_t CR5;   /*!< 0x08: Control register 5 */
  __IO uint8_t GTR;   /*!< 0x09: Guard time register */
  __IO uint8_t PSCR;  /*!< 0x0A: Prescaler register */
} USART1_TypeDef;

/* ---------------- TIM1 ---------------- */
typedef struct {
  __IO uint8_t CR1;    /*!< 0x00: Control register 1 */
  __IO uint8_t CR2;    /*!< 0x01: Control register 2 */
  __IO uint8_t SMCR;   /*!< 0x02: Slave mode control register */
  __IO uint8_t ETR;    /*!< 0x03: External trigger register */
  __IO uint8_t IER;    /*!< 0x04: Interrupt enable register */
  __IO uint8_t SR1;    /*!< 0x05: Status register 1 */
  __IO uint8_t SR2;    /*!< 0x06: Status register 2 */
  __IO uint8_t EGR;    /*!< 0x07: Event generation register */
  __IO uint8_t CCMR1;  /*!< 0x08: Capture/compare mode register 1 */
  __IO uint8_t CCMR2;  /*!< 0x09: Capture/compare mode register 2 */
  __IO uint8_t CCMR3;  /*!< 0x0A: Capture/compare mode register 3 */
  __IO uint8_t CCMR4;  /*!< 0x0B: Capture/compare mode register 4 */
  __IO uint8_t CCER1;  /*!< 0x0C: Capture/compare enable register 1 */
  __IO uint8_t CCER2;  /*!< 0x0D: Capture/compare enable register 2 */
  __IO uint8_t CNTRH;  /*!< 0x0E: Counter high */
  __IO uint8_t CNTRL;  /*!< 0x0F: Counter low */
  __IO uint8_t PSCRH;  /*!< 0x10: Prescaler high */
  __IO uint8_t PSCRL;  /*!< 0x11: Prescaler low */
  __IO uint8_t ARRH;   /*!< 0x12: Auto-reload high */
  __IO uint8_t ARRL;   /*!< 0x13: Auto-reload low */
  __IO uint8_t RCR;    /*!< 0x14: Repetition counter */
  __IO uint8_t CCR1H;  /*!< 0x15: Capture/compare 1 high */
  __IO uint8_t CCR1L;  /*!< 0x16: Capture/compare 1 low */
  __IO uint8_t CCR2H;  /*!< 0x17: Capture/compare 2 high */
  __IO uint8_t CCR2L;  /*!< 0x18: Capture/compare 2 low */
  __IO uint8_t CCR3H;  /*!< 0x19: Capture/compare 3 high */
  __IO uint8_t CCR3L;  /*!< 0x1A: Capture/compare 3 low */
  __IO uint8_t CCR4H;  /*!< 0x1B: Capture/compare 4 high */
  __IO uint8_t CCR4L;  /*!< 0x1C: Capture/compare 4 low */
  __IO uint8_t BKR;    /*!< 0x1D: Break register */
  __IO uint8_t DTR;    /*!< 0x1E: Dead-time register */
  __IO uint8_t OISR;   /*!< 0x1F: Output idle state register */
} TIM1_TypeDef;

/* ---------------- TIM2 ---------------- */
typedef struct {
  __IO uint8_t CR1;      /*!< 0x00: Control register 1 */
  uint8_t RESERVED[2];   /*!< 0x01-0x02: Reserved */
  __IO uint8_t IER;      /*!< 0x03: Interrupt enable register */
  __IO uint8_t SR1;      /*!< 0x04: Status register 1 */
  __IO uint8_t SR2;      /*!< 0x05: Status register 2 */
  __IO uint8_t EGR;      /*!< 0x06: Event generation register */
  __IO uint8_t CCMR1;    /*!< 0x07: Capture/compare mode register 1 */
  __IO uint8_t CCMR2;    /*!< 0x08: Capture/compare mode register 2 */
  __IO uint8_t CCMR3;    /*!< 0x09: Capture/compare mode register 3 */
  __IO uint8_t CCER1;    /*!< 0x0A: Capture/compare enable register 1 */
  __IO uint8_t CCER2;    /*!< 0x0B: Capture/compare enable register 2 */
  __IO uint8_t CNTRH;    /*!< 0x0C: Counter high */
  __IO uint8_t CNTRL;    /*!< 0x0D: Counter low */
  __IO uint8_t PSCR;     /*!< 0x0E: Prescaler */
  __IO uint8_t ARRH;     /*!< 0x0F: Auto-reload high */
  __IO uint8_t ARRL;     /*!< 0x10: Auto-reload low */
  __IO uint8_t CCR1H;    /*!< 0x11: Capture/compare 1 high */
  __IO uint8_t CCR1L;    /*!< 0x12: Capture/compare 1 low */
  __IO uint8_t CCR2H;    /*!< 0x13: Capture/compare 2 high */
  __IO uint8_t CCR2L;    /*!< 0x14: Capture/compare 2 low */
  __IO uint8_t CCR3H;    /*!< 0x15: Capture/compare 3 high */
  __IO uint8_t CCR3L;    /*!< 0x16: Capture/compare 3 low */
} TIM2_TypeDef;

/* ---------------- TIM4 ---------------- */
typedef struct {
  __IO uint8_t CR1;    /*!< 0x00: Control register 1 */
  uint8_t RESERVED[2];   /*!< 0x01-0x02: Reserved */
  __IO uint8_t IER;    /*!< 0x03: Interrupt enable register */
  __IO uint8_t SR;     /*!< 0x04: Status register */
  __IO uint8_t EGR;    /*!< 0x05: Event generation register */
  __IO uint8_t CNTR;   /*!< 0x06: Counter */
  __IO uint8_t PSCR;   /*!< 0x07: Prescaler */
  __IO uint8_t ARR;    /*!< 0x08: Auto-reload register */
} TIM4_TypeDef;

/* ---------------- ADC1 ---------------- */
typedef struct {
  __IO uint8_t DBxR[4];    /*!< 0x00-0x03: ADC data buffer registers */
  uint8_t RESERVED[12]; /**/  
  __IO uint8_t CSR;    /*!< 0x20: ADC status register */
  __IO uint8_t CR1;    /*!< 0x21: ADC control register 1 */
  __IO uint8_t CR2;    /*!< 0x22: ADC control register 2 */
  __IO uint8_t CR3;    /*!< 0x23: ADC control register 3 */
  __IO uint8_t DRH;    /*!< 0x24: Data register high */
  __IO uint8_t DRL;    /*!< 0x25: Data register low */
  __IO uint8_t TDRH;   /*!< 0x26: Schmitt trigger disable high */
  __IO uint8_t TDRL;   /*!< 0x27: Schmitt trigger disable low */
  __IO uint8_t HTRH;   /*!< 0x28: High threshold register high */
  __IO uint8_t HTRL;   /*!< 0x29: High threshold register low */
  __IO uint8_t LTRH;   /*!< 0x2A: Low threshold register high */
  __IO uint8_t LTRL;   /*!< 0x2B: Low threshold register low */
  __IO uint8_t AWSRH;  /*!< 0x2C: Analog watchdog selection high */
  __IO uint8_t AWSRL;  /*!< 0x2D: Analog watchdog selection low */
  __IO uint8_t AWCRH;  /*!< 0x2E: Analog watchdog control high */
  __IO uint8_t AWCRL;  /*!< 0x2F: Analog watchdog control low */
} ADC1_TypeDef;

/* ---------------- CPU (Core Control) ---------------- */
typedef struct {
    __IO uint8_t A;    /*!< 0x00: Accumulator */
    __IO uint8_t PCE;  /*!< 0x01: Program counter extension (high byte for PC > 16-bit) */
    __IO uint8_t PCH;  /*!< 0x02: Program counter high byte */
    __IO uint8_t PCL;  /*!< 0x03: Program counter low byte */
    __IO uint8_t XH;   /*!< 0x04: Index register X high byte */
    __IO uint8_t XL;   /*!< 0x05: Index register X low byte */
    __IO uint8_t YH;   /*!< 0x06: Index register Y high byte */
    __IO uint8_t YL;   /*!< 0x07: Index register Y low byte */
    __IO uint8_t SPH;  /*!< 0x08: Stack pointer high byte */
    __IO uint8_t SPL;  /*!< 0x09: Stack pointer low byte */
    __IO uint8_t CCR;  /*!< 0x0A: Condition code register (flags: C,Z,N,H,I,T) */
} CPU_TypeDef;

/* ---------------- ITC (Interrupt Controller) ---------------- */
typedef struct {
    __IO uint8_t SPR1; /*!< 0x00: Software priority register 1 */
    __IO uint8_t SPR2; /*!< 0x01: Software priority register 2 */
    __IO uint8_t SPR3; /*!< 0x02: Software priority register 3 */
    __IO uint8_t SPR4; /*!< 0x03: Software priority register 4 */
    __IO uint8_t SPR5; /*!< 0x04: Software priority register 5 */
    __IO uint8_t SPR6; /*!< 0x05: Software priority register 6 */
    __IO uint8_t SPR7; /*!< 0x06: Software priority register 7 */
    __IO uint8_t SPR8; /*!< 0x07: Software priority register 8 */
} ITC_TypeDef;

/* ---------------- SWIM (Single Wire Interface Module) ---------------- */
typedef struct {
    __IO uint8_t CSR; /*!< 0x7F18: SWIM control/status register */
} SWIM_TypeDef;

/* ---------------- DM (Debug Module) ---------------- */
typedef struct {
    __IO uint8_t BK1RE;   /*!< 0x00: Backup register 1 read enable */
    __IO uint8_t BK1RH;   /*!< 0x01: Backup register 1 high byte */
    __IO uint8_t BK1RL;   /*!< 0x02: Backup register 1 low byte */
    __IO uint8_t BK2RE;   /*!< 0x03: Backup register 2 read enable */
    __IO uint8_t BK2RH;   /*!< 0x04: Backup register 2 high byte */
    __IO uint8_t BK2RL;   /*!< 0x05: Backup register 2 low byte */
    __IO uint8_t CR1;     /*!< 0x06: Control register 1 */
    __IO uint8_t CR2;     /*!< 0x07: Control register 2 */
    __IO uint8_t CSR1;    /*!< 0x08: Control/status register 1 */
    __IO uint8_t CSR2;    /*!< 0x09: Control/status register 2 */
    __IO uint8_t ENFCTR;  /*!< 0x0A: Flash enable/force control register */
} DM_TypeDef;

/* ========================================================= */
/* ============== PERIPHERAL DECLARATIONS ================== */
/* ========================================================= */
#define GPIOA   ((GPIO_TypeDef *) GPIOA_BASE)
#define GPIOB   ((GPIO_TypeDef *) GPIOB_BASE)
#define GPIOC   ((GPIO_TypeDef *) GPIOC_BASE)
#define GPIOD   ((GPIO_TypeDef *) GPIOD_BASE)
#define GPIOE   ((GPIO_TypeDef *) GPIOE_BASE)

#define FLASH   ((FLASH_TypeDef *) FLASH_BASE)
#define EXTI    ((EXTI_TypeDef  *) EXTI_BASE)
#define RST     ((RST_TypeDef   *) RST_BASE)
#define CLK     ((CLK_TypeDef   *) CLK_BASE)
#define WWDG    ((WWDG_TypeDef  *) WWDG_BASE)
#define IWDG    ((IWDG_TypeDef  *) IWDG_BASE)
#define AWU     ((AWU_TypeDef   *) AWU_BASE)
#define BEEP    ((BEEP_TypeDef  *) BEEP_BASE)

#define SPI1    ((SPI_TypeDef   *) SPI_BASE)
#define I2C1    ((I2C_TypeDef   *) I2C_BASE)
#define USART1   ((USART1_TypeDef *) USART1_BASE)
#define TIM1    ((TIM1_TypeDef  *) TIM1_BASE)
#define TIM2    ((TIM2_TypeDef  *) TIM2_BASE)
#define TIM4    ((TIM4_TypeDef  *) TIM4_BASE)
#define ADC1    ((ADC1_TypeDef  *) ADC1_BASE)
#define CPU     ((CPU_TypeDef   *) CPU_BASE)
#define ITC     ((ITC_TypeDef   *) ITC_BASE)
#define DM      ((DM_TypeDef    *) DM_BASE)

#define SWIM_CSR    (*(volatile uint8_t *)0x7F80)  /*!< 0x7F80: SWIM control status register */
#define CPU_CFG_GCR (*(volatile uint8_t *)0x7F60)  /*!< 0x7F60: CPU Global Configuration Register */


#endif /* __STM8S103F3P6_H */

