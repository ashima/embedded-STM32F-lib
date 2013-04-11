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
<IRQBranchTable>
   <xsl:apply-templates select="table" />
</IRQBranchTable>
  </xsl:template>

  <xsl:template match="table[@name='IRQ']">
    <xsl:for-each select="cell[ generate-id() = generate-id(key('rows',@p*10000+@y)[1]) and position()>1]">
      <xsl:sort select="@p*10000+@y"/>
      <xsl:variable name="i" select="@p*10000+@y"/>
      <row position="{ key('rows',$i)[@x='0']/text() }"
           priority="{ key('rows',$i)[@x='1']/text() }"
           type    ="{ key('rows',$i)[@x='2']/text() }"
           name    ="{ translate(key('rows',$i)[@x='3']/text(),' ','') }"
           address ="{ translate(key('rows',$i)[@x='5']/text(),' ','') }" >
        <xsl:copy-of select="key('rows',$i)[@x='4']/text()"/>
      </row>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
