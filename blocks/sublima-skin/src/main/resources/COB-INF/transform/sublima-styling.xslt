<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template match="/">
    <html>
      <head>
        <title>Detektor</title>
      </head>
      <body>
        <div id="header"></div>

        <div id="container">
          <div id="results" class="column">
           <xsl:value-of select="page/result-list"/>
          </div>

          <div id="facets" class="column">
            <xsl:value-of select="page/facets"/>
          </div>

          <div id="navigation" class="column">
            <xsl:value-of select="page/navigation"/>
          </div>
        </div>

        <div id="footer"></div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="*|node()|@*">
    <xsl:copy><xsl:apply-templates select="*|node()|@*"/></xsl:copy>
  </xsl:template>

</xsl:stylesheet>