.SUFFIXES:

PY=/opt/local/bin/python2.7

# keep everything around for now.
all: infobase/memory.xml \
  intermediates/DM00037051_0064-0067.txt \
  intermediates/DM00031020_0002-0032.txt \
  intermediates/DM00031020_0307-0307.txt \
  intermediates/memory-boundries.xml \
  intermediates/memory-adc.xml \
  intermediates/registers1.xml\
  intermediates/reg-RCC.xml \
  intermediates/reg-GPIO.xml \
  intermediates/reg-SYSCFG.xml \
  intermediates/reg-DMA.xml


MEMMERGELST = guide.xml \
              memory-overview-STM32F407.xml  \
              memory-boundries.xml \
              memory-adc.xml  \
              memory-ethernet.xml 

WRAP=scripts/wrap.sh
VPATH=intermediates byhand docs
EXT=$(PY) scripts/extracttable.py
EXTARGS=-r 200 -t cells_xml -w none

intermediates/reg-%.xml: byhand/%.tab
	$(EXT) $(EXTARGS) -o $@ -name $* `cat $^`

intermediates/memory-boundries.xml:  DM00037051_0064-0067.txt
	$(PY) scripts/memOftab.py -i $^ -o $@ -t memory-boundries

intermediates/memory-adc.xml:  DM00031020_0307-0307.txt
	$(PY) scripts/memOftab.py -i $^ -o $@ -t memory-adc

intermediates/DM00037051_0064-0067.txt: DM00037051.pdf
	pdftotext -y 80 -H 655 -x 0 -W 600 -layout -f 64 -l 67 -nopgbrk $^ $@

intermediates/DM00031020_0002-0032.txt: DM00031020.pdf
	pdftotext -y 80 -H 655 -x 0 -W 600 -layout -f 2 -l 32 -nopgbrk $^ $@

intermediates/DM00031020_0307-0307.txt: DM00031020.pdf
	pdftotext -y 462 -H 128 -x 0 -W 600 -layout -f 307 -l 307 -nopgbrk $^ $@

intermediates/all.xml: $(MEMMERGELST) 
	$(WRAP) $^ > $@

infobase/memory.xml: intermediates/all.xml
	xsltproc -o $@ scripts/mergeMem.xsl $^

# registers
intermediates/registers1.xml: DM00031020_0002-0032.txt
	$(PY) scripts/regsOfindex.py -i $^ -o $@ 

clean:
	rm intermediates/*.xml intermediates/*.txt infobase/*.xml

