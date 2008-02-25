<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:c="http://xmlns.computas.com/cocoon"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:dct="http://purl.org/dc/terms/" 
    version="1.0">

  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:import href="rdfxml-nav-templates.xsl"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Detektor</title>
	<link rel="stylesheet" type="text/css" href="http://detektor.deichman.no/stylesheet.css"/>
	<link rel="stylesheet" type="text/css" href="/sublima-skin/my-css.css"/>
      </head>
      <body>
        <h1 id="header">Detektor demo</h1>

        <div id="container">

	  <div id="navigation" class="column">
            <h2>Navigering</h2>
            <xsl:apply-templates select="c:page/c:navigation/rdf:RDF/skos:Concept"/>
          </div>

	  <div id="results" class="column">
	    <h2>Søkeresultater</h2>
	    <xsl:apply-templates select="c:page/c:result-list/rdf:RDF"/>
          </div>

         <div id="facets" class="column">
            <h2>Filtrering</h2>
            <xsl:value-of select="c:page/c:facets"/>
          </div>


        </div>

        <div id="footer">
          A Free Software Project supported by ABM Utvikling and Computas AS, 2008
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>