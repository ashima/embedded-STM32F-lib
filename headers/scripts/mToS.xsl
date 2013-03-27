<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings" >

  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />

  <xsl:template match="/">
/* Memory map for <xsl:value-of select="@name"/>.
   Auto generated, do not edit.
 */

#define DECLATE_PERIPH(NAME,CLASS,BUS) \
  struct NAME##_t : public CLASS { \
    typedef CLASS base_t;
    // bus type in here soon
    enum { offset = memMap::NAME } ;
    };
  const NAME##_t &amp;NAME = *(NAME##_t*)(NAME##_t::offset) ;


<xsl:apply-templates select="/all/memory-map/block">
  <xsl:with-param name="indent" select="'      '"/>
  <xsl:with-param name="bb" select="0"/>
</xsl:apply-templates>
  </xsl:template>

  <xsl:template match="block"><xsl:param 
    name="bb"/><xsl:apply-templates select="block|instance">
      <xsl:with-param name="bb" select="$bb"/>
    </xsl:apply-templates><xsl:if test="@bb"><xsl:apply-templates 
      select="block|instance">
      <xsl:with-param name="bb" select="1"/>
    </xsl:apply-templates></xsl:if></xsl:template>

  <xsl:template match="instance"><xsl:param 
    name="bb"/>DECLARE_PERIPH(<xsl:value-of 
select="@class"/><xsl:if test="$bb=1">_BB</xsl:if>_t, <xsl:value-of 
select="@name"/><xsl:if test="$bb=1">_BB</xsl:if>, <xsl:value-of 
select="@bus"/>);<xsl:text>
</xsl:text></xsl:template>
  
</xsl:stylesheet>
