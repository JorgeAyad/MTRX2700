.syntax unified
.thumb

.global main

.data
inputString:  .asciz "HelloWorld123" // Input string
outputString: .space BUFFER_SIZE      // Defining an output string buffer



.equ BUFFER_SIZE, 32
.equ ASCII_UPPERCASE_A, 65 // Defining Variables for the ASCII bounds
.equ ASCII_UPPERCASE_Z, 90
.equ ASCII_LOWERCASE_A, 97
.equ ASCII_LOWERCASE_Z, 122
.equ CONVERT_DIFFERENCE, 32

.text


main:
    // Initialize variables
    LDR R0, =inputString   // Load address of the input string
    LDR R1, =outputString  // Load address of the output string

loop:
    LDRB R2, [R0], #1      // Load byte from input string, increment pointer
    CMP R2, #0             // Check for null terminator
    BEQ end                // If null terminator found, end loop

    CMP R2, #ASCII_UPPERCASE_A // Check if character is uppercase
    BLT check_lowercase
    CMP R2, #ASCII_UPPERCASE_Z
    BGT check_lowercase
    ADD R2, R2, CONVERT_DIFFERENCE // Convert uppercase to lowercase
    B store_char

check_lowercase:
    CMP R2, #ASCII_LOWERCASE_A // Check if character is lowercase
    BLT store_char
    CMP R2, #ASCII_LOWERCASE_Z
    BGT store_char
    SUB R2, R2, CONVERT_DIFFERENCE // Convert lowercase to uppercase

store_char:
    STRB R2, [R1], #1      // Store byte into output string and increments pointer
    B loop                 // Repeating the overall loop

end:
    MOV R2, #0             // Null terminate output string to end the program
    STRB R2, [R1]

    // End program
    B .


