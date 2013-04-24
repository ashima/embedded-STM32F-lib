#include <instances.h>
#include <clocks.h>
#include <clock_helpers.h>

#define DELAY 1000000

SysClock<20000000> clk;

int main()
  {
  clk.enablePLL( calc_PLL<20000000, 168000000, 3300>(), mk_PRE<1,2,4>() );

  *RCC::GPIOEEN = true;

  *GPIOE::MODER0   = *GPIOE::MODER1   = 1;  //Output
  *GPIOE::OT0      = *GPIOE::OT1      = 0;  //PullPull
  *GPIOE::OSPEEDR0 = *GPIOE::OSPEEDR1 = 1;  // 2 Mhz
  *GPIOE::PUPDR0   = *GPIOE::PUPDR1   = 0;  // No up/down

  *GPIOE::ODR0  = true;
  *GPIOE::ODR1  = false;

  while(1)
    {
    *GPIOE::ODR0 = ~ *GPIOE::ODR0 ;
    *GPIOE::ODR1 = ~ *GPIOE::ODR1 ; 

    for (volatile int i=0; i < DELAY; ++i)
      {}
    }
  return 0;
  }


