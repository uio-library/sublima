<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"   
  xmlns:dct="http://purl.org/dc/terms/" 
  xmlns:sublima="http://xmlns.computas.com/sublima#"
  xmlns="http://purl.org/rss/1.0/" 
  exclude-result-prefixes="rdf dct sublima">



  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="rdf:RDF" mode="results">
    <xsl:param name="sorting"/>
    
    
      <xsl:for-each select="sublima:Resource"> <!-- The root node for each described resource -->
        <xsl:sort lang="{$interface-language}" select="./*[name() = $sorting]"/>

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