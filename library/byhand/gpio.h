#ifndef GPIO_H
#define GPIO_H

// Set up sub registers for GPIO as the user wants.
// subregister< parent_type, offset, first-bit, last-bit >
template<typename PORT, int Lowbit, int Highbit>
struct mk_subport
  {
  typedef PORT t;
  enum
    {
    lowbit   = Lowbit,   highbit  = Highbit,
    lowbit2  = Lowbit*2, highbit2 = (Highbit+1)*2-1,
    lowbit4  = Lowbit*4, highbit4 = (Highbit+1)*4-1,
    };
  
  static subregister<t, t::oMODER,   lowbit2 , highbit2  > mode;
  static subregister<t, t::oOTYPER,  lowbit  , highbit   > otype;
  static subregister<t, t::oOSPEEDR, lowbit2 , highbit2  > ospeed;
  static subregister<t, t::oPUPDR,   lowbit2 , highbit2  > pupd;
  static subregister<t, t::oODR,     lowbit  , highbit   > od;
  static subregister<t, t::oIDR,     lowbit  , highbit   > id;
  static subregister<t, t::oBSRR,    lowbit  , highbit   > bsr;
  static subregister<t, t::oLCKR,    lowbit  , highbit   > lck;
  static subregister<t, t::oAFRL,    lowbit4 , highbit4, UINT64_RANGE  > af;
  };

enum 
  {
  rep16x1  = 0xFFFF,
  rep16x2  = 0x5555,
  rep16x4  = 0x1111,
  rep16x8  = 0x0101,
  };

enum 
  {
  rep32x1  = 0xFFFFFFFF,
  rep32x2  = 0x55555555,
  rep32x4  = 0x11111111,
  rep32x8  = 0x01010101,
  rep32x16 = 0x00010001,
  };

enum 
  {
  rep64x1  = 0xFFFFFFFFFFFFFFFF,
  rep64x2  = 0x5555555555555555,
  rep64x4  = 0x1111111111111111,
  rep64x8  = 0x0101010101010101,
  rep64x16 = 0x0001000100010001,
  rep64x32 = 0x0000000100000001,
  };

enum GPIO_mode // p198 DM00031020
  {
  GPIO_mode_IN      = 0,
  GPIO_mode_OUT     = 1,
  GPIO_mode_ALTFUNC = 2,
  GPIO_mode_ANALOG  = 3,
  } ;

enum GPIO_otype // p199 DM00031020
  {
  GPIO_otype_PUSHPULL = 0,
  GPIO_otype_OPENDRAIN = 1,
  };

enum GPIO_speed // p199 DM00031020
  {
  GPIO_ospeed_2MHZ   = 0,
  GPIO_ospeed_25MHZ  = 1,
  GPIO_ospeed_50MHZ  = 2,
  GPIO_ospeed_100MHZ = 3,
  };

enum GPIO_pupd // p200 DM00031020
  {
  GPIO_pupd_NONE = 0,
  GPIO_pupd_UP   = 1,
  GPIO_pupd_DOWN = 2,
  };


// Derived from Figure 18, p190 DM00031020 and others.
enum GPIO_af
  {
  GPIO_af_SYSTEM   = 0,
  GPIO_af_AF14     = 14,
  GPIO_af_EVENTOUT = 15,
  };
 
// Traits for Alternate function.
struct GPIO_SYSTEM { };
struct GPIO_EVENTOUT { };
struct GPIO_AF14 { };

template<class T> struct GPIO_AF {};

template<> struct GPIO_AF<GPIO_SYSTEM>   { enum {af = 0} ; };
template<> struct GPIO_AF<GPIO_AF14>     { enum {af = 14} ; };
template<> struct GPIO_AF<GPIO_EVENTOUT> { enum {af = 15} ; };


#endif
