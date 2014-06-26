#include "board.h"

#ifdef PINS_LEDS
static const Pin LEDS[] = { PINS_LEDS } ;
static const uint32_t NUM_LEDS = PIO_LISTSIZE(LEDS) ;
#endif

//------------------------------------------------------------------------------
/**
 *  Configures the pin associated with the given LED number. If the LED does
 *  not exist on the board, the function does nothing.
 *  \param led  Number of the LED to configure.
 *  \return 1 if the LED exists and has been configured; otherwise 0.
 */
uint8_t ledConfig(uint32_t led)
{
#ifdef PINS_LEDS
    // Check that LED exists
    if(led >= NUM_LEDS)
    {
        return 0;
    }

    // Configure LED
    return (PIO_Configure(&LEDS[led], 1));
#else
    return 0 ;
#endif
}

//------------------------------------------------------------------------------
/**
 *  Turns the given LED on if it exists; otherwise does nothing.
 *  \param led  Number of the LED to turn on.
 *  \return 1 if the LED has been turned on; 0 otherwise.
 */
uint8_t ledOn(uint32_t led)
{
#ifdef PINS_LEDS
    /* Check if LED exists */
    if(led >= NUM_LEDS)
    {
        return 0 ;
    }

    /* Turn LED on */
    if(LEDS[led].type == PIO_OUTPUT_0)
    {
        PIO_Set(&LEDS[led]);
    }
    else
    {
        PIO_Clear(&LEDS[led]);
    }

    return 1 ;
#else
    return 0 ;
#endif
}

//------------------------------------------------------------------------------
/**
 *  Turns a LED off.
 *
 *  \param led  Number of the LED to turn off.
 *  \return 1 if the LED has been turned off; 0 otherwise.
 */
uint8_t ledOff(uint32_t led)
{
#ifdef PINS_LEDS
    /* Check if LED exists */
    if(led >= NUM_LEDS)
    {
        return 0 ;
    }

    /* Turn LED off */
    if(LEDS[led].type == PIO_OUTPUT_0)
    {
        PIO_Clear(&LEDS[led]);
    }
    else
    {
        PIO_Set(&LEDS[led]);
    }

    return 1 ;
#else
    return 0 ;
#endif
}

//------------------------------------------------------------------------------
/**
 *  Toggles the current state of a LED.
 *
 *  \param led  Number of the LED to toggle.
 *  \return 1 if the LED has been toggled; otherwise 0.
 */
uint8_t ledToggle(uint32_t led)
{
#ifdef PINS_LEDS
    /* Check if LED exists */
    if(led >= NUM_LEDS)
    {
        return 0 ;
    }

    /* Toggle LED */
    if(PIO_GetOutputDataStatus(&LEDS[led]))
    {
        PIO_Clear(&LEDS[led]);
    }
    else
    {
        PIO_Set(&LEDS[led]);
    }

    return 1 ;
#else
    return 0 ;
#endif
}
