<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="boilerplate.xsl"/>

  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />
  <xsl:variable name="file-desc">GPIO Peripheral.</xsl:variable>

  <xsl:template match="infobase">
#include "gpio_base.h"

<!-- <xsl:apply-templates select="enum[starts-with(@name,'GPIO')]"/> -->
<xsl:apply-templates select="left-gpio/enum"/>
<xsl:apply-templates select="left-gpio/trait-enum"/>
  </xsl:template>

</xsl:stylesheet> 

