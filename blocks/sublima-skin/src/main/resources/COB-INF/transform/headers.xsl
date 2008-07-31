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
    <head>
      <title>
	<xsl:value-of select="$title"/>
	<xsl:text> | SMIL</xsl:text>
      </title>
   
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <link rel="stylesheet" type="text/css" href="styles/alt-css.css"/>
      <link rel="stylesheet" href="styles/jquery.autocomplete.css" type="text/css" />
      <script src="styles/jquery.js" type="text/javascript" />
      <script type="text/javascript">var dummy = null;</script>      
      <script src="styles/jquery.bgiframe.min.js" type="text/javascript"/>
      <script type="text/javascript">var dummy = null;</script>
      <script src="styles/jquery.autocomplete.js" type="text/javascript" />
      <script type="text/javascript">var dummy = null;</script>
      <script src="styles/expand.js" type="text/javascript" />
      <script type="text/javascript">var dummy = null;</script>

          
    </head>
  </xsl:template>

  <xsl:template name="headers">
    <xsl:param name="baseurl"/>
    <div id="header">
      <img alt="header logo" src="{$baseurl}/images/smil_beta_header.png"/>
      
      <h2>Sublima 0.9.6.1</h2>
      <ul>
	<li>
	  <a href="{$baseurl}/{$qloc}" class="active"><i18n:text key="menu.search">Søk</i18n:text></a>
	</li>
	<li>
	  <a href="{$baseurl}/advancedsearch{$qloc}"><i18n:text key="menu.advancedsearch">Avansert søk</i18n:text>
	  </a>
	</li>
	<li>
	  <a href="{$baseurl}/a-z{$qloc}"><i18n:text key="menu.az">A-Å</i18n:text></a>
	</li>
	<!--
	    <li>
              <a href="{$baseurl}/admin{$qloc}">Administrasjon
	      </a>
	      </li>
	-->
      </ul>
 
            <p id="layoutdims">
            <!--xsl:for-each select="c:page/c:breadcrumbs/c:breadcrumb">
              <a>
                <xsl:attribute name="href"><xsl:value-of select="$baseurl"/>/<xsl:value-of select="."/><xsl:value-of select="$qloc"/>}</xsl:attribute><xsl:value-of select="@title"/></a>
              <xsl:text> | </xsl:text>
            </xsl:for-each-->

          </p>
	   

	  <xsl:call-template name="set-langs">
	    <xsl:with-param name="baseurl" select="$baseurl"/>
	  </xsl:call-template>
      
      <p id="layoutdims">
	<a href="{$baseurl}/login{$qloc}">Admin</a>
      </p>
    </div>
  </xsl:template>


</xsl:stylesheet>

