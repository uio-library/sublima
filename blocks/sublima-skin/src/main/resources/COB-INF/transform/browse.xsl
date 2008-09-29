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
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language"/>

  <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyzæøåäö</xsl:variable>
  <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅÄÖ</xsl:variable>

  <xsl:template match="c:browse" mode="browse">
    <xsl:if test="./rdf:RDF/skos:Concept">
      <ul>
        <xsl:for-each select="./rdf:RDF//skos:Concept">
          <xsl:sort lang="{$interface-language}" select="./skos:prefLabel"/>

          <xsl:choose>
            <xsl:when test="/c:page/c:letter = ''">
              <li>
              <a href="{./@rdf:about}.html{$qloc}">
                <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
              </a>
              </li>                
            </xsl:when>

            <xsl:otherwise>

              <xsl:if test="starts-with(translate(./skos:prefLabel[@xml:lang=$interface-language], $ucletters, $lcletters), /c:page/c:letter)">
                <li>
                  <a href="{./@rdf:about}.html{$qloc}">
                    <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                  </a>
                </li>    
              </xsl:if>

              <xsl:if test="starts-with(translate(./skos:altLabel[@xml:lang=$interface-language], $ucletters, $lcletters), /c:page/c:letter)">
                <li>
                  <a href="{./@rdf:about}.html{$qloc}">
                    <xsl:value-of select="./skos:altLabel[@xml:lang=$interface-language]"/>
                  </a>
                </li>
              </xsl:if>

            </xsl:otherwise>

          </xsl:choose>
        </xsl:for-each>
      </ul>
    </xsl:if>

  </xsl:template>
</xsl:stylesheet>