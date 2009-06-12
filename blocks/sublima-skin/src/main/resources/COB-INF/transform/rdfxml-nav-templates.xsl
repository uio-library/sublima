<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:sub="http://xmlns.computas.com/sublima#"
  xmlns:sioc="http://rdfs.org/sioc/ns#"
  xmlns:lingvoj="http://www.lingvoj.org/ontology#"
  xmlns:wdr="http://www.w3.org/2007/05/powder#"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:c="http://xmlns.computas.com/cocoon"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr"
  >


  <xsl:template match="skos:Concept">
    <!-- uri is the URI of the concept we are on -->
    <xsl:variable name="uri" select="@rdf:about"/>

    <h3 class="subHeading">
      <i18n:text key="seealso">Se også</i18n:text>
    </h3>
    <div id="navi">   
	
      <xsl:for-each select="/c:page/c:navigation/rdf:RDF/*[rdfs:subPropertyOf/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#semanticRelation']">
	<h4><xsl:value-of select="rdfs:label[@xml:lang=$interface-language]"/></h4>
	<xsl:variable name="label-uri" select="@rdf:about"/>
	<ul>
	  <xsl:for-each select="/c:page/c:navigation/rdf:RDF/skos:Concept/*">
	    <!-- The order isn't entirely predictable since multiple
		 concepts will be pointed to from different relations -->
	    <xsl:sort lang="{$interface-language}"
		      select=".//skos:Concept/skos:prefLabel[@xml:lang=$interface-language]"/>

	    <xsl:choose>
	      <xsl:when test="$label-uri = concat(namespace-uri(.), local-name(.)) and ./@rdf:resource">
		<xsl:variable name="concept-uri" select="./@rdf:resource"/>
		<xsl:apply-templates select="//skos:Concept[@rdf:about = $concept-uri]" mode="link"/>
	      </xsl:when>
	      <xsl:when test="$label-uri = concat(namespace-uri(.), local-name(.))">
		<xsl:apply-templates select="./skos:Concept" mode="link"/>
	      </xsl:when>
	    </xsl:choose>
	  </xsl:for-each>
	</ul>
      </xsl:for-each>
	
    </div>
  </xsl:template>

  <xsl:template match="skos:Concept" mode="link">
    <li><a href="{@rdf:about}.html{$qloc}"><xsl:value-of select="skos:prefLabel[@xml:lang=$interface-language]"/></a></li>
  </xsl:template>

</xsl:stylesheet>