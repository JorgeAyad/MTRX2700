.syntax unified
.thumb

#include "definitions.s"
#include "initialise.s"

.text
.global main

main:
    // Button enable (input)
    LDR R0, =GPIOA         // Loading port A address into R0 register
    LDRB R1, [R0, #MODER]  // Loading the byte from GPIOA MODER (offset 0x00)
    AND R1, #0b11111100    // Bitmasking to change only the last two bits (bits 0 and 1)
    STRB R1, [R0, #MODER]  // Save back to GPIOA MODER

    BL enable_peripheral_clocks
    BL initialise_discovery_board
    MOV R4, #0              // Load LED pattern into a register
    LDRB R5, =0b00000001
    B loop

loop:
    LDRB R3, [R0, #IDR]    // Read the input from GPIOA IDR
    ANDS R3, #0x01          // Check if button is on
    BNE button_pressed      // Branch if button is pressed
    B loop

button_pressed:
    ORR R4, R4, R5 // Set the LED pattern
    LSL R5, R5, #0x01

    STRB R4, [R0, #ODR + 1]     // Save the LED pattern
    B loop
