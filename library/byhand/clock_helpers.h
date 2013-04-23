
#include "meta_script.h"


namespace MS = meta_script;

template<int XTAL, int HCLK>
struct mk_PLL
  {
  enum 
    { 
    vco_max = 432000000,
    vco_min = 192000000,
    clk48   = 48000000
    };

  //  let testp p = t*p < vco_max && t*p > vco_min
  template<class P> struct testp {
    enum { b = (P::i*HCLK < vco_max ) && (P::i*HCLK > vco_min)  }; 
    };

  //  and testm m = (x/m+1) / 1_000_001 == 1 
  template<class M> struct testm {
    enum { b = ((XTAL/M::i+1) / 1000001 == 1 ) };
    };
  //  and testn (n,_,_,_,_) =  n < 432 && n > 192
  template<class N> struct testn {
    enum { b = N::N < 432 && N::N > 192 };
    };

  // and tests (_,_,_,d1,e1) (_,_,_,d2,e2) = if d1=e1 then e1>e2 else d1<d2
  template<class A,class B> struct tests {
    enum { d1 = A::delta, d2=B::delta,
           e1 = A::p_in,  e2=B::p_in };
    enum { b = (d1==e1 ? e1>e2 : d1<d2) };
    };
  //  and calcn (p,m) = let n = t*p*m/x in (n,p,m,t-x*n/m/p,x/m)
  template<class A> struct calcn {
    struct r { enum {
      t     = HCLK     >> 6,  // lose some precision to fit in 32bits.
      x     = XTAL     >> 6,
      u     = clk48    >> 6,
      P     = A::a::i,
      M     = A::b::i,
      p_in  = x/M,           // PLL input
      N     = t * P * M / x, // target N.
      Q     = x * N /M /u,   // target Q for PLL48CLK
      s     = x * N /M /P,   // actual sysclk
      delta = t - s
      }; };
    };

  //  and ps = range (2,10,2) 
  typedef MS::range<2,10,2>::l ps;
  //  and ms = range (2,64,1)
  typedef MS::range<2,64>::l ms;
  //  in
  //  let possible_p = List.filter (testp) ps
  typedef typename MS::filter<testp, ps>::l possible_p;
  //  and possible_m = List.filter (testm) ms
  typedef typename MS::filter<testm, ms>::l possible_m;
  //  in
  //  let tmp1 = product possible_p possible_m
  typedef typename MS::product<possible_p, possible_m>::l tmp1;
  //  in
  //  let tmp2 = map calcn tmp1
  typedef typename MS::map<calcn, tmp1>::l tmp2;
  //  in
  //  let tmp3 = filter testn tmp2
  typedef typename MS::filter<testn, tmp2>::l tmp3;
  //  in
  //  let result::_ = sort tests tmp3
  typedef typename MS::sort<tests, tmp3>::l::h result;

  enum {
    P     = result::P,
    M     = result::M,
    p_in  = result::p_in,
    N     = result::N,
    Q     = result::Q,
    s     = result::s,
    delta = result::delta,
    BYP   = false, // no bypass.
    SRC   = 1      // HSE on.
    };
  };

/*
 * calculate the number of Wait states needed for the flash controler
 * given the HCLK (Hz) and supply voltage (mV).
 */
template<int HCLK, int mV>
struct mk_flash
  {
   enum {
    IC = true,
    DC = true,
    WS = int((1.006e-04 *HCLK)/mV -4.663e-01 + 0.5) //!< derived from Table 7. p63 DM00031020.pdf 
    };
  };


