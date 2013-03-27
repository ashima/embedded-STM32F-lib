<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  extension-element-prefixes="str u"
 >
<xsl:import href="utils.xsl"/>

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />

  <xsl:template match="/">
<memory>
    <xsl:apply-templates select="/all/memory1/block" >
      <xsl:with-param name="coff" select="0"/> 
    </xsl:apply-templates>
</memory>
  </xsl:template>

  <xsl:template match="block">
    <xsl:param name="coff"/>
    <xsl:variable name="n" select="@name"/>
    <xsl:variable name="start"><xsl:choose>
        <xsl:when test="@offset"><xsl:value-of select="($coff+u:toNum(@offset))"/></xsl:when>
        <xsl:when test="@first"><xsl:value-of select="u:toNum(@first)"/></xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose></xsl:variable>

    <xsl:variable name="o"><xsl:choose>
        <xsl:when test="@offset"><xsl:value-of select="u:toNum(@offset)"/></xsl:when>
        <xsl:when test="@first"><xsl:value-of select="u:toNum(@first)-$coff"/></xsl:when>
        <xsl:otherwise></xsl:otherwise>
    </xsl:choose></xsl:variable>

    <xsl:variable name="size"><xsl:choose>
       <xsl:when test="@size"><xsl:value-of select="u:toNum(@size)"/></xsl:when>
       <xsl:when test="@last"><xsl:value-of select="(u:toNum(@last)+1-$start)"/></xsl:when>
        <xsl:otherwise>C</xsl:otherwise>
    </xsl:choose></xsl:variable>

    <xsl:variable name="end"   select="($start+$size)"/> 
    <block>
      <xsl:copy-of select="@name|@class"/>
      <xsl:attribute name="offset">0x<xsl:value-of select="u:toHex($o)"/></xsl:attribute>
      <xsl:attribute name="first">0x<xsl:value-of select="u:toHex($start)"/></xsl:attribute>
      <xsl:if test="@size">
         <xsl:attribute name="size">0x<xsl:value-of select="u:toHex($size)"/></xsl:attribute>
         <xsl:attribute name="last">0x<xsl:value-of select="u:toHex(($end -1))"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@class"><xsl:attribute name="sect"><xsl:value-of select="$o div $size"/></xsl:attribute></xsl:if>

      <xsl:variable name='nodes'>
      <xsl:apply-templates select="block">
        <xsl:with-param name="coff" select="$start"/>
      </xsl:apply-templates>
      </xsl:variable>
      <xsl:copy-of select="$nodes"/>
      <xsl:apply-templates select="/all/memory2/block[
        @name != $n and
        u:toNum(@first) &gt;= $start and 
        u:toNum(@last) &lt; $end and
        (0=u:ex($nodes,@name)) ] ">
        <xsl:sort select="@first"/>
        <xsl:with-param name="coff" select="$start"/>
      </xsl:apply-templates>
    </block>
  </xsl:template>

</xsl:stylesheet>
