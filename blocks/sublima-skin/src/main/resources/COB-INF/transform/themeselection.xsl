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
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:import href="controlbutton.xsl"/>
  <xsl:import href="selectmultiple.xsl"/>

  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyzæøå</xsl:variable>
  <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ</xsl:variable>

    <xsl:template match="c:theme" mode="theme">

      <xsl:call-template name="selectmultiple">
        <xsl:with-param name="selectionid">#subject</xsl:with-param>
      </xsl:call-template>

        <form id="themeselection" action="{$baseurl}/admin/emner/tema" method="POST">
            <table>
                <tr>
                    <td>
                        <label for="subject"><i18n:text key="topics.theme">Temaemner</i18n:text></label>
                    </td>
                    <td>
                        <select id="subject" name="dct:subject" multiple="true">
                          <option value=""/>
                          <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept">
                              <xsl:sort lang="{$interface-language}" select="./skos:prefLabel"/>
                              <xsl:choose>
                                  <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                      <option value="{./@rdf:about}" selected="selected">
                                          <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                                      </option>
                                  </xsl:when>
                                  <xsl:otherwise>
                                      <option value="{./@rdf:about}">
                                          <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                                      </option>
                                  </xsl:otherwise>
                              </xsl:choose>
                          </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                       <xsl:call-template name="controlbutton">
                        <xsl:with-param name="privilege">topic.theme</xsl:with-param>
                        <xsl:with-param name="buttontext"><i18n:text key="button.savethemetopics">Lagre valgte temaemner</i18n:text></xsl:with-param>
                      </xsl:call-template>
                    </td>
                    <td>

                    </td>
                </tr>
            </table>
        </form>

    </xsl:template>
</xsl:stylesheet>