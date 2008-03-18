<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <!-- xsl:output method="html" indent="yes"/ -->

  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:import href="rdfxml2xhtml-facets.xsl"/>
  <xsl:import href="rdfxml-nav-templates.xsl"/>

  <xsl:param name="mode"/>

  <xsl:template name="advancedsearch"> <!-- I have no idea why it didn't work to have a normal node-based template -->
    <xsl:copy-of select="c:page/c:advancedsearch/*"/>
  </xsl:template>

  <xsl:template name="tips"> <!-- I have no idea why it didn't work to have a normal node-based template -->
    <xsl:copy-of select="c:page/c:tips/*"/>
  </xsl:template>

  <xsl:template match="/">

    <html>
      <head>
        <title>Detektor</title>
        <!-- link rel="stylesheet" type="text/css" href="http://detektor.deichman.no/stylesheet.css"/> -->
        <link rel="stylesheet" type="text/css" href="styles/alt-css.css"/>
      </head>
      <body>

        <div id="header">
          <img alt="header logo" src="images/detektor_beta_header.png"/>
           <xsl:value-of select="$mode"/>
          <h2>Demosite for portalverktøyet Sublima</h2>
          <ul>
            <li>
              <a href="home" class="active">Hjem</a>
            </li>
            <li>
              <a href="advancedsearch">Avansert søk
              </a>
            </li>
          </ul>

          <p id="layoutdims">
            Brødsmuler her? |
            <a href="#">Smule 1</a>
            |
            <a href="#">Smule 2</a>
            |
            <strong>Nåværende smule</strong>
          </p>
        </div>
        <div class="colmask threecol">
          <div class="colmid">
            <div class="colleft">
              <div class="col1">

                <!-- Column 1 start -->
                <xsl:if test="not(c:page/c:advancedsearch/node())">
                  <form name="freetextSearch" action="freetext-result" method="get">
                    <table>
                      <tr>
                        <td>
                          <input id="keyword" class="searchbox" type="text"
                                 name="searchstring" size="50"/>
                        </td>
                        <td>
                          <input type="submit" value="Søk"/>
                        </td>
                        <td>
                          <a href="advancedsearch">Avansert søk</a>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <input type="radio" name="booleanoperator" value="AND" checked="true" />OG <input type="radio" name="booleanoperator" value="OR" /> ELLER
                          <input type="checkbox" name="deepsearch" value="deepsearch"/> Søk også i de eksterne ressursene
                        </td>
                      </tr>
                    </table>
                  </form>
                </xsl:if>

                <!-- xsl:if test="c:page/c:mode = 'topic-instance'" -->

                  <h3>Navigering</h3>
                  <xsl:apply-templates select="c:page/c:navigation/rdf:RDF/skos:Concept"/>

                <!-- /xsl:if -->
                <!-- Her kommer avansert søk dersom denne er angitt, og tipsboksen dersom brukeren har valgt den -->
                <xsl:call-template name="advancedsearch"/>
                <!-- xsl:copy-of select="c:page/c:advancedsearch/*"/ -->
                <xsl:call-template name="tips"/>

                <h3>Ressurser</h3>
                <!-- Søkeresultatene -->
                <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="results"/>
                <!-- Column 1 end -->
              </div>
              <div class="col2">
                <!-- Column 2 start -->
                  <h3>Fasetter</h3>
                  <xsl:if test="c:page/c:facets">
                    <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="facets"/>
                  </xsl:if>



                <!-- Column 2 end -->
              </div>
              <div class="col3">
                <!-- Column 3 start -->
                  <!-- xsl:if test="c:page/c:mode = 'search-result'" -->
                 <h2>Min side osv.</h2>
                 <a href="tips">Tips oss om en ny ressurs</a>


                <!-- /xsl:if -->
                <!-- Column 3 end -->
              </div>
            </div>

          </div>
        </div>
        <div id="footer">
          <p>A Free Software Project supported by
            <a href="http://www.abm-utvikling.no/">ABM Utvikling</a>
            and
            <a href="http://www.computas.com">Computas AS</a>
            , 2008
          </p>
        </div>


      </body>
    </html>
  </xsl:template>


</xsl:stylesheet>