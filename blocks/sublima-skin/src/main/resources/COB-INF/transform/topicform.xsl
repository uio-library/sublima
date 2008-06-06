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
  <xsl:import href="controlbutton.xsl"/>
  <xsl:import href="rdfxml2html-lang-dropdown.xsl"/>
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="c:topic">
    <xsl:param name="mode"/>

    <form action="{$baseurl}/admin/emner/emne" method="POST">
      <xsl:choose>
	<xsl:when test="./c:topicdetails/rdf:RDF/skos:Concept/@rdf:about">
	  <input type="hidden" name="the-resource" value="{./c:topicdetails/rdf:RDF/skos:Concept/@rdf:about}"/>
	</xsl:when>
	<xsl:otherwise>
	  <input type="hidden" name="title-field" value="skos:prefLabel-1"/>
	  <input type="hidden" name="subjecturi-prefix" value="topic/"/>
	</xsl:otherwise>
      </xsl:choose>
      <table>
	<caption>Emneord</caption>
	<tr>
	  <th scope="col">Type</th><th scope="col">Tekst</th><th scope="col">Språk</th>
	</tr>
	
	<xsl:for-each select="c:topicdetails/rdf:RDF/skos:Concept/skos:prefLabel">
	  <xsl:call-template name="topic-labels">
	    <xsl:with-param name="label">Tittel</xsl:with-param>
	    <xsl:with-param name="value" select="."/>
	    <xsl:with-param name="default-language" select="@xml:lang"/>
	    <xsl:with-param name="field"><xsl:text>skos:prefLabel-</xsl:text><xsl:value-of select="position()"/></xsl:with-param>
	  </xsl:call-template>
	</xsl:for-each>

	<xsl:call-template name="topic-labels">
	  <xsl:with-param name="label">Tittel</xsl:with-param>
	  <xsl:with-param name="default-language" select="$interface-language"/>
	  <xsl:with-param name="field"><xsl:text>skos:prefLabel-</xsl:text><xsl:value-of select="count(c:topicdetails/rdf:RDF/skos:Concept/skos:prefLabel)+1"/></xsl:with-param>
	</xsl:call-template>


	<xsl:for-each select="c:topicdetails/rdf:RDF/skos:Concept/skos:altLabel">
	  <xsl:call-template name="topic-labels">
	    <xsl:with-param name="label">Synonym</xsl:with-param>
	    <xsl:with-param name="value" select="."/>
	    <xsl:with-param name="default-language" select="@xml:lang"/>
	    <xsl:with-param name="field"><xsl:text>skos:altLabel-</xsl:text><xsl:value-of select="position()"/></xsl:with-param>
	  </xsl:call-template>
	</xsl:for-each>

	<xsl:call-template name="topic-labels">
	  <xsl:with-param name="label">Synonym</xsl:with-param>
	  <xsl:with-param name="default-language" select="$interface-language"/>
	  <xsl:with-param name="field"><xsl:text>skos:altLabel-</xsl:text><xsl:value-of select="count(c:topicdetails/rdf:RDF/skos:Concept/skos:altLabel)+1"/></xsl:with-param>
	</xsl:call-template>

	<xsl:for-each select="c:topicdetails/rdf:RDF/skos:Concept/skos:hiddenLabel">
	  <xsl:call-template name="topic-labels">
	    <xsl:with-param name="label">Skrivefeil</xsl:with-param>
	    <xsl:with-param name="value" select="."/>
	    <xsl:with-param name="default-language" select="@xml:lang"/>
	    <xsl:with-param name="field"><xsl:text>skos:hiddenLabel-</xsl:text><xsl:value-of select="position()"/></xsl:with-param>
	  </xsl:call-template>
	</xsl:for-each>

	<xsl:call-template name="topic-labels">
	  <xsl:with-param name="label">Skrivefeil</xsl:with-param>
	  <xsl:with-param name="default-language" select="$interface-language"/>
	  <xsl:with-param name="field"><xsl:text>skos:hiddenLabel-</xsl:text><xsl:value-of select="count(c:topicdetails/rdf:RDF/skos:Concept/skos:hiddenLabel)+1"/></xsl:with-param>
	</xsl:call-template>


        <tr>
          <td>
            <label for="skos:definition">Beskrivelse</label>
          </td>
          <td>
            <textarea id="skos:definition" name="skos:definition"
                      rows="6" cols="40"><xsl:value-of
                    select="./c:topicdetails/rdf:RDF/skos:Concept/skos:definition"/>...
            </textarea>
          </td>
        </tr>


      </table>
      <p>Relaterte emner</p>
      <table>

        <xsl:for-each select="skos:semanticRelation">
          <xsl:sort select="./rdfs:label"/>
          <tr>
            <td>
              <label for="skos:semanticRelation/rdf:resource">Relasjon</label>
            </td>
            <td>
              <select id="skos:semanticRelation/rdf:resource"
                      name="skos:semanticRelation/rdf:resource">
                <xsl:for-each select="/c:page/c:content/c:topic/c:relationtypes/rdf:RDF/skos:semanticRelation">
                  <xsl:sort select="./rdfs:label"/>
                  <xsl:choose>
                    <xsl:when
                            test="./@rdf:about = /c:page/c:content/c:topic/c:topicdetails/rdf:RDF/skos:Concept/skos:semanticRelation/@rdf:resource">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./rdfs:label"/>
                      </option>
                    </xsl:when>
                    <xsl:otherwise>
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./rdfs:label"/>
                      </option>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </select>

              <select id="skos:semanticRelation/rdf:resource"
                      name="skos:semanticRelation/rdf:resource" multiple="multiple">
                <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept">
                  <xsl:sort select="./skos:prefLabel"/>
                  <xsl:choose>
                    <xsl:when
                            test="./@rdf:about = /c:page/c:content/c:topic/c:topicdetails/rdf:RDF/skos:Concept/skos:semanticRelation/@rdf:resource">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./skos:prefLabel"/>
                      </option>
                    </xsl:when>
                    <xsl:otherwise>
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./skos:prefLabel"/>
                      </option>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </select>
            </td>
          </tr>
        </xsl:for-each>


        <tr>
          <td>
          </td>
          <td>
            <select id="skos:semanticRelation/rdf:resource"
                    name="skos:semanticRelation/rdf:resource">
              <xsl:for-each select="/c:page/c:content/c:topic/c:relationtypes/rdf:RDF/skos:semanticRelation">
                <xsl:sort select="./rdfs:label"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:topic/c:topicdetails/rdf:RDF/skos:Concept/skos:semanticRelation/@rdf:resource">
                    <option value="{./@rdf:about}" selected="selected">
                      <xsl:value-of select="./rdfs:label"/>
                    </option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="{./@rdf:about}">
                      <xsl:value-of select="./rdfs:label"/>
                    </option>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>

            <select id="skos:semanticRelation/rdf:resource"
                    name="skos:semanticRelation/rdf:resource" multiple="multiple">
              <xsl:for-each select="./c:alltopics/rdf:RDF/skos:Concept">
                <xsl:sort select="./skos:prefLabel"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:topic/c:topicdetails/rdf:RDF/skos:Concept/skos:semanticRelation/@rdf:resource">
                    <option value="{./@rdf:about}" selected="selected">
                      <xsl:value-of select="./skos:prefLabel"/>
                    </option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="{./@rdf:about}">
                      <xsl:value-of select="./skos:prefLabel"/>
                    </option>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>

        <tr>
          <td>
            <label for="wdr:describedBy">Status</label>
          </td>
          <td>
            <select id="wdr:describedBy" name="wdr:describedBy">
              <option value=""/>
              <xsl:for-each select="./c:statuses/rdf:RDF/wdr:DR">
                <xsl:sort select="./rdfs:label"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:topic/c:topicdetails/rdf:RDF/skos:Concept/wdr:describedBy/@rdf:resource">
                    <option value="{./@rdf:about}" selected="selected">
                      <xsl:value-of select="./rdfs:label"/>
                    </option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="{./@rdf:about}">
                      <xsl:value-of select="./rdfs:label"/>
                    </option>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>

        <tr>
          <td>
            <label for="skos:note">Kommentar</label>
          </td>
          <td>
            <textarea id="skos:note" name="skos:note" rows="6"
                      cols="40"><xsl:value-of
                    select="./c:topicdetails/rdf:RDF/skos:Concept/skos:note"/>...
            </textarea>
          </td>
        </tr>


        <tr>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
	    <xsl:call-template name="controlbutton">
	      <xsl:with-param name="privilege">topic.edit</xsl:with-param>
	      <xsl:with-param name="buttontext">Lagre emne</xsl:with-param>
	    </xsl:call-template>
          </td>
          <td>
            <input type="reset" value="Rens skjema"/>
          </td>
        </tr>
      </table>
    </form>

  </xsl:template>

  <xsl:template name="topic-labels">
    <xsl:param name="field"/>
    <xsl:param name="label"/>
    <xsl:param name="value"/>
    <xsl:param name="default-language"/>
    <tr>
      <th scope="row">
	<label for="{$field}"><xsl:value-of select="$label"/></label>
      </th>
      <td>
	<input id="{$field}" type="text"
	       name="{$field}" size="20"
	       value="{$value}"/>
      </td>
      <td>
	<select name="{$field}">
	  <xsl:apply-templates select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo" mode="list-options">
	    <xsl:with-param name="default-language" select="$default-language"/>
	    <xsl:sort select="./rdfs:label[@xml:lang=$interface-language]"/>
	  </xsl:apply-templates>
	</select>
      </td>

    </tr>
  </xsl:template>
</xsl:stylesheet>