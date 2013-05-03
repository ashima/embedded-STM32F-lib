#include <inttypes.h>

//#include <structures.h>
//#include <instances.h>
#include <clocks.h>
#include <clock_helpers.h>
#include <gpio.h>
#include <newlibstubs.h>

#include <cstdio>

/* Using usart2 on pins PD5 and PD6 at 115200 baud 8N1, no flowcontrol.
 */

uint16_t hexcharof(uint32_t x);

template<class U>
void myPutc(uint16_t c)
  {
  while( *U::TXE == 0 ) {}
  *U::DR = c;
  *U::TE = true;
  };

#define DELAY 1e6

enum {
  XTALFreq   = 20000000,   // Hz
  SysFreq    = 168000000,  // Hz
  supVoltage = 3300,       // mVolt.
  };

SysClock<XTALFreq>  clk;
typedef mk_subport<GPIOE,0,1> leds;

// Using printf So need the right stubs!
typedef newlibStubs<heapctl_simple, filectl_uartonly<USART2> > stubs;
MK_NEWLIB_STUBS(stubs)

int main()
  {
  volatile uint32_t i;
  uint32_t count = 0;

  typedef mk_subport<GPIOD,3,6> pins;
  typedef USART2 usart;

  clk.enablePLL( calc_PLL<XTALFreq, SysFreq, supVoltage>(), mk_PRE<1,2,4>() );

  *RCC::USART2EN = true;
  *RCC::GPIODEN  = true;
  *RCC::GPIOEEN  = true;

  *pins::mode   = rep32x2 * GPIO_mode_ALTFUNC ;    // Both AF.
  *pins::otype  = rep32x1 * GPIO_otype_PUSHPULL ;  // Both PushPull
  *pins::ospeed = rep32x2 * GPIO_ospeed_100MHZ ;   // Both 100MHz
  *pins::pupd   = rep32x2 * GPIO_pupd_UP ;         // Both pull Up
  *pins::af     = rep64x4 * 7 ; 
                     // GPIO_AF< USART3 >::af;

  *leds::mode   = rep32x2 * GPIO_mode_OUT ;        // Both Output
  *leds::otype  = rep32x1 * GPIO_otype_PUSHPULL ;  // Both PullPull
  *leds::ospeed = rep32x2 * GPIO_ospeed_2MHZ ;     // Both 2MHz
  *leds::pupd   = rep32x2 * GPIO_pupd_NONE ;       // Both no up/down

// p 748

  *usart::UE   = true;
  *usart::M    = 0;      // 8
  *usart::PCE  = false;  // N
  *usart::STOP = 0;      // 1
  *usart::CTSE = false;  // No flow cntl
  *usart::RTSE = false;  // No flow cntl

  int over8 = 0 ;
  int baud  = 115200 ;


  int j = 2 * busClock<usart::bus>::clk(clk) / baud;
  int ratio = (j >> 1) + (j & 1);

  *usart::OVER8        = over8;
  *usart::DIV_Mantissa = ratio >> (4-over8);      // integer part
  *usart::DIV_Fraction = ratio &  (15 >> over8);  // fractional part (right justified)

  while(1)
    {
    *leds::od = (count & 3);

    printf("%d...\n", count);

    for (i=0; i < DELAY; ++i)
      {}
    ++count;
    }

  return 0;
  }

uint16_t hexcharof(uint32_t x)
  {
  uint32_t y = x & 0x0f;
  return y + (uint32_t)( y >= 10 ? 'a'-10 : '0') ;
  }
