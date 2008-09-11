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
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:import href="resourceform.xsl"/>
  <xsl:import href="resourcemassedit.xsl"/>
  <xsl:import href="topicform.xsl"/>
  <xsl:import href="headers.xsl"/>
  <xsl:import href="themeselection.xsl"/>
  <xsl:import href="topicjoin.xsl"/>
  <xsl:import href="allusers.xsl"/>
  <xsl:import href="allroles.xsl"/>
  <xsl:import href="userform.xsl"/>
  <xsl:import href="topicrelations.xsl"/>
  <xsl:import href="roleform.xsl"/>
  <xsl:import href="allrelationtypes.xsl"/>
  <xsl:import href="resourceprereg.xsl"/>
  <xsl:import href="importexport.xsl"/>
  <xsl:import href="set-lang.xsl"/>
  <xsl:import href="publisherform.xsl"/>
  <xsl:import href="sparql-uri-label-pairs.xsl"/>

  <xsl:output method="xml"
              encoding="UTF-8"
              indent="no"/>
  <xsl:param name="baseurl"/>
  <xsl:param name="servername"/>
  <xsl:param name="serverport"/>
  <xsl:param name="rss-url"/>
  <xsl:param name="locale"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:param name="qloc">
      <xsl:text>?locale=</xsl:text>
      <xsl:value-of select="$interface-language"/>
  </xsl:param>
  <xsl:param name="aloc">
      <xsl:text>&amp;locale=</xsl:text>
      <xsl:value-of select="$interface-language"/>
  </xsl:param>

  <xsl:template name="contenttext">
    <xsl:copy-of select="c:page/c:content/c:text/*"/>
  </xsl:template>

  <xsl:template name="theme">
    <xsl:choose>
      <xsl:when test="c:page/c:mode = 'theme'">
        <xsl:apply-templates select="c:page/c:content/c:theme" mode="theme"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- A debug template that dumps the source tree. Do not remove
       this, just comment out the call-template -->
  <xsl:template name="debug">
    <div id="debug">
      <xsl:copy-of select="*"/>
    </div>
  </xsl:template>

  <xsl:template name="messages">
    <xsl:if test="c:page/c:content/c:messages/c:messages/c:message">
      <ul>
        <xsl:for-each select="c:page/c:content/c:messages/c:messages/c:message">
          <li>
            <xsl:value-of select="."/>
            <br/>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template name="roledetails">
    <xsl:choose>
      <xsl:when test="c:page/c:mode = 'roletemp'">
        <xsl:apply-templates select="c:page/c:content/c:role" mode="roletemp"/>
      </xsl:when>
      <xsl:when test="c:page/c:mode = 'roleedit'">
        <xsl:apply-templates select="c:page/c:content/c:role" mode="roleedit"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="userdetails">

    <xsl:choose>
      <xsl:when test="c:page/c:mode = 'usertemp'">
        <xsl:apply-templates select="c:page/c:content/c:user" mode="usertemp"/>
      </xsl:when>
      <xsl:when test="c:page/c:mode = 'useredit'">
        <xsl:apply-templates select="c:page/c:content/c:user" mode="useredit"/>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="topicdetails">

    <xsl:choose>
      <xsl:when test="c:page/c:mode = 'topictemp'">
        <xsl:apply-templates select="c:page/c:content/c:topic">
	  <xsl:with-param name="mode">topictemp</xsl:with-param>
	</xsl:apply-templates>
      </xsl:when>
      <xsl:when test="c:page/c:mode = 'topicedit'">
        <xsl:apply-templates select="c:page/c:content/c:topic">
	  <xsl:with-param name="mode">topicedit</xsl:with-param>
	</xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="alltopics">
    <ul>
      <xsl:for-each select="c:page/c:content/c:topics/rdf:RDF/skos:Concept">
        <xsl:sort select="./skos:prefLabel"/>
        <li>
          <a href="{$baseurl}/admin/emner/emne?uri={./@rdf:about}{$aloc}"><xsl:value-of select="./skos:prefLabel"/></a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="resourcedetails">

    <xsl:choose>
      <xsl:when test="c:page/c:mode = 'edit'">
        <xsl:apply-templates select="c:page/c:content/c:resourcedetails" mode="resourceedit"/>
      </xsl:when>
      <xsl:when test="c:page/c:mode = 'temp'">
        <xsl:apply-templates select="c:page/c:content/c:resourcedetails" mode="temp"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Publisherlist -->
  <xsl:template name="publisherlist">
    <ul>
      <xsl:for-each select="c:page/c:content/c:publisherlist/sparql:sparql/sparql:results/sparql:result">
        <li>
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$baseurl"/>/admin/utgivere/utgiver?uri=<xsl:value-of select="./sparql:binding[@name='publisher']/sparql:uri"/><xsl:value-of
                    select="$aloc"/></xsl:attribute>
            <xsl:value-of select="./sparql:binding[@name='name']/sparql:literal"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="linkcheck">

    <xsl:if test="c:page/c:content/c:linkcheck/c:status_check/rdf:RDF/sub:Resource">
      <p><i18n:text key="admin.linkcheck.manual">Sjekkes manuelt grunnet problemer med tilkobling paa det aktuelle tidspunktet</i18n:text></p>
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
      <p><i18n:text key="admin.linkcheck.inactive">Satt inaktive pga varige problemer</i18n:text></p>
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
      <p><i18n:text key="admin.linkcheck.gone">Satt til borte grunnet entydig besked fra tilbyder</i18n:text></p>
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
      
      <xsl:call-template name="head">
	<xsl:with-param name="title" select="c:page/c:title"/>
      </xsl:call-template>
      <body>

	<xsl:call-template name="headers">
	  <xsl:with-param name="baseurl" select="$baseurl"/>
	</xsl:call-template>

        <div class="colmask threecol">
          <div class="colmid">
            <div class="colleft">
              <div class="col1">
                <!-- Column 1 start -->
		<!--
                <xsl:call-template name="debug"/>
-->
		<xsl:call-template name="contenttext"/>

                <xsl:call-template name="messages"/>

		<xsl:if test="c:page/c:statuses/sparql:sparql">
		
		  <form action="../../search-result.html" method="GET">
		    <input type="hidden" name="prefix" value="wdr: &lt;http://www.w3.org/2007/05/powder#&gt;"/>  
		    <xsl:call-template name="hidden-locale-field"/>

		    <table>
		      <xsl:apply-templates select="c:page/c:statuses/sparql:sparql">
			<xsl:with-param name="field">wdr:describedBy</xsl:with-param>
			<xsl:with-param name="label">Status</xsl:with-param>
		      </xsl:apply-templates>
		    </table>

		    <input type="submit" value="Search"/>
		  </form>
		  </xsl:if>




                <xsl:apply-templates select="c:page/c:content/c:upload" mode="upload"/>

                <xsl:call-template name="theme"/>

                <xsl:call-template name="alltopics"/>

                <xsl:call-template name="topicdetails"/>

                <xsl:call-template name="userdetails"/>

                <xsl:call-template name="roledetails"/>

                <xsl:apply-templates select="c:page/c:content/c:related"/>

                <xsl:apply-templates select="c:page/c:content/c:allusers" mode="list"/>
                
                <xsl:apply-templates select="c:page/c:content/c:allroles" mode="listallroles"/>

                <xsl:apply-templates select="c:page/c:content/c:relations" mode="listallrelationtypes"/>

                <xsl:apply-templates select="c:page/c:content/c:join" mode="topicjoin"/>

                <!-- Publisherdetails -->
                <xsl:apply-templates select="c:page/c:content/c:publisherdetails"/>

                <xsl:apply-templates select="c:page/c:massediting"/>		

                <xsl:if test="c:page/c:content/c:resourcedetails">
                  <xsl:call-template name="resourcedetails"/>
                </xsl:if>

                <xsl:if test="c:page/c:content/c:resourceprereg">
                  <xsl:apply-templates select="c:page/c:content/c:resourceprereg" mode="resourceprereg"/>
                </xsl:if>

                <!-- Publishers index -->
                <xsl:if test="c:page/c:content/c:publisherlist">
                  <xsl:call-template name="publisherlist"/>
                </xsl:if>

                <!-- Linkcheck -->
                <xsl:if test="c:page/c:content/c:linkcheck">
                  <xsl:call-template name="linkcheck"/>
                </xsl:if>


                <!-- Suggested resources -->
                <xsl:if test="c:page/c:content/c:suggestedresources/rdf:RDF">
                  <ul>
                    <xsl:for-each
                            select="c:page/c:content/c:suggestedresources/rdf:RDF/sub:Resource">
                      <li>
                        <a href="{$baseurl}/admin/ressurser/edit?uri={@rdf:about}{$aloc}"><xsl:value-of select="./dct:title"/></a>
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
                          <xsl:attribute name="href"><xsl:value-of select="$baseurl"/>/<xsl:value-of select="@link"/><xsl:value-of select="$qloc"/></xsl:attribute><xsl:value-of select="@title"/></a>
                      </li>
                      <xsl:if test="c:childmenuelement">
                        <ul>
                          <xsl:for-each select="c:childmenuelement">
                            <li>
                              <a>
                                <xsl:attribute name="href"><xsl:value-of select="$baseurl"/>/<xsl:value-of select="@link"/><xsl:value-of select="$qloc"/></xsl:attribute><xsl:value-of select="@title"/></a>
                            </li>
                            <xsl:if test="c:childmenuelement">
                              <ul>
                                <xsl:for-each select="c:childmenuelement">
                                <li>
                                  <a><xsl:attribute name="href"><xsl:value-of select="$baseurl"/>/<xsl:value-of select="@link"/><xsl:value-of select="$qloc"/></xsl:attribute><xsl:value-of select="@title"/></a>
                                </li>
                                </xsl:for-each>
                            </ul>
                          </xsl:if>
                          </xsl:for-each>
                        </ul>
                      </xsl:if>
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
          <p><i18n:text key="sublima.footer">A Free Software Project supported by
            <a href="http://www.abm-utvikling.no/">ABM Utvikling</a>
            and
            <a href="http://www.computas.com">Computas AS</a>
            , 2008</i18n:text>
          </p>
        </div>
      </body>
    </html>

  </xsl:template>

</xsl:stylesheet>
