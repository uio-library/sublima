<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:sub="http://xmlns.computas.com/sublima#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
    <!-- xsl:output method="html" indent="yes"/ -->

    <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
    <xsl:import href="rdfxml2xhtml-facets.xsl"/>
    <xsl:import href="rdfxml2xhtml-table.xsl"/>
    <xsl:import href="rdfxml-nav-templates.xsl"/>

    <xsl:param name="baseurl"/>

    <xsl:template name="title">
        <xsl:copy-of select="c:page/c:title/*"/>
    </xsl:template>

    <xsl:template name="breadcrumbs">


    </xsl:template>

    <xsl:template name="menu">
        <!-- xsl:copy-of select="c:page/c:menu/*"/ -->
        <xsl:for-each select="c:page/c:menu/c:menuelement">
            <xsl:value-of select="c:page/c:menu/c:menuelement"/>
            <xsl:text>menuelement</xsl:text>
            <xsl:value-of select="c:page/c:menu/c:menuelement/@title"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="content">
        <xsl:copy-of select="c:page/c:content/*"/>
    </xsl:template>

    <xsl:template match="/">

        <html>
            <head>
                <title>
                    <xsl:call-template name="title"/>
                    <!-- xsl:value-of select="c:page/c:title/*"/ -->
                    - Detektor
                </title>
                <!-- link rel="stylesheet" type="text/css" href="http://detektor.deichman.no/stylesheet.css"/> -->
                <link rel="stylesheet" type="text/css" href="styles/alt-css.css"/>
            </head>
            <body>

                <div id="header">
                    <img alt="header logo" src="{$baseurl}/images/detektor_beta_header.png"/>

                    <h2>Demosite for portalverktøyet Sublima</h2>
                    <ul>
                        <li>
                            <a href="{$baseurl}/home">Hjem</a>
                        </li>
                        <li>
                            <a href="{$baseurl}/advancedsearch">Avansert søk
                            </a>
                        </li>
                        <li>
                            <a href="{$baseurl}/admin" class="active">Administrasjon
                            </a>
                        </li>
                    </ul>

                    <p id="layoutdims">
                    <!-- xsl:call-template name="breadcrumbs"/ -->
                    <!-- xsl:value-of select="c:page/c:breadcrumbs/*"/ -->
                    <xsl:for-each select="c:page/c:breadcrumbs/c:breadcrumb">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$baseurl"/>/<xsl:value-of select="."/>
                                        </xsl:attribute>
                                        <xsl:value-of select="@title"/>
                                    </a><xsl:text> | </xsl:text>
                                </xsl:for-each>

                    </p>
                </div>
                <div class="colmask threecol">
                    <div class="colmid">
                        <div class="colleft">
                            <div class="col1">
                                <!-- Column 1 start -->
                                <xsl:call-template name="content"/>
                                <!-- xsl:value-of select="c:page/c:content/*"/ -->
                                <!-- Column 1 end -->
                            </div>
                            <div class="col2">
                                <!-- Column 2 start -->
                                <!-- xsl:call-template name="menu"/ -->
                                <!-- xsl:value-of select="c:page/c:menu/*"/ -->
                                <xsl:for-each select="c:page/c:menu/c:menuelement">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$baseurl"/>/<xsl:value-of select="."/>
                                        </xsl:attribute>
                                        <xsl:value-of select="@title"/>
                                    </a> <br/>
                                </xsl:for-each>
                                <!-- Column 2 end -->
                            </div>
                            <div class="col3">
                                <!-- Column 3 start -->
                                <!-- Column 3 end -->
                            </div>
                        </div>

                    </div>
                </div>
                <div id="footer">
                    <p>A Free Software Project supported by
                        <a href="http://www.abm-utvikling.no/">ABM Utvikling</a>
                        and
                        <a href="http://www.computas.com">Computas AS</a>
                        , 2008
                    </p>
                </div>
            </body>
        </html>

    </xsl:template>

</xsl:stylesheet>