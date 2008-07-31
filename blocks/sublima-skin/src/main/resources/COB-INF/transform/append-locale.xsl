<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:sub="http://xmlns.computas.com/sublima#"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:xh="http://www.w3.org/1999/xhtml"
        version="1.0">
  
  <xsl:param name="servername">/</xsl:param>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="/">
    <xsl:apply-templates mode="copy"/>
  </xsl:template>


  <xsl:template match="xh:a">
    <a>
      <xsl:attribute  name="href">
	<xsl:variable name="uri" select="./@href"/> 

	<xsl:choose>
	  <xsl:when test="not(contains($uri, 'locale='))">
	    <xsl:variable name="qoramp">
	      <xsl:choose>
		<xsl:when test="contains($uri, '?')">
		  <xsl:text>&amp;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:text>?</xsl:text>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:variable>
	    <xsl:choose>
	      <xsl:when test="contains($uri, $servername)">
		<xsl:value-of select="concat($uri, $qoramp, 'locale=', $interface-language)"/>
	      </xsl:when>
	      <xsl:when test="not(starts-with($uri, 'http'))">
		<xsl:value-of select="concat($uri, $qoramp, 'locale=', $interface-language)"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="$uri"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$uri"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>

      <xsl:copy-of select="@class|@id|@style|@lang|@hreflang|@onfocus|@onblur|@tabindex"/>
      <xsl:apply-templates select="node()" mode="copy"/>
    </a>
  </xsl:template>

  <xsl:template match="@*|node()" mode="copy">
    <xsl:apply-templates select="xh:a"/>
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="copy" />
      <xsl:apply-templates mode="copy" />
    </xsl:copy>
  </xsl:template>
  

</xsl:stylesheet>