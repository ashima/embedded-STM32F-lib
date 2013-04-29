.SUFFIXES:
.SECONDARY:

PY=/opt/local/bin/python2.7

# keep everything around for now.
I=./intermediates
R=./irritating
H=./byhand
S=./scripts
D=./docs
# what goes into the outbound database.
              #memory-adc.xml 

MERGELST = $H/guide.xml              $H/reg-Ranges.xml \
           $H/memory-overview-STM32F407.xml  \
           $H/memory-dma.xml         $H/memory-ethernet.xml \
           $I/memory-boundries.xml   $I/memory-ADC.xml \
           $I/regsFromIndex.xml      $I/periph-RCC.xml \
           $I/periph-GPIO.xml        $I/periph-SYSCFG.xml \
           $I/periph-FLASH.xml       $I/periph-DMA.xml \
           $I/periph-ADC.xml         $I/periph-DAC.xml \
           $I/periph-DCMI.xml        $I/periph-WWDG.xml \
           $I/periph-SPI.xml         $I/periph-USART.xml \
           $I/periph-I2C.xml         \
           $I/IRQ-branchtable.xml    $I/clocks.xml \
           $R/clk_v_ws.xml           $R/parts.xml 

all: infobase.xml

VPATH=$H $D

WRAP=$(PY) scripts/wrap.py
MINC=$(PY) scripts/mkinc.py
EXT=$(PY) scripts/extracttable.py
EXTARGS=-r 200 -t cells_xml

$I $R:
	-mkdir -p $@

$R/parts.xml: docs/STM-partlisttable.html | $I
	xsltproc --html -o $@ scripts/partsFromXHtml.xsl $^

$I/all.xml: $(MERGELST) 
	$(MINC) $^ | xsltproc -xinclude -o $@ scripts/nop.xsl -

infobase.xml: $I/all.xml
	xsltproc -o $@ scripts/merge.xsl $^

# registers
$I/DM00031020_0002-0032.txt: $D/DM00031020.pdf | $I
	pdftotext -y 80 -H 655 -x 0 -W 600 -layout -f 2 -l 32 -nopgbrk $^ $@

$I/regsFromIndex.xml: $I/DM00031020_0002-0032.txt
	$(PY) scripts/regsOfindex.py -i $^ -o $@ 

# table stuff...
$I/table-%.xml: $H/%.tab | $I
	$(EXT) $(EXTARGS) -o $@ `cat $^`
	if [ -e byhand/$*.errata ] ; then mv $@ $@.raw ; \
	$(MINC) $@.raw byhand/$*.errata |\
	xsltproc -xinclude -o $@ scripts/editTab.xsl - ; fi

$I/periph-%.xml: $I/table-reg-%.xml
	$(PY) scripts/periphOfTab.py -i $< -o $@

$I/memory-%.xml: $I/table-memory-%.xml
	xsltproc -o $@ scripts/memOfTab.xsl $^

$I/IRQ-branchtable.xml: $I/table-IRQ.xml
	xsltproc -o $@ scripts/btOfTab.xsl $^

$I/clocks.xml: $H/clocktree.xml
	xsltproc -o $@ scripts/expandClkTree.xsl $^
	
$I/clk_v_ws_data.xml: $I/table-clkWs.xml
	xsltproc -o $@ scripts/wsOfTab.xsl $^

$R/clk_v_ws.xml: $I/clk_v_ws_data.xml
	python2.7 scripts/wsClk.py -i $^ -o $@

clean:
	-rm $I/*.xml $I/*.txt $I/*.raw infobase.xml
	-rmdir $I

#infobase/memory.xml: intermediates/all.xml
#	xsltproc -o $@ scripts/mergeMem.xsl $^

#infobase/peripherals.xml: $I/all.xml
#	xsltproc -o $@ scripts/mergePeriph.xsl $^

#$I/DM00037051_0064-0067.txt: DM00037051.pdf
#	pdftotext -y 80 -H 655 -x 0 -W 600 -layout -f 64 -l 67 -nopgbrk $^ $@
#$I/DM00031020_0307-0307.txt: DM00031020.pdf
#	pdftotext -y 462 -H 128 -x 0 -W 600 -layout -f 307 -l 307 -nopgbrk $^ $@

#$I/table-%.xml: table-%.rawxml byhand/%.errata
	#$(MINC) $^ | xsltproc -xinclude -o $@ scripts/editTab.xsl
#$I/memory-boundries.xml:  DM00037051_0064-0067.txt
#	$(PY) scripts/memOftab.py -i $^ -o $@ -t memory-boundries
#$I/memory-adc.xml:  DM00031020_0307-0307.txt
#	$(PY) scripts/memOftab.py -i $^ -o $@ -t memory-adc
#	$(WRAP) -o $@ $^ 

