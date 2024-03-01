.syntax unified
.thumb

.global main

.data
 str: .asciz "HeLLo\n"

.text

main:

    LDR R1, =str
    LDRB R3, [R1]

	Character_Change: @    looping through word

        CMP R3, #'\n'
        BNE Character_Check

        Character_Check:
            CMP R3, #'a'
            BGT Check_Upper_l

            CMP R3, #'A'
            BGT Check_Upper_C

        Check_Upper_l:
            CMP R3, #'z'
            BLT Conversion_l

        Check_Upper_1:
            CMP R3, #'Z'
            BLT Conversion_C

        Conversion_l:
            SUB R3, #32
            STRB R3, [R1]
            LDRB R3, [R1, #1]

        Conversion_C:
            ADD R3, #'32'
            STRB R3, [R1]
            LDRB R3, [R1, #1]
