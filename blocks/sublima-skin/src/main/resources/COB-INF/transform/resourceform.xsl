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
        xmlns:url="http://whatever/java/java.net.URLDecoder"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="url"
        version="1.0">

  <xsl:import href="controlbutton.xsl"/>
  <xsl:import href="labels.xsl"/>
  <xsl:import href="selectmultiple.xsl"/>

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
      <input type="hidden" name="sub:committer" value="{./c:resource/rdf:RDF/sub:Resource/sub:committer/@rdf:resource}"/>
      <input type="hidden" name="dct:dateSubmitted" value="{./c:resource/rdf:RDF/sub:Resource/dct:dateSubmitted}"/>
      <input type="hidden" name="sub:lastApprovedBy" value="{./c:resource/rdf:RDF/sub:Resource/sub:lastApprovedBy/@rdf:resource}"/>
      <input type="hidden" name="dct:dateAccepted" value="{./c:resource/rdf:RDF/sub:Resource/dct:dateAccepted}"/>
      <input type="hidden" id="dct:identifier" name="dct:identifier" value="{./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource}"/>
      <input type="hidden" name="interface-language" value="{$interface-language}"/>
      <xsl:call-template name="hidden-locale-field"/>

      <table>
        <xsl:if test="./c:resource/rdf:RDF/sub:Resource/sub:committer/@rdf:resource">
          <tr>
            <td>
                <i18n:text key="registeredby">Registrert av</i18n:text>
            </td>
            <td>
                <xsl:for-each select="./c:users/rdf:RDF/sioc:User">
                  <xsl:if test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/sub:committer/@rdf:resource">
                    <xsl:value-of select="./rdfs:label"/>
                  </xsl:if>
                </xsl:for-each>
            </td>
          </tr>
          <tr>
            <td>
                <i18n:text key="date">Dato</i18n:text>
            </td>
            <td>
              <xsl:value-of select="substring-before(./c:resource/rdf:RDF/sub:Resource/dct:dateSubmitted, 'T')"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="./c:resource/rdf:RDF/sub:Resource/sub:lastApprovedBy/@rdf:resource">
          <tr>
            <td>
                <i18n:text key="lastapprovedby">Sist godkjent av</i18n:text>
            </td>
            <td>
                <xsl:for-each select="./c:users/rdf:RDF/sioc:User">
                  <xsl:if test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/sub:lastApprovedBy/@rdf:resource">
                    <xsl:value-of select="./rdfs:label"/>
                  </xsl:if>
                </xsl:for-each>
            </td>
          </tr>
          <tr>
            <td>
                <i18n:text key="date">Dato</i18n:text>
            </td>
            <td>
              <xsl:value-of select="substring-before(./c:resource/rdf:RDF/sub:Resource/dct:dateAccepted, 'T')"/>
            </td>
          </tr>
        </xsl:if>
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
                   value="{url:decode(./c:resource/rdf:RDF/sub:Resource/sub:url/@rdf:resource)}"/>
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

          <xsl:call-template name="selectmultiple">
            <xsl:with-param name="selectionid">#dctpublisher</xsl:with-param>
            <xsl:with-param name="tempid">#temppublisher</xsl:with-param>
            <xsl:with-param name="position">publisher</xsl:with-param>
          </xsl:call-template>

          <select class="selectmultiple" id="temppublisher" multiple="multiple">
            <xsl:for-each select="./c:publishers/rdf:RDF/foaf:Agent">
              <xsl:sort lang="{$interface-language}" select="./foaf:name"/>
              <xsl:if test="not(./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:publisher/@rdf:resource)">
                <xsl:if test="./foaf:name">
                  <option value="{./@rdf:about}">
                    <xsl:value-of select="./foaf:name"/>
                  </option>
                </xsl:if>
              </xsl:if>
            </xsl:for-each>
          </select>
          <a href="#" id="addpublisher" class="selectmultiplebutton"><i18n:text key="add">add</i18n:text> &gt;&gt;</a>
        </td>
          <td>
            <select name="dct:publisher" class="selectmultiple" multiple="multiple" id="dctpublisher">
              <option/>
              <xsl:for-each select="./c:publishers/rdf:RDF/foaf:Agent">
                <xsl:sort lang="{$interface-language}" select="./foaf:name[@xml:lang=$interface-language]"/>
                <xsl:if test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:publisher/@rdf:resource">
                  <xsl:if test="./foaf:name[@xml:lang=$interface-language]">
                    <option value="{./@rdf:about}" selected="selected">
                      <xsl:value-of select="./foaf:name[@xml:lang=$interface-language]"/>
                    </option>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
            </select>
            <a href="#" id="removepublisher" class="selectmultiplebutton">&lt;&lt; <i18n:text key="remove">remove</i18n:text></a>
          </td>

        </tr>
        <tr>
          <td>
            <label for="language">
              <i18n:text key="language">Språk</i18n:text>
            </label>
          </td>


          <td>

          <xsl:call-template name="selectmultiple">
            <xsl:with-param name="selectionid">#dctlanguage</xsl:with-param>
            <xsl:with-param name="tempid">#templanguage</xsl:with-param>
            <xsl:with-param name="position">language</xsl:with-param>
          </xsl:call-template>

          <select class="selectmultiple" id="templanguage" multiple="multiple">
            <xsl:for-each select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo">
              <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
              <xsl:if test="not(./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:language/@rdf:resource)">
                <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                  <option value="{./@rdf:about}">
                    <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                  </option>
                </xsl:if>
              </xsl:if>
            </xsl:for-each>
          </select>
          <a href="#" id="addlanguage" class="selectmultiplebutton"><i18n:text key="add">add</i18n:text> &gt;&gt;</a>
        </td>
          <td>
            <select name="dct:language" class="selectmultiple" multiple="multiple" id="dctlanguage">
              <option/>
              <xsl:for-each select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo">
                <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                <xsl:if test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:language/@rdf:resource">
                  <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                    <option value="{./@rdf:about}" selected="selected">
                      <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                    </option>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
            </select>
            <a href="#" id="removelanguage" class="selectmultiplebutton">&lt;&lt; <i18n:text key="remove">remove</i18n:text></a>
          </td>
        </tr>
        <tr>
          <td>
            <label for="format">
              <i18n:text key="mediatype">Mediatype</i18n:text>
            </label>
          </td>


          <td>

            <xsl:call-template name="selectmultiple">
              <xsl:with-param name="selectionid">#dctformat</xsl:with-param>
              <xsl:with-param name="tempid">#tempformat</xsl:with-param>
              <xsl:with-param name="position">format</xsl:with-param>
            </xsl:call-template>

            <select class="selectmultiple" id="tempformat" multiple="multiple">
              <xsl:for-each select="./c:mediatypes/rdf:RDF/dct:MediaType">
                <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                <xsl:if test="not(./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:type/@rdf:resource)">
                  <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                    <option value="{./@rdf:about}">
                      <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                    </option>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
            </select>
            <a href="#" id="addformat" class="selectmultiplebutton"><i18n:text key="add">add</i18n:text> &gt;&gt;</a>
          </td>
          <td>
            <select name="dct:type" class="selectmultiple" multiple="multiple" id="dctformat">
              <option/>
              <xsl:for-each select="./c:mediatypes/rdf:RDF/dct:MediaType">
                <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                <xsl:if test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:type/@rdf:resource">
                  <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                    <option value="{./@rdf:about}" selected="selected">
                      <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                    </option>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
            </select>
            <a href="#" id="removeformat" class="selectmultiplebutton">&lt;&lt; <i18n:text key="remove">remove</i18n:text></a>
          </td>


        </tr>
        <tr>
          <td>
            <label for="audience">
              <i18n:text key="audience">Målgruppe</i18n:text>
            </label>
          </td>

          <td>

            <xsl:call-template name="selectmultiple">
              <xsl:with-param name="selectionid">#dctaudience</xsl:with-param>
              <xsl:with-param name="tempid">#tempaudience</xsl:with-param>
              <xsl:with-param name="position">audience</xsl:with-param>
            </xsl:call-template>

            <select class="selectmultiple" id="tempaudience" multiple="multiple">
              <xsl:for-each select="./c:audiences/rdf:RDF/dct:AgentClass">
                <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                <xsl:if test="not(./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:audience/@rdf:resource)">
                  <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                    <option value="{./@rdf:about}">
                      <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                    </option>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
            </select>
            <a href="#" id="addaudience" class="selectmultiplebutton"><i18n:text key="add">add</i18n:text> &gt;&gt;</a>
          </td>
          <td>
            <select name="dct:audience" class="selectmultiple" multiple="multiple" id="dctaudience">
              <option/>
              <xsl:for-each select="./c:audiences/rdf:RDF/dct:AgentClass">
                <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                <xsl:if test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:audience/@rdf:resource">
                  <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                    <option value="{./@rdf:about}" selected="selected">
                      <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                    </option>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
            </select>
            <a href="#" id="removeaudience" class="selectmultiplebutton">&lt;&lt; <i18n:text key="remove">remove</i18n:text></a>
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
            <label for="dctsubject">
              <i18n:text key="topics">Emner</i18n:text>
            </label>
          </td>

          <td>

            <xsl:call-template name="selectmultiple">
              <xsl:with-param name="selectionid">#dctsubject</xsl:with-param>
              <xsl:with-param name="tempid">#tempsubject</xsl:with-param>
              <xsl:with-param name="position">subject</xsl:with-param>
            </xsl:call-template>

            <select class="selectmultiple" id="tempsubject" multiple="multiple">
              <xsl:for-each select="./c:topics/rdf:RDF/skos:Concept">
                <xsl:sort lang="{$interface-language}" select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                <xsl:if test="not(./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:subject/@rdf:resource)">
                  <xsl:if test="./skos:prefLabel[@xml:lang=$interface-language]">
                    <option value="{./@rdf:about}">
                      <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                    </option>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
            </select>
            <a href="#" id="addsubject" class="selectmultiplebutton"><i18n:text key="add">add</i18n:text> &gt;&gt;</a>
          </td>
          <td>
            <select name="dct:subject" class="selectmultiple" multiple="multiple" id="dctsubject">
              <option/>
              <xsl:for-each select="./c:topics/rdf:RDF/skos:Concept">
                <xsl:sort lang="{$interface-language}" select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                <xsl:if test="./@rdf:about = /c:page/c:content/c:resourcedetails/c:resource/rdf:RDF/sub:Resource/dct:subject/@rdf:resource">
                  <xsl:if test="./skos:prefLabel[@xml:lang=$interface-language]">
                    <option value="{./@rdf:about}" selected="selected">
                      <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                    </option>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
            </select>
            <a href="#" id="removesubject" class="selectmultiplebutton">&lt;&lt; <i18n:text key="remove">remove</i18n:text></a>
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

                      <xsl:when test="./@rdf:about = 'http://sublima.computas.com/status/under_behandling'">
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
                  <a href="mailto:{./sioc:has_creator}">
                    <xsl:value-of select="./sioc:has_creator"/>
                  </a>
                  <i18n:text> - </i18n:text><a href="{$baseurl}/admin/ressurser/kommentarer/slett?uri={./@rdf:about}"><i18n:text key="delete">Slett</i18n:text></a>
                </li>
              </xsl:for-each>
            </ul>
          </td>
        </tr>
        <xsl:if test="./c:resource/rdf:RDF/sub:Resource/dct:identifier/@rdf:resource">
          <tr id="markasnew">
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
                document.getElementById("markasnew").style.visibility = "hidden";
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