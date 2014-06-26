#ifndef LED_H
#define LED_H

#include <stdint.h>

extern uint8_t ledConfig(uint32_t led);
extern uint8_t ledOn(uint32_t led);
extern uint8_t ledOff(uint32_t led);
extern uint8_t ledToggle(uint32_t led);

#endif
