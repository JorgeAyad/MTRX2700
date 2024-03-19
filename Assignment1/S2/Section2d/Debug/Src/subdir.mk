################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (11.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/2d.s \
../Src/definitions.s \
../Src/delay.s \
../Src/initialise.s 

OBJS += \
./Src/2d.o \
./Src/definitions.o \
./Src/delay.o \
./Src/initialise.o 

S_DEPS += \
./Src/2d.d \
./Src/definitions.d \
./Src/delay.d \
./Src/initialise.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Src

clean-Src:
	-$(RM) ./Src/2d.d ./Src/2d.o ./Src/definitions.d ./Src/definitions.o ./Src/delay.d ./Src/delay.o ./Src/initialise.d ./Src/initialise.o

.PHONY: clean-Src

