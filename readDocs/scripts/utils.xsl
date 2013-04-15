<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings" 
  xmlns:fn="http://exslt.org/functions"
  xmlns:u="http://ashimagroup.net/ijm/exsltutils"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="str fn u exsl"
>

  <fn:function name="u:hex">
    <xsl:param name="s" />
    <xsl:variable name="h" select="substring($s, 1, string-length($s)-1 )" />
    <xsl:variable name="n" select="substring($s, string-length($s) )" />
  
    <xsl:choose>
  
      <xsl:when test="string-length($s) = 0">
        <fn:result select="0" />
      </xsl:when>
  
      <xsl:when test="string( number($n) ) = 'NaN'">
        <fn:result select="u:hex( $h ) * 16 + 10 +
            number( translate( $n, 'AaBbCcDdEeFf', '001122334455' ))"/>
      </xsl:when>
  
      <xsl:otherwise>
        <fn:result select="u:hex($h) * 16 + number($n)" />
      </xsl:otherwise>
    </xsl:choose>
  </fn:function>

  <fn:function name="u:toHex">
  <xsl:param name="x" />
  <xsl:param name="i" >0</xsl:param>
  <xsl:variable name="n" select="$x mod 16" />
  <xsl:variable name="h" select="floor( $x div 16 )" />
  <xsl:variable name="l">
<!--if h == 0 and i = 3 or 7 then stop.-->

    <xsl:if test="$i &lt; 16 and not ( $h = 0 and ( $i mod 4 = 3)) ">
      <xsl:value-of select="u:toHex($h,$i+1)"/>
    </xsl:if>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$n &gt; 9">
      <fn:result select="concat($l, translate(
                 substring($n,2), '012345', 'abcdef' ))"/>
    </xsl:when>
    <xsl:otherwise>
      <fn:result select="concat($l,$n)" />
    </xsl:otherwise>
  </xsl:choose>
</fn:function>

  <fn:function name="u:uppercase">
    <xsl:param name="s"/> 
    <fn:result select="translate($s, 'abcdefghijklmnopqrstuvwxyz',
       'ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
  </fn:function>
  
  <fn:function name="u:lowercase">
    <xsl:param name="s"/> 
    <fn:result select="translate($s, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
   'abcdefghijklmnopqrstuvwxyz')" />
  </fn:function>

  <fn:function name="u:stripws">
    <xsl:param name="s"/> 
    <fn:result select="translate(normalize-space($s), ' ', '')" />
  </fn:function>

  <fn:function name="u:ends-with">
    <xsl:param name="s"/> 
    <xsl:param name="t"/> 
    <fn:result 
       select="$t=substring($s,string-length($s) - string-length($t) +1)" />
  </fn:function>

  <fn:function name="u:test">
    <xsl:param name="nodeset"/>
    <fn:result>
    <xsl:value-of select="exsl:node-set($nodeset)/descendant::*[@name='AHB1']/@name"/>
    </fn:result>
  </fn:function>

  <fn:function name="u:toNum">
    <xsl:param name="s" />

    <xsl:variable name="t" select="substring($s, string-length($s)-1 )" />
    <xsl:variable name="h" select="substring($s, 1, string-length($s)-2 )" />

    <xsl:variable name="ret">
    <xsl:choose>
      <xsl:when test="$t='kb' or $t='kB' or $t='Kb' or $t='KB'">
        <xsl:value-of select="1024 * u:toNum($h)" />
      </xsl:when>
      <xsl:when test="$t='Mb' or $t='MB'">
        <xsl:value-of select="1024 * 1024 * u:toNum($h)" />
      </xsl:when>
      <xsl:when test="$t='Gb' or $t='GB'">
        <xsl:value-of select="1024*1024*1024 * u:toNum($h)" />
      </xsl:when>
      <xsl:when test="starts-with($s,'0x')">
        <xsl:variable name="s1" select="substring-after($s,'0x')" />
        <xsl:value-of select="u:hex( (str:tokenize($s1,
    concat(' ', translate($s1,'0123456789aAbBcCdDeEfF','')))[1]/text() ))" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="number($s)" />
      </xsl:otherwise>
    </xsl:choose>
    </xsl:variable>
   <!--<xsl:message>=<xsl:value-of select="$ret"/>]</xsl:message>-->
   <fn:result select="$ret"/>
  </fn:function>

  <fn:function name="u:ex">
    <xsl:param name="nodeset"/>
    <xsl:param name="n"/>
    <fn:result>
      <xsl:choose>
       <xsl:when test="exsl:node-set($nodeset)/descendant::*[@name=$n]/@name"
         >1</xsl:when>
     <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
    </fn:result>
  </fn:function>

   <fn:function name="u:range">
    <xsl:param name="acc" />
    <xsl:param name="i" />
    <xsl:param name="l" />
    <xsl:param name="s" />
    <xsl:choose>
      <xsl:when test="$i &gt; $l">
        <fn:result select="str:split($acc)"/>
      </xsl:when>
      <xsl:otherwise>
        <fn:result 
         select="u:range(concat($acc,' ',string($i)),$i + $s, $l , $s)"/>
      </xsl:otherwise>
    </xsl:choose>
  </fn:function>

  <xsl:template match="table" mode="group-to-row">
    <head>
      <xsl:for-each 
        select="cell[generate-id()=generate-id(key('rows',@p*10000+@y)[1])
          and position()=1]">
        <xsl:variable name="i" select="@p*10000+@y"/>
        <row p="{@p}" y="{@y}" >
          <xsl:copy-of select="key('rows',$i)" />
        </row>
      </xsl:for-each>
    </head>
    <body>
      <xsl:for-each select="cell[ generate-id() = generate-id(key('rows',@p*10000+@y)[1]) and position()>1]">
        <xsl:sort select="@p*10000+@y"/>
        <xsl:variable name="i" select="@p*10000+@y"/>
        <row p="{@p}" y="{@y}" >
          <xsl:copy-of select="key('rows',$i)" />
        </row>
      </xsl:for-each>
    </body>
  </xsl:template>

  <xsl:template name="boilerplate">
    <xsl:param name="desc"/>
  /**
   \brief      <xsl:value-of select="$desc"/>
   \copyright  Copyright (C) 2013 Ashima Research. All rights reserved.
               Distributed under the MIT Expat License. See LICENSE file.
               https://github.com/ashima/embedded-STM32F-lib

   \remark     Auto-generated file. Do not edit.

  */
  </xsl:template> 
</xsl:stylesheet>
