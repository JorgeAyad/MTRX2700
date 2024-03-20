.syntax unified
.thumb

#include "definitions.s"
#include "initialise.s"
@#include "delay.s"

.equ ASCII_LOWERCASE_A, 97
.equ ASCII_LOWERCASE_Z, 122

.data
string1: .asciz "abb"

.text
.global main

main:
    // Button enable (input)
    LDR R2, =GPIOA         // Loading port A address into R0 register
    LDRB R3, [R0, #MODER]  // Loading the byte from GPIOA MODER (offset 0x00)
    AND R3, #0b11111100    // Bitmasking to change only the last two bits (bits 0 and 1)
    STRB R3, [R2, #MODER]  // Save back to GPIOA MODER

    BL enable_peripheral_clocks
    BL initialise_discovery_board
    MOV R4, #0              // Load LED pattern into a register
    LDRB R5, =0b00000001

    LDR R7, =string1 // stores the string
    MOV R9, #ASCII_LOWERCASE_A // will be the comparison register
    MOV R10, #0

    B loop

loop:

	LDRB R6, [R2, #IDR]    // Read the input from GPIOA IDR
    ANDS R6, #0x01          // Check if button is on
    BNE button_pressed      // Branch if button is pressed

	#BL delay
	LDRB R8, [R7], #1      //the selected letter we are on
	CMP R8, #0             // Check for null terminator
    BEQ end                // If null terminator found, end loop

	CMP R8, R9
	BEQ LED_Counter

    B loop

LED_Counter:
	ORR R4, R4, R5 // Set the LED pattern
    LSL R5, R5, #0x01
    ADD R10, R10, #1
    @BL delay
   // MOV R11, 0xffff
    //BL delay_loop

    B loop


button_pressed:

	CMP R9, #ASCII_LOWERCASE_Z
	BEQ Reset_Letter
    MOV R9, #ASCII_LOWERCASE_A + 1
   	MOV R4, #0              //  reset LED pattern into a register
    LDRB R5, =0b00000001 // reset comparison bit
    SUB R7, R7, R10		// go back to the begining of the word
	MOV R10, #0
    B loop

Reset_Letter:
	MOV R9, #ASCII_LOWERCASE_A
	B loop

end:
	STRB R4, [R0, #ODR + 1]     // Save the LED pattern
	B .

delay_loop:
	SUBS R11, R11, 1
	BNE delay_loop
	BX LR
