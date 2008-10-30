<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:c="http://xmlns.computas.com/cocoon"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:srw="http://www.loc.gov/zing/srw/" 
    version="1.0">
  
  <xsl:output method="xml" indent="yes"/>
  

  <xsl:template match="/c:page">
    <rdf:RDF>
      <xsl:for-each select="srw:searchRetrieveResponse/srw:records/srw:record">
	<xsl:copy-of select="srw:recordData/*"/>
      </xsl:for-each>
    </rdf:RDF>
  </xsl:template>
</xsl:stylesheet>