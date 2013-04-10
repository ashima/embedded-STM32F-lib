<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings" >

  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />

  <xsl:template match="/">
/* Memory map for <xsl:value-of select="@name"/>.
   Auto generated, do not edit.
 */

#include "memory.h"
#include "structures.h"

#define DECLARE_PERIPH(NAME,CLASS,INTS,BUS) \
  typedef CLASS##_st&lt;INTS, memMap::NAME&gt; NAME ; \
  typedef CLASS##_rt&lt;INTS, memMap::NAME&gt; NAME##_t ; \
  NAME##_t &amp;NAME##_s = *(NAME##_t*)(NAME##_t::loc) ;

<xsl:apply-templates select="/all/memory-map/block">
  <xsl:with-param name="indent" select="'      '"/>
  <xsl:with-param name="bb" select="0"/>
</xsl:apply-templates>
  </xsl:template>

  <xsl:template match="block"><xsl:param 
    name="bb"/><xsl:apply-templates select="block|instance">
      <xsl:with-param name="bb" select="$bb"/>
    </xsl:apply-templates><xsl:if test="@bb"><xsl:apply-templates 
      select="block|instance">
      <xsl:with-param name="bb" select="1"/>
    </xsl:apply-templates></xsl:if></xsl:template>

  <xsl:template match="block[@class='RCC' or @class='DMA' or @class='DMA_S' or @class='GPIO' or @class='FLASH']"><xsl:param 
    name="bb"/>DECLARE_PERIPH(<xsl:value-of 
select="@name"/><xsl:if test="$bb=1">_BB</xsl:if>, <xsl:value-of 
select="@class"/>, <xsl:choose>
<xsl:when test="$bb=1">bitband_types</xsl:when>
<xsl:otherwise>normal_types</xsl:otherwise>
</xsl:choose>, <xsl:value-of 
select="../@name"/>);<xsl:text>
</xsl:text></xsl:template>
  
</xsl:stylesheet>
