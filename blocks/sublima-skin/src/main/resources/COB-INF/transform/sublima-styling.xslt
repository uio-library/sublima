<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:c="http://xmlns.computas.com/cocoon"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:dct="http://purl.org/dc/terms/" 
    version="1.0">

  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Detektor</title>
      </head>
      <body>
        <div id="header">Detektor demo</div>

        <div id="container">
          <div id="results" class="column">
            Søkeresultater
           <xsl:apply-templates select="c:page/c:result-list/rdf:RDF"/>
          </div>

          <div id="facets" class="column">
            Filtrering
            <xsl:value-of select="page/facets"/>
          </div>

          <div id="navigation" class="column">
            Navigering
            <xsl:value-of select="page/navigation"/>
          </div>
        </div>

        <div id="footer">
          ABM Utvikling og Computas AS, 2008
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>