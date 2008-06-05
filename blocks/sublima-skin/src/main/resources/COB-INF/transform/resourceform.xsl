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
  <xsl:template match="c:resourcedetails" mode="edit">

    <form action="{$baseurl}/admin/ressurser/ny" method="POST">

      <input type="hidden" name="a" value="http://xmlns.computas.com/sublima#Resource"/>
      <input type="hidden" name="dct:identifier"
             value="{./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource}"/>
      <table>
        <tr>
          <td>
            <label for="dct:title">Tittel</label>
          </td>
          <td>
            <input id="dct:title" type="text" name="dct:title" size="40"
                   value="{./c:resource/rdf:RDF/sub:Resource/dct:title}"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="sub:url">URI</label>
          </td>
          <td>
            <input id="sub:url" type="text" name="sub:url" size="40"
                   value="{./c:resource/rdf:RDF/sub:Resource/sub:url/@rdf:resource}"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="dct:description">Beskrivelse</label>
          </td>
          <td>
            <textarea id="dct:description" name="dct:description" rows="6" cols="40"><xsl:value-of
                    select="./c:resource/rdf:RDF/sub:Resource/dct:description"/>...
            </textarea>
          </td>
        </tr>
      </table>
      <br/>
      <p>Velg utgiver fra nedtrekkslisten, eller la den stå tom og skriv inn navnet på den nye utgiveren i
        tekstfeltet
        under
      </p>
      <table>
        <tr>
          <td>
            <label for="dct:publisher/foaf:Agent/@rdf:about">Utgiver</label>
          </td>
          <td>
            <select id="dct:publisher" name="dct:publisher">
              <option value=""/>
              <xsl:for-each select="./c:publishers/rdf:RDF/foaf:Agent">
                <xsl:sort select="./foaf:name"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:publisher/@rdf:resource">
                    <option value="{./@rdf:about}" selected="selected">
                      <xsl:value-of select="./foaf:name"/>
                    </option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="{./@rdf:about}">
                      <xsl:value-of select="./foaf:name"/>
                    </option>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <input id="dct:publisher/foaf:Agent/foaf:name" type="text"
                   name="dct:publisher/foaf:Agent/foaf:name" size="40"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="dct:language">Språk</label>
          </td>
          <td>
            <select id="dct:language" name="dct:language" multiple="multiple" size="10">
              <xsl:for-each select="./c:languages/rdf:RDF/lingvoj:Lingvo">
                <xsl:sort select="./rdfs:label"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:language/@rdf:resource">
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
            <label for="dct:format">Mediatype</label>
          </td>
          <td>
            <select id="dct:format" name="dct:format" multiple="multiple" size="10">
              <xsl:for-each
                      select="./c:mediatypes/rdf:RDF/dct:MediaType">
                <xsl:sort select="./rdfs:label"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:format/@rdf:resource">
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
            <label for="dct:audience">Målgruppe</label>
          </td>
          <td>
            <select id="dct:audience" name="dct:audience" multiple="multiple" size="10">
              <xsl:for-each
                      select="./c:audiences/rdf:RDF/dct:AgentClass">
                <xsl:sort select="./rdfs:label"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:audience/@rdf:resource">
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
            <label for="dct:subject">Emner</label>
          </td>
          <td>
            <select id="dct:subject" name="dct:subject" multiple="multiple" size="10">
              <xsl:for-each select="./c:topics/rdf:RDF/skos:Concept">
                <xsl:sort select="./skos:prefLabel"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:subject/@rdf:resource">
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
            <label for="rdfs:comment">Kommentar</label>
          </td>
          <td>
            <textarea id="rdfs:comment" name="rdfs:comment" rows="6" cols="40">...
              <xsl:value-of
                      select="./c:resource/rdf:RDF/sub:Resource/rdfs:comment"/>
            </textarea>
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
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/wdr:describedBy/@rdf:resource">
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

          </td>
        </tr>
        <tr>
          <td>Brukernes kommentarer</td>
          <td>
            <ul>
              <xsl:for-each select="./c:resource/rdf:RDF/sub:Resource/sub:comment">
                <li>
                  <xsl:value-of select="."/>
                </li>
              </xsl:for-each>
            </ul>
          </td>
        </tr>
        <tr>
          <td>

            <xsl:choose>
              <xsl:when test="/c:page/c:userprivileges/c:privileges/c:privilege = 'topic.edit'">
                <input type="submit" value="Lagre ressurs" name="actionbutton"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" value="Lagre ressurs" name="actionbutton" disabled="true"/>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
              <xsl:when test="/c:page/c:userprivileges/c:privileges/c:privilege = 'topic.delete'">
                <input type="submit" value="Slett ressurs" name="actionbutton"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" value="Slett ressurs" name="actionbutton" disabled="true"/>
              </xsl:otherwise>
            </xsl:choose>
            
          </td>
          <td>
            <input type="reset" value="Rens skjema"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>


  <xsl:template match="c:resourcedetails" mode="temp">

    <form action="{$baseurl}/admin/ressurser/ny" method="POST">

      <input type="hidden" name="a" value="http://xmlns.computas.com/sublima#Resource"/>
      <input type="hidden" name="dct:identifier"
             value="{./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource}"/>
      <table>
        <tr>
          <td>
            <label for="dct:title">Tittel</label>
          </td>
          <td>
            <input id="dct:title" type="text" name="dct:title" size="40"
                   value="{./c:tempvalues/c:tempvalues/dct:title}"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="sub:url">URI</label>
          </td>
          <td>
            <input id="sub:url" type="text" name="sub:url" size="40" value="{./c:tempvalues/c:tempvalues/sub:url}"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="dct:description">Beskrivelse</label>
          </td>
          <td>
            <textarea id="dct:description" name="dct:description" rows="6" cols="40"><xsl:value-of
                    select="./c:tempvalues/c:tempvalues/dct:description"/>...
            </textarea>
          </td>
        </tr>
      </table>
      <br/>
      <p>Velg utgiver fra nedtrekkslisten, eller la den stå tom og skriv inn navnet på den nye utgiveren i
        tekstfeltet
        under
      </p>
      <table>
        <tr>
          <td>
            <label for="dct:publisher/foaf:Agent/@rdf:about">Utgiver</label>
          </td>
          <td>
            <select id="dct:publisher" name="dct:publisher">
              <option value=""/>
              <xsl:for-each select="./c:publishers/rdf:RDF/foaf:Agent">
                <xsl:sort select="./foaf:name"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/dct:publisher">
                    <option value="{./@rdf:about}" selected="selected">
                      <xsl:value-of select="./foaf:name"/>
                    </option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="{./@rdf:about}">
                      <xsl:value-of select="./foaf:name"/>
                    </option>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <input id="dct:publisher/foaf:Agent/foaf:name" type="text"
                   name="dct:publisher/foaf:Agent/foaf:name" size="40"
                   value="{./c:tempvalues/c:tempvalues/foaf:Agent}"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="dct:language">Språk</label>
          </td>
          <td>
            <select id="dct:language" name="dct:language" multiple="multiple" size="10">
              <xsl:for-each select="./c:languages/rdf:RDF/lingvoj:Lingvo">
                <xsl:sort select="./rdfs:label"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/dct:language/@rdf:description">
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
            <label for="dct:format">Mediatype</label>
          </td>
          <td>
            <select id="dct:format" name="dct:format" multiple="multiple" size="10">
              <xsl:for-each
                      select="./c:mediatypes/rdf:RDF/dct:MediaType">
                <xsl:sort select="./rdfs:label"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/dct:format/@rdf:description">
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
            <label for="dct:audience">Målgruppe</label>
          </td>
          <td>
            <select id="dct:audience" name="dct:audience" multiple="multiple" size="10">
              <xsl:for-each
                      select="./c:audiences/rdf:RDF/dct:AgentClass">
                <xsl:sort select="./rdfs:label"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/dct:audience/@rdf:description">
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
            <label for="dct:subject">Emner</label>
          </td>
          <td>
            <select id="dct:subject" name="dct:subject" multiple="multiple" size="10">
              <xsl:for-each select="./c:topics/rdf:RDF/skos:Concept">
                <xsl:sort select="./skos:prefLabel"/>
                <xsl:choose>
                  <xsl:when
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/dct:subject/@rdf:description">
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
            <label for="rdfs:comment">Kommentar</label>
          </td>
          <td>
            <textarea id="rdfs:comment" name="rdfs:comment" rows="6" cols="40"><xsl:value-of
                    select="./c:tempvalues/c:tempvalues/rdfs:comment"/>...
            </textarea>
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
                          test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:tempvalues/c:tempvalues/wdr:describedBy">
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
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            <input type="submit" value="Lagre ressurs"/>
          </td>
          <td>
            <input type="reset" value="Rens skjema"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>

</xsl:stylesheet>