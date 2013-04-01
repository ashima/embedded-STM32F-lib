import sys
import argparse
import subprocess
from numpy import *
import pipes

def procargs() :
  p = argparse.ArgumentParser( description="Read a ppm table and output cells.")
  p.add_argument("-i", help="input file",dest='infile')
  p.add_argument("-o", help="output file name", dest='outfile' )
  p.add_argument("-p", type=int, required=True, help="output file name", dest='page' )
  p.add_argument("-t", help="grayscale threshold", dest='gthresh',default=64 )
  p.add_argument("-l", help="line length threshold", dest='lthresh',default=50 )
  p.add_argument("-bitmap", action="store_true",
       help = "dump working bitmap not debuging image.")
  p.add_argument("-checkcrop", action="store_true",
       help = "stop after finding croping rectangle, and output image.")
  p.add_argument("-checklines", action="store_true",
       help = "stop after finding lines, and output image.")
  p.add_argument("-checkdivs", action="store_true",
       help = "stop after finding dividors, and output image.")
  p.add_argument("-checkcells", action="store_true",
       help = "stop after finding cells, and output image.")
  return p.parse_args()

def col(a,x) :
  l = len(a)-1
  i = int (x *l)
  j = (x * l) % 1.0
  if i > l:
    i = l
  u = a[i,:]
  v = a[i+1,:]
  return u * (1.0-j) + (v * j)

def noncomment(fd):
  while True:
    x = fd.readline() 
    if x.startswith('#') :
      continue
    else:
      return x

def readPNM(fd):
  t = noncomment(fd)
  s = noncomment(fd)
  m = noncomment(fd) if not (t.startswith('P1') or t.startswith('P4')) else '1'
  data = fd.read()

  xs, ys = s.split()
  width = int(xs)
  height = int(ys)
  m = int(m)

  if m != 255 :
    print "Just want 8 bit pgms for now!"
  
  d = fromstring(data,dtype=uint8)
  d = reshape(d, (height,width) )
  return (m,width,height, d)

def writePNM(fd,img):
  s = img.shape
  m = 255
  if img.dtype == bool :
    img = img + uint8(0) 
    t = "P5"
    m = 1
  elif len(s) == 2 :
    t = "P5"
  else:
    t = "P6"
    
  fd.write( "%s\n%d %d\n%d\n" % (t, s[1],s[0],m) )
  fd.write( uint8(img).tostring() )


def dumpImage(args,bmp,img) :
  with (sys.stdout if args.outfile==None or 
         args.outfile=='-' else open(args.outfile,'w')) as ofd:
    writePNM(ofd, bmp if args.bitmap else img)
  ofd.close()

# main
args = procargs()
pg = args.page;

p = subprocess.Popen(
  ("pdftoppm -gray -r 300 -f %d -l %d %s " % (pg,pg,pipes.quote(args.infile))),
  stdin=subprocess.PIPE, stdout=subprocess.PIPE, shell=True )
#out = p.communicate()[0]

#with (sys.stdin if args.infile==None or 
       #args.infile=='-' else open(args.infile,'r')) as i:
(maxval, width, height, data) = readPNM(p.stdout)
#i.close()

bmp =  ( data[:,:] > args.gthresh )
img = zeros( (height,width,3) , dtype=uint8 )
img[:,:,0] = bmp*255
img[:,:,1] = bmp*255
img[:,:,2] = bmp*255

# find bounding box.
pad=1

t=0
while t < height and sum(bmp[t,:]==0) == 0 :
  t=t+1
if t > 0 :
  t=t-pad

b=height-1
while b > t and sum(bmp[b,:]==0) == 0 :
  b=b-pad
if b < height-1:
  b = b+1

l=0
while l < width and sum(bmp[:,l]==0) == 0 :
  l=l+pad
if l > 0 :
  l=l-1

r=width-1
while r > l and sum(bmp[:,r]==0) == 0 :
  r=r-pad
if r < width-1 :
  r=r+1
bmp[t,:] = 0
bmp[b,:] = 0
bmp[:,l] = 0
bmp[:,r] = 0

if args.checkcrop :
  dumpImage(args,bmp,img)
  sys.exit(0)

# Find all verticle or horizontal lines that
# are more than rlthresh long, these are considered
# lines on the table grid.

lthresh = int(args.lthresh)
vs = zeros(width, dtype=int)
for i in range(width) :
  dd = diff( where(bmp[:,i])[0] ) 
  if len(dd)>0:
    v = max ( dd )
    if v > lthresh :
      vs[i] = 1
  else:
# it was a solid black line.
    if bmp[0,i] == 0 :
      vs[i] = 1
      

#vd=[0,0]
vd=[]
vd.extend( where(diff(vs[:]))[0] +1 )
#vd.extend( [width,width] )
#print vd
hs = zeros(height, dtype=int)
for j in range(height) :
  dd = diff( where(bmp[j,:]==1)[0] )
  if len(dd) > 0 :
    h = max ( dd )
    if h > lthresh :
      hs[j] = 1
  else:
# it was a solid black line.
    if bmp[j,0] == 0 :
      hs[j] = 1

#hd=[0,0]
hd=[]
hd.extend(  where(diff(hs[:]==1))[0] +1 )
#hd.extend( [height,height] )


# at this point vd holds the x coordinate of vertical  and 
# hd holds the y coordinate of horizontal divider tansitions for each 
# vertical and horizontal lines in the table grid.
#
maxdiv=10
i=0
while i < len(vd) :
#  print "div @ ",vd[i],vd[i+1], "d=",vd[i+1]-vd[i]
  if vd[i+1]-vd[i] > maxdiv :
    vd.pop(i)
    vd.pop(i)
  else:
    i=i+2
#print vd
j = 0 
#print hd
while j < len(hd):
#  print "div @ ",hd[j],hd[j+1], "d=",hd[j+1]-hd[j]
  if hd[j+1]-hd[j] > maxdiv :
    hd.pop(j)
    hd.pop(j)
  else:
    j=j+2
#print hd
if args.checklines :
  for i in vd :
    img[:,i] = [255,0,0] # red

  for j in hd :
    img[j,:] = [0,0,255] # blue
  dumpImage(args,bmp,img)
  sys.exit(0)

def isDiv(a, l,r,t,b) :
        # if any col or row (in axis) is all zeros ...
  return sum( sum(bmp[t:b, l:r], axis=a)==0 ) >0 

if args.checkdivs :
  img = img / 2
  for j in range(0,len(hd),2):
    for i in range(0,len(vd),2):
      if i>0 :
        (l,r,t,b) = (vd[i-1], vd[i],   hd[j],   hd[j+1]) 
        img[ t:b, l:r, 1 ] = 192
        if isDiv(1, l,r,t,b) :
          img[ t:b, l:r, 0 ] = 0
          img[ t:b, l:r, 2 ] = 255
        
      if j>0 :
        (l,r,t,b) = (vd[i],   vd[i+1], hd[j-1], hd[j] )
        img[ t:b, l:r, 1 ] = 128
        if isDiv(0, l,r,t,b) :
          img[ t:b, l:r, 0 ] = 255
          img[ t:b, l:r, 2 ] = 0

  dumpImage(args,bmp,img)
  sys.exit(0)

cells =[] 
touched = zeros( (len(hd), len(vd)),dtype=bool )
#j = 0
#while j*2+2 < len (hd) :
  #i = 0
  #while i*2+2 < len(vd) :
    #u = 1
    #v = 1
    #if not touched[j,i] :
      #while 2+(i+u)*2 < len(vd) and \
          #not isDiv( 0, vd[ 2*(i+u) ], vd[ 2*(i+u)+1],
             #hd[ 2*(j+v)-1 ], hd[ 2*(j+v) ] ):
        #u=u+1
      #while 2+(j+v)*2 < len(hd) and \
          #not isDiv( 1, vd[ 2*(i+u)-1 ], vd[ 2*(i+u)],
             #hd[ 2*(j+v) ], hd[ 2*(j+v)+1 ] ):
        #v=v+1
      #cells.append( (i,j,u,v) )
      #touched[ j:j+v, i:i+u] = True
    #i = i+1
  #j=j+1
j = 0
while j*2+2 < len (hd) :
  i = 0
  while i*2+2 < len(vd) :
    u = 1
    v = 1
    if not touched[j,i] :
      while 2+(i+u)*2 < len(vd) and \
          not isDiv( 0, vd[ 2*(i+u) ], vd[ 2*(i+u)+1],
             hd[ 2*(j+v)-1 ], hd[ 2*(j+v) ] ):
        u=u+1
      bot = False
      while 2+(j+v)*2 < len(hd) and not bot :
        bot = False
        for k in range(1,u+1) :
          bot |= isDiv( 1, vd[ 2*(i+k)-1 ], vd[ 2*(i+k)],
             hd[ 2*(j+v) ], hd[ 2*(j+v)+1 ] )
        if not bot :
          v=v+1
      cells.append( (i,j,u,v) )
      touched[ j:j+v, i:i+u] = True
    i = i+1
  j=j+1

if args.checkcells :
  img = img / 2
  a = array([ [255,0,0],[255,255,0],[0,255,0],[0,255,255],[0,0,255] ])
  nc = len(cells)+0.

  for k in range(len(cells)):
    (i,j,u,v) = cells[k]
    (l,r,t,b) = ( vd[2*i+1] , vd[ 2*(i+u) ], hd[2*j+1], hd[2*(j+v)] )
    img[ t:b, l:r ] += col(a,k/nc)/2
  dumpImage(args,bmp,img)
  sys.exit(0)


def getCell( (i,j,u,v) ):
  (l,r,t,b) = ( vd[2*i+1] , vd[ 2*(i+u) ], hd[2*j+1], hd[2*(j+v)] )
  p = subprocess.Popen(
   ("pdftotext -r 300 -x %d -y %d -W %d -H %d -layout -nopgbrk -f %d -l %d %s -" % 
         (l,t,r-l,b-t, pg, pg, pipes.quote(args.infile) ) ),
    stdout=subprocess.PIPE, shell=True )
  return p.communicate()[0]

cont = map(getCell, cells)

oj = 0 
print "<table border='1' cellspacing='0'><tr>"
for k in range(len(cells)):
  (i,j,u,v) = cells[k]
  if j > oj :
    print "</tr></tr>"
    oj = j
  s = "<td "
  if u>1 :
    s += "colspan=%d " % u
  if v>1 :
    s += "rowspan=%d " % v
  s += ">%s</td>" % cont[k]
  print s
print "</tr></table>"

#  writePNM(p.stdin, bmp[t:b, l:r] )
#  p = subprocess.Popen("ocrad -l ", stdin=subprocess.PIPE, stdout=subprocess.PIPE, shell=True )
#  writePNM(p.stdin, bmp[t:b, l:r] )
  #print "<<<",k, out , ">>>"

