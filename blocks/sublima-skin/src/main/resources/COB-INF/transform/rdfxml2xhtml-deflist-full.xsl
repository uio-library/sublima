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
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr">
  <xsl:import href="rdfxml-res-templates.xsl"/>
  <xsl:output indent="yes"/>

  <xsl:param name="interface-language">no</xsl:param>
  <xsl:param name="baseurl"/>

  <xsl:template match="rdf:RDF" mode="results-full">
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
       short description
    </a>    
    
    <a>
       <xsl:attribute name="href">
          <xsl:value-of select="concat($gen-req, '&amp;res-view=medium')"/>
       </xsl:attribute>
       medium description
    </a>    
    <!--
    <a>
       <xsl:attribute name="href">
        <xsl:value-of select="concat($gen-req, '&amp;res-view=full')"/>
       </xsl:attribute>
       full description
    </a>
    -->
    

    
    <xsl:for-each select="sub:Resource"> <!-- The root node for each described resource -->
        <xsl:sort select="./*[name() = $sorting]"/>

    <br/>
    <table>
      
      <tr>
	<th colspan="2" scope="col">
	  <xsl:apply-templates select="./dct:title" mode="external-link"/> <xsl:if test="../../c:loggedin = 'true'"> - <a href="{$baseurl}/admin/ressurser/edit?uri={./@rdf:about}{$aloc}">[Edit]</a> </xsl:if>
    </th>
      </tr>
      <tr>
	<th scope="row">
    <i18n:text key="search.result.publishedby">Publisert av</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="./dct:publisher" mode="external-link" />
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="topics">Emner</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="./dct:subject"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="description">Beskrivelse</i18n:text>
	</th>
	<td>
	  <xsl:apply-templates select="./dct:description"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="admin.approvedby">Redaksjonelt godkjent av</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="./sub:committer"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="admin.posteddate">Innsendt</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="./dct:dateSubmitted"/>
	</td>
      </tr>
     
      <tr>
	<th scope="row">
	  <i18n:text key="admin.accepteddate">Akseptert</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="./dct:dateAccepted"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="language">Språk</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="./dct:language"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="type">Type</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="./dct:format"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="status">Status</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="./wdr:describedBy"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="audience">Målgruppe</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="./dct:audience" />
	</td>
      </tr>
     
    </table>
    
    </xsl:for-each>

  </xsl:template>


</xsl:stylesheet>