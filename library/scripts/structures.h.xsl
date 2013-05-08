<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  xmlns:str="http://exslt.org/strings"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="str u exsl"
 >
  <xsl:import href="utils.xsl"/>
  <xsl:import href="boilerplate.xsl"/>

  <xsl:output method="text" omit-xml-declaration="no" indent="no" />
  <xsl:variable name="file-desc">Register structures</xsl:variable>

  <xsl:template match="infobase">
  <xsl:apply-templates select="peripherals"/>
  </xsl:template>

  <xsl:template match="peripherals">
#include "st_base.h"

  <xsl:apply-templates select="peripheral"/>
  </xsl:template>

  <xsl:template match="peripheral">
template &lt;typename T,uint32_t L&gt;
struct <xsl:value-of select="@name"/>_rt {
  typedef T inttypes;
  enum { loc = L } ;
  <!-- <xsl:apply-templates select="register" mode="struct"> -->
  <xsl:call-template name="regnames">
    <xsl:with-param name="nodes" select="register"/>
    <xsl:with-param name="addr" 
select= "u:range('',0, u:toNum(register[position()=last()]/@offset),4)" />
  </xsl:call-template>
  };
<xsl:text>

</xsl:text>
template &lt;typename TYP,uint32_t LOC, typename BUS&gt;
struct <xsl:value-of select="@name"/>_st {
  typedef <xsl:value-of select="@name"/>_st t;
  typedef TYP inttypes;
  typedef BUS bus;
  enum { loc = LOC } ;
  enum { <xsl:apply-templates select="register" mode="offsets"/>
  };
<xsl:apply-templates select="subregister"/>
  };
  </xsl:template>

  <xsl:template name="regnames">
    <xsl:param name="addr"/>
    <xsl:param name="nodes"/>

  <xsl:for-each select="$addr">
    <xsl:variable name="i" select="number(text())"/>
/* 0x<xsl:value-of select="u:toHex($i)"/> */ <xsl:choose><xsl:when 
  test="$nodes[u:toNum(@offset)=$i]"><xsl:apply-templates  
  select="$nodes[u:toNum(@offset)=$i ]" mode="struct"/>
</xsl:when>
<xsl:otherwise>_V typename T::uint32_t Reserved_0x<xsl:value-of 
select="u:toHex($i)"/> ;</xsl:otherwise>
</xsl:choose>

  </xsl:for-each>
  </xsl:template>

  <xsl:template match="register" 
    mode="struct">_V typename T::uint32_t <xsl:value-of 
    select="@short"/>; <xsl:if test="description"
    > //!&lt; <xsl:copy-of select="description/text()"/>
</xsl:if>
  </xsl:template>

  <xsl:template match="register" mode="offsets">
  o<xsl:value-of select="@short"/> = <xsl:value-of 
    select="@offset"/>,<xsl:if test="description"
    > //?!&lt; <xsl:copy-of select="description/text()"/>
</xsl:if>
  </xsl:template>
  <xsl:key name="srs" match="/infobase/bitDesc/subreg" use="@name"/>

  <xsl:template match="subregister">
<xsl:variable name="s" select="@parent"/>
<xsl:variable name="n" select="@name"/>
  static subregister&lt;<xsl:value-of 
select="../@name"/>_st,o<xsl:value-of
select="../register[@short=$s]/@short"/>,<xsl:value-of 
select="@first"/>,<xsl:value-of 
select="@last"/><xsl:if test="@min">,range32&lt;<xsl:value-of 
select="@min"/>,<xsl:value-of 
select="@max"/>&gt; </xsl:if>&gt; <xsl:value-of
 select="@name"/>; <xsl:for-each 
select="key('srs',@name)[1]"> //!&lt; <xsl:copy-of 
select="."/></xsl:for-each>
</xsl:template>

</xsl:stylesheet>
