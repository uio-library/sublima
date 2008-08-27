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
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr"
  >

  <xsl:template match="skos:Concept">
    <xsl:param name="role"/>
    <xsl:variable name="uri" select="@rdf:about"/>
    <div class="skos:Concept">
      <p>
	<xsl:variable name="label-uri" select="concat(namespace-uri(..), local-name(..))"/>
	<xsl:if test="//owl:ObjectProperty[@rdf:about = $label-uri]/rdfs:label[@xml:lang=$interface-language]">
	  <xsl:value-of select="//owl:ObjectProperty[@rdf:about = $label-uri]/rdfs:label[@xml:lang=$interface-language]"/>
	  <xsl:text>: </xsl:text>
	</xsl:if>
	<xsl:choose>
	
	  <!-- The main concept --> 
	  <xsl:when test="$role='this-param'">
	    <h4><xsl:value-of select="skos:prefLabel[@xml:lang=$interface-language]"/></h4>
	  </xsl:when>
	  
	  <!-- or any other concept -->
	  <xsl:otherwise>
	    <a href="{$uri}.html{$qloc}"><xsl:value-of select="skos:prefLabel[@xml:lang=$interface-language]"/></a>
	  </xsl:otherwise>
	</xsl:choose>
      </p>
      
      <!-- Synonyms -->
      <xsl:if test="$role='this-param' and skos:altLabel[@xml:lang=$interface-language]">
	<p>
	  <i18n:text key="synonym">Synonym</i18n:text>: <xsl:value-of select="skos:altLabel[@xml:lang=$interface-language]"/>
	</p>
      </xsl:if>

      <!-- Now, run through all nodes that has skos:Concept as child
	   node. These will be nodes that this concept has a relation
           to. -->
           
      <!-- We could here also sort by the specific relation, i.e.  
      //owl:ObjectProperty[@rdf:about = $label-uri]/rdfs:label[@xml:lang=$interface-language] 
      for now sorting alphabetically on all the concepts regardless of relation.
      -->   
      
      <xsl:apply-templates select="./*/skos:Concept">
	<xsl:sort select="skos:prefLabel[@xml:lang=$interface-language]"/>
      </xsl:apply-templates> 
    </div>
    
  </xsl:template>
</xsl:stylesheet>