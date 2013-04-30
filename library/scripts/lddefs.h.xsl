<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="boilerplate.xsl"/>

  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />
  <xsl:variable name="file-desc"> Buses from Memory map.</xsl:variable>

  <xsl:template match="lddefs">
    <xsl:apply-templates select="def"/>
  </xsl:template>

  <xsl:template match="def">
    extern uint32_t <xsl:value-of select="@name"/> ;</xsl:template>

</xsl:stylesheet>
