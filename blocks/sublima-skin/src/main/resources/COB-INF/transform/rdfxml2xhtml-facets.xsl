<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:c="http://xmlns.computas.com/cocoon"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"   
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
  xmlns:dct="http://purl.org/dc/terms/" 
  xmlns:foaf="http://xmlns.com/foaf/0.1/" 
  xmlns:sub="http://xmlns.computas.com/sublima#"
  xmlns:sioc="http://rdfs.org/sioc/ns#"
  xmlns:lingvoj="http://www.lingvoj.org/ontology#"
  xmlns:wdr="http://www.w3.org/2007/05/powder#"
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr">
  <!-- xsl:import href="rdfxml-res-templates.xsl"/ -->
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="rdf:RDF" mode="facets">
    <xsl:variable name="baseurlparams">
      <xsl:choose>
	<xsl:when test="/c:page/c:mode = 'topic-instance'">
	  <xsl:text>../search-result?dct:subject/rdfs:label=</xsl:text>
	  <xsl:value-of select="/c:page/c:navigation/rdf:RDF/skos:Concept/skos:prefLabel[@xml:lang=$interface-language]"/>
	  <xsl:text>&amp;</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>?</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:for-each select="/c:page/c:facets/c:request/c:param">
	<xsl:for-each select="c:value">
	  <xsl:if test="text()">
	    <xsl:value-of select="../@key"/>=<xsl:value-of select="."/>&amp;<xsl:text/>
	  </xsl:if>
	</xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
   <ul>
      <xsl:apply-templates select="sub:Resource/dct:language" mode="facets">
	<xsl:with-param name="baseurlparams" select="$baseurlparams"/>
      </xsl:apply-templates> 
   </ul>
   <ul>
      <xsl:apply-templates select="sub:Resource/dct:audience" mode="facets">
	<xsl:with-param name="baseurlparams" select="$baseurlparams"/>
      </xsl:apply-templates> 
   </ul>
    <ul>
      <xsl:apply-templates select="sub:Resource/dct:subject" mode="facets">
	<xsl:with-param name="baseurlparams" select="$baseurlparams"/>
      </xsl:apply-templates>
    </ul>
   </xsl:template>


  <xsl:template match="dct:subject" mode="facets">
    <xsl:param name="baseurlparams"/>
    <xsl:if test="./skos:Concept"> <!-- This should iterate all unique topics -->
      <li>
	<xsl:variable name="this-label" select="./skos:Concept/rdfs:label[@xml:lang=$interface-language]"/>
	<a> <!-- The following builds the URL. -->
	  <xsl:attribute name="href">
	    <xsl:value-of select="$baseurlparams"/>
	    <xsl:text>dct:subject/rdfs:label=</xsl:text>
	    <xsl:value-of select="$this-label"/>
	  </xsl:attribute>
	  <xsl:value-of select="$this-label"/>
	</a>

	<xsl:variable name="uri" select="./skos:Concept/@rdf:about"/>
	<xsl:text> (</xsl:text>
	<xsl:value-of select="count(//dct:subject[@rdf:resource=$uri])+1"/>)
      </li>
    </xsl:if>
    
  </xsl:template>

  <xsl:template match="dct:language" mode="facets">
    <xsl:param name="baseurlparams"/>
    <xsl:if test="./lingvoj:Lingvo"> <!-- This should iterate all unique languages -->
      <li>
	<xsl:variable name="this-label" select="./lingvoj:Lingvo/rdfs:label[@xml:lang=$interface-language]"/>
	<a> <!-- The following builds the URL. -->
	  <xsl:attribute name="href">
	    <xsl:value-of select="$baseurlparams"/>
	    <xsl:text>dct:language/rdfs:label=</xsl:text>
	    <xsl:value-of select="$this-label"/>
	  </xsl:attribute>
	  <xsl:value-of select="$this-label"/>
	</a>

	<xsl:variable name="uri" select="./lingvoj:Lingvo/@rdf:about"/>
	<xsl:text> (</xsl:text>
	<xsl:value-of select="count(//dct:language[@rdf:resource=$uri])+1"/>)
      </li>
    </xsl:if>
    
  </xsl:template>

  <xsl:template match="dct:audience" mode="facets">
    <xsl:param name="baseurlparams"/>
    <xsl:if test="./dct:AgentClass"> <!-- This should iterate all unique languages -->
      <li>
	<xsl:variable name="this-label" select="./dct:AgentClass/rdfs:label[@xml:lang=$interface-language]"/>
	<a> <!-- The following builds the URL. -->
	  <xsl:attribute name="href">
	    <xsl:value-of select="$baseurlparams"/>
	    <xsl:text>dct:audience/rdfs:label=</xsl:text>
	    <xsl:value-of select="$this-label"/>
	  </xsl:attribute>
	  <xsl:value-of select="$this-label"/>
	</a>

	<xsl:variable name="uri" select="./dct:AgentClass/@rdf:about"/>
	<xsl:text> (</xsl:text>
	<xsl:value-of select="count(//dct:audience[@rdf:resource=$uri])+1"/>)
      </li>
    </xsl:if>
    
  </xsl:template>

</xsl:stylesheet>