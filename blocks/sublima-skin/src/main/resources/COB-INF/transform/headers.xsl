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
			<script src="{$baseurl}/styles/curvycorners.js" type="text/javascript" />
			<script type="text/javascript">var dummy = null;</script>
			<script src="{$baseurl}/styles/textsize.js" type="text/javascript" />
			<script type="text/javascript">var dummy = null;</script>
			<script src="{$baseurl}/styles/calculateHeight.js" type="text/javascript" />
			<script type="text/javascript">var dummy = null;</script>
			<script type="text/JavaScript">
				addEvent(window, 'load', initCorners);

				function initCorners() {
				var headerMenuSettings = {
				tl: { radius: 20 },
				tr: { radius: 20 },
				bl: { radius: 0 },
				br: { radius: 0 },
				antiAlias: true
				}
				curvyCorners(headerMenuSettings, ".MenuItem");
				ChangeTextSize(null, null);
				calculateDivHeight();
				hideFacetsOnLoad();
				}
			</script>
		</head>
  </xsl:template>

  <xsl:template name="headers">
    <xsl:param name="baseurl"/>
    <div id="header">
			<div id="headerLogo">
				<a  href="{$baseurl}/">
				<img alt="header logo" class="headerImg" src="{$baseurl}/images/sublima-logo.png"/>
				<span id="headerText">Emneportalverktøy</span>
				</a>
			</div>
			<div id="topMenu">
				<div id="headerSpacer">&#160;</div>
				<div class="MenuItem">Om portalen</div>
				<div class="MenuItem">
					<a href="{$baseurl}/tips{$qloc}">
						<i18n:text key="menu.tips">Forsalg</i18n:text>
					</a>
				</div>
				<div class="MenuItem">Hjelp</div>
			</div>
			
			<div class="langBar">
				<xsl:call-template name="set-langs">
					<xsl:with-param name="baseurl" select="$baseurl"/>
				</xsl:call-template>
				<div id="textSize">
					<a id="textSizeLarge" style="cursor:pointer;" onclick="ChangeTextSize('16px', this);">A</a>
					<a id="textSizeMedium" style="cursor:pointer;" onclick="ChangeTextSize('14px', this);">A</a>
					<a id="textSizeSmall" style="cursor:pointer;" onclick="ChangeTextSize('12px', this);">A</a>
				</div>
			</div>
			
    </div>
  </xsl:template>


</xsl:stylesheet>

