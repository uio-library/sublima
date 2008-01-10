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
  xmlns="http://www.w3.org/1999/xhtml" 
  >
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
	    <xsl:variable name="uri" select="dc:audience/@rdf:resource"/>
	    <xsl:apply-templates select="../*[@rdf:about=$uri]" />
	  </td>

	</tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="foaf:Agent|foaf:Person|foaf:Group|foaf:Organization" mode="external-link">
    <xsl:choose>
      <xsl:when test="foaf:homepage">
	<a href="{foaf:homepage/@rdf:resource}"><xsl:value-of select="foaf:name"/></a>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="foaf:name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dc:title" mode="internal-link">
    <xsl:if test="@xml:lang=$interface-language">
      <a href="{../dc:identifier/@rdf:resource}"><xsl:value-of select="."/></a>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="dc:description">
    <xsl:if test="@xml:lang=$interface-language">
      <xsl:copy-of select="node()"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="sub:committer">
    <xsl:value-of select="./sioc:User/rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>
 
  <xsl:template match="dct:dateAccepted|dct:dateSubmitted">
    <xsl:value-of select="substring-before(., 'T')"/>
  </xsl:template>

  <xsl:template match="dc:subject">
    <a href="{./*/@rdf:about}"><xsl:value-of select="./*/rdfs:label[@xml:lang=$interface-language]"/></a>
  </xsl:template>

  <xsl:template match="sub:Audience">
    <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>

  <xsl:template match="dc:language">
    <xsl:value-of select="./lingvoj:Lingvo/rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>

</xsl:stylesheet>