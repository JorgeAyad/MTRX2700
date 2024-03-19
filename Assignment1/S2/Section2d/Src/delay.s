.syntax unified
.thumb

#.global delay
.equ RCC_APB1ENR, 0x4002101C    // RCC APB1ENR register address
.equ TIM2_CR1, 0x40000000        // Timer control register 1 address
.equ TIM2_PSC, 0x40000028        // Timer prescaler register address
.equ TIM2_ARR, 0x4000002C        // Timer auto-reload register address
.equ TIM2_SR, 0x40000010         // Timer status register address
value: .word 79999999

delay:
    PUSH {LR}             // Save link register

    // Enable clock for Timer 2
    LDR R0, =RCC_APB1ENR
    LDR R1, [R0]
    ORR R1, R1, #(1 << 0)  // Set bit 0 to enable TIM2 clock
    STR R1, [R0]

    // Configure Timer 2
    LDR R0, =TIM2_CR1      // Load address of TIM2_CR1
    MOV R1, #0             // Clear all bits
    STR R1, [R0]           // Store back to CR1

    // Set prescaler for desired clock frequency
    LDR R0, =TIM2_PSC
    //For 500ms second
    LDR R1, =3999           // Setting the Prescaler, remeber that at zero, default is 1.
    //For 1 hour prescaler is roughly 2.2 so the prescaler should be ideally set at 1.2 but will be forced to be 1
    //LDR R1, =1
    //For 1 microsecond the prescaler will be roughly 7,999,999,999, This wont work as it will trigger the stack handler
    //LDR R1, #799999999
    //For 0.1ms or 100 microseconds the prescaler will be 79,999,999
    //LDR R3, #value
    //LDR R1, [R3]

    STR R1, [R0]

    // Calculate the ARR value for the desired delay time
    LDR R0, =TIM2_ARR
    MOV R1, #1000        // Setting the Frequency Counter at 1000
    STR R1, [R0]

    // Enable Timer 2
    LDR R0, =TIM2_CR1
    MOV R1, #(1 << 0)      // Set bit 0 (CEN) to enable the timer
    STR R1, [R0]

delay_loop:
    // Wait until the timer reaches zero (UIF flag is set)
    LDR R0, =TIM2_SR       // Load the status register
    LDR R1, [R0]
    TST R1, #(1 << 0)      // Check the UIF (Update Interrupt Flag) bit
    BEQ delay_loop         // If the UIF bit is not set, keep looping

    // Clear the UIF bit by writing 0 to it
    LDR R0, =TIM2_SR
    MOV R1, #0             // Clear the UIF bit
    STR R1, [R0]

    POP {PC}               // Return from function
