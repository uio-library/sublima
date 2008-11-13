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
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="c:tips" mode="form">

    <i18n:text key="tips.heading"><h2>Fant du ikke det du lette etter?</h2><br/><p>Tips oss gjerne dersom du finner sider som du tror vi kunne satt pris på!</p></i18n:text>
    <br/>

    <xsl:if test="/c:page/c:content/c:messages/c:messages/c:message">
      <ul>
        <xsl:for-each select="/c:page/c:content/c:messages/c:messages/c:message">
          <li>
            <xsl:value-of select="."/>
            <br/>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
    
    <form action="sendtips" method="GET">
      <table>
        <tr>
          <td align="right">
            <label for="url"><i18n:text key="url">URL</i18n:text></label>
          </td>
          <td>
            <input id="url" type="text" name="url" size="40"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="tittel"><i18n:text key="title">Tittel</i18n:text></label>
          </td>
          <td>
            <input id="tittel" type="text" name="tittel" size="40"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="beskrivelse"><i18n:text key="description">Beskrivelse</i18n:text></label>
          </td>
          <td>
            <textarea id="beskrivelse" name="beskrivelse" rows="6" cols="40"><xsl:text> </xsl:text></textarea>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="stikkord"><i18n:text key="tips.suggestedtopics">Forslag til emner på ressursen (kommaseparert)</i18n:text></label>
          </td>
          <td>
            <input id="stikkord" type="text" name="stikkord" size="40"/>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <input type="submit" value="tips.submit" i18n:attr="value"/>
          </td>
        </tr>
      </table>
    </form>
  
  </xsl:template>
</xsl:stylesheet>