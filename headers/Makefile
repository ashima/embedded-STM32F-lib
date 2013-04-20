.SECONDARY:
.SUFFIXES:

B=./built
H=./byhand
T=./tests
S=./scripts
INFOBASE=../readDocs/infobase.xml

CCC=g++
CCFLAGS=-O3
INCS=-I $B -I $H

VPATH=$H $S

TARGETS= \
  $B/memory.h        $B/instances.h \
  $B/structures.h    $B/stm32F4_rt.h  \
  $B/stm32F4_isrbt.c

TESTS= \
  $T/memory.rslt 

all: $(TARGETS) $(TESTS) 

$B $T:
	-mkdir $@

$(TARGETS): $(INFOBASE)

$B/%: %.xsl | $B
	xsltproc -o $@ $< $(INFOBASE)

$T/%: %.xsl | $T
	xsltproc -o $@ $< $(INFOBASE)

%.o: %.cc
	$(CCC) $(CCFLAGS) $(INCS) -c -o $@ $^

$T/%_test: $T/%_test.o
	$(CCC) -o $@ $^

$T/%.rslt: $T/%_test
	./$< > $@

clean:
	-rm $B/* $T/*
	-rmdir $B $T
