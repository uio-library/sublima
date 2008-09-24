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
    <a href="{$baseurl}/emner/a{$qloc}"><i18n:text key="letter.a">A</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/b{$qloc}"><i18n:text key="letter.b">B</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/c{$qloc}"><i18n:text key="letter.c">C</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/d{$qloc}"><i18n:text key="letter.d">D</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/e{$qloc}"><i18n:text key="letter.e">E</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/f{$qloc}"><i18n:text key="letter.f">F</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/g{$qloc}"><i18n:text key="letter.g">G</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/h{$qloc}"><i18n:text key="letter.h">H</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/i{$qloc}"><i18n:text key="letter.i">I</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/j{$qloc}"><i18n:text key="letter.j">J</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/k{$qloc}"><i18n:text key="letter.k">K</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/l{$qloc}"><i18n:text key="letter.l">L</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/m{$qloc}"><i18n:text key="letter.m">M</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/n{$qloc}"><i18n:text key="letter.n">N</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/o{$qloc}"><i18n:text key="letter.o">O</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/p{$qloc}"><i18n:text key="letter.p">P</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/q{$qloc}"><i18n:text key="letter.q">Q</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/r{$qloc}"><i18n:text key="letter.r">R</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/s{$qloc}"><i18n:text key="letter.s">S</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/t{$qloc}"><i18n:text key="letter.t">T</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/u{$qloc}"><i18n:text key="letter.u">U</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/v{$qloc}"><i18n:text key="letter.v">V</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/w{$qloc}"><i18n:text key="letter.w">W</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/x{$qloc}"><i18n:text key="letter.x">X</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/y{$qloc}"><i18n:text key="letter.y">Y</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/z{$qloc}"><i18n:text key="letter.z">Z</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/æ{$qloc}"><i18n:text key="letter.æ">Æ</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/ø{$qloc}"><i18n:text key="letter.ø">Ø</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/å{$qloc}"><i18n:text key="letter.å">Å</i18n:text></a><xsl:text> </xsl:text>
    <a href="{$baseurl}/emner/0-9{$qloc}"><i18n:text key="letter.0-9">0-9</i18n:text></a>
  </xsl:template>
</xsl:stylesheet>