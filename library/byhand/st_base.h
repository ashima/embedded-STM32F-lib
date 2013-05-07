#ifndef ST_BASE_H
#define ST_BASE_H
#pragma once

#include <inttypes.h>
#include <assert.h>
/**
  \brief Integer types to use for normal non-bitbanded registers
 */
struct normal_types
  {
  typedef ::uint32_t uint64_t[2];
  typedef ::uint32_t uint32_t;
  typedef ::uint16_t uint16_t;
  typedef ::uint8_t uint8_t;
  };

/**
  \brief Integer types to use for bitbanded reagons
 */
struct bitband_types
  {
  typedef ::uint32_t uint64_t[64];
  typedef ::uint32_t uint32_t[32];
  typedef ::uint32_t uint16_t[16];
  typedef ::uint32_t uint8_t[8];
  };

/**
  \brief 'range' trait for 32 bit numbers, contains ::MIN and ::MAX
  */
template <uint32_t min, uint32_t max>
struct range32
  {
  typedef uint32_t t;
  enum { t_lobit = 0, t_hibit = 31 };
  static const uint32_t MIN = min; //!< Minium inclusive value
  static const uint32_t MAX = max; //!< Maximum inclusive value
  };

/**
  \brief 'range' trait for 64 bit numbers, contains ::MIN and ::MAX
  */
template <uint64_t min, uint64_t max>
struct range64
  {
  typedef uint64_t t;
  enum { t_lobit = 0, t_hibit = 63 };
  static const uint64_t MIN = min; //!< Minimum inclusive value
  static const uint64_t MAX = max; //!< Maximum inclusive value
  };

typedef range32<0,UINT32_MAX> UINT32_RANGE; //!< Default range of 32 bit unsigned integers
typedef range64<0,UINT64_MAX> UINT64_RANGE; //!< Default range of 64 bit unsigned integers

/**
 \brief Subregister class. Maps a static subset of bits in a register to 
        an object that acts like an ordinary integer.
 */
template<class P,  //!< Parent (Should be the peripheral type)
          int O,   //!< Offset into the peripherals register map
          int F,   //!< First bit (inclusive)
          int L,   //!< Last bit (inclusive)
          class R=UINT32_RANGE  //!< Static range to check for if known.
          >
struct subregister {
  typedef typename R::t int_t; //!< The type of the underlying integer register.
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

  /**
    \brief helper object that does the actulay bitbanging.
  */
  struct t {
    int_t operator=(int_t const & x) {
      assert( (x&mask) >= R::MIN && x <= R::MAX );
      (*(int_t*)r) = ((*(int_t*)r) & (~(mask << F))) | ((x&mask) << F);
      return x; 
      };
    operator int_t () {
      return (int_t)( (*(volatile int_t*)r >> F) & mask) ;
      };
    };

  const t& operator*() const { return *(t*)0; };
  t&       operator*()       { return *(t*)0; };
  } ;

#define _V volatile

#endif
