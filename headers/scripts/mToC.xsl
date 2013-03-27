<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings" >

  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />

  <xsl:template match="/">
/* Memory map for <xsl:value-of select="@name"/>.
   Auto generated, do not edit.
 */
  struct memMap {
    enum {
<xsl:apply-templates select="/all/memory-map/block">
  <xsl:with-param name="indent" select="'      '"/>
  <xsl:with-param name="bb" select="0"/>
</xsl:apply-templates>
    };
  };
  </xsl:template>

  <xsl:template match="block|instance">
    <xsl:param name="indent"/>
    <xsl:param name="bb"/>
<xsl:value-of select="$indent"/><xsl:value-of select="@name"/><xsl:if
  test="$bb=1">_BB</xsl:if> = <xsl:if 
  test="../@name"><xsl:value-of select="../@name"/><xsl:if
  test="$bb=1">_BB</xsl:if> + </xsl:if><xsl:value-of
  select="@offset"/>UL<xsl:if test="$bb=1"> * 32</xsl:if><xsl:text>,
</xsl:text>
<xsl:apply-templates select="block|instance">
  <xsl:with-param name="indent" select="concat('  ',$indent)"/>
  <xsl:with-param name="bb" select="$bb"/>
</xsl:apply-templates>
<xsl:if test="@bb">
<xsl:value-of select="$indent"/><xsl:value-of select="@name"/>_BB = <xsl:if 
  test="../@name"><xsl:value-of select="../@name"/> + </xsl:if><xsl:value-of
  select="@bb"/>UL<xsl:text>,
</xsl:text>
<xsl:apply-templates select="block|instance">
  <xsl:with-param name="indent" select="concat('  ',$indent)"/>
  <xsl:with-param name="bb" select="1"/>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
  
</xsl:stylesheet>
