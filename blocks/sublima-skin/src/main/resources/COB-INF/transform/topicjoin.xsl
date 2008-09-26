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

    <xsl:template match="c:join" mode="topicjoin">

      <xsl:call-template name="selectmultiple">
        <xsl:with-param name="selectionid">#concept</xsl:with-param>
      </xsl:call-template>

        <form action="{$baseurl}/admin/emner/koble" method="POST">
            <table>
                <tr>
                    <td>
                        <label for="concept"><i18n:text key="topics">Emner</i18n:text></label>
                    </td>
                    <td>
                        <select id="concept" name="skos:Concept" multiple="multiple">
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept">
                                <xsl:sort lang="{$interface-language}" select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:join/c:tempvalues/c:tempvalues/skos:Concept/@rdf:about">
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
                    <td><label for="skos:Concept/skos:prefLabel"><i18n:text key="topic.commonname">Felles navn</i18n:text></label></td>
                    <td><input id="skos:Concept/skos:prefLabel" type="text" name="skos:Concept/skos:prefLabel" size="40" value="{./c:tempvalues/c:tempvalues/skos:Concept/skos:prefLabel}" /></td>
                </tr>
             
                <tr>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                       <xsl:call-template name="controlbutton">
                        <xsl:with-param name="privilege">topic.join</xsl:with-param>
                        <xsl:with-param name="buttontext"><i18n:text key="button.join">Slå sammen</i18n:text></xsl:with-param>
                      </xsl:call-template>
                    </td>
                    <td>

                    </td>
                </tr>
            </table>
        </form>

    </xsl:template>
</xsl:stylesheet>