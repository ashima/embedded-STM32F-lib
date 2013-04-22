.SECONDARY:
.SUFFIXES:

export ARMCPP=arm-none-eabi-g++
export ARMCC=arm-none-eabi-gcc
export ARMAR=arm-none-eabi-ar
export CFLAGS= -O3 -mthumb -mthumb-interwork -mcpu=cortex-m4

VPATH=src ../headers
INCS=-I ../headers

OBJS= obj/stm32F4_rt.o obj/stm32F4_isrbt.o obj/stubs.o

all: libstm32F407.a

obj/%.o: %.cc
	$(ARMCPP) $(CFLAGS) $(INCS) -o $@ -c $^

obj/%.o: %.c
	$(ARMCC) $(CFLAGS) $(INCS) -o $@ -c $^

libstm32F407.a: $(OBJS)
	$(ARMAR) rcs $@ $^

clean:
	rm obj/*.o *.a
