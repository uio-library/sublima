<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:c="http://xmlns.computas.com/cocoon"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"   
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
  xmlns:dct="http://purl.org/dc/terms/" 
  xmlns:foaf="http://xmlns.com/foaf/0.1/" 
  xmlns:sub="http://xmlns.computas.com/sublima#"
  xmlns:sioc="http://rdfs.org/sioc/ns#"
  xmlns:lingvoj="http://www.lingvoj.org/ontology#"  
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:wdr="http://www.w3.org/2007/05/powder#"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr">
  <xsl:import href="rdfxml-res-templates.xsl"/>


  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="rdf:RDF" mode="results">
    <xsl:param name="sorting"/>
    
    <!-- views -->
    <!-- "just" remove the res-view attribute -->
    <!-- issue: a & is left.... -->
    <xsl:param name="gen-req">
    <xsl:choose>
	<xsl:when test="contains(/c:page/c:facets/c:request/@requesturl, 'res-view=short')">
	  <xsl:value-of select="concat(substring-before(/c:page/c:facets/c:request/@requesturl, 'res-view=short'),  substring-after(/c:page/c:facets/c:request/@requesturl, 'res-view=short'))"/>
	</xsl:when>
	<xsl:when test="contains(/c:page/c:facets/c:request/@requesturl, 'res-view=full')">
	  <xsl:value-of select="concat(substring-before(/c:page/c:facets/c:request/@requesturl, 'res-view=full'),  substring-after(/c:page/c:facets/c:request/@requesturl, 'res-view=full'))"/>
	</xsl:when>
	<xsl:when test="contains(/c:page/c:facets/c:request/@requesturl, 'res-view=medium')">
	  <xsl:value-of select="concat(substring-before(/c:page/c:facets/c:request/@requesturl, 'res-view=medium'),  substring-after(/c:page/c:facets/c:request/@requesturl, 'res-view=medium'))"/>
	</xsl:when>

	<xsl:otherwise>
	<xsl:value-of select="/c:page/c:facets/c:request/@requesturl"/>
    </xsl:otherwise>
	</xsl:choose>
	</xsl:param>
    
    

    <a>
       <xsl:attribute name="href">
          <xsl:value-of select="concat($gen-req, '&amp;res-view=short')"/>
       </xsl:attribute>
       short description</a>
    <xsl:text>  </xsl:text>    
<!--
    <a>
       <xsl:attribute name="href">
          <xsl:value-of select="concat($gen-req, '&amp;res-view=medium')"/>
       </xsl:attribute>
       medium description</a>
    <xsl:text> </xsl:text>    
      
-->
      <a>
       <xsl:attribute name="href">
        <xsl:value-of select="concat($gen-req, '&amp;res-view=full')"/>
       </xsl:attribute>
       full description</a>
    
    
    
    <!-- testing if we can insert a relevance sorting attribute in the RESOURCE tree -->

    <!-- we have either come to this by navigation or search. If first we have a URI
         for the topic, if second we have a search string. --> 
         
   <xsl:variable name="topic-uri" select="/c:page/c:navigation/rdf:RDF/skos:Concept/@rdf:about" />
   <xsl:variable name="search-string" select="/c:page/c:searchparams/c:searchparams/c:searchstring"/>

    <xsl:variable name="res-copy">
        <xsl:for-each select="sub:Resource">
          <sub:Resource rdf:about="{./@rdf:about}"> 
           <xsl:if test="$topic-uri != ''"> 
                <sub:relevance>
                    <xsl:value-of select="count(./dct:subject)"/>
                </sub:relevance>
           </xsl:if> 
           <xsl:if test="$search-string !='' and contains(./dct:subject/skos:prefLabel, $search-string)">
                <sub:relevance>
                    <xsl:value-of select="1"/>
                </sub:relevance>
           </xsl:if>  
            <xsl:copy-of select="./*"/>
           </sub:Resource>
        </xsl:for-each> 
    </xsl:variable>
    

    
    
    
    <dl>
<!--      <xsl:for-each select="sub:Resource"> 
        <xsl:sort select="./*[name() = $sorting]"/> -->
<!-- The root node for each described resource -->
       <xsl:for-each select="xalan:nodeset($res-copy)/sub:Resource">
          <xsl:sort select="./sub:relevance"/> 
        

  <dt>
	  <xsl:apply-templates select="./dct:title" mode="internal-link"/>
	  <i18n:text key="search.result.hastopic">har emne</i18n:text><xsl:text> </xsl:text>
    <xsl:apply-templates select="./dct:subject"/>
	</dt>
	<dd>
	  <div style="font-size:small"><i18n:text key="search.result.publishedby">Publisert av</i18n:text><xsl:text>: </xsl:text>
	    <xsl:apply-templates select="dct:publisher"/>
	    <xsl:text> </xsl:text>
	    <xsl:apply-templates select="./dct:dateAccepted"/>
	  </div>
	  <xsl:apply-templates select="./dct:description"/>
	</dd>
      </xsl:for-each>
    </dl>
  </xsl:template>


</xsl:stylesheet>