#include <instances.h>
#include <clocks.h>
#include <clock_helpers.h>

#define DELAY 1000000

#ifdef DISCOVERY
enum { pinA=14, pinB = 15 };
typedef GPIOD::t t;
#else
enum { pinA=0, pinB = 1 };
typedef GPIOE::t t;
#endif

subregister<t,t::oMODER,   pinA,pinB> moder;
subregister<t,t::oOTYPER,  pinA,pinB> otr;
subregister<t,t::oOSPEEDER,pinA,pinB> ospeedr;
subregister<t,t::oPUPDR,   pinA,pinB> pupdr;
subregister<t,t::oODR,     pinA,pinB> odr;

SysClock<20000000> clk;

int main()
  {
  clk.enablePLL( calc_PLL<20000000, 168000000, 3300>(), mk_PRE<1,2,4>() );

  *RCC::GPIODEN = true;

  *moder   = 3; // Both Output
  *otr     = 0; // Both PullPull
  *ospeedr = 3; // Both 2MHz
  *pupdr   = 0; // Both no up/down

  *odr = 1;  // 14 = 1, 15 = 0

  while(1)
    {
    *odr = ~ *odr;

    for (volatile int i=0; i < DELAY; ++i)
      {}
    }
  return 0;
  }


