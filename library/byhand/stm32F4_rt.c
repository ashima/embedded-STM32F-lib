#include <inttypes.h>
#include <stm32F4_rt.h>

//extern "C" {
// From link script:

#include <lddefs.h>

extern void Reset_Handler() __attribute__ ((weak,interrupt));
extern int main(int,char**);

void Reset_Handler()
  {
  register uint32_t *p, *q;

  for ( p = &__etext, q = &__data_start__ ; q < &__data_end__ ; )
    *q++ = *p++;
  
  for ( p = &__bss_start__ ; p < &__bss_end__ ; )
    *p++ = 0;

  main(0,(char**)0);
  }

//}
