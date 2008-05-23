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

  <xsl:template match="c:a-z" mode="a-z">
    Alfabetisk navigering av emner<br/>
    <a href="{$baseurl}/emner/a">A</a><br/>
    <a href="{$baseurl}/emner/b">B</a><br/>
    <a href="{$baseurl}/emner/c">C</a><br/>
    <a href="{$baseurl}/emner/d">D</a><br/>
    <a href="{$baseurl}/emner/e">E</a><br/>
    <a href="{$baseurl}/emner/f">F</a><br/>
    <a href="{$baseurl}/emner/g">G</a><br/>
    <a href="{$baseurl}/emner/h">H</a><br/>
    <a href="{$baseurl}/emner/i">I</a><br/>
    <a href="{$baseurl}/emner/j">J</a><br/>
    <a href="{$baseurl}/emner/k">K</a><br/>
    <a href="{$baseurl}/emner/l">L</a><br/>
    <a href="{$baseurl}/emner/m">M</a><br/>
    <a href="{$baseurl}/emner/n">N</a><br/>
    <a href="{$baseurl}/emner/o">O</a><br/>
    <a href="{$baseurl}/emner/p">P</a><br/>
    <a href="{$baseurl}/emner/q">Q</a><br/>
    <a href="{$baseurl}/emner/r">R</a><br/>
    <a href="{$baseurl}/emner/s">S</a><br/>
    <a href="{$baseurl}/emner/t">T</a><br/>
    <a href="{$baseurl}/emner/u">U</a><br/>
    <a href="{$baseurl}/emner/v">V</a><br/>
    <a href="{$baseurl}/emner/w">W</a><br/>
    <a href="{$baseurl}/emner/x">X</a><br/>
    <a href="{$baseurl}/emner/y">Y</a><br/>
    <a href="{$baseurl}/emner/z">Z</a><br/>
    <a href="{$baseurl}/emner/æ">Æ</a><br/>
    <a href="{$baseurl}/emner/ø">Ø</a><br/>
    <a href="{$baseurl}/emner/å">Å</a><br/>
    <a href="{$baseurl}/emner/0-9">0-9</a><br/>
  </xsl:template>
</xsl:stylesheet>