<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:c="http://xmlns.computas.com/cocoon"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"   
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
  xmlns:dct="http://purl.org/dc/terms/" 
  xmlns:foaf="http://xmlns.com/foaf/0.1/" 
  xmlns:sublima="http://xmlns.computas.com/sublima#"
  xmlns:sioc="http://rdfs.org/sioc/ns#"
  xmlns:lingvoj="http://www.lingvoj.org/ontology#"
  xmlns:wdr="http://www.w3.org/2007/05/powder#"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns="http://purl.org/rss/1.0/" 
  exclude-result-prefixes="rdf rdfs dct foaf sublima sioc lingvoj wdr ">



  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="rdf:RDF" mode="results">
    <xsl:param name="sorting"/>
    
    
      <xsl:for-each select="sublima:Resource"> <!-- The root node for each described resource -->
        <xsl:sort select="./*[name() = $sorting]"/>

      <item rdf:about="{@rdf:about}"> 
        <title>
            <xsl:value-of select="./dct:title"/>
	    </title>
	    <link>
	       <!--
	       <xsl:value-of select="./dct:identifier/@rdf:resource"/>
	       -->
	       <xsl:value-of select="@rdf:about"/> 
	    </link>
	    <description>
	      <xsl:value-of select="./dct:description"/> 
	    </description>
    <!--	    
	  <xsl:apply-templates select="./dct:subject"/>
	  <xsl:apply-templates select="dct:publisher"/>
	  <xsl:apply-templates select="./dct:dateAccepted"/>
	  -->
	 	  </item> 
      </xsl:for-each>
    
  </xsl:template>


</xsl:stylesheet>