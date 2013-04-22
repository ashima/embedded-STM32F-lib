#include <inttypes.h>
#include <stm32F4_rt.h>

//extern "C" {
// From link script:

extern uint32_t __data_start__;
extern uint32_t __StackTop;
extern uint32_t __etext;
extern uint32_t __bss_end__;
extern uint32_t __HeapLimit;
extern uint32_t __StackLimit;
extern uint32_t __end__;
extern uint32_t __data_end__;
extern uint32_t __bss_start__;
extern uint32_t __stack;

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
