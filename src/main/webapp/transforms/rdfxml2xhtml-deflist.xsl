<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dct="http://purl.org/dc/terms/" 
  xmlns:foaf="http://xmlns.com/foaf/0.1/" 
  xmlns:sub="http://xmlns.computas.com/sublima#"
  xmlns:sioc="http://rdfs.org/sioc/ns#"
  xmlns:od="http://sublima.computas.com/topic/" 
  xmlns:lingvoj="http://www.lingvoj.org/ontology#"
  xmlns:wdr="http://www.w3.org/2007/05/powder#"
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dc dct foaf sub sioc od lingvoj wdr">
  <xsl:import href="rdfxml-res-templates.xsl"/>
  <xsl:output indent="yes"/>


  <xsl:param name="interface-language">en</xsl:param>

  <xsl:template match="rdf:RDF">
    <dl>
      <xsl:for-each select="rdf:Description"> <!-- The root node for each described resource -->
	<dt>
	  <xsl:apply-templates select="./dc:title" mode="internal-link"/>
	  <span style="font-size:small">Published by: 
	    <xsl:variable name="uri" select="dc:publisher/@rdf:resource"/>
	    <xsl:apply-templates select="../*[@rdf:about=$uri]" mode="external-link" />
	    <xsl:apply-templates select="./dct:dateAccepted"/>
	  </span>
	</dt>
	<dd>
	  <span style="color:red">
	    <xsl:apply-templates select="./dc:subject"/>
	  </span>
	  <xsl:apply-templates select="./dc:description"/>
	</dd>
      </xsl:for-each>
    </dl>
  </xsl:template>


</xsl:stylesheet>