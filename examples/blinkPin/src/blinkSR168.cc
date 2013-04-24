#include <instances.h>
#include <clocks.h>
#include <clock_helpers.h>

#define DELAY 1000000

#ifdef DISCOVERY
enum { pinA=14, pinB = 15 };
typedef GPIOD::t t;
#define EN RCC::GPIODEN
#else
enum { pinA=0, pinB = 1 };
typedef GPIOE::t t;
#define EN RCC::GPIOEEN
#endif

//Example of setting up subregisters.
// subregister< parent_type, offset, first-bit, last-bit >

subregister<t, t::oMODER,   pinA*2, pinB*2> moder;
subregister<t, t::oOTYPER,  pinA  , pinB  > otr;
subregister<t, t::oOSPEEDER,pinA*2, pinB*2> ospeedr;
subregister<t, t::oPUPDR,   pinA*2, pinB*2> pupdr;
subregister<t, t::oODR,     pinA  , pinB  > odr;

enum {
  XTALFreq = 20000000,   // Hz
  SysFreq  = 168000000,  // Hz
  supVoltage = 3300,   // mVolt.
  };

SysClock<XTALFreq>  clk;

int main()
  {
  clk.enablePLL( calc_PLL<XTALFreq, SysFreq, supVoltage>(), mk_PRE<1,2,4>() );

  *EN = true;
  *GPIOE::ODR0  = true;

  *moder   = 0x05; // Both Output
  *otr     = 0x00; // Both PullPull
  *ospeedr = 0x05; // Both 2MHz
  *pupdr   = 0x00; // Both no up/down

  *odr = 1;  // 14 = 1, 15 = 0

  while(1)
    {
    *odr = ~ *odr;

    for (volatile int i=0; i < DELAY; ++i)
      {}
    }
  return 0;
  }


