#include <instances.h>

#ifdef DISCOVERY_BRD
#  define EN            RCC::GPIODEN

#  define PINA_MODE     GPIOD::MODER14
#  define PINA_OT       GPIOD::OT14
#  define PINA_OSPEEDR  GPIOD::OSPEEDR14
#  define PINA_PUPDR    GPIOD::PUPDR14
#  define PINA_ODR      GPIOD::ODR14

#  define PINB_MODE     GPIOD::MODER15
#  define PINB_OT       GPIOD::OT15
#  define PINB_OSPEEDR  GPIOD::OSPEEDR15
#  define PINB_PUPDR    GPIOD::PUPDR15
#  define PINB_ODR      GPIOD::ODR15
#else
#  define EN            RCC::GPIOEEN

#  define PINA_MODE     GPIOE::MODER0
#  define PINA_OT       GPIOE::OT0
#  define PINA_OSPEEDR  GPIOE::OSPEEDR0
#  define PINA_PUPDR    GPIOE::PUPDR0
#  define PINA_ODR      GPIOE::ODR0

#  define PINB_MODE     GPIOE::MODER1
#  define PINB_OT       GPIOE::OT1
#  define PINB_OSPEEDR  GPIOE::OSPEEDR1
#  define PINB_PUPDR    GPIOE::PUPDR1
#  define PINB_ODR      GPIOE::ODR1
#endif

#define DELAY 1000000
int main();

extern
void Reset_Handler()
  {
  main();
  }

int main()
  {
  *EN = true;

  *PINA_MODE    = *PINB_MODE    = 1;  // Output
  *PINA_OT      = *PINB_OT      = 0;  // PullPull
  *PINA_OSPEEDR = *PINB_OSPEEDR = 1;  // 2 MHz
  *PINA_PUPDR   = *PINB_PUPDR   = 0;  // No up/down

  *PINA_ODR  = true;
  *PINB_ODR  = false;

  while(1)
    {
    *PINA_ODR = ~ *PINA_ODR;
    *PINB_ODR = ~ *PINB_ODR;

    for (volatile int i=0; i < DELAY; ++i)
      {}
    }
  return 0;
  }

void exit(int x)
  {
  while(1) {}
  }

