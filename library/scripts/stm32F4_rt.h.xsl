<?xml version="1.0"?>
<!--
  Description : Generate startup files.
       Author : Ian McEwan, Ashima Research.
   Maintainer : ijm
      Lastmod : 20130415 (ijm)
      License : Copyright (C) 2013 Ashima Research. All rights reserved.
                Distributed under the MIT Expat License. See LICENSE file.
                https://github.com/ashima/embedded-STM32F-lib
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://exslt.org/functions"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  xmlns:exsl="http://exslt.org/common"
  xmlns:str="http://exslt.org/strings" 
  extension-element-prefixes="str fn u exsl"
>
  <xsl:import href="startupCommon.xsl"/>

  <xsl:output method="text" omit-xml-declaration="no" indent="no" />

  <xsl:template match="/">
  <xsl:apply-templates select="infobase/runtime"/>
  </xsl:template>


  <xsl:template match="runtime">
    <xsl:call-template name="boilerplate">
     <xsl:with-param name="desc">Startup C runtime. Header file.</xsl:with-param>
    </xsl:call-template>

  <xsl:variable name="last" select="u:toNum(IRQBranchTable/row[position()=last()]/@address)" />
  <xsl:variable name="rows" select="IRQBranchTable" />
#ifndef STM32F4_RT_H
#define STM32F4_RT_H
#pragma once

#include &lt;inttypes.h&gt;

typedef void (*isr_fp)();

typedef struct isr_vector_s  {
  struct {
    uint32_t *stackpointer;
<xsl:call-template name="isrlist">
    <xsl:with-param name="type" select="'    isr_fp'"/>
    <xsl:with-param name="sep" select="';'"/>
    <xsl:with-param name="npc" select="'1'"/>
    <xsl:with-param name="addrs" select="u:range('',4,60,4)" />
  </xsl:call-template>
    } core;
  struct {
<xsl:call-template name="isrlist">
    <xsl:with-param name="type" select="'    isr_fp'"/>
    <xsl:with-param name="sep" select="';'"/>
    <xsl:with-param name="npc" select="'1'"/>
    <xsl:with-param name="addrs" select="u:range('',64,$last,4)" />
  </xsl:call-template>
    } ext;
  } isr_vector_t ;

#define ATT_ISR __attribute__ ((interrupt))

<xsl:call-template name="isrlist">
    <xsl:with-param name="type" select="'  void '"/>
    <xsl:with-param name="sep" select="'() ATT_ISR;'"/>
    <xsl:with-param name="npc" select="1"/>
    <xsl:with-param name="addrs" select="u:range('',4,$last,4)" />
  </xsl:call-template>
#endif
  </xsl:template>


</xsl:stylesheet>
