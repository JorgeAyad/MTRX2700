.syntax unified
.thumb

#include "definitions.s"
#include "initialise.s"

.text
.global main

.equ MODE, 0 //dictates which direction to go

main:
    // Button enable (input)
    LDR R2, =GPIOA         // Loading port A address into R0 register
    LDRB R3, [R0, #MODER]  // Loading the byte from GPIOA MODER (offset 0x00)
    AND R3, #0b11111100    // Bitmasking to change only the last two bits (bits 0 and 1)
    STRB R3, [R2, #MODER]  // Save back to GPIOA MODER

    BL enable_peripheral_clocks
    BL initialise_discovery_board
    MOV R4, #0              // Load LED pattern into a register
    MOV R8, #MODE
    LDRB R5, =0b00000001
    B loop

loop:
	BL Mode_Change

    LDRB R6, [R2, #IDR]    // Read the input from GPIOA IDR
    ANDS R6, #0x01          // Check if button is on
    BNE Button_Pressed      // Branch if button is pressed
    B loop

Mode_Change:
	CMP R4, #0
	BEQ Change_Mode_Ascending

	CMP R4, 0b11111111
	BEQ Change_Mode_Descending


Button_Pressed:

	CMP R8, #0
	BEQ button_pressed_ascending
	B button_pressed_descending

button_pressed_ascending:

    ORR R4, R4, R5 // Set the LED pattern
    LSL R5, R5, #0x01

    STRB R4, [R0, #ODR + 1]     // Save the LED pattern

    MOV R9, 0xffff

    BL delay_loop

    B loop

button_pressed_descending:
	LSR R5, R5, #0x01
	EOR R4, R4, R5
	STRB R4, [R0, #ODR + 1]
	CMP R4, 0b100000000
	BEQ Reset_LEDs

	MOV R9, 0xffff
	BL delay_loop

	B loop

Reset_LEDs:
	MOV R4, #0
	B button_pressed_descending

Change_Mode_Descending:
	MOV R8, #1
	BX LR

Change_Mode_Ascending:
	MOV R8, #0
	BX LR

delay_loop:
	SUBS R9, R9, 1
	BNE delay_loop
	BX LR


