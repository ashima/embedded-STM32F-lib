<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="str u exsl" >
  <xsl:strip-space elements="*" />
  <xsl:output method="text" omit-xml-declaration="no" indent="yes" />

  <xsl:key name="sels" match="select" use="concat(ancestor::clk/@name,@on)"/>

  <xsl:template match="/">
    <xsl:apply-templates select="/infobase/clocks"/>
  </xsl:template>

  <xsl:template match="/infobase/clocks">
#include &lt;structures.h&gt;
#include &lt;instances.h&gt;
#include &lt;busses.h&gt;

template&lt;uint32_t Hse,uint32_t Lse=0, uint32_t I2s=0&gt;
struct clkReadTree
  {
  static const int HSE() { return Hse; }
  static const int LSE() { return Lse; }
  static const int I2S_CKIN() { return I2s; }

  <xsl:apply-templates select="clk"/>
  };
  </xsl:template>

  <xsl:template match="clk">
  <xsl:variable name="n" select="@name"/>
  static const int <xsl:value-of select="$n"/>() __attribute__((noinline)) {
<xsl:for-each select="descendant::select"><xsl:variable name="k" 
  select="generate-id(key('sels',concat($n,@on))[1])"/><xsl:if test="$k=generate-id()">  int t_<xsl:value-of 
  select="$k"/> = *<xsl:value-of select="@on"/> ;
</xsl:if>
</xsl:for-each>  return <xsl:apply-templates select="node()"/> ;
};
  </xsl:template>

  <xsl:template match="src"><xsl:value-of select="@src"/>()</xsl:template>
  <xsl:template match="value"><xsl:value-of select="translate(@value,' ,_','')"/></xsl:template>
  <xsl:template match="comment">/*<xsl:apply-templates/>*/</xsl:template>
  <xsl:template match="select"><xsl:apply-templates 
    select="when[1]"/></xsl:template>

  <xsl:template match="mul"> <xsl:apply-templates 
       select="node()"/> * <xsl:if 
       test="string(number(@by))='NaN'">*</xsl:if><xsl:value-of 
       select="@by"/></xsl:template>

  <xsl:template match="div"> <xsl:apply-templates 
       select="node()"/> / <xsl:if 
       test="string(number(@by))='NaN'">*</xsl:if><xsl:value-of 
       select="@by"/></xsl:template>

  <xsl:template match="when[following-sibling::*]">
    (t_<xsl:value-of select="generate-id(key('sels',
              concat(ancestor::clk/@name,../@on))[1])"/> == <xsl:value-of
    select="@v"/> ? <xsl:apply-templates/> : <xsl:apply-templates 
    select="following-sibling::*[1]"/> )</xsl:template>

  <xsl:template match="when|otherwise">
    <xsl:apply-templates/>
  </xsl:template>

 </xsl:stylesheet> 
