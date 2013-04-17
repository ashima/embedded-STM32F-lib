from __future__ import print_function
import sys
import re
import argparse

p = argparse.ArgumentParser( description="Read ascii index "
   "and output a list of registers and descriptions." )

p.add_argument("-i",required=True, help="input file",dest='inxfile')
p.add_argument("-o", help="output file name", dest='outf' )

a = p.parse_args()

with open (a.inxfile, 'r' ) as l :
  inx = l.read()

l.close()
#   '     1.3     Peripheral availability. . . . . . . . 48'
#rse = re.compile( r'(\d+.*?\s+\.\s+\d+)', re.MULTILINE | re.DOTALL )
rse = re.compile( r'(\d+.*?\s+\d+$)', re.MULTILINE | re.DOTALL )

inx = re.sub( r'\n\s+(?=[A-Za-z\(])'," ",inx )
rs = rse.findall( inx )

inxrow = re.compile( r'(\d+.*?)\s+(.*?)(\d+)$' )
regi = {}
regs = []
sections = [] 

for reg in rs :
  reg = re.sub( r'[\s\n]+', " ", reg )
  m = inxrow.match(reg)

  if m == None :
    print("Couldn't fit {0}".format(reg))
    continute

  s = m.group(1)  
  t = m.group(2)  
  p = m.group(3)  

  t = re.sub( r'\.', "", t )
  t = re.sub( r'\s+', " ", t )
  t = re.sub( r'\s+$', "", t)
  t = re.sub( r'&', '&amp;', t)
  t = re.sub( r'<', '&lt;', t)
  t = re.sub( r'>', '&gt;', t)

  regline = re.compile( r'register.*\(([A-Za-z0-9_]+)\)' )

  m = regline.search(t)
  if m == None :
    sections.append ("<section name='%s' page='%s'>%s</section>" %(s,p,t))  
  else:
    r = m.group(1)
    if not r in regi :
      regs.append(r)
      regi[r] = t
    else:
      if len(t) < len(regi[r]) :
        regi[r] = t
    sections.append( "<section name='%s' page='%s' reg='%s'>%s</section>" %
      ( s, p, r,t) )

with (sys.stdout if a.outf==None or a.outf=='-' else open(a.outf,'w')) as o:
  o.write ("<index>\n  <sections>\n")
  for s in sections :
    o.write("    %s\n" % s)
  o.write ("  </sections>\n<registers>\n")
  for r in regs :
    o.write ("    <register name='%s'>%s</register>\n" % ( r, regi[r] ))
  o.write ("  </registers>\n</index>\n")

o.close()

