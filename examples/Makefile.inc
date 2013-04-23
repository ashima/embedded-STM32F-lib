.SUFFIXES:
.SECONDARY:

ARMCC=arm-none-eabi-gcc
ARMCPP=arm-none-eabi-g++
ARMAR=arm-none-eabi-ar
ARMOBJCOPY=arm-none-eabi-objcopy
ARMOBJDUMP=arm-none-eabi-objdump

INCS=-I ../../install/include
CFLAGS=-O3 -mthumb -mthumb-interwork -mcpu=cortex-m4 
LIBDIR=-L ../../install/lib

%.bin: obj/%.elf
	$(ARMOBJCOPY) -O binary $^ $@
	$(ARMOBJCOPY) -O ihex   $^ $*.hex
	$(ARMOBJDUMP) -SD       $^ > $*.lst

#	-ffunction-sections -fdata-sections -Wl,--print-map -Wl,--gc-sections \
#$(ARMCC) $(CFLAGS) $(LIBDIR) -T $(LINKFILE) \

%.elf: %.o
	$(ARMCPP) $(CFLAGS) $(LIBDIR) -nostartfiles --specs=nano.specs \
	-T stm32F407.ld -T sections.ld -u isr_vector \
	-Wl,--print-map  \
	-o $@ $^ -lstm32F407  > $*.mapfile

#../library/obj/stubs.o > $*.mapfile

# -T mem.ld -T sections.ld 
#	-o $@ $^ -lstm32F407 > $*.mapfile


obj/%.o: src/%.cc | obj
	$(ARMCPP) $(CFLAGS) $(INCS) -o $@ -c $^


clean:
	rm obj/*.o obj/*.elf *.bin *.lst *.hex

obj:
	-mkdir $@
