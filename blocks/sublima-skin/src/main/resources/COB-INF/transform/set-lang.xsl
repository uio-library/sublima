<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:c="http://xmlns.computas.com/cocoon"
   version="1.0">

  <xsl:template name="set-langs">
    <div class="set-langs">
      Sett språk til:
      <xsl:choose>
	<xsl:when test="not(/c:page/c:facets/c:request/@paramcount) or /c:page/c:facets/c:request/@paramcount = 0">
	  <a href="?locale=no">Norsk</a>, 
	  <a href="?locale=da">Dansk</a>, 
	  <a href="?locale=sv">Svenska</a>, 
	</xsl:when>
	<xsl:when test="/c:page/c:facets/c:request/c:param">
	  <xsl:variable name="baseurlparams">
	    <xsl:value-of select="/c:page/c:facets/c:request/@justbaseurl"/>
	    <xsl:text>?</xsl:text>
	    <xsl:for-each select="/c:page/c:facets/c:request/c:param">
	      <xsl:for-each select="c:value">
		<xsl:if test="text() and not(../@key = 'locale')">
		  <xsl:value-of select="../@key"/>=<xsl:value-of select="."/>&amp;<xsl:text/>
		</xsl:if>
	      </xsl:for-each>
	    </xsl:for-each>
	  </xsl:variable>
	  <a href="{$baseurlparams}&amp;locale=no">Norsk</a>, 
	  <a href="{$baseurlparams}&amp;locale=da">Dansk</a>, 
	  <a href="{$baseurlparams}&amp;locale=sv">Svenska</a>, 

	</xsl:when>
      </xsl:choose>
      
	eller se <a href="http://www.w3.org/International/questions/qa-lang-priorities">hvordan sette nettleserens språk</a>.
    </div>
  </xsl:template>
</xsl:stylesheet>

