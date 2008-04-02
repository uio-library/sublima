<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:c="http://xmlns.computas.com/cocoon"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"   
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
  xmlns:dct="http://purl.org/dc/terms/" 
  xmlns:foaf="http://xmlns.com/foaf/0.1/" 
  xmlns:sub="http://xmlns.computas.com/sublima#"
  xmlns:sioc="http://rdfs.org/sioc/ns#"
  xmlns:od="http://sublima.computas.com/topic/" 
  xmlns:lingvoj="http://www.lingvoj.org/ontology#"
  xmlns:wdr="http://www.w3.org/2007/05/powder#"
  xmlns:topic="http://sublima.computas.com/topic/"
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc od lingvoj wdr">
  <!-- xsl:import href="rdfxml-res-templates.xsl"/ -->

  <xsl:template match="rdf:RDF" mode="facets">
    <ul>
      <xsl:apply-templates select="sub:Resource/dct:subject" mode="facets"/>
    </ul>
  </xsl:template>


  <xsl:template match="dct:subject" mode="facets">
    <xsl:if test="./topic:*"> <!-- This should iterate all unique topics -->
      <li>
	<xsl:variable name="this-label" select="./topic:*/rdfs:label[@xml:lang=$interface-language]"/>
	<a> <!-- The following builds the URL. -->
	  <xsl:attribute name="href"><xsl:text>?</xsl:text><xsl:for-each select="/c:page/c:facets/c:request/c:param"><xsl:for-each select="c:value"><xsl:value-of select="../@key"/>=<xsl:value-of select="."/>&amp;<xsl:text/></xsl:for-each></xsl:for-each>
	  <xsl:text>dct:subject/rdfs:label=</xsl:text>
	  <xsl:value-of select="$this-label"/>
	  </xsl:attribute>
	</a>
	<xsl:value-of select="$this-label"/>
	<xsl:variable name="uri" select="./topic:*/@rdf:about"/>
	<xsl:text> (</xsl:text>
	<xsl:value-of select="count(//dct:subject[@rdf:resource=$uri])+1"/>)
      </li>
    </xsl:if>
    
  </xsl:template>
</xsl:stylesheet>