<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="str u exsl" >
  <xsl:strip-space elements="*" />
  <xsl:output method="xml" omit-xml-declaration="no" indent="yes" />

  <xsl:template match="/">
    <xsl:apply-templates mode="red" />
  </xsl:template>

  <xsl:template match="node()" mode="red">
    <xsl:param name="dict"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"  mode="red">
        <xsl:with-param name="dict" select="$dict"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*"  mode="red">
    <xsl:param name="dict"/>
    <xsl:apply-templates mode="blue" select="." >
      <xsl:with-param name="dict" select="$dict"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="@*"  mode="blue">
    <xsl:param name="dict"/>
    <xsl:attribute name="{name()}"><xsl:choose>
      <xsl:when test="starts-with(.,'$')">
        <xsl:variable name="rem" select="substring-after(.,'$')"/>
        <xsl:variable name="var" select="substring-before(concat($rem,'$'),'$')"/>
        <xsl:variable name="rest" select="substring-after($rem,'$')"/>
        <xsl:value-of select="exsl:node-set($dict)/@*[name()=$var]"/><xsl:value-of select="$rest"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose></xsl:attribute>
  </xsl:template>

  <xsl:template match="define" mode="red"/>

  <xsl:template match="use" mode="red">
    <xsl:variable name="n" select="@name"/>
    <xsl:apply-templates select="../define[@name=$n]/*" mode="red">
      <xsl:with-param name="dict" select="."/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="@src|@value" mode="red">
    <xsl:param name="dict"/>
    <xsl:element name="{name()}">
      <xsl:apply-templates select="." mode="blue">
        <xsl:with-param name="dict" select="$dict"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <xsl:template match="clktree" mode="red">
    <xsl:param name="dict"/>
    <xsl:variable name="self"><s><xsl:apply-templates select="./@*" mode="blue">
      <xsl:with-param name="dict" select="$dict"/>
    </xsl:apply-templates></s></xsl:variable>
    <xsl:variable name="n" select="exsl:node-set($self)/s/@name"/>
    <xsl:variable name="s" select="exsl:node-set($self)/s/@src"/>
    <xsl:for-each select="str:tokenize(@by,', ')">
      <clk name="{concat($n,.)}" >
        <div by="{.}"><src src="{$s}"/></div>
      </clk>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet> 
