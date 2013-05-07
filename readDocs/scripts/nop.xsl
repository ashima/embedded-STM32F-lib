<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xi="http://www.w3.org/2001/XInclude" exclude-result-prefixes="xi" >
  <xsl:strip-space elements="*" />
  <xsl:output method="xml" omit-xml-declaration="no" indent="yes" />
  <xsl:template match="/" >
    <xsl:copy-of select="." />
  </xsl:template>
</xsl:stylesheet> 
