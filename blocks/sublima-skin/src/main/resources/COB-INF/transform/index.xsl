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

  <xsl:template match="c:index">

    <h4>Index</h4>

      <xsl:call-template name="hidden-locale-field"/>
      <fieldset>
        <table>
          <thead>
            <tr>
              <th scope="col">
                <i18n:text key="index.type">Type</i18n:text>
              </th>
              <th scope="col">
                <i18n:text key="lastRun">Sist kjørt</i18n:text>
              </th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="/c:page/c:content/c:index/c:statistics/c:statistic">
              <tr>
                <td>
                  <i18n:text key="{./c:type}"/>
                </td>
                <td>
                  <xsl:value-of select="./c:date"/>
                </td>
              </tr>
            </xsl:for-each>
            
            <tr>
              <td>
                <form action="all" method="POST">
                <xsl:call-template name="controlbutton">
                  <xsl:with-param name="privilege">database.import</xsl:with-param>
                  <xsl:with-param name="buttontext">button.index.all</xsl:with-param>
                </xsl:call-template>
                </form>
              </td>
            </tr>
            <tr>
              <td>
                <form action="resources" method="POST">
                <xsl:call-template name="controlbutton">
                  <xsl:with-param name="privilege">database.import</xsl:with-param>
                  <xsl:with-param name="buttontext">button.index.resources</xsl:with-param>
                </xsl:call-template>
                </form>
              </td>
            </tr>
            <tr>
              <td>
                <form action="topics" method="POST">
                <xsl:call-template name="controlbutton">
                  <xsl:with-param name="privilege">database.import</xsl:with-param>
                  <xsl:with-param name="buttontext">button.index.topics</xsl:with-param>
                </xsl:call-template>
                </form>
              </td>
            </tr>
          </tbody>
        </table>
      </fieldset>


  </xsl:template>
</xsl:stylesheet>