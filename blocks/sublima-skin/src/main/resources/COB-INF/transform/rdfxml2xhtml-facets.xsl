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
  	<xsl:when test="/c:page/c:mode = 'topic'">
	  <xsl:text>../search-result?dct:subject=</xsl:text>
	  <xsl:value-of select="/c:page/c:navigation/rdf:RDF/skos:Concept/@rdf:about"/>
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
    
    <div class="facets">
   <div class="facet">
   Språk
   <xsl:if test="sub:Resource/dct:language">
    <ul>
      <xsl:apply-templates select="sub:Resource/dct:language" mode="facets">
	   <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
      </xsl:apply-templates> 
    </ul>
   </xsl:if>
   </div>
   
   <xsl:if test="sub:Resource/dct:audience">
     <div class="facet">
       Målgruppe
       <ul>
	 <xsl:apply-templates select="sub:Resource/dct:audience" mode="facets">
	   <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
	 </xsl:apply-templates> 
       </ul>
     </div>
   </xsl:if>
   

    <div class="facet">    
    Emne
   <xsl:if test="sub:Resource/dct:subject">
    <ul>
      <xsl:apply-templates select="sub:Resource/dct:subject[skos:Concept]" mode="facets">
	<xsl:with-param name="baseurlparams" select="$baseurlparams"/>
      </xsl:apply-templates> 
    </ul>
    </xsl:if>

    <xsl:if test="sub:Resource/dct:subject[skos:Concept][position() &gt; 1]">
      <span class="more"><a href="javascript:void(0);showHide('collapse');showHide('more');" >more &#187;</a></span>
    </xsl:if>

    
    </div>
    </div>
    <br/>
   </xsl:template>


  <xsl:template match="dct:subject" mode="facets">
    <xsl:param name="baseurlparams"/>
    <li>
      <xsl:if test="position() &gt; 2"> <!-- This number sets how many items should be shown untill the user clicks "more" -->
	<xsl:attribute name="class">collapse</xsl:attribute>
	<xsl:attribute name="style">display : none;</xsl:attribute>
      </xsl:if>
      <xsl:variable name="this-label" select="./skos:Concept/skos:prefLabel[@xml:lang=$interface-language]"/>
      <xsl:variable name="uri" select="./skos:Concept/@rdf:about"/>

      <a> <!-- The following builds the URL. -->
	<xsl:attribute name="href">
	  <xsl:value-of select="$baseurlparams"/>
	  <xsl:text>dct:subject=</xsl:text>
	  <xsl:value-of select="$uri"/>
	</xsl:attribute>
	<xsl:value-of select="$this-label"/>
      </a>
      <xsl:text> (</xsl:text>
      <xsl:value-of select="count(//dct:subject[@rdf:resource=$uri])+1"/>)
    </li>
  </xsl:template>



  <xsl:template match="dct:language" mode="facets">
    <xsl:param name="baseurlparams"/>
    <xsl:if test="./lingvoj:Lingvo"> <!-- This should iterate all unique languages -->
      <li>
	<xsl:variable name="this-label" select="./lingvoj:Lingvo/rdfs:label[@xml:lang=$interface-language]"/>
	<xsl:variable name="uri" select="./lingvoj:Lingvo/@rdf:about"/>
	<a> <!-- The following builds the URL. -->
	  <xsl:attribute name="href">
	    <xsl:value-of select="$baseurlparams"/>
	    <xsl:text>dct:language=</xsl:text>
	    <xsl:value-of select="$uri"/>
	  </xsl:attribute>
	  <xsl:value-of select="$this-label"/>
	</a>

	<xsl:text> (</xsl:text>
	<xsl:value-of select="count(//dct:language[@rdf:resource=$uri])+1"/>)
      </li>
    </xsl:if>
    
  </xsl:template>

  <xsl:template match="dct:audience" mode="facets">
    <xsl:param name="baseurlparams"/>
    <xsl:if test="./dct:AgentClass"> 
      <li>
	<xsl:variable name="this-label" select="./dct:AgentClass/rdfs:label[@xml:lang=$interface-language]"/>
	<xsl:variable name="uri" select="./dct:AgentClass/@rdf:about"/>
	<a> <!-- The following builds the URL. -->
	  <xsl:attribute name="href">
	    <xsl:value-of select="$baseurlparams"/>
	    <xsl:text>dct:audience=</xsl:text>
	    <xsl:value-of select="$uri"/>
	  </xsl:attribute>
	  <xsl:value-of select="$this-label"/>
	</a>

	<xsl:variable name="uri" select="./dct:AgentClass/@rdf:about"/>
	<xsl:text> (</xsl:text>
	<xsl:value-of select="count(//dct:audience[@rdf:resource=$uri])+1"/>)
      </li>
    </xsl:if>
    
  </xsl:template>
  
  
  <xsl:template match="root">
<xsl:copy>
<xsl:apply-templates>
<xsl:sort select="position()"
order="descending"
data-type="number"/>
</xsl:apply-templates>
</xsl:copy>
</xsl:template>
  

</xsl:stylesheet>