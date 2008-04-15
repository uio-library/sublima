<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:lingvoj="http://www.lingvoj.org/ontology#"
        xmlns:wdr="http://www.w3.org/2007/05/powder#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:sub="http://xmlns.computas.com/sublima#"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <!-- xsl:output method="html" indent="yes"/ -->
  <!-- xsl:import href="rdfxml-res-templates.xsl"/ -->
  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:import href="servlet:forms:/resource/internal/xsl/forms-page-styling.xsl"/>
  <xsl:import href="servlet:forms:/resource/internal/xsl/forms-field-styling.xsl"/>

   <xsl:output method="xml"
            encoding="UTF-8"
            indent="no"/>

  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>
  <xsl:param name="forms-resources"/>
  <xsl:param name="dojo-resources"/>

  <xsl:template name="title">
    <xsl:copy-of select="c:page/c:title/*"/>
  </xsl:template>

  <xsl:template name="contenttext">
    <xsl:copy-of select="c:page/c:content/c:text/*"/>
  </xsl:template>


  <xsl:template name="resourcedetails">
     <table>
        <tr>
            <td>
              <label for="sub:Resource">URI</label>
            </td>
            <td>
                <input id="sub:Resource" type="text" name="sub:Resource" size="40" />
            </td>
        </tr>
       <tr>
         <td><label for="dct:description">Beskrivelse</label></td>
         <td><textarea id="dct:description" name="dct:description" rows="6" cols="40">...</textarea></td>
       </tr>
       <tr>
         <td>Velg utgiver fra nedtrekkslisten, eller la den stå tom og skriv inn navnet på den nye utgiveren i tekstfeltet under</td>
       </tr>
       <tr>
         <td>
           <label for="dct:publisher/foaf:Agent/foaf:name">Utgiver</label>
         </td>
         <td>
           <select id="dct:publisher/foaf:Agent/foaf:name" name="dct:publisher/foaf:Agent/foaf:name">
              <xsl:for-each select="c:page/c:content/c:resourcedetails/c:publishers/rdf:RDF/foaf:Agent">
                <xsl:sort select="./foaf:name"/>
                <option value="{./@rdf:about}"><xsl:value-of select="./foaf:name"/></option>
              </xsl:for-each>
            </select>
         </td>
       </tr>
       <tr>
         <td></td>
         <td><input id="newpublisher" type="text" name="newpublisher" size="40" /></td>
       </tr>
       <tr>
         <td><label for="dct:language">Språk</label></td>
         <td>
           <select id="dct:language" name="dct:language" multiple="multiple" size="10">
              <xsl:for-each select="c:page/c:content/c:resourcedetails/c:languages/rdf:RDF/lingvoj:Lingvo">
                <xsl:sort select="./rdfs:label"/>
                <option value="{./@rdf:about}"><xsl:value-of select="./rdfs:label"/></option>
              </xsl:for-each>
            </select>
         </td>
       </tr>
       <tr>
         <td><label for="dct:MediaType">Mediatype</label></td>
         <td>
           <select id="dct:MediaType" name="dct:MediaType" multiple="multiple" size="10">
              <xsl:for-each select="c:page/c:content/c:resourcedetails/c:mediatypes/rdf:RDF/dct:MediaType">
                <xsl:sort select="./rdfs:label"/>
                <option value="{./@rdf:about}"><xsl:value-of select="./rdfs:label"/></option>
              </xsl:for-each>
            </select>
         </td>
       </tr>
       <tr>
         <td><label for="dct:audience">Målgruppe</label></td>
         <td>
           <select id="dct:audience" name="dct:audience" multiple="multiple" size="10">
              <xsl:for-each select="c:page/c:content/c:resourcedetails/c:audiences/rdf:RDF/dct:AgentClass">
                <xsl:sort select="./rdfs:label"/>
                <option value="{./@rdf:about}"><xsl:value-of select="./rdfs:label"/></option>
              </xsl:for-each>
            </select>
         </td>
       </tr>
       <tr>
         <td><label for="dct:subject">Emner</label></td>
         <td>
           <select id="dct:subject" name="dct:subject" multiple="multiple" size="10">
              <xsl:for-each select="c:page/c:content/c:resourcedetails/c:topics/rdf:RDF/skos:Concept">
                <xsl:sort select="./rdfs:label"/>
                <option value="{./@rdf:about}"><xsl:value-of select="./rdfs:label"/></option>
              </xsl:for-each>
            </select>
         </td>
       </tr>
       <tr>
         <td><label for="comment">Kommentar</label></td>
         <td><textarea id="comment" name="comment" rows="6" cols="40">...</textarea></td>
       </tr>
       <tr>
         <td><label for="wdr:DR">Status</label></td>
         <td>
           <select id="wdr:DR" name="wdr:DR">
              <xsl:for-each select="c:page/c:content/c:resourcedetails/c:statuses/rdf:RDF/wdr:DR">
                <xsl:sort select="./rdfs:label"/>
                <option value="{./@rdf:about}"><xsl:value-of select="./rdfs:label"/></option>
              </xsl:for-each>
            </select>
         </td>
       </tr>
    </table>
  </xsl:template>

  <!-- New publisher -->
  <xsl:template name="new_publisher">
      
    <form name="new_publisher" action="insertpublisher" method="GET">
     <table>
        <tr>
            <td>
              <label for="new_publisher">Navn</label>
            </td>
            <td>
                <input id="new_publisher" type="text" name="new_publisher" size="40" />
            </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <input type="submit" value="Lagre utgiver"/>
          </td>
        </tr>
      </table>
    </form>
      
     <xsl:if test="c:page/c:content/c:messages">
      <br/>
      <p class="validationmessage">
      <xsl:value-of select="c:page/c:content/c:messages/*" />
      </p>
    </xsl:if>

  </xsl:template>

  <!-- Publisherlist -->
  <xsl:template name="publisherlist">
    <xsl:call-template name="new_publisher"/>
    <br/>
    <ul>
      <xsl:for-each select="c:page/c:content/c:publisherlist/sparql:sparql/sparql:results/sparql:result">
        <li>
           <a>
              <xsl:attribute name="href"><xsl:value-of select="$baseurl"/>/admin/utgivere/utgiver?uri=<xsl:value-of select="./sparql:binding[@name='publisher']/sparql:uri"/>
              </xsl:attribute>
            <xsl:value-of select="./sparql:binding[@name='name']/sparql:literal"/>
            </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- Publisherdetails -->
  <xsl:template name="publisherdetails">

  <form name="rename_publisher" action="updatepublisher" method="GET">
     <table>
      <xsl:apply-templates select="c:page/c:content/c:publisherdetails/rdf:RDF/foaf:Agent" mode="edit" />
        <tr>
          <td></td>
          <td>
            <input type="submit" value="Lagre navneendring"/>
          </td>
        </tr>
      </table>
    <xsl:if test="c:page/c:content/c:messages">
      <br/>
      <p class="validationmessage">
      <xsl:value-of select="c:page/c:content/c:messages/*" />
      </p>
    </xsl:if>
    </form>
    <br />
    <h4>Ressurser tilknyttet utgiveren</h4>
    
    <xsl:apply-templates select="c:page/c:content/c:publisherdetails/rdf:RDF" mode="results"/>

  </xsl:template>

  <xsl:template name="linkcheck">

    <xsl:if test="c:page/c:content/c:linkcheck/c:status_check">
      <p>Sjekkes manuelt grunnet problemer med tilkobling paa det aktuelle tidspunktet</p>
      <ul>
      <xsl:for-each select="c:page/c:content/c:linkcheck/c:status_check/rdf:RDF/sub:Resource">
        <li>
          <xsl:apply-templates select="./dct:title" mode="internal-link"/>
        </li>
      </xsl:for-each>
      </ul>
    </xsl:if>

    <!-- Linkcheck status inactive -->
    <xsl:if test="c:page/c:content/c:linkcheck/c:status_inactive/rdf:RDF/sub:Resource">
      <p>Satt inaktive pga varige problemer</p>
      <ul>
      <xsl:for-each select="c:page/c:content/c:linkcheck/c:status_inactive/rdf:RDF/sub:Resource">
        <li>
          <xsl:apply-templates select="./dct:title" mode="internal-link"/>
        </li>
      </xsl:for-each>
      </ul>
    </xsl:if>

    <!-- Linkcheck status resource -->
    <xsl:if test="c:page/c:content/c:status_gone/rdf:RDF/sub:Resource">
      <p>Satt til borte grunnet entydig besked fra tilbyder</p>
      <ul>
      <xsl:for-each select="c:page/c:content/c:linkcheck/c:status_gone/rdf:RDF/sub:Resource">
        <li>
          <xsl:apply-templates select="./dct:title" mode="internal-link"/>
        </li>
      </xsl:for-each>
      </ul>
    </xsl:if>

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

          <h2>Sublima 0.6</h2>
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

                <!-- Resource form -->
                <xsl:apply-templates select="c:page/c:content/c:resourceform" mode="forms-page"/>
                <xsl:apply-templates select="c:page/c:content/c:resourceform" mode="forms-field"/>


                <xsl:if test="c:page/c:content/c:resourcedetails">
                  <xsl:call-template name="resourcedetails"/>
                </xsl:if>

                <!-- Publishers index -->
                <xsl:if test="c:page/c:content/c:publisherlist">
                  <xsl:call-template name="publisherlist"/>
                </xsl:if>

                <!-- Publishers details -->
                <xsl:if test="c:page/c:content/c:publisherdetails/rdf:RDF">
                  <xsl:call-template name="publisherdetails"/>
                </xsl:if>

                <!-- Linkcheck -->
                <xsl:if test="c:page/c:content/c:linkcheck">
                  <xsl:call-template name="linkcheck"/>
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