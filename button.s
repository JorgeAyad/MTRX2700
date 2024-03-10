.syntax unified
.thumb

.equ RCC_AHBENR, 0x40021014        @ RCC AHB peripheral clock enable register
.equ GPIOA_BASE, 0x48000000         @ GPIOA base address
.equ GPIOA_MODER, GPIOA_BASE + 0x00 @ GPIOA mode register
.equ GPIOA_IDR,   GPIOA_BASE + 0x10 @ GPIOA input data register

.equ BUTTON_PIN, 0                  @ Assuming button is connected to pin 0 on GPIOA

.section .text
.global main
.type main, %function

main:
    @ Enable GPIOA clock
    ldr r1, =RCC_AHBENR
    ldr r2, [r1]
    orr r2, r2, #(1 << 17)     @ Set bit 17 for GPIOA
    str r2, [r1]

    @ Set pin 0 of GPIOA as input
    ldr r1, =GPIOA_MODER
    ldr r2, [r1]
    bic r2, r2, #(0b11 << (BUTTON_PIN * 2))  @ Clear bits for pin 0
    str r2, [r1]

loop:
    @ Read the input from pin 0 of GPIOA
    ldr r1, =GPIOA_IDR
    ldr r2, [r1]
    lsr r2, r2, #(BUTTON_PIN)    @ Shift the value so the button state is in the LSB
    and r2, r2, #1               @ Mask other bits
    cmp r2, #0                   @ Compare with 0 to check if button is pressed
    beq loop                     @ If button is not pressed, loop

button_pressed:
    @ Button is pressed, do something here
    b loop                       @ Go back to looping

