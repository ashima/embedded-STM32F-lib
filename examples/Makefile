.SUFFIXES:
.SECONDARY:

ARMCC=arm-none-eabi-gcc
ARMCPP=arm-none-eabi-g++
ARMAR=arm-none-eabi-ar
ARMOBJCOPY=arm-none-eabi-objcopy
ARMOBJDUMP=arm-none-eabi-objdump

INCS=-I ../headers
CFLAGS=-O3 -mthumb -mthumb-interwork -mcpu=cortex-m4 
LIBDIR=-L ../library

all: blinkPin-Ashima.bin blinkPin-Discovery.bin ex.bin

%.bin: %.elf
	$(ARMOBJCOPY) -O binary $^ $@
	$(ARMOBJDUMP) -SD $^ > $*.lst
	$(ARMOBJCOPY) -O ihex $^ $*.hex

#	-ffunction-sections -fdata-sections -Wl,--print-map -Wl,--gc-sections \
#$(ARMCC) $(CFLAGS) $(LIBDIR) -T $(LINKFILE) \

%.elf: %.o
	$(ARMCPP) $(CFLAGS) $(LIBDIR) -nostartfiles --specs=nano.specs \
	-T stm32F407.ld -T sections.ld -u isr_vector \
	-Wl,--print-map  \
	-o $@ $^ -lstm32F407 ../library/obj/stubs.o > $*.mapfile

# -T mem.ld -T sections.ld 
#	-o $@ $^ -lstm32F407 > $*.mapfile

%.o: %.cc
	$(ARMCPP) $(CFLAGS) $(INCS) -o $@ -c $^

blinkPin-Ashima.o: blinkPin.cc
	$(ARMCPP) $(CFLAGS) $(INCS) -o $@ -c $^

blinkPin-Discovery.o: blinkPin.cc
	$(ARMCPP) -DDISCOVERY_BRD $(CFLAGS) $(INCS) -o $@ -c $^

clean:
	rm *.o *.elf *.bin
