.syntax unified
.thumb

#include "DEFINITIONS.s"

.global main

.data
inputString: .asciz "abcd" // Input string
outputString: .space BUFFER_SIZE      // Defining an output string buffer
encoded_alphabet: .byte 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
decoded_alphabet: .byte 'J', 'U', 'K', 'W','D','Q','F','A','P','O','E','N','C','Z','X','G','Y','V','R','M','L','I','S','H','T'

@ Mode Definitions
.equ MODE, 1

.text

main:
    // Initialize variables
    LDR R1, =inputString   // Load address of the input string
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
    BEQ Encode

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

Decode:
	LDR R7, =0
	MOV R8, R5
Decode_Loop:
	LDRB R9, [R4, R7]
	CMP R8, R9
	BEQ Decode_Code
	ADD R7, R7, #1
	CMP R7, #26
	BNE Decode_Loop
	B Store_Char

Decode_Code:
	ADD R5, R3, R7
	LDRB R5, [R5]
	B Store_Char

Check_Lowercase:
    CMP R5, #ASCII_LOWERCASE_A // Check if character is lowercase
    BLT Store_Char
    CMP R5, #ASCII_LOWERCASE_Z
    BGT Store_Char

	LDR R6, =MODE
	CMP R6, #0
    BEQ Encode_L
   	B Decode_L

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

Decode_L:
    LDR R7, =0
    MOV R8, R5
    SUB R8, R8, #32
Decode_Loop_L:
    LDRB R9, [R4, R7]
    CMP R8, R9
    BEQ Decode_Code_L
    ADD R7, R7, #1
    CMP R7, #25
    BNE Decode_Loop_L
    B Store_Char

Decode_Code_L:
    ADD R5, R3, R7
    LDRB R5, [R5]
    ADD R5, R5, #32
    B Store_Char

Store_Char:
	STRB R5, [R2], #1      // Store byte into output string and increments pointer
    B loop                 // Repeating the overall loop

end:
    MOV R2, #0             // Null terminate output string to end the program
    STRB R2, [R1]

@ R2 Has the converted String. Use it in the Transmit function.

@ Put Transmit Function Here!!!




    // End program
    B .
