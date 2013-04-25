import argparse
import sys
#from xml.dom.minidom import parse, getDOMImplementation
import xml.etree.ElementTree as ET
import re

def procargs() :
  """Add arguments to the parser and parse the command line"""
  p = argparse.ArgumentParser( description="Merge XML files together.")
  p.add_argument("-o", dest='outfile', help="output file", default=sys.stdout,
     type=argparse.FileType('w') )
  p.add_argument("-i", dest='infile', help="input table file", default=sys.stdin,
     type=argparse.FileType('r') )

  return p.parse_args()

args = procargs()

ws = re.compile( r'\s+' )
ns = re.compile( r'(\w+)' )
ss = re.compile( r'[^\w_\[\]]+' )

tableTree = ET.parse(args.infile)
table = tableTree.getroot()
tabname = table.get('name')

#comments = ET.parse(args.commfile).getroot()

fst = table.findall("cell[1]")[0]
hrowi = int(fst.attrib.get('y')) + 10000*int(fst.attrib.get('p'))

# Group by row.
inx = {}
for x in table :
  if x.text is not None and ws.sub('', x.text) != "Reserved" :
    i = int(x.attrib.get('y')) + 10000*int(x.attrib.get('p'))
    if inx.get(i)  is None : 
      inx[i] = []
    inx[i].append(x)

hrow={}
for i in inx[hrowi] :
  x = int(i.get('x')) 
  w = int(i.get('w'))
  for j in range(0,w):
    hrow[ str(x + j) ] = i

#equiv to xpath : 'ns[starts-with(text(),$t][0]'

def txtInNodes(ns,txt):
  """iterate through the node list, searching for the 'txt' string. 
  If found, store the node in the list. If the list is empty return 
  None, else return the first element."""
  l = [ x for x in inx[hrowi] 
                if x.text and x.text.lower().find(txt) !=-1 ]
  return None if len(l) == 0 else l[0]


n = txtInNodes(inx[hrowi], "off")
if n is not None and n.get("x") is not None :
  offCol = int(n.get("x"))
else:
  raise Exception("Couldn't find Offset column?!")

n = txtInNodes(inx[hrowi], "reg")

if n is not None and n.get("x") is not None :
  regCol = int(n.get("x"))
else:
  raise Exception("Couldn't find register column?!")

# make keys for register name rows
ks = [ int(x.attrib.get('y')) + 10000*int(x.attrib.get('p'))
       for x in table if int(x.get('x'))==regCol and\
                         x.text and\
                         x.text.startswith(tabname) ]

# Reshape by regname
root = ET.Element('permap',table.attrib)


#should get the special cases out somewhere!
n1 = re.compile( r'^(MCO2PRE|MCO1PRE|.*\s+)(\d+)$' )
#print sorted(ks)

for k in sorted(ks) :
  r = inx[k]
  d_x = {}
  d_n = {}
  reg = ET.Element("reg")
  root.append(reg)
  for j in r:
    x = int(j.get("x"))
    if x > int(regCol) and j.text is not None:
      w = j.get("w")
      txt = n1.match( j.text )
      if txt is None :
        bit = ET.Element("bit", { 
          "name"  : ss.sub('_',ws.sub("", j.text)) , 
          "w"     : w,
          "x"     : str(x),
          "last"  : hrow[str(x)].text,
          "first" : hrow[str(x+int(w)-1)].text
          } )
        reg.append( bit )
      else:
        n = txt.group(1)
        if d_n.get( n ) is None :
          d_n[n] = ET.Element("bit", { 
            "name"  : ss.sub('_', ws.sub("", n )) ,
            "last" : "0",
            "first" : "1000",
            } )
          reg.append( d_n[n] )
        b = d_n[n]
        l = int(hrow[str(x)].text)
        f = int(hrow[str(x+int(w)-1)].text)
        if int(b.attrib["first"]) > f :
          b.attrib["first"] = str(f) 
        if int(b.attrib["last"]) < l :
          b.attrib["last"] = str(f) 
        b.attrib["w"] = str( int(b.attrib["last"]) - int(b.attrib["first"])+1)
    d_x[ x ] = j
  n = d_x.get(regCol)
  if n is not None :
    n = ws.sub("",d_x[regCol].text)
  if n is not None :
    n = ns.match(n)
    if n is not None :
      n = n.group(1)
  if n is None :
    n = "Unknown!?"
  else:
    n = ss.sub('',n);
#  c = comments.findall("registers/register[@name='%s']" % n)
#  if len(c) > 0 and c[0].text != None:
#    desc = ET.Element("description")
#    desc.text = c[0].text
#    reg.append(desc)
  reg.set("name",  n)
 
  reg.set("offset", d_x[offCol].text)
  reg.set("p", d_x[offCol].get("p") )
  reg.set("y", d_x[offCol].get("y") )
    
#    reg = ET.Element('reg', { "y":y, "p":p, "name": 
    
args.outfile.write(ET.tostring(root).decode("utf-8"))

#root = ET.Element('pmap', { name: table.attrib['name'], src: table.attrib['src'] } )

        #bit = ET.Element("bit", { 
          #"name"  : ws.sub("", j.text) , 
          #"i"     : txt.group(2),
          #"w"     : w,
          #"x"     : str(x),
          #"last"  : hrow[str(x)].text,
          #"first" : hrow[str(x+int(w)-1)].text
          #} )
        #d_n[n].append( bit )
