<?xml version="1.0" encoding="UTF-8"?>


<!--
This stylesheet is the main stylesheet that is called for all pages.

-->

<!--
PVJ: Made the file UTF-8
-->





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
  <xsl:import href="rdfxml2xhtml-deflist-full.xsl"/>
  <xsl:import href="rdfxml2xhtml-deflist-short.xsl"/>
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
  
  <xsl:param name="rss-url">    
    <xsl:if test="c:page/c:mode = 'topic' or c:page/c:mode = 'search-result'">
      <xsl:choose>
	<xsl:when test="contains(/c:page/c:facets/c:request/@requesturl, '?')">
	  <xsl:value-of select="concat(substring-before(/c:page/c:facets/c:request/@requesturl, '.html?'), '.rss?', substring-after(/c:page/c:facets/c:request/@requesturl, '?'))"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat(substring-before(/c:page/c:facets/c:request/@requesturl, '.html'), '.rss')"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:param>
  

  <xsl:param name="numberofhits" select="count(c:page/c:result-list/rdf:RDF/sub:Resource)"/>

  <xsl:param name="res-view">
    <xsl:if test="/c:page/c:facets/c:request/c:param[@key='res-view'] !=''">
        <xsl:value-of select="/c:page/c:facets/c:request/c:param[@key='res-view']/c:value"/>
    </xsl:if>
  </xsl:param>
  
  
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
     <xsl:with-param name="baseurl" select="$baseurl"/>
      </xsl:call-template>
   
      <body>

	<xsl:value-of select="$querystring"/>
	<xsl:call-template name="headers">
	  <xsl:with-param name="baseurl" select="$baseurl"/>
	</xsl:call-template>
	
	
	<div class="colmask threecol" style="border:0px solid red;"  >
	  <div class="colmidleft" style="border:0px solid green;">
	    <div class="colleft" style="border:0px solid blue;">
	      
	      
	      
	      
<!-- ######################################################################
     CENTER COLUMN (col1)
	 contains: search panel, topic description panel, resource hits 
	 ###################################################################### -->       
	 <div class="col1" style="border:0px dotted red;">

		<!-- xsl:call-template name="debug"/ -->

	
		
		<!-- A-Z -->
		<div name="panel-az" style="border:0px solid lightgray">
		<xsl:apply-templates select="c:page" mode="a-z"/>                
        </div>
		
		<!-- Search -->
		<!-- Search is shown when advanced search is not -->	
		<xsl:if test="not(c:page/c:advancedsearch)">

      <div name="panel-search" style="border:0px solid brown">
		      <form action="{$baseurl}/search-result.html" method="get">  
		    <fieldset>
		      <input type="hidden" name="prefix" value="dct: &lt;http://purl.org/dc/terms/&gt;"/>
		      <input type="hidden" name="prefix" value="foaf: &lt;http://xmlns.com/foaf/0.1/&gt;"/>
		      <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
		      <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/> 
		      <input type="hidden" name="prefix" value="wdr: &lt;http://www.w3.org/2007/05/powder#&gt;"/>
		      <input type="hidden" name="prefix" value="skos: &lt;http://www.w3.org/2004/02/skos/core#&gt;"/>
		      <input type="hidden" name="prefix" value="pf: &lt;http://jena.hpl.hp.com/ARQ/property#&gt;"/>
		      <xsl:call-template name="hidden-locale-field"/>
		      <br/>
		      <input type="hidden" name="wdr:describedBy" value="http://sublima.computas.com/status/godkjent_av_administrator"/>

		      <input id="keyword" class="searchbox" type="text"
			     name="searchstring" size="40" value="{c:page/c:searchparams/c:searchparams/c:searchstring}"/>
		      <input type="submit" value="search.submit" i18n:attr="value"/>
		      <br/>

          <xsl:call-template name="autocompletion"/>

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
			<xsl:when test="c:page/c:searchparams/c:searchparams/c:exactmatch = 'exactmatch'">
			  <input type="checkbox" name="exactmatch" value="exactmatch" checked="checked"/>
			</xsl:when>
			<xsl:otherwise>
			  <input type="checkbox" name="exactmatch" value="exactmatch"/>
			</xsl:otherwise>
          </xsl:choose>
          <i18n:text key="search.exactmatch">Eksakt ord</i18n:text>
          <br/>

          <xsl:choose>
			<xsl:when test="c:page/c:searchparams/c:searchparams/c:deepsearch = 'deepsearch'">
			  <input type="checkbox" name="deepsearch" value="deepsearch" checked="checked"/>
			</xsl:when>
			<xsl:otherwise>
			  <input type="checkbox" name="deepsearch" value="deepsearch"/>
			</xsl:otherwise>
		      </xsl:choose>
		      <i18n:text key="search.externalresources">Inkluder søk i ressursinnhold</i18n:text>
		      <br/>
		      
		      
		      <!-- sorting panel -->
		      <!-- updates and submits the search form -->
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
		  </div>
		</xsl:if>

        <xsl:call-template name="messages"/>


        
        <!-- 
         Number of hits 
            precondition:
             page is topic, or search-result
        -->
        <xsl:if test="c:page/c:mode = 'topic' or c:page/c:mode = 'search-result'">
		  <i18n:text key="search.numberofhits">Antall treff</i18n:text>: <xsl:value-of select="$numberofhits"/><br/>
		</xsl:if>
		
			
		
		<!-- 
		 Advanced search        
		    Her kommer avansert søk dersom denne er angitt
		-->
		<xsl:apply-templates select="c:page/c:advancedsearch" mode="advancedsearch"/>
		
		
		
		<!-- 
		 Tips
		  precondition:
		  vises dersom brukeren har valgt den
		-->
		<xsl:apply-templates select="c:page/c:tips" mode="form"/>
		
		
		<!-- 
		 Login 
		  precondition:
		-->
		<xsl:apply-templates select="c:page/c:login" mode="login"/>
		
		
		<!-- 
		 Resource Description (details) 
		     precondition: 
		      page is 'resource'
		-->
		<div name="panel-resource-details" style="border:0px solid pink;">
		<xsl:if test="c:page/c:mode = 'resource'">		
		  <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="resource"/>
		</xsl:if>
		<xsl:text> </xsl:text> <!-- avoid empty div --> 
		</div>
		
		
		<!-- 
		 Topic description (details) 
		     precondition: 
		      page is 'browse' 
		-->
		<div name="panel-topic-details" style="border:0px solid purple;"> 
		<xsl:if test="c:page/c:mode = 'browse'">
		  <xsl:apply-templates select="c:page/c:browse" mode="browse"/>
		</xsl:if>
		<xsl:text> </xsl:text> <!-- avoid empty div --> 
		</div>
		

		<!-- 
	    No-hits 
		 precondition:
		   page is topic or search-result
		   no hits  
		-->
		<div name="panel-zero-hits" style="1px solid brown;">
		<xsl:if test="c:page/c:mode = 'topic' or c:page/c:mode = 'search-result'">
		
		  <xsl:if test="$numberofhits &lt; 1">
		      <br/>
		              <!-- Generer et google søk -->     
		              <a>
		                  <xsl:attribute name="href">
		                      <xsl:text>http://www.google.com/search?hl=</xsl:text>
		                      <xsl:value-of select="$interface-language"/>
		                      <xsl:text>&amp;q=</xsl:text>
		                      <xsl:value-of select="c:page/c:facets/c:request/c:param[@key='searchstring']/c:value"/>
		                      <xsl:text>&amp;btnG=Google-søk</xsl:text>
                          </xsl:attribute>
		                  <i18n:text key="search.for">Søk etter</i18n:text><xsl:text> '</xsl:text> 
		                  <xsl:value-of select="c:page/c:facets/c:request/c:param[@key='searchstring']/c:value"/> 
		                  <xsl:text>' </xsl:text> 
		                  <i18n:text key="in.google">i Google</i18n:text>
		              </a>
		              <br/>
		   </xsl:if>
		 </xsl:if>
		 <xsl:text> </xsl:text> <!-- avoid empty div tags -->
		</div> <!-- no hits -->     
	
	
		
		<!-- 
		 Search results
		  precondition:
		   page-mode is topic or search-results
		   hits is more than 0
		-->		
	  <div name="panel-results" style="border:0px solid orange;">	
	   <xsl:if test="c:page/c:mode = 'topic' or c:page/c:mode = 'search-result'">
	    <xsl:if test="$numberofhits &gt; 0">	
	
	     <h3><i18n:text key="resources.heading">Ressurser</i18n:text></h3>
		  

		
		  <xsl:choose>	  
    		 <xsl:when test="$res-view='full'">
    		 
    		  <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="results-full">
		          <xsl:with-param name="sorting"><xsl:value-of select="c:page/c:searchparams/c:searchparams/c:sortby"/></xsl:with-param>
	       	  </xsl:apply-templates>
             </xsl:when>  

    		 <xsl:when test="$res-view='short'">
    		 
    		  <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="results-short">
		          <xsl:with-param name="sorting"><xsl:value-of select="c:page/c:searchparams/c:searchparams/c:sortby"/></xsl:with-param>
	       	  </xsl:apply-templates>
             </xsl:when>  
		     
		     <xsl:otherwise>
		      <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="results">
		          <xsl:with-param name="sorting"><xsl:value-of select="c:page/c:searchparams/c:searchparams/c:sortby"/></xsl:with-param>
	       	  </xsl:apply-templates>
	        </xsl:otherwise>
		  </xsl:choose>
		  </xsl:if>
		</xsl:if>
		<xsl:text> </xsl:text> <!-- avoid empty results --> 
		</div><!-- panel-results-->
		
		
		
        
	  </div>
	  <!-- Column 1 end -->  
	      
	      
	      
	      
    <!-- ######################################################################
	     LEFT COLUMN (col2)
	     
	     contains: facets
	     ###################################################################### -->       
    <div class="col2" style="border:0px dotted blue;">
    
    
    
    	<!-- Facets 
    	  precondition: 
	        page is topic or search-result 
	        there is at least one hit
		    facets exists in the results (c:/page/c:facets exists in the XML)
		--> 
		<xsl:if test="c:page/c:mode = 'topic' or c:page/c:mode = 'search-result'">
		 <xsl:if test="$numberofhits &gt; 0">  
		  <xsl:if test="c:page/c:facets">
		  <div name="panel-facets" style="border:0px solid yellow;">		    
		   <!-- <h3><i18n:text key="facets.heading">Velg avgrensning</i18n:text></h3> -->
		    <xsl:apply-templates select="c:page/c:result-list/rdf:RDF" mode="facets"/>
		  </div>   
		  </xsl:if>
		 </xsl:if>  
	    </xsl:if>
	    <xsl:text> </xsl:text>
	   </div>
	   
	   
	   
		<!-- Column 2 end -->      
	      
	      
	      
	      
	      
	      
	      
	      
	      
	      
	      
	      
    <!-- ######################################################################
	     RIGHT COLUMN (col3)
	     
	     contains: 
	     ###################################################################### -->       
        <div class="col3" style="border:0px dotted green;">


		<!-- Navigation 
		  precondition:
		   page is either topic or search result
		-->
		
		<!--when one topic is in focus-->
		<div name="panel-nav" style="border:0px solid black">
		<xsl:if test="c:page/c:mode = 'topic'">
		  <h3><i18n:text key="topic.navigation">Navigering</i18n:text></h3>
		  <xsl:apply-templates select="c:page/c:navigation/rdf:RDF/skos:Concept">
		    <xsl:with-param name="role">this-param</xsl:with-param>
		  </xsl:apply-templates>
		</xsl:if>

		<!--more than one topic-->
		<xsl:if test="c:page/c:mode = 'search-result'">
		  <h3><i18n:text key="topic.navigation">Navigering</i18n:text></h3>
		  <ul>
		    <xsl:for-each select="c:page/c:navigation/rdf:RDF//skos:Concept">
		      <xsl:sort lang="{$interface-language}" select="skos:prefLabel[@xml:lang=$interface-language]"/>
		      <li>
			<a href="{./@rdf:about}.html{$qloc}"><xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/></a>
		      </li>
		    </xsl:for-each>
		  </ul>
		</xsl:if>
		<xsl:text> </xsl:text> <!-- avoid empty div -->
		</div>
		
		
        <!-- 
         Tasks
          precondition:
            none
        -->
		<div name="panel-tasks" style="border:0px solid darkgrey;">
		<h2><i18n:text key="menu.heading">Aktiviteter</i18n:text></h2>
		<a href="{$baseurl}/tips{$qloc}"><i18n:text key="menu.tips">Tips oss om en ny ressurs</i18n:text></a><br/>
		
		<xsl:choose>
		  <xsl:when test="c:page/c:loggedin = 'true' ">
		    <a href="{$baseurl}/admin/emner/{$qloc}"><i18n:text key="menu.topic">Emner</i18n:text></a><br/>
		    <a href="{$baseurl}/admin/ressurser/{$qloc}"><i18n:text key="menu.resource">Ressurser</i18n:text></a><br/>
		    <a href="{$baseurl}/admin/brukere/{$qloc}"><i18n:text key="menu.user">Brukere</i18n:text></a><br/>
		    <a href="{$baseurl}/admin/utgivere/{$qloc}"><i18n:text key="menu.publisher">Utgivere</i18n:text></a><br/>
		    <a href="{$baseurl}/admin/lenkesjekk/{$qloc}"><i18n:text key="menu.link">Lenkesjekk</i18n:text></a><br/>
		    <a href="{$baseurl}/admin/database/{$qloc}"><i18n:text key="menu.database">Database</i18n:text></a><br/>
        <a href="/stats/"><i18n:text key="menu.stats">Statistikk</i18n:text></a><br/>
        <br/>
        <a href="{$baseurl}/do-logout{$qloc}"><i18n:text key="admin.logout">Logg ut</i18n:text></a><br/>
    </xsl:when>
		</xsl:choose>
		</div>
	
	
		<!-- 
		  Link to RSS representation of search result 
		  precondition:
		    more than zero hits
		    rss-url has been created
		-->
    
		<div name="panel-rss" style="border:0px solid gray">
	    <xsl:if test="$numberofhits &gt; 0">	
		<xsl:if test="not($rss-url = '')">
		  <a>
		    <xsl:attribute name="href">
		      <xsl:value-of select="$rss-url"/>
		    </xsl:attribute> 
		    RSS
		  </a><br/>
		</xsl:if>
		</xsl:if>
		</div>
 		  
		
		
		

	      </div><!-- Column 3 end -->
	    
	    
	    </div>
	  </div>
	</div> <!-- three column layout end -->
	
	
	<div id="footer">
	  <p><i18n:text key="sublima.footer">An Open Source Software Project supported by
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