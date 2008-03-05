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
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc od lingvoj wdr">
  <xsl:import href="rdfxml-res-templates.xsl"/>


  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="rdf:RDF" mode="results">
    <dl>
      <xsl:for-each select="rdf:Description"> <!-- The root node for each described resource -->
	<dt>
	  <xsl:apply-templates select="./dct:title" mode="internal-link"/>
	  <xsl:text> har emne </xsl:text>	  
	  <xsl:apply-templates select="./dct:subject"/>
	</dt>
	<dd>
	  <div style="font-size:small"><xsl:text>Publisert av: </xsl:text>
	    <xsl:apply-templates select="dct:publisher"/>
	    <xsl:text> </xsl:text>
	    <xsl:apply-templates select="./dct:dateAccepted"/>
	  </div>
	  <xsl:apply-templates select="./dct:description"/>
	</dd>
      </xsl:for-each>
    </dl>
  </xsl:template>


</xsl:stylesheet>