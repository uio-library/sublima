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
        xmlns:sioc="http://rdfs.org/sioc/ns#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">

  <xsl:import href="controlbutton.xsl"/>
  <xsl:import href="labels.xsl"/>
  <xsl:import href="selectmultiple.xsl"/>

  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>
  <xsl:template match="c:resourcedetails" mode="resourceedit">

    <xsl:call-template name="selectmultiple">
      <xsl:with-param name="selectionid">#subject</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="selectmultiple">
      <xsl:with-param name="selectionid">#language</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="selectmultiple">
      <xsl:with-param name="selectionid">#format</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="selectmultiple">
      <xsl:with-param name="selectionid">#audience</xsl:with-param>
    </xsl:call-template>


    <form action="{$baseurl}/admin/ressurser/ny" method="POST">
      <input type="hidden" name="prefix" value="skos: &lt;http://www.w3.org/2004/02/skos/core#&gt;"/>
      <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
      <input type="hidden" name="prefix" value="wdr: &lt;http://www.w3.org/2007/05/powder#&gt;"/>
      <input type="hidden" name="prefix" value="lingvoj: &lt;http://www.lingvoj.org/ontology#&gt;"/>
      <input type="hidden" name="prefix" value="dct: &lt;http://purl.org/dc/terms/&gt;"/>
      <input type="hidden" name="prefix" value="rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;"/>
      <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
      <input type="hidden" name="rdf:type" value="http://xmlns.computas.com/sublima#Resource"/>
      <input type="hidden" name="dct:dateAccepted" value="{./c:resource/rdf:RDF/sub:Resource/dct:dateAccepted}"/>
      <input type="hidden" id="dct:identifier" name="dct:identifier"
             value="{./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource}"/>
      <input type="hidden" name="interface-language" value="{$interface-language}"/>
      <xsl:call-template name="hidden-locale-field"/>

      <table>
        <tr>
          <td>
            <label for="dct:title">
              <i18n:text key="title">Tittel</i18n:text>
            </label>
          </td>
          <td>
            <input id="dct:title" type="text" name="dct:title" size="40"
                   value="{./c:resource/rdf:RDF/sub:Resource/dct:title}"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="the-resource">
              <i18n:text key="url">URL</i18n:text>
            </label>
          </td>
          <td>
            <input id="the-resource" type="text" name="the-resource" size="40"
                   value="{./c:resource/rdf:RDF/sub:Resource/sub:url/@rdf:resource}"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="dct:description">
              <i18n:text key="description">Beskrivelse</i18n:text>
            </label>
          </td>
          <td>
            <textarea id="dct:description" name="dct:description" rows="6" cols="40">
              <xsl:value-of select="./c:resource/rdf:RDF/sub:Resource/dct:description"/>
              <xsl:text> </xsl:text>
            </textarea>
          </td>
        </tr>
        <tr>
          <td>
            <label for="dct:publisher/foaf:Agent/@rdf:about">
              <i18n:text key="publisher">Utgiver</i18n:text>
            </label>
          </td>
          <td>
            <select id="dct:publisher" name="dct:publisher">
              <option value=""/>
              <xsl:for-each select="./c:publishers/rdf:RDF/foaf:Agent">
                <xsl:sort lang="{$interface-language}" select="./foaf:name"/>
                <xsl:choose>
                  <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:publisher/@rdf:resource">
                    <xsl:if test="./foaf:name">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./foaf:name"/>
                      </option>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="./foaf:name">
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./foaf:name"/>
                      </option>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td>
            <label for="language">
              <i18n:text key="language">Språk</i18n:text>
            </label>
          </td>
          <td>
            <select id="language" name="dct:language" multiple="multiple" size="10">
              <xsl:for-each select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo">
                <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                <xsl:choose>
                  <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:language/@rdf:resource">
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td>
            <label for="format">
              <i18n:text key="mediatype">Mediatype</i18n:text>
            </label>
          </td>
          <td>
            <select id="format" name="dct:format" multiple="multiple" size="10">
              <xsl:for-each
                      select="./c:mediatypes/rdf:RDF/dct:MediaType">
                <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                <xsl:choose>
                  <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:format/@rdf:resource">
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td>
            <label for="audience">
              <i18n:text key="audience">Målgruppe</i18n:text>
            </label>
          </td>
          <td>
            <select id="audience" name="dct:audience" multiple="multiple" size="10">
              <xsl:for-each
                      select="./c:audiences/rdf:RDF/dct:AgentClass">
                <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                <xsl:choose>
                  <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:audience/@rdf:resource">
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <xsl:if test="./c:resource/rdf:RDF/sub:Resource/sub:keywords">
          <tr>
            <td>
              <label for="sub:keywords">
                <i18n:text key="tips.suggestedtopics">Emner</i18n:text>
              </label>
            </td>
            <td>
              <input id="sub:keywords" type="text" name="sub:keywords" size="40"
                   value="{./c:resource/rdf:RDF/sub:Resource/sub:keywords}" disabled="disabled"/>  
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td>
            <label for="subject">
              <i18n:text key="topics">Emner</i18n:text>
            </label>
          </td>
          <td>
            <select id="subject" name="dct:subject" multiple="multiple" size="10">
              <xsl:for-each select="./c:topics/rdf:RDF/skos:Concept">
                <xsl:sort lang="{$interface-language}" select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                <xsl:choose>
                  <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:subject/@rdf:resource">
                    <xsl:if test="./skos:prefLabel[@xml:lang=$interface-language]">
                      <xsl:if test="./wdr:describedBy/@rdf:resource = 'http://sublima.computas.com/status/godkjent_av_administrator'">
                        <option value="{./@rdf:about}" selected="selected">
                          <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                        </option>
                      </xsl:if>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="./skos:prefLabel[@xml:lang=$interface-language]">
                      <xsl:if test="./wdr:describedBy/@rdf:resource = 'http://sublima.computas.com/status/godkjent_av_administrator'">
                        <option value="{./@rdf:about}">
                          <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                        </option>
                      </xsl:if>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td>
            <label for="rdfs:comment">
              <i18n:text key="comment">Kommentar</i18n:text>
            </label>
          </td>
          <td>
            <textarea id="rdfs:comment" name="rdfs:comment" rows="6" cols="40">
              <xsl:value-of select="./c:resource/rdf:RDF/sub:Resource/rdfs:comment"/>
              <xsl:text> </xsl:text>
            </textarea>
          </td>
        </tr>

        <tr>
          <td>
            <label for="wdr:describedBy">
              <i18n:text key="status">Status</i18n:text>
            </label>
          </td>
          <td>
            <xsl:choose>

              <xsl:when test="not(/c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/wdr:describedBy/@rdf:resource)">
                <select id="wdr:describedBy" name="wdr:describedBy">

                  <xsl:for-each select="./c:statuses/rdf:RDF/wdr:DR">
                    <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>

                    <xsl:choose>

                      <xsl:when test="./@rdf:about = 'http://sublima.computas.com/status/inaktiv'">
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}" selected="selected">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:when>

                      <xsl:otherwise>
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:otherwise>

                    </xsl:choose>

                  </xsl:for-each>

                </select>

              </xsl:when>

              <xsl:otherwise>

                <select id="wdr:describedBy" name="wdr:describedBy">

                  <xsl:for-each select="./c:statuses/rdf:RDF/wdr:DR">
                    <xsl:sort lang="{$interface-language}" select="./rdfs:label"/>

                    <xsl:choose>

                      <xsl:when
                              test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/wdr:describedBy/@rdf:resource">
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}" selected="selected">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:when>

                      <xsl:otherwise>
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:otherwise>

                    </xsl:choose>

                  </xsl:for-each>

                </select>

              </xsl:otherwise>

            </xsl:choose>

          </td>
        </tr>

        <tr>
          <td>

          </td>
        </tr>
        <tr>
          <td>
            <i18n:text key="resource.usercomments">Brukernes kommentarer</i18n:text>
          </td>
          <td>
            <ul>
              <xsl:for-each select="./c:resource/rdf:RDF/sub:Resource/sub:comment/sioc:Item">
                <li>
                  <xsl:value-of select="./sioc:content"/>
                  <xsl:text> - </xsl:text>
                  <a href="{./sioc:has_creator/sioc:User/sioc:email/@rdf:resource}">
                    <xsl:value-of
                            select="substring-after(./sioc:has_creator/sioc:User/sioc:email/@rdf:resource, 'mailto:')"/>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
          </td>
        </tr>
        <xsl:if test="./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource">
          <tr>
            <td>
              <i18n:text key="resourceasnew">Marker som ny</i18n:text>
            </td>
            <td>
              <input type="checkbox" name="markasnew"/>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td colspan="2">

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


  <xsl:template match="c:resourcedetails" mode="temp">

    <xsl:call-template name="selectmultiple">
      <xsl:with-param name="selectionid">#subject</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="selectmultiple">
      <xsl:with-param name="selectionid">#language</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="selectmultiple">
      <xsl:with-param name="selectionid">#format</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="selectmultiple">
      <xsl:with-param name="selectionid">#audience</xsl:with-param>
    </xsl:call-template>

    <form action="{$baseurl}/admin/ressurser/ny" method="POST">
      <input type="hidden" name="prefix" value="skos: &lt;http://www.w3.org/2004/02/skos/core#&gt;"/>
      <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
      <input type="hidden" name="prefix" value="wdr: &lt;http://www.w3.org/2007/05/powder#&gt;"/>
      <input type="hidden" name="prefix" value="lingvoj: &lt;http://www.lingvoj.org/ontology#&gt;"/>
      <input type="hidden" name="prefix" value="dct: &lt;http://purl.org/dc/terms/&gt;"/>
      <input type="hidden" name="prefix" value="rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;"/>
      <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
      <input type="hidden" name="rdf:type" value="http://xmlns.computas.com/sublima#Resource"/>
      <input type="hidden" name="dct:dateAccepted" value="{./c:resource/rdf:RDF/sub:Resource/dct:dateAccepted}"/>
      <input type="hidden" id="dct:identifier" name="dct:identifier"
             value="{./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource}"/>
      <input type="hidden" name="interface-language" value="{$interface-language}"/>
      <xsl:call-template name="hidden-locale-field"/>

      <table>
        <tr>
          <td>
            <label for="dct:title">
              <i18n:text key="title">Tittel</i18n:text>
            </label>
          </td>
          <td>
            <input id="dct:title" type="text" name="dct:title" size="40"
                   value="{./c:resource/rdf:RDF/sub:Resource/dct:title}"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="the-resource">
              <i18n:text key="url">URL</i18n:text>
            </label>
          </td>
          <td>
            <input id="the-resource" type="text" name="the-resource" size="40"
                   value="{./c:resource/rdf:RDF/sub:Resource/sub:url/@rdf:resource}"/>
          </td>
        </tr>
        <tr>
          <td>
            <label for="dct:description">
              <i18n:text key="description">Beskrivelse</i18n:text>
            </label>
          </td>
          <td>
            <textarea id="dct:description" name="dct:description" rows="6" cols="40">
              <xsl:value-of select="./c:resource/rdf:RDF/sub:Resource/dct:description"/>
              <xsl:text> </xsl:text>
            </textarea>
          </td>
        </tr>
        <tr>
          <td>
            <label for="dct:publisher/foaf:Agent/@rdf:about">
              <i18n:text key="publisher">Utgiver</i18n:text>
            </label>
          </td>
          <td>
            <select id="dct:publisher" name="dct:publisher">
              <option value=""/>
              <xsl:for-each select="./c:publishers/rdf:RDF/foaf:Agent">
                <xsl:sort lang="{$interface-language}" select="./foaf:name"/>
                <xsl:choose>
                  <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:publisher/@rdf:resource">
                    <xsl:if test="./foaf:name">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./foaf:name"/>
                      </option>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="./foaf:name">
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./foaf:name"/>
                      </option>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td>
            <label for="language">
              <i18n:text key="language">Språk</i18n:text>
            </label>
          </td>
          <td>
            <select id="language" name="dct:language" multiple="multiple" size="10">
              <xsl:for-each select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo">
                <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                <xsl:choose>
                  <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:language/@rdf:resource">
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td>
            <label for="format">
              <i18n:text key="mediatype">Mediatype</i18n:text>
            </label>
          </td>
          <td>
            <select id="format" name="dct:format" multiple="multiple" size="10">
              <xsl:for-each
                      select="./c:mediatypes/rdf:RDF/dct:MediaType">
                <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                <xsl:choose>
                  <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:format/@rdf:resource">
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td>
            <label for="audience">
              <i18n:text key="audience">Målgruppe</i18n:text>
            </label>
          </td>
          <td>
            <select id="audience" name="dct:audience" multiple="multiple" size="10">
              <xsl:for-each
                      select="./c:audiences/rdf:RDF/dct:AgentClass">
                <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                <xsl:choose>
                  <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:audience/@rdf:resource">
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td>
            <label for="subject">
              <i18n:text key="topics">Emner</i18n:text>
            </label>
          </td>
          <td>
            <select id="subject" name="dct:subject" multiple="multiple" size="10">
              <xsl:for-each select="./c:topics/rdf:RDF/skos:Concept">
                <xsl:sort lang="{$interface-language}" select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                <xsl:choose>
                  <xsl:when test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:subject/@rdf:resource">
                    <xsl:if test="./skos:prefLabel[@xml:lang=$interface-language]">
                      <xsl:if test="./wdr:describedBy/@rdf:resource = 'http://sublima.computas.com/status/godkjent_av_administrator'">
                        <option value="{./@rdf:about}" selected="selected">
                          <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                        </option>
                      </xsl:if>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="./skos:prefLabel[@xml:lang=$interface-language]">
                      <xsl:if test="./wdr:describedBy/@rdf:resource = 'http://sublima.computas.com/status/godkjent_av_administrator'">
                        <option value="{./@rdf:about}">
                          <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                        </option>
                      </xsl:if>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </select>
          </td>
        </tr>
        <tr>
          <td>
            <label for="rdfs:comment">
              <i18n:text key="comment">Kommentar</i18n:text>
            </label>
          </td>
          <td>
            <textarea id="rdfs:comment" name="rdfs:comment" rows="6" cols="40">
              <xsl:value-of select="./c:resource/rdf:RDF/sub:Resource/rdfs:comment"/>
              <xsl:text> </xsl:text>
            </textarea>
          </td>
        </tr>

        <tr>
          <td>
            <label for="wdr:describedBy">
              <i18n:text key="status">Status</i18n:text>
            </label>
          </td>
          <td>
            <xsl:choose>

              <xsl:when test="not(/c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/wdr:describedBy/@rdf:resource)">
                <select id="wdr:describedBy" name="wdr:describedBy">

                  <xsl:for-each select="./c:statuses/rdf:RDF/wdr:DR">
                    <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>

                    <xsl:choose>

                      <xsl:when test="./@rdf:about = 'http://sublima.computas.com/status/inaktiv'">
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}" selected="selected">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:when>

                      <xsl:otherwise>
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:otherwise>

                    </xsl:choose>

                  </xsl:for-each>

                </select>

              </xsl:when>

              <xsl:otherwise>

                <select id="wdr:describedBy" name="wdr:describedBy">

                  <xsl:for-each select="./c:statuses/rdf:RDF/wdr:DR">
                    <xsl:sort lang="{$interface-language}" select="./rdfs:label"/>

                    <xsl:choose>

                      <xsl:when
                              test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/wdr:describedBy/@rdf:resource">
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}" selected="selected">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:when>

                      <xsl:otherwise>
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:otherwise>

                    </xsl:choose>

                  </xsl:for-each>

                </select>

              </xsl:otherwise>

            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td>

          </td>
        </tr>
        <tr>
          <td>
            <i18n:text key="resource.usercomments">Brukernes kommentarer</i18n:text>
          </td>
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
        <xsl:if test="not(./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource)">
          <tr>
            <td>
              <i18n:text key="resourceasnew">Marker som ny</i18n:text>
            </td>
            <td>
              <input type="checkbox" name="markasnew"/>
            </td>
          </tr>
        </xsl:if>
        <tr>
          <td colspan="2">

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

</xsl:stylesheet>