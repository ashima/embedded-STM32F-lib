.SECONDARY:

TARGETS = memory.h instances.h structures.h mToCtest mToCtest.out mToCtest.c

all: $(TARGETS)

#INFOBASE=../readDocs/infobase.xml
VPATH=../readDocs
#$(INFOBASE)

#memory.h: memory.xml
memory.h: infobase.xml
	xsltproc -o $@ scripts/mToC.xsl $^

#instances.h: memory.xml 
instances.h: infobase.xml 
	xsltproc -o $@ scripts/mToS.xsl $^

#structures.h: peripherals.xml
structures.h: infobase.xml
	xsltproc -o $@ scripts/periphToH.xsl $^

#mToCtest.c: memory.xml
mToCtest.c: infobase.xml
	xsltproc -o $@ scripts/mToCtest.xsl $^

mToCtest: mToCtest.c
	g++ -o $@ $^

mToCtest.out: mToCtest
	./mToCtest > $@
	diff $@ mToCtest.good

clean:
	rm $(TARGETS)
