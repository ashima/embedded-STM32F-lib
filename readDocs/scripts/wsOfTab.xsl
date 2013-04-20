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
<xsl:key name="fs" match="f" use="@y*1000+@x"/>





<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />

  <xsl:template match="/" >
    <xsl:variable name="pass1"><xsl:apply-templates 
     select="table" mode="group-to-row"><xsl:with-param
     name="numhead" select="3"/></xsl:apply-templates></xsl:variable>

    <xsl:variable name="pass2">
    <xsl:apply-templates select="exsl:node-set($pass1)/head/row[2]" mode="head" />
    <xsl:apply-templates select="exsl:node-set($pass1)/body/row" mode="body" />
    </xsl:variable>

    <t>
    <xsl:apply-templates select="exsl:node-set($pass2)/f[@y &gt; 3]" mode="p2"/>
    </t>
  </xsl:template>

  <xsl:template match="f" mode="p2" >
    <cell v="{key('fs',3*1000 + @x)/@v }">
      <xsl:copy-of select="@ws|@f"/>
    </cell>
  </xsl:template>

  <xsl:template match="row" mode="head" >
    <xsl:apply-templates select="cell" mode="head"/>
  </xsl:template>

  <xsl:template match="row" mode="body" >
    <xsl:variable name="ws" select="substring-before(cell[@x=0]/text(),' ')"/>
      <xsl:apply-templates select="cell[@x>0]" mode="body" >
        <xsl:with-param name="ws" select="$ws"/>
      </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="cell" mode="head">
    <xsl:variable name="s" select="str:tokenize(text())[contains(text(),'.')]"/>
    <f x="{@x *2 -1}" y="{@y}" v="{exsl:node-set($s)[1]/text()}" />
    <f x="{@x *2 }" y="{@y}" v="{exsl:node-set($s)[position()=last()]/text()}" />
  </xsl:template>

  <xsl:template match="cell" mode="body">
    <xsl:param name="ws"/>
    <xsl:variable name="s" select="str:tokenize(text())"/>
    <f x="{@x *2 -1}" ws="{$ws}" y="{@y}" f="{exsl:node-set($s)[1]/text()}" />
    <f x="{@x *2 }"   ws="{$ws}" y="{@y}" f="{exsl:node-set($s)[position()=last()]/text()}" />
  </xsl:template>

</xsl:stylesheet>
