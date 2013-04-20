import argparse
import sys
import xml.etree.ElementTree as ET
import re
import numpy
import math
import scipy.optimize as OP

def procargs() :
  p = argparse.ArgumentParser( description="wait states from XML files.")
  p.add_argument("-o", dest='outfile', help="output file", default=sys.stdout,
     type=argparse.FileType('w') )
  p.add_argument("-i", dest='infile', help="input file", default=sys.stdin,
     type=argparse.FileType('r') )
  return p.parse_args()

args = procargs()
root = ET.parse(args.infile).getroot()


xdata = []
ydata = []

for x in root.iter():
  v = x.get("v")
  w = x.get("ws")
  f = x.get("f")
  if v and w and f and int(f)!=168:
    xdata.append( float(f)*1000000. / (float(v)*1000.))
    ydata.append( float(w) )


def k(x):
  return math.copysign( abs(x)**0.1 , x)

def floorsmooth(x,k):
  return math.floor(x) + (k(2.0*(x%1.0)-1.0)+1.0)/2.0

def g(a,m,c):
  return [ floorsmooth(m*x + c, k) for x in a ]

x0 = numpy.array( [100.0, 0] )

(r,c) = OP.curve_fit(g, numpy.array(xdata), numpy.array(ydata), x0)

nroot = ET.Element("clk_V_to_WS", { "m": "%6.3e"%r[0], "c": "%6.3e"%r[1] })

ET.SubElement(nroot,"desc").text = ( 
  "Fitting for m,c in ws = round(m * (freq/volt) + c)" )

cov = ET.SubElement(nroot,"covariance")

for r in c.tolist() :
  e = ET.SubElement(cov,"row")
  for s in r :
    ET.SubElement(e,"cell").text = str(s)

args.outfile.write( ET.tostring(nroot))


