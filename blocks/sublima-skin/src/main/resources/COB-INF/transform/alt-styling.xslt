<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        version="1.0">

    <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
    <xsl:import href="rdfxml-nav-templates.xsl"/>

    <xsl:template match="/">

        <html>
            <head>
                <title>Detektor</title>
                <!-- link rel="stylesheet" type="text/css" href="http://detektor.deichman.no/stylesheet.css"/> -->
                <!-- link rel="stylesheet" type="text/css" href="styles/alt-css.css"/ -->
<style type="text/css" media="screen">

                    /* General styles */
                    body {
                        margin:0;
                        padding:0;
                        border:0;			/* This removes the border around the viewport in old versions of IE */
                        width:100%;
                        background:#3F464F;
                        min-width:600px;    /* Minimum width of layout - remove line if not required */
                                            /* The min-width property does not work in old versions of Internet Explorer */
                        font-size:90%;
                    }
                    a {
                        color:#31363E;
						text-decoration:underline;
                    }
                    a:hover {
                        color:#3990C8;
                        text-decoration:underline;
                    }
                    h1, h2, h3 {
                        margin:.8em 0 .2em 0;
                        padding:0;
						color:#31363E;
                    }
                    p {
                        margin:.4em 0 .8em 0;
                        padding:0;
                    }
                    img {
                        margin:10px 0 5px;
                    }
                    /* Header styles */
                    #header {
                        clear:both;
                        float:left;
                        width:100%;
						background:#E0DCC5;

                    }
                    #header h1
                    {
                        padding:.4em 15px 0 15px;
                        margin:0;
						color:#0F1A80;
                    }
					#header h2 {
						padding:.4em 15px 0 15px;
                        margin:0;
						color:#47463F;
					}
                    #header ul {
                        clear:left;
                        float:left;
                        width:100%;
                        list-style:none;
                        margin:10px 0 0 0;
                        padding:0;
                    }
                    #header ul li {
                        display:inline;
                        list-style:none;
                        margin:0;
                        padding:0;
                    }
                    #header ul li a {
                        display:block;
                        float:left;
                        margin:0 0 0 1px;
                        padding:3px 10px;
                        text-align:center;
                        background:#eee;
                        color:#000;
                        text-decoration:none;
                        position:relative;
                        left:15px;
                        line-height:1.3em;
                    }
                    #header ul li a:hover {
                        background:#369;
                        color:#fff;
                    }
                    #header ul li a.active,
                    #header ul li a.active:hover {
                        color:#fff;
                        background:#65ADFF;
                        font-weight:bold;
                    }
                    #header ul li a span {
                        display:block;
                    }
                    /* 'widths' sub menu */
                    #layoutdims {
                        clear:both;
                        background:#fff;
                        border-top:4px solid #F3F1E9;
						border-bottom:4px solid #F3F1E9;
                        margin:0;
                        padding:6px 15px !important;
                        text-align:right;
                    }
                    /* column container */
                    .colmask {
                        position:relative;		/* This fixes the IE7 overflow hidden bug */
                        clear:both;
                        float:left;
                        width:100%;			/* width of whole page */
                        overflow:hidden;	/* This chops off any overhanging divs */
                    }
                    /* common column settings */
                    .colright,
                    .colmid,
                    .colleft {
                        float:left;
                        width:100%;				/* width of page */
                        position:relative;
                    }
                    .col1,
                    .col2,
                    .col3 {
                        float:left;
                        position:relative;
                        padding:0 0 1em 0;	/* no left and right padding on columns, we just make them narrower instead
                                                only padding top and bottom is included here, make it whatever value you need */
                        overflow:hidden;
                    }
                    /* 3 Column settings */
                    .threecol {
                        background:#E2F1E7;		/* right column background colour */
                    }
                    .threecol .colmid {
                        right:25%;				/* width of the right column */
                        background:#F3F1E9;		/* center column background colour */
                    }
                    .threecol .colleft {
                        right:50%;				/* width of the middle column */
                        background:#E2F1E7;		/* left column background colour */
                    }
                    .threecol .col1 {
                        width:46%;				/* width of center column content (column width minus padding on either side) */
                        left:102%;				/* 100% plus left padding of center column */
                    }
                    .threecol .col2 {
                        width:21%;				/* Width of left column content (column width minus padding on either side) */
                        left:31%;				/* width of (right column) plus (center column left and right padding) plus (left column left padding) */
                    }
                    .threecol .col3 {
                        width:21%;				/* Width of right column content (column width minus padding on either side) */
                        left:85%;				/* Please make note of the brackets here:
                                                (100% - left column width) plus (center column left and right padding) plus (left column left and right padding) plus (right column left padding) */
                    }
					.col2 h1 h2 .col3 h1 h2 {
						color:#F3F1E9;
						font-size:18px;
						font-weight:bold;
					}
                    /* Footer styles */
                    #footer {
                        clear:both;
                        float:left;
                        width:100%;
                        border-top:1px solid #A6A18D;
						color:#A6A18D;
                    }
                    #footer p {
                        padding:10px;
                        margin:0;
                    }
					#footer a {
						color:#A6A18D;
					}
                    #search {
                        background:#fff;
                    }
                    .searchbox {
                        border:1px solid #aaa;
                        height:30px;
                        width:400px;
                        padding: 3px;
                        font-size : 130%;
                    }
					#navigation {
						background:#eee;
                        border:2px solid #B61963;
                    }
					#results {
						background:#ddd;
					}
                </style>
            </head>
            <body>

                <div id="header">

                    <h1>Detektor</h1>

                    <h2>Demosite for portalverktøyet Sublima</h2>
                    <ul>
                        <li>
                            <a href="#" class="active">Aktiv
                                <span>Link</span>
                            </a>
                        </li>
                        <li>
                            <a href="#">Inaktiv
                                <span>Link</span>
                            </a>
                        </li>
                    </ul>

                    <p id="layoutdims">
                        Brødsmuler her? | <a href="#">Smule 1</a> | <a href="#">Smule 2</a> | <strong>Nåværende smule</strong>
                    </p>
                </div>
                <div class="colmask threecol">
                    <div class="colmid">
                        <div class="colleft">
                            <div class="col1">

                                <!-- Column 1 start -->
                                <!-- Kolonne 1 er hovedkolonne, og vil da inneholde søkefeltet, navigering og søkeresultatene -->
                               <div id="search">
                                   <form name="freetextSearch" action="freetext-result" method="get">
                                        <table>
                                            <tr>
                                                <td>
                                                    <input id="keyword" class="searchbox" type="text" name="searchstring" size="50" />
                                                </td>
                                                <td>
                                                    <input type="submit" value="Søk"/>
                                                </td>
                                                <td>
                                                    <a href="#">Avansert søk</a>
                                                </td>
                                            </tr>
                                        </table>
                                    </form>
                                  </div>
                                <div id="navigation">
                                    <h2>Navigering</h2>
                                    <xsl:apply-templates select="c:page/c:navigation/rdf:RDF/skos:Concept"/>        
                                </div>
                                <div id="results">
                                    <!-- Søkeresultatene -->
                                    <h2>Søkeresultater</h2>
                                    <xsl:apply-templates select="c:page/c:result-list/rdf:RDF"/>
                                </div>
                                <!-- Column 1 end -->
                            </div>

                            <div class="col2">
                                <!-- Column 2 start -->
                                
                                <h2>Filtrering</h2>
                                <xsl:value-of select="c:page/c:facets"/>

                                <!-- Column 2 end -->
                            </div>

                            <div class="col3">
                                <!-- Column 3 start -->

                                <h2>Min side osv.</h2>

                                <!-- Column 3 end -->
                            </div>
                        </div>

                    </div>
                </div>
                <div id="footer">
                    <p>
                        A Free Software Project supported by <a href="http://www.abm-utvikling.no/">ABM Utvikling</a> and <a href="http://www.computas.com">Computas AS</a>, 2008
                    </p>

                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>