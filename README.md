# MTRX2700

## Members:

- George Ayad (Section 1, 2, 3)
    - Do main code of the each of the sections specified above
    - Troubleshoot each of the different parts of the code and attempt to optimise existing code.
    - Build up on base functionality of differently developed modules.  
- Peter Cruz (Section 1, 2, 4)
    - Assist with the main parts of the section codes by applying base modularised functions for each of the sections and creating functions.
    - Do Section 4 with Timers and assist with delay functions.
    - Meeting Minutes - Change meeting minutes.
    - Do main code of the each of the sections specified above
- Jamie Cheng (Section 2,3)
    - Assist with the sections through information gathering and address finding, troubleshooting and creating modularised code for the sections
    - Create backups of code on local machine
    - Clean up Github and manage comments in codes.
    - Do main code of the each of the sections specified above
    - Meeting Minutes
- Tom Bray (Secion 1, 2)
    - Determine Delay functions for each of the functions for live demo
    - Proof read code and make changes for ease of functionality and usage
    - Do main code of the each of the sections specified above

## Overview

The overall assignment code is stored in 5 section folders for each of the sections. Some of the subsections sections are carried over from previous subsections due to constructive nature of some of the sections. For Section 5, a framework has been created but is non-functional. It still reflects how the code would be structured and does derive parts from section 1c, 2d and others. 

The code is broken down and modularised wherever possible for ease of usage and clarity for debugging and troubleshooting which are separated under file names like "delay.s". This allows a better legibility of the order process of multi function code where there are many functions integrated within the main file. However, for the initial developmental process, one main file is used for ease of redistribution but broken down as its completed. 

Modularised code for each section are listed under each of the different sections for ease of accessibility. 

Section 1 - Section 1 functions by taking a string and passing it through an array of different funtions such as converting case, or applying ciphers to them. Part A converts case while Part B applies a Caesar Cipher and Part C Applies a scramble to the letters. All three Parts fundamentally have the same ordered process.

Section 2 - Section 2 relies on adding functions a through to d starting by applying a bitmask in a to determine how to use bitmasks with LEDs. Part B introduces the button to increment the LEDs through Left shifting. Part C is the same as Part B but with right shifting. Section D takes the Left shift Function with the button press but now implements that into a string to count letters.

Section 3 - Section uses USART to be able to transmit and receive, especially with UART4 where it is configured for send and receive which can be displayed on a terminal program like PuTTy. For example, a string can be passed through a buffer which can be released by a button to enable a transmit function. This does require the program to be interupted manually with a play/pause.

Section 4 - Section 4 uses timers to allow a specific delay through TIM_ARR and the Prescaler through calculating with a base clock speed of 8 MHz. Taking the precaled time and the value of ARR, a counter and timer can be made for time delays. The time delay ratio is PSC/ARR to determine the time delay

Section 5 - Section 5 attempts to integrate the tasks, but the communication between the boards did not work :(. As a result, the format of the sections is laid out on the send and receive functions which works individually on the previous sections but when combined unfortunately doesn't work. What it should do is to send the string from the first board by first appying a scramble, then the second board receives the string, decodes it and lights up the LEDs depending on the letter selected.

NOTE: Definitions and setup files like "definitions.s" and "initialise.s" are taken from the code examples, as they follow a very similar or same process as any other setup file due to the same model of board used. The variables and process for the enables and offsets can be found in the main manual of the STM32F3Discovery Board and the lecture slides. 

## How to run the code

In each of the subsection folders, the SRC folder contains the files required to run the main code with the respective include files that need to be also used. To run the program, all that is required is to place the files under the same SRC directory and ensure that the required functions are uncommented or set correctly in the variables section wherever applicable. 

## How to test and debug.

In the sections of the codes, there are various ways of debugging and testing code like using physical indicators like LED indicators and PuTTy, or by checking the memory addresses of the stored data. This is more prominent in Section 2 and 4 where LED indicators utilised while the Memory checking is more suited to Sections 1 and 4
