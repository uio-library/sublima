<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:sq="http://www.w3.org/2005/sparql-results#"
    version="1.0">

  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="sq:sparql">
    <xsl:param name="field"/>
    <xsl:param name="label"/>
    <xsl:if test="./sq:results/sq:result">
      <tr>
	<th scope="row">
	  <label for="{$field}">
	    <xsl:value-of select="$label"/>
	  </label>
	</th>
	<td>
	  <select id="{$field}" name="{$field}">
	    <option value=""></option>
	    <xsl:for-each select="./sq:results/sq:result">
	      <xsl:sort lang="{$interface-language}" select="./sq:binding[@name = 'label']/sq:literal[@xml:lang=$interface-language]"/>
	      <xsl:if test="./sq:binding[@name = 'label']/sq:literal[@xml:lang=$interface-language]">
		<option value="{./sq:binding[@name = 'uri']/sq:uri}">
		  <xsl:value-of select="./sq:binding[@name = 'label']/sq:literal[@xml:lang=$interface-language]"/>
		</option>
	      </xsl:if>
	    </xsl:for-each>
	  </select>
	</td>
      </tr>
      
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

