<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:sub="http://xmlns.computas.com/sublima#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">

  <xsl:template name="head">
    <xsl:param name="title"/>
    <head>
      <title>
	<xsl:value-of select="$title"/>
	<xsl:text> | SMIL</xsl:text>
      </title>
   
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <link rel="stylesheet" type="text/css" href="styles/alt-css.css"/>
      <script type="text/javascript" src="styles/expand.js"></script>
      
    </head>
  </xsl:template>

</xsl:stylesheet>