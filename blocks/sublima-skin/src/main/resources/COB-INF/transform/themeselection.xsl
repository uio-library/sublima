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

  <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyzæøå</xsl:variable>
   <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ</xsl:variable>

    <xsl:template match="c:theme" mode="theme">
        <form action="{$baseurl}/admin/emner/tema" method="POST">
            <table>
                <tr>
                    <td>
                        <label for="A">A</label>
                    </td>
                    <td>
                        <select id="A" name="A" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'A')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="B">B</label>
                    </td>
                    <td>
                        <select id="B" name="B" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'B')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="C">C</label>
                    </td>
                    <td>
                        <select id="C" name="C" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'C')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="D">D</label>
                    </td>
                    <td>
                        <select id="D" name="D" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'D')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="E">E</label>
                    </td>
                    <td>
                        <select id="E" name="E" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'E')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="F">F</label>
                    </td>
                    <td>
                        <select id="F" name="F" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'F')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="G">G</label>
                    </td>
                    <td>
                        <select id="G" name="G" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'G')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="H">H</label>
                    </td>
                    <td>
                        <select id="H" name="H" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'H')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="I">I</label>
                    </td>
                    <td>
                        <select id="I" name="I" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'I')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="J">J</label>
                    </td>
                    <td>
                        <select id="J" name="J" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'J')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="K">K</label>
                    </td>
                    <td>
                        <select id="K" name="K" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'K')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="L">L</label>
                    </td>
                    <td>
                        <select id="L" name="L" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'L')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="M">M</label>
                    </td>
                    <td>
                        <select id="M" name="M" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'M')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="N">N</label>
                    </td>
                    <td>
                        <select id="N" name="N" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'N')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="O">O</label>
                    </td>
                    <td>
                        <select id="O" name="O" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'O')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="P">P</label>
                    </td>
                    <td>
                        <select id="P" name="P" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'P')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="Q">Q</label>
                    </td>
                    <td>
                        <select id="Q" name="Q" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'Q')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="R">R</label>
                    </td>
                    <td>
                        <select id="R" name="R" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'R')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="S">S</label>
                    </td>
                    <td>
                        <select id="S" name="S" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'S')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="T">T</label>
                    </td>
                    <td>
                        <select id="T" name="T" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'T')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="U">U</label>
                    </td>
                    <td>
                        <select id="U" name="U" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'U')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="V">V</label>
                    </td>
                    <td>
                        <select id="V" name="V" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'V')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="W">W</label>
                    </td>
                    <td>
                        <select id="W" name="W" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'W')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="X">X</label>
                    </td>
                    <td>
                        <select id="X" name="X" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'X')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="Y">Y</label>
                    </td>
                    <td>
                        <select id="Y" name="Y" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'Y')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="Z">Z</label>
                    </td>
                    <td>
                        <select id="Z" name="Z" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'Z')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="Æ">Æ</label>
                    </td>
                    <td>
                        <select id="Æ" name="Æ" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'Æ')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="Ø">Ø</label>
                    </td>
                    <td>
                        <select id="Ø" name="Ø" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'Ø')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="Å">Å</label>
                    </td>
                    <td>
                        <select id="Å" name="Å" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept[starts-with(translate(skos:prefLabel, $lcletters, $ucletters), 'Å')]">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="0-9">0-9</label>
                    </td>
                    <td>
                        <select id="0-9" name="0-9" multiple="true">
                            <option value=""/>
                            <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept">
                                <xsl:sort select="./skos:prefLabel"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:theme/c:themetopics/rdf:RDF/skos:Concept/@rdf:about">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./skos:prefLabel"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./skos:prefLabel"/>
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
                        <xsl:with-param name="buttontext">Lagre valgte temaemner</xsl:with-param>
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