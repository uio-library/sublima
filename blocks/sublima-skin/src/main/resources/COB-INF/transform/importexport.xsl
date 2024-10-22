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
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:sioc="http://rdfs.org/sioc/ns#"
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:import href="controlbutton.xsl"/>
  <xsl:param name="baseurl"/>

  <xsl:template match="c:upload" mode="upload">
    <form action="upload" method="POST" enctype="multipart/form-data">
      <xsl:call-template name="hidden-locale-field"/>

      <fieldset>
      <table>
        <tr>
          <td align="right">
            <label for="location">
              <i18n:text key="location">Lokasjon</i18n:text>
            </label>
          </td>
          <td>
            <input id="location" type="file" name="location" size="40"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="tittel">
              <i18n:text key="type">Type</i18n:text>
            </label>
          </td>
          <td>
            <select name="type">
              <option value="RDF/XML">RDF/XML</option>
              <option value="N3">N3</option>
              <option value="Turtle" selected="selected">Turtle</option>
            </select>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">database.import</xsl:with-param>
              <xsl:with-param name="buttontext">button.read</xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </table>
      </fieldset>
    </form>
    <hr/>

    <h4>Export</h4>
    <form action="export" method="GET">
      <xsl:call-template name="hidden-locale-field"/>
      
      <table>
      <tr>
          <td align="right">
            <label for="type">
              <i18n:text key="type">Type</i18n:text>
            </label>
          </td>
          <td>
            <select name="type" id="type">
              <option value="application/rdf+xml" selected="selected">RDF/XML</option>
              <option value="text/rdf+n3">N3/Turtle</option>
            </select>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">database.export</xsl:with-param>
              <xsl:with-param name="buttontext">button.export</xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </table>
    </form>

  </xsl:template>
</xsl:stylesheet>