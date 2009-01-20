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
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns:sioc="http://rdfs.org/sioc/ns#"
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="c:relations" mode="listallrelationtypes">
    <ul>
      <xsl:for-each select="./rdf:RDF/owl:ObjectProperty | ./rdf:RDF/owl:SymmetricProperty">
        <xsl:sort lang="{$interface-language}" select="./rdfs:label"/>
        <li>
          <xsl:choose>
            <xsl:when test="contains(./@rdf:about, '#')">
              <xsl:variable name="uri">
                <xsl:value-of select="substring-before(./@rdf:about, '#')"/><xsl:text>%23</xsl:text><xsl:value-of select="substring-after(./@rdf:about, '#')"/>
              </xsl:variable>
              <a href="{$baseurl}/admin/emner/relasjoner/relasjon?the-resource={$uri}{$aloc}">
                <xsl:value-of select="./rdfs:label"/>
              </a>
            </xsl:when>

            <xsl:otherwise>
              <a href="{$baseurl}/admin/emner/relasjoner/relasjon?the-resource={./@rdf:about}{$aloc}">
                <xsl:value-of select="./rdfs:label"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
</xsl:stylesheet>