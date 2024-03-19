################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (11.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/DEFINITIONS.s \
../Src/Transmit.s \
../Src/intialise.s 

OBJS += \
./Src/DEFINITIONS.o \
./Src/Transmit.o \
./Src/intialise.o 

S_DEPS += \
./Src/DEFINITIONS.d \
./Src/Transmit.d \
./Src/intialise.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Src

clean-Src:
	-$(RM) ./Src/DEFINITIONS.d ./Src/DEFINITIONS.o ./Src/Transmit.d ./Src/Transmit.o ./Src/intialise.d ./Src/intialise.o

.PHONY: clean-Src

