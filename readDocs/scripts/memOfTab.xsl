<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="str u exsl"
 >
<xsl:import href="utils.xsl"/>

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />
<xsl:key name="rows" match="cell" use="@p*10000+@y"/>

  <xsl:template match="/" >
   <xsl:variable name="tab"><xsl:apply-templates 
     select="table" mode="group-to-row" /></xsl:variable>

<memory name="{table/@name}">
   <xsl:apply-templates select="exsl:node-set($tab)/body/row" >
     <xsl:with-param name="addrcol" select="exsl:node-set($tab)/head/row/cell
       [ contains(u:lowercase(text()),'address')]/@x" /> 
     <xsl:with-param name="namecol" select="exsl:node-set($tab)/head/row/cell
       [ contains(u:lowercase(text()),'name')]/@x" /> 
   </xsl:apply-templates>
</memory>
  </xsl:template>

  <xsl:template match="row" >
    <xsl:param name="addrcol"/>
    <xsl:param name="namecol"/>
    <xsl:if test="cell[@x=$namecol]/text()!='Reserved'">
      <xsl:variable name="h" select="cell[@x=$namecol]/@h"/>
      <xsl:variable name="y" select="@y"/>
      <xsl:variable name="p" select="@p"/>
      <xsl:variable name="addr1"><xsl:choose>
        <xsl:when test="$h &gt; 1" >
          <xsl:value-of 
select="substring-before(../row[@p=$p and @y=($y + $h -1)]/cell[@x=$addrcol]/text(),'-')"/>-<xsl:value-of
select="substring-after( cell[@x=$addrcol]/text(), '-' )"/>
</xsl:when>
<!-- select="name(/table/cell[@x=$addrcol and @p = $p and @y=$y])"/></xsl:when>  -->
      <xsl:otherwise><xsl:value-of select='cell[@x=$addrcol]/text()'/></xsl:otherwise>
      </xsl:choose></xsl:variable>
      <xsl:variable name="addr" select="translate(u:stripws($addr1),'X','x') " />
      <xsl:variable name="f" select="u:toNum(substring-before($addr,'-'))" />
      <xsl:variable name="l" select="u:toNum(substring-after($addr,'-'))" />
      <xsl:variable name="n" select="substring-before(concat(u:stripws(cell[@x=$namecol]/text()),'/'),'/') "/>
      <block name="{$n}" first="0x{u:toHex($f)}" last="0x{u:toHex($l)}">
        <xsl:if test="string($f)!='NaN' and string($l)!='NaN'" >
          <xsl:attribute name="size">0x<xsl:value-of select="u:toHex($l - $f +1)"/></xsl:attribute>
        </xsl:if>
      </block>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
