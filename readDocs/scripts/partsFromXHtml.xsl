<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ext="thing">
  <xsl:strip-space elements="*" />
  <xsl:output method="xml" omit-xml-declaration="no" indent="yes" />

  <xsl:template match="/" >
<parts>
    <xsl:apply-templates select="//tr" />
</parts>
  </xsl:template>

  <xsl:template match="tr" >
<part
name    = "{.//*[@class='x-grid3-cell-inner x-grid3-col-0']//text()}"
package = "{.//*[@class='x-grid3-cell-inner x-grid3-col-1']//text()}"
core    = "{.//*[@class='x-grid3-cell-inner x-grid3-col-3']//text()}"
speed   = "{.//*[@class='x-grid3-cell-inner x-grid3-col-4']//text()}"
flash   = "{.//*[@class='x-grid3-cell-inner x-grid3-col-5']//text()}"
sram    = "{.//*[@class='x-grid3-cell-inner x-grid3-col-6']//text()}" />
  </xsl:template>

</xsl:stylesheet>

