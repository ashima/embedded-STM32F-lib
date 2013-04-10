.SUFFIXES:
.SECONDARY:

PY=/opt/local/bin/python2.7

# keep everything around for now.
I=intermediates
REGOFINX=$I/regsFromIndex.xml

# what goes into the outbound database.
MERGELST = guide.xml \
           regRanges.xml \
              memory-overview-STM32F407.xml  \
              memory-boundries.xml \
              memory-adc.xml  \
              memory-dma.xml  \
              memory-ethernet.xml \
  regsFromIndex.xml\
  $I/periph-RCC.xml \
  $I/periph-GPIO.xml \
  $I/periph-SYSCFG.xml \
  $I/periph-FLASH.xml \
  $I/periph-DMA.xml \
  $I/irq.xml

all: infobase/memory.xml \
     infobase/peripherals.xml

#  intermediates/DM00037051_0064-0067.txt \
#  intermediates/DM00031020_0002-0032.txt \
#  intermediates/DM00031020_0307-0307.txt \
#  intermediates/memory-boundries.xml \
#  intermediates/memory-adc.xml \
#  $(REGOFINX)\
#  $(MERGELST)

WRAP=$(PY) scripts/wrap.py
VPATH=$I byhand docs
EXT=$(PY) scripts/extracttable.py
EXTARGS=-r 200 -t cells_xml
# -w none

$I/memory-boundries.xml:  DM00037051_0064-0067.txt
	$(PY) scripts/memOftab.py -i $^ -o $@ -t memory-boundries

$I/memory-adc.xml:  DM00031020_0307-0307.txt
	$(PY) scripts/memOftab.py -i $^ -o $@ -t memory-adc

$I/DM00037051_0064-0067.txt: DM00037051.pdf
	pdftotext -y 80 -H 655 -x 0 -W 600 -layout -f 64 -l 67 -nopgbrk $^ $@

$I/DM00031020_0002-0032.txt: DM00031020.pdf
	pdftotext -y 80 -H 655 -x 0 -W 600 -layout -f 2 -l 32 -nopgbrk $^ $@

$I/DM00031020_0307-0307.txt: DM00031020.pdf
	pdftotext -y 462 -H 128 -x 0 -W 600 -layout -f 307 -l 307 -nopgbrk $^ $@

$I/all.xml: $(MERGELST) 
	$(WRAP) -o $@ $^ 

infobase/memory.xml: intermediates/all.xml
	xsltproc -o $@ scripts/mergeMem.xsl $^

infobase/peripherals.xml: $I/all.xml
	xsltproc -o $@ scripts/mergePeriph.xsl $^

# registers
$(REGOFINX): DM00031020_0002-0032.txt
	$(PY) scripts/regsOfindex.py -i $^ -o $@ 

$I/table-%.xml: byhand/%.tab
	$(EXT) $(EXTARGS) -o $@ -name $* `cat $^`

$I/periph-%.xml: $I/table-reg-%.xml $(REGOFINX)
	$(PY) scripts/periphOfTab.py -c $(REGOFINX) -i $< -o $@

$I/irq.xml: $I/table-IRQ.xml
	echo $^

clean:
	rm intermediates/*.xml intermediates/*.txt infobase/*.xml

