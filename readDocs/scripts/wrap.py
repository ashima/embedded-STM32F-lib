from __future__ import print_function
import argparse
import sys
from xml.dom.minidom import parse, parseString, getDOMImplementation
import xml.etree.ElementTree as ET
import re

def procargs() :
  """Add arguments to the argument parser and parse the standard input"""
  p = argparse.ArgumentParser( description="Merge XML files together.")
  p.add_argument("-o", dest='outfile', help="output file", default=sys.stdout,
     type=argparse.FileType('w') )
  p.add_argument("-name", help="name of outer tag (default: <all> )", default="all")
  p.add_argument("infile", nargs="+", help="files to merge" )
  return p.parse_args()

args = procargs()
root = ET.Element(args.name)

for f in args.infile :
  print("file :{0}".format(f))
  root.append( ET.parse(f).getroot() )

ws = re.compile("[\n\s]+")

for x in root.iter():
  if (x.text is not None and ws.match(x.text) is not None) :
    x.text = None
  if (x.tail is not None and ws.match(x.tail) is not None) :
    x.tail = None

doc = parseString( ET.tostring(root) )
args.outfile.write( doc.toprettyxml( encoding="utf8", indent="  " ))

