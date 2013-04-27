<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="str u exsl" >
  <xsl:strip-space elements="*" />
  <xsl:output method="text" omit-xml-declaration="no" indent="yes" />

  <xsl:template match="clocks">
#include &lt;structures.h&gt;
#include &lt;instances.h&gt;

    <xsl:apply-templates select="clk"/>
  </xsl:template>

  <xsl:template match="clk">
inline static const int <xsl:value-of select="@name"/>() {
<xsl:for-each select="descendant::select">  int t_<xsl:value-of 
  select="generate-id(.)"/> ;
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
    ((t_<xsl:value-of select="generate-id(..)"/><xsl:if 
    test="generate-id(.) = generate-id(../when[1])">=*<xsl:value-of 
    select="../@on"/></xsl:if>) == <xsl:value-of
    select="@v"/> ? <xsl:apply-templates/> : <xsl:apply-templates 
    select="following-sibling::*[1]"/> )</xsl:template>

  <xsl:template match="when|otherwise">
    <xsl:apply-templates/>
  </xsl:template>

 </xsl:stylesheet> 
