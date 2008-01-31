<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template match="/page">
    <xsl:copy>
      <xsl:apply-templates select="result-list"/>
      <xsl:apply-templates select="result-list" mode="navigation"/>
      <xsl:apply-templates select="result-list" mode="facets"/>
      <foo>blah</foo>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*|node()|@*">
    <xsl:copy><xsl:apply-templates select="*|node()|@*"/></xsl:copy>
  </xsl:template>
  
  <!--xsl:template match="result-list">
  
  </xsl:template-->
  
  <xsl:template match="result-list" mode="navigation">
    <navigation>
     something goes in here
    </navigation>
  </xsl:template>
  
  <xsl:template match="result-list" mode="facets">
    <facets>
      <facet>Jets</facet>
    </facets>  
  </xsl:template>

</xsl:stylesheet>