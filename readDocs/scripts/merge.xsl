<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="str u exsl"
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
   </infobase>
  </xsl:template>

</xsl:stylesheet>
