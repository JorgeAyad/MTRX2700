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
tx_length: .byte 64



main:
	BL initialise_power
	BL change_clock_speed
	BL enable_peripheral_clocks
	BL enable_uart

	B tx_loop

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
	ANDS R1, 1 << UART_TXE  @ 'AND' the current status with the bit mask that we are interested in
						    @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	@ loop back to check status again if the flag indicates there is no byte waiting
	BEQ tx_uart

	@ load the next value in the string into the transmit buffer for the specified UART
	LDRB R5, [R3], #1
	CMP R5, #'\n'
	BEQ End
	STRB R5, [R0, USART_TDR]

	@ note the use of the S on the end of the SUBS, this means that the register flags are set
	@ and this subtraction can be used to make a branch
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
	LDR R9, =0xFFFFFF

delay_inner:

	SUBS R9, #1
	BGT delay_inner
	BX LR @ return from function call

End:
	B .
