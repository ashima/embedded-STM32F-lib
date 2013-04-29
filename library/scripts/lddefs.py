import argparse
import sys
import re
import xml.etree.ElementTree as ET


p = argparse.ArgumentParser(
    description="Make a C headerfile of linker exported names.")
p.add_argument("-o", dest='outfile', help="output file", default=sys.stdout,
               type=argparse.FileType('w') )
p.add_argument("-i", dest='infile', help="inputfile", default=sys.stdin,
               type=argparse.FileType('r') )

args = p.parse_args()

s = re.compile(r'(\w+)[^\w\n\r]*=')

f = args.infile.read();
l = s.findall(f)
root = ET.Element("lddefs")

for x in l:
  ET.SubElement(root, "def",{ "name": x })

args.outfile.write( ET.tostring(root).decode("utf-8") )


