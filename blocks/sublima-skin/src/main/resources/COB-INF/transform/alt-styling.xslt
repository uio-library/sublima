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


  <xsl:param name="baseurl"/>

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

        <div id="header">
          <img alt="header logo" src="{$baseurl}/images/smil_beta_header.png"/>

          <h2>Sublima 0.9.5</h2>
          <ul>
            <li>
              <a href="{$baseurl}/" class="active">Søk</a>
            </li>
            <li>
              <a href="{$baseurl}/advancedsearch">Avansert søk
              </a>
            </li>
            <li>
              <a href="{$baseurl}/a-z">A-Å
              </a>
            </li>
            <!--
            <li>
              <a href="{$baseurl}/admin">Administrasjon
              </a>
            </li>
            -->
          </ul>

            <!--
          <p id="layoutdims">
            Brødsmuler her? |
            <a href="#">Smule 1</a>
            |
            <a href="#">Smule 2</a>
            |
            <strong>Nåværende smule</strong>
          </p>
           -->
           
	   
	    <!-- xsl:if test="c:page/c:mode != 'search-result'">
	      <xsl:call-template name="set-langs"/>
	    </xsl:if -->
	   
	    <p id="layoutdims">
	      <a href="#">Login</a>
	    </p>
        </div>
        
        
        
        <div class="colmask threecol">
          <div class="colmid">
            <div class="colleft">
              <div class="col1">

		<!--
		  <xsl:call-template name="debug"/>
		-->

       <!-- Column 1 start -->
		
		<!-- Search -->
	    <!-- Search is shown when advanced search is not -->	
        <xsl:if test="not(c:page/c:advancedsearch/node())">
		
		  <form action="{$baseurl}/search-result" method="get">
		  <fieldset>
		    <input type="hidden" name="prefix" value="dct: &lt;http://purl.org/dc/terms/&gt;"/>
		    <input type="hidden" name="prefix" value="foaf: &lt;http://xmlns.com/foaf/0.1/&gt;"/>
		    <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
		    <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
             <br/>
            <input id="keyword" class="searchbox" type="text"
                   name="searchstring" size="40"/>
            <input type="submit" value="Søk"/><br/>
            <input type="radio" name="booleanoperator" value="AND" checked="checked"/>OG
            <input type="radio" name="booleanoperator" value="OR"/>
            ELLER
            <input type="checkbox" name="deepsearch" value="deepsearch"/>
            Søk også i de eksterne ressursene
            </fieldset>
          </form>
          
        </xsl:if>
        
        <!-- Facets -->
        <!-- Facets are shown if the c:/page/c:facets exists in the XML --> 
        <xsl:if test="c:page/c:mode != 'resource' and c:page/c:mode != 'browse'">
           <xsl:if test="c:page/c:facets">
            <h3>Velg avgrensning</h3>
            <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="facets"/>
          </xsl:if>
        </xsl:if>
                
        
        <!-- Advanced search -->        
        <!-- Her kommer avansert søk dersom denne er angitt, og tipsboksen dersom brukeren har valgt den -->
        <xsl:call-template name="advancedsearch"/>
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

        <!-- Search results -->
        <xsl:if test="c:page/c:mode = 'topic' or c:page/c:mode = 'search-result'">
            <h3>Ressurser</h3>
            <!-- Søkeresultatene -->
            <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="results"/>
        </xsl:if>
        
         <!-- Column 1 end -->
      </div>
             
      <div class="col2">
          <!-- Column 2 (left) start -->
            <h2>Mine aktiviteter</h2>
            <a href="{$baseurl}/tips">Tips oss om en ny ressurs</a><br/>
        
            <xsl:choose>
              <xsl:when test="c:page/c:loggedin = 'true' ">
                <a href="{$baseurl}/admin/emner/">Emner</a><br/>
                <a href="{$baseurl}/admin/ressurser/">Ressurser</a><br/>
                <a href="{$baseurl}/admin/brukere/">Brukere</a><br/>
                <a href="{$baseurl}/admin/utgivere/">Utgivere</a><br/>
                <a href="{$baseurl}/admin/lenkesjekk/">Lenkesjekk</a><br/>
                <a href="{$baseurl}/admin/database/">Database</a><br/>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$baseurl}/login">Logg inn</a><br/>
              </xsl:otherwise>
            </xsl:choose>

        <!-- Column 2 end -->
       </div>
       
       <div class="col3">
            <!-- Column 3 start -->
        
        <!-- Navigation -->
        <!-- Navigation is only shown when one topic is in focus -->
        <!-- Discussion is open on showing a different navigation scheme when more then one topic is in focus --> 
        <xsl:if test="c:page/c:mode = 'topic'">
            <h3>Navigering</h3>
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
          <p>A Free Software Project supported by
            <a href="http://www.abm-utvikling.no/">ABM Utvikling</a>
            and
            <a href="http://www.computas.com/">Computas AS</a>
            , 2008
          </p>
        </div>


      </body>
    </html>
  </xsl:template>


</xsl:stylesheet>