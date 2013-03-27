
all: memory.h instances.h mToCtest.out

INFOBASE=../readDocs/infobase/
VPATH=$(INFOBASE)

memory.h: memory.xml
	xsltproc -o $@ scripts/mToC.xsl $^

instances.h: memory.xml
	xsltproc -o $@ scripts/mToS.xsl $^

mToCtest.c: memory.xml
	xsltproc -o $@ scripts/mToCtest.xsl $^

mToCtest: mToCtest.c
	g++ -o $@ $^

mToCtest.out: mToCtest
	./mToCtest > $@
	diff $@ mToCtest.good

clean:
	rm memory.h instances.h mToCtest.out
