#ifndef BOARD_H
#define BOARD_H

#include "chip.h"

#include "include/board_lowlevel.h"
#include "include/led.h"

/** Name of the board */
#define BOARD_NAME "WIFIDROP"
/** Family definition (already defined) */
#define sam3s
/** Core definition */
#define cortexm3

#define BOARD_REV_A

/*----------------------------------------------------------------------------*/
/**
 *  \page sam3s_ek_opfreq "SAM3S-EK - Operating frequencies"
 *  This page lists several definition related to the board operating frequency
 *  (when using the initialization done by board_lowlevel.c).
 *
 *  \section Definitions
 *  - \ref BOARD_MAINOSC
 *  - \ref BOARD_MCK
 */

/** Frequency of the board main oscillator */
#define BOARD_MAINOSC           12000000

/** Master clock frequency (when using board_lowlevel.c) */
#define BOARD_MCK               64000000

#define LED_GREEN   0

/** List of all LEDs definitions. */
#define PINS_LEDS   PIN_LED_0

#ifdef BOARD_REV_A
#define PIN_LED_0   {PIO_PA1, PIOA, ID_PIOA, PIO_OUTPUT_1, PIO_DEFAULT}
#endif


#endif
