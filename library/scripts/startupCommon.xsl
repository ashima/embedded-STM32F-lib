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
  <xsl:import href="utils.xsl"/>

  <xsl:output method="text" omit-xml-declaration="no" indent="no" />
  <xsl:key name="irqn" match="infobase/runtime/IRQBranchTable/row" use="u:toNum(@address)"/>

  <xsl:template name="isrlist">
    <xsl:param name="type"/>
    <xsl:param name="sep"/>
    <xsl:param name="npc"/>
    <xsl:param name="addrs"/>
  <xsl:variable name="last" select="u:toNum(IRQBranchTable/row[position()=last()]/@address)" />
  <xsl:variable name="rows" select="IRQBranchTable" />
<xsl:for-each select="$addrs" >
    <xsl:variable name="i" select="number(text())"/>
    <xsl:for-each select="exsl:node-set($rows)" >
      <xsl:variable name='j' select="key('irqn', $i)"/>
      <xsl:choose>
        <xsl:when test="$j">
  <xsl:value-of select="$type"/><xsl:text> </xsl:text><xsl:value-of select="exsl:node-set($j)/@name" />_Handler</xsl:when>
      <xsl:otherwise>
  <xsl:value-of select="$type"/> Reserved_0x<xsl:value-of select="u:toHex($i)"/></xsl:otherwise>
    </xsl:choose><xsl:value-of select="$sep"/><xsl:if test="($i div 4) mod $npc = 0"><xsl:text>
</xsl:text></xsl:if>
    </xsl:for-each>
  </xsl:for-each> 
  </xsl:template>

</xsl:stylesheet>
