import argparse
import sys
import xml.etree.ElementTree as ET
import re

def procargs() :
  """Add arguments to the parser and parse the command line"""
  p = argparse.ArgumentParser( description="Extract subregister comments.")
  p.add_argument("-o", dest='outfile', help="output file", default=sys.stdout,
     type=argparse.FileType('w') )
  p.add_argument("-i", dest='infile', help="input table file", 
     default=sys.stdin, type=argparse.FileType('r') )

  return p.parse_args()

args = procargs()

ws = re.compile( r'^Bits*\s+([\d:]+)\s+(\S+):(.*?)$' )

root = ET.Element('bitDesc')

while 1:
  lines = args.infile.readlines(100000)
  if not lines:
    break
 
  for l in lines :
    m = ws.match(l)
    if m != None :
      (bit,name,desc) = m.groups()
      ET.SubElement(root,"subreg", { "name": name, "bit": bit}).text=desc.decode("utf-8")

args.outfile.write(ET.tostring(root).decode("utf-8"))




