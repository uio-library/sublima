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
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="c:page" mode="a-z">
    <!--
    <i18n:text key="az.heading">Alfabetisk navigering av emner</i18n:text><br/>
    -->
    <a href="{$baseurl}/emner/a{$qloc}">A</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/b{$qloc}">B</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/c{$qloc}">C</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/d{$qloc}">D</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/e{$qloc}">E</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/f{$qloc}">F</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/g{$qloc}">G</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/h{$qloc}">H</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/i{$qloc}">I</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/j{$qloc}">J</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/k{$qloc}">K</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/l{$qloc}">L</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/m{$qloc}">M</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/n{$qloc}">N</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/o{$qloc}">O</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/p{$qloc}">P</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/q{$qloc}">Q</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/r{$qloc}">R</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/s{$qloc}">S</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/t{$qloc}">T</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/u{$qloc}">U</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/v{$qloc}">V</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/w{$qloc}">W</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/x{$qloc}">X</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/y{$qloc}">Y</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/z{$qloc}">Z</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/æ{$qloc}">Æ</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/ø{$qloc}">Ø</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/å{$qloc}">Å</a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/0-9{$qloc}">0-9</a>
  </xsl:template>
</xsl:stylesheet>