<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:c="http://xmlns.computas.com/cocoon"
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
   version="1.0">

  <xsl:template name="lang-text">
    <xsl:param name="url"/>
    <a lang="no" hreflang="no" href="{$url}no">Norsk</a> <!--&#160;&#160;-->
<!--  
    <a lang="da" hreflang="da" href="{$url}da">Dansk</a> &#160;&#160;
    <a lang="sv" hreflang="sv" href="{$url}sv">Svenska</a>
    <a lang="en" hreflang="en" href="{$url}en">English</a> 
-->
  </xsl:template>
  
  <xsl:template name="set-langs"> 
    <xsl:param name="baseurl"/>
    <div class="set-langs">
      <xsl:choose>
	<xsl:when test="not(/c:page/c:facets/c:request/@paramcount) or /c:page/c:facets/c:request/@paramcount = 0">
	  <xsl:call-template name="lang-text">
	    <xsl:with-param name="url"><xsl:text>?locale=</xsl:text></xsl:with-param>
	  </xsl:call-template>
	</xsl:when>
	<xsl:when test="/c:page/c:facets/c:request/c:param">
	  <xsl:call-template name="lang-text">
	    <xsl:with-param name="url">
	      <xsl:value-of select="/c:page/c:facets/c:request/@justbaseurl"/>
	      <xsl:text>?</xsl:text>
	      <xsl:for-each select="/c:page/c:facets/c:request/c:param">
		<xsl:for-each select="c:value">
		  <xsl:if test="text() and not(../@key = 'locale')">
		    <xsl:value-of select="../@key"/>=<xsl:value-of select="."/>&amp;<xsl:text/>
		  </xsl:if>
		</xsl:for-each>
	      </xsl:for-each>
	      <xsl:text>&amp;locale=</xsl:text>
	    </xsl:with-param>
	  </xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
	  <!-- drop down to a provide a localised link to the root page -->
	  <xsl:call-template name="lang-text">
	    <xsl:with-param name="url">
	      <xsl:value-of select="$baseurl"/>
	      <xsl:text>/?locale=</xsl:text>
	    </xsl:with-param>
	  </xsl:call-template>
	</xsl:otherwise>
	
      </xsl:choose>
      
    </div>
  </xsl:template>

  <xsl:template name="hidden-locale-field">
    <xsl:if test="contains(/c:page/c:facets/c:request/@requesturl, 'locale=')">
      <input type="hidden" name="locale" value="{$interface-language}"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

