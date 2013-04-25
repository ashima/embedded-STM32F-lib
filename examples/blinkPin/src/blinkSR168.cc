#include <instances.h>
#include <clocks.h>
#include <clock_helpers.h>
#include <gpio.h>

#define DELAY 1000000

#ifdef DISCOVERY
typedef mk_subport<GPIOD,14,15> leds;
#define EN RCC::GPIODEN
#else
typedef mk_subport<GPIOE,0,1> leds;
#define EN RCC::GPIOEEN
#endif

enum {
  XTALFreq   = 20000000,   // Hz
  SysFreq    = 168000000,  // Hz
  supVoltage = 3300,       // mVolt.
  };

SysClock<XTALFreq>  clk;

int main()
  {
  clk.enablePLL( calc_PLL<XTALFreq, SysFreq, supVoltage>(), mk_PRE<1,2,4>() );

  *EN = true;

  *leds::mode   = 5; //rep32x2 * GPIO_mode_OUT ;        // Both Output
  *leds::otype  = 0; //rep32x1 * GPIO_otype_PUSHPULL ;  // Both PullPull
  *leds::ospeed = 5; // rep32x2 * GPIO_ospeed_2MHZ ;     // Both 2MHz
  *leds::pupd   = 0; //rep32x2 * GPIO_pupd_NONE ;       // Both no up/down
//  *leds::af     = rep64x4 * GPIO_af_SYSTEM ;       // pins are gpio.

  *leds::od = 2;  // 14 = 1, 15 = 0

  while(1)
    {
    *leds::od = ~ *leds::od ;

    for (volatile int i=0; i < DELAY; ++i)
      {}
    }
  return 0;
  }


