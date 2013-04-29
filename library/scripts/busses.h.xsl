<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="boilerplate.xsl"/>

  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />
  <xsl:variable name="file-desc"> Buses from Memory map.</xsl:variable>

  <xsl:template match="infobase">
  struct busMap
    {<xsl:apply-templates select="/infobase/memory-map//block[not(@class)]"/>
    };
  </xsl:template>

  <xsl:template match="block">
    struct <xsl:value-of select="@name"/> { <xsl:if 
test="@name != 'root'">typedef <xsl:value-of 
select="../@name"/> parent;</xsl:if> };</xsl:template>

</xsl:stylesheet>
