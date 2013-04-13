.SUFFIXES:
.SECONDARY:

PY=/opt/local/bin/python2.7

# keep everything around for now.
I=intermediates
REGOFINX=$I/regsFromIndex.xml

# what goes into the outbound database.
MERGELST = guide.xml \
           reg-Ranges.xml \
              memory-overview-STM32F407.xml  \
              memory-boundries.xml \
              memory-adc.xml  \
              memory-dma.xml  \
              memory-ethernet.xml \
  $I/table-memory-Blk12.xml \
  $I/table-memory-ADC.xml \
  regsFromIndex.xml\
  $I/periph-RCC.xml \
  $I/periph-GPIO.xml \
  $I/periph-SYSCFG.xml \
  $I/periph-FLASH.xml \
  $I/periph-DMA.xml \
  $I/periph-ADC.xml \
  $I/periph-DAC.xml \
  $I/periph-DCMI.xml \
  $I/periph-WWDG.xml \
  $I/periph-SPI.xml \
  $I/parts.xml \
  $I/IRQ-branchtable.xml

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
MINC=$(PY) scripts/mkinc.py
VPATH=$I byhand docs
EXT=$(PY) scripts/extracttable.py
EXTARGS=-r 200 -t cells_xml
# -w none

$I/parts.xml: docs/STM-partlisttable.html
	xsltproc --html -o $@ scripts/partsFromXHtml.xsl $^

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
	$(MINC) $^ | xsltproc -xinclude -o $@ scripts/nop.xsl -

#	$(WRAP) -o $@ $^ 

infobase/memory.xml: intermediates/all.xml
	xsltproc -o $@ scripts/mergeMem.xsl $^

infobase/peripherals.xml: $I/all.xml
	xsltproc -o $@ scripts/mergePeriph.xsl $^

# registers
$(REGOFINX): DM00031020_0002-0032.txt
	$(PY) scripts/regsOfindex.py -i $^ -o $@ 
# table stuff...

$I/table-%.xml: byhand/%.tab
	$(EXT) $(EXTARGS) -o $@ `cat $^`
	if [ -e byhand/$*.errata ] ; then mv $@ $@.raw ; \
	$(MINC) $@.raw byhand/$*.errata |\
	xsltproc -xinclude -o $@ scripts/editTab.xsl - ; fi




#$I/table-%.xml: table-%.rawxml byhand/%.errata
	#$(MINC) $^ | xsltproc -xinclude -o $@ scripts/editTab.xsl

$I/periph-%.xml: $I/table-reg-%.xml
	$(PY) scripts/periphOfTab.py -i $< -o $@

$I/IRQ-branchtable.xml: $I/table-IRQ.xml
	xsltproc -o $@ scripts/btOfTab.xsl $^

clean:
	rm intermediates/*.xml intermediates/*.txt infobase/*.xml

