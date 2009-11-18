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
				xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        version="1.0">
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language"/>
		

  <xsl:template match="c:browse" mode="browse">
    <xsl:if test="./rdf:RDF//skos:Concept/rdfs:label[@xml:lang=$interface-language]|./rdf:RDF//skos:Concept/skos:prefLabel[@xml:lang=$interface-language]">
			<div id="browseHeader">
				<span id="browseHeaderText">
					<i18n:text key="{//c:heading}">Kategorier</i18n:text>
				</span>
			</div>
			
			<xsl:variable name="colCount" select="1"></xsl:variable>
			<div class="browseCol">
				<ul>
					<xsl:for-each select="./rdf:RDF//skos:Concept/rdfs:label[@xml:lang=$interface-language]|./rdf:RDF//skos:Concept/skos:prefLabel[@xml:lang=$interface-language]">
						<xsl:sort lang="{$interface-language}" select="."/>
						<xsl:variable name="nodeCount" select="last()"></xsl:variable>
						<xsl:variable name="col1" select="ceiling($nodeCount div 3)"></xsl:variable>
						
						<xsl:if test="number($col1) >= position()" >
							<li>
								<a href="{../@rdf:about}.html{$qloc}">
									<xsl:value-of select="."/>
								</a>
							</li>
						</xsl:if>
					</xsl:for-each>
				</ul>
			</div>
			<div class="browseCol">
				<ul>
					<xsl:for-each select="./rdf:RDF//skos:Concept/rdfs:label[@xml:lang=$interface-language]|./rdf:RDF//skos:Concept/skos:prefLabel[@xml:lang=$interface-language]">
						<xsl:sort lang="{$interface-language}" select="."/>
						<xsl:variable name="nodeCount" select="last()"></xsl:variable>
						<xsl:variable name="col1" select="ceiling($nodeCount div 3)"></xsl:variable>
						<xsl:variable name="col2" select="ceiling((($nodeCount - $col1) div 2) + $col1)"></xsl:variable>

						<xsl:if test="position() > number($col1) and number($col2) >= position()">
							<li>
								<a href="{../@rdf:about}.html{$qloc}">
									<xsl:value-of select="."/>
								</a>
							</li>
						</xsl:if>
					</xsl:for-each>
				</ul>
			</div>
			<div class="browseCol">
				<ul>
					<xsl:for-each select="./rdf:RDF//skos:Concept/rdfs:label[@xml:lang=$interface-language]|./rdf:RDF//skos:Concept/skos:prefLabel[@xml:lang=$interface-language]">
						<xsl:sort lang="{$interface-language}" select="."/>
						<xsl:variable name="nodeCount" select="last()"></xsl:variable>
						<xsl:variable name="col1" select="ceiling($nodeCount div 3)"></xsl:variable>
						<xsl:variable name="col2" select="ceiling((($nodeCount - $col1) div 2) + $col1)"></xsl:variable>
						<xsl:if test="position() > number($col2)">
							<li>
								<a href="{../@rdf:about}.html{$qloc}">
									<xsl:value-of select="."/>
								</a>
							</li>
						</xsl:if>
					</xsl:for-each>
				</ul>
			</div>
			<div class="clearer">&#160;</div>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>