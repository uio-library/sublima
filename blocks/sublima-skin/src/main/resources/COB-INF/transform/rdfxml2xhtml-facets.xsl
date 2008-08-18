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
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr">

  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="rdf:RDF" mode="facets">
    <xsl:variable name="baseurlparams">
      <xsl:choose>
  	<xsl:when test="/c:page/c:mode = 'topic'">
	  <xsl:text>../search-result.html?dct:subject=</xsl:text>
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
   <i18n:text key="language">Språk</i18n:text>
   <xsl:if test="sub:Resource/dct:language">
    <ul>
      <xsl:apply-templates select="sub:Resource/dct:language" mode="facets">
	   <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
 	   <xsl:sort select="lingvoj:Lingvo/rdfs:label[@xml:lang=$interface-language]"/>
      </xsl:apply-templates> 
    </ul>
   </xsl:if>
   </div>
   
   <xsl:if test="sub:Resource/dct:audience">
     <div class="facet">
       <i18n:text key="audience">Målgruppe</i18n:text>
       <ul>
	 <xsl:apply-templates select="sub:Resource/dct:audience" mode="facets">
	   <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
	    <xsl:sort select="dct:AgentClass/rdfs:label[@xml:lang=$interface-language]"/>
	 </xsl:apply-templates> 
       </ul>
     </div>
   </xsl:if>
   
   
   

    <div class="facet">    
   
   <!-- sorted by preffered label -->
    <i18n:text key="topic">Emne</i18n:text> 
    <xsl:if test="sub:Resource/dct:subject">
    <ul>
      <xsl:apply-templates select="sub:Resource/dct:subject[skos:Concept]" mode="facets">
       
	    <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
       <xsl:sort select="skos:Concept/skos:prefLabel[@xml:lang=$interface-language]"/>
      </xsl:apply-templates> 
    </ul>
    </xsl:if>

    <xsl:if test="sub:Resource/dct:subject[skos:Concept][position() &gt; 1]">
      <span class="more"><a href="javascript:void(0);showHide('collapse');showHide('more');" ><i18n:text key="more">more</i18n:text> &#187;</a></span>
    </xsl:if>

    
    </div>
    </div>
    <br/>
   </xsl:template>

  <xsl:template match="dct:subject" mode="facets">
    <xsl:param name="baseurlparams"/>
    <xsl:variable name="uri" select="./skos:Concept/@rdf:about"/>
    <xsl:call-template name="facet-field">
      <xsl:with-param name="max-facets-more">4</xsl:with-param>
      <xsl:with-param name="this-field">dct:subject</xsl:with-param>
      <xsl:with-param name="this-label" select="./skos:Concept/skos:prefLabel[@xml:lang=$interface-language]"/>
      <xsl:with-param name="uri" select="$uri"/>
      <xsl:with-param name="count"  select="count(//dct:subject[@rdf:resource=$uri])+1"/>
      <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
 
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dct:language" mode="facets">
    <xsl:param name="baseurlparams"/>
    <xsl:variable name="uri" select="./lingvoj:Lingvo/@rdf:about"/>
    <xsl:call-template name="facet-field">
      <xsl:with-param name="max-facets-more">4</xsl:with-param>
      <xsl:with-param name="this-field">dct:language</xsl:with-param>
      <xsl:with-param name="this-label" select="./lingvoj:Lingvo/rdfs:label[@xml:lang=$interface-language]"/>
      <xsl:with-param name="uri" select="$uri"/>
      <xsl:with-param name="count"  select="count(//dct:language[@rdf:resource=$uri])+1"/>
      <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
 
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dct:audience" mode="facets">
    <xsl:param name="baseurlparams"/>
    <xsl:variable name="uri" select="./dct:AgentClass/@rdf:about"/>
    <xsl:call-template name="facet-field">
      <xsl:with-param name="max-facets-more">4</xsl:with-param>
      <xsl:with-param name="this-field">dct:audience</xsl:with-param>
      <xsl:with-param name="this-label" select="./dct:AgentClass/rdfs:label[@xml:lang=$interface-language]"/>
      <xsl:with-param name="uri" select="$uri"/>
      <xsl:with-param name="count" select="count(//dct:audience[@rdf:resource=$uri])+1"/>
      <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
    </xsl:call-template>  
  </xsl:template>


  <!-- This template can used to construct facets. See the above for examples.
       it takes a number of parameters:

         max-facets-more - This number sets how many items should be shown untill 
	                   the user clicks "more". This is optional, defaults to 3.
         baseurlparams   - Should be passed from other templates.
	 this-field      - The machine field, e.g. dct:subject.
	 this-label      - The human-readable label for this facet.
         uri             - The URI for the resource that uses this-label
	 count           - The number of resources that has this label.
	  
  -->



  <xsl:template name="facet-field">
    <xsl:param name="max-facets-more">3</xsl:param>
    <xsl:param name="baseurlparams"/>
    <xsl:param name="this-label"/>
    <xsl:param name="this-field"/>
    <xsl:param name="uri"/>
    <xsl:param name="count"/>
    <xsl:if test="$uri">
      <li>
	<xsl:if test="position() &gt; $max-facets-more"> <!-- This number sets how many items should be shown untill the user clicks "more" -->
	  <xsl:attribute name="class">collapse</xsl:attribute>
	  <xsl:attribute name="style">display : none;</xsl:attribute>
	</xsl:if>
	
	<xsl:choose>
	  <xsl:when test="$count = $numberofhits">
	    <xsl:value-of select="$this-label"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <a> <!-- The following builds the URL. -->
	      <xsl:attribute name="href">
		<xsl:value-of select="$baseurlparams"/>
		<xsl:value-of select="$this-field"/>
		<xsl:text>=</xsl:text>
		<xsl:value-of select="$uri"/>
		<xsl:value-of select="$aloc"/>
	      </xsl:attribute>
	      <xsl:value-of select="$this-label"/>
	    </a>
	  </xsl:otherwise>
	</xsl:choose>
	<bdo dir="ltr">
	  (<xsl:value-of select="$count"/>)
	</bdo>
	<xsl:if test="/c:page/c:facets/c:request/c:param[@key = $this-field]/c:value = $uri">
	  <a>
	    <xsl:attribute name="href">
	      <xsl:call-template name="uri-for-facet-remove">
		<xsl:with-param name="key" select="$this-field"/>
		<xsl:with-param name="value" select="$uri"/>
	      </xsl:call-template>
	    </xsl:attribute>
	    Fjern
	  </a>
	</xsl:if>
      </li>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="uri-for-facet-remove">
    <xsl:param name="key"/>
    <xsl:param name="value"/>
    <xsl:text>search-result.html?</xsl:text>
    <xsl:for-each select="/c:page/c:facets/c:request/c:param">
      <xsl:for-each select="c:value">
	<xsl:if test="not(../@key = $key and . = $value)">
	  <xsl:value-of select="../@key"/>=<xsl:value-of select="."/>&amp;<xsl:text/>
	</xsl:if>
      </xsl:for-each>
    </xsl:for-each>
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