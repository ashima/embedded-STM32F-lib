<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings" >

  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />

  <xsl:template match="/">
/* Memory map for <xsl:value-of select="@name"/>.
   Auto generated, do not edit.
 */
#include &lt;stdio.h&gt;
#include "memory.h"

int main()
  {
<xsl:apply-templates select="/infobase/memory-map/block">
  <xsl:with-param name="indent" select="'      '"/>
  <xsl:with-param name="bb" select="0"/>
</xsl:apply-templates>
  }
  </xsl:template>

  <xsl:template match="block|instance">
    <xsl:param name="indent"/>
    <xsl:param name="bb"/>printf("%s%10s = 0x%08x\n","<xsl:value-of 
select="$indent"/>","<xsl:value-of select="@name"/><xsl:if
  test="$bb=1">_BB</xsl:if>", (unsigned int)memMap::<xsl:value-of select="@name"/><xsl:if
  test="$bb=1">_BB</xsl:if> );
<xsl:apply-templates select="block|instance">
  <xsl:with-param name="indent" select="concat('  ',$indent)"/>
  <xsl:with-param name="bb" select="$bb"/>
</xsl:apply-templates>
<xsl:if test="@bb">
<!--<xsl:value-of select="$indent"/><xsl:value-of select="@name"/>_BB = <xsl:if 
  test="../@name"><xsl:value-of select="../@name"/> + </xsl:if><xsl:value-of
  select="@bb"/><xsl:text>,
</xsl:text> > -->
<xsl:apply-templates select="block|instance">
  <xsl:with-param name="indent" select="concat('  ',$indent)"/>
  <xsl:with-param name="bb" select="1"/>
</xsl:apply-templates>
</xsl:if>  
</xsl:template>
  
</xsl:stylesheet>
