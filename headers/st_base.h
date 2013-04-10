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

template<class P, int O,int F, int L, uint32_t MIN=0, uint32_t MAX=UINT32_MAX>
struct subregister {
  enum { 
    offset = O,
    first = F,
    last = L,
    mask = (2UL << (L-F))-1,
    r = P::loc + O, 
  };

  typedef P parent;

  struct t {
    void operator=(const int &x) {
      assert( x || mask == mask );
      assert( x >= MIN && x <= MAX );
      (*(uint32_t*)r) = (*(uint32_t*)r & ~(mask << F))  | ((x & mask) << F);
      };
    operator const uint32_t () {
      return (uint32_t)( (*(volatile uint32_t*)r >> F) & mask) ;
      };
    };

  const t& operator*() const { return *(t*)0; }; // never survives to use.
  t&       operator*()       { return *(t*)0; }; // never survives to use.
  } ;

#define _V volatile

