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
        xmlns:sq="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">

    <xsl:import href="autocompletion.xsl"/>
    <xsl:import href="sparql-uri-label-pairs.xsl"/>

    <xsl:param name="baseurl"/>
    <xsl:param name="interface-language">no</xsl:param>


    <xsl:template match="c:advancedsearch" mode="advancedsearch">

        <script type="text/javascript">
            function validateadvancedsearch() {

                // ugly cause of ampersand issues with XHTML/XSLT
               
                    if($('#subject').val() != '') {
                        return true;
                    } else if($('#title').val()!= '') {
                        return true;
                    } else if($('#description').val() != ''){
                        return true;
                    } else if($('#publisher').val() != ''){
                        return true;
                    } else if(document.getElementById("dct:type").value != ''){
                        return true;
                    } else if(document.getElementById("dct:audience").value != ''){
                        return true;
                 <xsl:if test="/c:page/c:loggedin = 'true'">
                    } else if($('#dateAccepted').val() != '') {
                        return true;
                    } else if($('#dateSubmitted').val() != ''){
                        return true;
                    } else if(document.getElementById("sub:committer").value != ''){
                        return true;
                    } else if(document.getElementById("wdr:describedBy").value != ''){
                        return true;
                 </xsl:if>
                     } else if(document.getElementById("dct:language").value != ''){
                        alert("Søket vil gi for mange treff. Vennligst angi mer enn bare språk.");
                        return true;
                        }  else {
                            return false;
                        }
            }
        </script>

        <xsl:call-template name="autocompletion">
            <xsl:with-param name="baseurl">
                <xsl:value-of select="$baseurl"/>
            </xsl:with-param>
            <xsl:with-param name="interface-language">
                <xsl:value-of select="$interface-language"/>
            </xsl:with-param>
        </xsl:call-template>

        <form name="advancedsearch" action="search-result.html" method="GET" onsubmit="return validateadvancedsearch()">
            <input type="hidden" name="freetext-field" value="dct:title"/>
            <input type="hidden" name="freetext-field" value="dct:subject/sub:literals"/>
            <input type="hidden" name="freetext-field" value="dct:description"/>
            <input type="hidden" name="freetext-field" value="dct:publisher/foaf:name"/>

            <input type="hidden" name="prefix" value="dct: &lt;http://purl.org/dc/terms/&gt;"/>
            <input type="hidden" name="prefix" value="foaf: &lt;http://xmlns.com/foaf/0.1/&gt;"/>
            <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
            <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
            <input type="hidden" name="prefix" value="wdr: &lt;http://www.w3.org/2007/05/powder#&gt;"/>

            <xsl:call-template name="hidden-locale-field"/>
            <table>
                <tr>
                    <th scope="row">
                        <label for="subject">
                            <i18n:text key="adv.subject">Emne</i18n:text>
                        </label>
                    </th>
                    <td>
                        <input id="subject" type="text" name="dct:subject/sub:literals" size="20"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row">
                        <label for="title">
                            <i18n:text key="adv.title">Tittel</i18n:text>
                        </label>
                    </th>
                    <td>
                        <input id="title" type="text" name="dct:title" size="20"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row">
                        <label for="description">
                            <i18n:text key="adv.description">Beskrivelse</i18n:text>
                        </label>
                    </th>
                    <td>
                        <input id="description" type="text" name="dct:description" size="20"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row">
                        <label for="publisher">
                            <i18n:text key="adv.publisher">Utgiver</i18n:text>
                        </label>
                    </th>
                    <td>
                        <input id="publisher" type="text" name="dct:publisher/foaf:name" size="20"/>
                    </td>
                </tr>

                <xsl:apply-templates select="/c:page/c:mediatypes/sq:sparql">
                    <xsl:with-param name="field">dct:type</xsl:with-param>
                    <xsl:with-param name="label">
                        <i18n:text key="adv.mediaType">Mediatype</i18n:text>
                    </xsl:with-param>
                </xsl:apply-templates>

                <xsl:apply-templates select="/c:page/c:audiences/sq:sparql">
                    <xsl:with-param name="field">dct:audience</xsl:with-param>
                    <xsl:with-param name="label">
                        <i18n:text key="adv.audience">Målgruppe</i18n:text>
                    </xsl:with-param>
                </xsl:apply-templates>

                <xsl:choose>
                    <xsl:when test="/c:page/c:loggedin = 'true'">

                        <tr>
                            <th scope="row">
                                <label for="dateAccepted">
                                    <i18n:text key="adv.dateAccepted">Godkjent Dato</i18n:text>
                                </label>
                            </th>
                            <td>
                                <input id="dateAccepted" type="text" name="dct:dateAccepted" size="20"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">
                                <label for="dateSubmitted">
                                    <i18n:text key="adv.dateSubmitted">Innsendt Dato</i18n:text>
                                </label>
                            </th>
                            <td>
                                <input id="dateSubmitted" type="text" name="dct:dateSubmitted" size="20"/>
                            </td>
                        </tr>
                        <xsl:apply-templates select="/c:page/c:committers/sq:sparql">
                            <xsl:with-param name="field">sub:committer</xsl:with-param>
                            <xsl:with-param name="label">
                                <i18n:text key="adv.approved">Godkjent av</i18n:text>
                            </xsl:with-param>
                        </xsl:apply-templates>

                        <xsl:apply-templates select="/c:page/c:statuses/sq:sparql">
                            <xsl:with-param name="field">wdr:describedBy</xsl:with-param>
                            <xsl:with-param name="label">Status</xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <input type="hidden" name="wdr:describedBy"
                               value="http://sublima.computas.com/status/godkjent_av_administrator"/>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:apply-templates select="/c:page/c:languages/sq:sparql">
                    <xsl:with-param name="field">dct:language</xsl:with-param>
                    <xsl:with-param name="label">
                        <i18n:text key="adv.language">Språk</i18n:text>
                    </xsl:with-param>
                </xsl:apply-templates>
                
                <tr>
                    <td></td>
                    <td>
                        <input type="submit" i18n:attr="value" value="button.adv.search"/>
                        <input type="reset" value="button.empty" i18n:attr="value"/>
                    </td>
                </tr>
            </table>
        </form>
        <br/>
        <br/>
        <hr/>
        <br/>
        <br/>
        <h3><i18n:text key="dypsok">Dypsøk</i18n:text></h3>
        <p>
            <i18n:text key="search.externalresources.explained">Søk i ressursenes innhold</i18n:text>    
        </p>
        <form action="{$baseurl}/search-result.html" method="get">

            <fieldset>
                <input type="hidden" name="prefix" value="dct: &lt;http://purl.org/dc/terms/&gt;"/>
                <input type="hidden" name="prefix" value="foaf: &lt;http://xmlns.com/foaf/0.1/&gt;"/>
                <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
                <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
                <input type="hidden" name="prefix" value="wdr: &lt;http://www.w3.org/2007/05/powder#&gt;"/>
                <input type="hidden" name="prefix" value="skos: &lt;http://www.w3.org/2004/02/skos/core#&gt;"/>
                <input type="hidden" name="prefix" value="pf: &lt;http://jena.hpl.hp.com/ARQ/property#&gt;"/>
                <input type="hidden" name="deepsearch" value="deepsearch" checked="checked"/>
                <xsl:call-template name="hidden-locale-field"/>
                <input type="hidden" name="wdr:describedBy"
                       value="http://sublima.computas.com/status/godkjent_av_administrator"/>


                <input id="keyword" class="searchbox" type="text"
                       name="searchstring" value="{c:page/c:searchparams/c:searchparams/c:searchstring}"/>
                <input type="submit" id="btnSearch" value="search.submit" i18n:attr="value"/>
                <br/>


                <input type="radio" class="radio" name="booleanoperator" value="AND" checked="checked"/>
                <i18n:text key="search.boolean.and">og</i18n:text>
                <input type="radio" class="radio" name="booleanoperator" value="OR"/>
                <i18n:text key="search.boolean.or">eller</i18n:text>

                <!-- sorting panel -->
                <!-- updates and submits the search form -->
                <span id="sortingpanel">
                    <i18n:text key="search.sortby">Sorter etter</i18n:text>

                    <select id="sort" name="sort">
                        <option value="n0pred:title">
                            <xsl:if test="c:page/c:searchparams/c:searchparams/c:sortby = 'n0pred:title'">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                            <i18n:text key="title">Tittel</i18n:text>
                        </option>
                        <option value="n0pred:dateAccepted">
                            <xsl:if test="c:page/c:searchparams/c:searchparams/c:sortby = 'n0pred:dateAccepted'">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                            <i18n:text key="search.sortby.date">Dato</i18n:text>
                        </option>
                    </select>
                </span>
                <br/>
                <xsl:choose>
                    <xsl:when test="c:page/c:searchparams/c:searchparams/c:exactmatch = 'exactmatch'">
                        <input type="checkbox" class="radio" name="exactmatch" value="exactmatch" checked="checked"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <input type="checkbox" class="radio" name="exactmatch" value="exactmatch"/>
                    </xsl:otherwise>
                </xsl:choose>
                <i18n:text key="search.exactmatch">Eksakt ord</i18n:text>
            </fieldset>
        </form>
    </xsl:template>

</xsl:stylesheet>