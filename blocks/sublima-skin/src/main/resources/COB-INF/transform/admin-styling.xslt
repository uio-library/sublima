<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:sub="http://xmlns.computas.com/sublima#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <!-- xsl:output method="html" indent="yes"/ -->
  <xsl:import href="rdfxml-res-templates.xsl"/>

  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template name="title">
    <xsl:copy-of select="c:page/c:title/*"/>
  </xsl:template>

  <xsl:template name="contenttext">
    <xsl:copy-of select="c:page/c:content/c:text/*"/>
  </xsl:template>

  <xsl:template match="/">

    <html>
      <head>
        <title>
          <xsl:call-template name="title"/>
          - Detektor
        </title>
        <link rel="stylesheet" type="text/css" href="styles/alt-css.css"/>
      </head>
      <body>

        <div id="header">
          <img alt="header logo" src="{$baseurl}/images/detektor_beta_header.png"/>

          <h2>Sublima 0.5.7</h2>
          <ul>
            <li>
              <a href="{$baseurl}/home">Hjem</a>
            </li>
            <li>
              <a href="{$baseurl}/advancedsearch">Avansert søk
              </a>
            </li>
            <li>
              <a href="{$baseurl}/admin" class="active">Administrasjon
              </a>
            </li>
          </ul>

          <p id="layoutdims">
            <xsl:for-each select="c:page/c:breadcrumbs/c:breadcrumb">
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$baseurl"/>/<xsl:value-of select="."/>
                </xsl:attribute>
                <xsl:value-of select="@title"/>
              </a>
              <xsl:text> | </xsl:text>
            </xsl:for-each>

          </p>
        </div>
        <div class="colmask threecol">
          <div class="colmid">
            <div class="colleft">
              <div class="col1">
                <!-- Column 1 start -->
                <xsl:call-template name="contenttext"/>

                <!-- Publishers -->
                <xsl:if test="c:page/c:content/c:publishers/sparql/results/result">
                  <ul>
                  <xsl:for-each select="c:page/c:content/c:publishers/sparql/results/result">
                    <li>
                       <a>
                          <xsl:attribute name="href">
                            <xsl:value-of select="./binding[@name='publisher']/uri"/>
                          </xsl:attribute>
                        <xsl:value-of select="./binding[@name='name']/literal"/>
                        </a>
                    </li>
                  </xsl:for-each>
                  </ul>                  
                </xsl:if>

                <!-- Linkcheck status check -->
                <xsl:if test="c:page/c:content/c:linkcheck_check/rdf:RDF/sub:Resource">
                  <p>Sjekkes manuelt grunnet problemer med tilkobling paa det aktuelle tidspunktet</p>
                  <ul>
                  <xsl:for-each select="c:page/c:content/c:linkcheck_check/rdf:RDF/sub:Resource">
                    <li>
                      <xsl:apply-templates select="./dct:title" mode="internal-link"/>
                    </li>
                  </xsl:for-each>
                  </ul>
                </xsl:if>

                <!-- Linkcheck status inactive -->
                <xsl:if test="c:page/c:content/c:linkcheck_inactive/rdf:RDF/sub:Resource">
                  <p>Satt inaktive pga varige problemer</p>
                  <ul>
                  <xsl:for-each select="c:page/c:content/c:linkcheck_inactive/rdf:RDF/sub:Resource">
                    <li>
                      <xsl:apply-templates select="./dct:title" mode="internal-link"/>
                    </li>
                  </xsl:for-each>
                  </ul>
                </xsl:if>

                <!-- Linkcheck status resource -->
                <xsl:if test="c:page/c:content/c:linkcheck_gone/rdf:RDF/sub:Resource">
                  <p>Satt til borte entydig besked fra tilbyder</p>
                  <ul>
                  <xsl:for-each select="c:page/c:content/c:linkcheck_gone/rdf:RDF/sub:Resource">
                    <li>
                      <xsl:apply-templates select="./dct:title" mode="internal-link"/>
                    </li>
                  </xsl:for-each>
                  </ul>
                </xsl:if>

                <!-- Suggested resources -->
                <xsl:if test="c:page/c:content/c:suggestedresources/rdf:RDF">
                  <ul>
                  <xsl:for-each select="c:page/c:content/c:suggestedresources/rdf:RDF/sub:Resource">
                    <li>
                      <xsl:apply-templates select="./dct:title" mode="internal-link"/>
                    </li>
                  </xsl:for-each>
                  </ul>
                </xsl:if>
                <!-- Column 1 end -->
              </div>
              <div class="col2">
                <!-- Column 2 start -->
                <xsl:if test="c:page/c:menu/c:menuelement">

                  <ul>

                    <xsl:for-each select="c:page/c:menu/c:menuelement">

                      <li>
                        <a>
                          <xsl:attribute name="href">
                            <xsl:value-of select="$baseurl"/>/<xsl:value-of select="."/>
                          </xsl:attribute>
                        <xsl:value-of select="@title"/>
                        </a>
                    </li>
                  </xsl:for-each>
                  </ul>
                </xsl:if>
                <!-- Column 2 end -->
              </div>
              <div class="col3">
                <!-- Column 3 start -->
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