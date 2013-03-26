# @file memory2.py
# @author ijm
# @brief  Translates memory table culled from data sheet to an XML 
#         file for further edting.

# This script makes the following edits to the data from the datasheet:
#  o Umarked lines are assumed to straddle an entry. i.e. that the
#    origonal table had verticaly centered cells.
#
#  o Ethernet and ADC are consolidated
#
#  o SPI / I2S are renamed to just SPI
#
#  o RTC & BKP is renamed to just RTC
#
#  o 'Flash interface register' is renamed to FIR
#
#  o 'Cortex-M4 internal peripherals' is renamed to CIP
#
#  o The class of I2S*ext is set to SPI
#

import sys
import re

lines = sys.stdin.readlines()
r = re.compile(r'.*(0[xX]....)\s+(....)\s*-\s*(0[xX]....)\s+(....)\s+(.*)$')

p=0
blocks = []

for line in lines:
  m = r.match(line)

  if m!=None  :
    x = int( m.group(1) + m.group(2) , 0)
    y = int( m.group(3) + m.group(4) , 0)
    i = m.group(5)

    if i == 'Flash interface register' :
      i = 'FIR'
    elif i == 'Cortex-M4 internal peripherals' :
      i = 'CIP'
    elif i.startswith('RTC ') :
      i = 'RTC'
    elif i.startswith('SPI') :
      i = i.split(' ')[0]
    elif i.startswith('ADC') :
      i = 'ADC'
    elif i.startswith('ETHERNET') :
      i = 'ETH'
    elif i.startswith('FSMC control') :
      i = 'FSMC_CR'

    if i == '':
      if p == 0 :
        p = 1
        tmp = []       
      tmp.append( (x,y,len(tmp)+1) )
    else:
      if p == 1 :
        group = i
        p = 2
        tmp.append( (x,y,len(tmp)+1) )
      elif p == 2 :
        blocks.append( (tmp[-1][0], tmp[0][1], group) )
        blocks.append( (x,y,i) )
        p = 0
      elif p == 0 :    
        blocks.append( (x,y,i) )

space = re.compile(r'\s+')

print "<memory2>"
for (x,y,i) in blocks:
  if i != "Reserved" :
    i = re.sub( space, "_", i)
    c = re.sub(r'\d+$', "", i)
    if c.startswith("I2S") :
      c = "SPI"
    if c.startswith("FSMC_b") or c.startswith("ADC") or c.startswith("ETH") :
      c = ""

    s = "  <block name='%s' " % i
    if c != "" :
      s += "class='%s' " % c
    s += "first='0x%08x' last='0x%08x' size='0x%08x' />" % (x,y,y-x+1)
    print s

print "</memory2>"
      

