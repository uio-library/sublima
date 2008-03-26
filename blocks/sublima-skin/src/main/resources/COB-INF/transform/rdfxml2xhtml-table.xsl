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
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc od lingvoj wdr">
  <xsl:import href="rdfxml-res-templates.xsl"/>
  <xsl:output indent="yes"/>

  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="rdf:RDF" mode="resource">
    <table>
      
      <tr>
	<th scope="col">
	  <xsl:apply-templates select="sub:Resource/dct:title" mode="external-link"/>
	</th>
      </tr>
      <tr>
	<td>
	  <xsl:variable name="uri" select="dct:publisher/@rdf:resource"/>
	  <xsl:apply-templates select="../*[@rdf:about=$uri]" mode="external-link" />
	</td>
      </tr>
      <tr>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:subject"/>
	</td>
      </tr>
      <tr>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:description"/>
	</td>
      </tr>
      <tr>
	<td>
	  <xsl:apply-templates select="sub:Resource/sub:committer"/>
	</td>
      </tr>
      <tr>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:dateAccepted"/>
	</td>
      </tr>
      <tr>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:language"/>
	</td>
      </tr>
      <tr>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:type"/>
	</td>
      </tr>
      <tr>
	<td>
	  <xsl:apply-templates select="sub:Resource/wdr:describedBy"/>
	</td>
      </tr>
      <tr>
	<td>
	  <xsl:variable name="uri" select="dct:audience/@rdf:resource"/>
	  <xsl:apply-templates select="../*[@rdf:about=$uri]" />
	</td>
      </tr>

    </table>
  </xsl:template>


</xsl:stylesheet>