<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
  xmlns:dct="http://purl.org/dc/terms/" 
  xmlns:foaf="http://xmlns.com/foaf/0.1/" 
  xmlns:sub="http://xmlns.computas.com/sublima#"
  xmlns:sioc="http://rdfs.org/sioc/ns#"
  xmlns:od="http://sublima.computas.com/topic/" 
  xmlns:lingvoj="http://www.lingvoj.org/ontology#"
  xmlns:wdr="http://www.w3.org/2007/05/powder#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc od lingvoj wdr"
  >

  <xsl:template match="skos:Concept">
    <xsl:variable name="uri" select="@rdf:about"/>
    <div class="skos:Concept">
      <p>
	<a href="{$uri}"><xsl:value-of select="skos:prefLabel[@xml:lang=$interface-language]"/></a>
      </p>
      <xsl:if test="skos:altLabel[@xml:lang=$interface-language]">
	<p>
	  Synonym: <xsl:value-of select="skos:altLabel[@xml:lang=$interface-language]"/>
	</p>
      </xsl:if>
      <xsl:if test="skos:broader/skos:Concept/skos:prefLabel[@xml:lang=$interface-language]">
	Bredere: <xsl:apply-templates select="skos:broader/skos:Concept"/>
      </xsl:if>
      <xsl:if test="skos:related/skos:Concept/skos:prefLabel[@xml:lang=$interface-language]">
	Relatert: <xsl:apply-templates select="skos:related/skos:Concept"/>
      </xsl:if>
    </div>
    
  </xsl:template>
</xsl:stylesheet>