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
    <!-- Importerer de ulike språkversjonene av de statiske sidene -->
    <xsl:import href="om_portalen_no.xsl"/>
    <xsl:import href="om_portalen_sv.xsl"/>
    <xsl:import href="om_portalen_en.xsl"/>
    <xsl:import href="hjelp_no.xsl"/>
    <xsl:import href="hjelp_en.xsl"/>
    <xsl:import href="mer_om_no.xsl"/>

    <xsl:param name="baseurl"/>
    <xsl:param name="interface-language"/>

    <!-- Matcher c:static som indikerer at vi skal se på statisk innhold -->
    <xsl:template match="c:static">
        <!--xsl:value-of disable-output-escaping="yes" select="."/-->

        <!-- Sjekker om URL'en er portal/om_portalen -->
        <xsl:if test=". = 'om_portalen'">
            <!-- Sjekker på språk, og viser riktig språktemplate -->
            <xsl:choose>
                <xsl:when test="$interface-language = 'no'">
                    <xsl:call-template name="om_portalen_no"/>
                </xsl:when>
                <xsl:when test="$interface-language = 'sv'">
                    <xsl:call-template name="om_portalen_sv"/>
                </xsl:when>
                <xsl:when test="$interface-language = 'da'">
                    <xsl:call-template name="om_portalen_no"/>
                </xsl:when>
                <xsl:when test="$interface-language = 'en'">
                    <xsl:call-template name="om_portalen_en"/>
                </xsl:when>
                <xsl:otherwise>

                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <!-- Sjekker om URL'en er portal/om_portalen -->
        <xsl:if test=". = 'hjelp'">
            <!-- Sjekker på språk, og viser riktig språktemplate -->
            <xsl:choose>
                <xsl:when test="$interface-language = 'no'">
                    <xsl:call-template name="hjelp_no"/>
                </xsl:when>
                <xsl:when test="$interface-language = 'sv'">
                    <xsl:call-template name="hjelp_no"/>
                </xsl:when>
                <xsl:when test="$interface-language = 'da'">
                    <xsl:call-template name="hjelp_no"/>
                </xsl:when>
                <xsl:when test="$interface-language = 'en'">
                    <xsl:call-template name="hjelp_en"/>
                </xsl:when>
                <xsl:otherwise>

                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <!-- Sjekker om URL'en er portal/mer_om -->
        <xsl:if test=". = 'mer_om'">
            <!-- Sjekker på språk, og viser riktig språktemplate -->
            <xsl:choose>
                <xsl:when test="$interface-language = 'no'">
                    <xsl:call-template name="mer_om_no"/>
                </xsl:when>
<!--
                <xsl:when test="$interface-language = 'en'">
                    <xsl:call-template name="mer_om_en"/>
                </xsl:when>
-->
                <xsl:otherwise>

                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
