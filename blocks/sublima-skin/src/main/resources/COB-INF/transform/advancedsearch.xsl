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
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:sq="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="c:advancedsearch" mode="advancedsearch">

    <script type="text/javascript">
        $(document).ready(function(){
          $("#subject").autocomplete("autocomplete", {
            minChars: 3,
            extraParams : { action:"topic", locale:"<xsl:value-of select="$interface-language"/>" }
            });

          $("#publisher").autocomplete("autocomplete", {
            minChars: 3,
            extraParams : { action:"publisher", locale:"<xsl:value-of select="$interface-language"/>" }
            });
        });
    </script>

    <form action="search-result.html" method="GET">
      <input type="hidden" name="freetext-field" value="dct:title"/>
      <input type="hidden" name="freetext-field" value="dct:subject/all-labels"/>
      <input type="hidden" name="freetext-field" value="dct:description"/>
      <input type="hidden" name="freetext-field" value="dct:publisher/foaf:name"/>

      <input type="hidden" name="prefix" value="dct: &lt;http://purl.org/dc/terms/&gt;"/>
      <input type="hidden" name="prefix" value="foaf: &lt;http://xmlns.com/foaf/0.1/&gt;"/>
      <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
      <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
      <xsl:call-template name="hidden-locale-field"/>
      <table>
        <tr>
          <th scope="row">
            <label for="title">Title</label>
          </th>
          <td>
            <input id="title" type="text" name="dct:title" size="20"/>
          </td>
        </tr>
        <tr>
          <th scope="row">
            <label for="subject">Subject</label>
          </th>
          <td>
            <input id="subject" type="text" name="dct:subject/all-labels" size="20"/>
          </td>
        </tr>
        <tr>
          <th scope="row">
            <label for="description">Description</label>
          </th>
          <td>
            <input id="description" type="text" name="dct:description" size="20"/>
          </td>
        </tr>
        <tr>
          <th scope="row">
            <label for="publisher">Publisher</label>
          </th>
          <td>
            <input id="publisher" type="text" name="dct:publisher/foaf:name" size="20"/>
          </td>
        </tr>
        <tr>
          <th scope="row">
            <label for="dateAccepted">DateAccepted</label>
          </th>
          <td>
            <input id="dateAccepted" type="text" name="dct:dateAccepted" size="20"/>
          </td>
        </tr>
        <tr>
          <th scope="row">
            <label for="dateSubmitted">DateSubmitted</label>
          </th>
          <td>
            <input id="dateSubmitted" type="text" name="dct:dateSubmitted" size="20"/>
          </td>
	</tr>
	<xsl:apply-templates select="/c:page/c:mediatypes/sq:sparql">
	  <xsl:with-param name="field">dct:format</xsl:with-param>
	  <xsl:with-param name="label">Type</xsl:with-param>
	</xsl:apply-templates>

	<xsl:apply-templates select="/c:page/c:languages/sq:sparql">
	  <xsl:with-param name="field">dct:language</xsl:with-param>
	  <xsl:with-param name="label">Språk</xsl:with-param>
	</xsl:apply-templates>

	<xsl:apply-templates select="/c:page/c:audiences/sq:sparql">
	  <xsl:with-param name="field">dct:audience</xsl:with-param>
	  <xsl:with-param name="label">Publikum</xsl:with-param>
	</xsl:apply-templates>

	<xsl:apply-templates select="/c:page/c:committers/sq:sparql">
	  <xsl:with-param name="field">sub:committer</xsl:with-param>
	  <xsl:with-param name="label">Godkjent av</xsl:with-param>
	</xsl:apply-templates>

        <tr>
          <td></td>
          <td>
            <input type="submit" value="Search"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

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
	      <xsl:sort select="./sq:binding[@name = 'label']/sq:literal"/>
	      <option value="{./sq:binding[@name = 'uri']/sq:uri}">
		<xsl:value-of select="./sq:binding[@name = 'label']/sq:literal"/>
	      </option>
	    </xsl:for-each>
	  </select>
	</td>
      </tr>
      
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>