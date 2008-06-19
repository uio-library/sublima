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
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">

  <xsl:import href="controlbutton.xsl"/>

  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>
  <xsl:template match="c:resourceprereg" mode="resourceprereg">

    <form action="{$baseurl}/admin/ressurser/checkurl" method="POST">
      <table>
        <tr>
          <td>
            <label for="sub:url">URL</label>
          </td>
          <td>
            <input id="sub:url" type="text" name="sub:url" size="40"
                   value="{./c:tempvalues/c:tempvalues/sub:url}"/>
          </td>
        </tr>
        <tr>
          <td>

            <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">topic.edit</xsl:with-param>
              <xsl:with-param name="buttontext">Gå videre</xsl:with-param>
            </xsl:call-template>

          </td>
          <td>
            <input type="reset" value="Rens skjema"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

</xsl:stylesheet>