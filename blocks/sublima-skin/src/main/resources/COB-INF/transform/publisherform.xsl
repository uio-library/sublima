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
  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:import href="controlbutton.xsl"/>
  <xsl:param name="baseurl"/>
    <xsl:param name="interface-language">no</xsl:param>

    <xsl:template match="c:join" mode="topicjoin">
      <form action="insertpublisher" method="GET">
      <table>
        <tr>
          <td>
            <label for="new_publisher">Navn</label>
          </td>
          <td>
            <input id="new_publisher" type="text" name="new_publisher" size="40"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="dct:description">Beskrivelse</label>
          </td>
          <td>
            <textarea id="dct:description" name="dct:description" rows="6" cols="40">...</textarea>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <input type="submit" value="Lagre utgiver"/>
          </td>
        </tr>
      </table>
    </form>

    </xsl:template>
</xsl:stylesheet>