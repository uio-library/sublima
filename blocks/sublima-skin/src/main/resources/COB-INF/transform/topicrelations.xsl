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
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
	version="1.0">
  <xsl:import href="rdfxml2html-lang-dropdown.xsl"/>
  <xsl:import href="controlbutton.xsl"/>
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>
  <xsl:template match="c:related">
    <form action="{$baseurl}/admin/emner/relasjoner/relasjon" method="POST">
      <fieldset>
	<input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
	<input type="hidden" name="interface-language" value="{$interface-language}"/>
	<xsl:choose>
	  <xsl:when test="./c:tempvalues/c:tempvalues">
	    <xsl:choose>
	      <xsl:when test="./c:tempvalues/c:tempvalues/rdf:about">
		<input type="hidden" name="the-resource" value="{./c:tempvalues/c:tempvalues/rdf:about}"/>     
	      </xsl:when>
	      <xsl:otherwise>
		<input type="hidden" name="title-field" value="rdfs:label-1"/>
		<input type="hidden" name="subjecturi-prefix" value="topicrelations/"/>
	      </xsl:otherwise>
	    </xsl:choose>
	    <xsl:variable name="label" select="./c:tempvalues/c:tempvalues/rdfs:label"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:choose>
	      <xsl:when test="./c:tempvalues/c:tempvalues/rdf:about">
		<input type="hidden" name="the-resource" value="{./c:tempvalues/c:tempvalues/rdf:about}"/>     
	      </xsl:when>
        <xsl:when test="./c:relation/rdf:RDF/owl:ObjectProperty/@rdf:about">
		<input type="hidden" name="the-resource" value="{./c:relation/rdf:RDF/owl:ObjectProperty/@rdf:about}"/>
	      </xsl:when>
        <xsl:otherwise>
		<input type="hidden" name="title-field" value="rdfs:label-1"/>
		<input type="hidden" name="subjecturi-prefix" value="topicrelations/"/>
	      </xsl:otherwise>
	    </xsl:choose>
	    <xsl:variable name="label" select="./c:tempvalues/c:tempvalues/rdfs:label"/>
	  </xsl:otherwise>


	</xsl:choose>
	
	<h3>Relasjonstype</h3>
	<table>
	  <tr><th>Navn</th><th>Språk</th></tr>
      <xsl:for-each select="./c:relation/rdf:RDF/owl:ObjectProperty/rdfs:label">
        <tr>
        <td><input type="text" name="rdfs:label-{position()}" size="20" value="{.}" /></td>
        <td>
	        <select name="rdfs:label-{position()}">
            <xsl:apply-templates select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo" mode="list-options">
              <xsl:with-param name="default-language" select="./@xml:lang"/>
              <xsl:sort select="./rdfs:label[@xml:lang=$interface-language]"/>
            </xsl:apply-templates>
	        </select>
	    </td>
      </tr>
      </xsl:for-each>
    <tr>
      <td><input type="text" name="rdfs:label-{count(./c:relation/rdf:RDF/owl:ObjectProperty/rdfs:label)+1}" size="20" /></td>
	    <td>Antall: <xsl:value-of select="count(./c:relation/rdf:RDF/owl:ObjectProperty/rdfs:label)+1"/>                             
	      <select name="rdfs:label-{count(./c:relation/rdf:RDF/owl:ObjectProperty/rdfs:label)+1}">
		<xsl:apply-templates select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo" mode="list-options">
		  <xsl:with-param name="default-language" select="$interface-language"/>
		  <xsl:sort select="./rdfs:label[@xml:lang=$interface-language]"/>
		</xsl:apply-templates>
	      </select>
	    </td>
	  </tr>
	</table>
	<input type="hidden" name="rdfs:subPropertyOf" value="http://www.w3.org/2004/02/skos/core#semanticRelation"/>
	<input type="hidden" name="a" value="http://www.w3.org/2002/07/owl#ObjectProperty"/>
	
	<input type="submit" value="Lagre relasjonstype"/>

  <xsl:call-template name="controlbutton">
       <xsl:with-param name="privilege">relation.edit</xsl:with-param>
       <xsl:with-param name="buttontext">Lagre relasjonstype</xsl:with-param>
  </xsl:call-template>

  <input type="reset" value="Rens skjema"/>
	
      </fieldset>
      
    </form>

  </xsl:template>



</xsl:stylesheet>