<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:lingvoj="http://www.lingvoj.org/ontology#"
        xmlns:wdr="http://www.w3.org/2007/05/powder#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:sub="http://xmlns.computas.com/sublima#"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">

  <xsl:import href="rdfxml2html-lang-dropdown.xsl"/>
  <xsl:param name="interface-language">no</xsl:param>

<xsl:template name="labels">
    <xsl:param name="field"/>
    <xsl:param name="label"/>
    <xsl:param name="value"/>
    <xsl:param name="type"/>
    <xsl:param name="default-language"/>
    <tr>
      <th scope="row">
	<label for="{$field}"><xsl:value-of select="$label"/></label>
      </th>
      <td>
        <xsl:choose>
          <xsl:when test="$type = 'text'">
            <input id="{$field}" type="{$type}"
             name="{$field}" size="20"
             value="{$value}"/>
          </xsl:when>
          <xsl:when test="$type = 'textarea'">
             <textarea id="{$field}" name="{$field}" rows="6" cols="40">...<xsl:value-of select="$value"/>
            </textarea>
          </xsl:when>
        </xsl:choose>
      </td>
      <td>
	<select name="{$field}">
	  <xsl:apply-templates select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo" mode="list-options">
	    <xsl:with-param name="default-language" select="$default-language"/>
	    <xsl:sort select="./rdfs:label[@xml:lang=$interface-language]"/>
	  </xsl:apply-templates>
	</select>
      </td>

    </tr>
  </xsl:template>
</xsl:stylesheet>