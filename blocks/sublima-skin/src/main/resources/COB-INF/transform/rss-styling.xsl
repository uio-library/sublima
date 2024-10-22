<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:sublima="http://xmlns.computas.com/sublima#"
        xmlns="http://purl.org/rss/1.0/" 
	exclude-result-prefixes="c skos sublima"
        version="1.0">
 
  <xsl:import href="rdfxml2rss-deflist.xsl"/>
  <xsl:import href="rss-channel.xsl"/>

  <xsl:output encoding="UTF-8" method="xml" media-type="application/rss+xml"/>

  <xsl:param name="servername"/>
  <xsl:param name="serverport"/>

  <!-- A debug template that dumps the source tree. Do not remove
this, just comment out the call-template -->
  <xsl:template name="debug">
    <div id="debug">
      <xsl:copy-of select="*"/>
    </div>
  </xsl:template>

  <xsl:template name="advancedsearch"> <!-- I have no idea why it didn't work to have a normal node-based template -->
    <xsl:copy-of select="c:page/c:advancedsearch/*"/>
  </xsl:template>

  <xsl:template match="/">


<rdf:RDF 
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns="http://purl.org/rss/1.0/"
>


      <xsl:call-template name="rss-channel">
	<xsl:with-param name="url">
	  <xsl:text>http://</xsl:text>
	  <xsl:value-of select="$servername"/>
	  <xsl:if test="$serverport != 80">
	    <xsl:text>:</xsl:text>
	    <xsl:value-of select="$serverport"/>
	  </xsl:if>
	  <xsl:value-of select="c:page/c:facets/c:request/@requesturl"/>
	</xsl:with-param>
        <xsl:with-param name="title">
          <xsl:choose>
            <xsl:when test="c:page/c:mode = 'topic'">
              <xsl:value-of
                      select="c:page/c:navigation/rdf:RDF/skos:Concept/skos:prefLabel[@xml:lang=$interface-language]"/>
              <xsl:if test="c:page/c:navigation/rdf:RDF/skos:Concept/skos:altLabel[@xml:lang=$interface-language]">
                <xsl:text>/</xsl:text>
                <xsl:value-of
                        select="c:page/c:navigation/rdf:RDF/skos:Concept/skos:altLabel[@xml:lang=$interface-language]"/>
              </xsl:if>

            </xsl:when>
            <xsl:when test="c:page/c:mode = 'resource'">
              <xsl:value-of select="c:page/c:result-list/rdf:RDF/sublima:Resource/dct:title"/>
            </xsl:when>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
   
      


        <!-- Search results -->
        <xsl:if test="c:page/c:mode = 'topic' or c:page/c:mode = 'search-result'">
            <!-- Søkeresultatene -->
            <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="results">
              <xsl:with-param name="sorting"><xsl:value-of select="c:page/c:searchparams/c:searchparams/c:sortby"/></xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        
         <!-- Column 1 end -->
       
       


    </rdf:RDF>
  </xsl:template>


</xsl:stylesheet>
