<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings" >

  <xsl:output method="text" omit-xml-declaration="no" indent="no" />

  <xsl:template match="/">
  <xsl:apply-templates select="infobase/peripherals"/>
  </xsl:template>

  <xsl:template match="peripherals">
/* 
   Auto generated, do not edit.
 */
#ifndef STRUCTURES_H
#define STRUCTURES_H

#include "st_base.h"

  <xsl:apply-templates select="peripheral"/>
#endif
  </xsl:template>

  <xsl:template match="peripheral">
template &lt;typename T,uint32_t L&gt;
struct <xsl:value-of select="@name"/>_rt {
  typedef T inttypes;
  enum { loc = L } ;
  <xsl:apply-templates select="register"/>
  };
<xsl:text>
</xsl:text>
template &lt;typename TYP,uint32_t LOC&gt;
struct <xsl:value-of select="@name"/>_st {
  typedef TYP inttypes;
  enum { loc = LOC } ;
<xsl:apply-templates select="subregister"/>
  };
  </xsl:template>

  <xsl:template match="register">
  _V typename T::uint32_t <xsl:value-of 
select="@short"/>; <xsl:if test="description"
> //?!&lt; <xsl:copy-of select="description/text()"/>
</xsl:if>
  </xsl:template>

  <xsl:template match="subregister">
<xsl:variable name="s" select="@parent"/>  static subregister&lt;<xsl:value-of 
select="../@name"/>_st,<xsl:value-of
select="../register[@short=$s]/@offset"/>,<xsl:value-of 
select="@first"/>,<xsl:value-of 
select="@last"/><xsl:if test="@min">,<xsl:value-of 
select="@min"/>,<xsl:value-of 
select="@max"/></xsl:if>&gt; <xsl:value-of select="@name"/> ;
</xsl:template>

</xsl:stylesheet>
