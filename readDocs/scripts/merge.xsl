<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xi="http://www.w3.org/2001/XInclude" 
  exclude-result-prefixes="xi"

 >

  <xsl:import href="utils.xsl"/>
  <xsl:import href="mergePeriph.xsl"/>
  <xsl:import href="mergeMem.xsl"/>
  <xsl:import href="mergeRunTime.xsl"/>

  <xsl:output method="xml" omit-xml-declaration="no" indent="yes" />

  <xsl:template match="all">
   <infobase>
     <peripherals>
       <xsl:apply-templates select="permap"/>
     </peripherals>
     <xsl:call-template name="memorymap"/>
     <xsl:call-template name="runtime"/>
     <xsl:copy-of select="bitDesc"/>
     <xsl:copy-of select="parts"/>
     <xsl:copy-of select="clocks"/>
     <xsl:copy-of select="left-gpio"/>
   </infobase>
  </xsl:template>

</xsl:stylesheet>
