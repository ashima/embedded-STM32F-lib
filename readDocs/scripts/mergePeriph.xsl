<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="str u exsl"
 >

<xsl:import href="utils.xsl"/>
<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />
<!--
  <xsl:template match="all">
<peripherals>
    <xsl:apply-templates select="permap"/>
</peripherals>
  </xsl:template>
-->

  <xsl:template match="permap[@name='GPIO']">
    <peripheral page="{reg/@p}">
      <xsl:copy-of select="@name|@src" />
      <xsl:apply-templates 
        select="reg[starts-with(@name,'GPIOx')]" mode="struct">
        <xsl:with-param name="tabbase" select="'GPIOx_'"/>
        <xsl:with-param name="docbase" select="'GPIOx_'"/>
      </xsl:apply-templates>
      <xsl:apply-templates 
        select="reg[starts-with(@name,'GPIOx')]/bit" mode="struct">
        <xsl:with-param name="tabbase" select="'GPIOx_'"/>
      </xsl:apply-templates>
    </peripheral>
  </xsl:template>

  <xsl:template match="permap[@name='DMA']">
    <peripheral name="DMA" page="{reg/@p}">
      <xsl:copy-of select="@src" />
      <xsl:apply-templates 
        select="reg[not(starts-with(@name,'DMA_S'))]" mode="struct">
        <xsl:with-param name="tabbase" select="'DMA_'"/>
        <xsl:with-param name="docbase" select="'DMA_'"/>
      </xsl:apply-templates>
      <xsl:apply-templates 
        select="reg[not(starts-with(@name,'DMA_S'))]/bit" mode="struct">
        <xsl:with-param name="tabbase" select="'DMA_'"/>
      </xsl:apply-templates>
    </peripheral>
    <peripheral name="DMA_S" page="{reg/@p}">
      <xsl:copy-of select="@src" />
      <xsl:apply-templates 
        select="reg[starts-with(@name,'DMA_S0')]" mode="struct">
        <xsl:with-param name="tabbase" select="'DMA_S0'"/>
        <xsl:with-param name="docbase" select="'DMA_Sx'"/>
        <xsl:with-param name="offsetoffset" select="-16"/>
      </xsl:apply-templates>
      <xsl:apply-templates 
        select="reg[starts-with(@name,'DMA_S0')]/bit" mode="struct">
        <xsl:with-param name="tabbase" select="'DMA_S0'"/>
      </xsl:apply-templates>
    </peripheral>

  </xsl:template>

  <xsl:template match="permap">
    <xsl:variable name="base"
                  select="concat(substring-before(concat(@name,'_'),'_'),'_')" />
    <peripheral page="{reg/@p}">
      <xsl:copy-of select="@name|@src" />
      <xsl:apply-templates select="reg" mode="struct">
        <xsl:with-param name="tabbase" select="$base"/>
        <xsl:with-param name="docbase" select="$base"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="reg/bit" mode="struct">
        <xsl:with-param name="tabbase" select="$base"/>
      </xsl:apply-templates>
    </peripheral>
  </xsl:template>

  <xsl:template match="reg" mode="struct">
    <xsl:param name="tabbase"/>
    <xsl:param name="docbase"/>
    <xsl:param name="offsetoffset"/>

    <xsl:variable name="o"><xsl:choose>
      <xsl:when test="$offsetoffset">0x<xsl:value-of
select="u:toHex(u:toNum(@offset)+$offsetoffset)" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="@offset"/></xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:variable name="s" select="substring-after(@name,$tabbase)"/>
    <xsl:variable name="n" select="concat($docbase,$s)"/>
    <register name="{$n}" short="{$s}" offset="{$o}">
      <xsl:if 
     test="/all/index/registers/register[@name=$n]/text()" >
        <description><xsl:copy-of 
     select="/all/index/registers/register[@name=$n]/text()"/>
        </description>
      </xsl:if>
    </register>
  </xsl:template>

  <xsl:template match="bit" mode="struct">
    <xsl:param name="tabbase"/>
    <xsl:variable name="p" select="substring-after(../@name,$tabbase)"/>
    <xsl:variable name="r" select="../../@name"/>
    <xsl:variable name="s" select="substring-before(concat(@name,'['),'[')"/>
    <subregister width="{@w}" name="{$s}" parent="{$p}" >
      <xsl:copy-of select="@first|@last"/>
      <xsl:copy-of select="/all/regranges/range[@reg=$r and @sub=$s]/@min" />
      <xsl:copy-of select="/all/regranges/range[@reg=$r and @sub=$s]/@max" />
    </subregister>
  </xsl:template>
  
</xsl:stylesheet>

