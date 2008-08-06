<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:sub="http://xmlns.computas.com/sublima#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <!-- xsl:output method="html" indent="yes"/ -->

  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:import href="rdfxml2xhtml-facets.xsl"/>
  <xsl:import href="rdfxml2xhtml-table.xsl"/>
  <xsl:import href="rdfxml-nav-templates.xsl"/>
  <xsl:import href="browse.xsl"/> 
  <xsl:import href="headers.xsl"/>
  <xsl:import href="tipsform.xsl"/>
  <xsl:import href="loginform.xsl"/>
  <xsl:import href="a-z.xsl"/>
  <xsl:import href="set-lang.xsl"/>
  <xsl:import href="advancedsearch.xsl"/>


  <xsl:param name="baseurl"/>
  <xsl:param name="querystring"/>
  <xsl:param name="interface-language"/>

  <xsl:param name="qloc">
    <xsl:if test="contains(/c:page/c:facets/c:request/@requesturl, 'locale=')">
      <xsl:text>?locale=</xsl:text>
      <xsl:value-of select="$interface-language"/>
    </xsl:if>
  </xsl:param>
  <xsl:param name="aloc">
    <xsl:if test="contains(/c:page/c:facets/c:request/@requesturl, 'locale=')">
      <xsl:text>&amp;locale=</xsl:text>
      <xsl:value-of select="$interface-language"/>
    </xsl:if>
  </xsl:param>


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

    <html>
      <xsl:call-template name="head">
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
              <xsl:value-of select="c:page/c:result-list/rdf:RDF/sub:Resource/dct:title"/>
            </xsl:when>
          </xsl:choose>
	</xsl:with-param>
      </xsl:call-template>
   
      <body>
	<xsl:value-of select="$querystring"/>
	<xsl:call-template name="headers">
	  <xsl:with-param name="baseurl" select="$baseurl"/>
	</xsl:call-template>

        <div class="colmask threecol">
          <div class="colmid">
            <div class="colleft">
              <div class="col1">
		
		  <xsl:call-template name="debug"/>
		
       <!-- Column 1 start -->
		
		<!-- Search -->
	    <!-- Search is shown when advanced search is not -->	
        <xsl:if test="not(c:page/c:advancedsearch)">
		
		  <form action="{$baseurl}/search-result" method="get">
		  <fieldset>
		    <input type="hidden" name="prefix" value="dct: &lt;http://purl.org/dc/terms/&gt;"/>
		    <input type="hidden" name="prefix" value="foaf: &lt;http://xmlns.com/foaf/0.1/&gt;"/>
		    <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
		    <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
             <br/>
            <input id="keyword" class="searchbox" type="text"
                   name="searchstring" size="40" value="{c:page/c:searchparams/c:searchparams/c:searchstring}"/>
            <input type="submit" value="search.submit" i18n:attr="value"/>
              <br/>

            <xsl:choose>
              <xsl:when test="c:page/c:searchparams/c:searchparams/c:operator = 'OR'">
                <input type="radio" name="booleanoperator" value="AND"/><i18n:text key="search.boolean.and">OG</i18n:text>
                <input type="radio" name="booleanoperator" value="OR" checked="checked"/><i18n:text key="search_boolean_or">ELLER</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="radio" name="booleanoperator" value="AND" checked="checked"/><i18n:text key="search.boolean.and">OG</i18n:text>
                <input type="radio" name="booleanoperator" value="OR" /><i18n:text key="search.boolean.or">ELLER</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
            <br/>

            <xsl:choose>
              <xsl:when test="c:page/c:searchparams/c:searchparams/c:deepsearch = 'deepsearch'">
                <input type="checkbox" name="deepsearch" value="deepsearch" checked="checked"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="deepsearch" value="deepsearch"/>
              </xsl:otherwise>
            </xsl:choose>
            <i18n:text key="search.externalresources">Søk også i de eksterne ressursene</i18n:text>
            <br/>
            <i18n:text key="search.sortby">Sorter etter</i18n:text>

            <select id="sort" name="sort">
              <option value="">
                <xsl:if test="c:page/c:searchparams/c:searchparams/c:sortby = ''">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <i18n:text key="search.sortby.relevance">Relevans</i18n:text>
               </option>
              <option value="dct:dateAccepted">
                <xsl:if test="c:page/c:searchparams/c:searchparams/c:sortby = 'dct:dateAccepted'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <i18n:text key="search.sortby.date">Dato</i18n:text>
               </option>
              <option value="dct:title">
                <xsl:if test="c:page/c:searchparams/c:searchparams/c:sortby = 'dct:title'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <i18n:text key="title">Tittel</i18n:text>
               </option>
            </select>
          </fieldset>
          </form>
          
        </xsl:if>

        <xsl:if test="c:page/c:mode = 'search-result'">
          <i18n:text key="search.numberofhits">Antall treff</i18n:text>: <xsl:value-of select="count(c:page/c:result-list/rdf:RDF/sub:Resource)"/>
        </xsl:if>
        
        <!-- Facets -->
        <!-- Facets are shown if the c:/page/c:facets exists in the XML --> 
        <xsl:if test="c:page/c:mode != 'resource' and c:page/c:mode != 'browse'">
           <xsl:if test="c:page/c:facets">
            <h3><i18n:text key="facets.heading">Velg avgrensning</i18n:text></h3>
            <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="facets"/>
          </xsl:if>
        </xsl:if>
                
        
        <!-- Advanced search -->        
        <!-- Her kommer avansert søk dersom denne er angitt, og tipsboksen dersom brukeren har valgt den -->
        <!--xsl:call-template name="advancedsearch"/-->
        <xsl:apply-templates select="c:page/c:advancedsearch" mode="advancedsearch"/>
        <!-- xsl:copy-of select="c:page/c:advancedsearch/*"/ -->
        
        <!-- Tips -->
        <xsl:apply-templates select="c:page/c:tips" mode="form"/>

        <!-- Login -->
        <xsl:apply-templates select="c:page/c:login" mode="login"/>

        <!-- A-Z -->
        <xsl:apply-templates select="c:page/c:a-z" mode="a-z"/>                
        
        <!-- Resource Description (details) -->
        <xsl:if test="c:page/c:mode = 'resource'">
            <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="resource"/>
        </xsl:if>
                
        <!-- Browse (A-Z)? -->    
        <xsl:if test="c:page/c:mode = 'browse'">
            <xsl:apply-templates select="c:page/c:browse" mode="browse"/>
        </xsl:if>


        <!-- Link to RSS representation of search result -->
        
        <xsl:if test="c:page/c:mode = 'topic' or c:page/c:mode = 'search-result'">
            <xsl:variable name="rss-url">    
                <xsl:choose>
                    <xsl:when test="contains(/c:page/c:facets/c:request/@requesturl, '?')">
                        <xsl:value-of select="concat(substring-before(/c:page/c:facets/c:request/@requesturl, '.html?'), '.rss?', substring-after(/c:page/c:facets/c:request/@requesturl, '?'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(substring-before(/c:page/c:facets/c:request/@requesturl, '.html'), '.rss')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <a>
            <xsl:attribute name="href">
             <xsl:value-of select="$rss-url"/>
            </xsl:attribute> 
            RSS
            </a>
        </xsl:if>

        <!-- Search results -->
        <xsl:if test="c:page/c:mode = 'topic' or c:page/c:mode = 'search-result'">
            <h3><i18n:text key="resources.heading">Ressurser</i18n:text></h3>
            <!-- Søkeresultatene -->
            <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="results">
              <xsl:with-param name="sorting"><xsl:value-of select="c:page/c:searchparams/c:searchparams/c:sortby"/></xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        
         <!-- Column 1 end -->
      </div>
             
      <div class="col2">
          <!-- Column 2 (left) start -->
            <h2><i18n:text key="menu.heading">Mine aktiviteter</i18n:text></h2>
            <a href="{$baseurl}/tips{$qloc}"><i18n:text key="menu.tips">Tips oss om en ny ressurs</i18n:text></a><br/>
        
            <xsl:choose>
              <xsl:when test="c:page/c:loggedin = 'true' ">
                <a href="{$baseurl}/admin/emner/{$qloc}"><i18n:text key="menu.topic">Emner</i18n:text></a><br/>
                <a href="{$baseurl}/admin/ressurser/{$qloc}"><i18n:text key="menu.resource">Ressurser</i18n:text></a><br/>
                <a href="{$baseurl}/admin/brukere/{$qloc}"><i18n:text key="menu.user">Brukere</i18n:text></a><br/>
                <a href="{$baseurl}/admin/utgivere/{$qloc}"><i18n:text key="menu.publisher">Utgivere</i18n:text></a><br/>
                <a href="{$baseurl}/admin/lenkesjekk/{$qloc}"><i18n:text key="menu.link">Lenkesjekk</i18n:text></a><br/>
                <a href="{$baseurl}/admin/database/{$qloc}"><i18n:text key="menu.database">Database</i18n:text></a><br/>
              </xsl:when>
            </xsl:choose>

        <!-- Column 2 end -->
       </div>
       
       <div class="col3">
            <!-- Column 3 start -->
        
        <!-- Navigation -->
        <!-- Navigation is only shown when one topic is in focus -->
        <!-- Discussion is open on showing a different navigation scheme when more then one topic is in focus --> 
        <xsl:if test="c:page/c:mode = 'topic'">
            <h3><i18n:text key="topic.navigation">Navigering</i18n:text></h3>
            <xsl:apply-templates select="c:page/c:navigation/rdf:RDF/skos:Concept">
                <xsl:with-param name="role">this-param</xsl:with-param>
             </xsl:apply-templates>
        </xsl:if>
     
            <!-- Column 3 end -->
              </div>
            </div>

          </div>
        </div>
        <div id="footer">
          <p><i18n:text key="sublima.footer">A Free Software Project supported by
            <a href="http://www.abm-utvikling.no/">ABM Utvikling</a>
            and
            <a href="http://www.computas.com/">Computas AS</a>
            , 2008</i18n:text>
          </p>
        </div>


      </body>
    </html>
  </xsl:template>


</xsl:stylesheet>