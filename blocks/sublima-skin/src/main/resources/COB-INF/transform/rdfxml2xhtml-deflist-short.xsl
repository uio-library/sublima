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
  xmlns:wdr="http://www.w3.org/2007/05/powder#"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:url="http://whatever/java/java.net.URLEncoder"
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr">
  <xsl:import href="rdfxml-res-templates.xsl"/>


  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="rdf:RDF" mode="results-short">
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
    
    
    <!--
    <a>
       <xsl:attribute name="href">
          <xsl:value-of select="concat($gen-req, '&amp;res-view=short')"/>
       </xsl:attribute>
       short description
    </a>    
    -->
    <a>
       <xsl:attribute name="href">
         <xsl:choose>
           <xsl:when test="not(contains(/c:page/c:facets/c:request/@requesturl, '?'))">
            <xsl:value-of select="concat($gen-req, '?res-view=medium')"/>
           </xsl:when>
           <xsl:otherwise>
            <xsl:value-of select="concat($gen-req, '&amp;res-view=medium')"/>
           </xsl:otherwise>
         </xsl:choose>
       </xsl:attribute>
       <i18n:text key="mediumdescription">medium description </i18n:text>
    </a>    
    <a>
       <xsl:attribute name="href">
         <xsl:choose>
           <xsl:when test="not(contains(/c:page/c:facets/c:request/@requesturl, '?'))">
            <xsl:value-of select="concat($gen-req, '?res-view=full')"/>
           </xsl:when>
           <xsl:otherwise>
            <xsl:value-of select="concat($gen-req, '&amp;res-view=full')"/>
           </xsl:otherwise>
         </xsl:choose>
       </xsl:attribute>
       <i18n:text key="fulldescription">full description</i18n:text>
    </a>

    
    <xsl:variable name="loggedin"><xsl:value-of select="//c:loggedin"/></xsl:variable>
    <dl>
      <xsl:for-each select="sub:Resource"> <!-- The root node for each described resource -->
        <xsl:sort lang="{$interface-language}" select="./*[name() = $sorting]"/>

  <dt>
	  <xsl:apply-templates select="./dct:title" mode="internal-link"/>
      <xsl:if test="$loggedin = 'true'">-
            <a href="{$baseurl}/admin/ressurser/edit?uri={url:encode(./@rdf:about)}{$aloc}">[Edit]</a>
      </xsl:if>
	</dt>
      </xsl:for-each>
    </dl>
  </xsl:template>


</xsl:stylesheet>