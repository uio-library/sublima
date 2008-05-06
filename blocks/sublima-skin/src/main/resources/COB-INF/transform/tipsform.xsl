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
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="c:tips" mode="form">

    <h2>Fant du ikke det du lette etter?</h2>
    <p>Tips oss gjerne dersom du finner sider som du tror vi kunne satt pris på!</p>
    <form name="tips" action="sendtips" method="GET">
      <table>
        <tr>
          <td align="right">
            <label for="url">URL</label>
          </td>
          <td>
            <input id="url" type="text" name="url" size="40"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="tittel">Tittel</label>
          </td>
          <td>
            <input id="tittel" type="text" name="tittel" size="40"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="beskrivelse">Beskrivelse</label>
          </td>
          <td>
            <textarea id="beskrivelse" name="beskrivelse" rows="6" cols="40">...</textarea>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="stikkord">Forslag til emner på ressursen (kommaseparert)</label>
          </td>
          <td>
            <input id="stikkord" type="text" name="stikkord" size="40"/>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <input type="submit" value="Send inn"/>
          </td>
        </tr>
      </table>
    </form>
  
  </xsl:template>
</xsl:stylesheet>