#ifndef ST_BASE_H
#define ST_BASE_H
#pragma once

#include <inttypes.h>
#include <assert.h>

struct normal_types
  {
  typedef ::uint32_t uint64_t[2];
  typedef ::uint32_t uint32_t;
  typedef ::uint16_t uint16_t;
  typedef ::uint8_t uint8_t;
  };

struct bitband_types
  {
  typedef ::uint32_t uint64_t[64];
  typedef ::uint32_t uint32_t[32];
  typedef ::uint32_t uint16_t[16];
  typedef ::uint32_t uint8_t[8];
  };

template <uint32_t min, uint32_t max>
struct range32
  {
  typedef uint32_t t;
  enum { t_lobit = 0, t_hibit = 31 };
  static const uint32_t MIN = min;
  static const uint32_t MAX = max;
  };

template <uint64_t min, uint64_t max>
struct range64
  {
  typedef uint64_t t;
  enum { t_lobit = 0, t_hibit = 63 };
  static const uint64_t MIN = min;
  static const uint64_t MAX = max;
  };

typedef range32<0,UINT32_MAX> UINT32_RANGE;
typedef range64<0,UINT64_MAX> UINT64_RANGE;

template<class P, int O,int F, int L, class R=UINT32_RANGE >
struct subregister {
  typedef typename R::t int_t;
  typedef P parent;
  //static_assert( F <= int_t::t_hibit && F >= int_t::t_lowbit )
  //static_assert( L <= int_t::t_hibit && L >= int_t::t_lowbit )
  enum { 
    offset = O,
    first = F,
    last = L,
    r = P::loc + O, 
  };

  static const int_t mask = ((int_t)2 << (L-F))-1 ;

  struct t {
    int_t operator=(int_t const & x) {
      assert( (x&mask) >= R::MIN && x <= R::MAX );
      (*(int_t*)r) = ((*(int_t*)r) & (~(mask << F))) | ((x&mask) << F);
      return x; 
      };
    operator const int_t () {
      return (int_t)( (*(volatile int_t*)r >> F) & mask) ;
      };
    };

  const t& operator*() const { return *(t*)0; }; // never survives to use.
  t&       operator*()       { return *(t*)0; }; // never survives to use.
  } ;

#define _V volatile

#endif
