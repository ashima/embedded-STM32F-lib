.SUFFIXES:
.SECONDARY:

ARMCC=arm-none-eabi-gcc
ARMCPP=arm-none-eabi-g++
ARMAR=arm-none-eabi-ar
ARMOBJCOPY=arm-none-eabi-objcopy
ARMOBJDUMP=arm-none-eabi-objdump

INCS=-I ../headers
CFLAGS=-g -O3 -mthumb -mthumb-interwork -mcpu=cortex-m4 
LIBDIR=-L ../library

all: blinkPin-Ashima.bin blinkPin-Discovery.bin

%.bin: %.elf
	$(ARMOBJCOPY) -O binary $^ $@
	$(ARMOBJDUMP) -SD $^ > $*.lst

#	-ffunction-sections -fdata-sections -Wl,--print-map -Wl,--gc-sections \
#$(ARMCC) $(CFLAGS) $(LIBDIR) -T $(LINKFILE) \

%.elf: %.o
	$(ARMCPP) $(CFLAGS) $(LIBDIR) -nostartfiles -nostdlib \
	-T mem.ld -T sections.ld -u isr_vector \
	-Wl,--print-map  \
	-o $@ $^ -lstm32F407 > $*.mapfile
# -T mem.ld -T sections.ld 

blinkPin-Ashima.o: blinkPin.cc
	$(ARMCPP) $(CFLAGS) $(INCS) -o $@ -c $^

blinkPin-Discovery.o: blinkPin.cc
	$(ARMCPP) -DDISCOVERY_BRD $(CFLAGS) $(INCS) -o $@ -c $^

clean:
	rm *.o *.elf *.bin
