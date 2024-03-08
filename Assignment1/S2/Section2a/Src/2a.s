.syntax unified
.thumb

.global main

#include "definitions.s"
#include "initialise.s"

.data @define variables

.text

@ this is the entry function called from the startup file
main:

	@ Branch with link to set the clocks for the I/O and UART
	BL enable_peripheral_clocks

	@ Once the clocks are started, need to initialise the discovery board I/O
	BL initialise_discovery_board
	B program_loop

	@ store the current light pattern (binary mask) in R4


program_loop:
LDR R5, =0b01010101 @ load a pattern for the set of LEDs (every second one is on)

LDR R0 , =GPIOE @ Loading the address of GPIOE
LDR R3, =0b00000001

ORR R4, R5, R3 @ Perform AND logical operator and Store result in R4
STRB R4, [R0, #ODR +1] @ Stores to the second byte of the ODR




