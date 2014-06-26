
#include "board.h"

/** Global timestamp in milliseconds since start of application */
volatile uint32_t dwTimeStamp = 0;

//------------------------------------------------------------------------------
/**
 *  \brief Handler for Sytem Tick interrupt.
 *
 *  Process System Tick Event
 *  Increments the timestamp counter.
 */
void SysTick_Handler(void)
{
    dwTimeStamp++;
}

//------------------------------------------------------------------------------
/**
 *  Waits for the given number of milliseconds (using the dwTimeStamp generated
 *  by the SAM3's microcontrollers's system tick).
 *  \param delay  Delay to wait for, in milliseconds.
 */
static void Wait(unsigned long delay)
{
    volatile uint32_t start = dwTimeStamp;
    uint32_t elapsed;
    do {
        elapsed = dwTimeStamp;
        elapsed -= start;
    }
    while (elapsed < delay);
}

//------------------------------------------------------------------------------
int main(void)
{
    ledConfig(LED_GREEN);
    
    SysTick_Config(BOARD_MCK / 1000);
    
    ledOn(LED_GREEN);
    while(1)
    {
        Wait(500);
        ledToggle(LED_GREEN);
    }

	return 0;
}
