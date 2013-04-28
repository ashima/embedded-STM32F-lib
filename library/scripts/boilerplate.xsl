<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  extension-element-prefixes="u" >

  <xsl:import href="utils.xsl"/>

  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />

  <xsl:template match="/">/**
  \brief      <xsl:value-of select="$file-desc"/>
  \copyright  Copyright (C) 2013 Ashima Research. All rights reserved.
              Distributed under the MIT Expat License. See LICENSE file.
              https://github.com/ashima/embedded-STM32F-lib

  \remark     Auto-generated file. Do not edit.

*/
<xsl:variable name="guard">LIBSTM32F_<xsl:value-of 
select="u:uppercase(u:nameify($target))"/></xsl:variable>
#ifndef <xsl:value-of select="$guard"/>
#define <xsl:value-of select="$guard"/>
#pragma once
<xsl:apply-templates/>
// <xsl:value-of select="$guard"/>
#endif
  </xsl:template> 

</xsl:stylesheet>

