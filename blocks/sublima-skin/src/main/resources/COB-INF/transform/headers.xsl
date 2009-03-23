<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:sub="http://xmlns.computas.com/sublima#"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        version="1.0">

  <xsl:template name="head">
    <xsl:param name="title"/>
    <xsl:param name="baseurl"/>

    <head>
      <title>
	<xsl:value-of select="$title"/>
	<xsl:text> | SMIL</xsl:text>
      </title>
   
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <xsl:if test="not($rss-url = '')">
	<link rel="alternate" 
	      type="application/rss+xml" 
	      title="RSS" 
	      href="{$rss-url}" />
      </xsl:if>

      <link rel="stylesheet" type="text/css" href="{$baseurl}/styles/alt-css.css"/>
      <link rel="stylesheet" href="{$baseurl}/styles/jquery.autocomplete.css" type="text/css" />
      <link rel="stylesheet" href="{$baseurl}/styles/jquery.asmselect.css" type="text/css" />
      <script src="{$baseurl}/styles/jquery-1.3.2.min.js" type="text/javascript" />
      <script type="text/javascript">var dummy = null;</script>      
      <script src="{$baseurl}/styles/jquery.bgiframe.min.js" type="text/javascript"/>
      <script type="text/javascript">var dummy = null;</script>
      <script src="{$baseurl}/styles/jquery.autocomplete.js" type="text/javascript" />
      <script type="text/javascript">var dummy = null;</script>
      <script src="{$baseurl}/styles/expand.js" type="text/javascript" />
      <script type="text/javascript">var dummy = null;</script>
      <script src="{$baseurl}/styles/expand.js" type="text/javascript" />
      <script type="text/javascript">var dummy = null;</script>
      <script src="{$baseurl}/styles/jquery.asmselect.js" type="text/javascript" />
      <script type="text/javascript">var dummy = null;</script>
      <script src="{$baseurl}/styles/jquery.ui.js" type="text/javascript" />
      <script type="text/javascript">var dummy = null;</script>
      <script src="{$baseurl}/styles/jquery.tablesorter.min.js" type="text/javascript" />
      <script type="text/javascript">var dummy = null;</script>
      <script src="{$baseurl}/styles/jquery.template.js" type="text/javascript" />
      <script type="text/javascript">var dummy = null;</script>
          
    </head>
  </xsl:template>

  <xsl:template name="headers">
    <xsl:param name="baseurl"/>
    <div id="header">
      <img alt="header logo" src="{$baseurl}/images/detektor_beta_header.png"/>
      
      <h2>Sublima 1.0.0 RC-19</h2>
      <div>

	  <a href="{$baseurl}/{$qloc}" class="active">
	  <i18n:text key="menu.search">Søk</i18n:text></a> ,

	  <a href="{$baseurl}/advancedsearch{$qloc}"><i18n:text key="menu.advancedsearch">Avansert søk</i18n:text>
	  </a> ,
	  <a href="{$baseurl}/a-z{$qloc}"><i18n:text key="menu.az">A-Å</i18n:text></a>
      </div>
 
      <p id="layoutdims"> 
	<xsl:call-template name="set-langs">
	  <xsl:with-param name="baseurl" select="$baseurl"/>
	</xsl:call-template>
      </p>

      <p id="layoutdims">
	<a href="{$baseurl}/login{$qloc}">Admin</a>         
      </p>
    </div>
  </xsl:template>


</xsl:stylesheet>

