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
    <table>
      <xsl:for-each select="rdf:Description"> <!-- The root node for each described resource -->
	<tr>
	  <th scope="row">
	    <xsl:apply-templates select="./dc:title" mode="internal-link"/>
	  </th>
	  <td>
	    <xsl:variable name="uri" select="dc:publisher/@rdf:resource"/>
	    <xsl:apply-templates select="../*[@rdf:about=$uri]" mode="external-link" />
	  </td>
	  <td>
	    <xsl:apply-templates select="./dc:subject"/>
	  </td>
	  <td>
	    <xsl:apply-templates select="./dc:description"/>
	  </td>
	  <td>
	    <xsl:apply-templates select="./sub:committer"/>
	  </td>
	  <td>
	    <xsl:apply-templates select="./dct:dateAccepted"/>
	  </td>
	  <td>
	    <xsl:apply-templates select="./dc:language"/>
	  </td>
	  <td>
	    <xsl:apply-templates select="./dc:type"/>
	  </td>
	  <td>
	    <xsl:apply-templates select="./wdr:describedBy"/>
	  </td>
	  <td>
	    <xsl:variable name="uri" select="dc:audience/@rdf:resource"/>
	    <xsl:apply-templates select="../*[@rdf:about=$uri]" />
	  </td>

	</tr>
      </xsl:for-each>
    </table>
  </xsl:template>


</xsl:stylesheet>