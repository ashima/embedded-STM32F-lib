#include <inttypes.h>

#include <structures.h>
#include <instances.h>
#include <clocks.h>
#include <clock_helpers.h>
#include <gpio.h>

/* Using usart2 on pins PD5 and PD6 at 9600 baud 8N1, no flowcontrol.
 */

uint16_t hexcharof(uint32_t x);

template<class U>
void myPutc(uint16_t c)
  {
  while( *U::TXE == 0 ) {}
  *U::DR = c;
  };

#define DELAY 1e7

enum {
  XTALFreq   = 20000000,   // Hz
  SysFreq    = 168000000,  // Hz
  supVoltage = 3300,       // mVolt.
  };

SysClock<XTALFreq>  clk;

void main()
  {
  volatile uint32_t i;
  uint32_t count = 0;

  typedef mk_subport<GPIOD,3,6> pins;
  typedef USART2 usart;

  clk.enablePLL( calc_PLL<XTALFreq, SysFreq, supVoltage>(), mk_PRE<1,2,4>() );

  *RCC::USART2 = true;
  *RCC::GPIOD  = true;

  *pins::mode   = rep32x2 * GPIO_mode_ALTFUNC ;    // Both AF.
  *pins::otype  = rep32x1 * GPIO_otype_PUSHPULL ;  // Both PushPull
  *pins::ospeed = rep32x2 * GPIO_ospeed_100MHZ ;   // Both 100MHz
  *pins::pupd   = rep32x2 * GPIO_pupd_UP ;         // Both pull Up
  *pins::af = rep64 * 7 ; 
                     // GPIO_AF< USART3 >::af;

// p 748

  *usart::UE   = true;
  *usart::M    = 0;      // 8
  *usart::PCE  = false;  // N
  *usart::STOP = 0;      // 1
  *usart::CTSE = false;  // No flow cntl
  *usart::RTSE = false;  // No flow cntl

  int over8 = 0 ;
  int baud  = 9600 ;

  int j = 2 * usart::bus::clk() / baud;
  int ratio = (j >> 1) + (j & 1);

  *usart::OVER8        = over8;
  *usart::DIV_Mantissa = ratio >> (4-over8);      // integer part
  *usart::DIV_Fraction = ratio &  (15 >> over8);  // fractional part (right justified)

  while(1)
    {
    myPutc<usart>( hexcharof( count >> 28 ));
    myPutc<usart>( hexcharof( count >> 24 ));
    myPutc<usart>( hexcharof( count >> 20 ));
    myPutc<usart>( hexcharof( count >> 16 ));
    myPutc<usart>( hexcharof( count >> 12 ));
    myPutc<usart>( hexcharof( count >> 8 ));
    myPutc<usart>( hexcharof( count >> 4 ));
    myPutc<usart>( hexcharof( count >> 0 ));
    myPutc<usart>( (uint16_t)'\n' );
    for (i=0; i < DELAY; ++i)
      {}
    ++count;
    }
  }



uint16_t hexcharof(uint32_t x)
  {
  uint32_t y = x & 0x0f;
  return y + (uint32_t)( y >= 10 ? 'a'-10 : '0') ;
  }
