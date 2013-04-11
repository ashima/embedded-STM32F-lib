<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:strip-space elements="*" />
  <xsl:output method="xml" omit-xml-declaration="no" indent="yes" />
  <xsl:key name="cells" match="replace" use="(((@p*10000)+@y)*200)+@x" /> 


  <xsl:template match="/" >
    <xsl:apply-templates select="all/table"/>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="cell[key('cells',(((@p*10000)+@y)*200)+@x)]">
<xsl:variable name="f" 
select="normalize-space(key('cells',(((@p*10000)+@y)*200)+@x)/was/text())"/>
<xsl:variable name="h" select="normalize-space(text())"/>
    <xsl:copy>
  <xsl:choose>
  <xsl:when test="$f=$h">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="key('cells',(((@p*10000)+@y)*200)+@x)/to/text() "/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:message>cell replacement found for x=<xsl:value-of 
      select="@x"/> y=<xsl:value-of select="@y"/> p=<xsl:value-of 
      select="@p"/> but text didn't match! '<xsl:value-of 
      select="$f"/>' != '<xsl:value-of select="$h"/>'
    </xsl:message>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:otherwise>
  </xsl:choose>
    </xsl:copy>
  </xsl:template>


<!--
  <xsl:template match="table" >
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="cell"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="cell" >
    <xsl:choose>
      <xsl:when test="key('cells',(((@p*10000)+@y)*200)+@x)">
      </xsl:when>
      <xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
-->
</xsl:stylesheet> 

