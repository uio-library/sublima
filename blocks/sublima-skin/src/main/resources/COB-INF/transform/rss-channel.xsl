<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns="http://purl.org/rss/1.0/" 
        xmlns:sublima="http://xmlns.computas.com/sublima#"
	exclude-result-prefixes="c sublima"
        version="1.0">

  <xsl:template name="rss-channel">
    <xsl:param name="title"/>
    <xsl:param name="url"/>
    <channel rdf:about="">
      <title>
	<xsl:value-of select="$title"/>
      </title>
      <description/>
      <link><xsl:value-of select="$url"/></link>
      <items>
	<rdf:Seq>
	  <xsl:for-each select="c:page/c:result-list/rdf:RDF/sublima:Resource">
	    <rdf:li resource="{@rdf:about}"/>
	  </xsl:for-each>
	</rdf:Seq>
      </items>
   
    </channel>
  </xsl:template>


</xsl:stylesheet>

