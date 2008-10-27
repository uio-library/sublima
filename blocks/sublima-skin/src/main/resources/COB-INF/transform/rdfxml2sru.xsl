<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:c="http://xmlns.computas.com/cocoon"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:sioc="http://rdfs.org/sioc/ns#"
    xmlns:sub="http://xmlns.computas.com/sublima#"
    xmlns="http://www.loc.gov/zing/srw/" 
    xmlns:wdr="http://www.w3.org/2007/05/powder#"
    xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/"
    xmlns:xcql="http://www.loc.gov/zing/cql/xcql/"
    version="1.0">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/c:page/c:stylesheet">
   <xsl:if test="not(normalize-space(.) = '')">
      <xsl:processing-instruction name="xml-stylesheet">
	href="<xsl:value-of select="."/>" type="text/xml"
      </xsl:processing-instruction>
    </xsl:if>
  </xsl:template>

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
	<sub:Resource rdf:about="{./@rdf:about}">
	  <xsl:apply-templates select="./sub:committer"/>
	  <xsl:apply-templates select="./dct:*"/>
	  <xsl:copy-of select="./wdr:describedBy"/>
	</sub:Resource>
      </recordData>
    </record>
  </xsl:template>

  <!-- First we take the DCT Properties -->
  <xsl:template match="dct:*">
    <xsl:choose>
    <xsl:when test="name() = 'dct:identifier'">
      <xsl:copy-of select="."/>
    </xsl:when>
    <xsl:when test="./@rdf:resource">
      <xsl:variable name="uri" select="./@rdf:resource"/>
      <xsl:element name="{name()}" namespace="{namespace-uri()}">
	<xsl:copy-of select="//*[@rdf:about=$uri]"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="sub:committer">
    <xsl:choose>
      <xsl:when test="./@rdf:resource">
	<xsl:variable name="uri" select="./@rdf:resource"/>
	<xsl:element name="{name()}" namespace="{namespace-uri()}">
	  <xsl:copy-of select="//sioc:User[@rdf:about=$uri]"/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
      <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>