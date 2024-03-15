.syntax unified
.thumb

#include "delay.s"

.global main

.equ RCC_AHBENR, 0x40021014      // RCC AHBENR register address
.equ GPIOE_MODER, 0x48001000      // GPIOE MODER register address
.equ GPIOE_ODR, 0x48001014        // GPIOE ODR register address

.equ LED_PIN, 9                   // Assuming LED is connected to pin 9 of GPIOE

main:
    // Enable clock for GPIOE
    ldr r0, =RCC_AHBENR
    ldr r1, [r0]
    orr r1, r1, #(1 << 21)         // Set bit 21 to enable GPIOE clock
    str r1, [r0]

    // Set LED pin as output
    ldr r0, =GPIOE_MODER
    ldr r1, [r0]
    bic r1, r1, #(0b11 << (LED_PIN * 2))  // Clear bits for LED pin
    orr r1, r1, #(0b01 << (LED_PIN * 2))  // Set pin as output (01)
    str r1, [r0]

loop:
    // Turn on LED
    ldr r0, =GPIOE_ODR
    ldr r1, [r0]
    orr r1, r1, #(1 << LED_PIN)    // Set bit for LED pin
    str r1, [r0]

    // Delay
    ldr r0, =10000             // Adjust delay as needed to some arbitary number for now
    bl delay

    // Turn off LED
    ldr r0, =GPIOE_ODR
    ldr r1, [r0]
    bic r1, r1, #(1 << LED_PIN)    // Clear bit for LED pin
    str r1, [r0]

    // Delay
    ldr r0, =10000             // Adjust delay as needed to some arbitary number for now
    bl delay

    // Repeat indefinitely
    B loop
