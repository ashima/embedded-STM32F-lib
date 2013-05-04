.SECONDARY:
.SUFFIXES:

I=../install

H=./byhand
S=./scripts
O=./obj
B=./built
T=./tests
INFOBASE=../readDocs/infobase.xml

CPP=g++
CCFLAGS=-O3

ARMCPP=arm-none-eabi-g++
ARMCC=arm-none-eabi-gcc
ARMAR=arm-none-eabi-ar
ARMCFLAGS= -O3 -mthumb -mthumb-interwork -mcpu=cortex-m4

PY=python2.7

INCS=-I $B -I $H
#VPATH=$B $H $S $O
#VPATH=$H $S

TARGETS=stm32F407
L_stm32F407=stm32F4_rt.o stm32F4_isrbt.o

LIBE=stm32F407.ld sections.ld 

HDRSE=clock_helpers.h clocks.h meta_script.h  st_base.h  system.h  gpio.h \
      newlibstubs.h
HDRS=instances.h busses.h memory.h  stm32F4_rt.h  structures.h \
     clktree.h lddefs.h

TESTS=memory.rslt

OBJ_stm32F407:=$(L_stm32F407:%=$O/%)

LIBNAMES:=$(TARGETS:%=lib%.a) $(LIBE)
INSTLIBS:=$(LIBNAMES:%=$I/lib/%)
BUILTLIBS:=$(TARGETS:%=$O/lib%.a)

HDRNAMES:=$(HDRS) $(HDRSE)
INSTHDRS:=$(HDRNAMES:%=$I/include/%)
BUILTHDRS:=$(HDRS:%=$B/%)

BUILTTSTS:=$(TESTS:%=$T/%)

.PHONY: all install clean

all: $(BUILTHDRS) $(BUILTLIBS) $(BUILTTSTS)

install: $(INSTHDRS) $(INSTLIBS) | all

dox:
	doxygen $S/dg.cfg

clean:
	-rm $O/* $B/* $T/*
	-rmdir $O $B $T
XSLTCMD=xsltproc --stringparam target $* -o $@ $< $(INFOBASE)
#	xsltproc -o $@ $< $(INFOBASE)

$B/%: $S/%.xsl $(INFOBASE) | $B
	$(XSLTCMD)

$T/%: $S/%.xsl $(INFOBASE) | $T
	xsltproc -o $@ $< $(INFOBASE)

# ld defs by hand for now.
$B/lddefs.xml: $S/lddefs.py $H/sections.ld
	$(PY) $S/lddefs.py -o $@ -i $H/sections.ld

$B/lddefs.h: $S/lddefs.h.xsl $B/lddefs.xml
	xsltproc --stringparam target lddefs.h -o $@ $S/lddefs.h.xsl $B/lddefs.xml

$O/%.o: $B/%.c | $O
	$(ARMCC) $(ARMCFLAGS) $(INCS) -c -o $@ $^

$O/%.o: $H/%.c | $O
	$(ARMCC) $(ARMCFLAGS) $(INCS) -c -o $@ $^

$O/%.o: $B/%.cc | $O
	$(ARMCPP) $(ARMCFLAGS) $(INCS) -c -o $@ $^

$O/%.o: $H/%.cc | $O
	$(ARMCPP) $(ARMCFLAGS) $(INCS) -c -o $@ $^

$T/%.o: $T/%.cc | $T
	$(CPP) $(CFLAGS) $(INCS) -c -o $@ $^

$T/%_test: $T/%_test.o
	$(CPP) -o $@ $^

$O/libstm32F407.a: $(OBJ_stm32F407) | $O
	$(ARMAR) rcs $@ $^

$T/%.rslt: $T/%_test | $T
	./$< > $@

$I/lib $I/include $B $T $O:
	-mkdir -p $@

$I/lib/%: $O/% | $I/lib
	cp $< $@

$I/lib/%: $H/% | $I/lib
	cp $< $@

$I/include/%: $H/% | $I/include
	cp $< $@

$I/include/%: $B/% | $I/include
	cp $< $@

$O/stubs.o $O/stm32F4_rt.o : | $B/lddefs.h
