.syntax unified
.thumb

#include "intialise.s"

.global main

.data

tx_length: .byte 1
outputString: .space BUFFER_SIZE     // Defining an output string buffer
encoded_alphabet: .byte 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
decoded_alphabet: .byte 'J', 'U', 'K', 'W','D','Q','F','A','P','O','E','N','C','Z','X','G','Y','V','R','M','L','I','S','H','T'

@ Mode Definitions


.text

main:
    // activate peripherals
	BL initialise_power
	@BL change_clock_speed
	BL enable_peripheral_clocks
	BL enable_uart
	LDR R1, =0x20000000   // Load address of the input string
    LDR R2, =outputString  // Load address of the output string
	LDR R3, =encoded_alphabet // Load address of the encoded_alphabet
	LDR R4, =decoded_alphabet // Load address of the decoded_alphabet
loop:
    LDRB R5, [R1], #1      // Load byte from input string, increment pointer
    CMP R5, #0             // Check for null terminator
    BEQ end                // If null terminator found, end loop

	CMP R5, #ASCII_UPPERCASE_A // Check if character is uppercase
    BLT Store_Char // Not uppercase
    CMP R5, #ASCII_UPPERCASE_Z
    BGT Check_Lowercase// check for lowercase

    @ Encoding Function
    B Encode

Encode:
    LDR R7, =0           // Initialize offset
    MOV R8, R5           // Move input character to R8 for comparison
Encode_Loop:
    LDRB R9, [R3, R7]   // Load character from encoded alphabet
    CMP R8, R9           // Compare input character with encoded character
    BEQ Code_Found       // If a match is found, jump to code_found
    ADD R7, R7, #1       // Increment offset to check the next character
    CMP R7, #26          // Check if we have checked all characters in the alphabet
    BNE Encode_Loop      // If not, continue searching
    ADD R3, R3, #32
    B Store_Char         // If no match found, store the original character
Code_Found:
    ADD R5, R4, R7       // Calculate the address of the corresponding decoded character
    LDRB R5, [R5]        // Load the decoded character
    B Store_Char         // Store the decoded character and continue

Check_Lowercase:
    CMP R5, #ASCII_LOWERCASE_A // Check if character is lowercase
    BLT Store_Char
    CMP R5, #ASCII_LOWERCASE_Z
    BGT Store_Char

    B Encode_L @ encoding for lowercase letters


Encode_L:
    LDR R7, =0           // Initialize offset
    MOV R8, R5
    SUB R8, R8, #32           // Move input character to R8 for comparison

Encode_Loop_L:
    LDRB R9, [R3, R7]   // Load character from encoded alphabet
    CMP R8, R9           // Compare input character with encoded character
    BEQ Code_Found_L     // If a match is found, jump to code_found_l
    ADD R7, R7, #1       // Increment offset to check the next character
    CMP R7, #25          // Check if we have checked all characters in the alphabet
    BNE Encode_Loop_L    // If not, continue searching
    B Store_Char         // If no match found, store the original character

Code_Found_L:
    ADD R5, R4, R7
    LDRB R5, [R5]
    ADD R5, R5, #32        // Load the decoded character
    B Store_Char         // Store the decoded character and continue

Store_Char:
	STRB R5, [R2], #1      // Store byte into output string and increments pointer
    B loop                 // Repeating the overall loop

end:
    MOV R2, #0             // Null terminate output string to end the program
    STRB R2, [R1]
    B Transmit

@ R2 Has the converted String. Use it in the Transmit function.

@ Put Transmit Function Here!!!
Transmit:

	@ the base address for the register to set up UART
	LDR R0, =UART

	@ load the memory addresses of the buffer and length information

	LDR R11, =tx_length
	LDR R12, =outputString

	@ dereference the length variable
	LDR R11, [R11]
	B Transmit_Loop

Transmit_Loop:

	LDR R10, [R0, USART_ISR] @ load the status of the UART
	ANDS R10, 1 << UART_TXE  @ 'AND' the current status with the bit mask that we are interested in
						    @ NOTE, the ANDS is used so that if the result is '0' the z register flag is set

	@ loop back to check status again if the flag indicates there is no byte waiting
	BEQ Transmit_Loop

	@ load the next value in the string into the transmit buffer for the specified UART
    LDRB R5, [R12], #1
	CMP R5, #0
	BEQ End
	STRB R5, [R0, USART_TDR]

	@ note the use of the S on the end of the SUBS, this means that the register flags are set
	@ and this subtraction can be used to make a branch
	SUBS R11, #1

	@ keep looping while there are more characters to send
	BGT Transmit_Loop

	@ make a delay before sending again
	BL delay_loop

	@ loop back to the start
	B Transmit

@delay function
delay_loop:
	LDR R9, =0xFFFFF

delay_inner:
	@ notice the SUB has an S on the end, this means it alters the condition register
	@ and can be used to make a branching decision.
	SUBS R9, #1
	BGT delay_inner
	BX LR @ return from function call

End:
	B .

