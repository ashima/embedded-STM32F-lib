<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  xmlns:exsl="http://exslt.org/common"
  xmlns:xi="http://www.w3.org/2001/XInclude" 
  xmlns:regexp="http://exslt.org/regular-expressions"
  extension-element-prefixes="str u exsl xi regexp"
 >

  <xsl:import href="utils.xsl"/>
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />

  <xsl:template match="/left-gpio">
    <left-gpio>
      <xsl:apply-templates select="altfunc"/>
      <xsl:copy-of select="enum"/>
    </left-gpio>
  </xsl:template>

  <xsl:template match="altfunc">
    <af-periph>
      <xsl:apply-templates select="af " mode="af-periph" />
    </af-periph>
    <trait-enum name="GPIO_AF">
      <xsl:apply-templates select="af " mode="periph-af" />
    </trait-enum>
  </xsl:template>

  <xsl:template match="af" mode="af-periph">
    <af name="{@name}">
      <xsl:for-each select="str:tokenize(@for)">
        <periph name="{.}"/>
      </xsl:for-each>
    </af>
  </xsl:template>

  <xsl:template match="af" mode="periph-af">
    <xsl:variable name="n" select="@name"/>
    <xsl:for-each select="str:tokenize(@for)">
      <val name="{.}" value="{$n}"/>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

