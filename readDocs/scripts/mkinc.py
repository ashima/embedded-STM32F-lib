import argparse
import sys
import xml.etree.ElementTree as ET

p = argparse.ArgumentParser(
    description="make an xinclude structure from a list of filenames.")
p.add_argument("-o", dest='outfile', help="output file", default=sys.stdout,
               type=argparse.FileType('w') )
p.add_argument("-name", 
               help="name of outer tag (default: <all> )", default="all")
p.add_argument("infile", nargs="+", help="files to merge" )

args = p.parse_args()

root = ET.Element(args.name, { "xmlns:xi":"http://www.w3.org/2001/XInclude" })

for f in args.infile :
  root.append( ET.Element("xi:include", { "href": f } ) )

args.outfile.write( ET.tostring(root) )

