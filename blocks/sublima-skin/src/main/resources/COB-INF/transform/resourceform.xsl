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
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">

  <xsl:import href="controlbutton.xsl"/>
  <xsl:import href="labels.xsl"/>

  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>
  <xsl:template match="c:resourcedetails" mode="resourceedit">

    <form action="{$baseurl}/admin/ressurser/ny" method="POST">
      <input type="hidden" name="prefix" value="skos: &lt;http://www.w3.org/2004/02/skos/core#&gt;"/>
      <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
      <input type="hidden" name="prefix" value="wdr: &lt;http://www.w3.org/2007/05/powder#&gt;"/>
      <input type="hidden" name="prefix" value="lingvoj: &lt;http://www.lingvoj.org/ontology#&gt;"/>
      <input type="hidden" name="prefix" value="dct: &lt;http://purl.org/dc/terms/&gt;"/>
      <input type="hidden" name="prefix" value="rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;"/>
      <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
      <input type="hidden" name="rdf:type" value="http://xmlns.computas.com/sublima#Resource"/>
      <input type="hidden" id="dct:identifier" name="dct:identifier" value="{./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource}"/>
      <input type="hidden" name="interface-language" value="{$interface-language}"/>
      
      <!--input type="hidden" name="a" value="http://xmlns.computas.com/sublima#Resource"/ -->
      <!-- input type="hidden" name="uri" value="{./c:resource/rdf:RDF/sub:Resource/@rdf:about}"/ -->
      <!-- input type="hidden" name="dct:identifier"
             value="{./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource}"/ -->

      <table>
        <tr>
        <td>
            <label for="dct:title"><i18n:text key="title">Tittel</i18n:text></label>
          </td>
          <td>
            <input id="dct:title" type="text" name="dct:title" size="40"
                   value="{./c:resource/rdf:RDF/sub:Resource/dct:title}"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="the-resource"><i18n:text key="url">URL</i18n:text></label>
          </td>
          <td>
            <input id="the-resource" type="text" name="the-resource" size="40"
                   value="{./c:resource/rdf:RDF/sub:Resource/sub:url/@rdf:resource}"/>
          </td>
        </tr>
      <tr>
        <td>
          <label for="dct:description"><i18n:text key="description">Beskrivelse</i18n:text></label>
        </td>
        <td>
          <textarea id="dct:description" name="dct:description" rows="6" cols="40"><xsl:value-of select="./c:resource/rdf:RDF/sub:Resource/dct:description"/><xsl:text> </xsl:text></textarea>
        </td>
        </tr>
        <tr>
          <td>
            <label for="dct:publisher/foaf:Agent/@rdf:about"><i18n:text key="publisher">Utgiver</i18n:text></label>
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
          <td>
            <label for="dct:language"><i18n:text key="language">Språk</i18n:text></label>
          </td>
          <td>
            <select id="dct:language" name="dct:language" multiple="multiple" size="10">
              <xsl:for-each select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo">
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
            <label for="dct:format"><i18n:text key="mediatype">Mediatype</i18n:text></label>
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
            <label for="dct:audience"><i18n:text key="audience">Målgruppe</i18n:text></label>
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
            <label for="dct:subject"><i18n:text key="topics">Emner</i18n:text></label>
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
            <label for="rdfs:comment"><i18n:text key="comment">Kommentar</i18n:text></label>
          </td>
          <td>
            <textarea id="rdfs:comment" name="rdfs:comment" rows="6" cols="40"><xsl:value-of select="./c:resource/rdf:RDF/sub:Resource/rdfs:comment"/><xsl:text> </xsl:text></textarea>
          </td>
        </tr>
        <tr>
          <td>
            <label for="wdr:describedBy"><i18n:text key="status">Status</i18n:text></label>
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
          <td><i18n:text key="resource.usercomments">Brukernes kommentarer</i18n:text></td>
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
          <td><i18n:text key="resourceasnew">Marker som ny</i18n:text></td>
          <td>
            <input type="checkbox" name="markasnew"/>
          </td>
        </tr>
        <tr>
          <td>

            <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">resource.edit</xsl:with-param>
              <xsl:with-param name="buttontext">button.saveresource</xsl:with-param>
            </xsl:call-template>

            <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">resource.delete</xsl:with-param>
              <xsl:with-param name="buttontext">button.deleteresource</xsl:with-param>
              <xsl:with-param name="buttonname">actionbuttondelete</xsl:with-param>
            </xsl:call-template>

            <script type="text/javascript">
              function copyAsNew() {
                document.getElementById("the-resource").value = '';
                document.getElementById("dct:identifier").value = '';
              }
            </script>

            <input type="button" value="button.copyasnew" i18n:attr="value" onclick="copyAsNew()"/>
            
          </td>
          <td>

          </td>
        </tr>
      </table>
    </form>
  </xsl:template>


  <!--xsl:template match="c:resourcedetails" mode="temp">

    <form action="{$baseurl}/admin/ressurser/ny" method="POST">

      <input type="hidden" name="a" value="http://xmlns.computas.com/sublima#Resource"/>
      <input type="hidden" name="dct:identifier"
             value="{./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource}"/>
      <table>
        <tr>
          <td>
            <label for="dct:title"><i18n:text key="resource.title"/></label>
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

          </td>
        </tr>
      </table>
    </form>
  </xsl:template-->

</xsl:stylesheet>