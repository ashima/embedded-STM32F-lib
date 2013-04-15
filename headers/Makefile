.SECONDARY:

TARGETS = memory.h instances.h structures.h \
  stm32F4_rt.h stm32F4_isrbt.c \
  mToCtest mToCtest.out mToCtest.c

all: $(TARGETS)

VPATH=../readDocs

memory.h: infobase.xml
	xsltproc -o $@ scripts/mToC.xsl $^

instances.h: infobase.xml 
	xsltproc -o $@ scripts/mToS.xsl $^

structures.h: infobase.xml
	xsltproc -o $@ scripts/periphToH.xsl $^

stm32F4_rt.h: infobase.xml
	xsltproc -o $@ scripts/startupH.xsl $^

stm32F4_isrbt.c: infobase.xml
	xsltproc -o $@ scripts/startupC.xsl $^


mToCtest.c: infobase.xml
	xsltproc -o $@ scripts/mToCtest.xsl $^

%.o : %.c
	g++ -o $Q $^

mToCtest: mToCtest.c
	g++ -o $@ $^

mToCtest.out: mToCtest
	./mToCtest > $@
	diff $@ mToCtest.good

clean:
	rm $(TARGETS)
