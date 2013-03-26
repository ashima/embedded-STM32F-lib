.SUFFIXES:

PY=/opt/local/bin/python2.7

# keep everything around for now.
all: infobase/memory.xml \
  intermediates/DM00037051_0064-0067.txt \
  intermediates/DM00031020_0002-0032.txt \
  intermediates/memory2.xml \
  intermediates/registers1.xml

MEMMERGELST =  byhand/memory1.xsrc  \
            intermediates/memory2.xml 

intermediates/memory2.xml:  intermediates/DM00037051_0064-0067.txt
	$(PY) scripts/memory2.py < $^ > $@

intermediates/DM00037051_0064-0067.txt: docs/DM00037051.pdf
	pdftotext -y 80 -H 655 -x 0 -W 600 -layout -f 64 -l 67 -nopgbrk $^ $@

intermediates/DM00031020_0002-0032.txt: docs/DM00031020.pdf
	pdftotext -y 80 -H 655 -x 0 -W 600 -layout -f 2 -l 32 -nopgbrk $^ $@

intermediates/registers1.xml: intermediates/DM00031020_0002-0032.txt
	$(PY) scripts/regsOfindex.py -i $^ -o $@ 

infobase/memory.xml: $(MEMMERGELST) scripts/mergeMem.xsl
	(echo '<all>' ; cat $(MEMMERGELST) ; echo '</all>' ) | \
	xsltproc -o $@ scripts/mergeMem.xsl - 

clean:
	rm intermediates/*.xml intermediates/*.txt infobase/*.xml

