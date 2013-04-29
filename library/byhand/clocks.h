#ifndef CLOCKS_H
#define CLOCKS_H
#pragma once

#include <inttypes.h>
#include <system.h>
#include <structures.h>
#include <instances.h>

#include <clktree.h>
// Should move this to a utils. or something.
template<class T>
inline bool waitFor(T reg, uint32_t timeout)
  {
  bool r;

  do --timeout;
  while ( (r = (0 == *reg)) && timeout );

  return r;
  }

//template<uint32_t Hse,uint32_t Lse=0, uint32_t I2s=0>

template<uint32_t Hse, uint32_t Lse=0, uint32_t I2s=0>
class SysClock : public clkReadTree<Hse, Lse, I2s>
  {

  private:
  enum 
    { 
    HS_TIMEOUT  = 1<<11,
    PLL_TIMEOUT = 1<<10
    };
  public:
  //static const int HSE() { return Hse; }
  //static const int LSE() { return Lse; }
  //static const int I2S_CKIN() { return I2s; }


  void clkToInitState()
    {
    *RCC::HSION = true;
    RCC_s.CFGR = 0;
    *RCC::HSEON = false;
    *RCC::CSSON = false;
    *RCC::PLLON = false;
    *RCC::HSEBYP = false;
    RCC_s.CIR = 0;
    } 

/* 
   group PLL:  N,M,P,Q, IC,DC,WS
   group PRE:  HPRE, PPRE1, PPRE2
*/
  template<class PLL, class PRE> 
  system_err::state_t enablePLL(const PLL &pll, const PRE &pre)
    {
    if (1 == pll.SRC) // HSE
      {
      *RCC::HSEON = true;
 //     *RCC::HSEBYP = src.BYP;
 
      if (waitFor( RCC::HSERDY , HS_TIMEOUT) )
       return system_err::clk_HSE_fail ; // HSE didn't come up.
      }
    else
      { // HSI
      *RCC::HSION = true;

      if (waitFor( RCC::HSIRDY , HS_TIMEOUT) )
       return system_err::clk_HSI_fail ; // HSI didn't come up.
      }
  
    *RCC::PWREN  = true;
    *RCC::HPRE   = pre.HPRE;
    *RCC::PPRE1  = pre.PPRE1;
    *RCC::PPRE2  = pre.PPRE2;
  
    *RCC::PLLM   = pll.M;
    *RCC::PLLN   = pll.N;
    *RCC::PLLP   = (pll.P /2)-1;
    *RCC::PLLQ   = pll.Q;
    *RCC::PLLSRC = pll.SRC ;
    *RCC::PLLON  = true;
  
    if (waitFor( RCC::PLLRDY , PLL_TIMEOUT) )
      return system_err::clk_PLL_fail ; // PLL didn't come up.
  
    *FLASH::ICEN = pll.IC ;
    *FLASH::DCEN = pll.DC ;
    *FLASH::LATENCY = pll.WS ;

    *RCC::SW = 2;       // SysClk is PLL

    return system_err::None;
    }


  };

template<uint32_t m,uint32_t n, uint32_t p, uint32_t q, uint32_t ws>
struct mk_PLL
  {
  enum { M = m, N = n, P = p, Q = q, WS = ws };
  };

// Allowed values for H from page 129, PREE1 and 2 from page 128 of DM00031020
template<uint32_t H,uint32_t P1, uint32_t P2,
  bool Hok  = 
    (H  & (H-1))==0 & H !=0 & H != 32 & H <= 512 &
    (P1 & (P1-1))==0 & P1!=0 & P1 <= 16 & P1 >= 2 &
    (P2 & (P2-1))==0 & P2!=0 & P2 <= 16 & P2 >= 2 >
struct mk_PRE
  {
  template<uint32_t L>
  struct log_ish {
    enum 
      {
      i =  L == 2 ? 0  : L == 4   ? 1 : L == 8   ? 2 : L == 16 ? 3 :
           L == 64 ? 4 : L == 128 ? 5 : L == 256 ? 6 : 7
      };
    };

  enum
    { 
    HPRE  = H ==1? 0 : (8 & log_ish<H>::i ),
    PPRE1 = P1==1? 0 : (4 & log_ish<P1>::i ),
    PPRE2 = P2==1? 0 : (4 & log_ish<P2>::i )
    };
  };

template<uint32_t H,uint32_t P1, uint32_t P2>
struct mk_PRE<H,P1,P2,0>
  {
// Need to throguh a more useful error here.
//  Invalid_value_for_H_P1_or_P2 ;
  };

#endif
