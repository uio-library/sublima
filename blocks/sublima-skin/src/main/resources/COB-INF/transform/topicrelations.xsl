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
  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:param name="baseurl"/>
    <xsl:param name="interface-language">no</xsl:param>

    <xsl:template match="c:related">
      <form action="{$baseurl}/admin/emner/relasjoner/relasjon" method="POST">
      <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
      <input type="hidden" name="interface-language" value="{$interface-language}"/>
	<xsl:choose>
	  <xsl:when test="./c:tempvalues/c:tempvalues">
	    <xsl:choose>
	      <xsl:when test="./c:tempvalues/c:tempvalues/rdf:about">
		<input type="hidden" name="the-resource" value="{./c:tempvalues/c:tempvalues/rdf:about}"/>     
	      </xsl:when>
	      <xsl:otherwise>
		<input type="hidden" name="title-field" value="rdfs:label"/>
		<input type="hidden" name="subjecturi-prefix" value="{$baseurl}/topicrelations/"/>
	      </xsl:otherwise>
	    </xsl:choose>
	    <xsl:variable name="label" select="./c:tempvalues/c:tempvalues/rdfs:label"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:choose>
	      <xsl:when test="./c:tempvalues/c:tempvalues/rdf:about">
		<input type="hidden" name="the-resource" value="{./c:tempvalues/c:tempvalues/rdf:about}"/>     
	      </xsl:when>
	      <xsl:otherwise>
		<input type="hidden" name="title-field" value="rdfs:label"/>
		<input type="hidden" name="subjecturi-prefix" value="{$baseurl}/topicrelations/"/>
	      </xsl:otherwise>
	    </xsl:choose>
	    <xsl:variable name="label" select="./c:tempvalues/c:tempvalues/rdfs:label"/>
	  </xsl:otherwise>


	</xsl:choose>
            <table>
                <tr>
                    <td>
                        <label for="skos:semanticRelation/rdfs:label">Relasjonstype</label>
                    </td>
                    <td>
                      <input id="skos:semanticRelation/rdfs:label" type="text" name="rdfs:label" size="40" value="{./c:tempvalues/c:tempvalues/rdfs:label}" /></td>
                </tr>

                <tr>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <input type="submit" value="Lagre relasjonstype"/>
                    </td>
                    <td>
                        <input type="reset" value="Rens skjema"/>
                    </td>
                </tr>
            </table>
        </form>

    </xsl:template>
</xsl:stylesheet>