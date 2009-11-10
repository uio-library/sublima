<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:c="http://xmlns.computas.com/cocoon"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                xmlns:sub="http://xmlns.computas.com/sublima#"
                xmlns:sioc="http://rdfs.org/sioc/ns#"
                xmlns:lingvoj="http://www.lingvoj.org/ontology#"
                xmlns:wdr="http://www.w3.org/2007/05/powder#"
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:go="http://www.geonames.org/ontology#"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr">

    <xsl:param name="interface-language">no</xsl:param>
    <xsl:param name="max_facets">2</xsl:param>

    <xsl:template match="rdf:RDF" mode="facets">
        <xsl:variable name="baseurlparams">
            <xsl:choose>
                <xsl:when test="/c:page/c:mode = 'topic'">
                    <xsl:text>../search-result.html?dct:subject=</xsl:text>
                    <xsl:value-of select="/c:page/c:navigation/rdf:RDF/skos:Concept/@rdf:about"/>
                    <xsl:text>&amp;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>?</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="/c:page/c:facets/c:request/c:param">
                <xsl:for-each select="c:value">
                    <xsl:if test="text()">
                        <xsl:value-of select="../@key"/>=<xsl:value-of select="."/>&amp;<xsl:text/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>

        <div class="facets">

            <xsl:if test="sub:Resource/dct:publisher">
                <h2 class="subHeading">
                    <i18n:text key="limit.search">Avgrens søk</i18n:text>
                </h2>
                <br/>
                <div class="facet">
                    <div class="facetHeading">
                        <h3>
                            <i18n:text key="publisher">Utgiver</i18n:text>
                        </h3>
                        <img id="openClosePublisher" alt="open/close publisher" src="{$baseurl}/images/closefacet.png"
                             onclick="OpenCloseFact('publisherFacets', this);"/>
                        <div class="clearer">&#160;</div>
                    </div>
                    <div id="publisherFacets">
                        <ul>
                            <xsl:apply-templates select="sub:Resource/dct:publisher" mode="facets">
                                <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
                                <xsl:sort lang="{$interface-language}" select="foaf:Agent/foaf:name"/>
                            </xsl:apply-templates>
                        </ul>
                        <div id="publisherFacetHideShow" class="showHideFacetslinks">
                            <a id="publisherFacetShowLink" href="javascript:showfacets('publisherFacet');">
                                <i18n:text key="more">mer</i18n:text>
                            </a>
                            <a id="publisherFacetHideLink" href="javascript:hidefacets('publisherFacet');">
                                <i18n:text key="hide">skjul</i18n:text>
                            </a>
                        </div>
                    </div>
                </div>
            </xsl:if>

            <xsl:if test="sub:Resource/dct:language">
                <div class="facet">
                    <div class="facetHeading">
                        <h3>
                            <i18n:text key="language">Språk</i18n:text>
                        </h3>
                        <img id="openCloseLanguage" alt="open/close publisher" src="{$baseurl}/images/closefacet.png"
                             onclick="OpenCloseFact('languageFacets', this);"/>
                        <div class="clearer">&#160;</div>
                    </div>
                    <div id="languageFacets">
                        <ul>
                            <xsl:apply-templates select="sub:Resource/dct:language" mode="facets">
                                <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
                                <xsl:sort lang="{$interface-language}"
                                          select="lingvoj:Lingvo/rdfs:label[@xml:lang=$interface-language]"/>
                            </xsl:apply-templates>
                        </ul>
                        <div id="languageFacetHideShow" class="showHideFacetslinks">
                            <a id="languageFacetShowLink" href="javascript:showfacets('languageFacet');">
                                <i18n:text key="more">mer</i18n:text>
                            </a>
                            <a id="languageFacetHideLink" href="javascript:hidefacets('languageFacet');">
                                <i18n:text key="hide">skjul</i18n:text>
                            </a>
                        </div>
                    </div>
                </div>
            </xsl:if>


            <xsl:if test="sub:Resource/dct:audience">
                <div class="facet">
                    <div class="facetHeading">
                        <h3>
                            <i18n:text key="audience">Målgruppe</i18n:text>
                        </h3>
                        <img id="openCloseAudience" alt="open/close publisher" src="{$baseurl}/images/closefacet.png"
                             onclick="OpenCloseFact('audienceFacets', this);"/>
                        <div class="clearer">&#160;</div>
                    </div>
                    <div id="audienceFacets">
                        <ul>
                            <xsl:apply-templates select="sub:Resource/dct:audience" mode="facets">
                                <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
                                <xsl:sort lang="{$interface-language}"
                                          select="dct:AgentClass/rdfs:label[@xml:lang=$interface-language]"/>
                            </xsl:apply-templates>
                        </ul>
                        <div id="audienceFacetHideShow" class="showHideFacetslinks">
                            <a id="audienceFacetShowLink" href="javascript:showfacets('audienceFacet');">
                                <i18n:text key="more">mer</i18n:text>
                            </a>
                            <a id="audienceFacetHideLink" href="javascript:hidefacets('audienceFacet');">
                                <i18n:text key="hide">skjul</i18n:text>
                            </a>
                        </div>
                    </div>
                </div>
            </xsl:if>

            <!-- Getting the right counts for the facets turned out to be
                 somewhat tricky.  Four situations can occur:

             1) The dct:subject element has the skos:Concept as child
             element.

                 2) The dct:subject element only has an rdf:resource attribute
                 that reference the skos:Concept which is a child element of a
                 dct:subject.

                 3) The skos:Concept is a child element of rdf:RDF element.

                 4) The skos:Concept is a child element of a subproperty of
                 skos:semanticRelation at some level

                 Furthermore, we assume that each skos:Concept only occur once
                 in the c:result-list.

                 If point 3) and 4) was absent, counting would be easy, just
                 count the number of dct:subject as in point 2) and add one,
                 since all but one dct:subject would reference a skos:Concept.

                 Point 3) and 4) violates this assumption, so the count has to
                 check if the skos:Concept is a direct child of rdf:RDF and if
                 it is a child element of some skos:narrower or skos:broader.

                 As far as we can see, this assumption is only violated for
                 skos:Concept, the simple count works for the other facets. If
                 other facets are seen with wrong counts, this is a point that
                 should be investigated.
            -->


            <div class="facet">

                <!-- sorted by preferred label -->
                <div class="facetHeading">
                    <h3>
                        <i18n:text key="topic">Emne</i18n:text>
                    </h3>
                    <img id="openCloseTopic" alt="open/close publisher" src="{$baseurl}/images/closefacet.png"
                         onclick="OpenCloseFact('subjectFacets', this);"/>
                    <div class="clearer">&#160;</div>
                </div>
                <xsl:if test="sub:Resource/dct:subject">
                    <div id="subjectFacets">
                        <ul>
                            <xsl:for-each select="/c:page/c:result-list/rdf:RDF//skos:Concept">
                                <xsl:sort lang="{$interface-language}"
                                          select="skos:prefLabel[@xml:lang=$interface-language]"/>
                                <xsl:variable name="uri" select="./@rdf:about"/>
                                <xsl:variable name="count">
                                    <xsl:choose>
                                        <xsl:when test="/c:page/c:result-list/rdf:RDF/skos:Concept[@rdf:about=$uri]">
                                            <xsl:value-of
                                                    select="count(/c:page/c:result-list/rdf:RDF/sub:Resource/dct:subject[@rdf:resource=$uri])"/>
                                        </xsl:when>
                                        <xsl:when
                                                test="/c:page/c:result-list/rdf:RDF/skos:Concept//skos:Concept[@rdf:about=$uri]">
                                            <xsl:value-of
                                                    select="count(/c:page/c:result-list/rdf:RDF/sub:Resource/dct:subject[@rdf:resource=$uri])"/>
                                        </xsl:when>
                                        <xsl:when
                                                test="/c:page/c:result-list/rdf:RDF/sub:Resource/dct:subject/skos:Concept[@rdf:about=$uri]">
                                            <xsl:value-of
                                                    select="count(/c:page/c:result-list/rdf:RDF/sub:Resource/dct:subject[@rdf:resource=$uri])+1"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                    select="count(/c:page/c:result-list/rdf:RDF/sub:Resource/dct:subject[@rdf:resource=$uri])"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>

                                <xsl:if test="not($count ='0')">
                                    <xsl:call-template name="facet-field">

                                        <xsl:with-param name="this-field">dct:subject</xsl:with-param>
                                        <xsl:with-param name="this-label">
                                            <xsl:choose>
                                                <xsl:when test="./skos:prefLabel[@xml:lang=$interface-language]">
                                                    <xsl:value-of
                                                            select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="$interface-language = 'no'">
                                                            <span class="warning">
                                                                <i18n:text key="validation.topic.notitle">Emnet mangler
                                                                    tittel på valgt språk
                                                                </i18n:text>
                                                            </span>
                                                        </xsl:when>
                                                        <xsl:when test="$interface-language = 'nn'">
                                                            <span class="warning">
                                                                <i18n:text key="validation.topic.notitle">Emnet manglar
                                                                    tittel på valgt språk
                                                                </i18n:text>
                                                            </span>
                                                        </xsl:when>
                                                        <xsl:when test="$interface-language = 'sv'">
                                                            <span class="warning">
                                                                <i18n:text key="validation.topic.notitle">Ämnet har inte
                                                                    titel på angivet språk
                                                                </i18n:text>
                                                            </span>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <span class="warning">
                                                                <i18n:text key="validation.topic.notitle">Topic has no
                                                                    title for the selected language
                                                                </i18n:text>
                                                            </span>
                                                        </xsl:otherwise>
                                                    </xsl:choose>

                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:with-param>
                                        <xsl:with-param name="uri" select="$uri"/>
                                        <xsl:with-param name="count" select="$count"/>
                                        <xsl:with-param name="baseurlparams" select="$baseurlparams"/>

                                    </xsl:call-template>
                                </xsl:if>

                            </xsl:for-each>
                        </ul>
                        <div id="subjectFacetHideShow" class="showHideFacetslinks">
                            <a id="subjectFacetShowLink" href="javascript:showfacets('subjectFacet');">
                                <i18n:text key="more">mer</i18n:text>
                            </a>
                            <a id="subjectFacetHideLink" href="javascript:hidefacets('subjectFacet');">
                                <i18n:text key="hide">skjul</i18n:text>
                            </a>
                        </div>
                    </div>
                </xsl:if>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="dct:language" mode="facets">
        <xsl:param name="baseurlparams"/>
        <xsl:variable name="uri" select="./lingvoj:Lingvo/@rdf:about"/>
        <xsl:call-template name="facet-field">

            <xsl:with-param name="this-field">dct:language</xsl:with-param>
            <xsl:with-param name="this-label" select="./lingvoj:Lingvo/rdfs:label[@xml:lang=$interface-language]"/>
            <xsl:with-param name="uri" select="$uri"/>
            <xsl:with-param name="count"
                            select="count(/c:page/c:result-list/rdf:RDF/sub:Resource/dct:language[@rdf:resource=$uri])+1"/>
            <xsl:with-param name="baseurlparams" select="$baseurlparams"/>

        </xsl:call-template>
    </xsl:template>

    <xsl:template match="dct:publisher" mode="facets">
        <xsl:param name="baseurlparams"/>
        <xsl:variable name="uri" select="./foaf:Agent/@rdf:about"/>
        <xsl:call-template name="facet-field">

            <xsl:with-param name="this-field">dct:publisher</xsl:with-param>
            <xsl:with-param name="this-label" select="./foaf:Agent/foaf:name"/>
            <xsl:with-param name="uri" select="$uri"/>
            <xsl:with-param name="count"
                            select="count(/c:page/c:result-list/rdf:RDF/sub:Resource/dct:publisher[@rdf:resource=$uri])+1"/>
            <xsl:with-param name="baseurlparams" select="$baseurlparams"/>

        </xsl:call-template>
    </xsl:template>

    <xsl:template match="dct:coverage" mode="facets">
        <xsl:param name="baseurlparams"/>
        <xsl:variable name="uri" select="./go:Country/@rdf:about"/>
        <xsl:call-template name="facet-field">

            <xsl:with-param name="this-field">dct:coverage</xsl:with-param>
            <xsl:with-param name="this-label" select="./go:Country/rdfs:label[@xml:lang=$interface-language]"/>
            <xsl:with-param name="uri" select="$uri"/>
            <xsl:with-param name="count"
                            select="count(/c:page/c:result-list/rdf:RDF/sub:Resource/dct:coverage[@rdf:resource=$uri])+1"/>
            <xsl:with-param name="baseurlparams" select="$baseurlparams"/>

        </xsl:call-template>
    </xsl:template>


    <xsl:template match="dct:audience" mode="facets">
        <xsl:param name="baseurlparams"/>
        <xsl:variable name="uri" select="./dct:AgentClass/@rdf:about"/>
        <xsl:call-template name="facet-field">

            <xsl:with-param name="this-field">dct:audience</xsl:with-param>
            <xsl:with-param name="this-label" select="./dct:AgentClass/rdfs:label[@xml:lang=$interface-language]"/>
            <xsl:with-param name="uri" select="$uri"/>
            <xsl:with-param name="count"
                            select="count(/c:page/c:result-list/rdf:RDF/sub:Resource/dct:audience[@rdf:resource=$uri])+1"/>
            <xsl:with-param name="baseurlparams" select="$baseurlparams"/>
        </xsl:call-template>
    </xsl:template>


    <!-- This template can used to construct facets. See the above for examples.
         it takes a number of parameters:


           baseurlparams   - Should be passed from other templates.
       this-field      - The machine field, e.g. dct:subject.
       this-label      - The human-readable label for this facet.
           uri             - The URI for the resource that uses this-label
       count           - The number of resources that has this label.

    -->


    <xsl:template name="facet-field">
        <xsl:param name="baseurlparams"/>
        <xsl:param name="this-label"/>
        <xsl:param name="this-field"/>
        <xsl:param name="uri"/>
        <xsl:param name="count"/>
        <xsl:if test="$uri">
            <li>
                <xsl:choose>
                    <xsl:when test="$this-field = 'dct:publisher'">
                        <xsl:attribute name="class">publisherFacet</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$this-field = 'dct:language'">
                        <xsl:attribute name="class">languageFacet</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$this-field = 'dct:audience'">
                        <xsl:attribute name="class">audienceFacet</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$this-field = 'dct:subject'">
                        <xsl:attribute name="class">subjectFacet</xsl:attribute>
                    </xsl:when>
                </xsl:choose>

                <xsl:choose>
                    <xsl:when test="$count = $numberofhits">
                        <xsl:value-of select="$this-label"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <a> <!-- The following builds the URL. -->
                            <xsl:attribute name="href">
                                <xsl:value-of select="$baseurlparams"/>
                                <xsl:value-of select="$this-field"/>
                                <xsl:text>=</xsl:text>
                                <xsl:value-of select="$uri"/>
                                <xsl:value-of select="$aloc"/>
                            </xsl:attribute>
                            <xsl:value-of select="$this-label"/>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>

                (<xsl:value-of select="$count"/>)

                <xsl:if test="/c:page/c:facets/c:request/c:param[@key = $this-field]/c:value = $uri">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="uri-for-facet-remove">
                                <xsl:with-param name="key" select="$this-field"/>
                                <xsl:with-param name="value" select="$uri"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <i18n:text key="remove">Fjern</i18n:text>
                    </a>
                </xsl:if>
            </li>
        </xsl:if>
    </xsl:template>

    <xsl:template name="uri-for-facet-remove">
        <xsl:param name="key"/>
        <xsl:param name="value"/>
        <xsl:text>search-result.html?</xsl:text>
        <xsl:for-each select="/c:page/c:facets/c:request/c:param">
            <xsl:for-each select="c:value">
                <xsl:if test="not(../@key = $key and . = $value)">
                    <xsl:value-of select="../@key"/>=<xsl:value-of select="."/>&amp;<xsl:text/>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="root">
        <xsl:copy>
            <xsl:apply-templates>
                <xsl:sort select="position()"
                          order="descending"
                          data-type="number"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>