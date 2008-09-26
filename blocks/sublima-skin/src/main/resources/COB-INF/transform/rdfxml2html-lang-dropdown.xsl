<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://xmlns.computas.com/cocoon"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:lingvoj="http://www.lingvoj.org/ontology#"
    xmlns="http://www.w3.org/1999/xhtml"
    version="1.0">

  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="lingvoj:Lingvo" mode="list-options">
    <xsl:param name="default-language"/>
    <xsl:choose>
      <xsl:when test="concat('http://www.lingvoj.org/lang/', $default-language) = ./@rdf:about">
	<option value="{./@rdf:about}" selected="selected">
	  <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
	</option>
      </xsl:when>
      <xsl:otherwise>
	<option value="{./@rdf:about}">
	  <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
	</option>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>