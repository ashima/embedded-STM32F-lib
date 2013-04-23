#include <instances.h>
#include <clocks.h>
#include <clock_helpers.h>

#define DELAY 1000000

SysClock<20000000> clk;

int main()
  {
  clk.enablePLL( calc_PLL<20000000, 168000000, 3300>(), mk_PRE<1,2,4>() );

  *RCC::GPIODEN = true;

  *GPIOD::MODER14   = *GPIOD::MODER15   = 1; // Outpu
  *GPIOD::OT14      = *GPIOD::OT15      = 0; // PullPull
  *GPIOD::OSPEEDR14 = *GPIOD::OSPEEDR15 = 1; // 2 MHz
  *GPIOD::PUPDR14   = *GPIOD::PUPDR15   = 0; // No up/down

  *GPIOD::ODR14 = true;
  *GPIOD::ODR15 = false;

  while(1)
    {
    *GPIOD::ODR14 = ~ *GPIOD::ODR14;
    *GPIOD::ODR15 = ~ *GPIOD::ODR15;

    for (volatile int i=0; i < DELAY; ++i)
      {}
    }
  return 0;
  }


