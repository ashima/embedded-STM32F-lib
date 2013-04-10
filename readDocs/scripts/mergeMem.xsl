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

  <xsl:template match="all">
<all>
    <xsl:apply-templates select="guide/section[@name='memory']"/>
</all>
  </xsl:template>

  <xsl:template match="section[@name='memory']" >
    <memory-map>
      <xsl:apply-templates select="/all/memory-overview/block" >
        <xsl:with-param name="coff" select="0" />
        <xsl:with-param name="inst" select="memory" />
      </xsl:apply-templates>
    </memory-map> 
  </xsl:template>

  <xsl:template match="block">
    <xsl:param name="coff"/>
    <xsl:param name="inst"/>
    <xsl:param name="num"/>
    <xsl:param name="width"/>
    <xsl:variable name="n"><xsl:choose>
      <xsl:when test="contains(@name,'x') and $num" ><xsl:value-of 
        select="concat( substring-before(@name,'x'), $num , substring-after(@name,'x') )"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise> 
    </xsl:choose></xsl:variable>

    <xsl:variable name="w"><xsl:choose>
      <xsl:when test= "@width"><xsl:value-of select="u:toNum(@width)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$width"/></xsl:otherwise>
    </xsl:choose></xsl:variable>
 
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
    <block name="{$n}">
      <xsl:copy-of select="@class|@bb"/>
      <xsl:attribute name="offset">0x<xsl:value-of select="u:toHex($o)"/></xsl:attribute>
      <xsl:attribute name="first">0x<xsl:value-of select="u:toHex($start)"/></xsl:attribute>
      <xsl:if test="@size">
         <xsl:attribute name="size">0x<xsl:value-of select="u:toHex($size)"/></xsl:attribute>
         <xsl:attribute name="last">0x<xsl:value-of select="u:toHex(($end -1))"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="$width>0"><xsl:attribute name="sect"><xsl:value-of select="$o div $width"/></xsl:attribute></xsl:if>

      <xsl:variable name='nodes'>
      <xsl:apply-templates select="block">
          <xsl:sort select="@first"/>
        <xsl:with-param name="coff" select="$start"/>
        <xsl:with-param name="inst" select="$inst"/>
        <xsl:with-param name="width" select="$w"/>
      </xsl:apply-templates>
      </xsl:variable>
      <xsl:copy-of select="$nodes"/>


      <xsl:for-each select="exsl:node-set($inst)/memory" >
        <xsl:variable name="guidename" select="@name"/>
        <xsl:variable name="guideanchor" select="@anchor"/>
        <xsl:variable name="guideinst" select="@inst"/>
        <xsl:variable name="w2"><xsl:choose>
          <xsl:when test= "@width"><xsl:value-of select="u:toNum(@width)"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$w"/></xsl:otherwise>
        </xsl:choose></xsl:variable> 
<!-- blocks that match on location -->
        <xsl:apply-templates select="/all/*[name()=$guidename]/block[
          @name != $n and
          u:toNum(@first) &gt;= $start and 
          u:toNum(@last) &lt; $end and
          (0=u:ex($nodes,@name)) ] ">
          <xsl:sort select="@first"/>
          <xsl:with-param name="coff" select="$start"/>
          <xsl:with-param name="inst" select="."/>
          <xsl:with-param name="width" select="$w2"/>
        </xsl:apply-templates>
<!-- blocks that match by anchor -->
        <xsl:if test="$n = $guideanchor">
          <xsl:apply-templates select="/all/*[name()=$guidename]/block" >
            <xsl:with-param name="coff" select="0"/>
            <!--<xsl:with-param name="coff" select="$start"/>-->
            <xsl:with-param name="inst" select="."/>
            <xsl:with-param name="num" select="$guideinst"/>
          <xsl:with-param name="width" select="$w2"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:for-each>
    </block>
  </xsl:template>

</xsl:stylesheet>
