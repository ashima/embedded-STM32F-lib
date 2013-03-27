# @file memory2.py
# @author ijm
# @brief  Translates memory table culled from data sheet to an XML 
#         file for further edting.

# This script makes the following edits to the data from the datasheet:
#  o Umarked lines are assumed to straddle an entry. i.e. that the
#    origonal table had verticaly centered cells.
#

import sys
import re
import argparse

p = argparse.ArgumentParser( description="Read a simple memory boundry"
  "table and output XML.")

p.add_argument("-i", help="input file",dest='inf')
p.add_argument("-o", help="output file name", dest='outf' )
p.add_argument("-t", help="outer tag name", dest='tagname' )

a = p.parse_args()

with (sys.stdin if a.inf==None or a.inf=='-' else open(a.inf,'r')) as i:
  txt = i.read()
i.close()

lines = txt.splitlines()

s1 = re.compile(r'\s+')
s2 = re.compile(r'\s\s+')
amp = re.compile(r'&')
r = re.compile(r'.*(0[xX].*)\s*-\s*(0[xX].*)$')

p=0
blocks = []

for line in lines:
  l = re.sub(s2,"_",line)
  m = r.search(l) 

  if m != None :
    xs = re.sub( s1, "", m.group(1))
    b = (re.sub( s1, "", m.group(2))).split( r'_' )
    ys = b[0]
    i = "" if len(b) == 1 else b[1]
  
    i = re.sub( amp, "&amp;", i)
    x = int( xs.lower() , 0)
    y = int( ys.lower() , 0)

    if i == 'Flashinterfaceregister' :
      i = 'FIR'
    elif i == 'Cortex-M4internalperipherals' :
      i = 'CIP'
    elif i.startswith('RTC') :
      i = 'RTC'
    elif i.startswith('SPI') :
      i = i.split('/')[0]
    elif i.startswith('ADC') :
      i = i.split('-')[0]
    elif i.startswith('ETHERNET') :
      i = 'ETH'
    elif i.startswith('FSMCcontrol') :
      i = 'FSMC_CR'
    elif i=='Commonregisters' :
      i = 'ADC_CR'

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

tagname = a.tagname
if tagname == None :
  tagname = "list"

with (sys.stdout if a.outf==None or a.outf=='-' else open(a.outf,'w')) as o:
  o.write("<%s>\n" % tagname )
  for (x,y,i) in blocks:
    if i == "Reserved" :
      continue
    c = re.sub(r'\d+$', "", i)
    if c.startswith("GPIO") :
        c = "GPIO"
    elif c.startswith("I2S") :
      c = "SPI"
    elif c.startswith("FSMCb") or c.startswith("ETH") :
      c =  ""
    s = "  <block name='%s' " % i
    if c != "" :
      s += "class='%s' " % c
    s += "first='0x%08x' last='0x%08x' size='0x%08x' />\n" % (x,y,y-x+1)
    o.write( s )
  o.write("</%s>\n" % tagname )


