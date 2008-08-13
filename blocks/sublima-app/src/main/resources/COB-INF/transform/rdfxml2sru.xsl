<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:c="http://xmlns.computas.com/cocoon"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:sub="http://xmlns.computas.com/sublima#"
    xmlns="http://www.loc.gov/zing/srw/" 
    xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/"
    xmlns:xcql="http://www.loc.gov/zing/cql/xcql/"
    version="1.0">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/c:page/rdf:RDF">
    <searchRetrieveResponse> 
      <version>1.1</version>
      <numberOfRecords>
	<xsl:value-of select="count(./sub:Resource)"/>
      </numberOfRecords>
      <records>
	<xsl:apply-templates select="./sub:Resource"/>
      </records>
    </searchRetrieveResponse>
  </xsl:template>


  <xsl:template match="sub:Resource">
    <record>
      <recordPacking>XML</recordPacking>
      <recordData>
	<xsl:apply-templates select="./dct:*"/> 
      </recordData>
    </record>
  </xsl:template>

  <!-- First we take the DCT Properties that have text, e.g. dct:title -->
  <xsl:template match="dct:*">
    <xsl:choose>
    <xsl:when test="not(normalize-space(./text())='')">
      <xsl:copy-of select="."/>
    </xsl:when>
      <xsl:otherwise>
	DAHUUUUUUUUUUT
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- the Identifier is a URI, shall never be expanded -->
  <!-- xsl:template match="dct:identifier">
    <xsl:copy-of select="."/>
  </xsl:template -->

  <!-- xsl:template match="dct:*/@rdf:resource" -->

</xsl:stylesheet>