<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  xmlns:exsl="http://exslt.org/common"
  xmlns:xi="http://www.w3.org/2001/XInclude" 
  extension-element-prefixes="str u exsl xi"
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
  <xsl:template name="runtime">
    <runtime>
      <xsl:apply-templates select="IRQBranchTable"/>
      <xsl:apply-templates select="parts/part[@name='STM32F407VG']" mode="runtime"/>
    </runtime>
  </xsl:template>

  <xsl:template match="IRQBranchTable">
    <IRQBranchTable>
      <xsl:apply-templates select="row[text()!='Reserved']" mode="runtime"/>
    </IRQBranchTable>
  </xsl:template>

  <xsl:template match="row|part" mode="runtime">
    <xsl:copy>
    <xsl:copy-of select="@*"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

