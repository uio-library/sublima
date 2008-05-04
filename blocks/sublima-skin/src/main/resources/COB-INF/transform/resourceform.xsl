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

    <xsl:param name="baseurl"/>
    <xsl:param name="interface-language">no</xsl:param>
    <xsl:template match="c:resourcedetails" mode="edit">

        <form name="new_resource" action="{$baseurl}/admin/ressurser/ny" method="POST">

            <input type="hidden" name="a" value="http://xmlns.computas.com/sublima#Resource"/>
            <input type="hidden" name="dct:identifier" value="{./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource}"/>
            <table>
                <tr>
                    <td>
                        <label for="dct:title">Tittel</label>
                    </td>
                    <td>
                        <input id="dct:title" type="text" name="dct:title" size="40" value="{./c:resource/rdf:RDF/sub:Resource/dct:title}" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="sub:url">URI</label>
                    </td>
                    <td>
                        <input id="sub:url" type="text" name="sub:url" size="40" value="{./c:resource/rdf:RDF/sub:Resource/@rdf:about}" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="dct:description">Beskrivelse</label>
                    </td>
                    <td>
                        <textarea id="dct:description" name="dct:description" rows="6" cols="40"><xsl:value-of
                                select="./c:resource/rdf:RDF/sub:Resource/dct:description"/>...</textarea>
                    </td>
                </tr>
            </table>
            <br/>
            <p>Velg utgiver fra nedtrekkslisten, eller la den stå tom og skriv inn navnet på den nye utgiveren i
                tekstfeltet
                under
            </p>
            <table>
                <tr>
                    <td>
                        <label for="dct:publisher/foaf:Agent/@rdf:about">Utgiver</label>
                    </td>
                    <td>
                        <select id="dct:publisher" name="dct:publisher">
                            <option value=""/>
                            <xsl:for-each select="./c:publishers/rdf:RDF/foaf:Agent">
                                <xsl:sort select="./foaf:name"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:publisher/@rdf:resource">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./foaf:name"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./foaf:name"/>
                                        </option>    
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input id="dct:publisher/foaf:Agent/foaf:name" type="text"
                               name="dct:publisher/foaf:Agent/foaf:name" size="40"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="dct:language">Språk</label>
                    </td>
                    <td>
                        <select id="dct:language" name="dct:language" multiple="multiple" size="10">
                            <xsl:for-each select="./c:languages/rdf:RDF/lingvoj:Lingvo">
                                <xsl:sort select="./rdfs:label"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:language/@rdf:resource">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="dct:MediaType">Mediatype</label>
                    </td>
                    <td>
                        <select id="dct:MediaType" name="dct:MediaType" multiple="multiple" size="10">
                            <xsl:for-each
                                    select="./c:mediatypes/rdf:RDF/dct:MediaType">
                                <xsl:sort select="./rdfs:label"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:MediaType/@rdf:resource">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="dct:audience">Målgruppe</label>
                    </td>
                    <td>
                        <select id="dct:audience" name="dct:audience" multiple="multiple" size="10">
                            <xsl:for-each
                                    select="./c:audiences/rdf:RDF/dct:AgentClass">
                                <xsl:sort select="./rdfs:label"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:audience/@rdf:resource">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="dct:subject">Emner</label>
                    </td>
                    <td>
                        <select id="dct:subject" name="dct:subject" multiple="multiple" size="10">
                            <xsl:for-each select="./c:topics/rdf:RDF/skos:Concept">
                                <xsl:sort select="./rdfs:label"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:subject/@rdf:resource">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="rdfs:comment">Kommentar</label>
                    </td>
                    <td>
                        <textarea id="rdfs:comment" name="rdfs:comment" rows="6" cols="40">...<xsl:value-of
                                select="./c:resource/rdf:RDF/sub:Resource/rdfs:comment"/></textarea>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="wdr:DR">Status</label>
                    </td>
                    <td>
                        <select id="wdr:DR" name="wdr:DR">
                            <option value=""/>
                            <xsl:for-each select="./c:statuses/rdf:RDF/wdr:DR">
                                <xsl:sort select="./rdfs:label"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/wdr:DR/@rdf:resource">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        
                    </td>
                </tr>
                <tr>
                    <td>Brukernes kommentarer</td>
                    <td>
                        <ul>
                            <xsl:for-each select="./c:resource/rdf:RDF/sub:Resource/sub:comment">
                                <li>
                                    <xsl:value-of select="." />
                                </li>
                            </xsl:for-each>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="submit" value="Lagre ressurs"/>
                    </td>
                    <td>
                        <input type="reset" value="Rens skjema"/>
                    </td>
                </tr>
            </table>
        </form>
    </xsl:template>





  <xsl:template match="c:resourcedetails" mode="temp">

        <form name="new_resource" action="{$baseurl}/admin/ressurser/ny" method="POST">

            <input type="hidden" name="a" value="http://xmlns.computas.com/sublima#Resource"/>
            <input type="hidden" name="dct:identifier" value="{./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource}"/>
            <table>
                <tr>
                    <td>
                        <label for="dct:title">Tittel</label>
                    </td>
                    <td>
                        <input id="dct:title" type="text" name="dct:title" size="40" value="{./c:tempvalues/c:tempvalues/dct:title}" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="sub:url">URI</label>
                    </td>
                    <td>
                        <input id="sub:url" type="text" name="sub:url" size="40" value="{./c:tempvalues/c:tempvalues/sub:url}"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="dct:description">Beskrivelse</label>
                    </td>
                    <td>
                        <textarea id="dct:description" name="dct:description" rows="6" cols="40"><xsl:value-of
                                select="./c:tempvalues/c:tempvalues/dct:description"/>...</textarea>
                    </td>
                </tr>
            </table>
            <br/>
            <p>Velg utgiver fra nedtrekkslisten, eller la den stå tom og skriv inn navnet på den nye utgiveren i
                tekstfeltet
                under
            </p>
            <table>
                <tr>
                    <td>
                        <label for="dct:publisher/foaf:Agent/@rdf:about">Utgiver</label>
                    </td>
                    <td>
                        <select id="dct:publisher" name="dct:publisher">
                            <option value=""/>
                            <xsl:for-each select="./c:publishers/rdf:RDF/foaf:Agent">
                                <xsl:sort select="./foaf:name"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/dct:publisher">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./foaf:name"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./foaf:name"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input id="dct:publisher/foaf:Agent/foaf:name" type="text"
                               name="dct:publisher/foaf:Agent/foaf:name" size="40"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="dct:language">Språk</label>
                    </td>
                    <td>
                        <select id="dct:language" name="dct:language" multiple="multiple" size="10">
                            <xsl:for-each select="./c:languages/rdf:RDF/lingvoj:Lingvo">
                                <xsl:sort select="./rdfs:label"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/dct:language/@rdf:description">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="dct:MediaType">Mediatype</label>
                    </td>
                    <td>
                        <select id="dct:MediaType" name="dct:MediaType" multiple="multiple" size="10">
                            <xsl:for-each
                                    select="./c:mediatypes/rdf:RDF/dct:MediaType">
                                <xsl:sort select="./rdfs:label"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/dct:MediaType/@rdf:description">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="dct:audience">Målgruppe</label>
                    </td>
                    <td>
                        <select id="dct:audience" name="dct:audience" multiple="multiple" size="10">
                            <xsl:for-each
                                    select="./c:audiences/rdf:RDF/dct:AgentClass">
                                <xsl:sort select="./rdfs:label"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/dct:audience/@rdf:description">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="dct:subject">Emner</label>
                    </td>
                    <td>
                        <select id="dct:subject" name="dct:subject" multiple="multiple" size="10">
                            <xsl:for-each select="./c:topics/rdf:RDF/skos:Concept">
                                <xsl:sort select="./rdfs:label"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/dct:subject/@rdf:description">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="rdfs:comment">Kommentar</label>
                    </td>
                    <td>
                        <textarea id="rdfs:comment" name="rdfs:comment" rows="6" cols="40"><xsl:value-of
                                select="./c:tempvalues/c:tempvalues/rdfs:comment"/>...</textarea>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="wdr:DR">Status</label>
                    </td>
                    <td>
                        <select id="wdr:DR" name="wdr:DR">
                            <option value=""/>
                            <xsl:for-each select="./c:statuses/rdf:RDF/wdr:DR">
                                <xsl:sort select="./rdfs:label"/>
                                <xsl:choose>
                                    <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/wdr:DR">
                                        <option value="{./@rdf:about}" selected="selected">
                                            <xsl:value-of select="./rdfs:label"/>
                                        </option>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <option value="{./@rdf:about}">
                                            <xsl:value-of select="./rdfs:label"/>
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
                        <input type="submit" value="Lagre ressurs"/>
                    </td>
                    <td>
                        <input type="reset" value="Rens skjema"/>
                    </td>
                </tr>
            </table>
        </form>
    </xsl:template>

</xsl:stylesheet>