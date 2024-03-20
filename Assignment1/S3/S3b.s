.syntax unified
.thumb

.global main
@ gotten fro stewart's W03 UART example
#include "initialise.s"


.align
@buffer to hold the recieving bytes (letters)
incoming_buffer: .space 62
@buffer length
incoming_counter: .byte 62

@length of string and what is
tx_string: .asciz "abcd\n"
tx_length: .byte 62





main:
	BL initialise_power
	BL change_clock_speed
	BL enable_peripheral_clocks
	BL enable_uart

	@ uncomment the next line to enter a transmission loop
	B tx_loop

Recieving:

	@ To read in data, we need to use a memory buffer to store the incoming bytes
	@ Get pointers to the buffer and counter memory areas
	LDR R6, =incoming_buffer
	LDR R7, =incoming_counter

	@ dereference the memory for the maximum buffer size, store it in R7
	LDRB R7, [R7]

	@ Keep a pointer that counts how many bytes have been received
	MOV R8, #0x00
	B Checking_UART_Status


Checking_UART_Status:

	LDR R0, =UART @ the base address for the register to set up UART
	LDR R1, [R0, USART_ISR] @ load the status of the UART

	TST R1, 1 << UART_ORE | 1 << UART_FE  @ 'AND' the current status with the bit mask that we are interested in
						   @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	BNE clear_error

	TST R1, 1 << UART_RXNE @ 'AND' the current status with the bit mask that we are interested in
							  @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	BEQ Checking_UART_Status @ loop back to check status again if the flag indicates there is no byte waiting

	LDRB R3, [R0, USART_RDR] @ load the lowest byte (RDR bits [0:7] for an 8 bit read)
	STRB R3, [R6, R8]
	ADD R8, #1
	B delay_loop

	CMP R7, R8
	BGT no_reset
	MOV R8, #0

	BX LR


no_reset:

	@ load the status of the UART
	LDR R1, [R0, USART_RQR]
	ORR R1, 1 << UART_RXFRQ
	STR R1, [R0, USART_RQR]

	BGT Checking_UART_Status

clear_error:

	@ Clear the overrun/frame error flag in the register USART_ICR (see page 897)
	LDR R1, [R0, USART_ICR]
	ORR R1, 1 << UART_ORECF | 1 << UART_FECF @ clear the flags (by setting flags to 1)
	STR R1, [R0, USART_ICR]
	B Checking_UART_Status


tx_loop:

	@ the base address for the register to set up UART
	LDR R0, =UART

	@ load the memory addresses of the buffer and length information
	LDR R3, =tx_string
	LDR R4, =tx_length

	@ dereference the length variable
	@ notice how memory address R4 is replaced by the value that was at that memory address
	LDR R4, [R4]


tx_uart:

	LDR R1, [R0, USART_ISR] @ load the status of the UART
	ANDS R1, 1 << UART_TXE


	BEQ tx_uart

	@ load the next value in the string into the transmit buffer for the specified UART
	LDRB R5, [R3], #1
	CMP R5, #'\n'
	BEQ End
	STRB R5, [R0, USART_TDR]


	SUBS R4, #1

	@ keep looping while there are more characters to send
	BGT tx_uart

	@ make a delay before sending again
	BL delay_loop

	@ loop back to the start
	B tx_loop


@ a very simple delay
@ you will need to find better ways of doing this
delay_loop:
	LDR R9, =0x3

delay_inner:

	SUBS R9, #1
	BGT delay_inner
	BX LR @ return from function call

End:
	B .