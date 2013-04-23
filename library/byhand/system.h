#ifndef SYSTEM_H
#define SYSTEM_H
#pragma once

struct system_err {
  enum state_t
    { 
    None = 0,
    clk_HSE_fail = 0x10001, clk_HSI_fail , clk_PLL_fail,
    };
  };

#endif

